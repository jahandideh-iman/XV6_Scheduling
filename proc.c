#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"
#include <time.h>


struct {
	struct spinlock lock;
	struct proc proc[NPROC];
} ptable;

struct processQueue{
	struct proc* proc[QUEUE_CAPACITY];
	int head;
	int tail;
	int size;
	int priority;
};


struct processQueue priorityTable[PRIORITYLEVELS] ;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void pinit(void) {
	initlock(&ptable.lock, "ptable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void) {
	struct proc *p;
	char *sp;


	acquire(&ptable.lock);
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
		if (p->state == UNUSED)
			goto found;
	release(&ptable.lock);
	return 0;

	found: p->state = EMBRYO;
	p->pid = nextpid++;

	release(&ptable.lock);

	// Allocate kernel stack.
	if ((p->kstack = kalloc()) == 0) {
		p->state = UNUSED;
		return 0;
	}
	sp = p->kstack + KSTACKSIZE;

	// Leave room for trap frame.
	sp -= sizeof *p->tf;
	p->tf = (struct trapframe*) sp;

	// Set up new context to start executing at forkret,
	// which returns to trapret.
	sp -= 4;
	*(uint*) sp = (uint) trapret;

	sp -= sizeof *p->context;
	p->context = (struct context*) sp;
	memset(p->context, 0, sizeof *p->context);
	p->context->eip = (uint) forkret;

	return p;
}

//PAGEBREAK: 32
// Set up first user process.
void userinit(void) {
	struct proc *p;
	extern char _binary_initcode_start[], _binary_initcode_size[];

	p = allocproc();

	initproc = p;
	if ((p->pgdir = setupkvm()) == 0)
		panic("userinit: out of memory?");
	inituvm(p->pgdir, _binary_initcode_start, (int) _binary_initcode_size);
	p->sz = PGSIZE;
	memset(p->tf, 0, sizeof(*p->tf));
	p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
	p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
	p->tf->es = p->tf->ds;
	p->tf->ss = p->tf->ds;
	p->tf->eflags = FL_IF;
	p->tf->esp = PGSIZE;
	p->tf->eip = 0; // beginning of initcode.S

	safestrcpy(p->name, "initcode", sizeof(p->name));
	p->cwd = namei("/");


	p->parent=0;
	setpriority(p,0);
	SetProcessRunnable(p);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int growproc(int n) {
	uint sz;

	sz = proc->sz;
	if (n > 0) {
		if ((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
			return -1;
	} else if (n < 0) {
		if ((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
			return -1;
	}
	proc->sz = sz;
	switchuvm(proc);
	return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int fork(void) {

	int i, pid;
	struct proc *np;

	// Allocate process.
	if ((np = allocproc()) == 0)
		return -1;

	// Copy process state from p.
	if ((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0) {
		kfree(np->kstack);
		np->kstack = 0;
		np->state = UNUSED;
		return -1;
	}
	np->sz = proc->sz;
	np->parent = proc;
	*np->tf = *proc->tf;

	// Clear %eax so that fork returns 0 in the child.
	np->tf->eax = 0;

	for (i = 0; i < NOFILE; i++)
		if (proc->ofile[i])
			np->ofile[i] = filedup(proc->ofile[i]);
	np->cwd = idup(proc->cwd);


	pid = np->pid;

	setpriority(np,np->parent->priority);
	SetProcessRunnable(np);
	safestrcpy(np->name, proc->name, sizeof(proc->name));

	return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void exit(void) {
	struct proc *p;
	int fd;

	if (proc == initproc)
		panic("init exiting");

	// Close all open files.
	for (fd = 0; fd < NOFILE; fd++) {
		if (proc->ofile[fd]) {
			fileclose(proc->ofile[fd]);
			proc->ofile[fd] = 0;
		}
	}

	iput(proc->cwd);
	proc->cwd = 0;

	acquire(&ptable.lock);

	// Parent might be sleeping in wait().
	wakeup1(proc->parent);

	// Pass abandoned children to init.
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if (p->parent == proc) {
			p->parent = initproc;
			if (p->state == ZOMBIE)
				wakeup1(initproc);
		}
	}

	// Jump into the scheduler, never to return.
	proc->state = ZOMBIE;
	sched();
	panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int wait(void) {
	struct proc *p;
	int havekids, pid;

	acquire(&ptable.lock);
	for (;;) {
		// Scan through table looking for zombie children.
		havekids = 0;
		for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
			if (p->parent != proc)
				continue;
			havekids = 1;
			if (p->state == ZOMBIE) {
				// Found one.
				pid = p->pid;
				kfree(p->kstack);
				p->kstack = 0;
				freevm(p->pgdir);
				p->state = UNUSED;
				p->pid = 0;
				p->parent = 0;
				p->name[0] = 0;
				p->killed = 0;
				release(&ptable.lock);
				return pid;
			}
		}

		// No point waiting if we don't have any children.
		if (!havekids || proc->killed) {
			release(&ptable.lock);
			return -1;
		}

		// Wait for children to exit.  (See wakeup1 call in proc_exit.)
		sleep(proc, &ptable.lock); //DOC: wait-sleep
	}
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void scheduler(void) {

	struct proc *p;
	int priority = 0;

	for (;;) {
		// Enable interrupts on this processor.
		sti();
		acquire(&ptable.lock);
		checkqueuefornonrunnable();

		p = GetNextRunnableProcess(priority);

		if( p != 0)
		{
			cprintf("cpu : %d |selected process:%d |priority:%d \n",cpu->id,p->pid,p->priority);
			SwitchToProccess(p);

			if(IsThereANoneEmptyHigherLevelPriorityTable(priority))
				priority= 0; // Start from the highest priority
		}
		else// the current priority Table is empty
			priority = (priority+1)%PRIORITYLEVELS;
		release(&ptable.lock);
	}
}


// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void sched(void) {
	int intena;

	if (!holding(&ptable.lock))
		panic("sched ptable.lock");
	if (cpu->ncli != 1)
		panic("sched locks");
	if (proc->state == RUNNING)
		panic("sched running");
	if (readeflags() & FL_IF)
		panic("sched interruptible");
	intena = cpu->intena;
	swtch(&proc->context, cpu->scheduler);
	cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void yield(void) {
	acquire(&ptable.lock); //DOC: yieldlock
	SetProcessRunnable(proc);
	sched();
	release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void) {
	static int first = 1;
	// Still holding ptable.lock from scheduler.
	release(&ptable.lock);

	if (first) {
		// Some initialization functions must be run in the context
		// of a regular process (e.g., they call sleep), and thus cannot
		// be run from main().
		first = 0;
		initlog();
	}

	// Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk) {
	if (proc == 0)
		panic("sleep");

	if (lk == 0)
		panic("sleep without lk");

	// Must acquire ptable.lock in order to
	// change p->state and then call sched.
	// Once we hold ptable.lock, we can be
	// guaranteed that we won't miss any wakeup
	// (wakeup runs with ptable.lock locked),
	// so it's okay to release lk.
	if (lk != &ptable.lock) { //DOC: sleeplock0
		acquire(&ptable.lock); //DOC: sleeplock1
		release(lk);
	}

	// Go to sleep.
	proc->chan = chan;
	proc->state = SLEEPING;
	sched();

	// Tidy up.
	proc->chan = 0;

	// Reacquire original lock.
	if (lk != &ptable.lock) { //DOC: sleeplock2
		release(&ptable.lock);
		acquire(lk);
	}
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void wakeup1(void *chan) {
	struct proc *p;

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
		if (p->state == SLEEPING && p->chan == chan)
			SetProcessRunnable(p);
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan) {
	acquire(&ptable.lock);
	wakeup1(chan);
	release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid) {
	struct proc *p;

	acquire(&ptable.lock);
	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if (p->pid == pid) {
			p->killed = 1;
			// Wake process from sleep if necessary.
			if (p->state == SLEEPING)
				SetProcessRunnable(p);
			release(&ptable.lock);
			return 0;
		}
	}
	release(&ptable.lock);
	return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void) {
	static char *states[] = { [UNUSED] "unused", [EMBRYO] "embryo", [SLEEPING
			] "sleep ", [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE
			] "zombie" };
	int i;
	struct proc *p;
	char *state;
	uint pc[10];

	for (p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if (p->state == UNUSED)
			continue;
		if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
			state = states[p->state];
		else
			state = "???";
		cprintf("%d %s %s ###", p->pid, state, p->name);
		if (p->state == SLEEPING) {
			getcallerpcs((uint*) p->context->ebp + 2, pc);
			for (i = 0; i < 10 && pc[i] != 0; i++)
				cprintf(" %p ###", pc[i]);
		}
		cprintf("\n");
	}
}
void printprocesslist(void) {
	int i = 0;
	for (; i < NPROC; i++) {
		if (ptable.proc[i].state != UNUSED) {
			cprintf("process name : %s and pid : %d \n", ptable.proc[i].name,
					ptable.proc[i].pid);
		}
	}
}

int ps(void) {
	static char *states[] = { [UNUSED] "unused", [EMBRYO] "embryo", [SLEEPING
			] "sleep ", [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE
			] "zombie" };

	cprintf("------------------ \n");
	showprocessqueuestable();
	return 1;
	int i;
	for(i=0;i<NPROC;i++)
	{
		if(ptable.proc[i].state!=UNUSED)
		{
			cprintf("pid:%d | name:%s | priority:%d | state:%s|parent:%d \n"
					,ptable.proc[i].pid
					,ptable.proc[i].name
					,ptable.proc[i].priority
					,states[ptable.proc[i].state]
					,ptable.proc[i].parent->pid);

		}
	}
	return 0;
}

void SwitchToProccess(struct proc* process)
{
	proc = process;
	switchuvm(process);
	process->state = RUNNING;
	swtch(&cpu->scheduler, proc->context);
	switchkvm();

	// Process is done running for now.
	// It should have changed its p->state before coming back.
	proc = 0;
}

void InitialPriorityTables()
{
	int i;
	for(i = 0 ; i< PRIORITYLEVELS;i++)
	{
		priorityTable[i].head = 0;
		priorityTable[i].tail = 0;
		priorityTable[i].size=0;
		priorityTable[i].priority = i;
	}
}

void SetProcessRunnable(struct proc* process)
{
	process->state=RUNNABLE;
	InsertToPriorityTable(process->priority,process);
	//ps();
}

int InsertToPriorityTable(int priority,struct proc* process)
{
	return EnqueueProcess(&priorityTable[priority],process);
}

struct proc* GetNextRunnableProcess(int priority)
{
	return DequeueProcess(&priorityTable[priority]);
}

bool IsThereANoneEmptyHigherLevelPriorityTable(int currentPriority)
{
	int i;
	for(i = 0 ; i< currentPriority ; i++)
	{
		if(!IsPriorityTableEmpty(i))
			return true;
	}
	return false;
}

bool IsPriorityTableEmpty(int priority)
{
	return (IsQueueEmpty(&priorityTable[priority]));
}

/****************************** QUEUE ******************************/
int EnqueueProcess(struct processQueue* queue, struct proc* process )
{
	if(!IsQueueFull(queue))
	{
		if(queue!=0)
		{
			queue->proc[queue->tail]=process;
			queue->tail=(queue->tail+1)%QUEUE_CAPACITY;
			queue->size=(queue->size)+1;
			return 0;
		}

	}
	return -1;
}

struct proc* DequeueProcess(struct processQueue* queue)
{
	if(!IsQueueEmpty(queue))
	{
		struct proc* p = queue->proc[queue->head];
		queue->head= (queue->head+1)%QUEUE_CAPACITY;
		queue->size=queue->size-1;
		return p;
		
	}
	return 0;
}

bool IsQueueFull(struct processQueue* queue)
{

	return (queue->size>=QUEUE_CAPACITY);
		
}

bool IsQueueEmpty(struct processQueue* queue)
{
	//if tail is pointing to the next of head
	//return ((queue.head++)%QUEUE_CAPACITY == queue.tail);
	return (queue->size<=0);
	
}

/****************************** /QUEUE ******************************/

int setprioritybypid(int pid,int priority)
{
	if(!(priority>=0 && priority<PRIORITYLEVELS))
		return -1;

	struct proc* foundprocess;
	foundprocess=findprocesswithpid(pid);
	//cprintf("**********************foundprocess priority:%d\n",foundprocess->priority);
	if(foundprocess!=0)
	{
		if(foundprocess->parent!=0&&priority>=foundprocess->parent->priority)
		{
			setpriority(foundprocess,priority);
			return 0;
		}
	}
	return -1;
}

void setpriority(struct proc* process,int newpriority)
{

	if(!(newpriority>=0&&newpriority<PRIORITYLEVELS))
		return ;
	int diff=newpriority-process->priority;
	int oldpriority=process->priority;
	process->priority=newpriority;

	moveToNewQueue(process,newpriority,oldpriority);

	setpriorityforchildren(process->pid,diff);
}


struct proc* findprocesswithpid(int pid)
{
	int i;
	//cprintf("findprocess with pid functoin : %d \n",pid);
	//ps();
	for(i=0;i<NPROC;i++)
	{
		if(ptable.proc[i].state!=UNUSED)
		{
			if(ptable.proc[i].pid==pid)
				return &ptable.proc[i];
		}
	}
	return 0;
}
int findprocessinqueuewithpid(struct processQueue* queue,int pid)
{
	int j;
	for(j=queue->head;j!=queue->tail;j=(j+1)%QUEUE_CAPACITY)
	{
		if(queue->proc[j]->pid==pid)
		{
			return j;
		}
	}
	return -1;

}

void setpriorityforchildren(int parentpid,int diff)
{
	int i;

	for(i=0;i<NPROC;i++)
	{
		if(ptable.proc[i].parent!=0 && ptable.proc[i].parent->pid==parentpid)
			setpriority(&ptable.proc[i],diff+ptable.proc[i].priority);
	}
}

void setpriorityinqueueforchildren(struct processQueue* queue,int parentpid,int diff)
{
	int i;
	struct proc* childprocess;
	cprintf("Queue size is %d\n", queue->size);
	for(i=queue->head;i!=queue->tail;i=(i+1)%QUEUE_CAPACITY)
	{
		cprintf("!!!!!!!!\n");
		if(queue->proc[i]->parent->pid==parentpid)
		{

			childprocess=queue->proc[i];
			setpriority(childprocess,childprocess->priority+diff);
		}
	}

}

int nice(int value)
{
	int newpriority=proc->priority+value;
	if(newpriority>PRIORITYLEVELS||newpriority<0)
		return -1;
	if(proc->parent!=0&&newpriority>=proc->parent->priority)
	{
		setpriority(proc,newpriority);
		return 0;
	}

	return -1;

}

int clmap(int number,int down,int up)
{
	if(number<down)
		number=down;
	else if (number>up)
		number=up;
	return number;

}

int getpriority(int pid)
{

	struct proc* process=findprocesswithpid(pid);
	//cprintf("pid:%d \n",process->pid);
	if(process==0)
		return -1;
	//cprintf("process found \n");
	return process->priority;
}

void removeitemfromqueue(struct processQueue* queue,int index)
{
	int i;
	for(i=index;i!=queue->tail;i=(i+1)%QUEUE_CAPACITY)
	{
		queue->proc[i]=queue->proc[i+1];
	}
	queue->tail=(queue->tail-1)%QUEUE_CAPACITY;
	queue->size-=1;
}

void moveToNewQueue(struct proc* process,int newpri,int oldpri)
{
	int index;
	index=findprocessinqueuewithpid(&priorityTable[oldpri],process->pid);
	if(index!=-1)
	{
		removeitemfromqueue(&priorityTable[oldpri],index);
		EnqueueProcess(&priorityTable[newpri],process);
	}
}

void checkqueuefornonrunnable()
{
	int i;
	int j;
	for(i = 0 ; i< PRIORITYLEVELS;i++)
	{
		for(j=priorityTable[i].head;j!=priorityTable[i].tail;)
		{
			if(priorityTable[i].proc[j]->state!=RUNNABLE)
				removeitemfromqueue(&priorityTable[i],j);
			else
				j=(j+1)%QUEUE_CAPACITY;
		}
	}
}


void showprocessqueuestable()
{
	/*static char *states[] = { [UNUSED] "unused", [EMBRYO] "embryo", [SLEEPING
				] "sleep ", [RUNNABLE] "runble", [RUNNING] "run   ", [ZOMBIE
				] "zombie" };
*/
	int i;
	int j;
	//char* wht="init";
	for(i = 0 ; i< PRIORITYLEVELS;i++)
	{
		cprintf("*****table %d******\n",i);
		for(j=priorityTable[i].head;j!=priorityTable[i].tail;j=(j+1)%QUEUE_CAPACITY)
		{
			if (priorityTable[i].proc[j]->parent!=0)
			{

				cprintf("pid:%d |name:%s|piority:%d|parent:%d\n",
						priorityTable[i].proc[j]->pid,
						priorityTable[i].proc[j]->name,
						priorityTable[i].proc[j]->priority,
						priorityTable[i].proc[j]->parent->pid);
			}
			else
			{
				cprintf("pid:%d |name:%s|piority:%d \n",
										priorityTable[i].proc[j]->pid,
										priorityTable[i].proc[j]->name,
										priorityTable[i].proc[j]->priority);

			}
		}
	}
}




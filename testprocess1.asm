
_testprocess1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork()==0)
   9:	e8 86 02 00 00       	call   294 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	75 18                	jne    2a <main+0x2a>
	  exec("testprocess2",argv);
  12:	8b 45 0c             	mov    0xc(%ebp),%eax
  15:	89 44 24 04          	mov    %eax,0x4(%esp)
  19:	c7 04 24 f7 07 00 00 	movl   $0x7f7,(%esp)
  20:	e8 af 02 00 00       	call   2d4 <exec>
	  while(1)
	  {

	  }
  }
  exit();
  25:	e8 72 02 00 00       	call   29c <exit>
{
  if(fork()==0)
	  exec("testprocess2",argv);
  else
  {
	  fork();
  2a:	e8 65 02 00 00       	call   294 <fork>
	  fork();
  2f:	e8 60 02 00 00       	call   294 <fork>
	  while(1)
	  {

	  }
  34:	eb fe                	jmp    34 <main+0x34>
  36:	90                   	nop
  37:	90                   	nop

00000038 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  38:	55                   	push   %ebp
  39:	89 e5                	mov    %esp,%ebp
  3b:	57                   	push   %edi
  3c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  40:	8b 55 10             	mov    0x10(%ebp),%edx
  43:	8b 45 0c             	mov    0xc(%ebp),%eax
  46:	89 cb                	mov    %ecx,%ebx
  48:	89 df                	mov    %ebx,%edi
  4a:	89 d1                	mov    %edx,%ecx
  4c:	fc                   	cld    
  4d:	f3 aa                	rep stos %al,%es:(%edi)
  4f:	89 ca                	mov    %ecx,%edx
  51:	89 fb                	mov    %edi,%ebx
  53:	89 5d 08             	mov    %ebx,0x8(%ebp)
  56:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  59:	5b                   	pop    %ebx
  5a:	5f                   	pop    %edi
  5b:	5d                   	pop    %ebp
  5c:	c3                   	ret    

0000005d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  5d:	55                   	push   %ebp
  5e:	89 e5                	mov    %esp,%ebp
  60:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  63:	8b 45 08             	mov    0x8(%ebp),%eax
  66:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  69:	90                   	nop
  6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  6d:	0f b6 10             	movzbl (%eax),%edx
  70:	8b 45 08             	mov    0x8(%ebp),%eax
  73:	88 10                	mov    %dl,(%eax)
  75:	8b 45 08             	mov    0x8(%ebp),%eax
  78:	0f b6 00             	movzbl (%eax),%eax
  7b:	84 c0                	test   %al,%al
  7d:	0f 95 c0             	setne  %al
  80:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  84:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  88:	84 c0                	test   %al,%al
  8a:	75 de                	jne    6a <strcpy+0xd>
    ;
  return os;
  8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8f:	c9                   	leave  
  90:	c3                   	ret    

00000091 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  94:	eb 08                	jmp    9e <strcmp+0xd>
    p++, q++;
  96:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  9a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	0f b6 00             	movzbl (%eax),%eax
  a4:	84 c0                	test   %al,%al
  a6:	74 10                	je     b8 <strcmp+0x27>
  a8:	8b 45 08             	mov    0x8(%ebp),%eax
  ab:	0f b6 10             	movzbl (%eax),%edx
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	0f b6 00             	movzbl (%eax),%eax
  b4:	38 c2                	cmp    %al,%dl
  b6:	74 de                	je     96 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  b8:	8b 45 08             	mov    0x8(%ebp),%eax
  bb:	0f b6 00             	movzbl (%eax),%eax
  be:	0f b6 d0             	movzbl %al,%edx
  c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  c4:	0f b6 00             	movzbl (%eax),%eax
  c7:	0f b6 c0             	movzbl %al,%eax
  ca:	89 d1                	mov    %edx,%ecx
  cc:	29 c1                	sub    %eax,%ecx
  ce:	89 c8                	mov    %ecx,%eax
}
  d0:	5d                   	pop    %ebp
  d1:	c3                   	ret    

000000d2 <strlen>:

uint
strlen(char *s)
{
  d2:	55                   	push   %ebp
  d3:	89 e5                	mov    %esp,%ebp
  d5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  df:	eb 04                	jmp    e5 <strlen+0x13>
  e1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  e8:	03 45 08             	add    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	84 c0                	test   %al,%al
  f0:	75 ef                	jne    e1 <strlen+0xf>
    ;
  return n;
  f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f5:	c9                   	leave  
  f6:	c3                   	ret    

000000f7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  fa:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  fd:	8b 45 10             	mov    0x10(%ebp),%eax
 100:	89 44 24 08          	mov    %eax,0x8(%esp)
 104:	8b 45 0c             	mov    0xc(%ebp),%eax
 107:	89 44 24 04          	mov    %eax,0x4(%esp)
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	89 04 24             	mov    %eax,(%esp)
 111:	e8 22 ff ff ff       	call   38 <stosb>
  return dst;
 116:	8b 45 08             	mov    0x8(%ebp),%eax
}
 119:	c9                   	leave  
 11a:	c3                   	ret    

0000011b <strchr>:

char*
strchr(const char *s, char c)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
 11e:	83 ec 04             	sub    $0x4,%esp
 121:	8b 45 0c             	mov    0xc(%ebp),%eax
 124:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 127:	eb 14                	jmp    13d <strchr+0x22>
    if(*s == c)
 129:	8b 45 08             	mov    0x8(%ebp),%eax
 12c:	0f b6 00             	movzbl (%eax),%eax
 12f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 132:	75 05                	jne    139 <strchr+0x1e>
      return (char*)s;
 134:	8b 45 08             	mov    0x8(%ebp),%eax
 137:	eb 13                	jmp    14c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 139:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 13d:	8b 45 08             	mov    0x8(%ebp),%eax
 140:	0f b6 00             	movzbl (%eax),%eax
 143:	84 c0                	test   %al,%al
 145:	75 e2                	jne    129 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 147:	b8 00 00 00 00       	mov    $0x0,%eax
}
 14c:	c9                   	leave  
 14d:	c3                   	ret    

0000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
 151:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 154:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 15b:	eb 44                	jmp    1a1 <gets+0x53>
    cc = read(0, &c, 1);
 15d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 164:	00 
 165:	8d 45 ef             	lea    -0x11(%ebp),%eax
 168:	89 44 24 04          	mov    %eax,0x4(%esp)
 16c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 173:	e8 3c 01 00 00       	call   2b4 <read>
 178:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 17b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 17f:	7e 2d                	jle    1ae <gets+0x60>
      break;
    buf[i++] = c;
 181:	8b 45 f4             	mov    -0xc(%ebp),%eax
 184:	03 45 08             	add    0x8(%ebp),%eax
 187:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 18b:	88 10                	mov    %dl,(%eax)
 18d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 191:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 195:	3c 0a                	cmp    $0xa,%al
 197:	74 16                	je     1af <gets+0x61>
 199:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 19d:	3c 0d                	cmp    $0xd,%al
 19f:	74 0e                	je     1af <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1aa:	7c b1                	jl     15d <gets+0xf>
 1ac:	eb 01                	jmp    1af <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1ae:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b2:	03 45 08             	add    0x8(%ebp),%eax
 1b5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1bb:	c9                   	leave  
 1bc:	c3                   	ret    

000001bd <stat>:

int
stat(char *n, struct stat *st)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ca:	00 
 1cb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ce:	89 04 24             	mov    %eax,(%esp)
 1d1:	e8 06 01 00 00       	call   2dc <open>
 1d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1dd:	79 07                	jns    1e6 <stat+0x29>
    return -1;
 1df:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1e4:	eb 23                	jmp    209 <stat+0x4c>
  r = fstat(fd, st);
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f0:	89 04 24             	mov    %eax,(%esp)
 1f3:	e8 fc 00 00 00       	call   2f4 <fstat>
 1f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fe:	89 04 24             	mov    %eax,(%esp)
 201:	e8 be 00 00 00       	call   2c4 <close>
  return r;
 206:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 209:	c9                   	leave  
 20a:	c3                   	ret    

0000020b <atoi>:

int
atoi(const char *s)
{
 20b:	55                   	push   %ebp
 20c:	89 e5                	mov    %esp,%ebp
 20e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 218:	eb 23                	jmp    23d <atoi+0x32>
    n = n*10 + *s++ - '0';
 21a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 21d:	89 d0                	mov    %edx,%eax
 21f:	c1 e0 02             	shl    $0x2,%eax
 222:	01 d0                	add    %edx,%eax
 224:	01 c0                	add    %eax,%eax
 226:	89 c2                	mov    %eax,%edx
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 00             	movzbl (%eax),%eax
 22e:	0f be c0             	movsbl %al,%eax
 231:	01 d0                	add    %edx,%eax
 233:	83 e8 30             	sub    $0x30,%eax
 236:	89 45 fc             	mov    %eax,-0x4(%ebp)
 239:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 23d:	8b 45 08             	mov    0x8(%ebp),%eax
 240:	0f b6 00             	movzbl (%eax),%eax
 243:	3c 2f                	cmp    $0x2f,%al
 245:	7e 0a                	jle    251 <atoi+0x46>
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	0f b6 00             	movzbl (%eax),%eax
 24d:	3c 39                	cmp    $0x39,%al
 24f:	7e c9                	jle    21a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 251:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 254:	c9                   	leave  
 255:	c3                   	ret    

00000256 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 256:	55                   	push   %ebp
 257:	89 e5                	mov    %esp,%ebp
 259:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 262:	8b 45 0c             	mov    0xc(%ebp),%eax
 265:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 268:	eb 13                	jmp    27d <memmove+0x27>
    *dst++ = *src++;
 26a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 26d:	0f b6 10             	movzbl (%eax),%edx
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
 273:	88 10                	mov    %dl,(%eax)
 275:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 279:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 27d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 281:	0f 9f c0             	setg   %al
 284:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 288:	84 c0                	test   %al,%al
 28a:	75 de                	jne    26a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28f:	c9                   	leave  
 290:	c3                   	ret    
 291:	90                   	nop
 292:	90                   	nop
 293:	90                   	nop

00000294 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 294:	b8 01 00 00 00       	mov    $0x1,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <exit>:
SYSCALL(exit)
 29c:	b8 02 00 00 00       	mov    $0x2,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <wait>:
SYSCALL(wait)
 2a4:	b8 03 00 00 00       	mov    $0x3,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <pipe>:
SYSCALL(pipe)
 2ac:	b8 04 00 00 00       	mov    $0x4,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <read>:
SYSCALL(read)
 2b4:	b8 05 00 00 00       	mov    $0x5,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <write>:
SYSCALL(write)
 2bc:	b8 10 00 00 00       	mov    $0x10,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <close>:
SYSCALL(close)
 2c4:	b8 15 00 00 00       	mov    $0x15,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <kill>:
SYSCALL(kill)
 2cc:	b8 06 00 00 00       	mov    $0x6,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <exec>:
SYSCALL(exec)
 2d4:	b8 07 00 00 00       	mov    $0x7,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <open>:
SYSCALL(open)
 2dc:	b8 0f 00 00 00       	mov    $0xf,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <mknod>:
SYSCALL(mknod)
 2e4:	b8 11 00 00 00       	mov    $0x11,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <unlink>:
SYSCALL(unlink)
 2ec:	b8 12 00 00 00       	mov    $0x12,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <fstat>:
SYSCALL(fstat)
 2f4:	b8 08 00 00 00       	mov    $0x8,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <link>:
SYSCALL(link)
 2fc:	b8 13 00 00 00       	mov    $0x13,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <mkdir>:
SYSCALL(mkdir)
 304:	b8 14 00 00 00       	mov    $0x14,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <chdir>:
SYSCALL(chdir)
 30c:	b8 09 00 00 00       	mov    $0x9,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <dup>:
SYSCALL(dup)
 314:	b8 0a 00 00 00       	mov    $0xa,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <getpid>:
SYSCALL(getpid)
 31c:	b8 0b 00 00 00       	mov    $0xb,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <sbrk>:
SYSCALL(sbrk)
 324:	b8 0c 00 00 00       	mov    $0xc,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <sleep>:
SYSCALL(sleep)
 32c:	b8 0d 00 00 00       	mov    $0xd,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <uptime>:
SYSCALL(uptime)
 334:	b8 0e 00 00 00       	mov    $0xe,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <ps>:
SYSCALL(ps)
 33c:	b8 16 00 00 00       	mov    $0x16,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <nice>:
SYSCALL(nice)
 344:	b8 19 00 00 00       	mov    $0x19,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <getpriority>:
SYSCALL(getpriority)
 34c:	b8 17 00 00 00       	mov    $0x17,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <setpriority>:
SYSCALL(setpriority)
 354:	b8 18 00 00 00       	mov    $0x18,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 28             	sub    $0x28,%esp
 362:	8b 45 0c             	mov    0xc(%ebp),%eax
 365:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 368:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 36f:	00 
 370:	8d 45 f4             	lea    -0xc(%ebp),%eax
 373:	89 44 24 04          	mov    %eax,0x4(%esp)
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	89 04 24             	mov    %eax,(%esp)
 37d:	e8 3a ff ff ff       	call   2bc <write>
}
 382:	c9                   	leave  
 383:	c3                   	ret    

00000384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 391:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 395:	74 17                	je     3ae <printint+0x2a>
 397:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39b:	79 11                	jns    3ae <printint+0x2a>
    neg = 1;
 39d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a7:	f7 d8                	neg    %eax
 3a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ac:	eb 06                	jmp    3b4 <printint+0x30>
  } else {
    x = xx;
 3ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3c1:	ba 00 00 00 00       	mov    $0x0,%edx
 3c6:	f7 f1                	div    %ecx
 3c8:	89 d0                	mov    %edx,%eax
 3ca:	0f b6 90 48 0a 00 00 	movzbl 0xa48(%eax),%edx
 3d1:	8d 45 dc             	lea    -0x24(%ebp),%eax
 3d4:	03 45 f4             	add    -0xc(%ebp),%eax
 3d7:	88 10                	mov    %dl,(%eax)
 3d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 3dd:	8b 55 10             	mov    0x10(%ebp),%edx
 3e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 3e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e6:	ba 00 00 00 00       	mov    $0x0,%edx
 3eb:	f7 75 d4             	divl   -0x2c(%ebp)
 3ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f5:	75 c4                	jne    3bb <printint+0x37>
  if(neg)
 3f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3fb:	74 2a                	je     427 <printint+0xa3>
    buf[i++] = '-';
 3fd:	8d 45 dc             	lea    -0x24(%ebp),%eax
 400:	03 45 f4             	add    -0xc(%ebp),%eax
 403:	c6 00 2d             	movb   $0x2d,(%eax)
 406:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 40a:	eb 1b                	jmp    427 <printint+0xa3>
    putc(fd, buf[i]);
 40c:	8d 45 dc             	lea    -0x24(%ebp),%eax
 40f:	03 45 f4             	add    -0xc(%ebp),%eax
 412:	0f b6 00             	movzbl (%eax),%eax
 415:	0f be c0             	movsbl %al,%eax
 418:	89 44 24 04          	mov    %eax,0x4(%esp)
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	89 04 24             	mov    %eax,(%esp)
 422:	e8 35 ff ff ff       	call   35c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 427:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 42b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 42f:	79 db                	jns    40c <printint+0x88>
    putc(fd, buf[i]);
}
 431:	c9                   	leave  
 432:	c3                   	ret    

00000433 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
 436:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 439:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 440:	8d 45 0c             	lea    0xc(%ebp),%eax
 443:	83 c0 04             	add    $0x4,%eax
 446:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 449:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 450:	e9 7d 01 00 00       	jmp    5d2 <printf+0x19f>
    c = fmt[i] & 0xff;
 455:	8b 55 0c             	mov    0xc(%ebp),%edx
 458:	8b 45 f0             	mov    -0x10(%ebp),%eax
 45b:	01 d0                	add    %edx,%eax
 45d:	0f b6 00             	movzbl (%eax),%eax
 460:	0f be c0             	movsbl %al,%eax
 463:	25 ff 00 00 00       	and    $0xff,%eax
 468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 46b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 46f:	75 2c                	jne    49d <printf+0x6a>
      if(c == '%'){
 471:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 475:	75 0c                	jne    483 <printf+0x50>
        state = '%';
 477:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 47e:	e9 4b 01 00 00       	jmp    5ce <printf+0x19b>
      } else {
        putc(fd, c);
 483:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 486:	0f be c0             	movsbl %al,%eax
 489:	89 44 24 04          	mov    %eax,0x4(%esp)
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	89 04 24             	mov    %eax,(%esp)
 493:	e8 c4 fe ff ff       	call   35c <putc>
 498:	e9 31 01 00 00       	jmp    5ce <printf+0x19b>
      }
    } else if(state == '%'){
 49d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a1:	0f 85 27 01 00 00    	jne    5ce <printf+0x19b>
      if(c == 'd'){
 4a7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4ab:	75 2d                	jne    4da <printf+0xa7>
        printint(fd, *ap, 10, 1);
 4ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b0:	8b 00                	mov    (%eax),%eax
 4b2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4b9:	00 
 4ba:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c1:	00 
 4c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	89 04 24             	mov    %eax,(%esp)
 4cc:	e8 b3 fe ff ff       	call   384 <printint>
        ap++;
 4d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4d5:	e9 ed 00 00 00       	jmp    5c7 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 4da:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4de:	74 06                	je     4e6 <printf+0xb3>
 4e0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e4:	75 2d                	jne    513 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 4e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4e9:	8b 00                	mov    (%eax),%eax
 4eb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4f2:	00 
 4f3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4fa:	00 
 4fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ff:	8b 45 08             	mov    0x8(%ebp),%eax
 502:	89 04 24             	mov    %eax,(%esp)
 505:	e8 7a fe ff ff       	call   384 <printint>
        ap++;
 50a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 50e:	e9 b4 00 00 00       	jmp    5c7 <printf+0x194>
      } else if(c == 's'){
 513:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 517:	75 46                	jne    55f <printf+0x12c>
        s = (char*)*ap;
 519:	8b 45 e8             	mov    -0x18(%ebp),%eax
 51c:	8b 00                	mov    (%eax),%eax
 51e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 521:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 525:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 529:	75 27                	jne    552 <printf+0x11f>
          s = "(null)";
 52b:	c7 45 f4 04 08 00 00 	movl   $0x804,-0xc(%ebp)
        while(*s != 0){
 532:	eb 1e                	jmp    552 <printf+0x11f>
          putc(fd, *s);
 534:	8b 45 f4             	mov    -0xc(%ebp),%eax
 537:	0f b6 00             	movzbl (%eax),%eax
 53a:	0f be c0             	movsbl %al,%eax
 53d:	89 44 24 04          	mov    %eax,0x4(%esp)
 541:	8b 45 08             	mov    0x8(%ebp),%eax
 544:	89 04 24             	mov    %eax,(%esp)
 547:	e8 10 fe ff ff       	call   35c <putc>
          s++;
 54c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 550:	eb 01                	jmp    553 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 552:	90                   	nop
 553:	8b 45 f4             	mov    -0xc(%ebp),%eax
 556:	0f b6 00             	movzbl (%eax),%eax
 559:	84 c0                	test   %al,%al
 55b:	75 d7                	jne    534 <printf+0x101>
 55d:	eb 68                	jmp    5c7 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 55f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 563:	75 1d                	jne    582 <printf+0x14f>
        putc(fd, *ap);
 565:	8b 45 e8             	mov    -0x18(%ebp),%eax
 568:	8b 00                	mov    (%eax),%eax
 56a:	0f be c0             	movsbl %al,%eax
 56d:	89 44 24 04          	mov    %eax,0x4(%esp)
 571:	8b 45 08             	mov    0x8(%ebp),%eax
 574:	89 04 24             	mov    %eax,(%esp)
 577:	e8 e0 fd ff ff       	call   35c <putc>
        ap++;
 57c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 580:	eb 45                	jmp    5c7 <printf+0x194>
      } else if(c == '%'){
 582:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 586:	75 17                	jne    59f <printf+0x16c>
        putc(fd, c);
 588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	89 44 24 04          	mov    %eax,0x4(%esp)
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	89 04 24             	mov    %eax,(%esp)
 598:	e8 bf fd ff ff       	call   35c <putc>
 59d:	eb 28                	jmp    5c7 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5a6:	00 
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	89 04 24             	mov    %eax,(%esp)
 5ad:	e8 aa fd ff ff       	call   35c <putc>
        putc(fd, c);
 5b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b5:	0f be c0             	movsbl %al,%eax
 5b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bc:	8b 45 08             	mov    0x8(%ebp),%eax
 5bf:	89 04 24             	mov    %eax,(%esp)
 5c2:	e8 95 fd ff ff       	call   35c <putc>
      }
      state = 0;
 5c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d8:	01 d0                	add    %edx,%eax
 5da:	0f b6 00             	movzbl (%eax),%eax
 5dd:	84 c0                	test   %al,%al
 5df:	0f 85 70 fe ff ff    	jne    455 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e5:	c9                   	leave  
 5e6:	c3                   	ret    
 5e7:	90                   	nop

000005e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	83 e8 08             	sub    $0x8,%eax
 5f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f7:	a1 64 0a 00 00       	mov    0xa64,%eax
 5fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ff:	eb 24                	jmp    625 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 609:	77 12                	ja     61d <free+0x35>
 60b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 611:	77 24                	ja     637 <free+0x4f>
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61b:	77 1a                	ja     637 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	89 45 fc             	mov    %eax,-0x4(%ebp)
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62b:	76 d4                	jbe    601 <free+0x19>
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 635:	76 ca                	jbe    601 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	8b 40 04             	mov    0x4(%eax),%eax
 63d:	c1 e0 03             	shl    $0x3,%eax
 640:	89 c2                	mov    %eax,%edx
 642:	03 55 f8             	add    -0x8(%ebp),%edx
 645:	8b 45 fc             	mov    -0x4(%ebp),%eax
 648:	8b 00                	mov    (%eax),%eax
 64a:	39 c2                	cmp    %eax,%edx
 64c:	75 24                	jne    672 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 64e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 651:	8b 50 04             	mov    0x4(%eax),%edx
 654:	8b 45 fc             	mov    -0x4(%ebp),%eax
 657:	8b 00                	mov    (%eax),%eax
 659:	8b 40 04             	mov    0x4(%eax),%eax
 65c:	01 c2                	add    %eax,%edx
 65e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 661:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 664:	8b 45 fc             	mov    -0x4(%ebp),%eax
 667:	8b 00                	mov    (%eax),%eax
 669:	8b 10                	mov    (%eax),%edx
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	89 10                	mov    %edx,(%eax)
 670:	eb 0a                	jmp    67c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 672:	8b 45 fc             	mov    -0x4(%ebp),%eax
 675:	8b 10                	mov    (%eax),%edx
 677:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 67c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67f:	8b 40 04             	mov    0x4(%eax),%eax
 682:	c1 e0 03             	shl    $0x3,%eax
 685:	03 45 fc             	add    -0x4(%ebp),%eax
 688:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 68b:	75 20                	jne    6ad <free+0xc5>
    p->s.size += bp->s.size;
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	8b 50 04             	mov    0x4(%eax),%edx
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
 696:	8b 40 04             	mov    0x4(%eax),%eax
 699:	01 c2                	add    %eax,%edx
 69b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a4:	8b 10                	mov    (%eax),%edx
 6a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a9:	89 10                	mov    %edx,(%eax)
 6ab:	eb 08                	jmp    6b5 <free+0xcd>
  } else
    p->s.ptr = bp;
 6ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6b3:	89 10                	mov    %edx,(%eax)
  freep = p;
 6b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b8:	a3 64 0a 00 00       	mov    %eax,0xa64
}
 6bd:	c9                   	leave  
 6be:	c3                   	ret    

000006bf <morecore>:

static Header*
morecore(uint nu)
{
 6bf:	55                   	push   %ebp
 6c0:	89 e5                	mov    %esp,%ebp
 6c2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6c5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6cc:	77 07                	ja     6d5 <morecore+0x16>
    nu = 4096;
 6ce:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6d5:	8b 45 08             	mov    0x8(%ebp),%eax
 6d8:	c1 e0 03             	shl    $0x3,%eax
 6db:	89 04 24             	mov    %eax,(%esp)
 6de:	e8 41 fc ff ff       	call   324 <sbrk>
 6e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6e6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6ea:	75 07                	jne    6f3 <morecore+0x34>
    return 0;
 6ec:	b8 00 00 00 00       	mov    $0x0,%eax
 6f1:	eb 22                	jmp    715 <morecore+0x56>
  hp = (Header*)p;
 6f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fc:	8b 55 08             	mov    0x8(%ebp),%edx
 6ff:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 702:	8b 45 f0             	mov    -0x10(%ebp),%eax
 705:	83 c0 08             	add    $0x8,%eax
 708:	89 04 24             	mov    %eax,(%esp)
 70b:	e8 d8 fe ff ff       	call   5e8 <free>
  return freep;
 710:	a1 64 0a 00 00       	mov    0xa64,%eax
}
 715:	c9                   	leave  
 716:	c3                   	ret    

00000717 <malloc>:

void*
malloc(uint nbytes)
{
 717:	55                   	push   %ebp
 718:	89 e5                	mov    %esp,%ebp
 71a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 71d:	8b 45 08             	mov    0x8(%ebp),%eax
 720:	83 c0 07             	add    $0x7,%eax
 723:	c1 e8 03             	shr    $0x3,%eax
 726:	83 c0 01             	add    $0x1,%eax
 729:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 72c:	a1 64 0a 00 00       	mov    0xa64,%eax
 731:	89 45 f0             	mov    %eax,-0x10(%ebp)
 734:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 738:	75 23                	jne    75d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 73a:	c7 45 f0 5c 0a 00 00 	movl   $0xa5c,-0x10(%ebp)
 741:	8b 45 f0             	mov    -0x10(%ebp),%eax
 744:	a3 64 0a 00 00       	mov    %eax,0xa64
 749:	a1 64 0a 00 00       	mov    0xa64,%eax
 74e:	a3 5c 0a 00 00       	mov    %eax,0xa5c
    base.s.size = 0;
 753:	c7 05 60 0a 00 00 00 	movl   $0x0,0xa60
 75a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 765:	8b 45 f4             	mov    -0xc(%ebp),%eax
 768:	8b 40 04             	mov    0x4(%eax),%eax
 76b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 76e:	72 4d                	jb     7bd <malloc+0xa6>
      if(p->s.size == nunits)
 770:	8b 45 f4             	mov    -0xc(%ebp),%eax
 773:	8b 40 04             	mov    0x4(%eax),%eax
 776:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 779:	75 0c                	jne    787 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	8b 10                	mov    (%eax),%edx
 780:	8b 45 f0             	mov    -0x10(%ebp),%eax
 783:	89 10                	mov    %edx,(%eax)
 785:	eb 26                	jmp    7ad <malloc+0x96>
      else {
        p->s.size -= nunits;
 787:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78a:	8b 40 04             	mov    0x4(%eax),%eax
 78d:	89 c2                	mov    %eax,%edx
 78f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 792:	8b 45 f4             	mov    -0xc(%ebp),%eax
 795:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 798:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79b:	8b 40 04             	mov    0x4(%eax),%eax
 79e:	c1 e0 03             	shl    $0x3,%eax
 7a1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7aa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b0:	a3 64 0a 00 00       	mov    %eax,0xa64
      return (void*)(p + 1);
 7b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b8:	83 c0 08             	add    $0x8,%eax
 7bb:	eb 38                	jmp    7f5 <malloc+0xde>
    }
    if(p == freep)
 7bd:	a1 64 0a 00 00       	mov    0xa64,%eax
 7c2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7c5:	75 1b                	jne    7e2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 7c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7ca:	89 04 24             	mov    %eax,(%esp)
 7cd:	e8 ed fe ff ff       	call   6bf <morecore>
 7d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7d9:	75 07                	jne    7e2 <malloc+0xcb>
        return 0;
 7db:	b8 00 00 00 00       	mov    $0x0,%eax
 7e0:	eb 13                	jmp    7f5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7eb:	8b 00                	mov    (%eax),%eax
 7ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f0:	e9 70 ff ff ff       	jmp    765 <malloc+0x4e>
}
 7f5:	c9                   	leave  
 7f6:	c3                   	ret    

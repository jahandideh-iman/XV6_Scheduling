/*
 * testprocess1.c
 *
 *  Created on: Dec 24, 2013
 *      Author: mohammad
 */


#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
	int childpid=fork();


	if(childpid!=0)
	{
		setprioritybypid(childpid,2);
		int secondChild = fork();
		if(secondChild!=0)
		{
			setprioritybypid(secondChild,1);
			ps();
		}


	}
	while(1);


/*
	else
	{
		int secondchild=fork();
		if(secondchild!=0)
		{
		}
	}*/
//	setprioritybypid(getpid(),2);


	//while (1);
	exit();
}

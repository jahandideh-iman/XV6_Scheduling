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
  if(fork()==0)
	  exec("testprocess2",argv);
  else
  {
	  fork();
	  fork();
	  while(1)
	  {

	  }
  }
  exit();
}

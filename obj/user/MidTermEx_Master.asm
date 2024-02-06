
obj/user/MidTermEx_Master:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 14 02 00 00       	call   80024a <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 33 80 00       	push   $0x8033a0
  80004a:	e8 8e 14 00 00       	call   8014dd <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 a4 33 80 00       	push   $0x8033a4
  800066:	e8 ef 03 00 00       	call   80045a <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 7f 01 00 00       	call   8001f2 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 27 01 00 00       	call   8001aa <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 1a 01 00 00       	call   8001aa <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 c9 33 80 00       	push   $0x8033c9
  80009f:	e8 39 14 00 00       	call   8014dd <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 12                	jne    8000e4 <_main+0xac>
	{
		sys_createSemaphore("T", 0);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	68 d0 33 80 00       	push   $0x8033d0
  8000dc:	e8 76 18 00 00       	call   801957 <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 d2 33 80 00       	push   $0x8033d2
  8000f0:	e8 e8 13 00 00       	call   8014dd <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 40 80 00       	mov    0x804020,%eax
  800109:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80010f:	a1 20 40 80 00       	mov    0x804020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c1                	mov    %eax,%ecx
  80011c:	a1 20 40 80 00       	mov    0x804020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	52                   	push   %edx
  800125:	51                   	push   %ecx
  800126:	50                   	push   %eax
  800127:	68 e0 33 80 00       	push   $0x8033e0
  80012c:	e8 37 19 00 00       	call   801a68 <sys_create_env>
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800137:	a1 20 40 80 00       	mov    0x804020,%eax
  80013c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	a1 20 40 80 00       	mov    0x804020,%eax
  800154:	8b 40 74             	mov    0x74(%eax),%eax
  800157:	52                   	push   %edx
  800158:	51                   	push   %ecx
  800159:	50                   	push   %eax
  80015a:	68 ea 33 80 00       	push   $0x8033ea
  80015f:	e8 04 19 00 00       	call   801a68 <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 11 19 00 00       	call   801a86 <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 03 19 00 00       	call   801a86 <sys_run_env>
  800183:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800186:	90                   	nop
  800187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	83 f8 02             	cmp    $0x2,%eax
  80018f:	75 f6                	jne    800187 <_main+0x14f>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  800191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	50                   	push   %eax
  80019a:	68 f4 33 80 00       	push   $0x8033f4
  80019f:	e8 b6 02 00 00       	call   80045a <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp

	return;
  8001a7:	90                   	nop
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001b6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	e8 54 17 00 00       	call   801917 <sys_cputc>
  8001c3:	83 c4 10             	add    $0x10,%esp
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001cf:	e8 0f 17 00 00       	call   8018e3 <sys_disable_interrupt>
	char c = ch;
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001da:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	e8 30 17 00 00       	call   801917 <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 0e 17 00 00       	call   8018fd <sys_enable_interrupt>
}
  8001ef:	90                   	nop
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <getchar>:

int
getchar(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8001f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8001ff:	eb 08                	jmp    800209 <getchar+0x17>
	{
		c = sys_cgetc();
  800201:	e8 58 15 00 00       	call   80175e <sys_cgetc>
  800206:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80020d:	74 f2                	je     800201 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <atomic_getchar>:

int
atomic_getchar(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80021a:	e8 c4 16 00 00       	call   8018e3 <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 31 15 00 00       	call   80175e <sys_cgetc>
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800234:	74 f2                	je     800228 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800236:	e8 c2 16 00 00       	call   8018fd <sys_enable_interrupt>
	return c;
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <iscons>:

int iscons(int fdnum)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800243:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800250:	e8 81 18 00 00       	call   801ad6 <sys_getenvindex>
  800255:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025b:	89 d0                	mov    %edx,%eax
  80025d:	c1 e0 03             	shl    $0x3,%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	01 c0                	add    %eax,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	01 d0                	add    %edx,%eax
  80026f:	c1 e0 04             	shl    $0x4,%eax
  800272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800277:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027c:	a1 20 40 80 00       	mov    0x804020,%eax
  800281:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800287:	84 c0                	test   %al,%al
  800289:	74 0f                	je     80029a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80028b:	a1 20 40 80 00       	mov    0x804020,%eax
  800290:	05 5c 05 00 00       	add    $0x55c,%eax
  800295:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029e:	7e 0a                	jle    8002aa <libmain+0x60>
		binaryname = argv[0];
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 80 fd ff ff       	call   800038 <_main>
  8002b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002bb:	e8 23 16 00 00       	call   8018e3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 24 34 80 00       	push   $0x803424
  8002c8:	e8 8d 01 00 00       	call   80045a <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d5:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002db:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e0:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 4c 34 80 00       	push   $0x80344c
  8002f0:	e8 65 01 00 00       	call   80045a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fd:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800303:	a1 20 40 80 00       	mov    0x804020,%eax
  800308:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80030e:	a1 20 40 80 00       	mov    0x804020,%eax
  800313:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 74 34 80 00       	push   $0x803474
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 cc 34 80 00       	push   $0x8034cc
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 24 34 80 00       	push   $0x803424
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 a3 15 00 00       	call   8018fd <sys_enable_interrupt>

	// exit gracefully
	exit();
  80035a:	e8 19 00 00 00       	call   800378 <exit>
}
  80035f:	90                   	nop
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	6a 00                	push   $0x0
  80036d:	e8 30 17 00 00       	call   801aa2 <sys_destroy_env>
  800372:	83 c4 10             	add    $0x10,%esp
}
  800375:	90                   	nop
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <exit>:

void
exit(void)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037e:	e8 85 17 00 00       	call   801b08 <sys_exit_env>
}
  800383:	90                   	nop
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	8d 48 01             	lea    0x1(%eax),%ecx
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 0a                	mov    %ecx,(%edx)
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	88 d1                	mov    %dl,%cl
  80039e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b1:	a0 24 40 80 00       	mov    0x804024,%al
  8003b6:	0f b6 c0             	movzbl %al,%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	8b 12                	mov    (%edx),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	83 c2 08             	add    $0x8,%edx
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	50                   	push   %eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	e8 64 13 00 00       	call   801735 <sys_cputs>
  8003d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	8b 40 04             	mov    0x4(%eax),%eax
  8003e3:	8d 50 01             	lea    0x1(%eax),%edx
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ec:	90                   	nop
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ff:	00 00 00 
	b.cnt = 0;
  800402:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800409:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	68 86 03 80 00       	push   $0x800386
  80041e:	e8 11 02 00 00       	call   800634 <vprintfmt>
  800423:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800426:	a0 24 40 80 00       	mov    0x804024,%al
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	52                   	push   %edx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 ed 12 00 00       	call   801735 <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

int cprintf(const char *fmt, ...) {
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800460:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 73 ff ff ff       	call   8003ef <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80048d:	e8 51 14 00 00       	call   8018e3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800492:	8d 45 0c             	lea    0xc(%ebp),%eax
  800495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a1:	50                   	push   %eax
  8004a2:	e8 48 ff ff ff       	call   8003ef <vcprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004ad:	e8 4b 14 00 00       	call   8018fd <sys_enable_interrupt>
	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 14             	sub    $0x14,%esp
  8004be:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d5:	77 55                	ja     80052c <printnum+0x75>
  8004d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004da:	72 05                	jb     8004e1 <printnum+0x2a>
  8004dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004df:	77 4b                	ja     80052c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	52                   	push   %edx
  8004f0:	50                   	push   %eax
  8004f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f7:	e8 28 2c 00 00       	call   803124 <__udivdi3>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	ff 75 20             	pushl  0x20(%ebp)
  800505:	53                   	push   %ebx
  800506:	ff 75 18             	pushl  0x18(%ebp)
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 a1 ff ff ff       	call   8004b7 <printnum>
  800516:	83 c4 20             	add    $0x20,%esp
  800519:	eb 1a                	jmp    800535 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 20             	pushl  0x20(%ebp)
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	ff d0                	call   *%eax
  800529:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052c:	ff 4d 1c             	decl   0x1c(%ebp)
  80052f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800533:	7f e6                	jg     80051b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800535:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800538:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800543:	53                   	push   %ebx
  800544:	51                   	push   %ecx
  800545:	52                   	push   %edx
  800546:	50                   	push   %eax
  800547:	e8 e8 2c 00 00       	call   803234 <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 f4 36 80 00       	add    $0x8036f4,%eax
  800554:	8a 00                	mov    (%eax),%al
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	ff d0                	call   *%eax
  800565:	83 c4 10             	add    $0x10,%esp
}
  800568:	90                   	nop
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800575:	7e 1c                	jle    800593 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 08             	sub    $0x8,%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	eb 40                	jmp    8005d3 <getuint+0x65>
	else if (lflag)
  800593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800597:	74 1e                	je     8005b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 10                	mov    %edx,(%eax)
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 e8 04             	sub    $0x4,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	eb 1c                	jmp    8005d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dc:	7e 1c                	jle    8005fa <getint+0x25>
		return va_arg(*ap, long long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 08             	lea    0x8(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 08             	sub    $0x8,%eax
  8005f3:	8b 50 04             	mov    0x4(%eax),%edx
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	eb 38                	jmp    800632 <getint+0x5d>
	else if (lflag)
  8005fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fe:	74 1a                	je     80061a <getint+0x45>
		return va_arg(*ap, long);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 50 04             	lea    0x4(%eax),%edx
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 10                	mov    %edx,(%eax)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	83 e8 04             	sub    $0x4,%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	99                   	cltd   
  800618:	eb 18                	jmp    800632 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	8d 50 04             	lea    0x4(%eax),%edx
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	89 10                	mov    %edx,(%eax)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
}
  800632:	5d                   	pop    %ebp
  800633:	c3                   	ret    

00800634 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	56                   	push   %esi
  800638:	53                   	push   %ebx
  800639:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x21>
			if (ch == '\0')
  80063e:	85 db                	test   %ebx,%ebx
  800640:	0f 84 af 03 00 00    	je     8009f5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	53                   	push   %ebx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	8b 45 10             	mov    0x10(%ebp),%eax
  800658:	8d 50 01             	lea    0x1(%eax),%edx
  80065b:	89 55 10             	mov    %edx,0x10(%ebp)
  80065e:	8a 00                	mov    (%eax),%al
  800660:	0f b6 d8             	movzbl %al,%ebx
  800663:	83 fb 25             	cmp    $0x25,%ebx
  800666:	75 d6                	jne    80063e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800668:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800673:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800681:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 45 10             	mov    0x10(%ebp),%eax
  80068b:	8d 50 01             	lea    0x1(%eax),%edx
  80068e:	89 55 10             	mov    %edx,0x10(%ebp)
  800691:	8a 00                	mov    (%eax),%al
  800693:	0f b6 d8             	movzbl %al,%ebx
  800696:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800699:	83 f8 55             	cmp    $0x55,%eax
  80069c:	0f 87 2b 03 00 00    	ja     8009cd <vprintfmt+0x399>
  8006a2:	8b 04 85 18 37 80 00 	mov    0x803718(,%eax,4),%eax
  8006a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d7                	jmp    800688 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d1                	jmp    800688 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	c1 e0 02             	shl    $0x2,%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	01 c0                	add    %eax,%eax
  8006ca:	01 d8                	add    %ebx,%eax
  8006cc:	83 e8 30             	sub    $0x30,%eax
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 3e                	jle    80071d <vprintfmt+0xe9>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 39                	jg     80071d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e7:	eb d5                	jmp    8006be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 c0 04             	add    $0x4,%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fd:	eb 1f                	jmp    80071e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	79 83                	jns    800688 <vprintfmt+0x54>
				width = 0;
  800705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070c:	e9 77 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800711:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800718:	e9 6b ff ff ff       	jmp    800688 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800722:	0f 89 60 ff ff ff    	jns    800688 <vprintfmt+0x54>
				width = precision, precision = -1;
  800728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800735:	e9 4e ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073d:	e9 46 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 c0 04             	add    $0x4,%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
			break;
  800762:	e9 89 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800778:	85 db                	test   %ebx,%ebx
  80077a:	79 02                	jns    80077e <vprintfmt+0x14a>
				err = -err;
  80077c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077e:	83 fb 64             	cmp    $0x64,%ebx
  800781:	7f 0b                	jg     80078e <vprintfmt+0x15a>
  800783:	8b 34 9d 60 35 80 00 	mov    0x803560(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 05 37 80 00       	push   $0x803705
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 5e 02 00 00       	call   8009fd <printfmt>
  80079f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a2:	e9 49 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a7:	56                   	push   %esi
  8007a8:	68 0e 37 80 00       	push   $0x80370e
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 45 02 00 00       	call   8009fd <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 30 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 30                	mov    (%eax),%esi
  8007d1:	85 f6                	test   %esi,%esi
  8007d3:	75 05                	jne    8007da <vprintfmt+0x1a6>
				p = "(null)";
  8007d5:	be 11 37 80 00       	mov    $0x803711,%esi
			if (width > 0 && padc != '-')
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	7e 6d                	jle    80084d <vprintfmt+0x219>
  8007e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e4:	74 67                	je     80084d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	50                   	push   %eax
  8007ed:	56                   	push   %esi
  8007ee:	e8 0c 03 00 00       	call   800aff <strnlen>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f9:	eb 16                	jmp    800811 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	50                   	push   %eax
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080e:	ff 4d e4             	decl   -0x1c(%ebp)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800815:	7f e4                	jg     8007fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800817:	eb 34                	jmp    80084d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800819:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081d:	74 1c                	je     80083b <vprintfmt+0x207>
  80081f:	83 fb 1f             	cmp    $0x1f,%ebx
  800822:	7e 05                	jle    800829 <vprintfmt+0x1f5>
  800824:	83 fb 7e             	cmp    $0x7e,%ebx
  800827:	7e 12                	jle    80083b <vprintfmt+0x207>
					putch('?', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 3f                	push   $0x3f
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	eb 0f                	jmp    80084a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084a:	ff 4d e4             	decl   -0x1c(%ebp)
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 70 01             	lea    0x1(%eax),%esi
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f be d8             	movsbl %al,%ebx
  800857:	85 db                	test   %ebx,%ebx
  800859:	74 24                	je     80087f <vprintfmt+0x24b>
  80085b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085f:	78 b8                	js     800819 <vprintfmt+0x1e5>
  800861:	ff 4d e0             	decl   -0x20(%ebp)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 af                	jns    800819 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086a:	eb 13                	jmp    80087f <vprintfmt+0x24b>
				putch(' ', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 20                	push   $0x20
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087c:	ff 4d e4             	decl   -0x1c(%ebp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7f e7                	jg     80086c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800885:	e9 66 01 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 e8             	pushl  -0x18(%ebp)
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	e8 3c fd ff ff       	call   8005d5 <getint>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	79 23                	jns    8008cf <vprintfmt+0x29b>
				putch('-', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 2d                	push   $0x2d
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c2:	f7 d8                	neg    %eax
  8008c4:	83 d2 00             	adc    $0x0,%edx
  8008c7:	f7 da                	neg    %edx
  8008c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d6:	e9 bc 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	e8 84 fc ff ff       	call   80056e <getuint>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fa:	e9 98 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	6a 58                	push   $0x58
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	6a 58                	push   $0x58
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	6a 58                	push   $0x58
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			break;
  80092f:	e9 bc 00 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	6a 30                	push   $0x30
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 78                	push   $0x78
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 c0 04             	add    $0x4,%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 e8 04             	sub    $0x4,%eax
  800963:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80096f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800976:	eb 1f                	jmp    800997 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 e8             	pushl  -0x18(%ebp)
  80097e:	8d 45 14             	lea    0x14(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	e8 e7 fb ff ff       	call   80056e <getuint>
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800990:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800997:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	52                   	push   %edx
  8009a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 00 fb ff ff       	call   8004b7 <printnum>
  8009b7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ba:	eb 34                	jmp    8009f0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			break;
  8009cb:	eb 23                	jmp    8009f0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	6a 25                	push   $0x25
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009dd:	ff 4d 10             	decl   0x10(%ebp)
  8009e0:	eb 03                	jmp    8009e5 <vprintfmt+0x3b1>
  8009e2:	ff 4d 10             	decl   0x10(%ebp)
  8009e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e8:	48                   	dec    %eax
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	3c 25                	cmp    $0x25,%al
  8009ed:	75 f3                	jne    8009e2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009ef:	90                   	nop
		}
	}
  8009f0:	e9 47 fc ff ff       	jmp    80063c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a03:	8d 45 10             	lea    0x10(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a12:	50                   	push   %eax
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	ff 75 08             	pushl  0x8(%ebp)
  800a19:	e8 16 fc ff ff       	call   800634 <vprintfmt>
  800a1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8b 40 08             	mov    0x8(%eax),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8b 10                	mov    (%eax),%edx
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 40 04             	mov    0x4(%eax),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	73 12                	jae    800a57 <sprintputch+0x33>
		*b->buf++ = ch;
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a50:	89 0a                	mov    %ecx,(%edx)
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	88 10                	mov    %dl,(%eax)
}
  800a57:	90                   	nop
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	01 d0                	add    %edx,%eax
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7f:	74 06                	je     800a87 <vsnprintf+0x2d>
  800a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a85:	7f 07                	jg     800a8e <vsnprintf+0x34>
		return -E_INVAL;
  800a87:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8c:	eb 20                	jmp    800aae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8e:	ff 75 14             	pushl  0x14(%ebp)
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a97:	50                   	push   %eax
  800a98:	68 24 0a 80 00       	push   $0x800a24
  800a9d:	e8 92 fb ff ff       	call   800634 <vprintfmt>
  800aa2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	ff 75 08             	pushl  0x8(%ebp)
  800acc:	e8 89 ff ff ff       	call   800a5a <vsnprintf>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae9:	eb 06                	jmp    800af1 <strlen+0x15>
		n++;
  800aeb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aee:	ff 45 08             	incl   0x8(%ebp)
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	75 f1                	jne    800aeb <strlen+0xf>
		n++;
	return n;
  800afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 09                	jmp    800b17 <strnlen+0x18>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	ff 4d 0c             	decl   0xc(%ebp)
  800b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1b:	74 09                	je     800b26 <strnlen+0x27>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	75 e8                	jne    800b0e <strnlen+0xf>
		n++;
	return n;
  800b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b37:	90                   	nop
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8d 50 01             	lea    0x1(%eax),%edx
  800b3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b47:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4a:	8a 12                	mov    (%edx),%dl
  800b4c:	88 10                	mov    %dl,(%eax)
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	84 c0                	test   %al,%al
  800b52:	75 e4                	jne    800b38 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6c:	eb 1f                	jmp    800b8d <strncpy+0x34>
		*dst++ = *src;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 08             	mov    %edx,0x8(%ebp)
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8a 12                	mov    (%edx),%dl
  800b7c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	84 c0                	test   %al,%al
  800b85:	74 03                	je     800b8a <strncpy+0x31>
			src++;
  800b87:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8a:	ff 45 fc             	incl   -0x4(%ebp)
  800b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b93:	72 d9                	jb     800b6e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800baa:	74 30                	je     800bdc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bac:	eb 16                	jmp    800bc4 <strlcpy+0x2a>
			*dst++ = *src++;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8d 50 01             	lea    0x1(%eax),%edx
  800bb4:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc0:	8a 12                	mov    (%edx),%dl
  800bc2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc4:	ff 4d 10             	decl   0x10(%ebp)
  800bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcb:	74 09                	je     800bd6 <strlcpy+0x3c>
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 d8                	jne    800bae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be2:	29 c2                	sub    %eax,%edx
  800be4:	89 d0                	mov    %edx,%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800beb:	eb 06                	jmp    800bf3 <strcmp+0xb>
		p++, q++;
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	74 0e                	je     800c0a <strcmp+0x22>
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8a 10                	mov    (%eax),%dl
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	38 c2                	cmp    %al,%dl
  800c08:	74 e3                	je     800bed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	0f b6 d0             	movzbl %al,%edx
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	0f b6 c0             	movzbl %al,%eax
  800c1a:	29 c2                	sub    %eax,%edx
  800c1c:	89 d0                	mov    %edx,%eax
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c23:	eb 09                	jmp    800c2e <strncmp+0xe>
		n--, p++, q++;
  800c25:	ff 4d 10             	decl   0x10(%ebp)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c32:	74 17                	je     800c4b <strncmp+0x2b>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	74 0e                	je     800c4b <strncmp+0x2b>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 10                	mov    (%eax),%dl
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	38 c2                	cmp    %al,%dl
  800c49:	74 da                	je     800c25 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4f:	75 07                	jne    800c58 <strncmp+0x38>
		return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	eb 14                	jmp    800c6c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f b6 d0             	movzbl %al,%edx
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	0f b6 c0             	movzbl %al,%eax
  800c68:	29 c2                	sub    %eax,%edx
  800c6a:	89 d0                	mov    %edx,%eax
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 04             	sub    $0x4,%esp
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7a:	eb 12                	jmp    800c8e <strchr+0x20>
		if (*s == c)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c84:	75 05                	jne    800c8b <strchr+0x1d>
			return (char *) s;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	eb 11                	jmp    800c9c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8b:	ff 45 08             	incl   0x8(%ebp)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e5                	jne    800c7c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 04             	sub    $0x4,%esp
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800caa:	eb 0d                	jmp    800cb9 <strfind+0x1b>
		if (*s == c)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb4:	74 0e                	je     800cc4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 ea                	jne    800cac <strfind+0xe>
  800cc2:	eb 01                	jmp    800cc5 <strfind+0x27>
		if (*s == c)
			break;
  800cc4:	90                   	nop
	return (char *) s;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cdc:	eb 0e                	jmp    800cec <memset+0x22>
		*p++ = c;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce1:	8d 50 01             	lea    0x1(%eax),%edx
  800ce4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cec:	ff 4d f8             	decl   -0x8(%ebp)
  800cef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf3:	79 e9                	jns    800cde <memset+0x14>
		*p++ = c;

	return v;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0c:	eb 16                	jmp    800d24 <memcpy+0x2a>
		*d++ = *s++;
  800d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d11:	8d 50 01             	lea    0x1(%eax),%edx
  800d14:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d20:	8a 12                	mov    (%edx),%dl
  800d22:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	75 dd                	jne    800d0e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4e:	73 50                	jae    800da0 <memmove+0x6a>
  800d50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5b:	76 43                	jbe    800da0 <memmove+0x6a>
		s += n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d69:	eb 10                	jmp    800d7b <memmove+0x45>
			*--d = *--s;
  800d6b:	ff 4d f8             	decl   -0x8(%ebp)
  800d6e:	ff 4d fc             	decl   -0x4(%ebp)
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d79:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	89 55 10             	mov    %edx,0x10(%ebp)
  800d84:	85 c0                	test   %eax,%eax
  800d86:	75 e3                	jne    800d6b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d88:	eb 23                	jmp    800dad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d99:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9c:	8a 12                	mov    (%edx),%dl
  800d9e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da0:	8b 45 10             	mov    0x10(%ebp),%eax
  800da3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da6:	89 55 10             	mov    %edx,0x10(%ebp)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	75 dd                	jne    800d8a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc4:	eb 2a                	jmp    800df0 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc9:	8a 10                	mov    (%eax),%dl
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	38 c2                	cmp    %al,%dl
  800dd2:	74 16                	je     800dea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d0             	movzbl %al,%edx
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 c0             	movzbl %al,%eax
  800de4:	29 c2                	sub    %eax,%edx
  800de6:	89 d0                	mov    %edx,%eax
  800de8:	eb 18                	jmp    800e02 <memcmp+0x50>
		s1++, s2++;
  800dea:	ff 45 fc             	incl   -0x4(%ebp)
  800ded:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df6:	89 55 10             	mov    %edx,0x10(%ebp)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	75 c9                	jne    800dc6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 d0                	add    %edx,%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e15:	eb 15                	jmp    800e2c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	39 c2                	cmp    %eax,%edx
  800e27:	74 0d                	je     800e36 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e32:	72 e3                	jb     800e17 <memfind+0x13>
  800e34:	eb 01                	jmp    800e37 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e36:	90                   	nop
	return (void *) s;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e50:	eb 03                	jmp    800e55 <strtol+0x19>
		s++;
  800e52:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 20                	cmp    $0x20,%al
  800e5c:	74 f4                	je     800e52 <strtol+0x16>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 09                	cmp    $0x9,%al
  800e65:	74 eb                	je     800e52 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 2b                	cmp    $0x2b,%al
  800e6e:	75 05                	jne    800e75 <strtol+0x39>
		s++;
  800e70:	ff 45 08             	incl   0x8(%ebp)
  800e73:	eb 13                	jmp    800e88 <strtol+0x4c>
	else if (*s == '-')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 2d                	cmp    $0x2d,%al
  800e7c:	75 0a                	jne    800e88 <strtol+0x4c>
		s++, neg = 1;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8c:	74 06                	je     800e94 <strtol+0x58>
  800e8e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e92:	75 20                	jne    800eb4 <strtol+0x78>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 30                	cmp    $0x30,%al
  800e9b:	75 17                	jne    800eb4 <strtol+0x78>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	40                   	inc    %eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	3c 78                	cmp    $0x78,%al
  800ea5:	75 0d                	jne    800eb4 <strtol+0x78>
		s += 2, base = 16;
  800ea7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb2:	eb 28                	jmp    800edc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb8:	75 15                	jne    800ecf <strtol+0x93>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 30                	cmp    $0x30,%al
  800ec1:	75 0c                	jne    800ecf <strtol+0x93>
		s++, base = 8;
  800ec3:	ff 45 08             	incl   0x8(%ebp)
  800ec6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ecd:	eb 0d                	jmp    800edc <strtol+0xa0>
	else if (base == 0)
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	75 07                	jne    800edc <strtol+0xa0>
		base = 10;
  800ed5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 2f                	cmp    $0x2f,%al
  800ee3:	7e 19                	jle    800efe <strtol+0xc2>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 39                	cmp    $0x39,%al
  800eec:	7f 10                	jg     800efe <strtol+0xc2>
			dig = *s - '0';
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	0f be c0             	movsbl %al,%eax
  800ef6:	83 e8 30             	sub    $0x30,%eax
  800ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efc:	eb 42                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 60                	cmp    $0x60,%al
  800f05:	7e 19                	jle    800f20 <strtol+0xe4>
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 7a                	cmp    $0x7a,%al
  800f0e:	7f 10                	jg     800f20 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f be c0             	movsbl %al,%eax
  800f18:	83 e8 57             	sub    $0x57,%eax
  800f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1e:	eb 20                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 40                	cmp    $0x40,%al
  800f27:	7e 39                	jle    800f62 <strtol+0x126>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 5a                	cmp    $0x5a,%al
  800f30:	7f 30                	jg     800f62 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f be c0             	movsbl %al,%eax
  800f3a:	83 e8 37             	sub    $0x37,%eax
  800f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f46:	7d 19                	jge    800f61 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5c:	e9 7b ff ff ff       	jmp    800edc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f61:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f66:	74 08                	je     800f70 <strtol+0x134>
		*endptr = (char *) s;
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f74:	74 07                	je     800f7d <strtol+0x141>
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f79:	f7 d8                	neg    %eax
  800f7b:	eb 03                	jmp    800f80 <strtol+0x144>
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <ltostr>:

void
ltostr(long value, char *str)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9a:	79 13                	jns    800faf <ltostr+0x2d>
	{
		neg = 1;
  800f9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb7:	99                   	cltd   
  800fb8:	f7 f9                	idiv   %ecx
  800fba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc0:	8d 50 01             	lea    0x1(%eax),%edx
  800fc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd0:	83 c2 30             	add    $0x30,%edx
  800fd3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fdd:	f7 e9                	imul   %ecx
  800fdf:	c1 fa 02             	sar    $0x2,%edx
  800fe2:	89 c8                	mov    %ecx,%eax
  800fe4:	c1 f8 1f             	sar    $0x1f,%eax
  800fe7:	29 c2                	sub    %eax,%edx
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff6:	f7 e9                	imul   %ecx
  800ff8:	c1 fa 02             	sar    $0x2,%edx
  800ffb:	89 c8                	mov    %ecx,%eax
  800ffd:	c1 f8 1f             	sar    $0x1f,%eax
  801000:	29 c2                	sub    %eax,%edx
  801002:	89 d0                	mov    %edx,%eax
  801004:	c1 e0 02             	shl    $0x2,%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	01 c0                	add    %eax,%eax
  80100b:	29 c1                	sub    %eax,%ecx
  80100d:	89 ca                	mov    %ecx,%edx
  80100f:	85 d2                	test   %edx,%edx
  801011:	75 9c                	jne    800faf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801013:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	48                   	dec    %eax
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801025:	74 3d                	je     801064 <ltostr+0xe2>
		start = 1 ;
  801027:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102e:	eb 34                	jmp    801064 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c2                	add    %eax,%edx
  801045:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c8                	add    %ecx,%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105c:	88 02                	mov    %al,(%edx)
		start++ ;
  80105e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801061:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106a:	7c c4                	jl     801030 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801077:	90                   	nop
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 54 fa ff ff       	call   800adc <strlen>
  801088:	83 c4 04             	add    $0x4,%esp
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	e8 46 fa ff ff       	call   800adc <strlen>
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010aa:	eb 17                	jmp    8010c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	01 c8                	add    %ecx,%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c0:	ff 45 fc             	incl   -0x4(%ebp)
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c9:	7c e1                	jl     8010ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d9:	eb 1f                	jmp    8010fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801100:	7c d9                	jl     8010db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801133:	eb 0c                	jmp    801141 <strsplit+0x31>
			*string++ = 0;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 18                	je     801162 <strsplit+0x52>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	50                   	push   %eax
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 13 fb ff ff       	call   800c6e <strchr>
  80115b:	83 c4 08             	add    $0x8,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	75 d3                	jne    801135 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	74 5a                	je     8011c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116b:	8b 45 14             	mov    0x14(%ebp),%eax
  80116e:	8b 00                	mov    (%eax),%eax
  801170:	83 f8 0f             	cmp    $0xf,%eax
  801173:	75 07                	jne    80117c <strsplit+0x6c>
		{
			return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb 66                	jmp    8011e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117c:	8b 45 14             	mov    0x14(%ebp),%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	8d 48 01             	lea    0x1(%eax),%ecx
  801184:	8b 55 14             	mov    0x14(%ebp),%edx
  801187:	89 0a                	mov    %ecx,(%edx)
  801189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119a:	eb 03                	jmp    80119f <strsplit+0x8f>
			string++;
  80119c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 8b                	je     801133 <strsplit+0x23>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 b5 fa ff ff       	call   800c6e <strchr>
  8011b9:	83 c4 08             	add    $0x8,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 dc                	je     80119c <strsplit+0x8c>
			string++;
	}
  8011c0:	e9 6e ff ff ff       	jmp    801133 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8011ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 1f                	je     801212 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8011f3:	e8 1d 00 00 00       	call   801215 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8011f8:	83 ec 0c             	sub    $0xc,%esp
  8011fb:	68 70 38 80 00       	push   $0x803870
  801200:	e8 55 f2 ff ff       	call   80045a <cprintf>
  801205:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801208:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80120f:	00 00 00 
	}
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80121b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801222:	00 00 00 
  801225:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80122c:	00 00 00 
  80122f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801236:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801239:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801240:	00 00 00 
  801243:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80124a:	00 00 00 
  80124d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801254:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801257:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80125e:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801261:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80126b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801270:	2d 00 10 00 00       	sub    $0x1000,%eax
  801275:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80127a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801281:	a1 20 41 80 00       	mov    0x804120,%eax
  801286:	c1 e0 04             	shl    $0x4,%eax
  801289:	89 c2                	mov    %eax,%edx
  80128b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80128e:	01 d0                	add    %edx,%eax
  801290:	48                   	dec    %eax
  801291:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801294:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801297:	ba 00 00 00 00       	mov    $0x0,%edx
  80129c:	f7 75 f0             	divl   -0x10(%ebp)
  80129f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a2:	29 d0                	sub    %edx,%eax
  8012a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8012a7:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8012ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012b1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012b6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012bb:	83 ec 04             	sub    $0x4,%esp
  8012be:	6a 06                	push   $0x6
  8012c0:	ff 75 e8             	pushl  -0x18(%ebp)
  8012c3:	50                   	push   %eax
  8012c4:	e8 b0 05 00 00       	call   801879 <sys_allocate_chunk>
  8012c9:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012cc:	a1 20 41 80 00       	mov    0x804120,%eax
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	50                   	push   %eax
  8012d5:	e8 25 0c 00 00       	call   801eff <initialize_MemBlocksList>
  8012da:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8012dd:	a1 48 41 80 00       	mov    0x804148,%eax
  8012e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8012e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8012e9:	75 14                	jne    8012ff <initialize_dyn_block_system+0xea>
  8012eb:	83 ec 04             	sub    $0x4,%esp
  8012ee:	68 95 38 80 00       	push   $0x803895
  8012f3:	6a 29                	push   $0x29
  8012f5:	68 b3 38 80 00       	push   $0x8038b3
  8012fa:	e8 43 1c 00 00       	call   802f42 <_panic>
  8012ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801302:	8b 00                	mov    (%eax),%eax
  801304:	85 c0                	test   %eax,%eax
  801306:	74 10                	je     801318 <initialize_dyn_block_system+0x103>
  801308:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80130b:	8b 00                	mov    (%eax),%eax
  80130d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801310:	8b 52 04             	mov    0x4(%edx),%edx
  801313:	89 50 04             	mov    %edx,0x4(%eax)
  801316:	eb 0b                	jmp    801323 <initialize_dyn_block_system+0x10e>
  801318:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80131b:	8b 40 04             	mov    0x4(%eax),%eax
  80131e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801326:	8b 40 04             	mov    0x4(%eax),%eax
  801329:	85 c0                	test   %eax,%eax
  80132b:	74 0f                	je     80133c <initialize_dyn_block_system+0x127>
  80132d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801330:	8b 40 04             	mov    0x4(%eax),%eax
  801333:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801336:	8b 12                	mov    (%edx),%edx
  801338:	89 10                	mov    %edx,(%eax)
  80133a:	eb 0a                	jmp    801346 <initialize_dyn_block_system+0x131>
  80133c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80133f:	8b 00                	mov    (%eax),%eax
  801341:	a3 48 41 80 00       	mov    %eax,0x804148
  801346:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80134f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801352:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801359:	a1 54 41 80 00       	mov    0x804154,%eax
  80135e:	48                   	dec    %eax
  80135f:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801364:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801367:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80136e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801371:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	ff 75 e0             	pushl  -0x20(%ebp)
  80137e:	e8 b9 14 00 00       	call   80283c <insert_sorted_with_merge_freeList>
  801383:	83 c4 10             	add    $0x10,%esp

}
  801386:	90                   	nop
  801387:	c9                   	leave  
  801388:	c3                   	ret    

00801389 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80138f:	e8 50 fe ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801394:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801398:	75 07                	jne    8013a1 <malloc+0x18>
  80139a:	b8 00 00 00 00       	mov    $0x0,%eax
  80139f:	eb 68                	jmp    801409 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8013a1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8013a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ae:	01 d0                	add    %edx,%eax
  8013b0:	48                   	dec    %eax
  8013b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8013b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013bc:	f7 75 f4             	divl   -0xc(%ebp)
  8013bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c2:	29 d0                	sub    %edx,%eax
  8013c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8013c7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8013ce:	e8 74 08 00 00       	call   801c47 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	74 2d                	je     801404 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8013d7:	83 ec 0c             	sub    $0xc,%esp
  8013da:	ff 75 ec             	pushl  -0x14(%ebp)
  8013dd:	e8 52 0e 00 00       	call   802234 <alloc_block_FF>
  8013e2:	83 c4 10             	add    $0x10,%esp
  8013e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8013e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8013ec:	74 16                	je     801404 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8013ee:	83 ec 0c             	sub    $0xc,%esp
  8013f1:	ff 75 e8             	pushl  -0x18(%ebp)
  8013f4:	e8 3b 0c 00 00       	call   802034 <insert_sorted_allocList>
  8013f9:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8013fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8013ff:	8b 40 08             	mov    0x8(%eax),%eax
  801402:	eb 05                	jmp    801409 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801404:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801411:	8b 45 08             	mov    0x8(%ebp),%eax
  801414:	83 ec 08             	sub    $0x8,%esp
  801417:	50                   	push   %eax
  801418:	68 40 40 80 00       	push   $0x804040
  80141d:	e8 ba 0b 00 00       	call   801fdc <find_block>
  801422:	83 c4 10             	add    $0x10,%esp
  801425:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801428:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80142b:	8b 40 0c             	mov    0xc(%eax),%eax
  80142e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801431:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801435:	0f 84 9f 00 00 00    	je     8014da <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	83 ec 08             	sub    $0x8,%esp
  801441:	ff 75 f0             	pushl  -0x10(%ebp)
  801444:	50                   	push   %eax
  801445:	e8 f7 03 00 00       	call   801841 <sys_free_user_mem>
  80144a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80144d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801451:	75 14                	jne    801467 <free+0x5c>
  801453:	83 ec 04             	sub    $0x4,%esp
  801456:	68 95 38 80 00       	push   $0x803895
  80145b:	6a 6a                	push   $0x6a
  80145d:	68 b3 38 80 00       	push   $0x8038b3
  801462:	e8 db 1a 00 00       	call   802f42 <_panic>
  801467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146a:	8b 00                	mov    (%eax),%eax
  80146c:	85 c0                	test   %eax,%eax
  80146e:	74 10                	je     801480 <free+0x75>
  801470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801473:	8b 00                	mov    (%eax),%eax
  801475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801478:	8b 52 04             	mov    0x4(%edx),%edx
  80147b:	89 50 04             	mov    %edx,0x4(%eax)
  80147e:	eb 0b                	jmp    80148b <free+0x80>
  801480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801483:	8b 40 04             	mov    0x4(%eax),%eax
  801486:	a3 44 40 80 00       	mov    %eax,0x804044
  80148b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148e:	8b 40 04             	mov    0x4(%eax),%eax
  801491:	85 c0                	test   %eax,%eax
  801493:	74 0f                	je     8014a4 <free+0x99>
  801495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801498:	8b 40 04             	mov    0x4(%eax),%eax
  80149b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80149e:	8b 12                	mov    (%edx),%edx
  8014a0:	89 10                	mov    %edx,(%eax)
  8014a2:	eb 0a                	jmp    8014ae <free+0xa3>
  8014a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a7:	8b 00                	mov    (%eax),%eax
  8014a9:	a3 40 40 80 00       	mov    %eax,0x804040
  8014ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014ba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014c1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8014c6:	48                   	dec    %eax
  8014c7:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d2:	e8 65 13 00 00       	call   80283c <insert_sorted_with_merge_freeList>
  8014d7:	83 c4 10             	add    $0x10,%esp
	}
}
  8014da:	90                   	nop
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    

008014dd <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	83 ec 28             	sub    $0x28,%esp
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014e9:	e8 f6 fc ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014ee:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014f2:	75 0a                	jne    8014fe <smalloc+0x21>
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f9:	e9 af 00 00 00       	jmp    8015ad <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8014fe:	e8 44 07 00 00       	call   801c47 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801503:	83 f8 01             	cmp    $0x1,%eax
  801506:	0f 85 9c 00 00 00    	jne    8015a8 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80150c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801513:	8b 55 0c             	mov    0xc(%ebp),%edx
  801516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801519:	01 d0                	add    %edx,%eax
  80151b:	48                   	dec    %eax
  80151c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80151f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801522:	ba 00 00 00 00       	mov    $0x0,%edx
  801527:	f7 75 f4             	divl   -0xc(%ebp)
  80152a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152d:	29 d0                	sub    %edx,%eax
  80152f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801532:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801539:	76 07                	jbe    801542 <smalloc+0x65>
			return NULL;
  80153b:	b8 00 00 00 00       	mov    $0x0,%eax
  801540:	eb 6b                	jmp    8015ad <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801542:	83 ec 0c             	sub    $0xc,%esp
  801545:	ff 75 0c             	pushl  0xc(%ebp)
  801548:	e8 e7 0c 00 00       	call   802234 <alloc_block_FF>
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801553:	83 ec 0c             	sub    $0xc,%esp
  801556:	ff 75 ec             	pushl  -0x14(%ebp)
  801559:	e8 d6 0a 00 00       	call   802034 <insert_sorted_allocList>
  80155e:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801561:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801565:	75 07                	jne    80156e <smalloc+0x91>
		{
			return NULL;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
  80156c:	eb 3f                	jmp    8015ad <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80156e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801571:	8b 40 08             	mov    0x8(%eax),%eax
  801574:	89 c2                	mov    %eax,%edx
  801576:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80157a:	52                   	push   %edx
  80157b:	50                   	push   %eax
  80157c:	ff 75 0c             	pushl  0xc(%ebp)
  80157f:	ff 75 08             	pushl  0x8(%ebp)
  801582:	e8 45 04 00 00       	call   8019cc <sys_createSharedObject>
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80158d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801591:	74 06                	je     801599 <smalloc+0xbc>
  801593:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801597:	75 07                	jne    8015a0 <smalloc+0xc3>
		{
			return NULL;
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
  80159e:	eb 0d                	jmp    8015ad <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8015a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a3:	8b 40 08             	mov    0x8(%eax),%eax
  8015a6:	eb 05                	jmp    8015ad <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8015a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ad:	c9                   	leave  
  8015ae:	c3                   	ret    

008015af <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b5:	e8 2a fc ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	ff 75 0c             	pushl  0xc(%ebp)
  8015c0:	ff 75 08             	pushl  0x8(%ebp)
  8015c3:	e8 2e 04 00 00       	call   8019f6 <sys_getSizeOfSharedObject>
  8015c8:	83 c4 10             	add    $0x10,%esp
  8015cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8015ce:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8015d2:	75 0a                	jne    8015de <sget+0x2f>
	{
		return NULL;
  8015d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d9:	e9 94 00 00 00       	jmp    801672 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015de:	e8 64 06 00 00       	call   801c47 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	0f 84 82 00 00 00    	je     80166d <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8015eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8015f2:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8015f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ff:	01 d0                	add    %edx,%eax
  801601:	48                   	dec    %eax
  801602:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801605:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801608:	ba 00 00 00 00       	mov    $0x0,%edx
  80160d:	f7 75 ec             	divl   -0x14(%ebp)
  801610:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801613:	29 d0                	sub    %edx,%eax
  801615:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801618:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161b:	83 ec 0c             	sub    $0xc,%esp
  80161e:	50                   	push   %eax
  80161f:	e8 10 0c 00 00       	call   802234 <alloc_block_FF>
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80162a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80162e:	75 07                	jne    801637 <sget+0x88>
		{
			return NULL;
  801630:	b8 00 00 00 00       	mov    $0x0,%eax
  801635:	eb 3b                	jmp    801672 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801637:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163a:	8b 40 08             	mov    0x8(%eax),%eax
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	50                   	push   %eax
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	ff 75 08             	pushl  0x8(%ebp)
  801647:	e8 c7 03 00 00       	call   801a13 <sys_getSharedObject>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801652:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801656:	74 06                	je     80165e <sget+0xaf>
  801658:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80165c:	75 07                	jne    801665 <sget+0xb6>
		{
			return NULL;
  80165e:	b8 00 00 00 00       	mov    $0x0,%eax
  801663:	eb 0d                	jmp    801672 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801668:	8b 40 08             	mov    0x8(%eax),%eax
  80166b:	eb 05                	jmp    801672 <sget+0xc3>
		}
	}
	else
			return NULL;
  80166d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
  801677:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80167a:	e8 65 fb ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80167f:	83 ec 04             	sub    $0x4,%esp
  801682:	68 c0 38 80 00       	push   $0x8038c0
  801687:	68 e1 00 00 00       	push   $0xe1
  80168c:	68 b3 38 80 00       	push   $0x8038b3
  801691:	e8 ac 18 00 00       	call   802f42 <_panic>

00801696 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80169c:	83 ec 04             	sub    $0x4,%esp
  80169f:	68 e8 38 80 00       	push   $0x8038e8
  8016a4:	68 f5 00 00 00       	push   $0xf5
  8016a9:	68 b3 38 80 00       	push   $0x8038b3
  8016ae:	e8 8f 18 00 00       	call   802f42 <_panic>

008016b3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b9:	83 ec 04             	sub    $0x4,%esp
  8016bc:	68 0c 39 80 00       	push   $0x80390c
  8016c1:	68 00 01 00 00       	push   $0x100
  8016c6:	68 b3 38 80 00       	push   $0x8038b3
  8016cb:	e8 72 18 00 00       	call   802f42 <_panic>

008016d0 <shrink>:

}
void shrink(uint32 newSize)
{
  8016d0:	55                   	push   %ebp
  8016d1:	89 e5                	mov    %esp,%ebp
  8016d3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016d6:	83 ec 04             	sub    $0x4,%esp
  8016d9:	68 0c 39 80 00       	push   $0x80390c
  8016de:	68 05 01 00 00       	push   $0x105
  8016e3:	68 b3 38 80 00       	push   $0x8038b3
  8016e8:	e8 55 18 00 00       	call   802f42 <_panic>

008016ed <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	68 0c 39 80 00       	push   $0x80390c
  8016fb:	68 0a 01 00 00       	push   $0x10a
  801700:	68 b3 38 80 00       	push   $0x8038b3
  801705:	e8 38 18 00 00       	call   802f42 <_panic>

0080170a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	57                   	push   %edi
  80170e:	56                   	push   %esi
  80170f:	53                   	push   %ebx
  801710:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	8b 55 0c             	mov    0xc(%ebp),%edx
  801719:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80171c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80171f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801722:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801725:	cd 30                	int    $0x30
  801727:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80172a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80172d:	83 c4 10             	add    $0x10,%esp
  801730:	5b                   	pop    %ebx
  801731:	5e                   	pop    %esi
  801732:	5f                   	pop    %edi
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    

00801735 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	83 ec 04             	sub    $0x4,%esp
  80173b:	8b 45 10             	mov    0x10(%ebp),%eax
  80173e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801741:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801745:	8b 45 08             	mov    0x8(%ebp),%eax
  801748:	6a 00                	push   $0x0
  80174a:	6a 00                	push   $0x0
  80174c:	52                   	push   %edx
  80174d:	ff 75 0c             	pushl  0xc(%ebp)
  801750:	50                   	push   %eax
  801751:	6a 00                	push   $0x0
  801753:	e8 b2 ff ff ff       	call   80170a <syscall>
  801758:	83 c4 18             	add    $0x18,%esp
}
  80175b:	90                   	nop
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <sys_cgetc>:

int
sys_cgetc(void)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801761:	6a 00                	push   $0x0
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	6a 00                	push   $0x0
  80176b:	6a 01                	push   $0x1
  80176d:	e8 98 ff ff ff       	call   80170a <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80177a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	6a 05                	push   $0x5
  80178a:	e8 7b ff ff ff       	call   80170a <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	c9                   	leave  
  801793:	c3                   	ret    

00801794 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801794:	55                   	push   %ebp
  801795:	89 e5                	mov    %esp,%ebp
  801797:	56                   	push   %esi
  801798:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801799:	8b 75 18             	mov    0x18(%ebp),%esi
  80179c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80179f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a8:	56                   	push   %esi
  8017a9:	53                   	push   %ebx
  8017aa:	51                   	push   %ecx
  8017ab:	52                   	push   %edx
  8017ac:	50                   	push   %eax
  8017ad:	6a 06                	push   $0x6
  8017af:	e8 56 ff ff ff       	call   80170a <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ba:	5b                   	pop    %ebx
  8017bb:	5e                   	pop    %esi
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    

008017be <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	52                   	push   %edx
  8017ce:	50                   	push   %eax
  8017cf:	6a 07                	push   $0x7
  8017d1:	e8 34 ff ff ff       	call   80170a <syscall>
  8017d6:	83 c4 18             	add    $0x18,%esp
}
  8017d9:	c9                   	leave  
  8017da:	c3                   	ret    

008017db <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017de:	6a 00                	push   $0x0
  8017e0:	6a 00                	push   $0x0
  8017e2:	6a 00                	push   $0x0
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	ff 75 08             	pushl  0x8(%ebp)
  8017ea:	6a 08                	push   $0x8
  8017ec:	e8 19 ff ff ff       	call   80170a <syscall>
  8017f1:	83 c4 18             	add    $0x18,%esp
}
  8017f4:	c9                   	leave  
  8017f5:	c3                   	ret    

008017f6 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017f9:	6a 00                	push   $0x0
  8017fb:	6a 00                	push   $0x0
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	6a 00                	push   $0x0
  801803:	6a 09                	push   $0x9
  801805:	e8 00 ff ff ff       	call   80170a <syscall>
  80180a:	83 c4 18             	add    $0x18,%esp
}
  80180d:	c9                   	leave  
  80180e:	c3                   	ret    

0080180f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801812:	6a 00                	push   $0x0
  801814:	6a 00                	push   $0x0
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 0a                	push   $0xa
  80181e:	e8 e7 fe ff ff       	call   80170a <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	c9                   	leave  
  801827:	c3                   	ret    

00801828 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80182b:	6a 00                	push   $0x0
  80182d:	6a 00                	push   $0x0
  80182f:	6a 00                	push   $0x0
  801831:	6a 00                	push   $0x0
  801833:	6a 00                	push   $0x0
  801835:	6a 0b                	push   $0xb
  801837:	e8 ce fe ff ff       	call   80170a <syscall>
  80183c:	83 c4 18             	add    $0x18,%esp
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801844:	6a 00                	push   $0x0
  801846:	6a 00                	push   $0x0
  801848:	6a 00                	push   $0x0
  80184a:	ff 75 0c             	pushl  0xc(%ebp)
  80184d:	ff 75 08             	pushl  0x8(%ebp)
  801850:	6a 0f                	push   $0xf
  801852:	e8 b3 fe ff ff       	call   80170a <syscall>
  801857:	83 c4 18             	add    $0x18,%esp
	return;
  80185a:	90                   	nop
}
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	ff 75 08             	pushl  0x8(%ebp)
  80186c:	6a 10                	push   $0x10
  80186e:	e8 97 fe ff ff       	call   80170a <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
	return ;
  801876:	90                   	nop
}
  801877:	c9                   	leave  
  801878:	c3                   	ret    

00801879 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	ff 75 10             	pushl  0x10(%ebp)
  801883:	ff 75 0c             	pushl  0xc(%ebp)
  801886:	ff 75 08             	pushl  0x8(%ebp)
  801889:	6a 11                	push   $0x11
  80188b:	e8 7a fe ff ff       	call   80170a <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
	return ;
  801893:	90                   	nop
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 00                	push   $0x0
  8018a1:	6a 00                	push   $0x0
  8018a3:	6a 0c                	push   $0xc
  8018a5:	e8 60 fe ff ff       	call   80170a <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
}
  8018ad:	c9                   	leave  
  8018ae:	c3                   	ret    

008018af <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 00                	push   $0x0
  8018ba:	ff 75 08             	pushl  0x8(%ebp)
  8018bd:	6a 0d                	push   $0xd
  8018bf:	e8 46 fe ff ff       	call   80170a <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 0e                	push   $0xe
  8018d8:	e8 2d fe ff ff       	call   80170a <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	90                   	nop
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 13                	push   $0x13
  8018f2:	e8 13 fe ff ff       	call   80170a <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	90                   	nop
  8018fb:	c9                   	leave  
  8018fc:	c3                   	ret    

008018fd <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 14                	push   $0x14
  80190c:	e8 f9 fd ff ff       	call   80170a <syscall>
  801911:	83 c4 18             	add    $0x18,%esp
}
  801914:	90                   	nop
  801915:	c9                   	leave  
  801916:	c3                   	ret    

00801917 <sys_cputc>:


void
sys_cputc(const char c)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 04             	sub    $0x4,%esp
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801923:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	50                   	push   %eax
  801930:	6a 15                	push   $0x15
  801932:	e8 d3 fd ff ff       	call   80170a <syscall>
  801937:	83 c4 18             	add    $0x18,%esp
}
  80193a:	90                   	nop
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    

0080193d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 16                	push   $0x16
  80194c:	e8 b9 fd ff ff       	call   80170a <syscall>
  801951:	83 c4 18             	add    $0x18,%esp
}
  801954:	90                   	nop
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80195a:	8b 45 08             	mov    0x8(%ebp),%eax
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	ff 75 0c             	pushl  0xc(%ebp)
  801966:	50                   	push   %eax
  801967:	6a 17                	push   $0x17
  801969:	e8 9c fd ff ff       	call   80170a <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801976:	8b 55 0c             	mov    0xc(%ebp),%edx
  801979:	8b 45 08             	mov    0x8(%ebp),%eax
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	52                   	push   %edx
  801983:	50                   	push   %eax
  801984:	6a 1a                	push   $0x1a
  801986:	e8 7f fd ff ff       	call   80170a <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801993:	8b 55 0c             	mov    0xc(%ebp),%edx
  801996:	8b 45 08             	mov    0x8(%ebp),%eax
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	52                   	push   %edx
  8019a0:	50                   	push   %eax
  8019a1:	6a 18                	push   $0x18
  8019a3:	e8 62 fd ff ff       	call   80170a <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	52                   	push   %edx
  8019be:	50                   	push   %eax
  8019bf:	6a 19                	push   $0x19
  8019c1:	e8 44 fd ff ff       	call   80170a <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8019d8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8019db:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	51                   	push   %ecx
  8019e5:	52                   	push   %edx
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	50                   	push   %eax
  8019ea:	6a 1b                	push   $0x1b
  8019ec:	e8 19 fd ff ff       	call   80170a <syscall>
  8019f1:	83 c4 18             	add    $0x18,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019f9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	52                   	push   %edx
  801a06:	50                   	push   %eax
  801a07:	6a 1c                	push   $0x1c
  801a09:	e8 fc fc ff ff       	call   80170a <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a16:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	51                   	push   %ecx
  801a24:	52                   	push   %edx
  801a25:	50                   	push   %eax
  801a26:	6a 1d                	push   $0x1d
  801a28:	e8 dd fc ff ff       	call   80170a <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	c9                   	leave  
  801a31:	c3                   	ret    

00801a32 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a38:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	52                   	push   %edx
  801a42:	50                   	push   %eax
  801a43:	6a 1e                	push   $0x1e
  801a45:	e8 c0 fc ff ff       	call   80170a <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 1f                	push   $0x1f
  801a5e:	e8 a7 fc ff ff       	call   80170a <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6e:	6a 00                	push   $0x0
  801a70:	ff 75 14             	pushl  0x14(%ebp)
  801a73:	ff 75 10             	pushl  0x10(%ebp)
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	50                   	push   %eax
  801a7a:	6a 20                	push   $0x20
  801a7c:	e8 89 fc ff ff       	call   80170a <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	50                   	push   %eax
  801a95:	6a 21                	push   $0x21
  801a97:	e8 6e fc ff ff       	call   80170a <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	90                   	nop
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	50                   	push   %eax
  801ab1:	6a 22                	push   $0x22
  801ab3:	e8 52 fc ff ff       	call   80170a <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 02                	push   $0x2
  801acc:	e8 39 fc ff ff       	call   80170a <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 03                	push   $0x3
  801ae5:	e8 20 fc ff ff       	call   80170a <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 04                	push   $0x4
  801afe:	e8 07 fc ff ff       	call   80170a <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_exit_env>:


void sys_exit_env(void)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 23                	push   $0x23
  801b17:	e8 ee fb ff ff       	call   80170a <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	90                   	nop
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b28:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b2b:	8d 50 04             	lea    0x4(%eax),%edx
  801b2e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	52                   	push   %edx
  801b38:	50                   	push   %eax
  801b39:	6a 24                	push   $0x24
  801b3b:	e8 ca fb ff ff       	call   80170a <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
	return result;
  801b43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b46:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b49:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b4c:	89 01                	mov    %eax,(%ecx)
  801b4e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	c9                   	leave  
  801b55:	c2 04 00             	ret    $0x4

00801b58 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b58:	55                   	push   %ebp
  801b59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	ff 75 10             	pushl  0x10(%ebp)
  801b62:	ff 75 0c             	pushl  0xc(%ebp)
  801b65:	ff 75 08             	pushl  0x8(%ebp)
  801b68:	6a 12                	push   $0x12
  801b6a:	e8 9b fb ff ff       	call   80170a <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
	return ;
  801b72:	90                   	nop
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 25                	push   $0x25
  801b84:	e8 81 fb ff ff       	call   80170a <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
  801b91:	83 ec 04             	sub    $0x4,%esp
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b9a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	50                   	push   %eax
  801ba7:	6a 26                	push   $0x26
  801ba9:	e8 5c fb ff ff       	call   80170a <syscall>
  801bae:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb1:	90                   	nop
}
  801bb2:	c9                   	leave  
  801bb3:	c3                   	ret    

00801bb4 <rsttst>:
void rsttst()
{
  801bb4:	55                   	push   %ebp
  801bb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 28                	push   $0x28
  801bc3:	e8 42 fb ff ff       	call   80170a <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
	return ;
  801bcb:	90                   	nop
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	83 ec 04             	sub    $0x4,%esp
  801bd4:	8b 45 14             	mov    0x14(%ebp),%eax
  801bd7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801bda:	8b 55 18             	mov    0x18(%ebp),%edx
  801bdd:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801be1:	52                   	push   %edx
  801be2:	50                   	push   %eax
  801be3:	ff 75 10             	pushl  0x10(%ebp)
  801be6:	ff 75 0c             	pushl  0xc(%ebp)
  801be9:	ff 75 08             	pushl  0x8(%ebp)
  801bec:	6a 27                	push   $0x27
  801bee:	e8 17 fb ff ff       	call   80170a <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801bf6:	90                   	nop
}
  801bf7:	c9                   	leave  
  801bf8:	c3                   	ret    

00801bf9 <chktst>:
void chktst(uint32 n)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	ff 75 08             	pushl  0x8(%ebp)
  801c07:	6a 29                	push   $0x29
  801c09:	e8 fc fa ff ff       	call   80170a <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
	return ;
  801c11:	90                   	nop
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <inctst>:

void inctst()
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 2a                	push   $0x2a
  801c23:	e8 e2 fa ff ff       	call   80170a <syscall>
  801c28:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2b:	90                   	nop
}
  801c2c:	c9                   	leave  
  801c2d:	c3                   	ret    

00801c2e <gettst>:
uint32 gettst()
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 2b                	push   $0x2b
  801c3d:	e8 c8 fa ff ff       	call   80170a <syscall>
  801c42:	83 c4 18             	add    $0x18,%esp
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 2c                	push   $0x2c
  801c59:	e8 ac fa ff ff       	call   80170a <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
  801c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c64:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c68:	75 07                	jne    801c71 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801c6f:	eb 05                	jmp    801c76 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 2c                	push   $0x2c
  801c8a:	e8 7b fa ff ff       	call   80170a <syscall>
  801c8f:	83 c4 18             	add    $0x18,%esp
  801c92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c95:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c99:	75 07                	jne    801ca2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c9b:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca0:	eb 05                	jmp    801ca7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 2c                	push   $0x2c
  801cbb:	e8 4a fa ff ff       	call   80170a <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
  801cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cc6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801cca:	75 07                	jne    801cd3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ccc:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd1:	eb 05                	jmp    801cd8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801cd3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 2c                	push   $0x2c
  801cec:	e8 19 fa ff ff       	call   80170a <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
  801cf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cf7:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cfb:	75 07                	jne    801d04 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cfd:	b8 01 00 00 00       	mov    $0x1,%eax
  801d02:	eb 05                	jmp    801d09 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d04:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	6a 2d                	push   $0x2d
  801d1b:	e8 ea f9 ff ff       	call   80170a <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
  801d29:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d2a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d33:	8b 45 08             	mov    0x8(%ebp),%eax
  801d36:	6a 00                	push   $0x0
  801d38:	53                   	push   %ebx
  801d39:	51                   	push   %ecx
  801d3a:	52                   	push   %edx
  801d3b:	50                   	push   %eax
  801d3c:	6a 2e                	push   $0x2e
  801d3e:	e8 c7 f9 ff ff       	call   80170a <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	52                   	push   %edx
  801d5b:	50                   	push   %eax
  801d5c:	6a 2f                	push   $0x2f
  801d5e:	e8 a7 f9 ff ff       	call   80170a <syscall>
  801d63:	83 c4 18             	add    $0x18,%esp
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
  801d6b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d6e:	83 ec 0c             	sub    $0xc,%esp
  801d71:	68 1c 39 80 00       	push   $0x80391c
  801d76:	e8 df e6 ff ff       	call   80045a <cprintf>
  801d7b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d7e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d85:	83 ec 0c             	sub    $0xc,%esp
  801d88:	68 48 39 80 00       	push   $0x803948
  801d8d:	e8 c8 e6 ff ff       	call   80045a <cprintf>
  801d92:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d95:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d99:	a1 38 41 80 00       	mov    0x804138,%eax
  801d9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801da1:	eb 56                	jmp    801df9 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801da3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801da7:	74 1c                	je     801dc5 <print_mem_block_lists+0x5d>
  801da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dac:	8b 50 08             	mov    0x8(%eax),%edx
  801daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db2:	8b 48 08             	mov    0x8(%eax),%ecx
  801db5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db8:	8b 40 0c             	mov    0xc(%eax),%eax
  801dbb:	01 c8                	add    %ecx,%eax
  801dbd:	39 c2                	cmp    %eax,%edx
  801dbf:	73 04                	jae    801dc5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801dc1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc8:	8b 50 08             	mov    0x8(%eax),%edx
  801dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dce:	8b 40 0c             	mov    0xc(%eax),%eax
  801dd1:	01 c2                	add    %eax,%edx
  801dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dd6:	8b 40 08             	mov    0x8(%eax),%eax
  801dd9:	83 ec 04             	sub    $0x4,%esp
  801ddc:	52                   	push   %edx
  801ddd:	50                   	push   %eax
  801dde:	68 5d 39 80 00       	push   $0x80395d
  801de3:	e8 72 e6 ff ff       	call   80045a <cprintf>
  801de8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801df1:	a1 40 41 80 00       	mov    0x804140,%eax
  801df6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801df9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dfd:	74 07                	je     801e06 <print_mem_block_lists+0x9e>
  801dff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e02:	8b 00                	mov    (%eax),%eax
  801e04:	eb 05                	jmp    801e0b <print_mem_block_lists+0xa3>
  801e06:	b8 00 00 00 00       	mov    $0x0,%eax
  801e0b:	a3 40 41 80 00       	mov    %eax,0x804140
  801e10:	a1 40 41 80 00       	mov    0x804140,%eax
  801e15:	85 c0                	test   %eax,%eax
  801e17:	75 8a                	jne    801da3 <print_mem_block_lists+0x3b>
  801e19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e1d:	75 84                	jne    801da3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801e1f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e23:	75 10                	jne    801e35 <print_mem_block_lists+0xcd>
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	68 6c 39 80 00       	push   $0x80396c
  801e2d:	e8 28 e6 ff ff       	call   80045a <cprintf>
  801e32:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801e35:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801e3c:	83 ec 0c             	sub    $0xc,%esp
  801e3f:	68 90 39 80 00       	push   $0x803990
  801e44:	e8 11 e6 ff ff       	call   80045a <cprintf>
  801e49:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e4c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e50:	a1 40 40 80 00       	mov    0x804040,%eax
  801e55:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e58:	eb 56                	jmp    801eb0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e5e:	74 1c                	je     801e7c <print_mem_block_lists+0x114>
  801e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e63:	8b 50 08             	mov    0x8(%eax),%edx
  801e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e69:	8b 48 08             	mov    0x8(%eax),%ecx
  801e6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e72:	01 c8                	add    %ecx,%eax
  801e74:	39 c2                	cmp    %eax,%edx
  801e76:	73 04                	jae    801e7c <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e78:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7f:	8b 50 08             	mov    0x8(%eax),%edx
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	8b 40 0c             	mov    0xc(%eax),%eax
  801e88:	01 c2                	add    %eax,%edx
  801e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8d:	8b 40 08             	mov    0x8(%eax),%eax
  801e90:	83 ec 04             	sub    $0x4,%esp
  801e93:	52                   	push   %edx
  801e94:	50                   	push   %eax
  801e95:	68 5d 39 80 00       	push   $0x80395d
  801e9a:	e8 bb e5 ff ff       	call   80045a <cprintf>
  801e9f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ea8:	a1 48 40 80 00       	mov    0x804048,%eax
  801ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb4:	74 07                	je     801ebd <print_mem_block_lists+0x155>
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	8b 00                	mov    (%eax),%eax
  801ebb:	eb 05                	jmp    801ec2 <print_mem_block_lists+0x15a>
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec2:	a3 48 40 80 00       	mov    %eax,0x804048
  801ec7:	a1 48 40 80 00       	mov    0x804048,%eax
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	75 8a                	jne    801e5a <print_mem_block_lists+0xf2>
  801ed0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed4:	75 84                	jne    801e5a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ed6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eda:	75 10                	jne    801eec <print_mem_block_lists+0x184>
  801edc:	83 ec 0c             	sub    $0xc,%esp
  801edf:	68 a8 39 80 00       	push   $0x8039a8
  801ee4:	e8 71 e5 ff ff       	call   80045a <cprintf>
  801ee9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801eec:	83 ec 0c             	sub    $0xc,%esp
  801eef:	68 1c 39 80 00       	push   $0x80391c
  801ef4:	e8 61 e5 ff ff       	call   80045a <cprintf>
  801ef9:	83 c4 10             	add    $0x10,%esp

}
  801efc:	90                   	nop
  801efd:	c9                   	leave  
  801efe:	c3                   	ret    

00801eff <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801eff:	55                   	push   %ebp
  801f00:	89 e5                	mov    %esp,%ebp
  801f02:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801f05:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801f0c:	00 00 00 
  801f0f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801f16:	00 00 00 
  801f19:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801f20:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  801f23:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801f2a:	e9 9e 00 00 00       	jmp    801fcd <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801f2f:	a1 50 40 80 00       	mov    0x804050,%eax
  801f34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f37:	c1 e2 04             	shl    $0x4,%edx
  801f3a:	01 d0                	add    %edx,%eax
  801f3c:	85 c0                	test   %eax,%eax
  801f3e:	75 14                	jne    801f54 <initialize_MemBlocksList+0x55>
  801f40:	83 ec 04             	sub    $0x4,%esp
  801f43:	68 d0 39 80 00       	push   $0x8039d0
  801f48:	6a 42                	push   $0x42
  801f4a:	68 f3 39 80 00       	push   $0x8039f3
  801f4f:	e8 ee 0f 00 00       	call   802f42 <_panic>
  801f54:	a1 50 40 80 00       	mov    0x804050,%eax
  801f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5c:	c1 e2 04             	shl    $0x4,%edx
  801f5f:	01 d0                	add    %edx,%eax
  801f61:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f67:	89 10                	mov    %edx,(%eax)
  801f69:	8b 00                	mov    (%eax),%eax
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	74 18                	je     801f87 <initialize_MemBlocksList+0x88>
  801f6f:	a1 48 41 80 00       	mov    0x804148,%eax
  801f74:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f7a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f7d:	c1 e1 04             	shl    $0x4,%ecx
  801f80:	01 ca                	add    %ecx,%edx
  801f82:	89 50 04             	mov    %edx,0x4(%eax)
  801f85:	eb 12                	jmp    801f99 <initialize_MemBlocksList+0x9a>
  801f87:	a1 50 40 80 00       	mov    0x804050,%eax
  801f8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8f:	c1 e2 04             	shl    $0x4,%edx
  801f92:	01 d0                	add    %edx,%eax
  801f94:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f99:	a1 50 40 80 00       	mov    0x804050,%eax
  801f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fa1:	c1 e2 04             	shl    $0x4,%edx
  801fa4:	01 d0                	add    %edx,%eax
  801fa6:	a3 48 41 80 00       	mov    %eax,0x804148
  801fab:	a1 50 40 80 00       	mov    0x804050,%eax
  801fb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fb3:	c1 e2 04             	shl    $0x4,%edx
  801fb6:	01 d0                	add    %edx,%eax
  801fb8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801fbf:	a1 54 41 80 00       	mov    0x804154,%eax
  801fc4:	40                   	inc    %eax
  801fc5:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  801fca:	ff 45 f4             	incl   -0xc(%ebp)
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	3b 45 08             	cmp    0x8(%ebp),%eax
  801fd3:	0f 82 56 ff ff ff    	jb     801f2f <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  801fd9:	90                   	nop
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  801fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe5:	8b 00                	mov    (%eax),%eax
  801fe7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  801fea:	eb 19                	jmp    802005 <find_block+0x29>
	{
		if(blk->sva==va)
  801fec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fef:	8b 40 08             	mov    0x8(%eax),%eax
  801ff2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801ff5:	75 05                	jne    801ffc <find_block+0x20>
			return (blk);
  801ff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ffa:	eb 36                	jmp    802032 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	8b 40 08             	mov    0x8(%eax),%eax
  802002:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802005:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802009:	74 07                	je     802012 <find_block+0x36>
  80200b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80200e:	8b 00                	mov    (%eax),%eax
  802010:	eb 05                	jmp    802017 <find_block+0x3b>
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
  802017:	8b 55 08             	mov    0x8(%ebp),%edx
  80201a:	89 42 08             	mov    %eax,0x8(%edx)
  80201d:	8b 45 08             	mov    0x8(%ebp),%eax
  802020:	8b 40 08             	mov    0x8(%eax),%eax
  802023:	85 c0                	test   %eax,%eax
  802025:	75 c5                	jne    801fec <find_block+0x10>
  802027:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80202b:	75 bf                	jne    801fec <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80203a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80203f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802042:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802049:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80204f:	75 65                	jne    8020b6 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802051:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802055:	75 14                	jne    80206b <insert_sorted_allocList+0x37>
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	68 d0 39 80 00       	push   $0x8039d0
  80205f:	6a 5c                	push   $0x5c
  802061:	68 f3 39 80 00       	push   $0x8039f3
  802066:	e8 d7 0e 00 00       	call   802f42 <_panic>
  80206b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	89 10                	mov    %edx,(%eax)
  802076:	8b 45 08             	mov    0x8(%ebp),%eax
  802079:	8b 00                	mov    (%eax),%eax
  80207b:	85 c0                	test   %eax,%eax
  80207d:	74 0d                	je     80208c <insert_sorted_allocList+0x58>
  80207f:	a1 40 40 80 00       	mov    0x804040,%eax
  802084:	8b 55 08             	mov    0x8(%ebp),%edx
  802087:	89 50 04             	mov    %edx,0x4(%eax)
  80208a:	eb 08                	jmp    802094 <insert_sorted_allocList+0x60>
  80208c:	8b 45 08             	mov    0x8(%ebp),%eax
  80208f:	a3 44 40 80 00       	mov    %eax,0x804044
  802094:	8b 45 08             	mov    0x8(%ebp),%eax
  802097:	a3 40 40 80 00       	mov    %eax,0x804040
  80209c:	8b 45 08             	mov    0x8(%ebp),%eax
  80209f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020ab:	40                   	inc    %eax
  8020ac:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8020b1:	e9 7b 01 00 00       	jmp    802231 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8020b6:	a1 44 40 80 00       	mov    0x804044,%eax
  8020bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8020be:	a1 40 40 80 00       	mov    0x804040,%eax
  8020c3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8020c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c9:	8b 50 08             	mov    0x8(%eax),%edx
  8020cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020cf:	8b 40 08             	mov    0x8(%eax),%eax
  8020d2:	39 c2                	cmp    %eax,%edx
  8020d4:	76 65                	jbe    80213b <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8020d6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020da:	75 14                	jne    8020f0 <insert_sorted_allocList+0xbc>
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	68 0c 3a 80 00       	push   $0x803a0c
  8020e4:	6a 64                	push   $0x64
  8020e6:	68 f3 39 80 00       	push   $0x8039f3
  8020eb:	e8 52 0e 00 00       	call   802f42 <_panic>
  8020f0:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	89 50 04             	mov    %edx,0x4(%eax)
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	8b 40 04             	mov    0x4(%eax),%eax
  802102:	85 c0                	test   %eax,%eax
  802104:	74 0c                	je     802112 <insert_sorted_allocList+0xde>
  802106:	a1 44 40 80 00       	mov    0x804044,%eax
  80210b:	8b 55 08             	mov    0x8(%ebp),%edx
  80210e:	89 10                	mov    %edx,(%eax)
  802110:	eb 08                	jmp    80211a <insert_sorted_allocList+0xe6>
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	a3 40 40 80 00       	mov    %eax,0x804040
  80211a:	8b 45 08             	mov    0x8(%ebp),%eax
  80211d:	a3 44 40 80 00       	mov    %eax,0x804044
  802122:	8b 45 08             	mov    0x8(%ebp),%eax
  802125:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80212b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802130:	40                   	inc    %eax
  802131:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802136:	e9 f6 00 00 00       	jmp    802231 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	8b 50 08             	mov    0x8(%eax),%edx
  802141:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802144:	8b 40 08             	mov    0x8(%eax),%eax
  802147:	39 c2                	cmp    %eax,%edx
  802149:	73 65                	jae    8021b0 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80214b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80214f:	75 14                	jne    802165 <insert_sorted_allocList+0x131>
  802151:	83 ec 04             	sub    $0x4,%esp
  802154:	68 d0 39 80 00       	push   $0x8039d0
  802159:	6a 68                	push   $0x68
  80215b:	68 f3 39 80 00       	push   $0x8039f3
  802160:	e8 dd 0d 00 00       	call   802f42 <_panic>
  802165:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	89 10                	mov    %edx,(%eax)
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	8b 00                	mov    (%eax),%eax
  802175:	85 c0                	test   %eax,%eax
  802177:	74 0d                	je     802186 <insert_sorted_allocList+0x152>
  802179:	a1 40 40 80 00       	mov    0x804040,%eax
  80217e:	8b 55 08             	mov    0x8(%ebp),%edx
  802181:	89 50 04             	mov    %edx,0x4(%eax)
  802184:	eb 08                	jmp    80218e <insert_sorted_allocList+0x15a>
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	a3 44 40 80 00       	mov    %eax,0x804044
  80218e:	8b 45 08             	mov    0x8(%ebp),%eax
  802191:	a3 40 40 80 00       	mov    %eax,0x804040
  802196:	8b 45 08             	mov    0x8(%ebp),%eax
  802199:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021a5:	40                   	inc    %eax
  8021a6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8021ab:	e9 81 00 00 00       	jmp    802231 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8021b0:	a1 40 40 80 00       	mov    0x804040,%eax
  8021b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021b8:	eb 51                	jmp    80220b <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8021ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bd:	8b 50 08             	mov    0x8(%eax),%edx
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 40 08             	mov    0x8(%eax),%eax
  8021c6:	39 c2                	cmp    %eax,%edx
  8021c8:	73 39                	jae    802203 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	8b 40 04             	mov    0x4(%eax),%eax
  8021d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8021d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021e1:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8021e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021ea:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8021ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f2:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8021f5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021fa:	40                   	inc    %eax
  8021fb:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802200:	90                   	nop
				}
			}
		 }

	}
}
  802201:	eb 2e                	jmp    802231 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802203:	a1 48 40 80 00       	mov    0x804048,%eax
  802208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80220b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80220f:	74 07                	je     802218 <insert_sorted_allocList+0x1e4>
  802211:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802214:	8b 00                	mov    (%eax),%eax
  802216:	eb 05                	jmp    80221d <insert_sorted_allocList+0x1e9>
  802218:	b8 00 00 00 00       	mov    $0x0,%eax
  80221d:	a3 48 40 80 00       	mov    %eax,0x804048
  802222:	a1 48 40 80 00       	mov    0x804048,%eax
  802227:	85 c0                	test   %eax,%eax
  802229:	75 8f                	jne    8021ba <insert_sorted_allocList+0x186>
  80222b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80222f:	75 89                	jne    8021ba <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802231:	90                   	nop
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80223a:	a1 38 41 80 00       	mov    0x804138,%eax
  80223f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802242:	e9 76 01 00 00       	jmp    8023bd <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802247:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224a:	8b 40 0c             	mov    0xc(%eax),%eax
  80224d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802250:	0f 85 8a 00 00 00    	jne    8022e0 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802256:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80225a:	75 17                	jne    802273 <alloc_block_FF+0x3f>
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	68 2f 3a 80 00       	push   $0x803a2f
  802264:	68 8a 00 00 00       	push   $0x8a
  802269:	68 f3 39 80 00       	push   $0x8039f3
  80226e:	e8 cf 0c 00 00       	call   802f42 <_panic>
  802273:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802276:	8b 00                	mov    (%eax),%eax
  802278:	85 c0                	test   %eax,%eax
  80227a:	74 10                	je     80228c <alloc_block_FF+0x58>
  80227c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80227f:	8b 00                	mov    (%eax),%eax
  802281:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802284:	8b 52 04             	mov    0x4(%edx),%edx
  802287:	89 50 04             	mov    %edx,0x4(%eax)
  80228a:	eb 0b                	jmp    802297 <alloc_block_FF+0x63>
  80228c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228f:	8b 40 04             	mov    0x4(%eax),%eax
  802292:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229a:	8b 40 04             	mov    0x4(%eax),%eax
  80229d:	85 c0                	test   %eax,%eax
  80229f:	74 0f                	je     8022b0 <alloc_block_FF+0x7c>
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 40 04             	mov    0x4(%eax),%eax
  8022a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022aa:	8b 12                	mov    (%edx),%edx
  8022ac:	89 10                	mov    %edx,(%eax)
  8022ae:	eb 0a                	jmp    8022ba <alloc_block_FF+0x86>
  8022b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b3:	8b 00                	mov    (%eax),%eax
  8022b5:	a3 38 41 80 00       	mov    %eax,0x804138
  8022ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022cd:	a1 44 41 80 00       	mov    0x804144,%eax
  8022d2:	48                   	dec    %eax
  8022d3:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8022d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022db:	e9 10 01 00 00       	jmp    8023f0 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8022e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022e6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8022e9:	0f 86 c6 00 00 00    	jbe    8023b5 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8022ef:	a1 48 41 80 00       	mov    0x804148,%eax
  8022f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8022f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8022fb:	75 17                	jne    802314 <alloc_block_FF+0xe0>
  8022fd:	83 ec 04             	sub    $0x4,%esp
  802300:	68 2f 3a 80 00       	push   $0x803a2f
  802305:	68 90 00 00 00       	push   $0x90
  80230a:	68 f3 39 80 00       	push   $0x8039f3
  80230f:	e8 2e 0c 00 00       	call   802f42 <_panic>
  802314:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802317:	8b 00                	mov    (%eax),%eax
  802319:	85 c0                	test   %eax,%eax
  80231b:	74 10                	je     80232d <alloc_block_FF+0xf9>
  80231d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802320:	8b 00                	mov    (%eax),%eax
  802322:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802325:	8b 52 04             	mov    0x4(%edx),%edx
  802328:	89 50 04             	mov    %edx,0x4(%eax)
  80232b:	eb 0b                	jmp    802338 <alloc_block_FF+0x104>
  80232d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802330:	8b 40 04             	mov    0x4(%eax),%eax
  802333:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802338:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80233b:	8b 40 04             	mov    0x4(%eax),%eax
  80233e:	85 c0                	test   %eax,%eax
  802340:	74 0f                	je     802351 <alloc_block_FF+0x11d>
  802342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802345:	8b 40 04             	mov    0x4(%eax),%eax
  802348:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80234b:	8b 12                	mov    (%edx),%edx
  80234d:	89 10                	mov    %edx,(%eax)
  80234f:	eb 0a                	jmp    80235b <alloc_block_FF+0x127>
  802351:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802354:	8b 00                	mov    (%eax),%eax
  802356:	a3 48 41 80 00       	mov    %eax,0x804148
  80235b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80236e:	a1 54 41 80 00       	mov    0x804154,%eax
  802373:	48                   	dec    %eax
  802374:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802379:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237c:	8b 55 08             	mov    0x8(%ebp),%edx
  80237f:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 50 08             	mov    0x8(%eax),%edx
  802388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238b:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	8b 50 08             	mov    0x8(%eax),%edx
  802394:	8b 45 08             	mov    0x8(%ebp),%eax
  802397:	01 c2                	add    %eax,%edx
  802399:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239c:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a5:	2b 45 08             	sub    0x8(%ebp),%eax
  8023a8:	89 c2                	mov    %eax,%edx
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8023b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b3:	eb 3b                	jmp    8023f0 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8023b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8023ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c1:	74 07                	je     8023ca <alloc_block_FF+0x196>
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	8b 00                	mov    (%eax),%eax
  8023c8:	eb 05                	jmp    8023cf <alloc_block_FF+0x19b>
  8023ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8023cf:	a3 40 41 80 00       	mov    %eax,0x804140
  8023d4:	a1 40 41 80 00       	mov    0x804140,%eax
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	0f 85 66 fe ff ff    	jne    802247 <alloc_block_FF+0x13>
  8023e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e5:	0f 85 5c fe ff ff    	jne    802247 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8023eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8023f8:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8023ff:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802406:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80240d:	a1 38 41 80 00       	mov    0x804138,%eax
  802412:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802415:	e9 cf 00 00 00       	jmp    8024e9 <alloc_block_BF+0xf7>
		{
			c++;
  80241a:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80241d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802420:	8b 40 0c             	mov    0xc(%eax),%eax
  802423:	3b 45 08             	cmp    0x8(%ebp),%eax
  802426:	0f 85 8a 00 00 00    	jne    8024b6 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80242c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802430:	75 17                	jne    802449 <alloc_block_BF+0x57>
  802432:	83 ec 04             	sub    $0x4,%esp
  802435:	68 2f 3a 80 00       	push   $0x803a2f
  80243a:	68 a8 00 00 00       	push   $0xa8
  80243f:	68 f3 39 80 00       	push   $0x8039f3
  802444:	e8 f9 0a 00 00       	call   802f42 <_panic>
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	74 10                	je     802462 <alloc_block_BF+0x70>
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 00                	mov    (%eax),%eax
  802457:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80245a:	8b 52 04             	mov    0x4(%edx),%edx
  80245d:	89 50 04             	mov    %edx,0x4(%eax)
  802460:	eb 0b                	jmp    80246d <alloc_block_BF+0x7b>
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 40 04             	mov    0x4(%eax),%eax
  802468:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 40 04             	mov    0x4(%eax),%eax
  802473:	85 c0                	test   %eax,%eax
  802475:	74 0f                	je     802486 <alloc_block_BF+0x94>
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 40 04             	mov    0x4(%eax),%eax
  80247d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802480:	8b 12                	mov    (%edx),%edx
  802482:	89 10                	mov    %edx,(%eax)
  802484:	eb 0a                	jmp    802490 <alloc_block_BF+0x9e>
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	8b 00                	mov    (%eax),%eax
  80248b:	a3 38 41 80 00       	mov    %eax,0x804138
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8024a8:	48                   	dec    %eax
  8024a9:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8024ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b1:	e9 85 01 00 00       	jmp    80263b <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024bf:	76 20                	jbe    8024e1 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024c7:	2b 45 08             	sub    0x8(%ebp),%eax
  8024ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8024cd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024d0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8024d3:	73 0c                	jae    8024e1 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8024d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8024d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8024db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024de:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8024e1:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ed:	74 07                	je     8024f6 <alloc_block_BF+0x104>
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	8b 00                	mov    (%eax),%eax
  8024f4:	eb 05                	jmp    8024fb <alloc_block_BF+0x109>
  8024f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fb:	a3 40 41 80 00       	mov    %eax,0x804140
  802500:	a1 40 41 80 00       	mov    0x804140,%eax
  802505:	85 c0                	test   %eax,%eax
  802507:	0f 85 0d ff ff ff    	jne    80241a <alloc_block_BF+0x28>
  80250d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802511:	0f 85 03 ff ff ff    	jne    80241a <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802517:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80251e:	a1 38 41 80 00       	mov    0x804138,%eax
  802523:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802526:	e9 dd 00 00 00       	jmp    802608 <alloc_block_BF+0x216>
		{
			if(x==sol)
  80252b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80252e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802531:	0f 85 c6 00 00 00    	jne    8025fd <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802537:	a1 48 41 80 00       	mov    0x804148,%eax
  80253c:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80253f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802543:	75 17                	jne    80255c <alloc_block_BF+0x16a>
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 2f 3a 80 00       	push   $0x803a2f
  80254d:	68 bb 00 00 00       	push   $0xbb
  802552:	68 f3 39 80 00       	push   $0x8039f3
  802557:	e8 e6 09 00 00       	call   802f42 <_panic>
  80255c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80255f:	8b 00                	mov    (%eax),%eax
  802561:	85 c0                	test   %eax,%eax
  802563:	74 10                	je     802575 <alloc_block_BF+0x183>
  802565:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80256d:	8b 52 04             	mov    0x4(%edx),%edx
  802570:	89 50 04             	mov    %edx,0x4(%eax)
  802573:	eb 0b                	jmp    802580 <alloc_block_BF+0x18e>
  802575:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802578:	8b 40 04             	mov    0x4(%eax),%eax
  80257b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802580:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802583:	8b 40 04             	mov    0x4(%eax),%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	74 0f                	je     802599 <alloc_block_BF+0x1a7>
  80258a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80258d:	8b 40 04             	mov    0x4(%eax),%eax
  802590:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802593:	8b 12                	mov    (%edx),%edx
  802595:	89 10                	mov    %edx,(%eax)
  802597:	eb 0a                	jmp    8025a3 <alloc_block_BF+0x1b1>
  802599:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80259c:	8b 00                	mov    (%eax),%eax
  80259e:	a3 48 41 80 00       	mov    %eax,0x804148
  8025a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b6:	a1 54 41 80 00       	mov    0x804154,%eax
  8025bb:	48                   	dec    %eax
  8025bc:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8025c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8025c7:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	8b 50 08             	mov    0x8(%eax),%edx
  8025d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025d3:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	8b 50 08             	mov    0x8(%eax),%edx
  8025dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8025df:	01 c2                	add    %eax,%edx
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ed:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f0:	89 c2                	mov    %eax,%edx
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8025f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8025fb:	eb 3e                	jmp    80263b <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8025fd:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802600:	a1 40 41 80 00       	mov    0x804140,%eax
  802605:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260c:	74 07                	je     802615 <alloc_block_BF+0x223>
  80260e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802611:	8b 00                	mov    (%eax),%eax
  802613:	eb 05                	jmp    80261a <alloc_block_BF+0x228>
  802615:	b8 00 00 00 00       	mov    $0x0,%eax
  80261a:	a3 40 41 80 00       	mov    %eax,0x804140
  80261f:	a1 40 41 80 00       	mov    0x804140,%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	0f 85 ff fe ff ff    	jne    80252b <alloc_block_BF+0x139>
  80262c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802630:	0f 85 f5 fe ff ff    	jne    80252b <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802636:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263b:	c9                   	leave  
  80263c:	c3                   	ret    

0080263d <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80263d:	55                   	push   %ebp
  80263e:	89 e5                	mov    %esp,%ebp
  802640:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802643:	a1 28 40 80 00       	mov    0x804028,%eax
  802648:	85 c0                	test   %eax,%eax
  80264a:	75 14                	jne    802660 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80264c:	a1 38 41 80 00       	mov    0x804138,%eax
  802651:	a3 5c 41 80 00       	mov    %eax,0x80415c
		hh=1;
  802656:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80265d:	00 00 00 
	}
	uint32 c=1;
  802660:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802667:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80266c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80266f:	e9 b3 01 00 00       	jmp    802827 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802674:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802677:	8b 40 0c             	mov    0xc(%eax),%eax
  80267a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80267d:	0f 85 a9 00 00 00    	jne    80272c <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802683:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	85 c0                	test   %eax,%eax
  80268a:	75 0c                	jne    802698 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80268c:	a1 38 41 80 00       	mov    0x804138,%eax
  802691:	a3 5c 41 80 00       	mov    %eax,0x80415c
  802696:	eb 0a                	jmp    8026a2 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802698:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269b:	8b 00                	mov    (%eax),%eax
  80269d:	a3 5c 41 80 00       	mov    %eax,0x80415c
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8026a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026a6:	75 17                	jne    8026bf <alloc_block_NF+0x82>
  8026a8:	83 ec 04             	sub    $0x4,%esp
  8026ab:	68 2f 3a 80 00       	push   $0x803a2f
  8026b0:	68 e3 00 00 00       	push   $0xe3
  8026b5:	68 f3 39 80 00       	push   $0x8039f3
  8026ba:	e8 83 08 00 00       	call   802f42 <_panic>
  8026bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c2:	8b 00                	mov    (%eax),%eax
  8026c4:	85 c0                	test   %eax,%eax
  8026c6:	74 10                	je     8026d8 <alloc_block_NF+0x9b>
  8026c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026cb:	8b 00                	mov    (%eax),%eax
  8026cd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026d0:	8b 52 04             	mov    0x4(%edx),%edx
  8026d3:	89 50 04             	mov    %edx,0x4(%eax)
  8026d6:	eb 0b                	jmp    8026e3 <alloc_block_NF+0xa6>
  8026d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026db:	8b 40 04             	mov    0x4(%eax),%eax
  8026de:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8026e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e6:	8b 40 04             	mov    0x4(%eax),%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	74 0f                	je     8026fc <alloc_block_NF+0xbf>
  8026ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f0:	8b 40 04             	mov    0x4(%eax),%eax
  8026f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026f6:	8b 12                	mov    (%edx),%edx
  8026f8:	89 10                	mov    %edx,(%eax)
  8026fa:	eb 0a                	jmp    802706 <alloc_block_NF+0xc9>
  8026fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ff:	8b 00                	mov    (%eax),%eax
  802701:	a3 38 41 80 00       	mov    %eax,0x804138
  802706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802709:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80270f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802712:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802719:	a1 44 41 80 00       	mov    0x804144,%eax
  80271e:	48                   	dec    %eax
  80271f:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802724:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802727:	e9 0e 01 00 00       	jmp    80283a <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80272c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272f:	8b 40 0c             	mov    0xc(%eax),%eax
  802732:	3b 45 08             	cmp    0x8(%ebp),%eax
  802735:	0f 86 ce 00 00 00    	jbe    802809 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80273b:	a1 48 41 80 00       	mov    0x804148,%eax
  802740:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802743:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802747:	75 17                	jne    802760 <alloc_block_NF+0x123>
  802749:	83 ec 04             	sub    $0x4,%esp
  80274c:	68 2f 3a 80 00       	push   $0x803a2f
  802751:	68 e9 00 00 00       	push   $0xe9
  802756:	68 f3 39 80 00       	push   $0x8039f3
  80275b:	e8 e2 07 00 00       	call   802f42 <_panic>
  802760:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802763:	8b 00                	mov    (%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	74 10                	je     802779 <alloc_block_NF+0x13c>
  802769:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802771:	8b 52 04             	mov    0x4(%edx),%edx
  802774:	89 50 04             	mov    %edx,0x4(%eax)
  802777:	eb 0b                	jmp    802784 <alloc_block_NF+0x147>
  802779:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277c:	8b 40 04             	mov    0x4(%eax),%eax
  80277f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 0f                	je     80279d <alloc_block_NF+0x160>
  80278e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802791:	8b 40 04             	mov    0x4(%eax),%eax
  802794:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802797:	8b 12                	mov    (%edx),%edx
  802799:	89 10                	mov    %edx,(%eax)
  80279b:	eb 0a                	jmp    8027a7 <alloc_block_NF+0x16a>
  80279d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	a3 48 41 80 00       	mov    %eax,0x804148
  8027a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ba:	a1 54 41 80 00       	mov    0x804154,%eax
  8027bf:	48                   	dec    %eax
  8027c0:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8027c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027cb:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8027ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d1:	8b 50 08             	mov    0x8(%eax),%edx
  8027d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d7:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8027da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dd:	8b 50 08             	mov    0x8(%eax),%edx
  8027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e3:	01 c2                	add    %eax,%edx
  8027e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e8:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f4:	89 c2                	mov    %eax,%edx
  8027f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f9:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8027fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ff:	a3 5c 41 80 00       	mov    %eax,0x80415c
				 return element1;
  802804:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802807:	eb 31                	jmp    80283a <alloc_block_NF+0x1fd>
			 }
		 c++;
  802809:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80280c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	85 c0                	test   %eax,%eax
  802813:	75 0a                	jne    80281f <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802815:	a1 38 41 80 00       	mov    0x804138,%eax
  80281a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80281d:	eb 08                	jmp    802827 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80281f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802822:	8b 00                	mov    (%eax),%eax
  802824:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802827:	a1 44 41 80 00       	mov    0x804144,%eax
  80282c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80282f:	0f 85 3f fe ff ff    	jne    802674 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802842:	a1 44 41 80 00       	mov    0x804144,%eax
  802847:	85 c0                	test   %eax,%eax
  802849:	75 68                	jne    8028b3 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80284b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80284f:	75 17                	jne    802868 <insert_sorted_with_merge_freeList+0x2c>
  802851:	83 ec 04             	sub    $0x4,%esp
  802854:	68 d0 39 80 00       	push   $0x8039d0
  802859:	68 0e 01 00 00       	push   $0x10e
  80285e:	68 f3 39 80 00       	push   $0x8039f3
  802863:	e8 da 06 00 00       	call   802f42 <_panic>
  802868:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	89 10                	mov    %edx,(%eax)
  802873:	8b 45 08             	mov    0x8(%ebp),%eax
  802876:	8b 00                	mov    (%eax),%eax
  802878:	85 c0                	test   %eax,%eax
  80287a:	74 0d                	je     802889 <insert_sorted_with_merge_freeList+0x4d>
  80287c:	a1 38 41 80 00       	mov    0x804138,%eax
  802881:	8b 55 08             	mov    0x8(%ebp),%edx
  802884:	89 50 04             	mov    %edx,0x4(%eax)
  802887:	eb 08                	jmp    802891 <insert_sorted_with_merge_freeList+0x55>
  802889:	8b 45 08             	mov    0x8(%ebp),%eax
  80288c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802891:	8b 45 08             	mov    0x8(%ebp),%eax
  802894:	a3 38 41 80 00       	mov    %eax,0x804138
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a3:	a1 44 41 80 00       	mov    0x804144,%eax
  8028a8:	40                   	inc    %eax
  8028a9:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8028ae:	e9 8c 06 00 00       	jmp    802f3f <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8028b3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8028bb:	a1 38 41 80 00       	mov    0x804138,%eax
  8028c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	8b 50 08             	mov    0x8(%eax),%edx
  8028c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028cc:	8b 40 08             	mov    0x8(%eax),%eax
  8028cf:	39 c2                	cmp    %eax,%edx
  8028d1:	0f 86 14 01 00 00    	jbe    8029eb <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8028d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028da:	8b 50 0c             	mov    0xc(%eax),%edx
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	8b 40 08             	mov    0x8(%eax),%eax
  8028e3:	01 c2                	add    %eax,%edx
  8028e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e8:	8b 40 08             	mov    0x8(%eax),%eax
  8028eb:	39 c2                	cmp    %eax,%edx
  8028ed:	0f 85 90 00 00 00    	jne    802983 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8028f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f6:	8b 50 0c             	mov    0xc(%eax),%edx
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ff:	01 c2                	add    %eax,%edx
  802901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802904:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80291b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291f:	75 17                	jne    802938 <insert_sorted_with_merge_freeList+0xfc>
  802921:	83 ec 04             	sub    $0x4,%esp
  802924:	68 d0 39 80 00       	push   $0x8039d0
  802929:	68 1b 01 00 00       	push   $0x11b
  80292e:	68 f3 39 80 00       	push   $0x8039f3
  802933:	e8 0a 06 00 00       	call   802f42 <_panic>
  802938:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	89 10                	mov    %edx,(%eax)
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	8b 00                	mov    (%eax),%eax
  802948:	85 c0                	test   %eax,%eax
  80294a:	74 0d                	je     802959 <insert_sorted_with_merge_freeList+0x11d>
  80294c:	a1 48 41 80 00       	mov    0x804148,%eax
  802951:	8b 55 08             	mov    0x8(%ebp),%edx
  802954:	89 50 04             	mov    %edx,0x4(%eax)
  802957:	eb 08                	jmp    802961 <insert_sorted_with_merge_freeList+0x125>
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	a3 48 41 80 00       	mov    %eax,0x804148
  802969:	8b 45 08             	mov    0x8(%ebp),%eax
  80296c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802973:	a1 54 41 80 00       	mov    0x804154,%eax
  802978:	40                   	inc    %eax
  802979:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  80297e:	e9 bc 05 00 00       	jmp    802f3f <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802983:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802987:	75 17                	jne    8029a0 <insert_sorted_with_merge_freeList+0x164>
  802989:	83 ec 04             	sub    $0x4,%esp
  80298c:	68 0c 3a 80 00       	push   $0x803a0c
  802991:	68 1f 01 00 00       	push   $0x11f
  802996:	68 f3 39 80 00       	push   $0x8039f3
  80299b:	e8 a2 05 00 00       	call   802f42 <_panic>
  8029a0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	89 50 04             	mov    %edx,0x4(%eax)
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	8b 40 04             	mov    0x4(%eax),%eax
  8029b2:	85 c0                	test   %eax,%eax
  8029b4:	74 0c                	je     8029c2 <insert_sorted_with_merge_freeList+0x186>
  8029b6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8029be:	89 10                	mov    %edx,(%eax)
  8029c0:	eb 08                	jmp    8029ca <insert_sorted_with_merge_freeList+0x18e>
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029db:	a1 44 41 80 00       	mov    0x804144,%eax
  8029e0:	40                   	inc    %eax
  8029e1:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8029e6:	e9 54 05 00 00       	jmp    802f3f <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	8b 50 08             	mov    0x8(%eax),%edx
  8029f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f4:	8b 40 08             	mov    0x8(%eax),%eax
  8029f7:	39 c2                	cmp    %eax,%edx
  8029f9:	0f 83 20 01 00 00    	jae    802b1f <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  8029ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802a02:	8b 50 0c             	mov    0xc(%eax),%edx
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	8b 40 08             	mov    0x8(%eax),%eax
  802a0b:	01 c2                	add    %eax,%edx
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	8b 40 08             	mov    0x8(%eax),%eax
  802a13:	39 c2                	cmp    %eax,%edx
  802a15:	0f 85 9c 00 00 00    	jne    802ab7 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1e:	8b 50 08             	mov    0x8(%eax),%edx
  802a21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a24:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802a27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a2a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	8b 40 0c             	mov    0xc(%eax),%eax
  802a33:	01 c2                	add    %eax,%edx
  802a35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a38:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a4f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a53:	75 17                	jne    802a6c <insert_sorted_with_merge_freeList+0x230>
  802a55:	83 ec 04             	sub    $0x4,%esp
  802a58:	68 d0 39 80 00       	push   $0x8039d0
  802a5d:	68 2a 01 00 00       	push   $0x12a
  802a62:	68 f3 39 80 00       	push   $0x8039f3
  802a67:	e8 d6 04 00 00       	call   802f42 <_panic>
  802a6c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	89 10                	mov    %edx,(%eax)
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	8b 00                	mov    (%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0d                	je     802a8d <insert_sorted_with_merge_freeList+0x251>
  802a80:	a1 48 41 80 00       	mov    0x804148,%eax
  802a85:	8b 55 08             	mov    0x8(%ebp),%edx
  802a88:	89 50 04             	mov    %edx,0x4(%eax)
  802a8b:	eb 08                	jmp    802a95 <insert_sorted_with_merge_freeList+0x259>
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	a3 48 41 80 00       	mov    %eax,0x804148
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa7:	a1 54 41 80 00       	mov    0x804154,%eax
  802aac:	40                   	inc    %eax
  802aad:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802ab2:	e9 88 04 00 00       	jmp    802f3f <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ab7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802abb:	75 17                	jne    802ad4 <insert_sorted_with_merge_freeList+0x298>
  802abd:	83 ec 04             	sub    $0x4,%esp
  802ac0:	68 d0 39 80 00       	push   $0x8039d0
  802ac5:	68 2e 01 00 00       	push   $0x12e
  802aca:	68 f3 39 80 00       	push   $0x8039f3
  802acf:	e8 6e 04 00 00       	call   802f42 <_panic>
  802ad4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	89 10                	mov    %edx,(%eax)
  802adf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae2:	8b 00                	mov    (%eax),%eax
  802ae4:	85 c0                	test   %eax,%eax
  802ae6:	74 0d                	je     802af5 <insert_sorted_with_merge_freeList+0x2b9>
  802ae8:	a1 38 41 80 00       	mov    0x804138,%eax
  802aed:	8b 55 08             	mov    0x8(%ebp),%edx
  802af0:	89 50 04             	mov    %edx,0x4(%eax)
  802af3:	eb 08                	jmp    802afd <insert_sorted_with_merge_freeList+0x2c1>
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	a3 38 41 80 00       	mov    %eax,0x804138
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b14:	40                   	inc    %eax
  802b15:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802b1a:	e9 20 04 00 00       	jmp    802f3f <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802b1f:	a1 38 41 80 00       	mov    0x804138,%eax
  802b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b27:	e9 e2 03 00 00       	jmp    802f0e <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	8b 50 08             	mov    0x8(%eax),%edx
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	8b 40 08             	mov    0x8(%eax),%eax
  802b38:	39 c2                	cmp    %eax,%edx
  802b3a:	0f 83 c6 03 00 00    	jae    802f06 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 40 04             	mov    0x4(%eax),%eax
  802b46:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802b49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b4c:	8b 50 08             	mov    0x8(%eax),%edx
  802b4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b52:	8b 40 0c             	mov    0xc(%eax),%eax
  802b55:	01 d0                	add    %edx,%eax
  802b57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	8b 40 08             	mov    0x8(%eax),%eax
  802b66:	01 d0                	add    %edx,%eax
  802b68:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	8b 40 08             	mov    0x8(%eax),%eax
  802b71:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802b74:	74 7a                	je     802bf0 <insert_sorted_with_merge_freeList+0x3b4>
  802b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b79:	8b 40 08             	mov    0x8(%eax),%eax
  802b7c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802b7f:	74 6f                	je     802bf0 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802b81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b85:	74 06                	je     802b8d <insert_sorted_with_merge_freeList+0x351>
  802b87:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8b:	75 17                	jne    802ba4 <insert_sorted_with_merge_freeList+0x368>
  802b8d:	83 ec 04             	sub    $0x4,%esp
  802b90:	68 50 3a 80 00       	push   $0x803a50
  802b95:	68 43 01 00 00       	push   $0x143
  802b9a:	68 f3 39 80 00       	push   $0x8039f3
  802b9f:	e8 9e 03 00 00       	call   802f42 <_panic>
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 50 04             	mov    0x4(%eax),%edx
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	89 50 04             	mov    %edx,0x4(%eax)
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bb6:	89 10                	mov    %edx,(%eax)
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 04             	mov    0x4(%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	74 0d                	je     802bcf <insert_sorted_with_merge_freeList+0x393>
  802bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc5:	8b 40 04             	mov    0x4(%eax),%eax
  802bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcb:	89 10                	mov    %edx,(%eax)
  802bcd:	eb 08                	jmp    802bd7 <insert_sorted_with_merge_freeList+0x39b>
  802bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd2:	a3 38 41 80 00       	mov    %eax,0x804138
  802bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bda:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdd:	89 50 04             	mov    %edx,0x4(%eax)
  802be0:	a1 44 41 80 00       	mov    0x804144,%eax
  802be5:	40                   	inc    %eax
  802be6:	a3 44 41 80 00       	mov    %eax,0x804144
  802beb:	e9 14 03 00 00       	jmp    802f04 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf3:	8b 40 08             	mov    0x8(%eax),%eax
  802bf6:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802bf9:	0f 85 a0 01 00 00    	jne    802d9f <insert_sorted_with_merge_freeList+0x563>
  802bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c02:	8b 40 08             	mov    0x8(%eax),%eax
  802c05:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c08:	0f 85 91 01 00 00    	jne    802d9f <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802c0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c11:	8b 50 0c             	mov    0xc(%eax),%edx
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	8b 48 0c             	mov    0xc(%eax),%ecx
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c20:	01 c8                	add    %ecx,%eax
  802c22:	01 c2                	add    %eax,%edx
  802c24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c27:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802c34:	8b 45 08             	mov    0x8(%ebp),%eax
  802c37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c56:	75 17                	jne    802c6f <insert_sorted_with_merge_freeList+0x433>
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	68 d0 39 80 00       	push   $0x8039d0
  802c60:	68 4d 01 00 00       	push   $0x14d
  802c65:	68 f3 39 80 00       	push   $0x8039f3
  802c6a:	e8 d3 02 00 00       	call   802f42 <_panic>
  802c6f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	89 10                	mov    %edx,(%eax)
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	74 0d                	je     802c90 <insert_sorted_with_merge_freeList+0x454>
  802c83:	a1 48 41 80 00       	mov    0x804148,%eax
  802c88:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8b:	89 50 04             	mov    %edx,0x4(%eax)
  802c8e:	eb 08                	jmp    802c98 <insert_sorted_with_merge_freeList+0x45c>
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	a3 48 41 80 00       	mov    %eax,0x804148
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802caa:	a1 54 41 80 00       	mov    0x804154,%eax
  802caf:	40                   	inc    %eax
  802cb0:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802cb5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb9:	75 17                	jne    802cd2 <insert_sorted_with_merge_freeList+0x496>
  802cbb:	83 ec 04             	sub    $0x4,%esp
  802cbe:	68 2f 3a 80 00       	push   $0x803a2f
  802cc3:	68 4e 01 00 00       	push   $0x14e
  802cc8:	68 f3 39 80 00       	push   $0x8039f3
  802ccd:	e8 70 02 00 00       	call   802f42 <_panic>
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 10                	je     802ceb <insert_sorted_with_merge_freeList+0x4af>
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 00                	mov    (%eax),%eax
  802ce0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce3:	8b 52 04             	mov    0x4(%edx),%edx
  802ce6:	89 50 04             	mov    %edx,0x4(%eax)
  802ce9:	eb 0b                	jmp    802cf6 <insert_sorted_with_merge_freeList+0x4ba>
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	8b 40 04             	mov    0x4(%eax),%eax
  802cf1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 04             	mov    0x4(%eax),%eax
  802cfc:	85 c0                	test   %eax,%eax
  802cfe:	74 0f                	je     802d0f <insert_sorted_with_merge_freeList+0x4d3>
  802d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d03:	8b 40 04             	mov    0x4(%eax),%eax
  802d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d09:	8b 12                	mov    (%edx),%edx
  802d0b:	89 10                	mov    %edx,(%eax)
  802d0d:	eb 0a                	jmp    802d19 <insert_sorted_with_merge_freeList+0x4dd>
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 00                	mov    (%eax),%eax
  802d14:	a3 38 41 80 00       	mov    %eax,0x804138
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d25:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2c:	a1 44 41 80 00       	mov    0x804144,%eax
  802d31:	48                   	dec    %eax
  802d32:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d3b:	75 17                	jne    802d54 <insert_sorted_with_merge_freeList+0x518>
  802d3d:	83 ec 04             	sub    $0x4,%esp
  802d40:	68 d0 39 80 00       	push   $0x8039d0
  802d45:	68 4f 01 00 00       	push   $0x14f
  802d4a:	68 f3 39 80 00       	push   $0x8039f3
  802d4f:	e8 ee 01 00 00       	call   802f42 <_panic>
  802d54:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5d:	89 10                	mov    %edx,(%eax)
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 00                	mov    (%eax),%eax
  802d64:	85 c0                	test   %eax,%eax
  802d66:	74 0d                	je     802d75 <insert_sorted_with_merge_freeList+0x539>
  802d68:	a1 48 41 80 00       	mov    0x804148,%eax
  802d6d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d70:	89 50 04             	mov    %edx,0x4(%eax)
  802d73:	eb 08                	jmp    802d7d <insert_sorted_with_merge_freeList+0x541>
  802d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d78:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d80:	a3 48 41 80 00       	mov    %eax,0x804148
  802d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d8f:	a1 54 41 80 00       	mov    0x804154,%eax
  802d94:	40                   	inc    %eax
  802d95:	a3 54 41 80 00       	mov    %eax,0x804154
  802d9a:	e9 65 01 00 00       	jmp    802f04 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802da2:	8b 40 08             	mov    0x8(%eax),%eax
  802da5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802da8:	0f 85 9f 00 00 00    	jne    802e4d <insert_sorted_with_merge_freeList+0x611>
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 40 08             	mov    0x8(%eax),%eax
  802db4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802db7:	0f 84 90 00 00 00    	je     802e4d <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802dbd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dc0:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc9:	01 c2                	add    %eax,%edx
  802dcb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dce:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802de5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de9:	75 17                	jne    802e02 <insert_sorted_with_merge_freeList+0x5c6>
  802deb:	83 ec 04             	sub    $0x4,%esp
  802dee:	68 d0 39 80 00       	push   $0x8039d0
  802df3:	68 58 01 00 00       	push   $0x158
  802df8:	68 f3 39 80 00       	push   $0x8039f3
  802dfd:	e8 40 01 00 00       	call   802f42 <_panic>
  802e02:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	89 10                	mov    %edx,(%eax)
  802e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e10:	8b 00                	mov    (%eax),%eax
  802e12:	85 c0                	test   %eax,%eax
  802e14:	74 0d                	je     802e23 <insert_sorted_with_merge_freeList+0x5e7>
  802e16:	a1 48 41 80 00       	mov    0x804148,%eax
  802e1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1e:	89 50 04             	mov    %edx,0x4(%eax)
  802e21:	eb 08                	jmp    802e2b <insert_sorted_with_merge_freeList+0x5ef>
  802e23:	8b 45 08             	mov    0x8(%ebp),%eax
  802e26:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	a3 48 41 80 00       	mov    %eax,0x804148
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3d:	a1 54 41 80 00       	mov    0x804154,%eax
  802e42:	40                   	inc    %eax
  802e43:	a3 54 41 80 00       	mov    %eax,0x804154
  802e48:	e9 b7 00 00 00       	jmp    802f04 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e50:	8b 40 08             	mov    0x8(%eax),%eax
  802e53:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e56:	0f 84 e2 00 00 00    	je     802f3e <insert_sorted_with_merge_freeList+0x702>
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	8b 40 08             	mov    0x8(%eax),%eax
  802e62:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e65:	0f 85 d3 00 00 00    	jne    802f3e <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	8b 50 08             	mov    0x8(%eax),%edx
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	8b 40 0c             	mov    0xc(%eax),%eax
  802e83:	01 c2                	add    %eax,%edx
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea3:	75 17                	jne    802ebc <insert_sorted_with_merge_freeList+0x680>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 d0 39 80 00       	push   $0x8039d0
  802ead:	68 61 01 00 00       	push   $0x161
  802eb2:	68 f3 39 80 00       	push   $0x8039f3
  802eb7:	e8 86 00 00 00       	call   802f42 <_panic>
  802ebc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	89 10                	mov    %edx,(%eax)
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	74 0d                	je     802edd <insert_sorted_with_merge_freeList+0x6a1>
  802ed0:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed8:	89 50 04             	mov    %edx,0x4(%eax)
  802edb:	eb 08                	jmp    802ee5 <insert_sorted_with_merge_freeList+0x6a9>
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	a3 48 41 80 00       	mov    %eax,0x804148
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef7:	a1 54 41 80 00       	mov    0x804154,%eax
  802efc:	40                   	inc    %eax
  802efd:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802f02:	eb 3a                	jmp    802f3e <insert_sorted_with_merge_freeList+0x702>
  802f04:	eb 38                	jmp    802f3e <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802f06:	a1 40 41 80 00       	mov    0x804140,%eax
  802f0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f12:	74 07                	je     802f1b <insert_sorted_with_merge_freeList+0x6df>
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	8b 00                	mov    (%eax),%eax
  802f19:	eb 05                	jmp    802f20 <insert_sorted_with_merge_freeList+0x6e4>
  802f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  802f20:	a3 40 41 80 00       	mov    %eax,0x804140
  802f25:	a1 40 41 80 00       	mov    0x804140,%eax
  802f2a:	85 c0                	test   %eax,%eax
  802f2c:	0f 85 fa fb ff ff    	jne    802b2c <insert_sorted_with_merge_freeList+0x2f0>
  802f32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f36:	0f 85 f0 fb ff ff    	jne    802b2c <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  802f3c:	eb 01                	jmp    802f3f <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  802f3e:	90                   	nop
							}

						}
		          }
		}
}
  802f3f:	90                   	nop
  802f40:	c9                   	leave  
  802f41:	c3                   	ret    

00802f42 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f42:	55                   	push   %ebp
  802f43:	89 e5                	mov    %esp,%ebp
  802f45:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f48:	8d 45 10             	lea    0x10(%ebp),%eax
  802f4b:	83 c0 04             	add    $0x4,%eax
  802f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f51:	a1 60 41 80 00       	mov    0x804160,%eax
  802f56:	85 c0                	test   %eax,%eax
  802f58:	74 16                	je     802f70 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f5a:	a1 60 41 80 00       	mov    0x804160,%eax
  802f5f:	83 ec 08             	sub    $0x8,%esp
  802f62:	50                   	push   %eax
  802f63:	68 88 3a 80 00       	push   $0x803a88
  802f68:	e8 ed d4 ff ff       	call   80045a <cprintf>
  802f6d:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802f70:	a1 00 40 80 00       	mov    0x804000,%eax
  802f75:	ff 75 0c             	pushl  0xc(%ebp)
  802f78:	ff 75 08             	pushl  0x8(%ebp)
  802f7b:	50                   	push   %eax
  802f7c:	68 8d 3a 80 00       	push   $0x803a8d
  802f81:	e8 d4 d4 ff ff       	call   80045a <cprintf>
  802f86:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802f89:	8b 45 10             	mov    0x10(%ebp),%eax
  802f8c:	83 ec 08             	sub    $0x8,%esp
  802f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  802f92:	50                   	push   %eax
  802f93:	e8 57 d4 ff ff       	call   8003ef <vcprintf>
  802f98:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802f9b:	83 ec 08             	sub    $0x8,%esp
  802f9e:	6a 00                	push   $0x0
  802fa0:	68 a9 3a 80 00       	push   $0x803aa9
  802fa5:	e8 45 d4 ff ff       	call   8003ef <vcprintf>
  802faa:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802fad:	e8 c6 d3 ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  802fb2:	eb fe                	jmp    802fb2 <_panic+0x70>

00802fb4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802fb4:	55                   	push   %ebp
  802fb5:	89 e5                	mov    %esp,%ebp
  802fb7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802fba:	a1 20 40 80 00       	mov    0x804020,%eax
  802fbf:	8b 50 74             	mov    0x74(%eax),%edx
  802fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fc5:	39 c2                	cmp    %eax,%edx
  802fc7:	74 14                	je     802fdd <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802fc9:	83 ec 04             	sub    $0x4,%esp
  802fcc:	68 ac 3a 80 00       	push   $0x803aac
  802fd1:	6a 26                	push   $0x26
  802fd3:	68 f8 3a 80 00       	push   $0x803af8
  802fd8:	e8 65 ff ff ff       	call   802f42 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802fdd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802fe4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802feb:	e9 c2 00 00 00       	jmp    8030b2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ff3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	01 d0                	add    %edx,%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	85 c0                	test   %eax,%eax
  803003:	75 08                	jne    80300d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803005:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803008:	e9 a2 00 00 00       	jmp    8030af <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80300d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803014:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80301b:	eb 69                	jmp    803086 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80301d:	a1 20 40 80 00       	mov    0x804020,%eax
  803022:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803028:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80302b:	89 d0                	mov    %edx,%eax
  80302d:	01 c0                	add    %eax,%eax
  80302f:	01 d0                	add    %edx,%eax
  803031:	c1 e0 03             	shl    $0x3,%eax
  803034:	01 c8                	add    %ecx,%eax
  803036:	8a 40 04             	mov    0x4(%eax),%al
  803039:	84 c0                	test   %al,%al
  80303b:	75 46                	jne    803083 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80303d:	a1 20 40 80 00       	mov    0x804020,%eax
  803042:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803048:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80304b:	89 d0                	mov    %edx,%eax
  80304d:	01 c0                	add    %eax,%eax
  80304f:	01 d0                	add    %edx,%eax
  803051:	c1 e0 03             	shl    $0x3,%eax
  803054:	01 c8                	add    %ecx,%eax
  803056:	8b 00                	mov    (%eax),%eax
  803058:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80305b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80305e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803063:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803065:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803068:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80306f:	8b 45 08             	mov    0x8(%ebp),%eax
  803072:	01 c8                	add    %ecx,%eax
  803074:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803076:	39 c2                	cmp    %eax,%edx
  803078:	75 09                	jne    803083 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80307a:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803081:	eb 12                	jmp    803095 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803083:	ff 45 e8             	incl   -0x18(%ebp)
  803086:	a1 20 40 80 00       	mov    0x804020,%eax
  80308b:	8b 50 74             	mov    0x74(%eax),%edx
  80308e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803091:	39 c2                	cmp    %eax,%edx
  803093:	77 88                	ja     80301d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803095:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803099:	75 14                	jne    8030af <CheckWSWithoutLastIndex+0xfb>
			panic(
  80309b:	83 ec 04             	sub    $0x4,%esp
  80309e:	68 04 3b 80 00       	push   $0x803b04
  8030a3:	6a 3a                	push   $0x3a
  8030a5:	68 f8 3a 80 00       	push   $0x803af8
  8030aa:	e8 93 fe ff ff       	call   802f42 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8030af:	ff 45 f0             	incl   -0x10(%ebp)
  8030b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030b5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030b8:	0f 8c 32 ff ff ff    	jl     802ff0 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8030be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030c5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8030cc:	eb 26                	jmp    8030f4 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8030ce:	a1 20 40 80 00       	mov    0x804020,%eax
  8030d3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030dc:	89 d0                	mov    %edx,%eax
  8030de:	01 c0                	add    %eax,%eax
  8030e0:	01 d0                	add    %edx,%eax
  8030e2:	c1 e0 03             	shl    $0x3,%eax
  8030e5:	01 c8                	add    %ecx,%eax
  8030e7:	8a 40 04             	mov    0x4(%eax),%al
  8030ea:	3c 01                	cmp    $0x1,%al
  8030ec:	75 03                	jne    8030f1 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8030ee:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030f1:	ff 45 e0             	incl   -0x20(%ebp)
  8030f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8030f9:	8b 50 74             	mov    0x74(%eax),%edx
  8030fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ff:	39 c2                	cmp    %eax,%edx
  803101:	77 cb                	ja     8030ce <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  803103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803106:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803109:	74 14                	je     80311f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80310b:	83 ec 04             	sub    $0x4,%esp
  80310e:	68 58 3b 80 00       	push   $0x803b58
  803113:	6a 44                	push   $0x44
  803115:	68 f8 3a 80 00       	push   $0x803af8
  80311a:	e8 23 fe ff ff       	call   802f42 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80311f:	90                   	nop
  803120:	c9                   	leave  
  803121:	c3                   	ret    
  803122:	66 90                	xchg   %ax,%ax

00803124 <__udivdi3>:
  803124:	55                   	push   %ebp
  803125:	57                   	push   %edi
  803126:	56                   	push   %esi
  803127:	53                   	push   %ebx
  803128:	83 ec 1c             	sub    $0x1c,%esp
  80312b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80312f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803137:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80313b:	89 ca                	mov    %ecx,%edx
  80313d:	89 f8                	mov    %edi,%eax
  80313f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803143:	85 f6                	test   %esi,%esi
  803145:	75 2d                	jne    803174 <__udivdi3+0x50>
  803147:	39 cf                	cmp    %ecx,%edi
  803149:	77 65                	ja     8031b0 <__udivdi3+0x8c>
  80314b:	89 fd                	mov    %edi,%ebp
  80314d:	85 ff                	test   %edi,%edi
  80314f:	75 0b                	jne    80315c <__udivdi3+0x38>
  803151:	b8 01 00 00 00       	mov    $0x1,%eax
  803156:	31 d2                	xor    %edx,%edx
  803158:	f7 f7                	div    %edi
  80315a:	89 c5                	mov    %eax,%ebp
  80315c:	31 d2                	xor    %edx,%edx
  80315e:	89 c8                	mov    %ecx,%eax
  803160:	f7 f5                	div    %ebp
  803162:	89 c1                	mov    %eax,%ecx
  803164:	89 d8                	mov    %ebx,%eax
  803166:	f7 f5                	div    %ebp
  803168:	89 cf                	mov    %ecx,%edi
  80316a:	89 fa                	mov    %edi,%edx
  80316c:	83 c4 1c             	add    $0x1c,%esp
  80316f:	5b                   	pop    %ebx
  803170:	5e                   	pop    %esi
  803171:	5f                   	pop    %edi
  803172:	5d                   	pop    %ebp
  803173:	c3                   	ret    
  803174:	39 ce                	cmp    %ecx,%esi
  803176:	77 28                	ja     8031a0 <__udivdi3+0x7c>
  803178:	0f bd fe             	bsr    %esi,%edi
  80317b:	83 f7 1f             	xor    $0x1f,%edi
  80317e:	75 40                	jne    8031c0 <__udivdi3+0x9c>
  803180:	39 ce                	cmp    %ecx,%esi
  803182:	72 0a                	jb     80318e <__udivdi3+0x6a>
  803184:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803188:	0f 87 9e 00 00 00    	ja     80322c <__udivdi3+0x108>
  80318e:	b8 01 00 00 00       	mov    $0x1,%eax
  803193:	89 fa                	mov    %edi,%edx
  803195:	83 c4 1c             	add    $0x1c,%esp
  803198:	5b                   	pop    %ebx
  803199:	5e                   	pop    %esi
  80319a:	5f                   	pop    %edi
  80319b:	5d                   	pop    %ebp
  80319c:	c3                   	ret    
  80319d:	8d 76 00             	lea    0x0(%esi),%esi
  8031a0:	31 ff                	xor    %edi,%edi
  8031a2:	31 c0                	xor    %eax,%eax
  8031a4:	89 fa                	mov    %edi,%edx
  8031a6:	83 c4 1c             	add    $0x1c,%esp
  8031a9:	5b                   	pop    %ebx
  8031aa:	5e                   	pop    %esi
  8031ab:	5f                   	pop    %edi
  8031ac:	5d                   	pop    %ebp
  8031ad:	c3                   	ret    
  8031ae:	66 90                	xchg   %ax,%ax
  8031b0:	89 d8                	mov    %ebx,%eax
  8031b2:	f7 f7                	div    %edi
  8031b4:	31 ff                	xor    %edi,%edi
  8031b6:	89 fa                	mov    %edi,%edx
  8031b8:	83 c4 1c             	add    $0x1c,%esp
  8031bb:	5b                   	pop    %ebx
  8031bc:	5e                   	pop    %esi
  8031bd:	5f                   	pop    %edi
  8031be:	5d                   	pop    %ebp
  8031bf:	c3                   	ret    
  8031c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031c5:	89 eb                	mov    %ebp,%ebx
  8031c7:	29 fb                	sub    %edi,%ebx
  8031c9:	89 f9                	mov    %edi,%ecx
  8031cb:	d3 e6                	shl    %cl,%esi
  8031cd:	89 c5                	mov    %eax,%ebp
  8031cf:	88 d9                	mov    %bl,%cl
  8031d1:	d3 ed                	shr    %cl,%ebp
  8031d3:	89 e9                	mov    %ebp,%ecx
  8031d5:	09 f1                	or     %esi,%ecx
  8031d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031db:	89 f9                	mov    %edi,%ecx
  8031dd:	d3 e0                	shl    %cl,%eax
  8031df:	89 c5                	mov    %eax,%ebp
  8031e1:	89 d6                	mov    %edx,%esi
  8031e3:	88 d9                	mov    %bl,%cl
  8031e5:	d3 ee                	shr    %cl,%esi
  8031e7:	89 f9                	mov    %edi,%ecx
  8031e9:	d3 e2                	shl    %cl,%edx
  8031eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ef:	88 d9                	mov    %bl,%cl
  8031f1:	d3 e8                	shr    %cl,%eax
  8031f3:	09 c2                	or     %eax,%edx
  8031f5:	89 d0                	mov    %edx,%eax
  8031f7:	89 f2                	mov    %esi,%edx
  8031f9:	f7 74 24 0c          	divl   0xc(%esp)
  8031fd:	89 d6                	mov    %edx,%esi
  8031ff:	89 c3                	mov    %eax,%ebx
  803201:	f7 e5                	mul    %ebp
  803203:	39 d6                	cmp    %edx,%esi
  803205:	72 19                	jb     803220 <__udivdi3+0xfc>
  803207:	74 0b                	je     803214 <__udivdi3+0xf0>
  803209:	89 d8                	mov    %ebx,%eax
  80320b:	31 ff                	xor    %edi,%edi
  80320d:	e9 58 ff ff ff       	jmp    80316a <__udivdi3+0x46>
  803212:	66 90                	xchg   %ax,%ax
  803214:	8b 54 24 08          	mov    0x8(%esp),%edx
  803218:	89 f9                	mov    %edi,%ecx
  80321a:	d3 e2                	shl    %cl,%edx
  80321c:	39 c2                	cmp    %eax,%edx
  80321e:	73 e9                	jae    803209 <__udivdi3+0xe5>
  803220:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803223:	31 ff                	xor    %edi,%edi
  803225:	e9 40 ff ff ff       	jmp    80316a <__udivdi3+0x46>
  80322a:	66 90                	xchg   %ax,%ax
  80322c:	31 c0                	xor    %eax,%eax
  80322e:	e9 37 ff ff ff       	jmp    80316a <__udivdi3+0x46>
  803233:	90                   	nop

00803234 <__umoddi3>:
  803234:	55                   	push   %ebp
  803235:	57                   	push   %edi
  803236:	56                   	push   %esi
  803237:	53                   	push   %ebx
  803238:	83 ec 1c             	sub    $0x1c,%esp
  80323b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80323f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803243:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803247:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80324b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80324f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803253:	89 f3                	mov    %esi,%ebx
  803255:	89 fa                	mov    %edi,%edx
  803257:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80325b:	89 34 24             	mov    %esi,(%esp)
  80325e:	85 c0                	test   %eax,%eax
  803260:	75 1a                	jne    80327c <__umoddi3+0x48>
  803262:	39 f7                	cmp    %esi,%edi
  803264:	0f 86 a2 00 00 00    	jbe    80330c <__umoddi3+0xd8>
  80326a:	89 c8                	mov    %ecx,%eax
  80326c:	89 f2                	mov    %esi,%edx
  80326e:	f7 f7                	div    %edi
  803270:	89 d0                	mov    %edx,%eax
  803272:	31 d2                	xor    %edx,%edx
  803274:	83 c4 1c             	add    $0x1c,%esp
  803277:	5b                   	pop    %ebx
  803278:	5e                   	pop    %esi
  803279:	5f                   	pop    %edi
  80327a:	5d                   	pop    %ebp
  80327b:	c3                   	ret    
  80327c:	39 f0                	cmp    %esi,%eax
  80327e:	0f 87 ac 00 00 00    	ja     803330 <__umoddi3+0xfc>
  803284:	0f bd e8             	bsr    %eax,%ebp
  803287:	83 f5 1f             	xor    $0x1f,%ebp
  80328a:	0f 84 ac 00 00 00    	je     80333c <__umoddi3+0x108>
  803290:	bf 20 00 00 00       	mov    $0x20,%edi
  803295:	29 ef                	sub    %ebp,%edi
  803297:	89 fe                	mov    %edi,%esi
  803299:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80329d:	89 e9                	mov    %ebp,%ecx
  80329f:	d3 e0                	shl    %cl,%eax
  8032a1:	89 d7                	mov    %edx,%edi
  8032a3:	89 f1                	mov    %esi,%ecx
  8032a5:	d3 ef                	shr    %cl,%edi
  8032a7:	09 c7                	or     %eax,%edi
  8032a9:	89 e9                	mov    %ebp,%ecx
  8032ab:	d3 e2                	shl    %cl,%edx
  8032ad:	89 14 24             	mov    %edx,(%esp)
  8032b0:	89 d8                	mov    %ebx,%eax
  8032b2:	d3 e0                	shl    %cl,%eax
  8032b4:	89 c2                	mov    %eax,%edx
  8032b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ba:	d3 e0                	shl    %cl,%eax
  8032bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c4:	89 f1                	mov    %esi,%ecx
  8032c6:	d3 e8                	shr    %cl,%eax
  8032c8:	09 d0                	or     %edx,%eax
  8032ca:	d3 eb                	shr    %cl,%ebx
  8032cc:	89 da                	mov    %ebx,%edx
  8032ce:	f7 f7                	div    %edi
  8032d0:	89 d3                	mov    %edx,%ebx
  8032d2:	f7 24 24             	mull   (%esp)
  8032d5:	89 c6                	mov    %eax,%esi
  8032d7:	89 d1                	mov    %edx,%ecx
  8032d9:	39 d3                	cmp    %edx,%ebx
  8032db:	0f 82 87 00 00 00    	jb     803368 <__umoddi3+0x134>
  8032e1:	0f 84 91 00 00 00    	je     803378 <__umoddi3+0x144>
  8032e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032eb:	29 f2                	sub    %esi,%edx
  8032ed:	19 cb                	sbb    %ecx,%ebx
  8032ef:	89 d8                	mov    %ebx,%eax
  8032f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032f5:	d3 e0                	shl    %cl,%eax
  8032f7:	89 e9                	mov    %ebp,%ecx
  8032f9:	d3 ea                	shr    %cl,%edx
  8032fb:	09 d0                	or     %edx,%eax
  8032fd:	89 e9                	mov    %ebp,%ecx
  8032ff:	d3 eb                	shr    %cl,%ebx
  803301:	89 da                	mov    %ebx,%edx
  803303:	83 c4 1c             	add    $0x1c,%esp
  803306:	5b                   	pop    %ebx
  803307:	5e                   	pop    %esi
  803308:	5f                   	pop    %edi
  803309:	5d                   	pop    %ebp
  80330a:	c3                   	ret    
  80330b:	90                   	nop
  80330c:	89 fd                	mov    %edi,%ebp
  80330e:	85 ff                	test   %edi,%edi
  803310:	75 0b                	jne    80331d <__umoddi3+0xe9>
  803312:	b8 01 00 00 00       	mov    $0x1,%eax
  803317:	31 d2                	xor    %edx,%edx
  803319:	f7 f7                	div    %edi
  80331b:	89 c5                	mov    %eax,%ebp
  80331d:	89 f0                	mov    %esi,%eax
  80331f:	31 d2                	xor    %edx,%edx
  803321:	f7 f5                	div    %ebp
  803323:	89 c8                	mov    %ecx,%eax
  803325:	f7 f5                	div    %ebp
  803327:	89 d0                	mov    %edx,%eax
  803329:	e9 44 ff ff ff       	jmp    803272 <__umoddi3+0x3e>
  80332e:	66 90                	xchg   %ax,%ax
  803330:	89 c8                	mov    %ecx,%eax
  803332:	89 f2                	mov    %esi,%edx
  803334:	83 c4 1c             	add    $0x1c,%esp
  803337:	5b                   	pop    %ebx
  803338:	5e                   	pop    %esi
  803339:	5f                   	pop    %edi
  80333a:	5d                   	pop    %ebp
  80333b:	c3                   	ret    
  80333c:	3b 04 24             	cmp    (%esp),%eax
  80333f:	72 06                	jb     803347 <__umoddi3+0x113>
  803341:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803345:	77 0f                	ja     803356 <__umoddi3+0x122>
  803347:	89 f2                	mov    %esi,%edx
  803349:	29 f9                	sub    %edi,%ecx
  80334b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80334f:	89 14 24             	mov    %edx,(%esp)
  803352:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803356:	8b 44 24 04          	mov    0x4(%esp),%eax
  80335a:	8b 14 24             	mov    (%esp),%edx
  80335d:	83 c4 1c             	add    $0x1c,%esp
  803360:	5b                   	pop    %ebx
  803361:	5e                   	pop    %esi
  803362:	5f                   	pop    %edi
  803363:	5d                   	pop    %ebp
  803364:	c3                   	ret    
  803365:	8d 76 00             	lea    0x0(%esi),%esi
  803368:	2b 04 24             	sub    (%esp),%eax
  80336b:	19 fa                	sbb    %edi,%edx
  80336d:	89 d1                	mov    %edx,%ecx
  80336f:	89 c6                	mov    %eax,%esi
  803371:	e9 71 ff ff ff       	jmp    8032e7 <__umoddi3+0xb3>
  803376:	66 90                	xchg   %ax,%ax
  803378:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80337c:	72 ea                	jb     803368 <__umoddi3+0x134>
  80337e:	89 d9                	mov    %ebx,%ecx
  803380:	e9 62 ff ff ff       	jmp    8032e7 <__umoddi3+0xb3>

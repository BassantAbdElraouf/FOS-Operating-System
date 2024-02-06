
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 b4 01 00 00       	call   8001ea <libmain>
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
  800045:	68 e0 33 80 00       	push   $0x8033e0
  80004a:	e8 0e 16 00 00       	call   80165d <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 e2 33 80 00       	push   $0x8033e2
  80006e:	e8 ea 15 00 00       	call   80165d <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 e9 33 80 00       	push   $0x8033e9
  8000ab:	e8 27 1a 00 00       	call   801ad7 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 eb 33 80 00       	push   $0x8033eb
  8000bf:	e8 99 15 00 00       	call   80165d <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 f9 33 80 00       	push   $0x8033f9
  8000f1:	e8 f2 1a 00 00       	call   801be8 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800101:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 03 34 80 00       	push   $0x803403
  80011a:	e8 c9 1a 00 00       	call   801be8 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 0d 34 80 00       	push   $0x80340d
  800139:	6a 27                	push   $0x27
  80013b:	68 22 34 80 00       	push   $0x803422
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 b6 1a 00 00       	call   801c06 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 62 2f 00 00       	call   8030c2 <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 98 1a 00 00       	call   801c06 <sys_run_env>
  80016e:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800171:	90                   	nop
  800172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	83 f8 02             	cmp    $0x2,%eax
  80017a:	75 f6                	jne    800172 <_main+0x13a>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	50                   	push   %eax
  800185:	68 3d 34 80 00       	push   $0x80343d
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 d8 1a 00 00       	call   801c6f <sys_getparentenvid>
  800197:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  80019a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80019e:	7e 47                	jle    8001e7 <_main+0x1af>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  8001a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	68 eb 33 80 00       	push   $0x8033eb
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 78 15 00 00       	call   80172f <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 5a 1a 00 00       	call   801c22 <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 4c 1a 00 00       	call   801c22 <sys_destroy_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dc:	8b 00                	mov    (%eax),%eax
  8001de:	8d 50 01             	lea    0x1(%eax),%edx
  8001e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e4:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e6:	90                   	nop
  8001e7:	90                   	nop
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f0:	e8 61 1a 00 00       	call   801c56 <sys_getenvindex>
  8001f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fb:	89 d0                	mov    %edx,%eax
  8001fd:	c1 e0 03             	shl    $0x3,%eax
  800200:	01 d0                	add    %edx,%eax
  800202:	01 c0                	add    %eax,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020d:	01 d0                	add    %edx,%eax
  80020f:	c1 e0 04             	shl    $0x4,%eax
  800212:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800217:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80021c:	a1 20 40 80 00       	mov    0x804020,%eax
  800221:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800227:	84 c0                	test   %al,%al
  800229:	74 0f                	je     80023a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	05 5c 05 00 00       	add    $0x55c,%eax
  800235:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023e:	7e 0a                	jle    80024a <libmain+0x60>
		binaryname = argv[0];
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	e8 e0 fd ff ff       	call   800038 <_main>
  800258:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80025b:	e8 03 18 00 00       	call   801a63 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 6c 34 80 00       	push   $0x80346c
  800268:	e8 6d 03 00 00       	call   8005da <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800270:	a1 20 40 80 00       	mov    0x804020,%eax
  800275:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80027b:	a1 20 40 80 00       	mov    0x804020,%eax
  800280:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	68 94 34 80 00       	push   $0x803494
  800290:	e8 45 03 00 00       	call   8005da <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800298:	a1 20 40 80 00       	mov    0x804020,%eax
  80029d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002b9:	51                   	push   %ecx
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	68 bc 34 80 00       	push   $0x8034bc
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 14 35 80 00       	push   $0x803514
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 6c 34 80 00       	push   $0x80346c
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 83 17 00 00       	call   801a7d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002fa:	e8 19 00 00 00       	call   800318 <exit>
}
  8002ff:	90                   	nop
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	6a 00                	push   $0x0
  80030d:	e8 10 19 00 00       	call   801c22 <sys_destroy_env>
  800312:	83 c4 10             	add    $0x10,%esp
}
  800315:	90                   	nop
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <exit>:

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031e:	e8 65 19 00 00       	call   801c88 <sys_exit_env>
}
  800323:	90                   	nop
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80032c:	8d 45 10             	lea    0x10(%ebp),%eax
  80032f:	83 c0 04             	add    $0x4,%eax
  800332:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800335:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80033a:	85 c0                	test   %eax,%eax
  80033c:	74 16                	je     800354 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	50                   	push   %eax
  800347:	68 28 35 80 00       	push   $0x803528
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 40 80 00       	mov    0x804000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 2d 35 80 00       	push   $0x80352d
  800365:	e8 70 02 00 00       	call   8005da <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80036d:	8b 45 10             	mov    0x10(%ebp),%eax
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 75 f4             	pushl  -0xc(%ebp)
  800376:	50                   	push   %eax
  800377:	e8 f3 01 00 00       	call   80056f <vcprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	6a 00                	push   $0x0
  800384:	68 49 35 80 00       	push   $0x803549
  800389:	e8 e1 01 00 00       	call   80056f <vcprintf>
  80038e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800391:	e8 82 ff ff ff       	call   800318 <exit>

	// should not return here
	while (1) ;
  800396:	eb fe                	jmp    800396 <_panic+0x70>

00800398 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	8b 50 74             	mov    0x74(%eax),%edx
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	74 14                	je     8003c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 4c 35 80 00       	push   $0x80354c
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 98 35 80 00       	push   $0x803598
  8003bc:	e8 65 ff ff ff       	call   800326 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003cf:	e9 c2 00 00 00       	jmp    800496 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	75 08                	jne    8003f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ec:	e9 a2 00 00 00       	jmp    800493 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ff:	eb 69                	jmp    80046a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040f:	89 d0                	mov    %edx,%eax
  800411:	01 c0                	add    %eax,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8a 40 04             	mov    0x4(%eax),%al
  80041d:	84 c0                	test   %al,%al
  80041f:	75 46                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80042c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800447:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c8                	add    %ecx,%eax
  800458:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045a:	39 c2                	cmp    %eax,%edx
  80045c:	75 09                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80045e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800465:	eb 12                	jmp    800479 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	ff 45 e8             	incl   -0x18(%ebp)
  80046a:	a1 20 40 80 00       	mov    0x804020,%eax
  80046f:	8b 50 74             	mov    0x74(%eax),%edx
  800472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800475:	39 c2                	cmp    %eax,%edx
  800477:	77 88                	ja     800401 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047d:	75 14                	jne    800493 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 a4 35 80 00       	push   $0x8035a4
  800487:	6a 3a                	push   $0x3a
  800489:	68 98 35 80 00       	push   $0x803598
  80048e:	e8 93 fe ff ff       	call   800326 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800493:	ff 45 f0             	incl   -0x10(%ebp)
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800499:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049c:	0f 8c 32 ff ff ff    	jl     8003d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b0:	eb 26                	jmp    8004d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c0:	89 d0                	mov    %edx,%eax
  8004c2:	01 c0                	add    %eax,%eax
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	c1 e0 03             	shl    $0x3,%eax
  8004c9:	01 c8                	add    %ecx,%eax
  8004cb:	8a 40 04             	mov    0x4(%eax),%al
  8004ce:	3c 01                	cmp    $0x1,%al
  8004d0:	75 03                	jne    8004d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d5:	ff 45 e0             	incl   -0x20(%ebp)
  8004d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8004dd:	8b 50 74             	mov    0x74(%eax),%edx
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	39 c2                	cmp    %eax,%edx
  8004e5:	77 cb                	ja     8004b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ed:	74 14                	je     800503 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 f8 35 80 00       	push   $0x8035f8
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 98 35 80 00       	push   $0x803598
  8004fe:	e8 23 fe ff ff       	call   800326 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 48 01             	lea    0x1(%eax),%ecx
  800514:	8b 55 0c             	mov    0xc(%ebp),%edx
  800517:	89 0a                	mov    %ecx,(%edx)
  800519:	8b 55 08             	mov    0x8(%ebp),%edx
  80051c:	88 d1                	mov    %dl,%cl
  80051e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800521:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052f:	75 2c                	jne    80055d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800531:	a0 24 40 80 00       	mov    0x804024,%al
  800536:	0f b6 c0             	movzbl %al,%eax
  800539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053c:	8b 12                	mov    (%edx),%edx
  80053e:	89 d1                	mov    %edx,%ecx
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	83 c2 08             	add    $0x8,%edx
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	50                   	push   %eax
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	e8 64 13 00 00       	call   8018b5 <sys_cputs>
  800551:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	8b 40 04             	mov    0x4(%eax),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	8b 45 0c             	mov    0xc(%ebp),%eax
  800569:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056c:	90                   	nop
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800578:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057f:	00 00 00 
	b.cnt = 0;
  800582:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800589:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800598:	50                   	push   %eax
  800599:	68 06 05 80 00       	push   $0x800506
  80059e:	e8 11 02 00 00       	call   8007b4 <vprintfmt>
  8005a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005a6:	a0 24 40 80 00       	mov    0x804024,%al
  8005ab:	0f b6 c0             	movzbl %al,%eax
  8005ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	50                   	push   %eax
  8005b8:	52                   	push   %edx
  8005b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bf:	83 c0 08             	add    $0x8,%eax
  8005c2:	50                   	push   %eax
  8005c3:	e8 ed 12 00 00       	call   8018b5 <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cb:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <cprintf>:

int cprintf(const char *fmt, ...) {
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e0:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	e8 73 ff ff ff       	call   80056f <vcprintf>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800605:	c9                   	leave  
  800606:	c3                   	ret    

00800607 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80060d:	e8 51 14 00 00       	call   801a63 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800612:	8d 45 0c             	lea    0xc(%ebp),%eax
  800615:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 f4             	pushl  -0xc(%ebp)
  800621:	50                   	push   %eax
  800622:	e8 48 ff ff ff       	call   80056f <vcprintf>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80062d:	e8 4b 14 00 00       	call   801a7d <sys_enable_interrupt>
	return cnt;
  800632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	53                   	push   %ebx
  80063b:	83 ec 14             	sub    $0x14,%esp
  80063e:	8b 45 10             	mov    0x10(%ebp),%eax
  800641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064a:	8b 45 18             	mov    0x18(%ebp),%eax
  80064d:	ba 00 00 00 00       	mov    $0x0,%edx
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	77 55                	ja     8006ac <printnum+0x75>
  800657:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065a:	72 05                	jb     800661 <printnum+0x2a>
  80065c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065f:	77 4b                	ja     8006ac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800661:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800664:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800667:	8b 45 18             	mov    0x18(%ebp),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	52                   	push   %edx
  800670:	50                   	push   %eax
  800671:	ff 75 f4             	pushl  -0xc(%ebp)
  800674:	ff 75 f0             	pushl  -0x10(%ebp)
  800677:	e8 fc 2a 00 00       	call   803178 <__udivdi3>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	ff 75 20             	pushl  0x20(%ebp)
  800685:	53                   	push   %ebx
  800686:	ff 75 18             	pushl  0x18(%ebp)
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 a1 ff ff ff       	call   800637 <printnum>
  800696:	83 c4 20             	add    $0x20,%esp
  800699:	eb 1a                	jmp    8006b5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	ff 75 20             	pushl  0x20(%ebp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ac:	ff 4d 1c             	decl   0x1c(%ebp)
  8006af:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b3:	7f e6                	jg     80069b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c3:	53                   	push   %ebx
  8006c4:	51                   	push   %ecx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	e8 bc 2b 00 00       	call   803288 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 74 38 80 00       	add    $0x803874,%eax
  8006d4:	8a 00                	mov    (%eax),%al
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
}
  8006e8:	90                   	nop
  8006e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f5:	7e 1c                	jle    800713 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8d 50 08             	lea    0x8(%eax),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	89 10                	mov    %edx,(%eax)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	83 e8 08             	sub    $0x8,%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	eb 40                	jmp    800753 <getuint+0x65>
	else if (lflag)
  800713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800717:	74 1e                	je     800737 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	eb 1c                	jmp    800753 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8d 50 04             	lea    0x4(%eax),%edx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 10                	mov    %edx,(%eax)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800753:	5d                   	pop    %ebp
  800754:	c3                   	ret    

00800755 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800758:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075c:	7e 1c                	jle    80077a <getint+0x25>
		return va_arg(*ap, long long);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	8d 50 08             	lea    0x8(%eax),%edx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	89 10                	mov    %edx,(%eax)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 e8 08             	sub    $0x8,%eax
  800773:	8b 50 04             	mov    0x4(%eax),%edx
  800776:	8b 00                	mov    (%eax),%eax
  800778:	eb 38                	jmp    8007b2 <getint+0x5d>
	else if (lflag)
  80077a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077e:	74 1a                	je     80079a <getint+0x45>
		return va_arg(*ap, long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 04             	sub    $0x4,%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	99                   	cltd   
  800798:	eb 18                	jmp    8007b2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 04             	lea    0x4(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 04             	sub    $0x4,%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	99                   	cltd   
}
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bc:	eb 17                	jmp    8007d5 <vprintfmt+0x21>
			if (ch == '\0')
  8007be:	85 db                	test   %ebx,%ebx
  8007c0:	0f 84 af 03 00 00    	je     800b75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	8d 50 01             	lea    0x1(%eax),%edx
  8007db:	89 55 10             	mov    %edx,0x10(%ebp)
  8007de:	8a 00                	mov    (%eax),%al
  8007e0:	0f b6 d8             	movzbl %al,%ebx
  8007e3:	83 fb 25             	cmp    $0x25,%ebx
  8007e6:	75 d6                	jne    8007be <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800801:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	8d 50 01             	lea    0x1(%eax),%edx
  80080e:	89 55 10             	mov    %edx,0x10(%ebp)
  800811:	8a 00                	mov    (%eax),%al
  800813:	0f b6 d8             	movzbl %al,%ebx
  800816:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800819:	83 f8 55             	cmp    $0x55,%eax
  80081c:	0f 87 2b 03 00 00    	ja     800b4d <vprintfmt+0x399>
  800822:	8b 04 85 98 38 80 00 	mov    0x803898(,%eax,4),%eax
  800829:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082f:	eb d7                	jmp    800808 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800831:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800835:	eb d1                	jmp    800808 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800837:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80083e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800841:	89 d0                	mov    %edx,%eax
  800843:	c1 e0 02             	shl    $0x2,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	01 c0                	add    %eax,%eax
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	83 e8 30             	sub    $0x30,%eax
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800852:	8b 45 10             	mov    0x10(%ebp),%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085a:	83 fb 2f             	cmp    $0x2f,%ebx
  80085d:	7e 3e                	jle    80089d <vprintfmt+0xe9>
  80085f:	83 fb 39             	cmp    $0x39,%ebx
  800862:	7f 39                	jg     80089d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800864:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800867:	eb d5                	jmp    80083e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 c0 04             	add    $0x4,%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 e8 04             	sub    $0x4,%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087d:	eb 1f                	jmp    80089e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	79 83                	jns    800808 <vprintfmt+0x54>
				width = 0;
  800885:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088c:	e9 77 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800891:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800898:	e9 6b ff ff ff       	jmp    800808 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a2:	0f 89 60 ff ff ff    	jns    800808 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b5:	e9 4e ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008bd:	e9 46 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 89 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f8:	85 db                	test   %ebx,%ebx
  8008fa:	79 02                	jns    8008fe <vprintfmt+0x14a>
				err = -err;
  8008fc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008fe:	83 fb 64             	cmp    $0x64,%ebx
  800901:	7f 0b                	jg     80090e <vprintfmt+0x15a>
  800903:	8b 34 9d e0 36 80 00 	mov    0x8036e0(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 85 38 80 00       	push   $0x803885
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 5e 02 00 00       	call   800b7d <printfmt>
  80091f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800922:	e9 49 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800927:	56                   	push   %esi
  800928:	68 8e 38 80 00       	push   $0x80388e
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	ff 75 08             	pushl  0x8(%ebp)
  800933:	e8 45 02 00 00       	call   800b7d <printfmt>
  800938:	83 c4 10             	add    $0x10,%esp
			break;
  80093b:	e9 30 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 c0 04             	add    $0x4,%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 30                	mov    (%eax),%esi
  800951:	85 f6                	test   %esi,%esi
  800953:	75 05                	jne    80095a <vprintfmt+0x1a6>
				p = "(null)";
  800955:	be 91 38 80 00       	mov    $0x803891,%esi
			if (width > 0 && padc != '-')
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	7e 6d                	jle    8009cd <vprintfmt+0x219>
  800960:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800964:	74 67                	je     8009cd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	50                   	push   %eax
  80096d:	56                   	push   %esi
  80096e:	e8 0c 03 00 00       	call   800c7f <strnlen>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800979:	eb 16                	jmp    800991 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	50                   	push   %eax
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80098e:	ff 4d e4             	decl   -0x1c(%ebp)
  800991:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800995:	7f e4                	jg     80097b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800997:	eb 34                	jmp    8009cd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099d:	74 1c                	je     8009bb <vprintfmt+0x207>
  80099f:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a2:	7e 05                	jle    8009a9 <vprintfmt+0x1f5>
  8009a4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a7:	7e 12                	jle    8009bb <vprintfmt+0x207>
					putch('?', putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	6a 3f                	push   $0x3f
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	eb 0f                	jmp    8009ca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 70 01             	lea    0x1(%eax),%esi
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f be d8             	movsbl %al,%ebx
  8009d7:	85 db                	test   %ebx,%ebx
  8009d9:	74 24                	je     8009ff <vprintfmt+0x24b>
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	78 b8                	js     800999 <vprintfmt+0x1e5>
  8009e1:	ff 4d e0             	decl   -0x20(%ebp)
  8009e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e8:	79 af                	jns    800999 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ea:	eb 13                	jmp    8009ff <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	6a 20                	push   $0x20
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a03:	7f e7                	jg     8009ec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a05:	e9 66 01 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
  800a13:	50                   	push   %eax
  800a14:	e8 3c fd ff ff       	call   800755 <getint>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a28:	85 d2                	test   %edx,%edx
  800a2a:	79 23                	jns    800a4f <vprintfmt+0x29b>
				putch('-', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 2d                	push   $0x2d
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a42:	f7 d8                	neg    %eax
  800a44:	83 d2 00             	adc    $0x0,%edx
  800a47:	f7 da                	neg    %edx
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a56:	e9 bc 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a61:	8d 45 14             	lea    0x14(%ebp),%eax
  800a64:	50                   	push   %eax
  800a65:	e8 84 fc ff ff       	call   8006ee <getuint>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7a:	e9 98 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 58                	push   $0x58
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 58                	push   $0x58
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 58                	push   $0x58
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	e9 bc 00 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 30                	push   $0x30
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 78                	push   $0x78
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	83 e8 04             	sub    $0x4,%eax
  800ae3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af6:	eb 1f                	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 e8             	pushl  -0x18(%ebp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	50                   	push   %eax
  800b02:	e8 e7 fb ff ff       	call   8006ee <getuint>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b25:	50                   	push   %eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 00 fb ff ff       	call   800637 <printnum>
  800b37:	83 c4 20             	add    $0x20,%esp
			break;
  800b3a:	eb 34                	jmp    800b70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			break;
  800b4b:	eb 23                	jmp    800b70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 25                	push   $0x25
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5d:	ff 4d 10             	decl   0x10(%ebp)
  800b60:	eb 03                	jmp    800b65 <vprintfmt+0x3b1>
  800b62:	ff 4d 10             	decl   0x10(%ebp)
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	48                   	dec    %eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	3c 25                	cmp    $0x25,%al
  800b6d:	75 f3                	jne    800b62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b6f:	90                   	nop
		}
	}
  800b70:	e9 47 fc ff ff       	jmp    8007bc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b83:	8d 45 10             	lea    0x10(%ebp),%eax
  800b86:	83 c0 04             	add    $0x4,%eax
  800b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 08             	pushl  0x8(%ebp)
  800b99:	e8 16 fc ff ff       	call   8007b4 <vprintfmt>
  800b9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba1:	90                   	nop
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8b 40 08             	mov    0x8(%eax),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 10                	mov    (%eax),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8b 40 04             	mov    0x4(%eax),%eax
  800bc1:	39 c2                	cmp    %eax,%edx
  800bc3:	73 12                	jae    800bd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	8d 48 01             	lea    0x1(%eax),%ecx
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 0a                	mov    %ecx,(%edx)
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	88 10                	mov    %dl,(%eax)
}
  800bd7:	90                   	nop
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bff:	74 06                	je     800c07 <vsnprintf+0x2d>
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	7f 07                	jg     800c0e <vsnprintf+0x34>
		return -E_INVAL;
  800c07:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0c:	eb 20                	jmp    800c2e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c0e:	ff 75 14             	pushl  0x14(%ebp)
  800c11:	ff 75 10             	pushl  0x10(%ebp)
  800c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c17:	50                   	push   %eax
  800c18:	68 a4 0b 80 00       	push   $0x800ba4
  800c1d:	e8 92 fb ff ff       	call   8007b4 <vprintfmt>
  800c22:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c36:	8d 45 10             	lea    0x10(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c42:	ff 75 f4             	pushl  -0xc(%ebp)
  800c45:	50                   	push   %eax
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	ff 75 08             	pushl  0x8(%ebp)
  800c4c:	e8 89 ff ff ff       	call   800bda <vsnprintf>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c69:	eb 06                	jmp    800c71 <strlen+0x15>
		n++;
  800c6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6e:	ff 45 08             	incl   0x8(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	84 c0                	test   %al,%al
  800c78:	75 f1                	jne    800c6b <strlen+0xf>
		n++;
	return n;
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 09                	jmp    800c97 <strnlen+0x18>
		n++;
  800c8e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	ff 4d 0c             	decl   0xc(%ebp)
  800c97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9b:	74 09                	je     800ca6 <strnlen+0x27>
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 e8                	jne    800c8e <strnlen+0xf>
		n++;
	return n;
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb7:	90                   	nop
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 e4                	jne    800cb8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cec:	eb 1f                	jmp    800d0d <strncpy+0x34>
		*dst++ = *src;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8d 50 01             	lea    0x1(%eax),%edx
  800cf4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfa:	8a 12                	mov    (%edx),%dl
  800cfc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	74 03                	je     800d0a <strncpy+0x31>
			src++;
  800d07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0a:	ff 45 fc             	incl   -0x4(%ebp)
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d13:	72 d9                	jb     800cee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	74 30                	je     800d5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2c:	eb 16                	jmp    800d44 <strlcpy+0x2a>
			*dst++ = *src++;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 08             	mov    %edx,0x8(%ebp)
  800d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d40:	8a 12                	mov    (%edx),%dl
  800d42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	74 09                	je     800d56 <strlcpy+0x3c>
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	75 d8                	jne    800d2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	29 c2                	sub    %eax,%edx
  800d64:	89 d0                	mov    %edx,%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6b:	eb 06                	jmp    800d73 <strcmp+0xb>
		p++, q++;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 0e                	je     800d8a <strcmp+0x22>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 10                	mov    (%eax),%dl
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	38 c2                	cmp    %al,%dl
  800d88:	74 e3                	je     800d6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 d0             	movzbl %al,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f b6 c0             	movzbl %al,%eax
  800d9a:	29 c2                	sub    %eax,%edx
  800d9c:	89 d0                	mov    %edx,%eax
}
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da3:	eb 09                	jmp    800dae <strncmp+0xe>
		n--, p++, q++;
  800da5:	ff 4d 10             	decl   0x10(%ebp)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db2:	74 17                	je     800dcb <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 0e                	je     800dcb <strncmp+0x2b>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	38 c2                	cmp    %al,%dl
  800dc9:	74 da                	je     800da5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 07                	jne    800dd8 <strncmp+0x38>
		return 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	eb 14                	jmp    800dec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfa:	eb 12                	jmp    800e0e <strchr+0x20>
		if (*s == c)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e04:	75 05                	jne    800e0b <strchr+0x1d>
			return (char *) s;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	eb 11                	jmp    800e1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e5                	jne    800dfc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2a:	eb 0d                	jmp    800e39 <strfind+0x1b>
		if (*s == c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e34:	74 0e                	je     800e44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 ea                	jne    800e2c <strfind+0xe>
  800e42:	eb 01                	jmp    800e45 <strfind+0x27>
		if (*s == c)
			break;
  800e44:	90                   	nop
	return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5c:	eb 0e                	jmp    800e6c <memset+0x22>
		*p++ = c;
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6c:	ff 4d f8             	decl   -0x8(%ebp)
  800e6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e73:	79 e9                	jns    800e5e <memset+0x14>
		*p++ = c;

	return v;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8c:	eb 16                	jmp    800ea4 <memcpy+0x2a>
		*d++ = *s++;
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 dd                	jne    800e8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	73 50                	jae    800f20 <memmove+0x6a>
  800ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edb:	76 43                	jbe    800f20 <memmove+0x6a>
		s += n;
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee9:	eb 10                	jmp    800efb <memmove+0x45>
			*--d = *--s;
  800eeb:	ff 4d f8             	decl   -0x8(%ebp)
  800eee:	ff 4d fc             	decl   -0x4(%ebp)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efb:	8b 45 10             	mov    0x10(%ebp),%eax
  800efe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f01:	89 55 10             	mov    %edx,0x10(%ebp)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	75 e3                	jne    800eeb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f08:	eb 23                	jmp    800f2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f26:	89 55 10             	mov    %edx,0x10(%ebp)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	75 dd                	jne    800f0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f44:	eb 2a                	jmp    800f70 <memcmp+0x3e>
		if (*s1 != *s2)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 16                	je     800f6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 d0             	movzbl %al,%edx
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	29 c2                	sub    %eax,%edx
  800f66:	89 d0                	mov    %edx,%eax
  800f68:	eb 18                	jmp    800f82 <memcmp+0x50>
		s1++, s2++;
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 c9                	jne    800f46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f95:	eb 15                	jmp    800fac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f b6 d0             	movzbl %al,%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	39 c2                	cmp    %eax,%edx
  800fa7:	74 0d                	je     800fb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb2:	72 e3                	jb     800f97 <memfind+0x13>
  800fb4:	eb 01                	jmp    800fb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb6:	90                   	nop
	return (void *) s;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd0:	eb 03                	jmp    800fd5 <strtol+0x19>
		s++;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 20                	cmp    $0x20,%al
  800fdc:	74 f4                	je     800fd2 <strtol+0x16>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 09                	cmp    $0x9,%al
  800fe5:	74 eb                	je     800fd2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 2b                	cmp    $0x2b,%al
  800fee:	75 05                	jne    800ff5 <strtol+0x39>
		s++;
  800ff0:	ff 45 08             	incl   0x8(%ebp)
  800ff3:	eb 13                	jmp    801008 <strtol+0x4c>
	else if (*s == '-')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2d                	cmp    $0x2d,%al
  800ffc:	75 0a                	jne    801008 <strtol+0x4c>
		s++, neg = 1;
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	74 06                	je     801014 <strtol+0x58>
  80100e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801012:	75 20                	jne    801034 <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 30                	cmp    $0x30,%al
  80101b:	75 17                	jne    801034 <strtol+0x78>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	40                   	inc    %eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 78                	cmp    $0x78,%al
  801025:	75 0d                	jne    801034 <strtol+0x78>
		s += 2, base = 16;
  801027:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801032:	eb 28                	jmp    80105c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801038:	75 15                	jne    80104f <strtol+0x93>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 30                	cmp    $0x30,%al
  801041:	75 0c                	jne    80104f <strtol+0x93>
		s++, base = 8;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104d:	eb 0d                	jmp    80105c <strtol+0xa0>
	else if (base == 0)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	75 07                	jne    80105c <strtol+0xa0>
		base = 10;
  801055:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 2f                	cmp    $0x2f,%al
  801063:	7e 19                	jle    80107e <strtol+0xc2>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 39                	cmp    $0x39,%al
  80106c:	7f 10                	jg     80107e <strtol+0xc2>
			dig = *s - '0';
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	0f be c0             	movsbl %al,%eax
  801076:	83 e8 30             	sub    $0x30,%eax
  801079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107c:	eb 42                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 60                	cmp    $0x60,%al
  801085:	7e 19                	jle    8010a0 <strtol+0xe4>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 7a                	cmp    $0x7a,%al
  80108e:	7f 10                	jg     8010a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f be c0             	movsbl %al,%eax
  801098:	83 e8 57             	sub    $0x57,%eax
  80109b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109e:	eb 20                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 40                	cmp    $0x40,%al
  8010a7:	7e 39                	jle    8010e2 <strtol+0x126>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 5a                	cmp    $0x5a,%al
  8010b0:	7f 30                	jg     8010e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 37             	sub    $0x37,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c6:	7d 19                	jge    8010e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c8:	ff 45 08             	incl   0x8(%ebp)
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010dc:	e9 7b ff ff ff       	jmp    80105c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e6:	74 08                	je     8010f0 <strtol+0x134>
		*endptr = (char *) s;
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f4:	74 07                	je     8010fd <strtol+0x141>
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	f7 d8                	neg    %eax
  8010fb:	eb 03                	jmp    801100 <strtol+0x144>
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <ltostr>:

void
ltostr(long value, char *str)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111a:	79 13                	jns    80112f <ltostr+0x2d>
	{
		neg = 1;
  80111c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801129:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801137:	99                   	cltd   
  801138:	f7 f9                	idiv   %ecx
  80113a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8d 50 01             	lea    0x1(%eax),%edx
  801143:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801150:	83 c2 30             	add    $0x30,%edx
  801153:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115d:	f7 e9                	imul   %ecx
  80115f:	c1 fa 02             	sar    $0x2,%edx
  801162:	89 c8                	mov    %ecx,%eax
  801164:	c1 f8 1f             	sar    $0x1f,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80116e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801171:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801176:	f7 e9                	imul   %ecx
  801178:	c1 fa 02             	sar    $0x2,%edx
  80117b:	89 c8                	mov    %ecx,%eax
  80117d:	c1 f8 1f             	sar    $0x1f,%eax
  801180:	29 c2                	sub    %eax,%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	c1 e0 02             	shl    $0x2,%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	01 c0                	add    %eax,%eax
  80118b:	29 c1                	sub    %eax,%ecx
  80118d:	89 ca                	mov    %ecx,%edx
  80118f:	85 d2                	test   %edx,%edx
  801191:	75 9c                	jne    80112f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	48                   	dec    %eax
  80119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a5:	74 3d                	je     8011e4 <ltostr+0xe2>
		start = 1 ;
  8011a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ae:	eb 34                	jmp    8011e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	01 c2                	add    %eax,%edx
  8011c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	01 c8                	add    %ecx,%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	01 c2                	add    %eax,%edx
  8011d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8011de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c c4                	jl     8011b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	e8 54 fa ff ff       	call   800c5c <strlen>
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	e8 46 fa ff ff       	call   800c5c <strlen>
  801216:	83 c4 04             	add    $0x4,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80122a:	eb 17                	jmp    801243 <strcconcat+0x49>
		final[s] = str1[s] ;
  80122c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	01 c2                	add    %eax,%edx
  801234:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 c8                	add    %ecx,%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801240:	ff 45 fc             	incl   -0x4(%ebp)
  801243:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801246:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801249:	7c e1                	jl     80122c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80124b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801259:	eb 1f                	jmp    80127a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	8d 50 01             	lea    0x1(%eax),%edx
  801261:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801264:	89 c2                	mov    %eax,%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 c2                	add    %eax,%edx
  80126b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801277:	ff 45 f8             	incl   -0x8(%ebp)
  80127a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801280:	7c d9                	jl     80125b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c6 00 00             	movb   $0x0,(%eax)
}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80129c:	8b 45 14             	mov    0x14(%ebp),%eax
  80129f:	8b 00                	mov    (%eax),%eax
  8012a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b3:	eb 0c                	jmp    8012c1 <strsplit+0x31>
			*string++ = 0;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8d 50 01             	lea    0x1(%eax),%edx
  8012bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	74 18                	je     8012e2 <strsplit+0x52>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	e8 13 fb ff ff       	call   800dee <strchr>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 d3                	jne    8012b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 5a                	je     801345 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	83 f8 0f             	cmp    $0xf,%eax
  8012f3:	75 07                	jne    8012fc <strsplit+0x6c>
		{
			return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	eb 66                	jmp    801362 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	8d 48 01             	lea    0x1(%eax),%ecx
  801304:	8b 55 14             	mov    0x14(%ebp),%edx
  801307:	89 0a                	mov    %ecx,(%edx)
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 c2                	add    %eax,%edx
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131a:	eb 03                	jmp    80131f <strsplit+0x8f>
			string++;
  80131c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	84 c0                	test   %al,%al
  801326:	74 8b                	je     8012b3 <strsplit+0x23>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	0f be c0             	movsbl %al,%eax
  801330:	50                   	push   %eax
  801331:	ff 75 0c             	pushl  0xc(%ebp)
  801334:	e8 b5 fa ff ff       	call   800dee <strchr>
  801339:	83 c4 08             	add    $0x8,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	74 dc                	je     80131c <strsplit+0x8c>
			string++;
	}
  801340:	e9 6e ff ff ff       	jmp    8012b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801345:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80135d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80136a:	a1 04 40 80 00       	mov    0x804004,%eax
  80136f:	85 c0                	test   %eax,%eax
  801371:	74 1f                	je     801392 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801373:	e8 1d 00 00 00       	call   801395 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	68 f0 39 80 00       	push   $0x8039f0
  801380:	e8 55 f2 ff ff       	call   8005da <cprintf>
  801385:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801388:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80138f:	00 00 00 
	}
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80139b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013a2:	00 00 00 
  8013a5:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013ac:	00 00 00 
  8013af:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013b6:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8013b9:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013c0:	00 00 00 
  8013c3:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013ca:	00 00 00 
  8013cd:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013d4:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8013d7:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013de:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8013e1:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013f5:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8013fa:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801401:	a1 20 41 80 00       	mov    0x804120,%eax
  801406:	c1 e0 04             	shl    $0x4,%eax
  801409:	89 c2                	mov    %eax,%edx
  80140b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140e:	01 d0                	add    %edx,%eax
  801410:	48                   	dec    %eax
  801411:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801414:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801417:	ba 00 00 00 00       	mov    $0x0,%edx
  80141c:	f7 75 f0             	divl   -0x10(%ebp)
  80141f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801422:	29 d0                	sub    %edx,%eax
  801424:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801427:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80142e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801436:	2d 00 10 00 00       	sub    $0x1000,%eax
  80143b:	83 ec 04             	sub    $0x4,%esp
  80143e:	6a 06                	push   $0x6
  801440:	ff 75 e8             	pushl  -0x18(%ebp)
  801443:	50                   	push   %eax
  801444:	e8 b0 05 00 00       	call   8019f9 <sys_allocate_chunk>
  801449:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80144c:	a1 20 41 80 00       	mov    0x804120,%eax
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	50                   	push   %eax
  801455:	e8 25 0c 00 00       	call   80207f <initialize_MemBlocksList>
  80145a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  80145d:	a1 48 41 80 00       	mov    0x804148,%eax
  801462:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801465:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801469:	75 14                	jne    80147f <initialize_dyn_block_system+0xea>
  80146b:	83 ec 04             	sub    $0x4,%esp
  80146e:	68 15 3a 80 00       	push   $0x803a15
  801473:	6a 29                	push   $0x29
  801475:	68 33 3a 80 00       	push   $0x803a33
  80147a:	e8 a7 ee ff ff       	call   800326 <_panic>
  80147f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801482:	8b 00                	mov    (%eax),%eax
  801484:	85 c0                	test   %eax,%eax
  801486:	74 10                	je     801498 <initialize_dyn_block_system+0x103>
  801488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148b:	8b 00                	mov    (%eax),%eax
  80148d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801490:	8b 52 04             	mov    0x4(%edx),%edx
  801493:	89 50 04             	mov    %edx,0x4(%eax)
  801496:	eb 0b                	jmp    8014a3 <initialize_dyn_block_system+0x10e>
  801498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149b:	8b 40 04             	mov    0x4(%eax),%eax
  80149e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a6:	8b 40 04             	mov    0x4(%eax),%eax
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	74 0f                	je     8014bc <initialize_dyn_block_system+0x127>
  8014ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b0:	8b 40 04             	mov    0x4(%eax),%eax
  8014b3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014b6:	8b 12                	mov    (%edx),%edx
  8014b8:	89 10                	mov    %edx,(%eax)
  8014ba:	eb 0a                	jmp    8014c6 <initialize_dyn_block_system+0x131>
  8014bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014bf:	8b 00                	mov    (%eax),%eax
  8014c1:	a3 48 41 80 00       	mov    %eax,0x804148
  8014c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014d9:	a1 54 41 80 00       	mov    0x804154,%eax
  8014de:	48                   	dec    %eax
  8014df:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  8014e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e7:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8014ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8014f8:	83 ec 0c             	sub    $0xc,%esp
  8014fb:	ff 75 e0             	pushl  -0x20(%ebp)
  8014fe:	e8 b9 14 00 00       	call   8029bc <insert_sorted_with_merge_freeList>
  801503:	83 c4 10             	add    $0x10,%esp

}
  801506:	90                   	nop
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80150f:	e8 50 fe ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  801514:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801518:	75 07                	jne    801521 <malloc+0x18>
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
  80151f:	eb 68                	jmp    801589 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801521:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801528:	8b 55 08             	mov    0x8(%ebp),%edx
  80152b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152e:	01 d0                	add    %edx,%eax
  801530:	48                   	dec    %eax
  801531:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801537:	ba 00 00 00 00       	mov    $0x0,%edx
  80153c:	f7 75 f4             	divl   -0xc(%ebp)
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	29 d0                	sub    %edx,%eax
  801544:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801547:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80154e:	e8 74 08 00 00       	call   801dc7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801553:	85 c0                	test   %eax,%eax
  801555:	74 2d                	je     801584 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801557:	83 ec 0c             	sub    $0xc,%esp
  80155a:	ff 75 ec             	pushl  -0x14(%ebp)
  80155d:	e8 52 0e 00 00       	call   8023b4 <alloc_block_FF>
  801562:	83 c4 10             	add    $0x10,%esp
  801565:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801568:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80156c:	74 16                	je     801584 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  80156e:	83 ec 0c             	sub    $0xc,%esp
  801571:	ff 75 e8             	pushl  -0x18(%ebp)
  801574:	e8 3b 0c 00 00       	call   8021b4 <insert_sorted_allocList>
  801579:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80157c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80157f:	8b 40 08             	mov    0x8(%eax),%eax
  801582:	eb 05                	jmp    801589 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801584:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801589:	c9                   	leave  
  80158a:	c3                   	ret    

0080158b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801591:	8b 45 08             	mov    0x8(%ebp),%eax
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	50                   	push   %eax
  801598:	68 40 40 80 00       	push   $0x804040
  80159d:	e8 ba 0b 00 00       	call   80215c <find_block>
  8015a2:	83 c4 10             	add    $0x10,%esp
  8015a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8015b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015b5:	0f 84 9f 00 00 00    	je     80165a <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	83 ec 08             	sub    $0x8,%esp
  8015c1:	ff 75 f0             	pushl  -0x10(%ebp)
  8015c4:	50                   	push   %eax
  8015c5:	e8 f7 03 00 00       	call   8019c1 <sys_free_user_mem>
  8015ca:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  8015cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015d1:	75 14                	jne    8015e7 <free+0x5c>
  8015d3:	83 ec 04             	sub    $0x4,%esp
  8015d6:	68 15 3a 80 00       	push   $0x803a15
  8015db:	6a 6a                	push   $0x6a
  8015dd:	68 33 3a 80 00       	push   $0x803a33
  8015e2:	e8 3f ed ff ff       	call   800326 <_panic>
  8015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ea:	8b 00                	mov    (%eax),%eax
  8015ec:	85 c0                	test   %eax,%eax
  8015ee:	74 10                	je     801600 <free+0x75>
  8015f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f3:	8b 00                	mov    (%eax),%eax
  8015f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015f8:	8b 52 04             	mov    0x4(%edx),%edx
  8015fb:	89 50 04             	mov    %edx,0x4(%eax)
  8015fe:	eb 0b                	jmp    80160b <free+0x80>
  801600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801603:	8b 40 04             	mov    0x4(%eax),%eax
  801606:	a3 44 40 80 00       	mov    %eax,0x804044
  80160b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160e:	8b 40 04             	mov    0x4(%eax),%eax
  801611:	85 c0                	test   %eax,%eax
  801613:	74 0f                	je     801624 <free+0x99>
  801615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801618:	8b 40 04             	mov    0x4(%eax),%eax
  80161b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80161e:	8b 12                	mov    (%edx),%edx
  801620:	89 10                	mov    %edx,(%eax)
  801622:	eb 0a                	jmp    80162e <free+0xa3>
  801624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801627:	8b 00                	mov    (%eax),%eax
  801629:	a3 40 40 80 00       	mov    %eax,0x804040
  80162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801631:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80163a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801641:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801646:	48                   	dec    %eax
  801647:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  80164c:	83 ec 0c             	sub    $0xc,%esp
  80164f:	ff 75 f4             	pushl  -0xc(%ebp)
  801652:	e8 65 13 00 00       	call   8029bc <insert_sorted_with_merge_freeList>
  801657:	83 c4 10             	add    $0x10,%esp
	}
}
  80165a:	90                   	nop
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
  801660:	83 ec 28             	sub    $0x28,%esp
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801669:	e8 f6 fc ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  80166e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801672:	75 0a                	jne    80167e <smalloc+0x21>
  801674:	b8 00 00 00 00       	mov    $0x0,%eax
  801679:	e9 af 00 00 00       	jmp    80172d <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80167e:	e8 44 07 00 00       	call   801dc7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801683:	83 f8 01             	cmp    $0x1,%eax
  801686:	0f 85 9c 00 00 00    	jne    801728 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80168c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801693:	8b 55 0c             	mov    0xc(%ebp),%edx
  801696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801699:	01 d0                	add    %edx,%eax
  80169b:	48                   	dec    %eax
  80169c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a7:	f7 75 f4             	divl   -0xc(%ebp)
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ad:	29 d0                	sub    %edx,%eax
  8016af:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8016b2:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  8016b9:	76 07                	jbe    8016c2 <smalloc+0x65>
			return NULL;
  8016bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c0:	eb 6b                	jmp    80172d <smalloc+0xd0>
		blk =alloc_block_FF(size);
  8016c2:	83 ec 0c             	sub    $0xc,%esp
  8016c5:	ff 75 0c             	pushl  0xc(%ebp)
  8016c8:	e8 e7 0c 00 00       	call   8023b4 <alloc_block_FF>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  8016d3:	83 ec 0c             	sub    $0xc,%esp
  8016d6:	ff 75 ec             	pushl  -0x14(%ebp)
  8016d9:	e8 d6 0a 00 00       	call   8021b4 <insert_sorted_allocList>
  8016de:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8016e1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016e5:	75 07                	jne    8016ee <smalloc+0x91>
		{
			return NULL;
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ec:	eb 3f                	jmp    80172d <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8016ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f1:	8b 40 08             	mov    0x8(%eax),%eax
  8016f4:	89 c2                	mov    %eax,%edx
  8016f6:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016fa:	52                   	push   %edx
  8016fb:	50                   	push   %eax
  8016fc:	ff 75 0c             	pushl  0xc(%ebp)
  8016ff:	ff 75 08             	pushl  0x8(%ebp)
  801702:	e8 45 04 00 00       	call   801b4c <sys_createSharedObject>
  801707:	83 c4 10             	add    $0x10,%esp
  80170a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80170d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801711:	74 06                	je     801719 <smalloc+0xbc>
  801713:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801717:	75 07                	jne    801720 <smalloc+0xc3>
		{
			return NULL;
  801719:	b8 00 00 00 00       	mov    $0x0,%eax
  80171e:	eb 0d                	jmp    80172d <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801720:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801723:	8b 40 08             	mov    0x8(%eax),%eax
  801726:	eb 05                	jmp    80172d <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801735:	e8 2a fc ff ff       	call   801364 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 0c             	pushl  0xc(%ebp)
  801740:	ff 75 08             	pushl  0x8(%ebp)
  801743:	e8 2e 04 00 00       	call   801b76 <sys_getSizeOfSharedObject>
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  80174e:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801752:	75 0a                	jne    80175e <sget+0x2f>
	{
		return NULL;
  801754:	b8 00 00 00 00       	mov    $0x0,%eax
  801759:	e9 94 00 00 00       	jmp    8017f2 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80175e:	e8 64 06 00 00       	call   801dc7 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801763:	85 c0                	test   %eax,%eax
  801765:	0f 84 82 00 00 00    	je     8017ed <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  80176b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801772:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801779:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80177f:	01 d0                	add    %edx,%eax
  801781:	48                   	dec    %eax
  801782:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801785:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801788:	ba 00 00 00 00       	mov    $0x0,%edx
  80178d:	f7 75 ec             	divl   -0x14(%ebp)
  801790:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801793:	29 d0                	sub    %edx,%eax
  801795:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801798:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179b:	83 ec 0c             	sub    $0xc,%esp
  80179e:	50                   	push   %eax
  80179f:	e8 10 0c 00 00       	call   8023b4 <alloc_block_FF>
  8017a4:	83 c4 10             	add    $0x10,%esp
  8017a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8017aa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017ae:	75 07                	jne    8017b7 <sget+0x88>
		{
			return NULL;
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b5:	eb 3b                	jmp    8017f2 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	8b 40 08             	mov    0x8(%eax),%eax
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	50                   	push   %eax
  8017c1:	ff 75 0c             	pushl  0xc(%ebp)
  8017c4:	ff 75 08             	pushl  0x8(%ebp)
  8017c7:	e8 c7 03 00 00       	call   801b93 <sys_getSharedObject>
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  8017d2:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8017d6:	74 06                	je     8017de <sget+0xaf>
  8017d8:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8017dc:	75 07                	jne    8017e5 <sget+0xb6>
		{
			return NULL;
  8017de:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e3:	eb 0d                	jmp    8017f2 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8017e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e8:	8b 40 08             	mov    0x8(%eax),%eax
  8017eb:	eb 05                	jmp    8017f2 <sget+0xc3>
		}
	}
	else
			return NULL;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017f2:	c9                   	leave  
  8017f3:	c3                   	ret    

008017f4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017fa:	e8 65 fb ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017ff:	83 ec 04             	sub    $0x4,%esp
  801802:	68 40 3a 80 00       	push   $0x803a40
  801807:	68 e1 00 00 00       	push   $0xe1
  80180c:	68 33 3a 80 00       	push   $0x803a33
  801811:	e8 10 eb ff ff       	call   800326 <_panic>

00801816 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80181c:	83 ec 04             	sub    $0x4,%esp
  80181f:	68 68 3a 80 00       	push   $0x803a68
  801824:	68 f5 00 00 00       	push   $0xf5
  801829:	68 33 3a 80 00       	push   $0x803a33
  80182e:	e8 f3 ea ff ff       	call   800326 <_panic>

00801833 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801839:	83 ec 04             	sub    $0x4,%esp
  80183c:	68 8c 3a 80 00       	push   $0x803a8c
  801841:	68 00 01 00 00       	push   $0x100
  801846:	68 33 3a 80 00       	push   $0x803a33
  80184b:	e8 d6 ea ff ff       	call   800326 <_panic>

00801850 <shrink>:

}
void shrink(uint32 newSize)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801856:	83 ec 04             	sub    $0x4,%esp
  801859:	68 8c 3a 80 00       	push   $0x803a8c
  80185e:	68 05 01 00 00       	push   $0x105
  801863:	68 33 3a 80 00       	push   $0x803a33
  801868:	e8 b9 ea ff ff       	call   800326 <_panic>

0080186d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	68 8c 3a 80 00       	push   $0x803a8c
  80187b:	68 0a 01 00 00       	push   $0x10a
  801880:	68 33 3a 80 00       	push   $0x803a33
  801885:	e8 9c ea ff ff       	call   800326 <_panic>

0080188a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	57                   	push   %edi
  80188e:	56                   	push   %esi
  80188f:	53                   	push   %ebx
  801890:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801893:	8b 45 08             	mov    0x8(%ebp),%eax
  801896:	8b 55 0c             	mov    0xc(%ebp),%edx
  801899:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80189c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80189f:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018a2:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018a5:	cd 30                	int    $0x30
  8018a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	5b                   	pop    %ebx
  8018b1:	5e                   	pop    %esi
  8018b2:	5f                   	pop    %edi
  8018b3:	5d                   	pop    %ebp
  8018b4:	c3                   	ret    

008018b5 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8018be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018c1:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	52                   	push   %edx
  8018cd:	ff 75 0c             	pushl  0xc(%ebp)
  8018d0:	50                   	push   %eax
  8018d1:	6a 00                	push   $0x0
  8018d3:	e8 b2 ff ff ff       	call   80188a <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	90                   	nop
  8018dc:	c9                   	leave  
  8018dd:	c3                   	ret    

008018de <sys_cgetc>:

int
sys_cgetc(void)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 01                	push   $0x1
  8018ed:	e8 98 ff ff ff       	call   80188a <syscall>
  8018f2:	83 c4 18             	add    $0x18,%esp
}
  8018f5:	c9                   	leave  
  8018f6:	c3                   	ret    

008018f7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	52                   	push   %edx
  801907:	50                   	push   %eax
  801908:	6a 05                	push   $0x5
  80190a:	e8 7b ff ff ff       	call   80188a <syscall>
  80190f:	83 c4 18             	add    $0x18,%esp
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801919:	8b 75 18             	mov    0x18(%ebp),%esi
  80191c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801922:	8b 55 0c             	mov    0xc(%ebp),%edx
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	56                   	push   %esi
  801929:	53                   	push   %ebx
  80192a:	51                   	push   %ecx
  80192b:	52                   	push   %edx
  80192c:	50                   	push   %eax
  80192d:	6a 06                	push   $0x6
  80192f:	e8 56 ff ff ff       	call   80188a <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80193a:	5b                   	pop    %ebx
  80193b:	5e                   	pop    %esi
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    

0080193e <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801941:	8b 55 0c             	mov    0xc(%ebp),%edx
  801944:	8b 45 08             	mov    0x8(%ebp),%eax
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	52                   	push   %edx
  80194e:	50                   	push   %eax
  80194f:	6a 07                	push   $0x7
  801951:	e8 34 ff ff ff       	call   80188a <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	ff 75 0c             	pushl  0xc(%ebp)
  801967:	ff 75 08             	pushl  0x8(%ebp)
  80196a:	6a 08                	push   $0x8
  80196c:	e8 19 ff ff ff       	call   80188a <syscall>
  801971:	83 c4 18             	add    $0x18,%esp
}
  801974:	c9                   	leave  
  801975:	c3                   	ret    

00801976 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 09                	push   $0x9
  801985:	e8 00 ff ff ff       	call   80188a <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
}
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 0a                	push   $0xa
  80199e:	e8 e7 fe ff ff       	call   80188a <syscall>
  8019a3:	83 c4 18             	add    $0x18,%esp
}
  8019a6:	c9                   	leave  
  8019a7:	c3                   	ret    

008019a8 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 0b                	push   $0xb
  8019b7:	e8 ce fe ff ff       	call   80188a <syscall>
  8019bc:	83 c4 18             	add    $0x18,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	ff 75 0c             	pushl  0xc(%ebp)
  8019cd:	ff 75 08             	pushl  0x8(%ebp)
  8019d0:	6a 0f                	push   $0xf
  8019d2:	e8 b3 fe ff ff       	call   80188a <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
	return;
  8019da:	90                   	nop
}
  8019db:	c9                   	leave  
  8019dc:	c3                   	ret    

008019dd <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	ff 75 08             	pushl  0x8(%ebp)
  8019ec:	6a 10                	push   $0x10
  8019ee:	e8 97 fe ff ff       	call   80188a <syscall>
  8019f3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f6:	90                   	nop
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	ff 75 10             	pushl  0x10(%ebp)
  801a03:	ff 75 0c             	pushl  0xc(%ebp)
  801a06:	ff 75 08             	pushl  0x8(%ebp)
  801a09:	6a 11                	push   $0x11
  801a0b:	e8 7a fe ff ff       	call   80188a <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
	return ;
  801a13:	90                   	nop
}
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 0c                	push   $0xc
  801a25:	e8 60 fe ff ff       	call   80188a <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a32:	6a 00                	push   $0x0
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	ff 75 08             	pushl  0x8(%ebp)
  801a3d:	6a 0d                	push   $0xd
  801a3f:	e8 46 fe ff ff       	call   80188a <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 0e                	push   $0xe
  801a58:	e8 2d fe ff ff       	call   80188a <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 13                	push   $0x13
  801a72:	e8 13 fe ff ff       	call   80188a <syscall>
  801a77:	83 c4 18             	add    $0x18,%esp
}
  801a7a:	90                   	nop
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 14                	push   $0x14
  801a8c:	e8 f9 fd ff ff       	call   80188a <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aa3:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	50                   	push   %eax
  801ab0:	6a 15                	push   $0x15
  801ab2:	e8 d3 fd ff ff       	call   80188a <syscall>
  801ab7:	83 c4 18             	add    $0x18,%esp
}
  801aba:	90                   	nop
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	6a 16                	push   $0x16
  801acc:	e8 b9 fd ff ff       	call   80188a <syscall>
  801ad1:	83 c4 18             	add    $0x18,%esp
}
  801ad4:	90                   	nop
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ada:	8b 45 08             	mov    0x8(%ebp),%eax
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	ff 75 0c             	pushl  0xc(%ebp)
  801ae6:	50                   	push   %eax
  801ae7:	6a 17                	push   $0x17
  801ae9:	e8 9c fd ff ff       	call   80188a <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af9:	8b 45 08             	mov    0x8(%ebp),%eax
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	52                   	push   %edx
  801b03:	50                   	push   %eax
  801b04:	6a 1a                	push   $0x1a
  801b06:	e8 7f fd ff ff       	call   80188a <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
}
  801b0e:	c9                   	leave  
  801b0f:	c3                   	ret    

00801b10 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b13:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b16:	8b 45 08             	mov    0x8(%ebp),%eax
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	52                   	push   %edx
  801b20:	50                   	push   %eax
  801b21:	6a 18                	push   $0x18
  801b23:	e8 62 fd ff ff       	call   80188a <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
}
  801b2b:	90                   	nop
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b31:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b34:	8b 45 08             	mov    0x8(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	52                   	push   %edx
  801b3e:	50                   	push   %eax
  801b3f:	6a 19                	push   $0x19
  801b41:	e8 44 fd ff ff       	call   80188a <syscall>
  801b46:	83 c4 18             	add    $0x18,%esp
}
  801b49:	90                   	nop
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	8b 45 10             	mov    0x10(%ebp),%eax
  801b55:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b58:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b5b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	51                   	push   %ecx
  801b65:	52                   	push   %edx
  801b66:	ff 75 0c             	pushl  0xc(%ebp)
  801b69:	50                   	push   %eax
  801b6a:	6a 1b                	push   $0x1b
  801b6c:	e8 19 fd ff ff       	call   80188a <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	52                   	push   %edx
  801b86:	50                   	push   %eax
  801b87:	6a 1c                	push   $0x1c
  801b89:	e8 fc fc ff ff       	call   80188a <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b96:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b99:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	51                   	push   %ecx
  801ba4:	52                   	push   %edx
  801ba5:	50                   	push   %eax
  801ba6:	6a 1d                	push   $0x1d
  801ba8:	e8 dd fc ff ff       	call   80188a <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	52                   	push   %edx
  801bc2:	50                   	push   %eax
  801bc3:	6a 1e                	push   $0x1e
  801bc5:	e8 c0 fc ff ff       	call   80188a <syscall>
  801bca:	83 c4 18             	add    $0x18,%esp
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 1f                	push   $0x1f
  801bde:	e8 a7 fc ff ff       	call   80188a <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801beb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bee:	6a 00                	push   $0x0
  801bf0:	ff 75 14             	pushl  0x14(%ebp)
  801bf3:	ff 75 10             	pushl  0x10(%ebp)
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	50                   	push   %eax
  801bfa:	6a 20                	push   $0x20
  801bfc:	e8 89 fc ff ff       	call   80188a <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	50                   	push   %eax
  801c15:	6a 21                	push   $0x21
  801c17:	e8 6e fc ff ff       	call   80188a <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
}
  801c1f:	90                   	nop
  801c20:	c9                   	leave  
  801c21:	c3                   	ret    

00801c22 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c25:	8b 45 08             	mov    0x8(%ebp),%eax
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	50                   	push   %eax
  801c31:	6a 22                	push   $0x22
  801c33:	e8 52 fc ff ff       	call   80188a <syscall>
  801c38:	83 c4 18             	add    $0x18,%esp
}
  801c3b:	c9                   	leave  
  801c3c:	c3                   	ret    

00801c3d <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 02                	push   $0x2
  801c4c:	e8 39 fc ff ff       	call   80188a <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	c9                   	leave  
  801c55:	c3                   	ret    

00801c56 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	6a 00                	push   $0x0
  801c63:	6a 03                	push   $0x3
  801c65:	e8 20 fc ff ff       	call   80188a <syscall>
  801c6a:	83 c4 18             	add    $0x18,%esp
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 04                	push   $0x4
  801c7e:	e8 07 fc ff ff       	call   80188a <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
}
  801c86:	c9                   	leave  
  801c87:	c3                   	ret    

00801c88 <sys_exit_env>:


void sys_exit_env(void)
{
  801c88:	55                   	push   %ebp
  801c89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 23                	push   $0x23
  801c97:	e8 ee fb ff ff       	call   80188a <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	90                   	nop
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cab:	8d 50 04             	lea    0x4(%eax),%edx
  801cae:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	52                   	push   %edx
  801cb8:	50                   	push   %eax
  801cb9:	6a 24                	push   $0x24
  801cbb:	e8 ca fb ff ff       	call   80188a <syscall>
  801cc0:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ccc:	89 01                	mov    %eax,(%ecx)
  801cce:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	c9                   	leave  
  801cd5:	c2 04 00             	ret    $0x4

00801cd8 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd8:	55                   	push   %ebp
  801cd9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	ff 75 10             	pushl  0x10(%ebp)
  801ce2:	ff 75 0c             	pushl  0xc(%ebp)
  801ce5:	ff 75 08             	pushl  0x8(%ebp)
  801ce8:	6a 12                	push   $0x12
  801cea:	e8 9b fb ff ff       	call   80188a <syscall>
  801cef:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf2:	90                   	nop
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 25                	push   $0x25
  801d04:	e8 81 fb ff ff       	call   80188a <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
}
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
  801d11:	83 ec 04             	sub    $0x4,%esp
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d1a:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	50                   	push   %eax
  801d27:	6a 26                	push   $0x26
  801d29:	e8 5c fb ff ff       	call   80188a <syscall>
  801d2e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d31:	90                   	nop
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <rsttst>:
void rsttst()
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 28                	push   $0x28
  801d43:	e8 42 fb ff ff       	call   80188a <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4b:	90                   	nop
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	8b 45 14             	mov    0x14(%ebp),%eax
  801d57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d5a:	8b 55 18             	mov    0x18(%ebp),%edx
  801d5d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d61:	52                   	push   %edx
  801d62:	50                   	push   %eax
  801d63:	ff 75 10             	pushl  0x10(%ebp)
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	ff 75 08             	pushl  0x8(%ebp)
  801d6c:	6a 27                	push   $0x27
  801d6e:	e8 17 fb ff ff       	call   80188a <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
	return ;
  801d76:	90                   	nop
}
  801d77:	c9                   	leave  
  801d78:	c3                   	ret    

00801d79 <chktst>:
void chktst(uint32 n)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	ff 75 08             	pushl  0x8(%ebp)
  801d87:	6a 29                	push   $0x29
  801d89:	e8 fc fa ff ff       	call   80188a <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d91:	90                   	nop
}
  801d92:	c9                   	leave  
  801d93:	c3                   	ret    

00801d94 <inctst>:

void inctst()
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 2a                	push   $0x2a
  801da3:	e8 e2 fa ff ff       	call   80188a <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dab:	90                   	nop
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <gettst>:
uint32 gettst()
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 2b                	push   $0x2b
  801dbd:	e8 c8 fa ff ff       	call   80188a <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 2c                	push   $0x2c
  801dd9:	e8 ac fa ff ff       	call   80188a <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
  801de1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801de4:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801de8:	75 07                	jne    801df1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dea:	b8 01 00 00 00       	mov    $0x1,%eax
  801def:	eb 05                	jmp    801df6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801df1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 2c                	push   $0x2c
  801e0a:	e8 7b fa ff ff       	call   80188a <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
  801e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e15:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e19:	75 07                	jne    801e22 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e20:	eb 05                	jmp    801e27 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 2c                	push   $0x2c
  801e3b:	e8 4a fa ff ff       	call   80188a <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e46:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e4a:	75 07                	jne    801e53 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e51:	eb 05                	jmp    801e58 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 2c                	push   $0x2c
  801e6c:	e8 19 fa ff ff       	call   80188a <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
  801e74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e77:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e7b:	75 07                	jne    801e84 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e82:	eb 05                	jmp    801e89 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	ff 75 08             	pushl  0x8(%ebp)
  801e99:	6a 2d                	push   $0x2d
  801e9b:	e8 ea f9 ff ff       	call   80188a <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea3:	90                   	nop
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eaa:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ead:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb6:	6a 00                	push   $0x0
  801eb8:	53                   	push   %ebx
  801eb9:	51                   	push   %ecx
  801eba:	52                   	push   %edx
  801ebb:	50                   	push   %eax
  801ebc:	6a 2e                	push   $0x2e
  801ebe:	e8 c7 f9 ff ff       	call   80188a <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ece:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	52                   	push   %edx
  801edb:	50                   	push   %eax
  801edc:	6a 2f                	push   $0x2f
  801ede:	e8 a7 f9 ff ff       	call   80188a <syscall>
  801ee3:	83 c4 18             	add    $0x18,%esp
}
  801ee6:	c9                   	leave  
  801ee7:	c3                   	ret    

00801ee8 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ee8:	55                   	push   %ebp
  801ee9:	89 e5                	mov    %esp,%ebp
  801eeb:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eee:	83 ec 0c             	sub    $0xc,%esp
  801ef1:	68 9c 3a 80 00       	push   $0x803a9c
  801ef6:	e8 df e6 ff ff       	call   8005da <cprintf>
  801efb:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801efe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	68 c8 3a 80 00       	push   $0x803ac8
  801f0d:	e8 c8 e6 ff ff       	call   8005da <cprintf>
  801f12:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f15:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f19:	a1 38 41 80 00       	mov    0x804138,%eax
  801f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f21:	eb 56                	jmp    801f79 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f27:	74 1c                	je     801f45 <print_mem_block_lists+0x5d>
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	8b 50 08             	mov    0x8(%eax),%edx
  801f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f32:	8b 48 08             	mov    0x8(%eax),%ecx
  801f35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f38:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3b:	01 c8                	add    %ecx,%eax
  801f3d:	39 c2                	cmp    %eax,%edx
  801f3f:	73 04                	jae    801f45 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f41:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 50 08             	mov    0x8(%eax),%edx
  801f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f51:	01 c2                	add    %eax,%edx
  801f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f56:	8b 40 08             	mov    0x8(%eax),%eax
  801f59:	83 ec 04             	sub    $0x4,%esp
  801f5c:	52                   	push   %edx
  801f5d:	50                   	push   %eax
  801f5e:	68 dd 3a 80 00       	push   $0x803add
  801f63:	e8 72 e6 ff ff       	call   8005da <cprintf>
  801f68:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f71:	a1 40 41 80 00       	mov    0x804140,%eax
  801f76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7d:	74 07                	je     801f86 <print_mem_block_lists+0x9e>
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	8b 00                	mov    (%eax),%eax
  801f84:	eb 05                	jmp    801f8b <print_mem_block_lists+0xa3>
  801f86:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8b:	a3 40 41 80 00       	mov    %eax,0x804140
  801f90:	a1 40 41 80 00       	mov    0x804140,%eax
  801f95:	85 c0                	test   %eax,%eax
  801f97:	75 8a                	jne    801f23 <print_mem_block_lists+0x3b>
  801f99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9d:	75 84                	jne    801f23 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f9f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa3:	75 10                	jne    801fb5 <print_mem_block_lists+0xcd>
  801fa5:	83 ec 0c             	sub    $0xc,%esp
  801fa8:	68 ec 3a 80 00       	push   $0x803aec
  801fad:	e8 28 e6 ff ff       	call   8005da <cprintf>
  801fb2:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fb5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fbc:	83 ec 0c             	sub    $0xc,%esp
  801fbf:	68 10 3b 80 00       	push   $0x803b10
  801fc4:	e8 11 e6 ff ff       	call   8005da <cprintf>
  801fc9:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fcc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd0:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd8:	eb 56                	jmp    802030 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fda:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fde:	74 1c                	je     801ffc <print_mem_block_lists+0x114>
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	8b 50 08             	mov    0x8(%eax),%edx
  801fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe9:	8b 48 08             	mov    0x8(%eax),%ecx
  801fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fef:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff2:	01 c8                	add    %ecx,%eax
  801ff4:	39 c2                	cmp    %eax,%edx
  801ff6:	73 04                	jae    801ffc <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ff8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	8b 50 08             	mov    0x8(%eax),%edx
  802002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802005:	8b 40 0c             	mov    0xc(%eax),%eax
  802008:	01 c2                	add    %eax,%edx
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	8b 40 08             	mov    0x8(%eax),%eax
  802010:	83 ec 04             	sub    $0x4,%esp
  802013:	52                   	push   %edx
  802014:	50                   	push   %eax
  802015:	68 dd 3a 80 00       	push   $0x803add
  80201a:	e8 bb e5 ff ff       	call   8005da <cprintf>
  80201f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802028:	a1 48 40 80 00       	mov    0x804048,%eax
  80202d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802030:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802034:	74 07                	je     80203d <print_mem_block_lists+0x155>
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	8b 00                	mov    (%eax),%eax
  80203b:	eb 05                	jmp    802042 <print_mem_block_lists+0x15a>
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
  802042:	a3 48 40 80 00       	mov    %eax,0x804048
  802047:	a1 48 40 80 00       	mov    0x804048,%eax
  80204c:	85 c0                	test   %eax,%eax
  80204e:	75 8a                	jne    801fda <print_mem_block_lists+0xf2>
  802050:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802054:	75 84                	jne    801fda <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802056:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80205a:	75 10                	jne    80206c <print_mem_block_lists+0x184>
  80205c:	83 ec 0c             	sub    $0xc,%esp
  80205f:	68 28 3b 80 00       	push   $0x803b28
  802064:	e8 71 e5 ff ff       	call   8005da <cprintf>
  802069:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80206c:	83 ec 0c             	sub    $0xc,%esp
  80206f:	68 9c 3a 80 00       	push   $0x803a9c
  802074:	e8 61 e5 ff ff       	call   8005da <cprintf>
  802079:	83 c4 10             	add    $0x10,%esp

}
  80207c:	90                   	nop
  80207d:	c9                   	leave  
  80207e:	c3                   	ret    

0080207f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80207f:	55                   	push   %ebp
  802080:	89 e5                	mov    %esp,%ebp
  802082:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802085:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80208c:	00 00 00 
  80208f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802096:	00 00 00 
  802099:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020a0:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8020a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020aa:	e9 9e 00 00 00       	jmp    80214d <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8020af:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b7:	c1 e2 04             	shl    $0x4,%edx
  8020ba:	01 d0                	add    %edx,%eax
  8020bc:	85 c0                	test   %eax,%eax
  8020be:	75 14                	jne    8020d4 <initialize_MemBlocksList+0x55>
  8020c0:	83 ec 04             	sub    $0x4,%esp
  8020c3:	68 50 3b 80 00       	push   $0x803b50
  8020c8:	6a 42                	push   $0x42
  8020ca:	68 73 3b 80 00       	push   $0x803b73
  8020cf:	e8 52 e2 ff ff       	call   800326 <_panic>
  8020d4:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020dc:	c1 e2 04             	shl    $0x4,%edx
  8020df:	01 d0                	add    %edx,%eax
  8020e1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020e7:	89 10                	mov    %edx,(%eax)
  8020e9:	8b 00                	mov    (%eax),%eax
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	74 18                	je     802107 <initialize_MemBlocksList+0x88>
  8020ef:	a1 48 41 80 00       	mov    0x804148,%eax
  8020f4:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020fa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020fd:	c1 e1 04             	shl    $0x4,%ecx
  802100:	01 ca                	add    %ecx,%edx
  802102:	89 50 04             	mov    %edx,0x4(%eax)
  802105:	eb 12                	jmp    802119 <initialize_MemBlocksList+0x9a>
  802107:	a1 50 40 80 00       	mov    0x804050,%eax
  80210c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210f:	c1 e2 04             	shl    $0x4,%edx
  802112:	01 d0                	add    %edx,%eax
  802114:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802119:	a1 50 40 80 00       	mov    0x804050,%eax
  80211e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802121:	c1 e2 04             	shl    $0x4,%edx
  802124:	01 d0                	add    %edx,%eax
  802126:	a3 48 41 80 00       	mov    %eax,0x804148
  80212b:	a1 50 40 80 00       	mov    0x804050,%eax
  802130:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802133:	c1 e2 04             	shl    $0x4,%edx
  802136:	01 d0                	add    %edx,%eax
  802138:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213f:	a1 54 41 80 00       	mov    0x804154,%eax
  802144:	40                   	inc    %eax
  802145:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80214a:	ff 45 f4             	incl   -0xc(%ebp)
  80214d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802150:	3b 45 08             	cmp    0x8(%ebp),%eax
  802153:	0f 82 56 ff ff ff    	jb     8020af <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802159:	90                   	nop
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	8b 00                	mov    (%eax),%eax
  802167:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80216a:	eb 19                	jmp    802185 <find_block+0x29>
	{
		if(blk->sva==va)
  80216c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216f:	8b 40 08             	mov    0x8(%eax),%eax
  802172:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802175:	75 05                	jne    80217c <find_block+0x20>
			return (blk);
  802177:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217a:	eb 36                	jmp    8021b2 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80217c:	8b 45 08             	mov    0x8(%ebp),%eax
  80217f:	8b 40 08             	mov    0x8(%eax),%eax
  802182:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802185:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802189:	74 07                	je     802192 <find_block+0x36>
  80218b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218e:	8b 00                	mov    (%eax),%eax
  802190:	eb 05                	jmp    802197 <find_block+0x3b>
  802192:	b8 00 00 00 00       	mov    $0x0,%eax
  802197:	8b 55 08             	mov    0x8(%ebp),%edx
  80219a:	89 42 08             	mov    %eax,0x8(%edx)
  80219d:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a0:	8b 40 08             	mov    0x8(%eax),%eax
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	75 c5                	jne    80216c <find_block+0x10>
  8021a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ab:	75 bf                	jne    80216c <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8021ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021b2:	c9                   	leave  
  8021b3:	c3                   	ret    

008021b4 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021b4:	55                   	push   %ebp
  8021b5:	89 e5                	mov    %esp,%ebp
  8021b7:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8021ba:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021c2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8021c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021cf:	75 65                	jne    802236 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021d5:	75 14                	jne    8021eb <insert_sorted_allocList+0x37>
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	68 50 3b 80 00       	push   $0x803b50
  8021df:	6a 5c                	push   $0x5c
  8021e1:	68 73 3b 80 00       	push   $0x803b73
  8021e6:	e8 3b e1 ff ff       	call   800326 <_panic>
  8021eb:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	89 10                	mov    %edx,(%eax)
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	8b 00                	mov    (%eax),%eax
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	74 0d                	je     80220c <insert_sorted_allocList+0x58>
  8021ff:	a1 40 40 80 00       	mov    0x804040,%eax
  802204:	8b 55 08             	mov    0x8(%ebp),%edx
  802207:	89 50 04             	mov    %edx,0x4(%eax)
  80220a:	eb 08                	jmp    802214 <insert_sorted_allocList+0x60>
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	a3 44 40 80 00       	mov    %eax,0x804044
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	a3 40 40 80 00       	mov    %eax,0x804040
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802226:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80222b:	40                   	inc    %eax
  80222c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802231:	e9 7b 01 00 00       	jmp    8023b1 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802236:	a1 44 40 80 00       	mov    0x804044,%eax
  80223b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80223e:	a1 40 40 80 00       	mov    0x804040,%eax
  802243:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802246:	8b 45 08             	mov    0x8(%ebp),%eax
  802249:	8b 50 08             	mov    0x8(%eax),%edx
  80224c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80224f:	8b 40 08             	mov    0x8(%eax),%eax
  802252:	39 c2                	cmp    %eax,%edx
  802254:	76 65                	jbe    8022bb <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225a:	75 14                	jne    802270 <insert_sorted_allocList+0xbc>
  80225c:	83 ec 04             	sub    $0x4,%esp
  80225f:	68 8c 3b 80 00       	push   $0x803b8c
  802264:	6a 64                	push   $0x64
  802266:	68 73 3b 80 00       	push   $0x803b73
  80226b:	e8 b6 e0 ff ff       	call   800326 <_panic>
  802270:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	89 50 04             	mov    %edx,0x4(%eax)
  80227c:	8b 45 08             	mov    0x8(%ebp),%eax
  80227f:	8b 40 04             	mov    0x4(%eax),%eax
  802282:	85 c0                	test   %eax,%eax
  802284:	74 0c                	je     802292 <insert_sorted_allocList+0xde>
  802286:	a1 44 40 80 00       	mov    0x804044,%eax
  80228b:	8b 55 08             	mov    0x8(%ebp),%edx
  80228e:	89 10                	mov    %edx,(%eax)
  802290:	eb 08                	jmp    80229a <insert_sorted_allocList+0xe6>
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	a3 40 40 80 00       	mov    %eax,0x804040
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	a3 44 40 80 00       	mov    %eax,0x804044
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ab:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b0:	40                   	inc    %eax
  8022b1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022b6:	e9 f6 00 00 00       	jmp    8023b1 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	8b 50 08             	mov    0x8(%eax),%edx
  8022c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022c4:	8b 40 08             	mov    0x8(%eax),%eax
  8022c7:	39 c2                	cmp    %eax,%edx
  8022c9:	73 65                	jae    802330 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8022cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022cf:	75 14                	jne    8022e5 <insert_sorted_allocList+0x131>
  8022d1:	83 ec 04             	sub    $0x4,%esp
  8022d4:	68 50 3b 80 00       	push   $0x803b50
  8022d9:	6a 68                	push   $0x68
  8022db:	68 73 3b 80 00       	push   $0x803b73
  8022e0:	e8 41 e0 ff ff       	call   800326 <_panic>
  8022e5:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	89 10                	mov    %edx,(%eax)
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8b 00                	mov    (%eax),%eax
  8022f5:	85 c0                	test   %eax,%eax
  8022f7:	74 0d                	je     802306 <insert_sorted_allocList+0x152>
  8022f9:	a1 40 40 80 00       	mov    0x804040,%eax
  8022fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802301:	89 50 04             	mov    %edx,0x4(%eax)
  802304:	eb 08                	jmp    80230e <insert_sorted_allocList+0x15a>
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	a3 44 40 80 00       	mov    %eax,0x804044
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	a3 40 40 80 00       	mov    %eax,0x804040
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802320:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802325:	40                   	inc    %eax
  802326:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80232b:	e9 81 00 00 00       	jmp    8023b1 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802330:	a1 40 40 80 00       	mov    0x804040,%eax
  802335:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802338:	eb 51                	jmp    80238b <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	8b 50 08             	mov    0x8(%eax),%edx
  802340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802343:	8b 40 08             	mov    0x8(%eax),%eax
  802346:	39 c2                	cmp    %eax,%edx
  802348:	73 39                	jae    802383 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  80234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234d:	8b 40 04             	mov    0x4(%eax),%eax
  802350:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802356:	8b 55 08             	mov    0x8(%ebp),%edx
  802359:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  80235b:	8b 45 08             	mov    0x8(%ebp),%eax
  80235e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802361:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802364:	8b 45 08             	mov    0x8(%ebp),%eax
  802367:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236a:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 55 08             	mov    0x8(%ebp),%edx
  802372:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802375:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80237a:	40                   	inc    %eax
  80237b:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802380:	90                   	nop
				}
			}
		 }

	}
}
  802381:	eb 2e                	jmp    8023b1 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802383:	a1 48 40 80 00       	mov    0x804048,%eax
  802388:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80238b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238f:	74 07                	je     802398 <insert_sorted_allocList+0x1e4>
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 00                	mov    (%eax),%eax
  802396:	eb 05                	jmp    80239d <insert_sorted_allocList+0x1e9>
  802398:	b8 00 00 00 00       	mov    $0x0,%eax
  80239d:	a3 48 40 80 00       	mov    %eax,0x804048
  8023a2:	a1 48 40 80 00       	mov    0x804048,%eax
  8023a7:	85 c0                	test   %eax,%eax
  8023a9:	75 8f                	jne    80233a <insert_sorted_allocList+0x186>
  8023ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023af:	75 89                	jne    80233a <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8023b1:	90                   	nop
  8023b2:	c9                   	leave  
  8023b3:	c3                   	ret    

008023b4 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023b4:	55                   	push   %ebp
  8023b5:	89 e5                	mov    %esp,%ebp
  8023b7:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8023ba:	a1 38 41 80 00       	mov    0x804138,%eax
  8023bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023c2:	e9 76 01 00 00       	jmp    80253d <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8023cd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d0:	0f 85 8a 00 00 00    	jne    802460 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8023d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023da:	75 17                	jne    8023f3 <alloc_block_FF+0x3f>
  8023dc:	83 ec 04             	sub    $0x4,%esp
  8023df:	68 af 3b 80 00       	push   $0x803baf
  8023e4:	68 8a 00 00 00       	push   $0x8a
  8023e9:	68 73 3b 80 00       	push   $0x803b73
  8023ee:	e8 33 df ff ff       	call   800326 <_panic>
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	85 c0                	test   %eax,%eax
  8023fa:	74 10                	je     80240c <alloc_block_FF+0x58>
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 00                	mov    (%eax),%eax
  802401:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802404:	8b 52 04             	mov    0x4(%edx),%edx
  802407:	89 50 04             	mov    %edx,0x4(%eax)
  80240a:	eb 0b                	jmp    802417 <alloc_block_FF+0x63>
  80240c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240f:	8b 40 04             	mov    0x4(%eax),%eax
  802412:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802417:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241a:	8b 40 04             	mov    0x4(%eax),%eax
  80241d:	85 c0                	test   %eax,%eax
  80241f:	74 0f                	je     802430 <alloc_block_FF+0x7c>
  802421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802424:	8b 40 04             	mov    0x4(%eax),%eax
  802427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242a:	8b 12                	mov    (%edx),%edx
  80242c:	89 10                	mov    %edx,(%eax)
  80242e:	eb 0a                	jmp    80243a <alloc_block_FF+0x86>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	a3 38 41 80 00       	mov    %eax,0x804138
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244d:	a1 44 41 80 00       	mov    0x804144,%eax
  802452:	48                   	dec    %eax
  802453:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	e9 10 01 00 00       	jmp    802570 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802463:	8b 40 0c             	mov    0xc(%eax),%eax
  802466:	3b 45 08             	cmp    0x8(%ebp),%eax
  802469:	0f 86 c6 00 00 00    	jbe    802535 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80246f:	a1 48 41 80 00       	mov    0x804148,%eax
  802474:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802477:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80247b:	75 17                	jne    802494 <alloc_block_FF+0xe0>
  80247d:	83 ec 04             	sub    $0x4,%esp
  802480:	68 af 3b 80 00       	push   $0x803baf
  802485:	68 90 00 00 00       	push   $0x90
  80248a:	68 73 3b 80 00       	push   $0x803b73
  80248f:	e8 92 de ff ff       	call   800326 <_panic>
  802494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	85 c0                	test   %eax,%eax
  80249b:	74 10                	je     8024ad <alloc_block_FF+0xf9>
  80249d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a0:	8b 00                	mov    (%eax),%eax
  8024a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024a5:	8b 52 04             	mov    0x4(%edx),%edx
  8024a8:	89 50 04             	mov    %edx,0x4(%eax)
  8024ab:	eb 0b                	jmp    8024b8 <alloc_block_FF+0x104>
  8024ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b0:	8b 40 04             	mov    0x4(%eax),%eax
  8024b3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bb:	8b 40 04             	mov    0x4(%eax),%eax
  8024be:	85 c0                	test   %eax,%eax
  8024c0:	74 0f                	je     8024d1 <alloc_block_FF+0x11d>
  8024c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c5:	8b 40 04             	mov    0x4(%eax),%eax
  8024c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024cb:	8b 12                	mov    (%edx),%edx
  8024cd:	89 10                	mov    %edx,(%eax)
  8024cf:	eb 0a                	jmp    8024db <alloc_block_FF+0x127>
  8024d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d4:	8b 00                	mov    (%eax),%eax
  8024d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8024db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ee:	a1 54 41 80 00       	mov    0x804154,%eax
  8024f3:	48                   	dec    %eax
  8024f4:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8024f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ff:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 50 08             	mov    0x8(%eax),%edx
  802508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250b:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 50 08             	mov    0x8(%eax),%edx
  802514:	8b 45 08             	mov    0x8(%ebp),%eax
  802517:	01 c2                	add    %eax,%edx
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  80251f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802522:	8b 40 0c             	mov    0xc(%eax),%eax
  802525:	2b 45 08             	sub    0x8(%ebp),%eax
  802528:	89 c2                	mov    %eax,%edx
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802530:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802533:	eb 3b                	jmp    802570 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802535:	a1 40 41 80 00       	mov    0x804140,%eax
  80253a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802541:	74 07                	je     80254a <alloc_block_FF+0x196>
  802543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802546:	8b 00                	mov    (%eax),%eax
  802548:	eb 05                	jmp    80254f <alloc_block_FF+0x19b>
  80254a:	b8 00 00 00 00       	mov    $0x0,%eax
  80254f:	a3 40 41 80 00       	mov    %eax,0x804140
  802554:	a1 40 41 80 00       	mov    0x804140,%eax
  802559:	85 c0                	test   %eax,%eax
  80255b:	0f 85 66 fe ff ff    	jne    8023c7 <alloc_block_FF+0x13>
  802561:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802565:	0f 85 5c fe ff ff    	jne    8023c7 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  80256b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
  802575:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802578:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80257f:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802586:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80258d:	a1 38 41 80 00       	mov    0x804138,%eax
  802592:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802595:	e9 cf 00 00 00       	jmp    802669 <alloc_block_BF+0xf7>
		{
			c++;
  80259a:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a6:	0f 85 8a 00 00 00    	jne    802636 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8025ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b0:	75 17                	jne    8025c9 <alloc_block_BF+0x57>
  8025b2:	83 ec 04             	sub    $0x4,%esp
  8025b5:	68 af 3b 80 00       	push   $0x803baf
  8025ba:	68 a8 00 00 00       	push   $0xa8
  8025bf:	68 73 3b 80 00       	push   $0x803b73
  8025c4:	e8 5d dd ff ff       	call   800326 <_panic>
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 00                	mov    (%eax),%eax
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	74 10                	je     8025e2 <alloc_block_BF+0x70>
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 00                	mov    (%eax),%eax
  8025d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025da:	8b 52 04             	mov    0x4(%edx),%edx
  8025dd:	89 50 04             	mov    %edx,0x4(%eax)
  8025e0:	eb 0b                	jmp    8025ed <alloc_block_BF+0x7b>
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	8b 40 04             	mov    0x4(%eax),%eax
  8025e8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f0:	8b 40 04             	mov    0x4(%eax),%eax
  8025f3:	85 c0                	test   %eax,%eax
  8025f5:	74 0f                	je     802606 <alloc_block_BF+0x94>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 40 04             	mov    0x4(%eax),%eax
  8025fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802600:	8b 12                	mov    (%edx),%edx
  802602:	89 10                	mov    %edx,(%eax)
  802604:	eb 0a                	jmp    802610 <alloc_block_BF+0x9e>
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	a3 38 41 80 00       	mov    %eax,0x804138
  802610:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802613:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802623:	a1 44 41 80 00       	mov    0x804144,%eax
  802628:	48                   	dec    %eax
  802629:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	e9 85 01 00 00       	jmp    8027bb <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	8b 40 0c             	mov    0xc(%eax),%eax
  80263c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80263f:	76 20                	jbe    802661 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	8b 40 0c             	mov    0xc(%eax),%eax
  802647:	2b 45 08             	sub    0x8(%ebp),%eax
  80264a:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  80264d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802650:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802653:	73 0c                	jae    802661 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802655:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802658:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  80265b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80265e:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802661:	a1 40 41 80 00       	mov    0x804140,%eax
  802666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80266d:	74 07                	je     802676 <alloc_block_BF+0x104>
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	8b 00                	mov    (%eax),%eax
  802674:	eb 05                	jmp    80267b <alloc_block_BF+0x109>
  802676:	b8 00 00 00 00       	mov    $0x0,%eax
  80267b:	a3 40 41 80 00       	mov    %eax,0x804140
  802680:	a1 40 41 80 00       	mov    0x804140,%eax
  802685:	85 c0                	test   %eax,%eax
  802687:	0f 85 0d ff ff ff    	jne    80259a <alloc_block_BF+0x28>
  80268d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802691:	0f 85 03 ff ff ff    	jne    80259a <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802697:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80269e:	a1 38 41 80 00       	mov    0x804138,%eax
  8026a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a6:	e9 dd 00 00 00       	jmp    802788 <alloc_block_BF+0x216>
		{
			if(x==sol)
  8026ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ae:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026b1:	0f 85 c6 00 00 00    	jne    80277d <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8026b7:	a1 48 41 80 00       	mov    0x804148,%eax
  8026bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8026bf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026c3:	75 17                	jne    8026dc <alloc_block_BF+0x16a>
  8026c5:	83 ec 04             	sub    $0x4,%esp
  8026c8:	68 af 3b 80 00       	push   $0x803baf
  8026cd:	68 bb 00 00 00       	push   $0xbb
  8026d2:	68 73 3b 80 00       	push   $0x803b73
  8026d7:	e8 4a dc ff ff       	call   800326 <_panic>
  8026dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	85 c0                	test   %eax,%eax
  8026e3:	74 10                	je     8026f5 <alloc_block_BF+0x183>
  8026e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e8:	8b 00                	mov    (%eax),%eax
  8026ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026ed:	8b 52 04             	mov    0x4(%edx),%edx
  8026f0:	89 50 04             	mov    %edx,0x4(%eax)
  8026f3:	eb 0b                	jmp    802700 <alloc_block_BF+0x18e>
  8026f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f8:	8b 40 04             	mov    0x4(%eax),%eax
  8026fb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802703:	8b 40 04             	mov    0x4(%eax),%eax
  802706:	85 c0                	test   %eax,%eax
  802708:	74 0f                	je     802719 <alloc_block_BF+0x1a7>
  80270a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270d:	8b 40 04             	mov    0x4(%eax),%eax
  802710:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802713:	8b 12                	mov    (%edx),%edx
  802715:	89 10                	mov    %edx,(%eax)
  802717:	eb 0a                	jmp    802723 <alloc_block_BF+0x1b1>
  802719:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271c:	8b 00                	mov    (%eax),%eax
  80271e:	a3 48 41 80 00       	mov    %eax,0x804148
  802723:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802726:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80272c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802736:	a1 54 41 80 00       	mov    0x804154,%eax
  80273b:	48                   	dec    %eax
  80273c:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802741:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802744:	8b 55 08             	mov    0x8(%ebp),%edx
  802747:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 50 08             	mov    0x8(%eax),%edx
  802750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802753:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 50 08             	mov    0x8(%eax),%edx
  80275c:	8b 45 08             	mov    0x8(%ebp),%eax
  80275f:	01 c2                	add    %eax,%edx
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 40 0c             	mov    0xc(%eax),%eax
  80276d:	2b 45 08             	sub    0x8(%ebp),%eax
  802770:	89 c2                	mov    %eax,%edx
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802778:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277b:	eb 3e                	jmp    8027bb <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80277d:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802780:	a1 40 41 80 00       	mov    0x804140,%eax
  802785:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80278c:	74 07                	je     802795 <alloc_block_BF+0x223>
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 00                	mov    (%eax),%eax
  802793:	eb 05                	jmp    80279a <alloc_block_BF+0x228>
  802795:	b8 00 00 00 00       	mov    $0x0,%eax
  80279a:	a3 40 41 80 00       	mov    %eax,0x804140
  80279f:	a1 40 41 80 00       	mov    0x804140,%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	0f 85 ff fe ff ff    	jne    8026ab <alloc_block_BF+0x139>
  8027ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b0:	0f 85 f5 fe ff ff    	jne    8026ab <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bb:	c9                   	leave  
  8027bc:	c3                   	ret    

008027bd <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027bd:	55                   	push   %ebp
  8027be:	89 e5                	mov    %esp,%ebp
  8027c0:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  8027c3:	a1 28 40 80 00       	mov    0x804028,%eax
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	75 14                	jne    8027e0 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  8027cc:	a1 38 41 80 00       	mov    0x804138,%eax
  8027d1:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  8027d6:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8027dd:	00 00 00 
	}
	uint32 c=1;
  8027e0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8027e7:	a1 60 41 80 00       	mov    0x804160,%eax
  8027ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8027ef:	e9 b3 01 00 00       	jmp    8029a7 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8027f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fa:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027fd:	0f 85 a9 00 00 00    	jne    8028ac <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 00                	mov    (%eax),%eax
  802808:	85 c0                	test   %eax,%eax
  80280a:	75 0c                	jne    802818 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80280c:	a1 38 41 80 00       	mov    0x804138,%eax
  802811:	a3 60 41 80 00       	mov    %eax,0x804160
  802816:	eb 0a                	jmp    802822 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	8b 00                	mov    (%eax),%eax
  80281d:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802822:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802826:	75 17                	jne    80283f <alloc_block_NF+0x82>
  802828:	83 ec 04             	sub    $0x4,%esp
  80282b:	68 af 3b 80 00       	push   $0x803baf
  802830:	68 e3 00 00 00       	push   $0xe3
  802835:	68 73 3b 80 00       	push   $0x803b73
  80283a:	e8 e7 da ff ff       	call   800326 <_panic>
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	74 10                	je     802858 <alloc_block_NF+0x9b>
  802848:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284b:	8b 00                	mov    (%eax),%eax
  80284d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802850:	8b 52 04             	mov    0x4(%edx),%edx
  802853:	89 50 04             	mov    %edx,0x4(%eax)
  802856:	eb 0b                	jmp    802863 <alloc_block_NF+0xa6>
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	8b 40 04             	mov    0x4(%eax),%eax
  80285e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802863:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802866:	8b 40 04             	mov    0x4(%eax),%eax
  802869:	85 c0                	test   %eax,%eax
  80286b:	74 0f                	je     80287c <alloc_block_NF+0xbf>
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802876:	8b 12                	mov    (%edx),%edx
  802878:	89 10                	mov    %edx,(%eax)
  80287a:	eb 0a                	jmp    802886 <alloc_block_NF+0xc9>
  80287c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287f:	8b 00                	mov    (%eax),%eax
  802881:	a3 38 41 80 00       	mov    %eax,0x804138
  802886:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802889:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802899:	a1 44 41 80 00       	mov    0x804144,%eax
  80289e:	48                   	dec    %eax
  80289f:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  8028a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a7:	e9 0e 01 00 00       	jmp    8029ba <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8028ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028af:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028b5:	0f 86 ce 00 00 00    	jbe    802989 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8028bb:	a1 48 41 80 00       	mov    0x804148,%eax
  8028c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8028c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c7:	75 17                	jne    8028e0 <alloc_block_NF+0x123>
  8028c9:	83 ec 04             	sub    $0x4,%esp
  8028cc:	68 af 3b 80 00       	push   $0x803baf
  8028d1:	68 e9 00 00 00       	push   $0xe9
  8028d6:	68 73 3b 80 00       	push   $0x803b73
  8028db:	e8 46 da ff ff       	call   800326 <_panic>
  8028e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	85 c0                	test   %eax,%eax
  8028e7:	74 10                	je     8028f9 <alloc_block_NF+0x13c>
  8028e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f1:	8b 52 04             	mov    0x4(%edx),%edx
  8028f4:	89 50 04             	mov    %edx,0x4(%eax)
  8028f7:	eb 0b                	jmp    802904 <alloc_block_NF+0x147>
  8028f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fc:	8b 40 04             	mov    0x4(%eax),%eax
  8028ff:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802904:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802907:	8b 40 04             	mov    0x4(%eax),%eax
  80290a:	85 c0                	test   %eax,%eax
  80290c:	74 0f                	je     80291d <alloc_block_NF+0x160>
  80290e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802911:	8b 40 04             	mov    0x4(%eax),%eax
  802914:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802917:	8b 12                	mov    (%edx),%edx
  802919:	89 10                	mov    %edx,(%eax)
  80291b:	eb 0a                	jmp    802927 <alloc_block_NF+0x16a>
  80291d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802920:	8b 00                	mov    (%eax),%eax
  802922:	a3 48 41 80 00       	mov    %eax,0x804148
  802927:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802930:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802933:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80293a:	a1 54 41 80 00       	mov    0x804154,%eax
  80293f:	48                   	dec    %eax
  802940:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802945:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802948:	8b 55 08             	mov    0x8(%ebp),%edx
  80294b:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  80294e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802951:	8b 50 08             	mov    0x8(%eax),%edx
  802954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802957:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  80295a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295d:	8b 50 08             	mov    0x8(%eax),%edx
  802960:	8b 45 08             	mov    0x8(%ebp),%eax
  802963:	01 c2                	add    %eax,%edx
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296e:	8b 40 0c             	mov    0xc(%eax),%eax
  802971:	2b 45 08             	sub    0x8(%ebp),%eax
  802974:	89 c2                	mov    %eax,%edx
  802976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802979:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80297c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297f:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802984:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802987:	eb 31                	jmp    8029ba <alloc_block_NF+0x1fd>
			 }
		 c++;
  802989:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80298c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298f:	8b 00                	mov    (%eax),%eax
  802991:	85 c0                	test   %eax,%eax
  802993:	75 0a                	jne    80299f <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802995:	a1 38 41 80 00       	mov    0x804138,%eax
  80299a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80299d:	eb 08                	jmp    8029a7 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80299f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a2:	8b 00                	mov    (%eax),%eax
  8029a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8029a7:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8029af:	0f 85 3f fe ff ff    	jne    8027f4 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8029b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ba:	c9                   	leave  
  8029bb:	c3                   	ret    

008029bc <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029bc:	55                   	push   %ebp
  8029bd:	89 e5                	mov    %esp,%ebp
  8029bf:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  8029c2:	a1 44 41 80 00       	mov    0x804144,%eax
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	75 68                	jne    802a33 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029cf:	75 17                	jne    8029e8 <insert_sorted_with_merge_freeList+0x2c>
  8029d1:	83 ec 04             	sub    $0x4,%esp
  8029d4:	68 50 3b 80 00       	push   $0x803b50
  8029d9:	68 0e 01 00 00       	push   $0x10e
  8029de:	68 73 3b 80 00       	push   $0x803b73
  8029e3:	e8 3e d9 ff ff       	call   800326 <_panic>
  8029e8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	89 10                	mov    %edx,(%eax)
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	85 c0                	test   %eax,%eax
  8029fa:	74 0d                	je     802a09 <insert_sorted_with_merge_freeList+0x4d>
  8029fc:	a1 38 41 80 00       	mov    0x804138,%eax
  802a01:	8b 55 08             	mov    0x8(%ebp),%edx
  802a04:	89 50 04             	mov    %edx,0x4(%eax)
  802a07:	eb 08                	jmp    802a11 <insert_sorted_with_merge_freeList+0x55>
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a11:	8b 45 08             	mov    0x8(%ebp),%eax
  802a14:	a3 38 41 80 00       	mov    %eax,0x804138
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a23:	a1 44 41 80 00       	mov    0x804144,%eax
  802a28:	40                   	inc    %eax
  802a29:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a2e:	e9 8c 06 00 00       	jmp    8030bf <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802a33:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802a3b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a40:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	8b 50 08             	mov    0x8(%eax),%edx
  802a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4c:	8b 40 08             	mov    0x8(%eax),%eax
  802a4f:	39 c2                	cmp    %eax,%edx
  802a51:	0f 86 14 01 00 00    	jbe    802b6b <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802a57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a60:	8b 40 08             	mov    0x8(%eax),%eax
  802a63:	01 c2                	add    %eax,%edx
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	8b 40 08             	mov    0x8(%eax),%eax
  802a6b:	39 c2                	cmp    %eax,%edx
  802a6d:	0f 85 90 00 00 00    	jne    802b03 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802a73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a76:	8b 50 0c             	mov    0xc(%eax),%edx
  802a79:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a7f:	01 c2                	add    %eax,%edx
  802a81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a84:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9f:	75 17                	jne    802ab8 <insert_sorted_with_merge_freeList+0xfc>
  802aa1:	83 ec 04             	sub    $0x4,%esp
  802aa4:	68 50 3b 80 00       	push   $0x803b50
  802aa9:	68 1b 01 00 00       	push   $0x11b
  802aae:	68 73 3b 80 00       	push   $0x803b73
  802ab3:	e8 6e d8 ff ff       	call   800326 <_panic>
  802ab8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	89 10                	mov    %edx,(%eax)
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	8b 00                	mov    (%eax),%eax
  802ac8:	85 c0                	test   %eax,%eax
  802aca:	74 0d                	je     802ad9 <insert_sorted_with_merge_freeList+0x11d>
  802acc:	a1 48 41 80 00       	mov    0x804148,%eax
  802ad1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad4:	89 50 04             	mov    %edx,0x4(%eax)
  802ad7:	eb 08                	jmp    802ae1 <insert_sorted_with_merge_freeList+0x125>
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802af3:	a1 54 41 80 00       	mov    0x804154,%eax
  802af8:	40                   	inc    %eax
  802af9:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802afe:	e9 bc 05 00 00       	jmp    8030bf <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b07:	75 17                	jne    802b20 <insert_sorted_with_merge_freeList+0x164>
  802b09:	83 ec 04             	sub    $0x4,%esp
  802b0c:	68 8c 3b 80 00       	push   $0x803b8c
  802b11:	68 1f 01 00 00       	push   $0x11f
  802b16:	68 73 3b 80 00       	push   $0x803b73
  802b1b:	e8 06 d8 ff ff       	call   800326 <_panic>
  802b20:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b26:	8b 45 08             	mov    0x8(%ebp),%eax
  802b29:	89 50 04             	mov    %edx,0x4(%eax)
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	8b 40 04             	mov    0x4(%eax),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	74 0c                	je     802b42 <insert_sorted_with_merge_freeList+0x186>
  802b36:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3e:	89 10                	mov    %edx,(%eax)
  802b40:	eb 08                	jmp    802b4a <insert_sorted_with_merge_freeList+0x18e>
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	a3 38 41 80 00       	mov    %eax,0x804138
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b5b:	a1 44 41 80 00       	mov    0x804144,%eax
  802b60:	40                   	inc    %eax
  802b61:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802b66:	e9 54 05 00 00       	jmp    8030bf <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	8b 50 08             	mov    0x8(%eax),%edx
  802b71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b74:	8b 40 08             	mov    0x8(%eax),%eax
  802b77:	39 c2                	cmp    %eax,%edx
  802b79:	0f 83 20 01 00 00    	jae    802c9f <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	8b 50 0c             	mov    0xc(%eax),%edx
  802b85:	8b 45 08             	mov    0x8(%ebp),%eax
  802b88:	8b 40 08             	mov    0x8(%eax),%eax
  802b8b:	01 c2                	add    %eax,%edx
  802b8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b90:	8b 40 08             	mov    0x8(%eax),%eax
  802b93:	39 c2                	cmp    %eax,%edx
  802b95:	0f 85 9c 00 00 00    	jne    802c37 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ba1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba4:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802baa:	8b 50 0c             	mov    0xc(%eax),%edx
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb3:	01 c2                	add    %eax,%edx
  802bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb8:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802bcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd3:	75 17                	jne    802bec <insert_sorted_with_merge_freeList+0x230>
  802bd5:	83 ec 04             	sub    $0x4,%esp
  802bd8:	68 50 3b 80 00       	push   $0x803b50
  802bdd:	68 2a 01 00 00       	push   $0x12a
  802be2:	68 73 3b 80 00       	push   $0x803b73
  802be7:	e8 3a d7 ff ff       	call   800326 <_panic>
  802bec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	89 10                	mov    %edx,(%eax)
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 0d                	je     802c0d <insert_sorted_with_merge_freeList+0x251>
  802c00:	a1 48 41 80 00       	mov    0x804148,%eax
  802c05:	8b 55 08             	mov    0x8(%ebp),%edx
  802c08:	89 50 04             	mov    %edx,0x4(%eax)
  802c0b:	eb 08                	jmp    802c15 <insert_sorted_with_merge_freeList+0x259>
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	a3 48 41 80 00       	mov    %eax,0x804148
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c27:	a1 54 41 80 00       	mov    0x804154,%eax
  802c2c:	40                   	inc    %eax
  802c2d:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c32:	e9 88 04 00 00       	jmp    8030bf <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c37:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3b:	75 17                	jne    802c54 <insert_sorted_with_merge_freeList+0x298>
  802c3d:	83 ec 04             	sub    $0x4,%esp
  802c40:	68 50 3b 80 00       	push   $0x803b50
  802c45:	68 2e 01 00 00       	push   $0x12e
  802c4a:	68 73 3b 80 00       	push   $0x803b73
  802c4f:	e8 d2 d6 ff ff       	call   800326 <_panic>
  802c54:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	89 10                	mov    %edx,(%eax)
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	8b 00                	mov    (%eax),%eax
  802c64:	85 c0                	test   %eax,%eax
  802c66:	74 0d                	je     802c75 <insert_sorted_with_merge_freeList+0x2b9>
  802c68:	a1 38 41 80 00       	mov    0x804138,%eax
  802c6d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c70:	89 50 04             	mov    %edx,0x4(%eax)
  802c73:	eb 08                	jmp    802c7d <insert_sorted_with_merge_freeList+0x2c1>
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c80:	a3 38 41 80 00       	mov    %eax,0x804138
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c8f:	a1 44 41 80 00       	mov    0x804144,%eax
  802c94:	40                   	inc    %eax
  802c95:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c9a:	e9 20 04 00 00       	jmp    8030bf <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802c9f:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca7:	e9 e2 03 00 00       	jmp    80308e <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	8b 50 08             	mov    0x8(%eax),%edx
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 40 08             	mov    0x8(%eax),%eax
  802cb8:	39 c2                	cmp    %eax,%edx
  802cba:	0f 83 c6 03 00 00    	jae    803086 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	8b 40 04             	mov    0x4(%eax),%eax
  802cc6:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802cc9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ccc:	8b 50 08             	mov    0x8(%eax),%edx
  802ccf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd5:	01 d0                	add    %edx,%eax
  802cd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce3:	8b 40 08             	mov    0x8(%eax),%eax
  802ce6:	01 d0                	add    %edx,%eax
  802ce8:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cee:	8b 40 08             	mov    0x8(%eax),%eax
  802cf1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cf4:	74 7a                	je     802d70 <insert_sorted_with_merge_freeList+0x3b4>
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 08             	mov    0x8(%eax),%eax
  802cfc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cff:	74 6f                	je     802d70 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802d01:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d05:	74 06                	je     802d0d <insert_sorted_with_merge_freeList+0x351>
  802d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0b:	75 17                	jne    802d24 <insert_sorted_with_merge_freeList+0x368>
  802d0d:	83 ec 04             	sub    $0x4,%esp
  802d10:	68 d0 3b 80 00       	push   $0x803bd0
  802d15:	68 43 01 00 00       	push   $0x143
  802d1a:	68 73 3b 80 00       	push   $0x803b73
  802d1f:	e8 02 d6 ff ff       	call   800326 <_panic>
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	8b 50 04             	mov    0x4(%eax),%edx
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	89 50 04             	mov    %edx,0x4(%eax)
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d36:	89 10                	mov    %edx,(%eax)
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 40 04             	mov    0x4(%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0d                	je     802d4f <insert_sorted_with_merge_freeList+0x393>
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 04             	mov    0x4(%eax),%eax
  802d48:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4b:	89 10                	mov    %edx,(%eax)
  802d4d:	eb 08                	jmp    802d57 <insert_sorted_with_merge_freeList+0x39b>
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	a3 38 41 80 00       	mov    %eax,0x804138
  802d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5d:	89 50 04             	mov    %edx,0x4(%eax)
  802d60:	a1 44 41 80 00       	mov    0x804144,%eax
  802d65:	40                   	inc    %eax
  802d66:	a3 44 41 80 00       	mov    %eax,0x804144
  802d6b:	e9 14 03 00 00       	jmp    803084 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	8b 40 08             	mov    0x8(%eax),%eax
  802d76:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d79:	0f 85 a0 01 00 00    	jne    802f1f <insert_sorted_with_merge_freeList+0x563>
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 40 08             	mov    0x8(%eax),%eax
  802d85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d88:	0f 85 91 01 00 00    	jne    802f1f <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802d8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d91:	8b 50 0c             	mov    0xc(%eax),%edx
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802da0:	01 c8                	add    %ecx,%eax
  802da2:	01 c2                	add    %eax,%edx
  802da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da7:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802db4:	8b 45 08             	mov    0x8(%ebp),%eax
  802db7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802dbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dd6:	75 17                	jne    802def <insert_sorted_with_merge_freeList+0x433>
  802dd8:	83 ec 04             	sub    $0x4,%esp
  802ddb:	68 50 3b 80 00       	push   $0x803b50
  802de0:	68 4d 01 00 00       	push   $0x14d
  802de5:	68 73 3b 80 00       	push   $0x803b73
  802dea:	e8 37 d5 ff ff       	call   800326 <_panic>
  802def:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802df5:	8b 45 08             	mov    0x8(%ebp),%eax
  802df8:	89 10                	mov    %edx,(%eax)
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	85 c0                	test   %eax,%eax
  802e01:	74 0d                	je     802e10 <insert_sorted_with_merge_freeList+0x454>
  802e03:	a1 48 41 80 00       	mov    0x804148,%eax
  802e08:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0b:	89 50 04             	mov    %edx,0x4(%eax)
  802e0e:	eb 08                	jmp    802e18 <insert_sorted_with_merge_freeList+0x45c>
  802e10:	8b 45 08             	mov    0x8(%ebp),%eax
  802e13:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e18:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1b:	a3 48 41 80 00       	mov    %eax,0x804148
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e2a:	a1 54 41 80 00       	mov    0x804154,%eax
  802e2f:	40                   	inc    %eax
  802e30:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802e35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e39:	75 17                	jne    802e52 <insert_sorted_with_merge_freeList+0x496>
  802e3b:	83 ec 04             	sub    $0x4,%esp
  802e3e:	68 af 3b 80 00       	push   $0x803baf
  802e43:	68 4e 01 00 00       	push   $0x14e
  802e48:	68 73 3b 80 00       	push   $0x803b73
  802e4d:	e8 d4 d4 ff ff       	call   800326 <_panic>
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	85 c0                	test   %eax,%eax
  802e59:	74 10                	je     802e6b <insert_sorted_with_merge_freeList+0x4af>
  802e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5e:	8b 00                	mov    (%eax),%eax
  802e60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e63:	8b 52 04             	mov    0x4(%edx),%edx
  802e66:	89 50 04             	mov    %edx,0x4(%eax)
  802e69:	eb 0b                	jmp    802e76 <insert_sorted_with_merge_freeList+0x4ba>
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 40 04             	mov    0x4(%eax),%eax
  802e71:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 40 04             	mov    0x4(%eax),%eax
  802e7c:	85 c0                	test   %eax,%eax
  802e7e:	74 0f                	je     802e8f <insert_sorted_with_merge_freeList+0x4d3>
  802e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e83:	8b 40 04             	mov    0x4(%eax),%eax
  802e86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e89:	8b 12                	mov    (%edx),%edx
  802e8b:	89 10                	mov    %edx,(%eax)
  802e8d:	eb 0a                	jmp    802e99 <insert_sorted_with_merge_freeList+0x4dd>
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 00                	mov    (%eax),%eax
  802e94:	a3 38 41 80 00       	mov    %eax,0x804138
  802e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eac:	a1 44 41 80 00       	mov    0x804144,%eax
  802eb1:	48                   	dec    %eax
  802eb2:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ebb:	75 17                	jne    802ed4 <insert_sorted_with_merge_freeList+0x518>
  802ebd:	83 ec 04             	sub    $0x4,%esp
  802ec0:	68 50 3b 80 00       	push   $0x803b50
  802ec5:	68 4f 01 00 00       	push   $0x14f
  802eca:	68 73 3b 80 00       	push   $0x803b73
  802ecf:	e8 52 d4 ff ff       	call   800326 <_panic>
  802ed4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edd:	89 10                	mov    %edx,(%eax)
  802edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee2:	8b 00                	mov    (%eax),%eax
  802ee4:	85 c0                	test   %eax,%eax
  802ee6:	74 0d                	je     802ef5 <insert_sorted_with_merge_freeList+0x539>
  802ee8:	a1 48 41 80 00       	mov    0x804148,%eax
  802eed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef0:	89 50 04             	mov    %edx,0x4(%eax)
  802ef3:	eb 08                	jmp    802efd <insert_sorted_with_merge_freeList+0x541>
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f00:	a3 48 41 80 00       	mov    %eax,0x804148
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0f:	a1 54 41 80 00       	mov    0x804154,%eax
  802f14:	40                   	inc    %eax
  802f15:	a3 54 41 80 00       	mov    %eax,0x804154
  802f1a:	e9 65 01 00 00       	jmp    803084 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	8b 40 08             	mov    0x8(%eax),%eax
  802f25:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f28:	0f 85 9f 00 00 00    	jne    802fcd <insert_sorted_with_merge_freeList+0x611>
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	8b 40 08             	mov    0x8(%eax),%eax
  802f34:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f37:	0f 84 90 00 00 00    	je     802fcd <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802f3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f40:	8b 50 0c             	mov    0xc(%eax),%edx
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	8b 40 0c             	mov    0xc(%eax),%eax
  802f49:	01 c2                	add    %eax,%edx
  802f4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4e:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f69:	75 17                	jne    802f82 <insert_sorted_with_merge_freeList+0x5c6>
  802f6b:	83 ec 04             	sub    $0x4,%esp
  802f6e:	68 50 3b 80 00       	push   $0x803b50
  802f73:	68 58 01 00 00       	push   $0x158
  802f78:	68 73 3b 80 00       	push   $0x803b73
  802f7d:	e8 a4 d3 ff ff       	call   800326 <_panic>
  802f82:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f88:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8b:	89 10                	mov    %edx,(%eax)
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	85 c0                	test   %eax,%eax
  802f94:	74 0d                	je     802fa3 <insert_sorted_with_merge_freeList+0x5e7>
  802f96:	a1 48 41 80 00       	mov    0x804148,%eax
  802f9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f9e:	89 50 04             	mov    %edx,0x4(%eax)
  802fa1:	eb 08                	jmp    802fab <insert_sorted_with_merge_freeList+0x5ef>
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fab:	8b 45 08             	mov    0x8(%ebp),%eax
  802fae:	a3 48 41 80 00       	mov    %eax,0x804148
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fbd:	a1 54 41 80 00       	mov    0x804154,%eax
  802fc2:	40                   	inc    %eax
  802fc3:	a3 54 41 80 00       	mov    %eax,0x804154
  802fc8:	e9 b7 00 00 00       	jmp    803084 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd0:	8b 40 08             	mov    0x8(%eax),%eax
  802fd3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802fd6:	0f 84 e2 00 00 00    	je     8030be <insert_sorted_with_merge_freeList+0x702>
  802fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fdf:	8b 40 08             	mov    0x8(%eax),%eax
  802fe2:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802fe5:	0f 85 d3 00 00 00    	jne    8030be <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	8b 50 08             	mov    0x8(%eax),%edx
  802ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff4:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffa:	8b 50 0c             	mov    0xc(%eax),%edx
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	8b 40 0c             	mov    0xc(%eax),%eax
  803003:	01 c2                	add    %eax,%edx
  803005:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803008:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80300b:	8b 45 08             	mov    0x8(%ebp),%eax
  80300e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80301f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803023:	75 17                	jne    80303c <insert_sorted_with_merge_freeList+0x680>
  803025:	83 ec 04             	sub    $0x4,%esp
  803028:	68 50 3b 80 00       	push   $0x803b50
  80302d:	68 61 01 00 00       	push   $0x161
  803032:	68 73 3b 80 00       	push   $0x803b73
  803037:	e8 ea d2 ff ff       	call   800326 <_panic>
  80303c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803042:	8b 45 08             	mov    0x8(%ebp),%eax
  803045:	89 10                	mov    %edx,(%eax)
  803047:	8b 45 08             	mov    0x8(%ebp),%eax
  80304a:	8b 00                	mov    (%eax),%eax
  80304c:	85 c0                	test   %eax,%eax
  80304e:	74 0d                	je     80305d <insert_sorted_with_merge_freeList+0x6a1>
  803050:	a1 48 41 80 00       	mov    0x804148,%eax
  803055:	8b 55 08             	mov    0x8(%ebp),%edx
  803058:	89 50 04             	mov    %edx,0x4(%eax)
  80305b:	eb 08                	jmp    803065 <insert_sorted_with_merge_freeList+0x6a9>
  80305d:	8b 45 08             	mov    0x8(%ebp),%eax
  803060:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803065:	8b 45 08             	mov    0x8(%ebp),%eax
  803068:	a3 48 41 80 00       	mov    %eax,0x804148
  80306d:	8b 45 08             	mov    0x8(%ebp),%eax
  803070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803077:	a1 54 41 80 00       	mov    0x804154,%eax
  80307c:	40                   	inc    %eax
  80307d:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803082:	eb 3a                	jmp    8030be <insert_sorted_with_merge_freeList+0x702>
  803084:	eb 38                	jmp    8030be <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803086:	a1 40 41 80 00       	mov    0x804140,%eax
  80308b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80308e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803092:	74 07                	je     80309b <insert_sorted_with_merge_freeList+0x6df>
  803094:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803097:	8b 00                	mov    (%eax),%eax
  803099:	eb 05                	jmp    8030a0 <insert_sorted_with_merge_freeList+0x6e4>
  80309b:	b8 00 00 00 00       	mov    $0x0,%eax
  8030a0:	a3 40 41 80 00       	mov    %eax,0x804140
  8030a5:	a1 40 41 80 00       	mov    0x804140,%eax
  8030aa:	85 c0                	test   %eax,%eax
  8030ac:	0f 85 fa fb ff ff    	jne    802cac <insert_sorted_with_merge_freeList+0x2f0>
  8030b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030b6:	0f 85 f0 fb ff ff    	jne    802cac <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8030bc:	eb 01                	jmp    8030bf <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8030be:	90                   	nop
							}

						}
		          }
		}
}
  8030bf:	90                   	nop
  8030c0:	c9                   	leave  
  8030c1:	c3                   	ret    

008030c2 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8030c2:	55                   	push   %ebp
  8030c3:	89 e5                	mov    %esp,%ebp
  8030c5:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8030c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030cb:	89 d0                	mov    %edx,%eax
  8030cd:	c1 e0 02             	shl    $0x2,%eax
  8030d0:	01 d0                	add    %edx,%eax
  8030d2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030d9:	01 d0                	add    %edx,%eax
  8030db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030e2:	01 d0                	add    %edx,%eax
  8030e4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030eb:	01 d0                	add    %edx,%eax
  8030ed:	c1 e0 04             	shl    $0x4,%eax
  8030f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030fa:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030fd:	83 ec 0c             	sub    $0xc,%esp
  803100:	50                   	push   %eax
  803101:	e8 9c eb ff ff       	call   801ca2 <sys_get_virtual_time>
  803106:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803109:	eb 41                	jmp    80314c <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80310b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80310e:	83 ec 0c             	sub    $0xc,%esp
  803111:	50                   	push   %eax
  803112:	e8 8b eb ff ff       	call   801ca2 <sys_get_virtual_time>
  803117:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80311a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80311d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803120:	29 c2                	sub    %eax,%edx
  803122:	89 d0                	mov    %edx,%eax
  803124:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803127:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80312a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80312d:	89 d1                	mov    %edx,%ecx
  80312f:	29 c1                	sub    %eax,%ecx
  803131:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803134:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803137:	39 c2                	cmp    %eax,%edx
  803139:	0f 97 c0             	seta   %al
  80313c:	0f b6 c0             	movzbl %al,%eax
  80313f:	29 c1                	sub    %eax,%ecx
  803141:	89 c8                	mov    %ecx,%eax
  803143:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803146:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803149:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803152:	72 b7                	jb     80310b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803154:	90                   	nop
  803155:	c9                   	leave  
  803156:	c3                   	ret    

00803157 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803157:	55                   	push   %ebp
  803158:	89 e5                	mov    %esp,%ebp
  80315a:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80315d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803164:	eb 03                	jmp    803169 <busy_wait+0x12>
  803166:	ff 45 fc             	incl   -0x4(%ebp)
  803169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80316c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80316f:	72 f5                	jb     803166 <busy_wait+0xf>
	return i;
  803171:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803174:	c9                   	leave  
  803175:	c3                   	ret    
  803176:	66 90                	xchg   %ax,%ax

00803178 <__udivdi3>:
  803178:	55                   	push   %ebp
  803179:	57                   	push   %edi
  80317a:	56                   	push   %esi
  80317b:	53                   	push   %ebx
  80317c:	83 ec 1c             	sub    $0x1c,%esp
  80317f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803183:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803187:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80318b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80318f:	89 ca                	mov    %ecx,%edx
  803191:	89 f8                	mov    %edi,%eax
  803193:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803197:	85 f6                	test   %esi,%esi
  803199:	75 2d                	jne    8031c8 <__udivdi3+0x50>
  80319b:	39 cf                	cmp    %ecx,%edi
  80319d:	77 65                	ja     803204 <__udivdi3+0x8c>
  80319f:	89 fd                	mov    %edi,%ebp
  8031a1:	85 ff                	test   %edi,%edi
  8031a3:	75 0b                	jne    8031b0 <__udivdi3+0x38>
  8031a5:	b8 01 00 00 00       	mov    $0x1,%eax
  8031aa:	31 d2                	xor    %edx,%edx
  8031ac:	f7 f7                	div    %edi
  8031ae:	89 c5                	mov    %eax,%ebp
  8031b0:	31 d2                	xor    %edx,%edx
  8031b2:	89 c8                	mov    %ecx,%eax
  8031b4:	f7 f5                	div    %ebp
  8031b6:	89 c1                	mov    %eax,%ecx
  8031b8:	89 d8                	mov    %ebx,%eax
  8031ba:	f7 f5                	div    %ebp
  8031bc:	89 cf                	mov    %ecx,%edi
  8031be:	89 fa                	mov    %edi,%edx
  8031c0:	83 c4 1c             	add    $0x1c,%esp
  8031c3:	5b                   	pop    %ebx
  8031c4:	5e                   	pop    %esi
  8031c5:	5f                   	pop    %edi
  8031c6:	5d                   	pop    %ebp
  8031c7:	c3                   	ret    
  8031c8:	39 ce                	cmp    %ecx,%esi
  8031ca:	77 28                	ja     8031f4 <__udivdi3+0x7c>
  8031cc:	0f bd fe             	bsr    %esi,%edi
  8031cf:	83 f7 1f             	xor    $0x1f,%edi
  8031d2:	75 40                	jne    803214 <__udivdi3+0x9c>
  8031d4:	39 ce                	cmp    %ecx,%esi
  8031d6:	72 0a                	jb     8031e2 <__udivdi3+0x6a>
  8031d8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031dc:	0f 87 9e 00 00 00    	ja     803280 <__udivdi3+0x108>
  8031e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8031e7:	89 fa                	mov    %edi,%edx
  8031e9:	83 c4 1c             	add    $0x1c,%esp
  8031ec:	5b                   	pop    %ebx
  8031ed:	5e                   	pop    %esi
  8031ee:	5f                   	pop    %edi
  8031ef:	5d                   	pop    %ebp
  8031f0:	c3                   	ret    
  8031f1:	8d 76 00             	lea    0x0(%esi),%esi
  8031f4:	31 ff                	xor    %edi,%edi
  8031f6:	31 c0                	xor    %eax,%eax
  8031f8:	89 fa                	mov    %edi,%edx
  8031fa:	83 c4 1c             	add    $0x1c,%esp
  8031fd:	5b                   	pop    %ebx
  8031fe:	5e                   	pop    %esi
  8031ff:	5f                   	pop    %edi
  803200:	5d                   	pop    %ebp
  803201:	c3                   	ret    
  803202:	66 90                	xchg   %ax,%ax
  803204:	89 d8                	mov    %ebx,%eax
  803206:	f7 f7                	div    %edi
  803208:	31 ff                	xor    %edi,%edi
  80320a:	89 fa                	mov    %edi,%edx
  80320c:	83 c4 1c             	add    $0x1c,%esp
  80320f:	5b                   	pop    %ebx
  803210:	5e                   	pop    %esi
  803211:	5f                   	pop    %edi
  803212:	5d                   	pop    %ebp
  803213:	c3                   	ret    
  803214:	bd 20 00 00 00       	mov    $0x20,%ebp
  803219:	89 eb                	mov    %ebp,%ebx
  80321b:	29 fb                	sub    %edi,%ebx
  80321d:	89 f9                	mov    %edi,%ecx
  80321f:	d3 e6                	shl    %cl,%esi
  803221:	89 c5                	mov    %eax,%ebp
  803223:	88 d9                	mov    %bl,%cl
  803225:	d3 ed                	shr    %cl,%ebp
  803227:	89 e9                	mov    %ebp,%ecx
  803229:	09 f1                	or     %esi,%ecx
  80322b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80322f:	89 f9                	mov    %edi,%ecx
  803231:	d3 e0                	shl    %cl,%eax
  803233:	89 c5                	mov    %eax,%ebp
  803235:	89 d6                	mov    %edx,%esi
  803237:	88 d9                	mov    %bl,%cl
  803239:	d3 ee                	shr    %cl,%esi
  80323b:	89 f9                	mov    %edi,%ecx
  80323d:	d3 e2                	shl    %cl,%edx
  80323f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803243:	88 d9                	mov    %bl,%cl
  803245:	d3 e8                	shr    %cl,%eax
  803247:	09 c2                	or     %eax,%edx
  803249:	89 d0                	mov    %edx,%eax
  80324b:	89 f2                	mov    %esi,%edx
  80324d:	f7 74 24 0c          	divl   0xc(%esp)
  803251:	89 d6                	mov    %edx,%esi
  803253:	89 c3                	mov    %eax,%ebx
  803255:	f7 e5                	mul    %ebp
  803257:	39 d6                	cmp    %edx,%esi
  803259:	72 19                	jb     803274 <__udivdi3+0xfc>
  80325b:	74 0b                	je     803268 <__udivdi3+0xf0>
  80325d:	89 d8                	mov    %ebx,%eax
  80325f:	31 ff                	xor    %edi,%edi
  803261:	e9 58 ff ff ff       	jmp    8031be <__udivdi3+0x46>
  803266:	66 90                	xchg   %ax,%ax
  803268:	8b 54 24 08          	mov    0x8(%esp),%edx
  80326c:	89 f9                	mov    %edi,%ecx
  80326e:	d3 e2                	shl    %cl,%edx
  803270:	39 c2                	cmp    %eax,%edx
  803272:	73 e9                	jae    80325d <__udivdi3+0xe5>
  803274:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803277:	31 ff                	xor    %edi,%edi
  803279:	e9 40 ff ff ff       	jmp    8031be <__udivdi3+0x46>
  80327e:	66 90                	xchg   %ax,%ax
  803280:	31 c0                	xor    %eax,%eax
  803282:	e9 37 ff ff ff       	jmp    8031be <__udivdi3+0x46>
  803287:	90                   	nop

00803288 <__umoddi3>:
  803288:	55                   	push   %ebp
  803289:	57                   	push   %edi
  80328a:	56                   	push   %esi
  80328b:	53                   	push   %ebx
  80328c:	83 ec 1c             	sub    $0x1c,%esp
  80328f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803293:	8b 74 24 34          	mov    0x34(%esp),%esi
  803297:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80329b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80329f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032a7:	89 f3                	mov    %esi,%ebx
  8032a9:	89 fa                	mov    %edi,%edx
  8032ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032af:	89 34 24             	mov    %esi,(%esp)
  8032b2:	85 c0                	test   %eax,%eax
  8032b4:	75 1a                	jne    8032d0 <__umoddi3+0x48>
  8032b6:	39 f7                	cmp    %esi,%edi
  8032b8:	0f 86 a2 00 00 00    	jbe    803360 <__umoddi3+0xd8>
  8032be:	89 c8                	mov    %ecx,%eax
  8032c0:	89 f2                	mov    %esi,%edx
  8032c2:	f7 f7                	div    %edi
  8032c4:	89 d0                	mov    %edx,%eax
  8032c6:	31 d2                	xor    %edx,%edx
  8032c8:	83 c4 1c             	add    $0x1c,%esp
  8032cb:	5b                   	pop    %ebx
  8032cc:	5e                   	pop    %esi
  8032cd:	5f                   	pop    %edi
  8032ce:	5d                   	pop    %ebp
  8032cf:	c3                   	ret    
  8032d0:	39 f0                	cmp    %esi,%eax
  8032d2:	0f 87 ac 00 00 00    	ja     803384 <__umoddi3+0xfc>
  8032d8:	0f bd e8             	bsr    %eax,%ebp
  8032db:	83 f5 1f             	xor    $0x1f,%ebp
  8032de:	0f 84 ac 00 00 00    	je     803390 <__umoddi3+0x108>
  8032e4:	bf 20 00 00 00       	mov    $0x20,%edi
  8032e9:	29 ef                	sub    %ebp,%edi
  8032eb:	89 fe                	mov    %edi,%esi
  8032ed:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032f1:	89 e9                	mov    %ebp,%ecx
  8032f3:	d3 e0                	shl    %cl,%eax
  8032f5:	89 d7                	mov    %edx,%edi
  8032f7:	89 f1                	mov    %esi,%ecx
  8032f9:	d3 ef                	shr    %cl,%edi
  8032fb:	09 c7                	or     %eax,%edi
  8032fd:	89 e9                	mov    %ebp,%ecx
  8032ff:	d3 e2                	shl    %cl,%edx
  803301:	89 14 24             	mov    %edx,(%esp)
  803304:	89 d8                	mov    %ebx,%eax
  803306:	d3 e0                	shl    %cl,%eax
  803308:	89 c2                	mov    %eax,%edx
  80330a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80330e:	d3 e0                	shl    %cl,%eax
  803310:	89 44 24 04          	mov    %eax,0x4(%esp)
  803314:	8b 44 24 08          	mov    0x8(%esp),%eax
  803318:	89 f1                	mov    %esi,%ecx
  80331a:	d3 e8                	shr    %cl,%eax
  80331c:	09 d0                	or     %edx,%eax
  80331e:	d3 eb                	shr    %cl,%ebx
  803320:	89 da                	mov    %ebx,%edx
  803322:	f7 f7                	div    %edi
  803324:	89 d3                	mov    %edx,%ebx
  803326:	f7 24 24             	mull   (%esp)
  803329:	89 c6                	mov    %eax,%esi
  80332b:	89 d1                	mov    %edx,%ecx
  80332d:	39 d3                	cmp    %edx,%ebx
  80332f:	0f 82 87 00 00 00    	jb     8033bc <__umoddi3+0x134>
  803335:	0f 84 91 00 00 00    	je     8033cc <__umoddi3+0x144>
  80333b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80333f:	29 f2                	sub    %esi,%edx
  803341:	19 cb                	sbb    %ecx,%ebx
  803343:	89 d8                	mov    %ebx,%eax
  803345:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803349:	d3 e0                	shl    %cl,%eax
  80334b:	89 e9                	mov    %ebp,%ecx
  80334d:	d3 ea                	shr    %cl,%edx
  80334f:	09 d0                	or     %edx,%eax
  803351:	89 e9                	mov    %ebp,%ecx
  803353:	d3 eb                	shr    %cl,%ebx
  803355:	89 da                	mov    %ebx,%edx
  803357:	83 c4 1c             	add    $0x1c,%esp
  80335a:	5b                   	pop    %ebx
  80335b:	5e                   	pop    %esi
  80335c:	5f                   	pop    %edi
  80335d:	5d                   	pop    %ebp
  80335e:	c3                   	ret    
  80335f:	90                   	nop
  803360:	89 fd                	mov    %edi,%ebp
  803362:	85 ff                	test   %edi,%edi
  803364:	75 0b                	jne    803371 <__umoddi3+0xe9>
  803366:	b8 01 00 00 00       	mov    $0x1,%eax
  80336b:	31 d2                	xor    %edx,%edx
  80336d:	f7 f7                	div    %edi
  80336f:	89 c5                	mov    %eax,%ebp
  803371:	89 f0                	mov    %esi,%eax
  803373:	31 d2                	xor    %edx,%edx
  803375:	f7 f5                	div    %ebp
  803377:	89 c8                	mov    %ecx,%eax
  803379:	f7 f5                	div    %ebp
  80337b:	89 d0                	mov    %edx,%eax
  80337d:	e9 44 ff ff ff       	jmp    8032c6 <__umoddi3+0x3e>
  803382:	66 90                	xchg   %ax,%ax
  803384:	89 c8                	mov    %ecx,%eax
  803386:	89 f2                	mov    %esi,%edx
  803388:	83 c4 1c             	add    $0x1c,%esp
  80338b:	5b                   	pop    %ebx
  80338c:	5e                   	pop    %esi
  80338d:	5f                   	pop    %edi
  80338e:	5d                   	pop    %ebp
  80338f:	c3                   	ret    
  803390:	3b 04 24             	cmp    (%esp),%eax
  803393:	72 06                	jb     80339b <__umoddi3+0x113>
  803395:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803399:	77 0f                	ja     8033aa <__umoddi3+0x122>
  80339b:	89 f2                	mov    %esi,%edx
  80339d:	29 f9                	sub    %edi,%ecx
  80339f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033a3:	89 14 24             	mov    %edx,(%esp)
  8033a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033aa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033ae:	8b 14 24             	mov    (%esp),%edx
  8033b1:	83 c4 1c             	add    $0x1c,%esp
  8033b4:	5b                   	pop    %ebx
  8033b5:	5e                   	pop    %esi
  8033b6:	5f                   	pop    %edi
  8033b7:	5d                   	pop    %ebp
  8033b8:	c3                   	ret    
  8033b9:	8d 76 00             	lea    0x0(%esi),%esi
  8033bc:	2b 04 24             	sub    (%esp),%eax
  8033bf:	19 fa                	sbb    %edi,%edx
  8033c1:	89 d1                	mov    %edx,%ecx
  8033c3:	89 c6                	mov    %eax,%esi
  8033c5:	e9 71 ff ff ff       	jmp    80333b <__umoddi3+0xb3>
  8033ca:	66 90                	xchg   %ax,%ax
  8033cc:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033d0:	72 ea                	jb     8033bc <__umoddi3+0x134>
  8033d2:	89 d9                	mov    %ebx,%ecx
  8033d4:	e9 62 ff ff ff       	jmp    80333b <__umoddi3+0xb3>

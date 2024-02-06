
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 5f 01 00 00       	call   800195 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing scenario 3: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 33 80 00       	push   $0x8033a0
  80004a:	e8 b9 15 00 00       	call   801608 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 be 18 00 00       	call   801921 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 56 19 00 00       	call   8019c1 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 33 80 00       	push   $0x8033b0
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 e3 33 80 00       	push   $0x8033e3
  800099:	e8 f5 1a 00 00       	call   801b93 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 ec 33 80 00       	push   $0x8033ec
  8000bc:	e8 d2 1a 00 00       	call   801b93 <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 df 1a 00 00       	call   801bb1 <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 8b 2f 00 00       	call   80306d <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 c1 1a 00 00       	call   801bb1 <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 1e 18 00 00       	call   801921 <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 f8 33 80 00       	push   $0x8033f8
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 ae 1a 00 00       	call   801bcd <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 a0 1a 00 00       	call   801bcd <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 ec 17 00 00       	call   801921 <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 84 18 00 00       	call   8019c1 <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 2c 34 80 00       	push   $0x80342c
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 7c 34 80 00       	push   $0x80347c
  800163:	6a 23                	push   $0x23
  800165:	68 b2 34 80 00       	push   $0x8034b2
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 c8 34 80 00       	push   $0x8034c8
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 28 35 80 00       	push   $0x803528
  80018a:	e8 f6 03 00 00       	call   800585 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
	return;
  800192:	90                   	nop
}
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80019b:	e8 61 1a 00 00       	call   801c01 <sys_getenvindex>
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a6:	89 d0                	mov    %edx,%eax
  8001a8:	c1 e0 03             	shl    $0x3,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	01 c0                	add    %eax,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	c1 e0 04             	shl    $0x4,%eax
  8001bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001d2:	84 c0                	test   %al,%al
  8001d4:	74 0f                	je     8001e5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001db:	05 5c 05 00 00       	add    $0x55c,%eax
  8001e0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x60>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800206:	e8 03 18 00 00       	call   801a0e <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 8c 35 80 00       	push   $0x80358c
  800213:	e8 6d 03 00 00       	call   800585 <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80021b:	a1 20 40 80 00       	mov    0x804020,%eax
  800220:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800226:	a1 20 40 80 00       	mov    0x804020,%eax
  80022b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800231:	83 ec 04             	sub    $0x4,%esp
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 b4 35 80 00       	push   $0x8035b4
  80023b:	e8 45 03 00 00       	call   800585 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800243:	a1 20 40 80 00       	mov    0x804020,%eax
  800248:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024e:	a1 20 40 80 00       	mov    0x804020,%eax
  800253:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800264:	51                   	push   %ecx
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 dc 35 80 00       	push   $0x8035dc
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 34 36 80 00       	push   $0x803634
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 8c 35 80 00       	push   $0x80358c
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 83 17 00 00       	call   801a28 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a5:	e8 19 00 00 00       	call   8002c3 <exit>
}
  8002aa:	90                   	nop
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	6a 00                	push   $0x0
  8002b8:	e8 10 19 00 00       	call   801bcd <sys_destroy_env>
  8002bd:	83 c4 10             	add    $0x10,%esp
}
  8002c0:	90                   	nop
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <exit>:

void
exit(void)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c9:	e8 65 19 00 00       	call   801c33 <sys_exit_env>
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002da:	83 c0 04             	add    $0x4,%eax
  8002dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002e0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	74 16                	je     8002ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 48 36 80 00       	push   $0x803648
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 40 80 00       	mov    0x804000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 4d 36 80 00       	push   $0x80364d
  800310:	e8 70 02 00 00       	call   800585 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800318:	8b 45 10             	mov    0x10(%ebp),%eax
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	ff 75 f4             	pushl  -0xc(%ebp)
  800321:	50                   	push   %eax
  800322:	e8 f3 01 00 00       	call   80051a <vcprintf>
  800327:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	6a 00                	push   $0x0
  80032f:	68 69 36 80 00       	push   $0x803669
  800334:	e8 e1 01 00 00       	call   80051a <vcprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80033c:	e8 82 ff ff ff       	call   8002c3 <exit>

	// should not return here
	while (1) ;
  800341:	eb fe                	jmp    800341 <_panic+0x70>

00800343 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 50 74             	mov    0x74(%eax),%edx
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
  800354:	39 c2                	cmp    %eax,%edx
  800356:	74 14                	je     80036c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 6c 36 80 00       	push   $0x80366c
  800360:	6a 26                	push   $0x26
  800362:	68 b8 36 80 00       	push   $0x8036b8
  800367:	e8 65 ff ff ff       	call   8002d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80036c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80037a:	e9 c2 00 00 00       	jmp    800441 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800382:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	85 c0                	test   %eax,%eax
  800392:	75 08                	jne    80039c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800394:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800397:	e9 a2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80039c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003aa:	eb 69                	jmp    800415 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ba:	89 d0                	mov    %edx,%eax
  8003bc:	01 c0                	add    %eax,%eax
  8003be:	01 d0                	add    %edx,%eax
  8003c0:	c1 e0 03             	shl    $0x3,%eax
  8003c3:	01 c8                	add    %ecx,%eax
  8003c5:	8a 40 04             	mov    0x4(%eax),%al
  8003c8:	84 c0                	test   %al,%al
  8003ca:	75 46                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	c1 e0 03             	shl    $0x3,%eax
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	01 c8                	add    %ecx,%eax
  800403:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800405:	39 c2                	cmp    %eax,%edx
  800407:	75 09                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800409:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800410:	eb 12                	jmp    800424 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800412:	ff 45 e8             	incl   -0x18(%ebp)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	77 88                	ja     8003ac <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800428:	75 14                	jne    80043e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	68 c4 36 80 00       	push   $0x8036c4
  800432:	6a 3a                	push   $0x3a
  800434:	68 b8 36 80 00       	push   $0x8036b8
  800439:	e8 93 fe ff ff       	call   8002d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043e:	ff 45 f0             	incl   -0x10(%ebp)
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800447:	0f 8c 32 ff ff ff    	jl     80037f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800454:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80045b:	eb 26                	jmp    800483 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045d:	a1 20 40 80 00       	mov    0x804020,%eax
  800462:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800468:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046b:	89 d0                	mov    %edx,%eax
  80046d:	01 c0                	add    %eax,%eax
  80046f:	01 d0                	add    %edx,%eax
  800471:	c1 e0 03             	shl    $0x3,%eax
  800474:	01 c8                	add    %ecx,%eax
  800476:	8a 40 04             	mov    0x4(%eax),%al
  800479:	3c 01                	cmp    $0x1,%al
  80047b:	75 03                	jne    800480 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	ff 45 e0             	incl   -0x20(%ebp)
  800483:	a1 20 40 80 00       	mov    0x804020,%eax
  800488:	8b 50 74             	mov    0x74(%eax),%edx
  80048b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	77 cb                	ja     80045d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800495:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800498:	74 14                	je     8004ae <CheckWSWithoutLastIndex+0x16b>
		panic(
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 18 37 80 00       	push   $0x803718
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 b8 36 80 00       	push   $0x8036b8
  8004a9:	e8 23 fe ff ff       	call   8002d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ae:	90                   	nop
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 2c                	jne    800508 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004dc:	a0 24 40 80 00       	mov    0x804024,%al
  8004e1:	0f b6 c0             	movzbl %al,%eax
  8004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e7:	8b 12                	mov    (%edx),%edx
  8004e9:	89 d1                	mov    %edx,%ecx
  8004eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ee:	83 c2 08             	add    $0x8,%edx
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	50                   	push   %eax
  8004f5:	51                   	push   %ecx
  8004f6:	52                   	push   %edx
  8004f7:	e8 64 13 00 00       	call   801860 <sys_cputs>
  8004fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	8b 40 04             	mov    0x4(%eax),%eax
  80050e:	8d 50 01             	lea    0x1(%eax),%edx
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	89 50 04             	mov    %edx,0x4(%eax)
}
  800517:	90                   	nop
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800523:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80052a:	00 00 00 
	b.cnt = 0;
  80052d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800534:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	50                   	push   %eax
  800544:	68 b1 04 80 00       	push   $0x8004b1
  800549:	e8 11 02 00 00       	call   80075f <vprintfmt>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800551:	a0 24 40 80 00       	mov    0x804024,%al
  800556:	0f b6 c0             	movzbl %al,%eax
  800559:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	50                   	push   %eax
  800563:	52                   	push   %edx
  800564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056a:	83 c0 08             	add    $0x8,%eax
  80056d:	50                   	push   %eax
  80056e:	e8 ed 12 00 00       	call   801860 <sys_cputs>
  800573:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800576:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <cprintf>:

int cprintf(const char *fmt, ...) {
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800592:	8d 45 0c             	lea    0xc(%ebp),%eax
  800595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	e8 73 ff ff ff       	call   80051a <vcprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b8:	e8 51 14 00 00       	call   801a0e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	e8 48 ff ff ff       	call   80051a <vcprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d8:	e8 4b 14 00 00       	call   801a28 <sys_enable_interrupt>
	return cnt;
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 14             	sub    $0x14,%esp
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800600:	77 55                	ja     800657 <printnum+0x75>
  800602:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800605:	72 05                	jb     80060c <printnum+0x2a>
  800607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80060a:	77 4b                	ja     800657 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800612:	8b 45 18             	mov    0x18(%ebp),%eax
  800615:	ba 00 00 00 00       	mov    $0x0,%edx
  80061a:	52                   	push   %edx
  80061b:	50                   	push   %eax
  80061c:	ff 75 f4             	pushl  -0xc(%ebp)
  80061f:	ff 75 f0             	pushl  -0x10(%ebp)
  800622:	e8 fd 2a 00 00       	call   803124 <__udivdi3>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	53                   	push   %ebx
  800631:	ff 75 18             	pushl  0x18(%ebp)
  800634:	52                   	push   %edx
  800635:	50                   	push   %eax
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 08             	pushl  0x8(%ebp)
  80063c:	e8 a1 ff ff ff       	call   8005e2 <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 1a                	jmp    800660 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	ff 75 20             	pushl  0x20(%ebp)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800657:	ff 4d 1c             	decl   0x1c(%ebp)
  80065a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065e:	7f e6                	jg     800646 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800660:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066e:	53                   	push   %ebx
  80066f:	51                   	push   %ecx
  800670:	52                   	push   %edx
  800671:	50                   	push   %eax
  800672:	e8 bd 2b 00 00       	call   803234 <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 94 39 80 00       	add    $0x803994,%eax
  80067f:	8a 00                	mov    (%eax),%al
  800681:	0f be c0             	movsbl %al,%eax
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	50                   	push   %eax
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	ff d0                	call   *%eax
  800690:	83 c4 10             	add    $0x10,%esp
}
  800693:	90                   	nop
  800694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a0:	7e 1c                	jle    8006be <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	8d 50 08             	lea    0x8(%eax),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 10                	mov    %edx,(%eax)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 e8 08             	sub    $0x8,%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	eb 40                	jmp    8006fe <getuint+0x65>
	else if (lflag)
  8006be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c2:	74 1e                	je     8006e2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 50 04             	lea    0x4(%eax),%edx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 10                	mov    %edx,(%eax)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	83 e8 04             	sub    $0x4,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e0:	eb 1c                	jmp    8006fe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800703:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800707:	7e 1c                	jle    800725 <getint+0x25>
		return va_arg(*ap, long long);
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8d 50 08             	lea    0x8(%eax),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 10                	mov    %edx,(%eax)
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 e8 08             	sub    $0x8,%eax
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	eb 38                	jmp    80075d <getint+0x5d>
	else if (lflag)
  800725:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800729:	74 1a                	je     800745 <getint+0x45>
		return va_arg(*ap, long);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 10                	mov    %edx,(%eax)
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	83 e8 04             	sub    $0x4,%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	99                   	cltd   
  800743:	eb 18                	jmp    80075d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	89 10                	mov    %edx,(%eax)
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	99                   	cltd   
}
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	56                   	push   %esi
  800763:	53                   	push   %ebx
  800764:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800767:	eb 17                	jmp    800780 <vprintfmt+0x21>
			if (ch == '\0')
  800769:	85 db                	test   %ebx,%ebx
  80076b:	0f 84 af 03 00 00    	je     800b20 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	8d 50 01             	lea    0x1(%eax),%edx
  800786:	89 55 10             	mov    %edx,0x10(%ebp)
  800789:	8a 00                	mov    (%eax),%al
  80078b:	0f b6 d8             	movzbl %al,%ebx
  80078e:	83 fb 25             	cmp    $0x25,%ebx
  800791:	75 d6                	jne    800769 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800793:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800797:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	8d 50 01             	lea    0x1(%eax),%edx
  8007b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bc:	8a 00                	mov    (%eax),%al
  8007be:	0f b6 d8             	movzbl %al,%ebx
  8007c1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c4:	83 f8 55             	cmp    $0x55,%eax
  8007c7:	0f 87 2b 03 00 00    	ja     800af8 <vprintfmt+0x399>
  8007cd:	8b 04 85 b8 39 80 00 	mov    0x8039b8(,%eax,4),%eax
  8007d4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007da:	eb d7                	jmp    8007b3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007dc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e0:	eb d1                	jmp    8007b3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	c1 e0 02             	shl    $0x2,%eax
  8007f1:	01 d0                	add    %edx,%eax
  8007f3:	01 c0                	add    %eax,%eax
  8007f5:	01 d8                	add    %ebx,%eax
  8007f7:	83 e8 30             	sub    $0x30,%eax
  8007fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800805:	83 fb 2f             	cmp    $0x2f,%ebx
  800808:	7e 3e                	jle    800848 <vprintfmt+0xe9>
  80080a:	83 fb 39             	cmp    $0x39,%ebx
  80080d:	7f 39                	jg     800848 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800812:	eb d5                	jmp    8007e9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 c0 04             	add    $0x4,%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 e8 04             	sub    $0x4,%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800828:	eb 1f                	jmp    800849 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	79 83                	jns    8007b3 <vprintfmt+0x54>
				width = 0;
  800830:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800837:	e9 77 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80083c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800843:	e9 6b ff ff ff       	jmp    8007b3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800848:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800849:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084d:	0f 89 60 ff ff ff    	jns    8007b3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800859:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800860:	e9 4e ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800865:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800868:	e9 46 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 c0 04             	add    $0x4,%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 e8 04             	sub    $0x4,%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	50                   	push   %eax
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 89 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	79 02                	jns    8008a9 <vprintfmt+0x14a>
				err = -err;
  8008a7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a9:	83 fb 64             	cmp    $0x64,%ebx
  8008ac:	7f 0b                	jg     8008b9 <vprintfmt+0x15a>
  8008ae:	8b 34 9d 00 38 80 00 	mov    0x803800(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 a5 39 80 00       	push   $0x8039a5
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 5e 02 00 00       	call   800b28 <printfmt>
  8008ca:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cd:	e9 49 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d2:	56                   	push   %esi
  8008d3:	68 ae 39 80 00       	push   $0x8039ae
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 45 02 00 00       	call   800b28 <printfmt>
  8008e3:	83 c4 10             	add    $0x10,%esp
			break;
  8008e6:	e9 30 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 c0 04             	add    $0x4,%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 30                	mov    (%eax),%esi
  8008fc:	85 f6                	test   %esi,%esi
  8008fe:	75 05                	jne    800905 <vprintfmt+0x1a6>
				p = "(null)";
  800900:	be b1 39 80 00       	mov    $0x8039b1,%esi
			if (width > 0 && padc != '-')
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	7e 6d                	jle    800978 <vprintfmt+0x219>
  80090b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090f:	74 67                	je     800978 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	50                   	push   %eax
  800918:	56                   	push   %esi
  800919:	e8 0c 03 00 00       	call   800c2a <strnlen>
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800924:	eb 16                	jmp    80093c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800926:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800939:	ff 4d e4             	decl   -0x1c(%ebp)
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800940:	7f e4                	jg     800926 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800942:	eb 34                	jmp    800978 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800944:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800948:	74 1c                	je     800966 <vprintfmt+0x207>
  80094a:	83 fb 1f             	cmp    $0x1f,%ebx
  80094d:	7e 05                	jle    800954 <vprintfmt+0x1f5>
  80094f:	83 fb 7e             	cmp    $0x7e,%ebx
  800952:	7e 12                	jle    800966 <vprintfmt+0x207>
					putch('?', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	6a 3f                	push   $0x3f
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	ff d0                	call   *%eax
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	eb 0f                	jmp    800975 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	ff d0                	call   *%eax
  800972:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800975:	ff 4d e4             	decl   -0x1c(%ebp)
  800978:	89 f0                	mov    %esi,%eax
  80097a:	8d 70 01             	lea    0x1(%eax),%esi
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f be d8             	movsbl %al,%ebx
  800982:	85 db                	test   %ebx,%ebx
  800984:	74 24                	je     8009aa <vprintfmt+0x24b>
  800986:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098a:	78 b8                	js     800944 <vprintfmt+0x1e5>
  80098c:	ff 4d e0             	decl   -0x20(%ebp)
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	79 af                	jns    800944 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800995:	eb 13                	jmp    8009aa <vprintfmt+0x24b>
				putch(' ', putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	6a 20                	push   $0x20
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ae:	7f e7                	jg     800997 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b0:	e9 66 01 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	e8 3c fd ff ff       	call   800700 <getint>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	79 23                	jns    8009fa <vprintfmt+0x29b>
				putch('-', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 2d                	push   $0x2d
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ed:	f7 d8                	neg    %eax
  8009ef:	83 d2 00             	adc    $0x0,%edx
  8009f2:	f7 da                	neg    %edx
  8009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a01:	e9 bc 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	e8 84 fc ff ff       	call   800699 <getuint>
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a25:	e9 98 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	6a 58                	push   $0x58
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	6a 58                	push   $0x58
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	6a 58                	push   $0x58
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
			break;
  800a5a:	e9 bc 00 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	6a 30                	push   $0x30
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	6a 78                	push   $0x78
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	ff d0                	call   *%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 e8 04             	sub    $0x4,%eax
  800a8e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 e7 fb ff ff       	call   800699 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800abb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	83 ec 04             	sub    $0x4,%esp
  800acc:	52                   	push   %edx
  800acd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad0:	50                   	push   %eax
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 00 fb ff ff       	call   8005e2 <printnum>
  800ae2:	83 c4 20             	add    $0x20,%esp
			break;
  800ae5:	eb 34                	jmp    800b1b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	eb 23                	jmp    800b1b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 25                	push   $0x25
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b08:	ff 4d 10             	decl   0x10(%ebp)
  800b0b:	eb 03                	jmp    800b10 <vprintfmt+0x3b1>
  800b0d:	ff 4d 10             	decl   0x10(%ebp)
  800b10:	8b 45 10             	mov    0x10(%ebp),%eax
  800b13:	48                   	dec    %eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	3c 25                	cmp    $0x25,%al
  800b18:	75 f3                	jne    800b0d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b1a:	90                   	nop
		}
	}
  800b1b:	e9 47 fc ff ff       	jmp    800767 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b20:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b31:	83 c0 04             	add    $0x4,%eax
  800b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 16 fc ff ff       	call   80075f <vprintfmt>
  800b49:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b4c:	90                   	nop
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 08             	mov    0x8(%eax),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8b 10                	mov    (%eax),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 40 04             	mov    0x4(%eax),%eax
  800b6c:	39 c2                	cmp    %eax,%edx
  800b6e:	73 12                	jae    800b82 <sprintputch+0x33>
		*b->buf++ = ch;
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	8d 48 01             	lea    0x1(%eax),%ecx
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	89 0a                	mov    %ecx,(%edx)
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	88 10                	mov    %dl,(%eax)
}
  800b82:	90                   	nop
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	01 d0                	add    %edx,%eax
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800baa:	74 06                	je     800bb2 <vsnprintf+0x2d>
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	7f 07                	jg     800bb9 <vsnprintf+0x34>
		return -E_INVAL;
  800bb2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb7:	eb 20                	jmp    800bd9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb9:	ff 75 14             	pushl  0x14(%ebp)
  800bbc:	ff 75 10             	pushl  0x10(%ebp)
  800bbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc2:	50                   	push   %eax
  800bc3:	68 4f 0b 80 00       	push   $0x800b4f
  800bc8:	e8 92 fb ff ff       	call   80075f <vprintfmt>
  800bcd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be1:	8d 45 10             	lea    0x10(%ebp),%eax
  800be4:	83 c0 04             	add    $0x4,%eax
  800be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 89 ff ff ff       	call   800b85 <vsnprintf>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c14:	eb 06                	jmp    800c1c <strlen+0x15>
		n++;
  800c16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c19:	ff 45 08             	incl   0x8(%ebp)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 f1                	jne    800c16 <strlen+0xf>
		n++;
	return n;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 09                	jmp    800c42 <strnlen+0x18>
		n++;
  800c39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	ff 4d 0c             	decl   0xc(%ebp)
  800c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c46:	74 09                	je     800c51 <strnlen+0x27>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 e8                	jne    800c39 <strnlen+0xf>
		n++;
	return n;
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c62:	90                   	nop
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 e4                	jne    800c63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c97:	eb 1f                	jmp    800cb8 <strncpy+0x34>
		*dst++ = *src;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	74 03                	je     800cb5 <strncpy+0x31>
			src++;
  800cb2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb5:	ff 45 fc             	incl   -0x4(%ebp)
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbe:	72 d9                	jb     800c99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	74 30                	je     800d07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd7:	eb 16                	jmp    800cef <strlcpy+0x2a>
			*dst++ = *src++;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8d 50 01             	lea    0x1(%eax),%edx
  800cdf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ceb:	8a 12                	mov    (%edx),%dl
  800ced:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cef:	ff 4d 10             	decl   0x10(%ebp)
  800cf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf6:	74 09                	je     800d01 <strlcpy+0x3c>
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 d8                	jne    800cd9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	29 c2                	sub    %eax,%edx
  800d0f:	89 d0                	mov    %edx,%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d16:	eb 06                	jmp    800d1e <strcmp+0xb>
		p++, q++;
  800d18:	ff 45 08             	incl   0x8(%ebp)
  800d1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strcmp+0x22>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 e3                	je     800d18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d0             	movzbl %al,%edx
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 c0             	movzbl %al,%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
}
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4e:	eb 09                	jmp    800d59 <strncmp+0xe>
		n--, p++, q++;
  800d50:	ff 4d 10             	decl   0x10(%ebp)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 17                	je     800d76 <strncmp+0x2b>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	74 0e                	je     800d76 <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	38 c2                	cmp    %al,%dl
  800d74:	74 da                	je     800d50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	75 07                	jne    800d83 <strncmp+0x38>
		return 0;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	eb 14                	jmp    800d97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	0f b6 d0             	movzbl %al,%edx
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	0f b6 c0             	movzbl %al,%eax
  800d93:	29 c2                	sub    %eax,%edx
  800d95:	89 d0                	mov    %edx,%eax
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 12                	jmp    800db9 <strchr+0x20>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	75 05                	jne    800db6 <strchr+0x1d>
			return (char *) s;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	eb 11                	jmp    800dc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 e5                	jne    800da7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd5:	eb 0d                	jmp    800de4 <strfind+0x1b>
		if (*s == c)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddf:	74 0e                	je     800def <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 ea                	jne    800dd7 <strfind+0xe>
  800ded:	eb 01                	jmp    800df0 <strfind+0x27>
		if (*s == c)
			break;
  800def:	90                   	nop
	return (char *) s;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e07:	eb 0e                	jmp    800e17 <memset+0x22>
		*p++ = c;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e15:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e17:	ff 4d f8             	decl   -0x8(%ebp)
  800e1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1e:	79 e9                	jns    800e09 <memset+0x14>
		*p++ = c;

	return v;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e37:	eb 16                	jmp    800e4f <memcpy+0x2a>
		*d++ = *s++;
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	75 dd                	jne    800e39 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e79:	73 50                	jae    800ecb <memmove+0x6a>
  800e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e86:	76 43                	jbe    800ecb <memmove+0x6a>
		s += n;
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e91:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e94:	eb 10                	jmp    800ea6 <memmove+0x45>
			*--d = *--s;
  800e96:	ff 4d f8             	decl   -0x8(%ebp)
  800e99:	ff 4d fc             	decl   -0x4(%ebp)
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9f:	8a 10                	mov    (%eax),%dl
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eac:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	75 e3                	jne    800e96 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb3:	eb 23                	jmp    800ed8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8d 50 01             	lea    0x1(%eax),%edx
  800ebb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 dd                	jne    800eb5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eef:	eb 2a                	jmp    800f1b <memcmp+0x3e>
		if (*s1 != *s2)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	38 c2                	cmp    %al,%dl
  800efd:	74 16                	je     800f15 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d0             	movzbl %al,%edx
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
  800f13:	eb 18                	jmp    800f2d <memcmp+0x50>
		s1++, s2++;
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
  800f18:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 c9                	jne    800ef1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    

00800f2f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f40:	eb 15                	jmp    800f57 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 d0             	movzbl %al,%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	0f b6 c0             	movzbl %al,%eax
  800f50:	39 c2                	cmp    %eax,%edx
  800f52:	74 0d                	je     800f61 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5d:	72 e3                	jb     800f42 <memfind+0x13>
  800f5f:	eb 01                	jmp    800f62 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f61:	90                   	nop
	return (void *) s;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7b:	eb 03                	jmp    800f80 <strtol+0x19>
		s++;
  800f7d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 20                	cmp    $0x20,%al
  800f87:	74 f4                	je     800f7d <strtol+0x16>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 09                	cmp    $0x9,%al
  800f90:	74 eb                	je     800f7d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 2b                	cmp    $0x2b,%al
  800f99:	75 05                	jne    800fa0 <strtol+0x39>
		s++;
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	eb 13                	jmp    800fb3 <strtol+0x4c>
	else if (*s == '-')
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 2d                	cmp    $0x2d,%al
  800fa7:	75 0a                	jne    800fb3 <strtol+0x4c>
		s++, neg = 1;
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 06                	je     800fbf <strtol+0x58>
  800fb9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fbd:	75 20                	jne    800fdf <strtol+0x78>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 30                	cmp    $0x30,%al
  800fc6:	75 17                	jne    800fdf <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	40                   	inc    %eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 78                	cmp    $0x78,%al
  800fd0:	75 0d                	jne    800fdf <strtol+0x78>
		s += 2, base = 16;
  800fd2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fdd:	eb 28                	jmp    801007 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 15                	jne    800ffa <strtol+0x93>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 30                	cmp    $0x30,%al
  800fec:	75 0c                	jne    800ffa <strtol+0x93>
		s++, base = 8;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff8:	eb 0d                	jmp    801007 <strtol+0xa0>
	else if (base == 0)
  800ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffe:	75 07                	jne    801007 <strtol+0xa0>
		base = 10;
  801000:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 2f                	cmp    $0x2f,%al
  80100e:	7e 19                	jle    801029 <strtol+0xc2>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 39                	cmp    $0x39,%al
  801017:	7f 10                	jg     801029 <strtol+0xc2>
			dig = *s - '0';
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f be c0             	movsbl %al,%eax
  801021:	83 e8 30             	sub    $0x30,%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801027:	eb 42                	jmp    80106b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 60                	cmp    $0x60,%al
  801030:	7e 19                	jle    80104b <strtol+0xe4>
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 7a                	cmp    $0x7a,%al
  801039:	7f 10                	jg     80104b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	0f be c0             	movsbl %al,%eax
  801043:	83 e8 57             	sub    $0x57,%eax
  801046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801049:	eb 20                	jmp    80106b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 40                	cmp    $0x40,%al
  801052:	7e 39                	jle    80108d <strtol+0x126>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 5a                	cmp    $0x5a,%al
  80105b:	7f 30                	jg     80108d <strtol+0x126>
			dig = *s - 'A' + 10;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 37             	sub    $0x37,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801071:	7d 19                	jge    80108c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801087:	e9 7b ff ff ff       	jmp    801007 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80108c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801091:	74 08                	je     80109b <strtol+0x134>
		*endptr = (char *) s;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80109b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109f:	74 07                	je     8010a8 <strtol+0x141>
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	f7 d8                	neg    %eax
  8010a6:	eb 03                	jmp    8010ab <strtol+0x144>
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <ltostr>:

void
ltostr(long value, char *str)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c5:	79 13                	jns    8010da <ltostr+0x2d>
	{
		neg = 1;
  8010c7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010e2:	99                   	cltd   
  8010e3:	f7 f9                	idiv   %ecx
  8010e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010eb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010fb:	83 c2 30             	add    $0x30,%edx
  8010fe:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801103:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801108:	f7 e9                	imul   %ecx
  80110a:	c1 fa 02             	sar    $0x2,%edx
  80110d:	89 c8                	mov    %ecx,%eax
  80110f:	c1 f8 1f             	sar    $0x1f,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
  801116:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801121:	f7 e9                	imul   %ecx
  801123:	c1 fa 02             	sar    $0x2,%edx
  801126:	89 c8                	mov    %ecx,%eax
  801128:	c1 f8 1f             	sar    $0x1f,%eax
  80112b:	29 c2                	sub    %eax,%edx
  80112d:	89 d0                	mov    %edx,%eax
  80112f:	c1 e0 02             	shl    $0x2,%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	01 c0                	add    %eax,%eax
  801136:	29 c1                	sub    %eax,%ecx
  801138:	89 ca                	mov    %ecx,%edx
  80113a:	85 d2                	test   %edx,%edx
  80113c:	75 9c                	jne    8010da <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	48                   	dec    %eax
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801150:	74 3d                	je     80118f <ltostr+0xe2>
		start = 1 ;
  801152:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801159:	eb 34                	jmp    80118f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80115b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	01 c8                	add    %ecx,%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8a 45 eb             	mov    -0x15(%ebp),%al
  801187:	88 02                	mov    %al,(%edx)
		start++ ;
  801189:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801195:	7c c4                	jl     80115b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801197:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 54 fa ff ff       	call   800c07 <strlen>
  8011b3:	83 c4 04             	add    $0x4,%esp
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	e8 46 fa ff ff       	call   800c07 <strlen>
  8011c1:	83 c4 04             	add    $0x4,%esp
  8011c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d5:	eb 17                	jmp    8011ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 c2                	add    %eax,%edx
  8011df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	01 c8                	add    %ecx,%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f4:	7c e1                	jl     8011d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801204:	eb 1f                	jmp    801225 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120f:	89 c2                	mov    %eax,%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801222:	ff 45 f8             	incl   -0x8(%ebp)
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122b:	7c d9                	jl     801206 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	c6 00 00             	movb   $0x0,(%eax)
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125e:	eb 0c                	jmp    80126c <strsplit+0x31>
			*string++ = 0;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 08             	mov    %edx,0x8(%ebp)
  801269:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 18                	je     80128d <strsplit+0x52>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	50                   	push   %eax
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	e8 13 fb ff ff       	call   800d99 <strchr>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 d3                	jne    801260 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	84 c0                	test   %al,%al
  801294:	74 5a                	je     8012f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	83 f8 0f             	cmp    $0xf,%eax
  80129e:	75 07                	jne    8012a7 <strsplit+0x6c>
		{
			return 0;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a5:	eb 66                	jmp    80130d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 c2                	add    %eax,%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c5:	eb 03                	jmp    8012ca <strsplit+0x8f>
			string++;
  8012c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	84 c0                	test   %al,%al
  8012d1:	74 8b                	je     80125e <strsplit+0x23>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	50                   	push   %eax
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 b5 fa ff ff       	call   800d99 <strchr>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	74 dc                	je     8012c7 <strsplit+0x8c>
			string++;
	}
  8012eb:	e9 6e ff ff ff       	jmp    80125e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801308:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801315:	a1 04 40 80 00       	mov    0x804004,%eax
  80131a:	85 c0                	test   %eax,%eax
  80131c:	74 1f                	je     80133d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131e:	e8 1d 00 00 00       	call   801340 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 10 3b 80 00       	push   $0x803b10
  80132b:	e8 55 f2 ff ff       	call   800585 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801333:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80133a:	00 00 00 
	}
}
  80133d:	90                   	nop
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801346:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80134d:	00 00 00 
  801350:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801357:	00 00 00 
  80135a:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801361:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801364:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80136b:	00 00 00 
  80136e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801375:	00 00 00 
  801378:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80137f:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801382:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801389:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80138c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801396:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139b:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a0:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8013a5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013ac:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b1:	c1 e0 04             	shl    $0x4,%eax
  8013b4:	89 c2                	mov    %eax,%edx
  8013b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	48                   	dec    %eax
  8013bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c7:	f7 75 f0             	divl   -0x10(%ebp)
  8013ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013cd:	29 d0                	sub    %edx,%eax
  8013cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8013d2:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e6:	83 ec 04             	sub    $0x4,%esp
  8013e9:	6a 06                	push   $0x6
  8013eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8013ee:	50                   	push   %eax
  8013ef:	e8 b0 05 00 00       	call   8019a4 <sys_allocate_chunk>
  8013f4:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013f7:	a1 20 41 80 00       	mov    0x804120,%eax
  8013fc:	83 ec 0c             	sub    $0xc,%esp
  8013ff:	50                   	push   %eax
  801400:	e8 25 0c 00 00       	call   80202a <initialize_MemBlocksList>
  801405:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801408:	a1 48 41 80 00       	mov    0x804148,%eax
  80140d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801410:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801414:	75 14                	jne    80142a <initialize_dyn_block_system+0xea>
  801416:	83 ec 04             	sub    $0x4,%esp
  801419:	68 35 3b 80 00       	push   $0x803b35
  80141e:	6a 29                	push   $0x29
  801420:	68 53 3b 80 00       	push   $0x803b53
  801425:	e8 a7 ee ff ff       	call   8002d1 <_panic>
  80142a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142d:	8b 00                	mov    (%eax),%eax
  80142f:	85 c0                	test   %eax,%eax
  801431:	74 10                	je     801443 <initialize_dyn_block_system+0x103>
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80143b:	8b 52 04             	mov    0x4(%edx),%edx
  80143e:	89 50 04             	mov    %edx,0x4(%eax)
  801441:	eb 0b                	jmp    80144e <initialize_dyn_block_system+0x10e>
  801443:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801446:	8b 40 04             	mov    0x4(%eax),%eax
  801449:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80144e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801451:	8b 40 04             	mov    0x4(%eax),%eax
  801454:	85 c0                	test   %eax,%eax
  801456:	74 0f                	je     801467 <initialize_dyn_block_system+0x127>
  801458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145b:	8b 40 04             	mov    0x4(%eax),%eax
  80145e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801461:	8b 12                	mov    (%edx),%edx
  801463:	89 10                	mov    %edx,(%eax)
  801465:	eb 0a                	jmp    801471 <initialize_dyn_block_system+0x131>
  801467:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146a:	8b 00                	mov    (%eax),%eax
  80146c:	a3 48 41 80 00       	mov    %eax,0x804148
  801471:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801474:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80147a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801484:	a1 54 41 80 00       	mov    0x804154,%eax
  801489:	48                   	dec    %eax
  80148a:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80148f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801492:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801499:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8014a3:	83 ec 0c             	sub    $0xc,%esp
  8014a6:	ff 75 e0             	pushl  -0x20(%ebp)
  8014a9:	e8 b9 14 00 00       	call   802967 <insert_sorted_with_merge_freeList>
  8014ae:	83 c4 10             	add    $0x10,%esp

}
  8014b1:	90                   	nop
  8014b2:	c9                   	leave  
  8014b3:	c3                   	ret    

008014b4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014b4:	55                   	push   %ebp
  8014b5:	89 e5                	mov    %esp,%ebp
  8014b7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014ba:	e8 50 fe ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  8014bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c3:	75 07                	jne    8014cc <malloc+0x18>
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ca:	eb 68                	jmp    801534 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8014cc:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d9:	01 d0                	add    %edx,%eax
  8014db:	48                   	dec    %eax
  8014dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e7:	f7 75 f4             	divl   -0xc(%ebp)
  8014ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ed:	29 d0                	sub    %edx,%eax
  8014ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8014f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014f9:	e8 74 08 00 00       	call   801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014fe:	85 c0                	test   %eax,%eax
  801500:	74 2d                	je     80152f <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801502:	83 ec 0c             	sub    $0xc,%esp
  801505:	ff 75 ec             	pushl  -0x14(%ebp)
  801508:	e8 52 0e 00 00       	call   80235f <alloc_block_FF>
  80150d:	83 c4 10             	add    $0x10,%esp
  801510:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801513:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801517:	74 16                	je     80152f <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801519:	83 ec 0c             	sub    $0xc,%esp
  80151c:	ff 75 e8             	pushl  -0x18(%ebp)
  80151f:	e8 3b 0c 00 00       	call   80215f <insert_sorted_allocList>
  801524:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801527:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80152a:	8b 40 08             	mov    0x8(%eax),%eax
  80152d:	eb 05                	jmp    801534 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  80152f:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801534:	c9                   	leave  
  801535:	c3                   	ret    

00801536 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801536:	55                   	push   %ebp
  801537:	89 e5                	mov    %esp,%ebp
  801539:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  80153c:	8b 45 08             	mov    0x8(%ebp),%eax
  80153f:	83 ec 08             	sub    $0x8,%esp
  801542:	50                   	push   %eax
  801543:	68 40 40 80 00       	push   $0x804040
  801548:	e8 ba 0b 00 00       	call   802107 <find_block>
  80154d:	83 c4 10             	add    $0x10,%esp
  801550:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801556:	8b 40 0c             	mov    0xc(%eax),%eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80155c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801560:	0f 84 9f 00 00 00    	je     801605 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801566:	8b 45 08             	mov    0x8(%ebp),%eax
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	ff 75 f0             	pushl  -0x10(%ebp)
  80156f:	50                   	push   %eax
  801570:	e8 f7 03 00 00       	call   80196c <sys_free_user_mem>
  801575:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801578:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80157c:	75 14                	jne    801592 <free+0x5c>
  80157e:	83 ec 04             	sub    $0x4,%esp
  801581:	68 35 3b 80 00       	push   $0x803b35
  801586:	6a 6a                	push   $0x6a
  801588:	68 53 3b 80 00       	push   $0x803b53
  80158d:	e8 3f ed ff ff       	call   8002d1 <_panic>
  801592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801595:	8b 00                	mov    (%eax),%eax
  801597:	85 c0                	test   %eax,%eax
  801599:	74 10                	je     8015ab <free+0x75>
  80159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159e:	8b 00                	mov    (%eax),%eax
  8015a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a3:	8b 52 04             	mov    0x4(%edx),%edx
  8015a6:	89 50 04             	mov    %edx,0x4(%eax)
  8015a9:	eb 0b                	jmp    8015b6 <free+0x80>
  8015ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ae:	8b 40 04             	mov    0x4(%eax),%eax
  8015b1:	a3 44 40 80 00       	mov    %eax,0x804044
  8015b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b9:	8b 40 04             	mov    0x4(%eax),%eax
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	74 0f                	je     8015cf <free+0x99>
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	8b 40 04             	mov    0x4(%eax),%eax
  8015c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c9:	8b 12                	mov    (%edx),%edx
  8015cb:	89 10                	mov    %edx,(%eax)
  8015cd:	eb 0a                	jmp    8015d9 <free+0xa3>
  8015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	a3 40 40 80 00       	mov    %eax,0x804040
  8015d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015f1:	48                   	dec    %eax
  8015f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8015f7:	83 ec 0c             	sub    $0xc,%esp
  8015fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fd:	e8 65 13 00 00       	call   802967 <insert_sorted_with_merge_freeList>
  801602:	83 c4 10             	add    $0x10,%esp
	}
}
  801605:	90                   	nop
  801606:	c9                   	leave  
  801607:	c3                   	ret    

00801608 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801608:	55                   	push   %ebp
  801609:	89 e5                	mov    %esp,%ebp
  80160b:	83 ec 28             	sub    $0x28,%esp
  80160e:	8b 45 10             	mov    0x10(%ebp),%eax
  801611:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801614:	e8 f6 fc ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  801619:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161d:	75 0a                	jne    801629 <smalloc+0x21>
  80161f:	b8 00 00 00 00       	mov    $0x0,%eax
  801624:	e9 af 00 00 00       	jmp    8016d8 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801629:	e8 44 07 00 00       	call   801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162e:	83 f8 01             	cmp    $0x1,%eax
  801631:	0f 85 9c 00 00 00    	jne    8016d3 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801637:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80163e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801644:	01 d0                	add    %edx,%eax
  801646:	48                   	dec    %eax
  801647:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80164a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164d:	ba 00 00 00 00       	mov    $0x0,%edx
  801652:	f7 75 f4             	divl   -0xc(%ebp)
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801658:	29 d0                	sub    %edx,%eax
  80165a:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80165d:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801664:	76 07                	jbe    80166d <smalloc+0x65>
			return NULL;
  801666:	b8 00 00 00 00       	mov    $0x0,%eax
  80166b:	eb 6b                	jmp    8016d8 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	ff 75 0c             	pushl  0xc(%ebp)
  801673:	e8 e7 0c 00 00       	call   80235f <alloc_block_FF>
  801678:	83 c4 10             	add    $0x10,%esp
  80167b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80167e:	83 ec 0c             	sub    $0xc,%esp
  801681:	ff 75 ec             	pushl  -0x14(%ebp)
  801684:	e8 d6 0a 00 00       	call   80215f <insert_sorted_allocList>
  801689:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80168c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801690:	75 07                	jne    801699 <smalloc+0x91>
		{
			return NULL;
  801692:	b8 00 00 00 00       	mov    $0x0,%eax
  801697:	eb 3f                	jmp    8016d8 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801699:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169c:	8b 40 08             	mov    0x8(%eax),%eax
  80169f:	89 c2                	mov    %eax,%edx
  8016a1:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016a5:	52                   	push   %edx
  8016a6:	50                   	push   %eax
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	ff 75 08             	pushl  0x8(%ebp)
  8016ad:	e8 45 04 00 00       	call   801af7 <sys_createSharedObject>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8016b8:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016bc:	74 06                	je     8016c4 <smalloc+0xbc>
  8016be:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016c2:	75 07                	jne    8016cb <smalloc+0xc3>
		{
			return NULL;
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	eb 0d                	jmp    8016d8 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8016cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ce:	8b 40 08             	mov    0x8(%eax),%eax
  8016d1:	eb 05                	jmp    8016d8 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d8:	c9                   	leave  
  8016d9:	c3                   	ret    

008016da <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016da:	55                   	push   %ebp
  8016db:	89 e5                	mov    %esp,%ebp
  8016dd:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e0:	e8 2a fc ff ff       	call   80130f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016e5:	83 ec 08             	sub    $0x8,%esp
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	e8 2e 04 00 00       	call   801b21 <sys_getSizeOfSharedObject>
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8016f9:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016fd:	75 0a                	jne    801709 <sget+0x2f>
	{
		return NULL;
  8016ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801704:	e9 94 00 00 00       	jmp    80179d <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801709:	e8 64 06 00 00       	call   801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170e:	85 c0                	test   %eax,%eax
  801710:	0f 84 82 00 00 00    	je     801798 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801716:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  80171d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801724:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801727:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80172a:	01 d0                	add    %edx,%eax
  80172c:	48                   	dec    %eax
  80172d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801730:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801733:	ba 00 00 00 00       	mov    $0x0,%edx
  801738:	f7 75 ec             	divl   -0x14(%ebp)
  80173b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80173e:	29 d0                	sub    %edx,%eax
  801740:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801746:	83 ec 0c             	sub    $0xc,%esp
  801749:	50                   	push   %eax
  80174a:	e8 10 0c 00 00       	call   80235f <alloc_block_FF>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801755:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801759:	75 07                	jne    801762 <sget+0x88>
		{
			return NULL;
  80175b:	b8 00 00 00 00       	mov    $0x0,%eax
  801760:	eb 3b                	jmp    80179d <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801765:	8b 40 08             	mov    0x8(%eax),%eax
  801768:	83 ec 04             	sub    $0x4,%esp
  80176b:	50                   	push   %eax
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	ff 75 08             	pushl  0x8(%ebp)
  801772:	e8 c7 03 00 00       	call   801b3e <sys_getSharedObject>
  801777:	83 c4 10             	add    $0x10,%esp
  80177a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80177d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801781:	74 06                	je     801789 <sget+0xaf>
  801783:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801787:	75 07                	jne    801790 <sget+0xb6>
		{
			return NULL;
  801789:	b8 00 00 00 00       	mov    $0x0,%eax
  80178e:	eb 0d                	jmp    80179d <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801793:	8b 40 08             	mov    0x8(%eax),%eax
  801796:	eb 05                	jmp    80179d <sget+0xc3>
		}
	}
	else
			return NULL;
  801798:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    

0080179f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80179f:	55                   	push   %ebp
  8017a0:	89 e5                	mov    %esp,%ebp
  8017a2:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a5:	e8 65 fb ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017aa:	83 ec 04             	sub    $0x4,%esp
  8017ad:	68 60 3b 80 00       	push   $0x803b60
  8017b2:	68 e1 00 00 00       	push   $0xe1
  8017b7:	68 53 3b 80 00       	push   $0x803b53
  8017bc:	e8 10 eb ff ff       	call   8002d1 <_panic>

008017c1 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017c1:	55                   	push   %ebp
  8017c2:	89 e5                	mov    %esp,%ebp
  8017c4:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c7:	83 ec 04             	sub    $0x4,%esp
  8017ca:	68 88 3b 80 00       	push   $0x803b88
  8017cf:	68 f5 00 00 00       	push   $0xf5
  8017d4:	68 53 3b 80 00       	push   $0x803b53
  8017d9:	e8 f3 ea ff ff       	call   8002d1 <_panic>

008017de <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	68 ac 3b 80 00       	push   $0x803bac
  8017ec:	68 00 01 00 00       	push   $0x100
  8017f1:	68 53 3b 80 00       	push   $0x803b53
  8017f6:	e8 d6 ea ff ff       	call   8002d1 <_panic>

008017fb <shrink>:

}
void shrink(uint32 newSize)
{
  8017fb:	55                   	push   %ebp
  8017fc:	89 e5                	mov    %esp,%ebp
  8017fe:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801801:	83 ec 04             	sub    $0x4,%esp
  801804:	68 ac 3b 80 00       	push   $0x803bac
  801809:	68 05 01 00 00       	push   $0x105
  80180e:	68 53 3b 80 00       	push   $0x803b53
  801813:	e8 b9 ea ff ff       	call   8002d1 <_panic>

00801818 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
  80181b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 ac 3b 80 00       	push   $0x803bac
  801826:	68 0a 01 00 00       	push   $0x10a
  80182b:	68 53 3b 80 00       	push   $0x803b53
  801830:	e8 9c ea ff ff       	call   8002d1 <_panic>

00801835 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	57                   	push   %edi
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183e:	8b 45 08             	mov    0x8(%ebp),%eax
  801841:	8b 55 0c             	mov    0xc(%ebp),%edx
  801844:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801847:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80184a:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184d:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801850:	cd 30                	int    $0x30
  801852:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801855:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5f                   	pop    %edi
  80185e:	5d                   	pop    %ebp
  80185f:	c3                   	ret    

00801860 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	8b 45 10             	mov    0x10(%ebp),%eax
  801869:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80186c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	52                   	push   %edx
  801878:	ff 75 0c             	pushl  0xc(%ebp)
  80187b:	50                   	push   %eax
  80187c:	6a 00                	push   $0x0
  80187e:	e8 b2 ff ff ff       	call   801835 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_cgetc>:

int
sys_cgetc(void)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80188c:	6a 00                	push   $0x0
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 01                	push   $0x1
  801898:	e8 98 ff ff ff       	call   801835 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	52                   	push   %edx
  8018b2:	50                   	push   %eax
  8018b3:	6a 05                	push   $0x5
  8018b5:	e8 7b ff ff ff       	call   801835 <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c4:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	56                   	push   %esi
  8018d4:	53                   	push   %ebx
  8018d5:	51                   	push   %ecx
  8018d6:	52                   	push   %edx
  8018d7:	50                   	push   %eax
  8018d8:	6a 06                	push   $0x6
  8018da:	e8 56 ff ff ff       	call   801835 <syscall>
  8018df:	83 c4 18             	add    $0x18,%esp
}
  8018e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e5:	5b                   	pop    %ebx
  8018e6:	5e                   	pop    %esi
  8018e7:	5d                   	pop    %ebp
  8018e8:	c3                   	ret    

008018e9 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 07                	push   $0x7
  8018fc:	e8 34 ff ff ff       	call   801835 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	6a 08                	push   $0x8
  801917:	e8 19 ff ff ff       	call   801835 <syscall>
  80191c:	83 c4 18             	add    $0x18,%esp
}
  80191f:	c9                   	leave  
  801920:	c3                   	ret    

00801921 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 09                	push   $0x9
  801930:	e8 00 ff ff ff       	call   801835 <syscall>
  801935:	83 c4 18             	add    $0x18,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	6a 0a                	push   $0xa
  801949:	e8 e7 fe ff ff       	call   801835 <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 0b                	push   $0xb
  801962:	e8 ce fe ff ff       	call   801835 <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	ff 75 0c             	pushl  0xc(%ebp)
  801978:	ff 75 08             	pushl  0x8(%ebp)
  80197b:	6a 0f                	push   $0xf
  80197d:	e8 b3 fe ff ff       	call   801835 <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
	return;
  801985:	90                   	nop
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	ff 75 08             	pushl  0x8(%ebp)
  801997:	6a 10                	push   $0x10
  801999:	e8 97 fe ff ff       	call   801835 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a1:	90                   	nop
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	ff 75 10             	pushl  0x10(%ebp)
  8019ae:	ff 75 0c             	pushl  0xc(%ebp)
  8019b1:	ff 75 08             	pushl  0x8(%ebp)
  8019b4:	6a 11                	push   $0x11
  8019b6:	e8 7a fe ff ff       	call   801835 <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
	return ;
  8019be:	90                   	nop
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 0c                	push   $0xc
  8019d0:	e8 60 fe ff ff       	call   801835 <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	ff 75 08             	pushl  0x8(%ebp)
  8019e8:	6a 0d                	push   $0xd
  8019ea:	e8 46 fe ff ff       	call   801835 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 0e                	push   $0xe
  801a03:	e8 2d fe ff ff       	call   801835 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	90                   	nop
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 13                	push   $0x13
  801a1d:	e8 13 fe ff ff       	call   801835 <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 14                	push   $0x14
  801a37:	e8 f9 fd ff ff       	call   801835 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
}
  801a3f:	90                   	nop
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	83 ec 04             	sub    $0x4,%esp
  801a48:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a4e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	50                   	push   %eax
  801a5b:	6a 15                	push   $0x15
  801a5d:	e8 d3 fd ff ff       	call   801835 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	90                   	nop
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 16                	push   $0x16
  801a77:	e8 b9 fd ff ff       	call   801835 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	90                   	nop
  801a80:	c9                   	leave  
  801a81:	c3                   	ret    

00801a82 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a82:	55                   	push   %ebp
  801a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	50                   	push   %eax
  801a92:	6a 17                	push   $0x17
  801a94:	e8 9c fd ff ff       	call   801835 <syscall>
  801a99:	83 c4 18             	add    $0x18,%esp
}
  801a9c:	c9                   	leave  
  801a9d:	c3                   	ret    

00801a9e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	52                   	push   %edx
  801aae:	50                   	push   %eax
  801aaf:	6a 1a                	push   $0x1a
  801ab1:	e8 7f fd ff ff       	call   801835 <syscall>
  801ab6:	83 c4 18             	add    $0x18,%esp
}
  801ab9:	c9                   	leave  
  801aba:	c3                   	ret    

00801abb <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	52                   	push   %edx
  801acb:	50                   	push   %eax
  801acc:	6a 18                	push   $0x18
  801ace:	e8 62 fd ff ff       	call   801835 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801adc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	52                   	push   %edx
  801ae9:	50                   	push   %eax
  801aea:	6a 19                	push   $0x19
  801aec:	e8 44 fd ff ff       	call   801835 <syscall>
  801af1:	83 c4 18             	add    $0x18,%esp
}
  801af4:	90                   	nop
  801af5:	c9                   	leave  
  801af6:	c3                   	ret    

00801af7 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af7:	55                   	push   %ebp
  801af8:	89 e5                	mov    %esp,%ebp
  801afa:	83 ec 04             	sub    $0x4,%esp
  801afd:	8b 45 10             	mov    0x10(%ebp),%eax
  801b00:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b03:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b06:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	51                   	push   %ecx
  801b10:	52                   	push   %edx
  801b11:	ff 75 0c             	pushl  0xc(%ebp)
  801b14:	50                   	push   %eax
  801b15:	6a 1b                	push   $0x1b
  801b17:	e8 19 fd ff ff       	call   801835 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b27:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	52                   	push   %edx
  801b31:	50                   	push   %eax
  801b32:	6a 1c                	push   $0x1c
  801b34:	e8 fc fc ff ff       	call   801835 <syscall>
  801b39:	83 c4 18             	add    $0x18,%esp
}
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b41:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	51                   	push   %ecx
  801b4f:	52                   	push   %edx
  801b50:	50                   	push   %eax
  801b51:	6a 1d                	push   $0x1d
  801b53:	e8 dd fc ff ff       	call   801835 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	52                   	push   %edx
  801b6d:	50                   	push   %eax
  801b6e:	6a 1e                	push   $0x1e
  801b70:	e8 c0 fc ff ff       	call   801835 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 1f                	push   $0x1f
  801b89:	e8 a7 fc ff ff       	call   801835 <syscall>
  801b8e:	83 c4 18             	add    $0x18,%esp
}
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	ff 75 14             	pushl  0x14(%ebp)
  801b9e:	ff 75 10             	pushl  0x10(%ebp)
  801ba1:	ff 75 0c             	pushl  0xc(%ebp)
  801ba4:	50                   	push   %eax
  801ba5:	6a 20                	push   $0x20
  801ba7:	e8 89 fc ff ff       	call   801835 <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	50                   	push   %eax
  801bc0:	6a 21                	push   $0x21
  801bc2:	e8 6e fc ff ff       	call   801835 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	90                   	nop
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	50                   	push   %eax
  801bdc:	6a 22                	push   $0x22
  801bde:	e8 52 fc ff ff       	call   801835 <syscall>
  801be3:	83 c4 18             	add    $0x18,%esp
}
  801be6:	c9                   	leave  
  801be7:	c3                   	ret    

00801be8 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be8:	55                   	push   %ebp
  801be9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 02                	push   $0x2
  801bf7:	e8 39 fc ff ff       	call   801835 <syscall>
  801bfc:	83 c4 18             	add    $0x18,%esp
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 03                	push   $0x3
  801c10:	e8 20 fc ff ff       	call   801835 <syscall>
  801c15:	83 c4 18             	add    $0x18,%esp
}
  801c18:	c9                   	leave  
  801c19:	c3                   	ret    

00801c1a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c1a:	55                   	push   %ebp
  801c1b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 00                	push   $0x0
  801c27:	6a 04                	push   $0x4
  801c29:	e8 07 fc ff ff       	call   801835 <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_exit_env>:


void sys_exit_env(void)
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 23                	push   $0x23
  801c42:	e8 ee fb ff ff       	call   801835 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	90                   	nop
  801c4b:	c9                   	leave  
  801c4c:	c3                   	ret    

00801c4d <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c53:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c56:	8d 50 04             	lea    0x4(%eax),%edx
  801c59:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	6a 24                	push   $0x24
  801c66:	e8 ca fb ff ff       	call   801835 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c6e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c74:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c77:	89 01                	mov    %eax,(%ecx)
  801c79:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	c9                   	leave  
  801c80:	c2 04 00             	ret    $0x4

00801c83 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	ff 75 10             	pushl  0x10(%ebp)
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	6a 12                	push   $0x12
  801c95:	e8 9b fb ff ff       	call   801835 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9d:	90                   	nop
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 25                	push   $0x25
  801caf:	e8 81 fb ff ff       	call   801835 <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	83 ec 04             	sub    $0x4,%esp
  801cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc5:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	50                   	push   %eax
  801cd2:	6a 26                	push   $0x26
  801cd4:	e8 5c fb ff ff       	call   801835 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdc:	90                   	nop
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <rsttst>:
void rsttst()
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 28                	push   $0x28
  801cee:	e8 42 fb ff ff       	call   801835 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
  801cfc:	83 ec 04             	sub    $0x4,%esp
  801cff:	8b 45 14             	mov    0x14(%ebp),%eax
  801d02:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d05:	8b 55 18             	mov    0x18(%ebp),%edx
  801d08:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d0c:	52                   	push   %edx
  801d0d:	50                   	push   %eax
  801d0e:	ff 75 10             	pushl  0x10(%ebp)
  801d11:	ff 75 0c             	pushl  0xc(%ebp)
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	6a 27                	push   $0x27
  801d19:	e8 17 fb ff ff       	call   801835 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <chktst>:
void chktst(uint32 n)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	ff 75 08             	pushl  0x8(%ebp)
  801d32:	6a 29                	push   $0x29
  801d34:	e8 fc fa ff ff       	call   801835 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3c:	90                   	nop
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <inctst>:

void inctst()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 2a                	push   $0x2a
  801d4e:	e8 e2 fa ff ff       	call   801835 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <gettst>:
uint32 gettst()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 2b                	push   $0x2b
  801d68:	e8 c8 fa ff ff       	call   801835 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 2c                	push   $0x2c
  801d84:	e8 ac fa ff ff       	call   801835 <syscall>
  801d89:	83 c4 18             	add    $0x18,%esp
  801d8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d8f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d93:	75 07                	jne    801d9c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d95:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9a:	eb 05                	jmp    801da1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
  801da6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 2c                	push   $0x2c
  801db5:	e8 7b fa ff ff       	call   801835 <syscall>
  801dba:	83 c4 18             	add    $0x18,%esp
  801dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dc0:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc4:	75 07                	jne    801dcd <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcb:	eb 05                	jmp    801dd2 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dcd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd2:	c9                   	leave  
  801dd3:	c3                   	ret    

00801dd4 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd4:	55                   	push   %ebp
  801dd5:	89 e5                	mov    %esp,%ebp
  801dd7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 2c                	push   $0x2c
  801de6:	e8 4a fa ff ff       	call   801835 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
  801dee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801df1:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df5:	75 07                	jne    801dfe <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfc:	eb 05                	jmp    801e03 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e03:	c9                   	leave  
  801e04:	c3                   	ret    

00801e05 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e05:	55                   	push   %ebp
  801e06:	89 e5                	mov    %esp,%ebp
  801e08:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 2c                	push   $0x2c
  801e17:	e8 19 fa ff ff       	call   801835 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
  801e1f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e22:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e26:	75 07                	jne    801e2f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e28:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2d:	eb 05                	jmp    801e34 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e2f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	ff 75 08             	pushl  0x8(%ebp)
  801e44:	6a 2d                	push   $0x2d
  801e46:	e8 ea f9 ff ff       	call   801835 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4e:	90                   	nop
}
  801e4f:	c9                   	leave  
  801e50:	c3                   	ret    

00801e51 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e55:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e58:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e61:	6a 00                	push   $0x0
  801e63:	53                   	push   %ebx
  801e64:	51                   	push   %ecx
  801e65:	52                   	push   %edx
  801e66:	50                   	push   %eax
  801e67:	6a 2e                	push   $0x2e
  801e69:	e8 c7 f9 ff ff       	call   801835 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
}
  801e71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e79:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	52                   	push   %edx
  801e86:	50                   	push   %eax
  801e87:	6a 2f                	push   $0x2f
  801e89:	e8 a7 f9 ff ff       	call   801835 <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e99:	83 ec 0c             	sub    $0xc,%esp
  801e9c:	68 bc 3b 80 00       	push   $0x803bbc
  801ea1:	e8 df e6 ff ff       	call   800585 <cprintf>
  801ea6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ea9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	68 e8 3b 80 00       	push   $0x803be8
  801eb8:	e8 c8 e6 ff ff       	call   800585 <cprintf>
  801ebd:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ec0:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec4:	a1 38 41 80 00       	mov    0x804138,%eax
  801ec9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ecc:	eb 56                	jmp    801f24 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ece:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed2:	74 1c                	je     801ef0 <print_mem_block_lists+0x5d>
  801ed4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed7:	8b 50 08             	mov    0x8(%eax),%edx
  801eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edd:	8b 48 08             	mov    0x8(%eax),%ecx
  801ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee6:	01 c8                	add    %ecx,%eax
  801ee8:	39 c2                	cmp    %eax,%edx
  801eea:	73 04                	jae    801ef0 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eec:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef3:	8b 50 08             	mov    0x8(%eax),%edx
  801ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef9:	8b 40 0c             	mov    0xc(%eax),%eax
  801efc:	01 c2                	add    %eax,%edx
  801efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f01:	8b 40 08             	mov    0x8(%eax),%eax
  801f04:	83 ec 04             	sub    $0x4,%esp
  801f07:	52                   	push   %edx
  801f08:	50                   	push   %eax
  801f09:	68 fd 3b 80 00       	push   $0x803bfd
  801f0e:	e8 72 e6 ff ff       	call   800585 <cprintf>
  801f13:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f1c:	a1 40 41 80 00       	mov    0x804140,%eax
  801f21:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f28:	74 07                	je     801f31 <print_mem_block_lists+0x9e>
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	8b 00                	mov    (%eax),%eax
  801f2f:	eb 05                	jmp    801f36 <print_mem_block_lists+0xa3>
  801f31:	b8 00 00 00 00       	mov    $0x0,%eax
  801f36:	a3 40 41 80 00       	mov    %eax,0x804140
  801f3b:	a1 40 41 80 00       	mov    0x804140,%eax
  801f40:	85 c0                	test   %eax,%eax
  801f42:	75 8a                	jne    801ece <print_mem_block_lists+0x3b>
  801f44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f48:	75 84                	jne    801ece <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f4a:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f4e:	75 10                	jne    801f60 <print_mem_block_lists+0xcd>
  801f50:	83 ec 0c             	sub    $0xc,%esp
  801f53:	68 0c 3c 80 00       	push   $0x803c0c
  801f58:	e8 28 e6 ff ff       	call   800585 <cprintf>
  801f5d:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f67:	83 ec 0c             	sub    $0xc,%esp
  801f6a:	68 30 3c 80 00       	push   $0x803c30
  801f6f:	e8 11 e6 ff ff       	call   800585 <cprintf>
  801f74:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f77:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f7b:	a1 40 40 80 00       	mov    0x804040,%eax
  801f80:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f83:	eb 56                	jmp    801fdb <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f85:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f89:	74 1c                	je     801fa7 <print_mem_block_lists+0x114>
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	8b 50 08             	mov    0x8(%eax),%edx
  801f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f94:	8b 48 08             	mov    0x8(%eax),%ecx
  801f97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9d:	01 c8                	add    %ecx,%eax
  801f9f:	39 c2                	cmp    %eax,%edx
  801fa1:	73 04                	jae    801fa7 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa3:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801faa:	8b 50 08             	mov    0x8(%eax),%edx
  801fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb3:	01 c2                	add    %eax,%edx
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	8b 40 08             	mov    0x8(%eax),%eax
  801fbb:	83 ec 04             	sub    $0x4,%esp
  801fbe:	52                   	push   %edx
  801fbf:	50                   	push   %eax
  801fc0:	68 fd 3b 80 00       	push   $0x803bfd
  801fc5:	e8 bb e5 ff ff       	call   800585 <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd3:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdf:	74 07                	je     801fe8 <print_mem_block_lists+0x155>
  801fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe4:	8b 00                	mov    (%eax),%eax
  801fe6:	eb 05                	jmp    801fed <print_mem_block_lists+0x15a>
  801fe8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fed:	a3 48 40 80 00       	mov    %eax,0x804048
  801ff2:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	75 8a                	jne    801f85 <print_mem_block_lists+0xf2>
  801ffb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fff:	75 84                	jne    801f85 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802001:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802005:	75 10                	jne    802017 <print_mem_block_lists+0x184>
  802007:	83 ec 0c             	sub    $0xc,%esp
  80200a:	68 48 3c 80 00       	push   $0x803c48
  80200f:	e8 71 e5 ff ff       	call   800585 <cprintf>
  802014:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	68 bc 3b 80 00       	push   $0x803bbc
  80201f:	e8 61 e5 ff ff       	call   800585 <cprintf>
  802024:	83 c4 10             	add    $0x10,%esp

}
  802027:	90                   	nop
  802028:	c9                   	leave  
  802029:	c3                   	ret    

0080202a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80202a:	55                   	push   %ebp
  80202b:	89 e5                	mov    %esp,%ebp
  80202d:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802030:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802037:	00 00 00 
  80203a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802041:	00 00 00 
  802044:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80204b:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80204e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802055:	e9 9e 00 00 00       	jmp    8020f8 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80205a:	a1 50 40 80 00       	mov    0x804050,%eax
  80205f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802062:	c1 e2 04             	shl    $0x4,%edx
  802065:	01 d0                	add    %edx,%eax
  802067:	85 c0                	test   %eax,%eax
  802069:	75 14                	jne    80207f <initialize_MemBlocksList+0x55>
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	68 70 3c 80 00       	push   $0x803c70
  802073:	6a 42                	push   $0x42
  802075:	68 93 3c 80 00       	push   $0x803c93
  80207a:	e8 52 e2 ff ff       	call   8002d1 <_panic>
  80207f:	a1 50 40 80 00       	mov    0x804050,%eax
  802084:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802087:	c1 e2 04             	shl    $0x4,%edx
  80208a:	01 d0                	add    %edx,%eax
  80208c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802092:	89 10                	mov    %edx,(%eax)
  802094:	8b 00                	mov    (%eax),%eax
  802096:	85 c0                	test   %eax,%eax
  802098:	74 18                	je     8020b2 <initialize_MemBlocksList+0x88>
  80209a:	a1 48 41 80 00       	mov    0x804148,%eax
  80209f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020a5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020a8:	c1 e1 04             	shl    $0x4,%ecx
  8020ab:	01 ca                	add    %ecx,%edx
  8020ad:	89 50 04             	mov    %edx,0x4(%eax)
  8020b0:	eb 12                	jmp    8020c4 <initialize_MemBlocksList+0x9a>
  8020b2:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ba:	c1 e2 04             	shl    $0x4,%edx
  8020bd:	01 d0                	add    %edx,%eax
  8020bf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020c4:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cc:	c1 e2 04             	shl    $0x4,%edx
  8020cf:	01 d0                	add    %edx,%eax
  8020d1:	a3 48 41 80 00       	mov    %eax,0x804148
  8020d6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020db:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020de:	c1 e2 04             	shl    $0x4,%edx
  8020e1:	01 d0                	add    %edx,%eax
  8020e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8020ef:	40                   	inc    %eax
  8020f0:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8020f5:	ff 45 f4             	incl   -0xc(%ebp)
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020fe:	0f 82 56 ff ff ff    	jb     80205a <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802104:	90                   	nop
  802105:	c9                   	leave  
  802106:	c3                   	ret    

00802107 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80210d:	8b 45 08             	mov    0x8(%ebp),%eax
  802110:	8b 00                	mov    (%eax),%eax
  802112:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802115:	eb 19                	jmp    802130 <find_block+0x29>
	{
		if(blk->sva==va)
  802117:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211a:	8b 40 08             	mov    0x8(%eax),%eax
  80211d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802120:	75 05                	jne    802127 <find_block+0x20>
			return (blk);
  802122:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802125:	eb 36                	jmp    80215d <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802127:	8b 45 08             	mov    0x8(%ebp),%eax
  80212a:	8b 40 08             	mov    0x8(%eax),%eax
  80212d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802130:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802134:	74 07                	je     80213d <find_block+0x36>
  802136:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802139:	8b 00                	mov    (%eax),%eax
  80213b:	eb 05                	jmp    802142 <find_block+0x3b>
  80213d:	b8 00 00 00 00       	mov    $0x0,%eax
  802142:	8b 55 08             	mov    0x8(%ebp),%edx
  802145:	89 42 08             	mov    %eax,0x8(%edx)
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	8b 40 08             	mov    0x8(%eax),%eax
  80214e:	85 c0                	test   %eax,%eax
  802150:	75 c5                	jne    802117 <find_block+0x10>
  802152:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802156:	75 bf                	jne    802117 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802165:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80216a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80216d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802177:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80217a:	75 65                	jne    8021e1 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80217c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802180:	75 14                	jne    802196 <insert_sorted_allocList+0x37>
  802182:	83 ec 04             	sub    $0x4,%esp
  802185:	68 70 3c 80 00       	push   $0x803c70
  80218a:	6a 5c                	push   $0x5c
  80218c:	68 93 3c 80 00       	push   $0x803c93
  802191:	e8 3b e1 ff ff       	call   8002d1 <_panic>
  802196:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	89 10                	mov    %edx,(%eax)
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	8b 00                	mov    (%eax),%eax
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	74 0d                	je     8021b7 <insert_sorted_allocList+0x58>
  8021aa:	a1 40 40 80 00       	mov    0x804040,%eax
  8021af:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b2:	89 50 04             	mov    %edx,0x4(%eax)
  8021b5:	eb 08                	jmp    8021bf <insert_sorted_allocList+0x60>
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	a3 44 40 80 00       	mov    %eax,0x804044
  8021bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c2:	a3 40 40 80 00       	mov    %eax,0x804040
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021d6:	40                   	inc    %eax
  8021d7:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8021dc:	e9 7b 01 00 00       	jmp    80235c <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8021e1:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8021e9:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	8b 50 08             	mov    0x8(%eax),%edx
  8021f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021fa:	8b 40 08             	mov    0x8(%eax),%eax
  8021fd:	39 c2                	cmp    %eax,%edx
  8021ff:	76 65                	jbe    802266 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802201:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802205:	75 14                	jne    80221b <insert_sorted_allocList+0xbc>
  802207:	83 ec 04             	sub    $0x4,%esp
  80220a:	68 ac 3c 80 00       	push   $0x803cac
  80220f:	6a 64                	push   $0x64
  802211:	68 93 3c 80 00       	push   $0x803c93
  802216:	e8 b6 e0 ff ff       	call   8002d1 <_panic>
  80221b:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	89 50 04             	mov    %edx,0x4(%eax)
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	8b 40 04             	mov    0x4(%eax),%eax
  80222d:	85 c0                	test   %eax,%eax
  80222f:	74 0c                	je     80223d <insert_sorted_allocList+0xde>
  802231:	a1 44 40 80 00       	mov    0x804044,%eax
  802236:	8b 55 08             	mov    0x8(%ebp),%edx
  802239:	89 10                	mov    %edx,(%eax)
  80223b:	eb 08                	jmp    802245 <insert_sorted_allocList+0xe6>
  80223d:	8b 45 08             	mov    0x8(%ebp),%eax
  802240:	a3 40 40 80 00       	mov    %eax,0x804040
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	a3 44 40 80 00       	mov    %eax,0x804044
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802256:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80225b:	40                   	inc    %eax
  80225c:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802261:	e9 f6 00 00 00       	jmp    80235c <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802266:	8b 45 08             	mov    0x8(%ebp),%eax
  802269:	8b 50 08             	mov    0x8(%eax),%edx
  80226c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80226f:	8b 40 08             	mov    0x8(%eax),%eax
  802272:	39 c2                	cmp    %eax,%edx
  802274:	73 65                	jae    8022db <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802276:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80227a:	75 14                	jne    802290 <insert_sorted_allocList+0x131>
  80227c:	83 ec 04             	sub    $0x4,%esp
  80227f:	68 70 3c 80 00       	push   $0x803c70
  802284:	6a 68                	push   $0x68
  802286:	68 93 3c 80 00       	push   $0x803c93
  80228b:	e8 41 e0 ff ff       	call   8002d1 <_panic>
  802290:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	89 10                	mov    %edx,(%eax)
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	8b 00                	mov    (%eax),%eax
  8022a0:	85 c0                	test   %eax,%eax
  8022a2:	74 0d                	je     8022b1 <insert_sorted_allocList+0x152>
  8022a4:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ac:	89 50 04             	mov    %edx,0x4(%eax)
  8022af:	eb 08                	jmp    8022b9 <insert_sorted_allocList+0x15a>
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bc:	a3 40 40 80 00       	mov    %eax,0x804040
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022cb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d0:	40                   	inc    %eax
  8022d1:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022d6:	e9 81 00 00 00       	jmp    80235c <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022db:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e3:	eb 51                	jmp    802336 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8022e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e8:	8b 50 08             	mov    0x8(%eax),%edx
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	8b 40 08             	mov    0x8(%eax),%eax
  8022f1:	39 c2                	cmp    %eax,%edx
  8022f3:	73 39                	jae    80232e <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8022f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f8:	8b 40 04             	mov    0x4(%eax),%eax
  8022fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8022fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802301:	8b 55 08             	mov    0x8(%ebp),%edx
  802304:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80230c:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802315:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231a:	8b 55 08             	mov    0x8(%ebp),%edx
  80231d:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802320:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802325:	40                   	inc    %eax
  802326:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  80232b:	90                   	nop
				}
			}
		 }

	}
}
  80232c:	eb 2e                	jmp    80235c <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80232e:	a1 48 40 80 00       	mov    0x804048,%eax
  802333:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802336:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233a:	74 07                	je     802343 <insert_sorted_allocList+0x1e4>
  80233c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233f:	8b 00                	mov    (%eax),%eax
  802341:	eb 05                	jmp    802348 <insert_sorted_allocList+0x1e9>
  802343:	b8 00 00 00 00       	mov    $0x0,%eax
  802348:	a3 48 40 80 00       	mov    %eax,0x804048
  80234d:	a1 48 40 80 00       	mov    0x804048,%eax
  802352:	85 c0                	test   %eax,%eax
  802354:	75 8f                	jne    8022e5 <insert_sorted_allocList+0x186>
  802356:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80235a:	75 89                	jne    8022e5 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80235c:	90                   	nop
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802365:	a1 38 41 80 00       	mov    0x804138,%eax
  80236a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236d:	e9 76 01 00 00       	jmp    8024e8 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 40 0c             	mov    0xc(%eax),%eax
  802378:	3b 45 08             	cmp    0x8(%ebp),%eax
  80237b:	0f 85 8a 00 00 00    	jne    80240b <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802385:	75 17                	jne    80239e <alloc_block_FF+0x3f>
  802387:	83 ec 04             	sub    $0x4,%esp
  80238a:	68 cf 3c 80 00       	push   $0x803ccf
  80238f:	68 8a 00 00 00       	push   $0x8a
  802394:	68 93 3c 80 00       	push   $0x803c93
  802399:	e8 33 df ff ff       	call   8002d1 <_panic>
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 00                	mov    (%eax),%eax
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	74 10                	je     8023b7 <alloc_block_FF+0x58>
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 00                	mov    (%eax),%eax
  8023ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023af:	8b 52 04             	mov    0x4(%edx),%edx
  8023b2:	89 50 04             	mov    %edx,0x4(%eax)
  8023b5:	eb 0b                	jmp    8023c2 <alloc_block_FF+0x63>
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 40 04             	mov    0x4(%eax),%eax
  8023bd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 40 04             	mov    0x4(%eax),%eax
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	74 0f                	je     8023db <alloc_block_FF+0x7c>
  8023cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cf:	8b 40 04             	mov    0x4(%eax),%eax
  8023d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d5:	8b 12                	mov    (%edx),%edx
  8023d7:	89 10                	mov    %edx,(%eax)
  8023d9:	eb 0a                	jmp    8023e5 <alloc_block_FF+0x86>
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	a3 38 41 80 00       	mov    %eax,0x804138
  8023e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f8:	a1 44 41 80 00       	mov    0x804144,%eax
  8023fd:	48                   	dec    %eax
  8023fe:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802406:	e9 10 01 00 00       	jmp    80251b <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 40 0c             	mov    0xc(%eax),%eax
  802411:	3b 45 08             	cmp    0x8(%ebp),%eax
  802414:	0f 86 c6 00 00 00    	jbe    8024e0 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80241a:	a1 48 41 80 00       	mov    0x804148,%eax
  80241f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802422:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802426:	75 17                	jne    80243f <alloc_block_FF+0xe0>
  802428:	83 ec 04             	sub    $0x4,%esp
  80242b:	68 cf 3c 80 00       	push   $0x803ccf
  802430:	68 90 00 00 00       	push   $0x90
  802435:	68 93 3c 80 00       	push   $0x803c93
  80243a:	e8 92 de ff ff       	call   8002d1 <_panic>
  80243f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 10                	je     802458 <alloc_block_FF+0xf9>
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244b:	8b 00                	mov    (%eax),%eax
  80244d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802450:	8b 52 04             	mov    0x4(%edx),%edx
  802453:	89 50 04             	mov    %edx,0x4(%eax)
  802456:	eb 0b                	jmp    802463 <alloc_block_FF+0x104>
  802458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245b:	8b 40 04             	mov    0x4(%eax),%eax
  80245e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	8b 40 04             	mov    0x4(%eax),%eax
  802469:	85 c0                	test   %eax,%eax
  80246b:	74 0f                	je     80247c <alloc_block_FF+0x11d>
  80246d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802470:	8b 40 04             	mov    0x4(%eax),%eax
  802473:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802476:	8b 12                	mov    (%edx),%edx
  802478:	89 10                	mov    %edx,(%eax)
  80247a:	eb 0a                	jmp    802486 <alloc_block_FF+0x127>
  80247c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	a3 48 41 80 00       	mov    %eax,0x804148
  802486:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802489:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802492:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802499:	a1 54 41 80 00       	mov    0x804154,%eax
  80249e:	48                   	dec    %eax
  80249f:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8024a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8024aa:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 50 08             	mov    0x8(%eax),%edx
  8024b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b6:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 50 08             	mov    0x8(%eax),%edx
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	01 c2                	add    %eax,%edx
  8024c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c7:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d0:	2b 45 08             	sub    0x8(%ebp),%eax
  8024d3:	89 c2                	mov    %eax,%edx
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8024db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024de:	eb 3b                	jmp    80251b <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8024e0:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ec:	74 07                	je     8024f5 <alloc_block_FF+0x196>
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 00                	mov    (%eax),%eax
  8024f3:	eb 05                	jmp    8024fa <alloc_block_FF+0x19b>
  8024f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8024fa:	a3 40 41 80 00       	mov    %eax,0x804140
  8024ff:	a1 40 41 80 00       	mov    0x804140,%eax
  802504:	85 c0                	test   %eax,%eax
  802506:	0f 85 66 fe ff ff    	jne    802372 <alloc_block_FF+0x13>
  80250c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802510:	0f 85 5c fe ff ff    	jne    802372 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802516:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80251b:	c9                   	leave  
  80251c:	c3                   	ret    

0080251d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80251d:	55                   	push   %ebp
  80251e:	89 e5                	mov    %esp,%ebp
  802520:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802523:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80252a:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802531:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802538:	a1 38 41 80 00       	mov    0x804138,%eax
  80253d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802540:	e9 cf 00 00 00       	jmp    802614 <alloc_block_BF+0xf7>
		{
			c++;
  802545:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 0c             	mov    0xc(%eax),%eax
  80254e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802551:	0f 85 8a 00 00 00    	jne    8025e1 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	75 17                	jne    802574 <alloc_block_BF+0x57>
  80255d:	83 ec 04             	sub    $0x4,%esp
  802560:	68 cf 3c 80 00       	push   $0x803ccf
  802565:	68 a8 00 00 00       	push   $0xa8
  80256a:	68 93 3c 80 00       	push   $0x803c93
  80256f:	e8 5d dd ff ff       	call   8002d1 <_panic>
  802574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802577:	8b 00                	mov    (%eax),%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	74 10                	je     80258d <alloc_block_BF+0x70>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 00                	mov    (%eax),%eax
  802582:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802585:	8b 52 04             	mov    0x4(%edx),%edx
  802588:	89 50 04             	mov    %edx,0x4(%eax)
  80258b:	eb 0b                	jmp    802598 <alloc_block_BF+0x7b>
  80258d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802590:	8b 40 04             	mov    0x4(%eax),%eax
  802593:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	8b 40 04             	mov    0x4(%eax),%eax
  80259e:	85 c0                	test   %eax,%eax
  8025a0:	74 0f                	je     8025b1 <alloc_block_BF+0x94>
  8025a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a5:	8b 40 04             	mov    0x4(%eax),%eax
  8025a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ab:	8b 12                	mov    (%edx),%edx
  8025ad:	89 10                	mov    %edx,(%eax)
  8025af:	eb 0a                	jmp    8025bb <alloc_block_BF+0x9e>
  8025b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b4:	8b 00                	mov    (%eax),%eax
  8025b6:	a3 38 41 80 00       	mov    %eax,0x804138
  8025bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ce:	a1 44 41 80 00       	mov    0x804144,%eax
  8025d3:	48                   	dec    %eax
  8025d4:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	e9 85 01 00 00       	jmp    802766 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ea:	76 20                	jbe    80260c <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f2:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f5:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8025f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025fe:	73 0c                	jae    80260c <alloc_block_BF+0xef>
				{
					ma=tempi;
  802600:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802603:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802606:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802609:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80260c:	a1 40 41 80 00       	mov    0x804140,%eax
  802611:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802614:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802618:	74 07                	je     802621 <alloc_block_BF+0x104>
  80261a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	eb 05                	jmp    802626 <alloc_block_BF+0x109>
  802621:	b8 00 00 00 00       	mov    $0x0,%eax
  802626:	a3 40 41 80 00       	mov    %eax,0x804140
  80262b:	a1 40 41 80 00       	mov    0x804140,%eax
  802630:	85 c0                	test   %eax,%eax
  802632:	0f 85 0d ff ff ff    	jne    802545 <alloc_block_BF+0x28>
  802638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263c:	0f 85 03 ff ff ff    	jne    802545 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802642:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802649:	a1 38 41 80 00       	mov    0x804138,%eax
  80264e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802651:	e9 dd 00 00 00       	jmp    802733 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802656:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802659:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80265c:	0f 85 c6 00 00 00    	jne    802728 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802662:	a1 48 41 80 00       	mov    0x804148,%eax
  802667:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80266a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80266e:	75 17                	jne    802687 <alloc_block_BF+0x16a>
  802670:	83 ec 04             	sub    $0x4,%esp
  802673:	68 cf 3c 80 00       	push   $0x803ccf
  802678:	68 bb 00 00 00       	push   $0xbb
  80267d:	68 93 3c 80 00       	push   $0x803c93
  802682:	e8 4a dc ff ff       	call   8002d1 <_panic>
  802687:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268a:	8b 00                	mov    (%eax),%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	74 10                	je     8026a0 <alloc_block_BF+0x183>
  802690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802693:	8b 00                	mov    (%eax),%eax
  802695:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802698:	8b 52 04             	mov    0x4(%edx),%edx
  80269b:	89 50 04             	mov    %edx,0x4(%eax)
  80269e:	eb 0b                	jmp    8026ab <alloc_block_BF+0x18e>
  8026a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a3:	8b 40 04             	mov    0x4(%eax),%eax
  8026a6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ae:	8b 40 04             	mov    0x4(%eax),%eax
  8026b1:	85 c0                	test   %eax,%eax
  8026b3:	74 0f                	je     8026c4 <alloc_block_BF+0x1a7>
  8026b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b8:	8b 40 04             	mov    0x4(%eax),%eax
  8026bb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026be:	8b 12                	mov    (%edx),%edx
  8026c0:	89 10                	mov    %edx,(%eax)
  8026c2:	eb 0a                	jmp    8026ce <alloc_block_BF+0x1b1>
  8026c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c7:	8b 00                	mov    (%eax),%eax
  8026c9:	a3 48 41 80 00       	mov    %eax,0x804148
  8026ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e1:	a1 54 41 80 00       	mov    0x804154,%eax
  8026e6:	48                   	dec    %eax
  8026e7:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8026ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f2:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 50 08             	mov    0x8(%eax),%edx
  8026fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fe:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	8b 50 08             	mov    0x8(%eax),%edx
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	01 c2                	add    %eax,%edx
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	8b 40 0c             	mov    0xc(%eax),%eax
  802718:	2b 45 08             	sub    0x8(%ebp),%eax
  80271b:	89 c2                	mov    %eax,%edx
  80271d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802720:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802723:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802726:	eb 3e                	jmp    802766 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802728:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80272b:	a1 40 41 80 00       	mov    0x804140,%eax
  802730:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802733:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802737:	74 07                	je     802740 <alloc_block_BF+0x223>
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	eb 05                	jmp    802745 <alloc_block_BF+0x228>
  802740:	b8 00 00 00 00       	mov    $0x0,%eax
  802745:	a3 40 41 80 00       	mov    %eax,0x804140
  80274a:	a1 40 41 80 00       	mov    0x804140,%eax
  80274f:	85 c0                	test   %eax,%eax
  802751:	0f 85 ff fe ff ff    	jne    802656 <alloc_block_BF+0x139>
  802757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80275b:	0f 85 f5 fe ff ff    	jne    802656 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802761:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802766:	c9                   	leave  
  802767:	c3                   	ret    

00802768 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802768:	55                   	push   %ebp
  802769:	89 e5                	mov    %esp,%ebp
  80276b:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80276e:	a1 28 40 80 00       	mov    0x804028,%eax
  802773:	85 c0                	test   %eax,%eax
  802775:	75 14                	jne    80278b <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802777:	a1 38 41 80 00       	mov    0x804138,%eax
  80277c:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802781:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802788:	00 00 00 
	}
	uint32 c=1;
  80278b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802792:	a1 60 41 80 00       	mov    0x804160,%eax
  802797:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80279a:	e9 b3 01 00 00       	jmp    802952 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80279f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a5:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a8:	0f 85 a9 00 00 00    	jne    802857 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8027ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b1:	8b 00                	mov    (%eax),%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	75 0c                	jne    8027c3 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8027b7:	a1 38 41 80 00       	mov    0x804138,%eax
  8027bc:	a3 60 41 80 00       	mov    %eax,0x804160
  8027c1:	eb 0a                	jmp    8027cd <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8027c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c6:	8b 00                	mov    (%eax),%eax
  8027c8:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8027cd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027d1:	75 17                	jne    8027ea <alloc_block_NF+0x82>
  8027d3:	83 ec 04             	sub    $0x4,%esp
  8027d6:	68 cf 3c 80 00       	push   $0x803ccf
  8027db:	68 e3 00 00 00       	push   $0xe3
  8027e0:	68 93 3c 80 00       	push   $0x803c93
  8027e5:	e8 e7 da ff ff       	call   8002d1 <_panic>
  8027ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	74 10                	je     802803 <alloc_block_NF+0x9b>
  8027f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027fb:	8b 52 04             	mov    0x4(%edx),%edx
  8027fe:	89 50 04             	mov    %edx,0x4(%eax)
  802801:	eb 0b                	jmp    80280e <alloc_block_NF+0xa6>
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	8b 40 04             	mov    0x4(%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 0f                	je     802827 <alloc_block_NF+0xbf>
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	8b 40 04             	mov    0x4(%eax),%eax
  80281e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802821:	8b 12                	mov    (%edx),%edx
  802823:	89 10                	mov    %edx,(%eax)
  802825:	eb 0a                	jmp    802831 <alloc_block_NF+0xc9>
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	a3 38 41 80 00       	mov    %eax,0x804138
  802831:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802834:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802844:	a1 44 41 80 00       	mov    0x804144,%eax
  802849:	48                   	dec    %eax
  80284a:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  80284f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802852:	e9 0e 01 00 00       	jmp    802965 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802860:	0f 86 ce 00 00 00    	jbe    802934 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802866:	a1 48 41 80 00       	mov    0x804148,%eax
  80286b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80286e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802872:	75 17                	jne    80288b <alloc_block_NF+0x123>
  802874:	83 ec 04             	sub    $0x4,%esp
  802877:	68 cf 3c 80 00       	push   $0x803ccf
  80287c:	68 e9 00 00 00       	push   $0xe9
  802881:	68 93 3c 80 00       	push   $0x803c93
  802886:	e8 46 da ff ff       	call   8002d1 <_panic>
  80288b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288e:	8b 00                	mov    (%eax),%eax
  802890:	85 c0                	test   %eax,%eax
  802892:	74 10                	je     8028a4 <alloc_block_NF+0x13c>
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	8b 00                	mov    (%eax),%eax
  802899:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80289c:	8b 52 04             	mov    0x4(%edx),%edx
  80289f:	89 50 04             	mov    %edx,0x4(%eax)
  8028a2:	eb 0b                	jmp    8028af <alloc_block_NF+0x147>
  8028a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a7:	8b 40 04             	mov    0x4(%eax),%eax
  8028aa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b2:	8b 40 04             	mov    0x4(%eax),%eax
  8028b5:	85 c0                	test   %eax,%eax
  8028b7:	74 0f                	je     8028c8 <alloc_block_NF+0x160>
  8028b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bc:	8b 40 04             	mov    0x4(%eax),%eax
  8028bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028c2:	8b 12                	mov    (%edx),%edx
  8028c4:	89 10                	mov    %edx,(%eax)
  8028c6:	eb 0a                	jmp    8028d2 <alloc_block_NF+0x16a>
  8028c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cb:	8b 00                	mov    (%eax),%eax
  8028cd:	a3 48 41 80 00       	mov    %eax,0x804148
  8028d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e5:	a1 54 41 80 00       	mov    0x804154,%eax
  8028ea:	48                   	dec    %eax
  8028eb:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8028f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f6:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8028f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fc:	8b 50 08             	mov    0x8(%eax),%edx
  8028ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802902:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802905:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802908:	8b 50 08             	mov    0x8(%eax),%edx
  80290b:	8b 45 08             	mov    0x8(%ebp),%eax
  80290e:	01 c2                	add    %eax,%edx
  802910:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802913:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802919:	8b 40 0c             	mov    0xc(%eax),%eax
  80291c:	2b 45 08             	sub    0x8(%ebp),%eax
  80291f:	89 c2                	mov    %eax,%edx
  802921:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802924:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292a:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  80292f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802932:	eb 31                	jmp    802965 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802934:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802937:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	85 c0                	test   %eax,%eax
  80293e:	75 0a                	jne    80294a <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802940:	a1 38 41 80 00       	mov    0x804138,%eax
  802945:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802948:	eb 08                	jmp    802952 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80294a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802952:	a1 44 41 80 00       	mov    0x804144,%eax
  802957:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80295a:	0f 85 3f fe ff ff    	jne    80279f <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802960:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802965:	c9                   	leave  
  802966:	c3                   	ret    

00802967 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802967:	55                   	push   %ebp
  802968:	89 e5                	mov    %esp,%ebp
  80296a:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80296d:	a1 44 41 80 00       	mov    0x804144,%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	75 68                	jne    8029de <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802976:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80297a:	75 17                	jne    802993 <insert_sorted_with_merge_freeList+0x2c>
  80297c:	83 ec 04             	sub    $0x4,%esp
  80297f:	68 70 3c 80 00       	push   $0x803c70
  802984:	68 0e 01 00 00       	push   $0x10e
  802989:	68 93 3c 80 00       	push   $0x803c93
  80298e:	e8 3e d9 ff ff       	call   8002d1 <_panic>
  802993:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	89 10                	mov    %edx,(%eax)
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	8b 00                	mov    (%eax),%eax
  8029a3:	85 c0                	test   %eax,%eax
  8029a5:	74 0d                	je     8029b4 <insert_sorted_with_merge_freeList+0x4d>
  8029a7:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8029af:	89 50 04             	mov    %edx,0x4(%eax)
  8029b2:	eb 08                	jmp    8029bc <insert_sorted_with_merge_freeList+0x55>
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	a3 38 41 80 00       	mov    %eax,0x804138
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ce:	a1 44 41 80 00       	mov    0x804144,%eax
  8029d3:	40                   	inc    %eax
  8029d4:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8029d9:	e9 8c 06 00 00       	jmp    80306a <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8029de:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8029e6:	a1 38 41 80 00       	mov    0x804138,%eax
  8029eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	8b 50 08             	mov    0x8(%eax),%edx
  8029f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f7:	8b 40 08             	mov    0x8(%eax),%eax
  8029fa:	39 c2                	cmp    %eax,%edx
  8029fc:	0f 86 14 01 00 00    	jbe    802b16 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	8b 50 0c             	mov    0xc(%eax),%edx
  802a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0b:	8b 40 08             	mov    0x8(%eax),%eax
  802a0e:	01 c2                	add    %eax,%edx
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	8b 40 08             	mov    0x8(%eax),%eax
  802a16:	39 c2                	cmp    %eax,%edx
  802a18:	0f 85 90 00 00 00    	jne    802aae <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a21:	8b 50 0c             	mov    0xc(%eax),%edx
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2a:	01 c2                	add    %eax,%edx
  802a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2f:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a4a:	75 17                	jne    802a63 <insert_sorted_with_merge_freeList+0xfc>
  802a4c:	83 ec 04             	sub    $0x4,%esp
  802a4f:	68 70 3c 80 00       	push   $0x803c70
  802a54:	68 1b 01 00 00       	push   $0x11b
  802a59:	68 93 3c 80 00       	push   $0x803c93
  802a5e:	e8 6e d8 ff ff       	call   8002d1 <_panic>
  802a63:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	89 10                	mov    %edx,(%eax)
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	8b 00                	mov    (%eax),%eax
  802a73:	85 c0                	test   %eax,%eax
  802a75:	74 0d                	je     802a84 <insert_sorted_with_merge_freeList+0x11d>
  802a77:	a1 48 41 80 00       	mov    0x804148,%eax
  802a7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7f:	89 50 04             	mov    %edx,0x4(%eax)
  802a82:	eb 08                	jmp    802a8c <insert_sorted_with_merge_freeList+0x125>
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	a3 48 41 80 00       	mov    %eax,0x804148
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9e:	a1 54 41 80 00       	mov    0x804154,%eax
  802aa3:	40                   	inc    %eax
  802aa4:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802aa9:	e9 bc 05 00 00       	jmp    80306a <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802aae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab2:	75 17                	jne    802acb <insert_sorted_with_merge_freeList+0x164>
  802ab4:	83 ec 04             	sub    $0x4,%esp
  802ab7:	68 ac 3c 80 00       	push   $0x803cac
  802abc:	68 1f 01 00 00       	push   $0x11f
  802ac1:	68 93 3c 80 00       	push   $0x803c93
  802ac6:	e8 06 d8 ff ff       	call   8002d1 <_panic>
  802acb:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad4:	89 50 04             	mov    %edx,0x4(%eax)
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	8b 40 04             	mov    0x4(%eax),%eax
  802add:	85 c0                	test   %eax,%eax
  802adf:	74 0c                	je     802aed <insert_sorted_with_merge_freeList+0x186>
  802ae1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae9:	89 10                	mov    %edx,(%eax)
  802aeb:	eb 08                	jmp    802af5 <insert_sorted_with_merge_freeList+0x18e>
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	a3 38 41 80 00       	mov    %eax,0x804138
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802afd:	8b 45 08             	mov    0x8(%ebp),%eax
  802b00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b06:	a1 44 41 80 00       	mov    0x804144,%eax
  802b0b:	40                   	inc    %eax
  802b0c:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802b11:	e9 54 05 00 00       	jmp    80306a <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	8b 50 08             	mov    0x8(%eax),%edx
  802b1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1f:	8b 40 08             	mov    0x8(%eax),%eax
  802b22:	39 c2                	cmp    %eax,%edx
  802b24:	0f 83 20 01 00 00    	jae    802c4a <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2d:	8b 50 0c             	mov    0xc(%eax),%edx
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	8b 40 08             	mov    0x8(%eax),%eax
  802b36:	01 c2                	add    %eax,%edx
  802b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3b:	8b 40 08             	mov    0x8(%eax),%eax
  802b3e:	39 c2                	cmp    %eax,%edx
  802b40:	0f 85 9c 00 00 00    	jne    802be2 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	8b 50 08             	mov    0x8(%eax),%edx
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b55:	8b 50 0c             	mov    0xc(%eax),%edx
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5e:	01 c2                	add    %eax,%edx
  802b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b63:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7e:	75 17                	jne    802b97 <insert_sorted_with_merge_freeList+0x230>
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	68 70 3c 80 00       	push   $0x803c70
  802b88:	68 2a 01 00 00       	push   $0x12a
  802b8d:	68 93 3c 80 00       	push   $0x803c93
  802b92:	e8 3a d7 ff ff       	call   8002d1 <_panic>
  802b97:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	89 10                	mov    %edx,(%eax)
  802ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	85 c0                	test   %eax,%eax
  802ba9:	74 0d                	je     802bb8 <insert_sorted_with_merge_freeList+0x251>
  802bab:	a1 48 41 80 00       	mov    0x804148,%eax
  802bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb3:	89 50 04             	mov    %edx,0x4(%eax)
  802bb6:	eb 08                	jmp    802bc0 <insert_sorted_with_merge_freeList+0x259>
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	a3 48 41 80 00       	mov    %eax,0x804148
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bd2:	a1 54 41 80 00       	mov    0x804154,%eax
  802bd7:	40                   	inc    %eax
  802bd8:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802bdd:	e9 88 04 00 00       	jmp    80306a <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802be2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be6:	75 17                	jne    802bff <insert_sorted_with_merge_freeList+0x298>
  802be8:	83 ec 04             	sub    $0x4,%esp
  802beb:	68 70 3c 80 00       	push   $0x803c70
  802bf0:	68 2e 01 00 00       	push   $0x12e
  802bf5:	68 93 3c 80 00       	push   $0x803c93
  802bfa:	e8 d2 d6 ff ff       	call   8002d1 <_panic>
  802bff:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	89 10                	mov    %edx,(%eax)
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	8b 00                	mov    (%eax),%eax
  802c0f:	85 c0                	test   %eax,%eax
  802c11:	74 0d                	je     802c20 <insert_sorted_with_merge_freeList+0x2b9>
  802c13:	a1 38 41 80 00       	mov    0x804138,%eax
  802c18:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1b:	89 50 04             	mov    %edx,0x4(%eax)
  802c1e:	eb 08                	jmp    802c28 <insert_sorted_with_merge_freeList+0x2c1>
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	a3 38 41 80 00       	mov    %eax,0x804138
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3a:	a1 44 41 80 00       	mov    0x804144,%eax
  802c3f:	40                   	inc    %eax
  802c40:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c45:	e9 20 04 00 00       	jmp    80306a <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802c4a:	a1 38 41 80 00       	mov    0x804138,%eax
  802c4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c52:	e9 e2 03 00 00       	jmp    803039 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c57:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5a:	8b 50 08             	mov    0x8(%eax),%edx
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 08             	mov    0x8(%eax),%eax
  802c63:	39 c2                	cmp    %eax,%edx
  802c65:	0f 83 c6 03 00 00    	jae    803031 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 04             	mov    0x4(%eax),%eax
  802c71:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c77:	8b 50 08             	mov    0x8(%eax),%edx
  802c7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c80:	01 d0                	add    %edx,%eax
  802c82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	8b 50 0c             	mov    0xc(%eax),%edx
  802c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8e:	8b 40 08             	mov    0x8(%eax),%eax
  802c91:	01 d0                	add    %edx,%eax
  802c93:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	8b 40 08             	mov    0x8(%eax),%eax
  802c9c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c9f:	74 7a                	je     802d1b <insert_sorted_with_merge_freeList+0x3b4>
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 40 08             	mov    0x8(%eax),%eax
  802ca7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802caa:	74 6f                	je     802d1b <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802cac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb0:	74 06                	je     802cb8 <insert_sorted_with_merge_freeList+0x351>
  802cb2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb6:	75 17                	jne    802ccf <insert_sorted_with_merge_freeList+0x368>
  802cb8:	83 ec 04             	sub    $0x4,%esp
  802cbb:	68 f0 3c 80 00       	push   $0x803cf0
  802cc0:	68 43 01 00 00       	push   $0x143
  802cc5:	68 93 3c 80 00       	push   $0x803c93
  802cca:	e8 02 d6 ff ff       	call   8002d1 <_panic>
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 50 04             	mov    0x4(%eax),%edx
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	89 50 04             	mov    %edx,0x4(%eax)
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ce1:	89 10                	mov    %edx,(%eax)
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	74 0d                	je     802cfa <insert_sorted_with_merge_freeList+0x393>
  802ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf0:	8b 40 04             	mov    0x4(%eax),%eax
  802cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf6:	89 10                	mov    %edx,(%eax)
  802cf8:	eb 08                	jmp    802d02 <insert_sorted_with_merge_freeList+0x39b>
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	a3 38 41 80 00       	mov    %eax,0x804138
  802d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d05:	8b 55 08             	mov    0x8(%ebp),%edx
  802d08:	89 50 04             	mov    %edx,0x4(%eax)
  802d0b:	a1 44 41 80 00       	mov    0x804144,%eax
  802d10:	40                   	inc    %eax
  802d11:	a3 44 41 80 00       	mov    %eax,0x804144
  802d16:	e9 14 03 00 00       	jmp    80302f <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	8b 40 08             	mov    0x8(%eax),%eax
  802d21:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d24:	0f 85 a0 01 00 00    	jne    802eca <insert_sorted_with_merge_freeList+0x563>
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 40 08             	mov    0x8(%eax),%eax
  802d30:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d33:	0f 85 91 01 00 00    	jne    802eca <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d48:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4b:	01 c8                	add    %ecx,%eax
  802d4d:	01 c2                	add    %eax,%edx
  802d4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d52:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d76:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d81:	75 17                	jne    802d9a <insert_sorted_with_merge_freeList+0x433>
  802d83:	83 ec 04             	sub    $0x4,%esp
  802d86:	68 70 3c 80 00       	push   $0x803c70
  802d8b:	68 4d 01 00 00       	push   $0x14d
  802d90:	68 93 3c 80 00       	push   $0x803c93
  802d95:	e8 37 d5 ff ff       	call   8002d1 <_panic>
  802d9a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	89 10                	mov    %edx,(%eax)
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	85 c0                	test   %eax,%eax
  802dac:	74 0d                	je     802dbb <insert_sorted_with_merge_freeList+0x454>
  802dae:	a1 48 41 80 00       	mov    0x804148,%eax
  802db3:	8b 55 08             	mov    0x8(%ebp),%edx
  802db6:	89 50 04             	mov    %edx,0x4(%eax)
  802db9:	eb 08                	jmp    802dc3 <insert_sorted_with_merge_freeList+0x45c>
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	a3 48 41 80 00       	mov    %eax,0x804148
  802dcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd5:	a1 54 41 80 00       	mov    0x804154,%eax
  802dda:	40                   	inc    %eax
  802ddb:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802de0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de4:	75 17                	jne    802dfd <insert_sorted_with_merge_freeList+0x496>
  802de6:	83 ec 04             	sub    $0x4,%esp
  802de9:	68 cf 3c 80 00       	push   $0x803ccf
  802dee:	68 4e 01 00 00       	push   $0x14e
  802df3:	68 93 3c 80 00       	push   $0x803c93
  802df8:	e8 d4 d4 ff ff       	call   8002d1 <_panic>
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 00                	mov    (%eax),%eax
  802e02:	85 c0                	test   %eax,%eax
  802e04:	74 10                	je     802e16 <insert_sorted_with_merge_freeList+0x4af>
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 00                	mov    (%eax),%eax
  802e0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0e:	8b 52 04             	mov    0x4(%edx),%edx
  802e11:	89 50 04             	mov    %edx,0x4(%eax)
  802e14:	eb 0b                	jmp    802e21 <insert_sorted_with_merge_freeList+0x4ba>
  802e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e19:	8b 40 04             	mov    0x4(%eax),%eax
  802e1c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e24:	8b 40 04             	mov    0x4(%eax),%eax
  802e27:	85 c0                	test   %eax,%eax
  802e29:	74 0f                	je     802e3a <insert_sorted_with_merge_freeList+0x4d3>
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	8b 40 04             	mov    0x4(%eax),%eax
  802e31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e34:	8b 12                	mov    (%edx),%edx
  802e36:	89 10                	mov    %edx,(%eax)
  802e38:	eb 0a                	jmp    802e44 <insert_sorted_with_merge_freeList+0x4dd>
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	8b 00                	mov    (%eax),%eax
  802e3f:	a3 38 41 80 00       	mov    %eax,0x804138
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e50:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e57:	a1 44 41 80 00       	mov    0x804144,%eax
  802e5c:	48                   	dec    %eax
  802e5d:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e62:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e66:	75 17                	jne    802e7f <insert_sorted_with_merge_freeList+0x518>
  802e68:	83 ec 04             	sub    $0x4,%esp
  802e6b:	68 70 3c 80 00       	push   $0x803c70
  802e70:	68 4f 01 00 00       	push   $0x14f
  802e75:	68 93 3c 80 00       	push   $0x803c93
  802e7a:	e8 52 d4 ff ff       	call   8002d1 <_panic>
  802e7f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	89 10                	mov    %edx,(%eax)
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 00                	mov    (%eax),%eax
  802e8f:	85 c0                	test   %eax,%eax
  802e91:	74 0d                	je     802ea0 <insert_sorted_with_merge_freeList+0x539>
  802e93:	a1 48 41 80 00       	mov    0x804148,%eax
  802e98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9b:	89 50 04             	mov    %edx,0x4(%eax)
  802e9e:	eb 08                	jmp    802ea8 <insert_sorted_with_merge_freeList+0x541>
  802ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	a3 48 41 80 00       	mov    %eax,0x804148
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eba:	a1 54 41 80 00       	mov    0x804154,%eax
  802ebf:	40                   	inc    %eax
  802ec0:	a3 54 41 80 00       	mov    %eax,0x804154
  802ec5:	e9 65 01 00 00       	jmp    80302f <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	8b 40 08             	mov    0x8(%eax),%eax
  802ed0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ed3:	0f 85 9f 00 00 00    	jne    802f78 <insert_sorted_with_merge_freeList+0x611>
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	8b 40 08             	mov    0x8(%eax),%eax
  802edf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ee2:	0f 84 90 00 00 00    	je     802f78 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eeb:	8b 50 0c             	mov    0xc(%eax),%edx
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef4:	01 c2                	add    %eax,%edx
  802ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef9:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f14:	75 17                	jne    802f2d <insert_sorted_with_merge_freeList+0x5c6>
  802f16:	83 ec 04             	sub    $0x4,%esp
  802f19:	68 70 3c 80 00       	push   $0x803c70
  802f1e:	68 58 01 00 00       	push   $0x158
  802f23:	68 93 3c 80 00       	push   $0x803c93
  802f28:	e8 a4 d3 ff ff       	call   8002d1 <_panic>
  802f2d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	89 10                	mov    %edx,(%eax)
  802f38:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	74 0d                	je     802f4e <insert_sorted_with_merge_freeList+0x5e7>
  802f41:	a1 48 41 80 00       	mov    0x804148,%eax
  802f46:	8b 55 08             	mov    0x8(%ebp),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	eb 08                	jmp    802f56 <insert_sorted_with_merge_freeList+0x5ef>
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	a3 48 41 80 00       	mov    %eax,0x804148
  802f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f68:	a1 54 41 80 00       	mov    0x804154,%eax
  802f6d:	40                   	inc    %eax
  802f6e:	a3 54 41 80 00       	mov    %eax,0x804154
  802f73:	e9 b7 00 00 00       	jmp    80302f <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f78:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7b:	8b 40 08             	mov    0x8(%eax),%eax
  802f7e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f81:	0f 84 e2 00 00 00    	je     803069 <insert_sorted_with_merge_freeList+0x702>
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 40 08             	mov    0x8(%eax),%eax
  802f8d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f90:	0f 85 d3 00 00 00    	jne    803069 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	8b 50 08             	mov    0x8(%eax),%edx
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802fa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa5:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	8b 40 0c             	mov    0xc(%eax),%eax
  802fae:	01 c2                	add    %eax,%edx
  802fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb3:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fce:	75 17                	jne    802fe7 <insert_sorted_with_merge_freeList+0x680>
  802fd0:	83 ec 04             	sub    $0x4,%esp
  802fd3:	68 70 3c 80 00       	push   $0x803c70
  802fd8:	68 61 01 00 00       	push   $0x161
  802fdd:	68 93 3c 80 00       	push   $0x803c93
  802fe2:	e8 ea d2 ff ff       	call   8002d1 <_panic>
  802fe7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	89 10                	mov    %edx,(%eax)
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	8b 00                	mov    (%eax),%eax
  802ff7:	85 c0                	test   %eax,%eax
  802ff9:	74 0d                	je     803008 <insert_sorted_with_merge_freeList+0x6a1>
  802ffb:	a1 48 41 80 00       	mov    0x804148,%eax
  803000:	8b 55 08             	mov    0x8(%ebp),%edx
  803003:	89 50 04             	mov    %edx,0x4(%eax)
  803006:	eb 08                	jmp    803010 <insert_sorted_with_merge_freeList+0x6a9>
  803008:	8b 45 08             	mov    0x8(%ebp),%eax
  80300b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803010:	8b 45 08             	mov    0x8(%ebp),%eax
  803013:	a3 48 41 80 00       	mov    %eax,0x804148
  803018:	8b 45 08             	mov    0x8(%ebp),%eax
  80301b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803022:	a1 54 41 80 00       	mov    0x804154,%eax
  803027:	40                   	inc    %eax
  803028:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  80302d:	eb 3a                	jmp    803069 <insert_sorted_with_merge_freeList+0x702>
  80302f:	eb 38                	jmp    803069 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803031:	a1 40 41 80 00       	mov    0x804140,%eax
  803036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803039:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303d:	74 07                	je     803046 <insert_sorted_with_merge_freeList+0x6df>
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	8b 00                	mov    (%eax),%eax
  803044:	eb 05                	jmp    80304b <insert_sorted_with_merge_freeList+0x6e4>
  803046:	b8 00 00 00 00       	mov    $0x0,%eax
  80304b:	a3 40 41 80 00       	mov    %eax,0x804140
  803050:	a1 40 41 80 00       	mov    0x804140,%eax
  803055:	85 c0                	test   %eax,%eax
  803057:	0f 85 fa fb ff ff    	jne    802c57 <insert_sorted_with_merge_freeList+0x2f0>
  80305d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803061:	0f 85 f0 fb ff ff    	jne    802c57 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803067:	eb 01                	jmp    80306a <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803069:	90                   	nop
							}

						}
		          }
		}
}
  80306a:	90                   	nop
  80306b:	c9                   	leave  
  80306c:	c3                   	ret    

0080306d <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80306d:	55                   	push   %ebp
  80306e:	89 e5                	mov    %esp,%ebp
  803070:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803073:	8b 55 08             	mov    0x8(%ebp),%edx
  803076:	89 d0                	mov    %edx,%eax
  803078:	c1 e0 02             	shl    $0x2,%eax
  80307b:	01 d0                	add    %edx,%eax
  80307d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803084:	01 d0                	add    %edx,%eax
  803086:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80308d:	01 d0                	add    %edx,%eax
  80308f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803096:	01 d0                	add    %edx,%eax
  803098:	c1 e0 04             	shl    $0x4,%eax
  80309b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80309e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030a5:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030a8:	83 ec 0c             	sub    $0xc,%esp
  8030ab:	50                   	push   %eax
  8030ac:	e8 9c eb ff ff       	call   801c4d <sys_get_virtual_time>
  8030b1:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030b4:	eb 41                	jmp    8030f7 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030b6:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030b9:	83 ec 0c             	sub    $0xc,%esp
  8030bc:	50                   	push   %eax
  8030bd:	e8 8b eb ff ff       	call   801c4d <sys_get_virtual_time>
  8030c2:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cb:	29 c2                	sub    %eax,%edx
  8030cd:	89 d0                	mov    %edx,%eax
  8030cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d8:	89 d1                	mov    %edx,%ecx
  8030da:	29 c1                	sub    %eax,%ecx
  8030dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e2:	39 c2                	cmp    %eax,%edx
  8030e4:	0f 97 c0             	seta   %al
  8030e7:	0f b6 c0             	movzbl %al,%eax
  8030ea:	29 c1                	sub    %eax,%ecx
  8030ec:	89 c8                	mov    %ecx,%eax
  8030ee:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030fd:	72 b7                	jb     8030b6 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030ff:	90                   	nop
  803100:	c9                   	leave  
  803101:	c3                   	ret    

00803102 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803102:	55                   	push   %ebp
  803103:	89 e5                	mov    %esp,%ebp
  803105:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80310f:	eb 03                	jmp    803114 <busy_wait+0x12>
  803111:	ff 45 fc             	incl   -0x4(%ebp)
  803114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803117:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311a:	72 f5                	jb     803111 <busy_wait+0xf>
	return i;
  80311c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80311f:	c9                   	leave  
  803120:	c3                   	ret    
  803121:	66 90                	xchg   %ax,%ax
  803123:	90                   	nop

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

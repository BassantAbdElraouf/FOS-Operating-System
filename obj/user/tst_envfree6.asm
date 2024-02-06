
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 5c 01 00 00       	call   800192 <libmain>
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
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 33 80 00       	push   $0x8033a0
  80004a:	e8 b6 15 00 00       	call   801605 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 bb 18 00 00       	call   80191e <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 53 19 00 00       	call   8019be <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 33 80 00       	push   $0x8033b0
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 e3 33 80 00       	push   $0x8033e3
  800099:	e8 f2 1a 00 00       	call   801b90 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 ec 33 80 00       	push   $0x8033ec
  8000b9:	e8 d2 1a 00 00       	call   801b90 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 df 1a 00 00       	call   801bae <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 8b 2f 00 00       	call   80306a <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 c1 1a 00 00       	call   801bae <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 1e 18 00 00       	call   80191e <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 f8 33 80 00       	push   $0x8033f8
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 ae 1a 00 00       	call   801bca <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 a0 1a 00 00       	call   801bca <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 ec 17 00 00       	call   80191e <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 84 18 00 00       	call   8019be <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 2c 34 80 00       	push   $0x80342c
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 7c 34 80 00       	push   $0x80347c
  800160:	6a 23                	push   $0x23
  800162:	68 b2 34 80 00       	push   $0x8034b2
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 c8 34 80 00       	push   $0x8034c8
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 28 35 80 00       	push   $0x803528
  800187:	e8 f6 03 00 00       	call   800582 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	return;
  80018f:	90                   	nop
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800198:	e8 61 1a 00 00       	call   801bfe <sys_getenvindex>
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a3:	89 d0                	mov    %edx,%eax
  8001a5:	c1 e0 03             	shl    $0x3,%eax
  8001a8:	01 d0                	add    %edx,%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	c1 e0 04             	shl    $0x4,%eax
  8001ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bf:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c9:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001cf:	84 c0                	test   %al,%al
  8001d1:	74 0f                	je     8001e2 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d8:	05 5c 05 00 00       	add    $0x55c,%eax
  8001dd:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e6:	7e 0a                	jle    8001f2 <libmain+0x60>
		binaryname = argv[0];
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	8b 00                	mov    (%eax),%eax
  8001ed:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 38 fe ff ff       	call   800038 <_main>
  800200:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800203:	e8 03 18 00 00       	call   801a0b <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 8c 35 80 00       	push   $0x80358c
  800210:	e8 6d 03 00 00       	call   800582 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800223:	a1 20 40 80 00       	mov    0x804020,%eax
  800228:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 b4 35 80 00       	push   $0x8035b4
  800238:	e8 45 03 00 00       	call   800582 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800240:	a1 20 40 80 00       	mov    0x804020,%eax
  800245:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800256:	a1 20 40 80 00       	mov    0x804020,%eax
  80025b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800261:	51                   	push   %ecx
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 dc 35 80 00       	push   $0x8035dc
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 34 36 80 00       	push   $0x803634
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 8c 35 80 00       	push   $0x80358c
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 83 17 00 00       	call   801a25 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a2:	e8 19 00 00 00       	call   8002c0 <exit>
}
  8002a7:	90                   	nop
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	6a 00                	push   $0x0
  8002b5:	e8 10 19 00 00       	call   801bca <sys_destroy_env>
  8002ba:	83 c4 10             	add    $0x10,%esp
}
  8002bd:	90                   	nop
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <exit>:

void
exit(void)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c6:	e8 65 19 00 00       	call   801c30 <sys_exit_env>
}
  8002cb:	90                   	nop
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    

008002ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d7:	83 c0 04             	add    $0x4,%eax
  8002da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002dd:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	74 16                	je     8002fc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	50                   	push   %eax
  8002ef:	68 48 36 80 00       	push   $0x803648
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 40 80 00       	mov    0x804000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 4d 36 80 00       	push   $0x80364d
  80030d:	e8 70 02 00 00       	call   800582 <cprintf>
  800312:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800315:	8b 45 10             	mov    0x10(%ebp),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 f4             	pushl  -0xc(%ebp)
  80031e:	50                   	push   %eax
  80031f:	e8 f3 01 00 00       	call   800517 <vcprintf>
  800324:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	68 69 36 80 00       	push   $0x803669
  800331:	e8 e1 01 00 00       	call   800517 <vcprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800339:	e8 82 ff ff ff       	call   8002c0 <exit>

	// should not return here
	while (1) ;
  80033e:	eb fe                	jmp    80033e <_panic+0x70>

00800340 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800346:	a1 20 40 80 00       	mov    0x804020,%eax
  80034b:	8b 50 74             	mov    0x74(%eax),%edx
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	39 c2                	cmp    %eax,%edx
  800353:	74 14                	je     800369 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 6c 36 80 00       	push   $0x80366c
  80035d:	6a 26                	push   $0x26
  80035f:	68 b8 36 80 00       	push   $0x8036b8
  800364:	e8 65 ff ff ff       	call   8002ce <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800377:	e9 c2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	01 d0                	add    %edx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	85 c0                	test   %eax,%eax
  80038f:	75 08                	jne    800399 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800391:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800394:	e9 a2 00 00 00       	jmp    80043b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800399:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a7:	eb 69                	jmp    800412 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ae:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	01 c0                	add    %eax,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c1 e0 03             	shl    $0x3,%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8a 40 04             	mov    0x4(%eax),%al
  8003c5:	84 c0                	test   %al,%al
  8003c7:	75 46                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ce:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	01 c0                	add    %eax,%eax
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	c1 e0 03             	shl    $0x3,%eax
  8003e0:	01 c8                	add    %ecx,%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800402:	39 c2                	cmp    %eax,%edx
  800404:	75 09                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800406:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80040d:	eb 12                	jmp    800421 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040f:	ff 45 e8             	incl   -0x18(%ebp)
  800412:	a1 20 40 80 00       	mov    0x804020,%eax
  800417:	8b 50 74             	mov    0x74(%eax),%edx
  80041a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	77 88                	ja     8003a9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800425:	75 14                	jne    80043b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800427:	83 ec 04             	sub    $0x4,%esp
  80042a:	68 c4 36 80 00       	push   $0x8036c4
  80042f:	6a 3a                	push   $0x3a
  800431:	68 b8 36 80 00       	push   $0x8036b8
  800436:	e8 93 fe ff ff       	call   8002ce <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043b:	ff 45 f0             	incl   -0x10(%ebp)
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800444:	0f 8c 32 ff ff ff    	jl     80037c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800451:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800458:	eb 26                	jmp    800480 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045a:	a1 20 40 80 00       	mov    0x804020,%eax
  80045f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800468:	89 d0                	mov    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8a 40 04             	mov    0x4(%eax),%al
  800476:	3c 01                	cmp    $0x1,%al
  800478:	75 03                	jne    80047d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047d:	ff 45 e0             	incl   -0x20(%ebp)
  800480:	a1 20 40 80 00       	mov    0x804020,%eax
  800485:	8b 50 74             	mov    0x74(%eax),%edx
  800488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048b:	39 c2                	cmp    %eax,%edx
  80048d:	77 cb                	ja     80045a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800495:	74 14                	je     8004ab <CheckWSWithoutLastIndex+0x16b>
		panic(
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	68 18 37 80 00       	push   $0x803718
  80049f:	6a 44                	push   $0x44
  8004a1:	68 b8 36 80 00       	push   $0x8036b8
  8004a6:	e8 23 fe ff ff       	call   8002ce <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bf:	89 0a                	mov    %ecx,(%edx)
  8004c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c4:	88 d1                	mov    %dl,%cl
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d7:	75 2c                	jne    800505 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004d9:	a0 24 40 80 00       	mov    0x804024,%al
  8004de:	0f b6 c0             	movzbl %al,%eax
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	8b 12                	mov    (%edx),%edx
  8004e6:	89 d1                	mov    %edx,%ecx
  8004e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004eb:	83 c2 08             	add    $0x8,%edx
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	50                   	push   %eax
  8004f2:	51                   	push   %ecx
  8004f3:	52                   	push   %edx
  8004f4:	e8 64 13 00 00       	call   80185d <sys_cputs>
  8004f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	8b 40 04             	mov    0x4(%eax),%eax
  80050b:	8d 50 01             	lea    0x1(%eax),%edx
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	89 50 04             	mov    %edx,0x4(%eax)
}
  800514:	90                   	nop
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800520:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800527:	00 00 00 
	b.cnt = 0;
  80052a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800531:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	ff 75 08             	pushl  0x8(%ebp)
  80053a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800540:	50                   	push   %eax
  800541:	68 ae 04 80 00       	push   $0x8004ae
  800546:	e8 11 02 00 00       	call   80075c <vprintfmt>
  80054b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80054e:	a0 24 40 80 00       	mov    0x804024,%al
  800553:	0f b6 c0             	movzbl %al,%eax
  800556:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055c:	83 ec 04             	sub    $0x4,%esp
  80055f:	50                   	push   %eax
  800560:	52                   	push   %edx
  800561:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800567:	83 c0 08             	add    $0x8,%eax
  80056a:	50                   	push   %eax
  80056b:	e8 ed 12 00 00       	call   80185d <sys_cputs>
  800570:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800573:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <cprintf>:

int cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800588:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80058f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 f4             	pushl  -0xc(%ebp)
  80059e:	50                   	push   %eax
  80059f:	e8 73 ff ff ff       	call   800517 <vcprintf>
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b5:	e8 51 14 00 00       	call   801a0b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	50                   	push   %eax
  8005ca:	e8 48 ff ff ff       	call   800517 <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d5:	e8 4b 14 00 00       	call   801a25 <sys_enable_interrupt>
	return cnt;
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	53                   	push   %ebx
  8005e3:	83 ec 14             	sub    $0x14,%esp
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fd:	77 55                	ja     800654 <printnum+0x75>
  8005ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800602:	72 05                	jb     800609 <printnum+0x2a>
  800604:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800607:	77 4b                	ja     800654 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800609:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80060f:	8b 45 18             	mov    0x18(%ebp),%eax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	ff 75 f0             	pushl  -0x10(%ebp)
  80061f:	e8 fc 2a 00 00       	call   803120 <__udivdi3>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	ff 75 20             	pushl  0x20(%ebp)
  80062d:	53                   	push   %ebx
  80062e:	ff 75 18             	pushl  0x18(%ebp)
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	ff 75 08             	pushl  0x8(%ebp)
  800639:	e8 a1 ff ff ff       	call   8005df <printnum>
  80063e:	83 c4 20             	add    $0x20,%esp
  800641:	eb 1a                	jmp    80065d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	ff 75 20             	pushl  0x20(%ebp)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800654:	ff 4d 1c             	decl   0x1c(%ebp)
  800657:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065b:	7f e6                	jg     800643 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800660:	bb 00 00 00 00       	mov    $0x0,%ebx
  800665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066b:	53                   	push   %ebx
  80066c:	51                   	push   %ecx
  80066d:	52                   	push   %edx
  80066e:	50                   	push   %eax
  80066f:	e8 bc 2b 00 00       	call   803230 <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 94 39 80 00       	add    $0x803994,%eax
  80067c:	8a 00                	mov    (%eax),%al
  80067e:	0f be c0             	movsbl %al,%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	50                   	push   %eax
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
}
  800690:	90                   	nop
  800691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800694:	c9                   	leave  
  800695:	c3                   	ret    

00800696 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800699:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069d:	7e 1c                	jle    8006bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8d 50 08             	lea    0x8(%eax),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	89 10                	mov    %edx,(%eax)
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	83 e8 08             	sub    $0x8,%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	eb 40                	jmp    8006fb <getuint+0x65>
	else if (lflag)
  8006bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006bf:	74 1e                	je     8006df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	8d 50 04             	lea    0x4(%eax),%edx
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	89 10                	mov    %edx,(%eax)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	83 e8 04             	sub    $0x4,%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	eb 1c                	jmp    8006fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getint+0x25>
		return va_arg(*ap, long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 38                	jmp    80075a <getint+0x5d>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1a                	je     800742 <getint+0x45>
		return va_arg(*ap, long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
  800740:	eb 18                	jmp    80075a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	8d 50 04             	lea    0x4(%eax),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 10                	mov    %edx,(%eax)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 e8 04             	sub    $0x4,%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	99                   	cltd   
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
  800761:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	eb 17                	jmp    80077d <vprintfmt+0x21>
			if (ch == '\0')
  800766:	85 db                	test   %ebx,%ebx
  800768:	0f 84 af 03 00 00    	je     800b1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	53                   	push   %ebx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077d:	8b 45 10             	mov    0x10(%ebp),%eax
  800780:	8d 50 01             	lea    0x1(%eax),%edx
  800783:	89 55 10             	mov    %edx,0x10(%ebp)
  800786:	8a 00                	mov    (%eax),%al
  800788:	0f b6 d8             	movzbl %al,%ebx
  80078b:	83 fb 25             	cmp    $0x25,%ebx
  80078e:	75 d6                	jne    800766 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800790:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800794:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b3:	8d 50 01             	lea    0x1(%eax),%edx
  8007b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f b6 d8             	movzbl %al,%ebx
  8007be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c1:	83 f8 55             	cmp    $0x55,%eax
  8007c4:	0f 87 2b 03 00 00    	ja     800af5 <vprintfmt+0x399>
  8007ca:	8b 04 85 b8 39 80 00 	mov    0x8039b8(,%eax,4),%eax
  8007d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d7:	eb d7                	jmp    8007b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007dd:	eb d1                	jmp    8007b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e9:	89 d0                	mov    %edx,%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	01 c0                	add    %eax,%eax
  8007f2:	01 d8                	add    %ebx,%eax
  8007f4:	83 e8 30             	sub    $0x30,%eax
  8007f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	8a 00                	mov    (%eax),%al
  8007ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800802:	83 fb 2f             	cmp    $0x2f,%ebx
  800805:	7e 3e                	jle    800845 <vprintfmt+0xe9>
  800807:	83 fb 39             	cmp    $0x39,%ebx
  80080a:	7f 39                	jg     800845 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80080f:	eb d5                	jmp    8007e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 c0 04             	add    $0x4,%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800825:	eb 1f                	jmp    800846 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082b:	79 83                	jns    8007b0 <vprintfmt+0x54>
				width = 0;
  80082d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800834:	e9 77 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800839:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800840:	e9 6b ff ff ff       	jmp    8007b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800845:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084a:	0f 89 60 ff ff ff    	jns    8007b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800856:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80085d:	e9 4e ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800862:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800865:	e9 46 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 c0 04             	add    $0x4,%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	50                   	push   %eax
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			break;
  80088a:	e9 89 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	83 c0 04             	add    $0x4,%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 e8 04             	sub    $0x4,%eax
  80089e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	79 02                	jns    8008a6 <vprintfmt+0x14a>
				err = -err;
  8008a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a6:	83 fb 64             	cmp    $0x64,%ebx
  8008a9:	7f 0b                	jg     8008b6 <vprintfmt+0x15a>
  8008ab:	8b 34 9d 00 38 80 00 	mov    0x803800(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 a5 39 80 00       	push   $0x8039a5
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 5e 02 00 00       	call   800b25 <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ca:	e9 49 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cf:	56                   	push   %esi
  8008d0:	68 ae 39 80 00       	push   $0x8039ae
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 45 02 00 00       	call   800b25 <printfmt>
  8008e0:	83 c4 10             	add    $0x10,%esp
			break;
  8008e3:	e9 30 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 30                	mov    (%eax),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 05                	jne    800902 <vprintfmt+0x1a6>
				p = "(null)";
  8008fd:	be b1 39 80 00       	mov    $0x8039b1,%esi
			if (width > 0 && padc != '-')
  800902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800906:	7e 6d                	jle    800975 <vprintfmt+0x219>
  800908:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090c:	74 67                	je     800975 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	50                   	push   %eax
  800915:	56                   	push   %esi
  800916:	e8 0c 03 00 00       	call   800c27 <strnlen>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800921:	eb 16                	jmp    800939 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800923:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800936:	ff 4d e4             	decl   -0x1c(%ebp)
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	7f e4                	jg     800923 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093f:	eb 34                	jmp    800975 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800941:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800945:	74 1c                	je     800963 <vprintfmt+0x207>
  800947:	83 fb 1f             	cmp    $0x1f,%ebx
  80094a:	7e 05                	jle    800951 <vprintfmt+0x1f5>
  80094c:	83 fb 7e             	cmp    $0x7e,%ebx
  80094f:	7e 12                	jle    800963 <vprintfmt+0x207>
					putch('?', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 3f                	push   $0x3f
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	53                   	push   %ebx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	ff d0                	call   *%eax
  80096f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800972:	ff 4d e4             	decl   -0x1c(%ebp)
  800975:	89 f0                	mov    %esi,%eax
  800977:	8d 70 01             	lea    0x1(%eax),%esi
  80097a:	8a 00                	mov    (%eax),%al
  80097c:	0f be d8             	movsbl %al,%ebx
  80097f:	85 db                	test   %ebx,%ebx
  800981:	74 24                	je     8009a7 <vprintfmt+0x24b>
  800983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800987:	78 b8                	js     800941 <vprintfmt+0x1e5>
  800989:	ff 4d e0             	decl   -0x20(%ebp)
  80098c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800990:	79 af                	jns    800941 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800992:	eb 13                	jmp    8009a7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	6a 20                	push   $0x20
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	7f e7                	jg     800994 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ad:	e9 66 01 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 3c fd ff ff       	call   8006fd <getint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	79 23                	jns    8009f7 <vprintfmt+0x29b>
				putch('-', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 2d                	push   $0x2d
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ea:	f7 d8                	neg    %eax
  8009ec:	83 d2 00             	adc    $0x0,%edx
  8009ef:	f7 da                	neg    %edx
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fe:	e9 bc 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 e8             	pushl  -0x18(%ebp)
  800a09:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0c:	50                   	push   %eax
  800a0d:	e8 84 fc ff ff       	call   800696 <getuint>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 98 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 58                	push   $0x58
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 58                	push   $0x58
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 58                	push   $0x58
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			break;
  800a57:	e9 bc 00 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 30                	push   $0x30
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	6a 78                	push   $0x78
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a9e:	eb 1f                	jmp    800abf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa6:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	e8 e7 fb ff ff       	call   800696 <getuint>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac6:	83 ec 04             	sub    $0x4,%esp
  800ac9:	52                   	push   %edx
  800aca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acd:	50                   	push   %eax
  800ace:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 00 fb ff ff       	call   8005df <printnum>
  800adf:	83 c4 20             	add    $0x20,%esp
			break;
  800ae2:	eb 34                	jmp    800b18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	eb 23                	jmp    800b18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 25                	push   $0x25
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	eb 03                	jmp    800b0d <vprintfmt+0x3b1>
  800b0a:	ff 4d 10             	decl   0x10(%ebp)
  800b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b10:	48                   	dec    %eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	3c 25                	cmp    $0x25,%al
  800b15:	75 f3                	jne    800b0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b17:	90                   	nop
		}
	}
  800b18:	e9 47 fc ff ff       	jmp    800764 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b34:	8b 45 10             	mov    0x10(%ebp),%eax
  800b37:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 16 fc ff ff       	call   80075c <vprintfmt>
  800b46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b49:	90                   	nop
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 40 08             	mov    0x8(%eax),%eax
  800b55:	8d 50 01             	lea    0x1(%eax),%edx
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 10                	mov    (%eax),%edx
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8b 40 04             	mov    0x4(%eax),%eax
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	73 12                	jae    800b7f <sprintputch+0x33>
		*b->buf++ = ch;
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	8d 48 01             	lea    0x1(%eax),%ecx
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b78:	89 0a                	mov    %ecx,(%edx)
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	88 10                	mov    %dl,(%eax)
}
  800b7f:	90                   	nop
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	01 d0                	add    %edx,%eax
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba7:	74 06                	je     800baf <vsnprintf+0x2d>
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	7f 07                	jg     800bb6 <vsnprintf+0x34>
		return -E_INVAL;
  800baf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb4:	eb 20                	jmp    800bd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb6:	ff 75 14             	pushl  0x14(%ebp)
  800bb9:	ff 75 10             	pushl  0x10(%ebp)
  800bbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	68 4c 0b 80 00       	push   $0x800b4c
  800bc5:	e8 92 fb ff ff       	call   80075c <vprintfmt>
  800bca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bde:	8d 45 10             	lea    0x10(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 89 ff ff ff       	call   800b82 <vsnprintf>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c11:	eb 06                	jmp    800c19 <strlen+0x15>
		n++;
  800c13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	ff 45 08             	incl   0x8(%ebp)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 f1                	jne    800c13 <strlen+0xf>
		n++;
	return n;
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c34:	eb 09                	jmp    800c3f <strnlen+0x18>
		n++;
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	ff 4d 0c             	decl   0xc(%ebp)
  800c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c43:	74 09                	je     800c4e <strnlen+0x27>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	75 e8                	jne    800c36 <strnlen+0xf>
		n++;
	return n;
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c5f:	90                   	nop
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c72:	8a 12                	mov    (%edx),%dl
  800c74:	88 10                	mov    %dl,(%eax)
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 e4                	jne    800c60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c94:	eb 1f                	jmp    800cb5 <strncpy+0x34>
		*dst++ = *src;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	74 03                	je     800cb2 <strncpy+0x31>
			src++;
  800caf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb2:	ff 45 fc             	incl   -0x4(%ebp)
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbb:	72 d9                	jb     800c96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd2:	74 30                	je     800d04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd4:	eb 16                	jmp    800cec <strlcpy+0x2a>
			*dst++ = *src++;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce8:	8a 12                	mov    (%edx),%dl
  800cea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cec:	ff 4d 10             	decl   0x10(%ebp)
  800cef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf3:	74 09                	je     800cfe <strlcpy+0x3c>
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 d8                	jne    800cd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	29 c2                	sub    %eax,%edx
  800d0c:	89 d0                	mov    %edx,%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d13:	eb 06                	jmp    800d1b <strcmp+0xb>
		p++, q++;
  800d15:	ff 45 08             	incl   0x8(%ebp)
  800d18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	84 c0                	test   %al,%al
  800d22:	74 0e                	je     800d32 <strcmp+0x22>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 10                	mov    (%eax),%dl
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	38 c2                	cmp    %al,%dl
  800d30:	74 e3                	je     800d15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 d0             	movzbl %al,%edx
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f b6 c0             	movzbl %al,%eax
  800d42:	29 c2                	sub    %eax,%edx
  800d44:	89 d0                	mov    %edx,%eax
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4b:	eb 09                	jmp    800d56 <strncmp+0xe>
		n--, p++, q++;
  800d4d:	ff 4d 10             	decl   0x10(%ebp)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 17                	je     800d73 <strncmp+0x2b>
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	74 0e                	je     800d73 <strncmp+0x2b>
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 10                	mov    (%eax),%dl
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	38 c2                	cmp    %al,%dl
  800d71:	74 da                	je     800d4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d77:	75 07                	jne    800d80 <strncmp+0x38>
		return 0;
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7e:	eb 14                	jmp    800d94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d0             	movzbl %al,%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f b6 c0             	movzbl %al,%eax
  800d90:	29 c2                	sub    %eax,%edx
  800d92:	89 d0                	mov    %edx,%eax
}
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 04             	sub    $0x4,%esp
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da2:	eb 12                	jmp    800db6 <strchr+0x20>
		if (*s == c)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dac:	75 05                	jne    800db3 <strchr+0x1d>
			return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	eb 11                	jmp    800dc4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 e5                	jne    800da4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 04             	sub    $0x4,%esp
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd2:	eb 0d                	jmp    800de1 <strfind+0x1b>
		if (*s == c)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddc:	74 0e                	je     800dec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dde:	ff 45 08             	incl   0x8(%ebp)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	75 ea                	jne    800dd4 <strfind+0xe>
  800dea:	eb 01                	jmp    800ded <strfind+0x27>
		if (*s == c)
			break;
  800dec:	90                   	nop
	return (char *) s;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e04:	eb 0e                	jmp    800e14 <memset+0x22>
		*p++ = c;
  800e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e09:	8d 50 01             	lea    0x1(%eax),%edx
  800e0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e14:	ff 4d f8             	decl   -0x8(%ebp)
  800e17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1b:	79 e9                	jns    800e06 <memset+0x14>
		*p++ = c;

	return v;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e34:	eb 16                	jmp    800e4c <memcpy+0x2a>
		*d++ = *s++;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e48:	8a 12                	mov    (%edx),%dl
  800e4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 dd                	jne    800e36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e76:	73 50                	jae    800ec8 <memmove+0x6a>
  800e78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	01 d0                	add    %edx,%eax
  800e80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e83:	76 43                	jbe    800ec8 <memmove+0x6a>
		s += n;
  800e85:	8b 45 10             	mov    0x10(%ebp),%eax
  800e88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e91:	eb 10                	jmp    800ea3 <memmove+0x45>
			*--d = *--s;
  800e93:	ff 4d f8             	decl   -0x8(%ebp)
  800e96:	ff 4d fc             	decl   -0x4(%ebp)
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 10                	mov    (%eax),%dl
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	75 e3                	jne    800e93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb0:	eb 23                	jmp    800ed5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec4:	8a 12                	mov    (%edx),%dl
  800ec6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ece:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 dd                	jne    800eb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eec:	eb 2a                	jmp    800f18 <memcmp+0x3e>
		if (*s1 != *s2)
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef1:	8a 10                	mov    (%eax),%dl
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	38 c2                	cmp    %al,%dl
  800efa:	74 16                	je     800f12 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 d0             	movzbl %al,%edx
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	0f b6 c0             	movzbl %al,%eax
  800f0c:	29 c2                	sub    %eax,%edx
  800f0e:	89 d0                	mov    %edx,%eax
  800f10:	eb 18                	jmp    800f2a <memcmp+0x50>
		s1++, s2++;
  800f12:	ff 45 fc             	incl   -0x4(%ebp)
  800f15:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 c9                	jne    800eee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 d0                	add    %edx,%eax
  800f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f3d:	eb 15                	jmp    800f54 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 d0             	movzbl %al,%edx
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	74 0d                	je     800f5e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5a:	72 e3                	jb     800f3f <memfind+0x13>
  800f5c:	eb 01                	jmp    800f5f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f5e:	90                   	nop
	return (void *) s;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f78:	eb 03                	jmp    800f7d <strtol+0x19>
		s++;
  800f7a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 20                	cmp    $0x20,%al
  800f84:	74 f4                	je     800f7a <strtol+0x16>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 09                	cmp    $0x9,%al
  800f8d:	74 eb                	je     800f7a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 2b                	cmp    $0x2b,%al
  800f96:	75 05                	jne    800f9d <strtol+0x39>
		s++;
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	eb 13                	jmp    800fb0 <strtol+0x4c>
	else if (*s == '-')
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 2d                	cmp    $0x2d,%al
  800fa4:	75 0a                	jne    800fb0 <strtol+0x4c>
		s++, neg = 1;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb4:	74 06                	je     800fbc <strtol+0x58>
  800fb6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fba:	75 20                	jne    800fdc <strtol+0x78>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 30                	cmp    $0x30,%al
  800fc3:	75 17                	jne    800fdc <strtol+0x78>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	40                   	inc    %eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 78                	cmp    $0x78,%al
  800fcd:	75 0d                	jne    800fdc <strtol+0x78>
		s += 2, base = 16;
  800fcf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fda:	eb 28                	jmp    801004 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 15                	jne    800ff7 <strtol+0x93>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 30                	cmp    $0x30,%al
  800fe9:	75 0c                	jne    800ff7 <strtol+0x93>
		s++, base = 8;
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff5:	eb 0d                	jmp    801004 <strtol+0xa0>
	else if (base == 0)
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 07                	jne    801004 <strtol+0xa0>
		base = 10;
  800ffd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2f                	cmp    $0x2f,%al
  80100b:	7e 19                	jle    801026 <strtol+0xc2>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 39                	cmp    $0x39,%al
  801014:	7f 10                	jg     801026 <strtol+0xc2>
			dig = *s - '0';
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	83 e8 30             	sub    $0x30,%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801024:	eb 42                	jmp    801068 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 60                	cmp    $0x60,%al
  80102d:	7e 19                	jle    801048 <strtol+0xe4>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 7a                	cmp    $0x7a,%al
  801036:	7f 10                	jg     801048 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	83 e8 57             	sub    $0x57,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801046:	eb 20                	jmp    801068 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 40                	cmp    $0x40,%al
  80104f:	7e 39                	jle    80108a <strtol+0x126>
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 5a                	cmp    $0x5a,%al
  801058:	7f 30                	jg     80108a <strtol+0x126>
			dig = *s - 'A' + 10;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f be c0             	movsbl %al,%eax
  801062:	83 e8 37             	sub    $0x37,%eax
  801065:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80106e:	7d 19                	jge    801089 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801070:	ff 45 08             	incl   0x8(%ebp)
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801084:	e9 7b ff ff ff       	jmp    801004 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801089:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108e:	74 08                	je     801098 <strtol+0x134>
		*endptr = (char *) s;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801098:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109c:	74 07                	je     8010a5 <strtol+0x141>
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	f7 d8                	neg    %eax
  8010a3:	eb 03                	jmp    8010a8 <strtol+0x144>
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <ltostr>:

void
ltostr(long value, char *str)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c2:	79 13                	jns    8010d7 <ltostr+0x2d>
	{
		neg = 1;
  8010c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010df:	99                   	cltd   
  8010e0:	f7 f9                	idiv   %ecx
  8010e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	83 c2 30             	add    $0x30,%edx
  8010fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801100:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801105:	f7 e9                	imul   %ecx
  801107:	c1 fa 02             	sar    $0x2,%edx
  80110a:	89 c8                	mov    %ecx,%eax
  80110c:	c1 f8 1f             	sar    $0x1f,%eax
  80110f:	29 c2                	sub    %eax,%edx
  801111:	89 d0                	mov    %edx,%eax
  801113:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801119:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111e:	f7 e9                	imul   %ecx
  801120:	c1 fa 02             	sar    $0x2,%edx
  801123:	89 c8                	mov    %ecx,%eax
  801125:	c1 f8 1f             	sar    $0x1f,%eax
  801128:	29 c2                	sub    %eax,%edx
  80112a:	89 d0                	mov    %edx,%eax
  80112c:	c1 e0 02             	shl    $0x2,%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	01 c0                	add    %eax,%eax
  801133:	29 c1                	sub    %eax,%ecx
  801135:	89 ca                	mov    %ecx,%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	75 9c                	jne    8010d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	48                   	dec    %eax
  801146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801149:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114d:	74 3d                	je     80118c <ltostr+0xe2>
		start = 1 ;
  80114f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801156:	eb 34                	jmp    80118c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	01 c2                	add    %eax,%edx
  80116d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	01 c8                	add    %ecx,%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c2                	add    %eax,%edx
  801181:	8a 45 eb             	mov    -0x15(%ebp),%al
  801184:	88 02                	mov    %al,(%edx)
		start++ ;
  801186:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801189:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801192:	7c c4                	jl     801158 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801194:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80119f:	90                   	nop
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	e8 54 fa ff ff       	call   800c04 <strlen>
  8011b0:	83 c4 04             	add    $0x4,%esp
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	e8 46 fa ff ff       	call   800c04 <strlen>
  8011be:	83 c4 04             	add    $0x4,%esp
  8011c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d2:	eb 17                	jmp    8011eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	01 c2                	add    %eax,%edx
  8011dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	01 c8                	add    %ecx,%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e8:	ff 45 fc             	incl   -0x4(%ebp)
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f1:	7c e1                	jl     8011d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801201:	eb 1f                	jmp    801222 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 c2                	add    %eax,%edx
  801213:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 c8                	add    %ecx,%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801228:	7c d9                	jl     801203 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	c6 00 00             	movb   $0x0,(%eax)
}
  801235:	90                   	nop
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123b:	8b 45 14             	mov    0x14(%ebp),%eax
  80123e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125b:	eb 0c                	jmp    801269 <strsplit+0x31>
			*string++ = 0;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 08             	mov    %edx,0x8(%ebp)
  801266:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 18                	je     80128a <strsplit+0x52>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 13 fb ff ff       	call   800d96 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	75 d3                	jne    80125d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	84 c0                	test   %al,%al
  801291:	74 5a                	je     8012ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	83 f8 0f             	cmp    $0xf,%eax
  80129b:	75 07                	jne    8012a4 <strsplit+0x6c>
		{
			return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a2:	eb 66                	jmp    80130a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a7:	8b 00                	mov    (%eax),%eax
  8012a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8012af:	89 0a                	mov    %ecx,(%edx)
  8012b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c2:	eb 03                	jmp    8012c7 <strsplit+0x8f>
			string++;
  8012c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 8b                	je     80125b <strsplit+0x23>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	0f be c0             	movsbl %al,%eax
  8012d8:	50                   	push   %eax
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	e8 b5 fa ff ff       	call   800d96 <strchr>
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	74 dc                	je     8012c4 <strsplit+0x8c>
			string++;
	}
  8012e8:	e9 6e ff ff ff       	jmp    80125b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8b 00                	mov    (%eax),%eax
  8012f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801305:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801312:	a1 04 40 80 00       	mov    0x804004,%eax
  801317:	85 c0                	test   %eax,%eax
  801319:	74 1f                	je     80133a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131b:	e8 1d 00 00 00       	call   80133d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	68 10 3b 80 00       	push   $0x803b10
  801328:	e8 55 f2 ff ff       	call   800582 <cprintf>
  80132d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801330:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801337:	00 00 00 
	}
}
  80133a:	90                   	nop
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801343:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80134a:	00 00 00 
  80134d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801354:	00 00 00 
  801357:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80135e:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801361:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801368:	00 00 00 
  80136b:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801372:	00 00 00 
  801375:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80137c:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80137f:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801386:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801389:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801398:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139d:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8013a2:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013a9:	a1 20 41 80 00       	mov    0x804120,%eax
  8013ae:	c1 e0 04             	shl    $0x4,%eax
  8013b1:	89 c2                	mov    %eax,%edx
  8013b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b6:	01 d0                	add    %edx,%eax
  8013b8:	48                   	dec    %eax
  8013b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c4:	f7 75 f0             	divl   -0x10(%ebp)
  8013c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ca:	29 d0                	sub    %edx,%eax
  8013cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8013cf:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013de:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	6a 06                	push   $0x6
  8013e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8013eb:	50                   	push   %eax
  8013ec:	e8 b0 05 00 00       	call   8019a1 <sys_allocate_chunk>
  8013f1:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013f4:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f9:	83 ec 0c             	sub    $0xc,%esp
  8013fc:	50                   	push   %eax
  8013fd:	e8 25 0c 00 00       	call   802027 <initialize_MemBlocksList>
  801402:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801405:	a1 48 41 80 00       	mov    0x804148,%eax
  80140a:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  80140d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801411:	75 14                	jne    801427 <initialize_dyn_block_system+0xea>
  801413:	83 ec 04             	sub    $0x4,%esp
  801416:	68 35 3b 80 00       	push   $0x803b35
  80141b:	6a 29                	push   $0x29
  80141d:	68 53 3b 80 00       	push   $0x803b53
  801422:	e8 a7 ee ff ff       	call   8002ce <_panic>
  801427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142a:	8b 00                	mov    (%eax),%eax
  80142c:	85 c0                	test   %eax,%eax
  80142e:	74 10                	je     801440 <initialize_dyn_block_system+0x103>
  801430:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801433:	8b 00                	mov    (%eax),%eax
  801435:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801438:	8b 52 04             	mov    0x4(%edx),%edx
  80143b:	89 50 04             	mov    %edx,0x4(%eax)
  80143e:	eb 0b                	jmp    80144b <initialize_dyn_block_system+0x10e>
  801440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801443:	8b 40 04             	mov    0x4(%eax),%eax
  801446:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80144b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144e:	8b 40 04             	mov    0x4(%eax),%eax
  801451:	85 c0                	test   %eax,%eax
  801453:	74 0f                	je     801464 <initialize_dyn_block_system+0x127>
  801455:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801458:	8b 40 04             	mov    0x4(%eax),%eax
  80145b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80145e:	8b 12                	mov    (%edx),%edx
  801460:	89 10                	mov    %edx,(%eax)
  801462:	eb 0a                	jmp    80146e <initialize_dyn_block_system+0x131>
  801464:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801467:	8b 00                	mov    (%eax),%eax
  801469:	a3 48 41 80 00       	mov    %eax,0x804148
  80146e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801471:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801481:	a1 54 41 80 00       	mov    0x804154,%eax
  801486:	48                   	dec    %eax
  801487:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80148c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801496:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801499:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	ff 75 e0             	pushl  -0x20(%ebp)
  8014a6:	e8 b9 14 00 00       	call   802964 <insert_sorted_with_merge_freeList>
  8014ab:	83 c4 10             	add    $0x10,%esp

}
  8014ae:	90                   	nop
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014b7:	e8 50 fe ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  8014bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014c0:	75 07                	jne    8014c9 <malloc+0x18>
  8014c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c7:	eb 68                	jmp    801531 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8014c9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d6:	01 d0                	add    %edx,%eax
  8014d8:	48                   	dec    %eax
  8014d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014df:	ba 00 00 00 00       	mov    $0x0,%edx
  8014e4:	f7 75 f4             	divl   -0xc(%ebp)
  8014e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ea:	29 d0                	sub    %edx,%eax
  8014ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8014ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014f6:	e8 74 08 00 00       	call   801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	74 2d                	je     80152c <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8014ff:	83 ec 0c             	sub    $0xc,%esp
  801502:	ff 75 ec             	pushl  -0x14(%ebp)
  801505:	e8 52 0e 00 00       	call   80235c <alloc_block_FF>
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801510:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801514:	74 16                	je     80152c <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801516:	83 ec 0c             	sub    $0xc,%esp
  801519:	ff 75 e8             	pushl  -0x18(%ebp)
  80151c:	e8 3b 0c 00 00       	call   80215c <insert_sorted_allocList>
  801521:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801524:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801527:	8b 40 08             	mov    0x8(%eax),%eax
  80152a:	eb 05                	jmp    801531 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  80152c:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801531:	c9                   	leave  
  801532:	c3                   	ret    

00801533 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801533:	55                   	push   %ebp
  801534:	89 e5                	mov    %esp,%ebp
  801536:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801539:	8b 45 08             	mov    0x8(%ebp),%eax
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	50                   	push   %eax
  801540:	68 40 40 80 00       	push   $0x804040
  801545:	e8 ba 0b 00 00       	call   802104 <find_block>
  80154a:	83 c4 10             	add    $0x10,%esp
  80154d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801553:	8b 40 0c             	mov    0xc(%eax),%eax
  801556:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801559:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80155d:	0f 84 9f 00 00 00    	je     801602 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	83 ec 08             	sub    $0x8,%esp
  801569:	ff 75 f0             	pushl  -0x10(%ebp)
  80156c:	50                   	push   %eax
  80156d:	e8 f7 03 00 00       	call   801969 <sys_free_user_mem>
  801572:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801579:	75 14                	jne    80158f <free+0x5c>
  80157b:	83 ec 04             	sub    $0x4,%esp
  80157e:	68 35 3b 80 00       	push   $0x803b35
  801583:	6a 6a                	push   $0x6a
  801585:	68 53 3b 80 00       	push   $0x803b53
  80158a:	e8 3f ed ff ff       	call   8002ce <_panic>
  80158f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801592:	8b 00                	mov    (%eax),%eax
  801594:	85 c0                	test   %eax,%eax
  801596:	74 10                	je     8015a8 <free+0x75>
  801598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159b:	8b 00                	mov    (%eax),%eax
  80159d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a0:	8b 52 04             	mov    0x4(%edx),%edx
  8015a3:	89 50 04             	mov    %edx,0x4(%eax)
  8015a6:	eb 0b                	jmp    8015b3 <free+0x80>
  8015a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ab:	8b 40 04             	mov    0x4(%eax),%eax
  8015ae:	a3 44 40 80 00       	mov    %eax,0x804044
  8015b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b6:	8b 40 04             	mov    0x4(%eax),%eax
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	74 0f                	je     8015cc <free+0x99>
  8015bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c0:	8b 40 04             	mov    0x4(%eax),%eax
  8015c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015c6:	8b 12                	mov    (%edx),%edx
  8015c8:	89 10                	mov    %edx,(%eax)
  8015ca:	eb 0a                	jmp    8015d6 <free+0xa3>
  8015cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015cf:	8b 00                	mov    (%eax),%eax
  8015d1:	a3 40 40 80 00       	mov    %eax,0x804040
  8015d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015e9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015ee:	48                   	dec    %eax
  8015ef:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8015f4:	83 ec 0c             	sub    $0xc,%esp
  8015f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8015fa:	e8 65 13 00 00       	call   802964 <insert_sorted_with_merge_freeList>
  8015ff:	83 c4 10             	add    $0x10,%esp
	}
}
  801602:	90                   	nop
  801603:	c9                   	leave  
  801604:	c3                   	ret    

00801605 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 28             	sub    $0x28,%esp
  80160b:	8b 45 10             	mov    0x10(%ebp),%eax
  80160e:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801611:	e8 f6 fc ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  801616:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80161a:	75 0a                	jne    801626 <smalloc+0x21>
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	e9 af 00 00 00       	jmp    8016d5 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801626:	e8 44 07 00 00       	call   801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80162b:	83 f8 01             	cmp    $0x1,%eax
  80162e:	0f 85 9c 00 00 00    	jne    8016d0 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801634:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80163b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801641:	01 d0                	add    %edx,%eax
  801643:	48                   	dec    %eax
  801644:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164a:	ba 00 00 00 00       	mov    $0x0,%edx
  80164f:	f7 75 f4             	divl   -0xc(%ebp)
  801652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801655:	29 d0                	sub    %edx,%eax
  801657:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80165a:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801661:	76 07                	jbe    80166a <smalloc+0x65>
			return NULL;
  801663:	b8 00 00 00 00       	mov    $0x0,%eax
  801668:	eb 6b                	jmp    8016d5 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80166a:	83 ec 0c             	sub    $0xc,%esp
  80166d:	ff 75 0c             	pushl  0xc(%ebp)
  801670:	e8 e7 0c 00 00       	call   80235c <alloc_block_FF>
  801675:	83 c4 10             	add    $0x10,%esp
  801678:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80167b:	83 ec 0c             	sub    $0xc,%esp
  80167e:	ff 75 ec             	pushl  -0x14(%ebp)
  801681:	e8 d6 0a 00 00       	call   80215c <insert_sorted_allocList>
  801686:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801689:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80168d:	75 07                	jne    801696 <smalloc+0x91>
		{
			return NULL;
  80168f:	b8 00 00 00 00       	mov    $0x0,%eax
  801694:	eb 3f                	jmp    8016d5 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801699:	8b 40 08             	mov    0x8(%eax),%eax
  80169c:	89 c2                	mov    %eax,%edx
  80169e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016a2:	52                   	push   %edx
  8016a3:	50                   	push   %eax
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	ff 75 08             	pushl  0x8(%ebp)
  8016aa:	e8 45 04 00 00       	call   801af4 <sys_createSharedObject>
  8016af:	83 c4 10             	add    $0x10,%esp
  8016b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8016b5:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016b9:	74 06                	je     8016c1 <smalloc+0xbc>
  8016bb:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016bf:	75 07                	jne    8016c8 <smalloc+0xc3>
		{
			return NULL;
  8016c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c6:	eb 0d                	jmp    8016d5 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8016c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016cb:	8b 40 08             	mov    0x8(%eax),%eax
  8016ce:	eb 05                	jmp    8016d5 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8016d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016dd:	e8 2a fc ff ff       	call   80130c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016e2:	83 ec 08             	sub    $0x8,%esp
  8016e5:	ff 75 0c             	pushl  0xc(%ebp)
  8016e8:	ff 75 08             	pushl  0x8(%ebp)
  8016eb:	e8 2e 04 00 00       	call   801b1e <sys_getSizeOfSharedObject>
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8016f6:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016fa:	75 0a                	jne    801706 <sget+0x2f>
	{
		return NULL;
  8016fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801701:	e9 94 00 00 00       	jmp    80179a <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801706:	e8 64 06 00 00       	call   801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170b:	85 c0                	test   %eax,%eax
  80170d:	0f 84 82 00 00 00    	je     801795 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801713:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  80171a:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801721:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801724:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801727:	01 d0                	add    %edx,%eax
  801729:	48                   	dec    %eax
  80172a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80172d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801730:	ba 00 00 00 00       	mov    $0x0,%edx
  801735:	f7 75 ec             	divl   -0x14(%ebp)
  801738:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80173b:	29 d0                	sub    %edx,%eax
  80173d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801743:	83 ec 0c             	sub    $0xc,%esp
  801746:	50                   	push   %eax
  801747:	e8 10 0c 00 00       	call   80235c <alloc_block_FF>
  80174c:	83 c4 10             	add    $0x10,%esp
  80174f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801752:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801756:	75 07                	jne    80175f <sget+0x88>
		{
			return NULL;
  801758:	b8 00 00 00 00       	mov    $0x0,%eax
  80175d:	eb 3b                	jmp    80179a <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801762:	8b 40 08             	mov    0x8(%eax),%eax
  801765:	83 ec 04             	sub    $0x4,%esp
  801768:	50                   	push   %eax
  801769:	ff 75 0c             	pushl  0xc(%ebp)
  80176c:	ff 75 08             	pushl  0x8(%ebp)
  80176f:	e8 c7 03 00 00       	call   801b3b <sys_getSharedObject>
  801774:	83 c4 10             	add    $0x10,%esp
  801777:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80177a:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80177e:	74 06                	je     801786 <sget+0xaf>
  801780:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801784:	75 07                	jne    80178d <sget+0xb6>
		{
			return NULL;
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	eb 0d                	jmp    80179a <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80178d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801790:	8b 40 08             	mov    0x8(%eax),%eax
  801793:	eb 05                	jmp    80179a <sget+0xc3>
		}
	}
	else
			return NULL;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80179a:	c9                   	leave  
  80179b:	c3                   	ret    

0080179c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80179c:	55                   	push   %ebp
  80179d:	89 e5                	mov    %esp,%ebp
  80179f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017a2:	e8 65 fb ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 60 3b 80 00       	push   $0x803b60
  8017af:	68 e1 00 00 00       	push   $0xe1
  8017b4:	68 53 3b 80 00       	push   $0x803b53
  8017b9:	e8 10 eb ff ff       	call   8002ce <_panic>

008017be <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 88 3b 80 00       	push   $0x803b88
  8017cc:	68 f5 00 00 00       	push   $0xf5
  8017d1:	68 53 3b 80 00       	push   $0x803b53
  8017d6:	e8 f3 ea ff ff       	call   8002ce <_panic>

008017db <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e1:	83 ec 04             	sub    $0x4,%esp
  8017e4:	68 ac 3b 80 00       	push   $0x803bac
  8017e9:	68 00 01 00 00       	push   $0x100
  8017ee:	68 53 3b 80 00       	push   $0x803b53
  8017f3:	e8 d6 ea ff ff       	call   8002ce <_panic>

008017f8 <shrink>:

}
void shrink(uint32 newSize)
{
  8017f8:	55                   	push   %ebp
  8017f9:	89 e5                	mov    %esp,%ebp
  8017fb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fe:	83 ec 04             	sub    $0x4,%esp
  801801:	68 ac 3b 80 00       	push   $0x803bac
  801806:	68 05 01 00 00       	push   $0x105
  80180b:	68 53 3b 80 00       	push   $0x803b53
  801810:	e8 b9 ea ff ff       	call   8002ce <_panic>

00801815 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801815:	55                   	push   %ebp
  801816:	89 e5                	mov    %esp,%ebp
  801818:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80181b:	83 ec 04             	sub    $0x4,%esp
  80181e:	68 ac 3b 80 00       	push   $0x803bac
  801823:	68 0a 01 00 00       	push   $0x10a
  801828:	68 53 3b 80 00       	push   $0x803b53
  80182d:	e8 9c ea ff ff       	call   8002ce <_panic>

00801832 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	57                   	push   %edi
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
  801838:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183b:	8b 45 08             	mov    0x8(%ebp),%eax
  80183e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801841:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801844:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801847:	8b 7d 18             	mov    0x18(%ebp),%edi
  80184a:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80184d:	cd 30                	int    $0x30
  80184f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801852:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801855:	83 c4 10             	add    $0x10,%esp
  801858:	5b                   	pop    %ebx
  801859:	5e                   	pop    %esi
  80185a:	5f                   	pop    %edi
  80185b:	5d                   	pop    %ebp
  80185c:	c3                   	ret    

0080185d <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	83 ec 04             	sub    $0x4,%esp
  801863:	8b 45 10             	mov    0x10(%ebp),%eax
  801866:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801869:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	52                   	push   %edx
  801875:	ff 75 0c             	pushl  0xc(%ebp)
  801878:	50                   	push   %eax
  801879:	6a 00                	push   $0x0
  80187b:	e8 b2 ff ff ff       	call   801832 <syscall>
  801880:	83 c4 18             	add    $0x18,%esp
}
  801883:	90                   	nop
  801884:	c9                   	leave  
  801885:	c3                   	ret    

00801886 <sys_cgetc>:

int
sys_cgetc(void)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801889:	6a 00                	push   $0x0
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 01                	push   $0x1
  801895:	e8 98 ff ff ff       	call   801832 <syscall>
  80189a:	83 c4 18             	add    $0x18,%esp
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	52                   	push   %edx
  8018af:	50                   	push   %eax
  8018b0:	6a 05                	push   $0x5
  8018b2:	e8 7b ff ff ff       	call   801832 <syscall>
  8018b7:	83 c4 18             	add    $0x18,%esp
}
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018c1:	8b 75 18             	mov    0x18(%ebp),%esi
  8018c4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	56                   	push   %esi
  8018d1:	53                   	push   %ebx
  8018d2:	51                   	push   %ecx
  8018d3:	52                   	push   %edx
  8018d4:	50                   	push   %eax
  8018d5:	6a 06                	push   $0x6
  8018d7:	e8 56 ff ff ff       	call   801832 <syscall>
  8018dc:	83 c4 18             	add    $0x18,%esp
}
  8018df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	52                   	push   %edx
  8018f6:	50                   	push   %eax
  8018f7:	6a 07                	push   $0x7
  8018f9:	e8 34 ff ff ff       	call   801832 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	ff 75 0c             	pushl  0xc(%ebp)
  80190f:	ff 75 08             	pushl  0x8(%ebp)
  801912:	6a 08                	push   $0x8
  801914:	e8 19 ff ff ff       	call   801832 <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 09                	push   $0x9
  80192d:	e8 00 ff ff ff       	call   801832 <syscall>
  801932:	83 c4 18             	add    $0x18,%esp
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 0a                	push   $0xa
  801946:	e8 e7 fe ff ff       	call   801832 <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 0b                	push   $0xb
  80195f:	e8 ce fe ff ff       	call   801832 <syscall>
  801964:	83 c4 18             	add    $0x18,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	ff 75 0c             	pushl  0xc(%ebp)
  801975:	ff 75 08             	pushl  0x8(%ebp)
  801978:	6a 0f                	push   $0xf
  80197a:	e8 b3 fe ff ff       	call   801832 <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
	return;
  801982:	90                   	nop
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	ff 75 0c             	pushl  0xc(%ebp)
  801991:	ff 75 08             	pushl  0x8(%ebp)
  801994:	6a 10                	push   $0x10
  801996:	e8 97 fe ff ff       	call   801832 <syscall>
  80199b:	83 c4 18             	add    $0x18,%esp
	return ;
  80199e:	90                   	nop
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	ff 75 10             	pushl  0x10(%ebp)
  8019ab:	ff 75 0c             	pushl  0xc(%ebp)
  8019ae:	ff 75 08             	pushl  0x8(%ebp)
  8019b1:	6a 11                	push   $0x11
  8019b3:	e8 7a fe ff ff       	call   801832 <syscall>
  8019b8:	83 c4 18             	add    $0x18,%esp
	return ;
  8019bb:	90                   	nop
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 0c                	push   $0xc
  8019cd:	e8 60 fe ff ff       	call   801832 <syscall>
  8019d2:	83 c4 18             	add    $0x18,%esp
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	ff 75 08             	pushl  0x8(%ebp)
  8019e5:	6a 0d                	push   $0xd
  8019e7:	e8 46 fe ff ff       	call   801832 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 0e                	push   $0xe
  801a00:	e8 2d fe ff ff       	call   801832 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	90                   	nop
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 13                	push   $0x13
  801a1a:	e8 13 fe ff ff       	call   801832 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
}
  801a22:	90                   	nop
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 14                	push   $0x14
  801a34:	e8 f9 fd ff ff       	call   801832 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	90                   	nop
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_cputc>:


void
sys_cputc(const char c)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	8b 45 08             	mov    0x8(%ebp),%eax
  801a48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a4b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	50                   	push   %eax
  801a58:	6a 15                	push   $0x15
  801a5a:	e8 d3 fd ff ff       	call   801832 <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 16                	push   $0x16
  801a74:	e8 b9 fd ff ff       	call   801832 <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a82:	8b 45 08             	mov    0x8(%ebp),%eax
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	ff 75 0c             	pushl  0xc(%ebp)
  801a8e:	50                   	push   %eax
  801a8f:	6a 17                	push   $0x17
  801a91:	e8 9c fd ff ff       	call   801832 <syscall>
  801a96:	83 c4 18             	add    $0x18,%esp
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	52                   	push   %edx
  801aab:	50                   	push   %eax
  801aac:	6a 1a                	push   $0x1a
  801aae:	e8 7f fd ff ff       	call   801832 <syscall>
  801ab3:	83 c4 18             	add    $0x18,%esp
}
  801ab6:	c9                   	leave  
  801ab7:	c3                   	ret    

00801ab8 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ab8:	55                   	push   %ebp
  801ab9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	52                   	push   %edx
  801ac8:	50                   	push   %eax
  801ac9:	6a 18                	push   $0x18
  801acb:	e8 62 fd ff ff       	call   801832 <syscall>
  801ad0:	83 c4 18             	add    $0x18,%esp
}
  801ad3:	90                   	nop
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	52                   	push   %edx
  801ae6:	50                   	push   %eax
  801ae7:	6a 19                	push   $0x19
  801ae9:	e8 44 fd ff ff       	call   801832 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	90                   	nop
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	8b 45 10             	mov    0x10(%ebp),%eax
  801afd:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b00:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b03:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	6a 00                	push   $0x0
  801b0c:	51                   	push   %ecx
  801b0d:	52                   	push   %edx
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	50                   	push   %eax
  801b12:	6a 1b                	push   $0x1b
  801b14:	e8 19 fd ff ff       	call   801832 <syscall>
  801b19:	83 c4 18             	add    $0x18,%esp
}
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b21:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	52                   	push   %edx
  801b2e:	50                   	push   %eax
  801b2f:	6a 1c                	push   $0x1c
  801b31:	e8 fc fc ff ff       	call   801832 <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	51                   	push   %ecx
  801b4c:	52                   	push   %edx
  801b4d:	50                   	push   %eax
  801b4e:	6a 1d                	push   $0x1d
  801b50:	e8 dd fc ff ff       	call   801832 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b60:	8b 45 08             	mov    0x8(%ebp),%eax
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	52                   	push   %edx
  801b6a:	50                   	push   %eax
  801b6b:	6a 1e                	push   $0x1e
  801b6d:	e8 c0 fc ff ff       	call   801832 <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 1f                	push   $0x1f
  801b86:	e8 a7 fc ff ff       	call   801832 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	6a 00                	push   $0x0
  801b98:	ff 75 14             	pushl  0x14(%ebp)
  801b9b:	ff 75 10             	pushl  0x10(%ebp)
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	50                   	push   %eax
  801ba2:	6a 20                	push   $0x20
  801ba4:	e8 89 fc ff ff       	call   801832 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	50                   	push   %eax
  801bbd:	6a 21                	push   $0x21
  801bbf:	e8 6e fc ff ff       	call   801832 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	90                   	nop
  801bc8:	c9                   	leave  
  801bc9:	c3                   	ret    

00801bca <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	50                   	push   %eax
  801bd9:	6a 22                	push   $0x22
  801bdb:	e8 52 fc ff ff       	call   801832 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 02                	push   $0x2
  801bf4:	e8 39 fc ff ff       	call   801832 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c01:	6a 00                	push   $0x0
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 03                	push   $0x3
  801c0d:	e8 20 fc ff ff       	call   801832 <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 04                	push   $0x4
  801c26:	e8 07 fc ff ff       	call   801832 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <sys_exit_env>:


void sys_exit_env(void)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 23                	push   $0x23
  801c3f:	e8 ee fb ff ff       	call   801832 <syscall>
  801c44:	83 c4 18             	add    $0x18,%esp
}
  801c47:	90                   	nop
  801c48:	c9                   	leave  
  801c49:	c3                   	ret    

00801c4a <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c50:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c53:	8d 50 04             	lea    0x4(%eax),%edx
  801c56:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	52                   	push   %edx
  801c60:	50                   	push   %eax
  801c61:	6a 24                	push   $0x24
  801c63:	e8 ca fb ff ff       	call   801832 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
	return result;
  801c6b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c74:	89 01                	mov    %eax,(%ecx)
  801c76:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c79:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7c:	c9                   	leave  
  801c7d:	c2 04 00             	ret    $0x4

00801c80 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	ff 75 10             	pushl  0x10(%ebp)
  801c8a:	ff 75 0c             	pushl  0xc(%ebp)
  801c8d:	ff 75 08             	pushl  0x8(%ebp)
  801c90:	6a 12                	push   $0x12
  801c92:	e8 9b fb ff ff       	call   801832 <syscall>
  801c97:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9a:	90                   	nop
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_rcr2>:
uint32 sys_rcr2()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 25                	push   $0x25
  801cac:	e8 81 fb ff ff       	call   801832 <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	83 ec 04             	sub    $0x4,%esp
  801cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cc2:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	50                   	push   %eax
  801ccf:	6a 26                	push   $0x26
  801cd1:	e8 5c fb ff ff       	call   801832 <syscall>
  801cd6:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd9:	90                   	nop
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <rsttst>:
void rsttst()
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 28                	push   $0x28
  801ceb:	e8 42 fb ff ff       	call   801832 <syscall>
  801cf0:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf3:	90                   	nop
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 04             	sub    $0x4,%esp
  801cfc:	8b 45 14             	mov    0x14(%ebp),%eax
  801cff:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d02:	8b 55 18             	mov    0x18(%ebp),%edx
  801d05:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d09:	52                   	push   %edx
  801d0a:	50                   	push   %eax
  801d0b:	ff 75 10             	pushl  0x10(%ebp)
  801d0e:	ff 75 0c             	pushl  0xc(%ebp)
  801d11:	ff 75 08             	pushl  0x8(%ebp)
  801d14:	6a 27                	push   $0x27
  801d16:	e8 17 fb ff ff       	call   801832 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1e:	90                   	nop
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <chktst>:
void chktst(uint32 n)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	6a 29                	push   $0x29
  801d31:	e8 fc fa ff ff       	call   801832 <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
	return ;
  801d39:	90                   	nop
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <inctst>:

void inctst()
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 2a                	push   $0x2a
  801d4b:	e8 e2 fa ff ff       	call   801832 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return ;
  801d53:	90                   	nop
}
  801d54:	c9                   	leave  
  801d55:	c3                   	ret    

00801d56 <gettst>:
uint32 gettst()
{
  801d56:	55                   	push   %ebp
  801d57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 2b                	push   $0x2b
  801d65:	e8 c8 fa ff ff       	call   801832 <syscall>
  801d6a:	83 c4 18             	add    $0x18,%esp
}
  801d6d:	c9                   	leave  
  801d6e:	c3                   	ret    

00801d6f <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d6f:	55                   	push   %ebp
  801d70:	89 e5                	mov    %esp,%ebp
  801d72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 2c                	push   $0x2c
  801d81:	e8 ac fa ff ff       	call   801832 <syscall>
  801d86:	83 c4 18             	add    $0x18,%esp
  801d89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d8c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d90:	75 07                	jne    801d99 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d92:	b8 01 00 00 00       	mov    $0x1,%eax
  801d97:	eb 05                	jmp    801d9e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 2c                	push   $0x2c
  801db2:	e8 7b fa ff ff       	call   801832 <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
  801dba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dbd:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801dc1:	75 07                	jne    801dca <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dc3:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc8:	eb 05                	jmp    801dcf <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801dca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 2c                	push   $0x2c
  801de3:	e8 4a fa ff ff       	call   801832 <syscall>
  801de8:	83 c4 18             	add    $0x18,%esp
  801deb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dee:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801df2:	75 07                	jne    801dfb <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801df4:	b8 01 00 00 00       	mov    $0x1,%eax
  801df9:	eb 05                	jmp    801e00 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e08:	6a 00                	push   $0x0
  801e0a:	6a 00                	push   $0x0
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 2c                	push   $0x2c
  801e14:	e8 19 fa ff ff       	call   801832 <syscall>
  801e19:	83 c4 18             	add    $0x18,%esp
  801e1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e1f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e23:	75 07                	jne    801e2c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e25:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2a:	eb 05                	jmp    801e31 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	ff 75 08             	pushl  0x8(%ebp)
  801e41:	6a 2d                	push   $0x2d
  801e43:	e8 ea f9 ff ff       	call   801832 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4b:	90                   	nop
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e52:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e55:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	6a 00                	push   $0x0
  801e60:	53                   	push   %ebx
  801e61:	51                   	push   %ecx
  801e62:	52                   	push   %edx
  801e63:	50                   	push   %eax
  801e64:	6a 2e                	push   $0x2e
  801e66:	e8 c7 f9 ff ff       	call   801832 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
}
  801e6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e71:	c9                   	leave  
  801e72:	c3                   	ret    

00801e73 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e73:	55                   	push   %ebp
  801e74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e79:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	52                   	push   %edx
  801e83:	50                   	push   %eax
  801e84:	6a 2f                	push   $0x2f
  801e86:	e8 a7 f9 ff ff       	call   801832 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	68 bc 3b 80 00       	push   $0x803bbc
  801e9e:	e8 df e6 ff ff       	call   800582 <cprintf>
  801ea3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ea6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ead:	83 ec 0c             	sub    $0xc,%esp
  801eb0:	68 e8 3b 80 00       	push   $0x803be8
  801eb5:	e8 c8 e6 ff ff       	call   800582 <cprintf>
  801eba:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ebd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec1:	a1 38 41 80 00       	mov    0x804138,%eax
  801ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec9:	eb 56                	jmp    801f21 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ecb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ecf:	74 1c                	je     801eed <print_mem_block_lists+0x5d>
  801ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed4:	8b 50 08             	mov    0x8(%eax),%edx
  801ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eda:	8b 48 08             	mov    0x8(%eax),%ecx
  801edd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee0:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee3:	01 c8                	add    %ecx,%eax
  801ee5:	39 c2                	cmp    %eax,%edx
  801ee7:	73 04                	jae    801eed <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ee9:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef0:	8b 50 08             	mov    0x8(%eax),%edx
  801ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ef6:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef9:	01 c2                	add    %eax,%edx
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	8b 40 08             	mov    0x8(%eax),%eax
  801f01:	83 ec 04             	sub    $0x4,%esp
  801f04:	52                   	push   %edx
  801f05:	50                   	push   %eax
  801f06:	68 fd 3b 80 00       	push   $0x803bfd
  801f0b:	e8 72 e6 ff ff       	call   800582 <cprintf>
  801f10:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f19:	a1 40 41 80 00       	mov    0x804140,%eax
  801f1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f25:	74 07                	je     801f2e <print_mem_block_lists+0x9e>
  801f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2a:	8b 00                	mov    (%eax),%eax
  801f2c:	eb 05                	jmp    801f33 <print_mem_block_lists+0xa3>
  801f2e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f33:	a3 40 41 80 00       	mov    %eax,0x804140
  801f38:	a1 40 41 80 00       	mov    0x804140,%eax
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	75 8a                	jne    801ecb <print_mem_block_lists+0x3b>
  801f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f45:	75 84                	jne    801ecb <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f47:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f4b:	75 10                	jne    801f5d <print_mem_block_lists+0xcd>
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	68 0c 3c 80 00       	push   $0x803c0c
  801f55:	e8 28 e6 ff ff       	call   800582 <cprintf>
  801f5a:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f5d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f64:	83 ec 0c             	sub    $0xc,%esp
  801f67:	68 30 3c 80 00       	push   $0x803c30
  801f6c:	e8 11 e6 ff ff       	call   800582 <cprintf>
  801f71:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f74:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f78:	a1 40 40 80 00       	mov    0x804040,%eax
  801f7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f80:	eb 56                	jmp    801fd8 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f82:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f86:	74 1c                	je     801fa4 <print_mem_block_lists+0x114>
  801f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8b:	8b 50 08             	mov    0x8(%eax),%edx
  801f8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f91:	8b 48 08             	mov    0x8(%eax),%ecx
  801f94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f97:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9a:	01 c8                	add    %ecx,%eax
  801f9c:	39 c2                	cmp    %eax,%edx
  801f9e:	73 04                	jae    801fa4 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fa0:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa7:	8b 50 08             	mov    0x8(%eax),%edx
  801faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fad:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb0:	01 c2                	add    %eax,%edx
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	8b 40 08             	mov    0x8(%eax),%eax
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	52                   	push   %edx
  801fbc:	50                   	push   %eax
  801fbd:	68 fd 3b 80 00       	push   $0x803bfd
  801fc2:	e8 bb e5 ff ff       	call   800582 <cprintf>
  801fc7:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fd0:	a1 48 40 80 00       	mov    0x804048,%eax
  801fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fdc:	74 07                	je     801fe5 <print_mem_block_lists+0x155>
  801fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe1:	8b 00                	mov    (%eax),%eax
  801fe3:	eb 05                	jmp    801fea <print_mem_block_lists+0x15a>
  801fe5:	b8 00 00 00 00       	mov    $0x0,%eax
  801fea:	a3 48 40 80 00       	mov    %eax,0x804048
  801fef:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff4:	85 c0                	test   %eax,%eax
  801ff6:	75 8a                	jne    801f82 <print_mem_block_lists+0xf2>
  801ff8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ffc:	75 84                	jne    801f82 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801ffe:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802002:	75 10                	jne    802014 <print_mem_block_lists+0x184>
  802004:	83 ec 0c             	sub    $0xc,%esp
  802007:	68 48 3c 80 00       	push   $0x803c48
  80200c:	e8 71 e5 ff ff       	call   800582 <cprintf>
  802011:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802014:	83 ec 0c             	sub    $0xc,%esp
  802017:	68 bc 3b 80 00       	push   $0x803bbc
  80201c:	e8 61 e5 ff ff       	call   800582 <cprintf>
  802021:	83 c4 10             	add    $0x10,%esp

}
  802024:	90                   	nop
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80202d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802034:	00 00 00 
  802037:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80203e:	00 00 00 
  802041:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802048:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80204b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802052:	e9 9e 00 00 00       	jmp    8020f5 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802057:	a1 50 40 80 00       	mov    0x804050,%eax
  80205c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205f:	c1 e2 04             	shl    $0x4,%edx
  802062:	01 d0                	add    %edx,%eax
  802064:	85 c0                	test   %eax,%eax
  802066:	75 14                	jne    80207c <initialize_MemBlocksList+0x55>
  802068:	83 ec 04             	sub    $0x4,%esp
  80206b:	68 70 3c 80 00       	push   $0x803c70
  802070:	6a 42                	push   $0x42
  802072:	68 93 3c 80 00       	push   $0x803c93
  802077:	e8 52 e2 ff ff       	call   8002ce <_panic>
  80207c:	a1 50 40 80 00       	mov    0x804050,%eax
  802081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802084:	c1 e2 04             	shl    $0x4,%edx
  802087:	01 d0                	add    %edx,%eax
  802089:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80208f:	89 10                	mov    %edx,(%eax)
  802091:	8b 00                	mov    (%eax),%eax
  802093:	85 c0                	test   %eax,%eax
  802095:	74 18                	je     8020af <initialize_MemBlocksList+0x88>
  802097:	a1 48 41 80 00       	mov    0x804148,%eax
  80209c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020a2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020a5:	c1 e1 04             	shl    $0x4,%ecx
  8020a8:	01 ca                	add    %ecx,%edx
  8020aa:	89 50 04             	mov    %edx,0x4(%eax)
  8020ad:	eb 12                	jmp    8020c1 <initialize_MemBlocksList+0x9a>
  8020af:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b7:	c1 e2 04             	shl    $0x4,%edx
  8020ba:	01 d0                	add    %edx,%eax
  8020bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020c1:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c9:	c1 e2 04             	shl    $0x4,%edx
  8020cc:	01 d0                	add    %edx,%eax
  8020ce:	a3 48 41 80 00       	mov    %eax,0x804148
  8020d3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020db:	c1 e2 04             	shl    $0x4,%edx
  8020de:	01 d0                	add    %edx,%eax
  8020e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020e7:	a1 54 41 80 00       	mov    0x804154,%eax
  8020ec:	40                   	inc    %eax
  8020ed:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8020f2:	ff 45 f4             	incl   -0xc(%ebp)
  8020f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020fb:	0f 82 56 ff ff ff    	jb     802057 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802101:	90                   	nop
  802102:	c9                   	leave  
  802103:	c3                   	ret    

00802104 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	8b 00                	mov    (%eax),%eax
  80210f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802112:	eb 19                	jmp    80212d <find_block+0x29>
	{
		if(blk->sva==va)
  802114:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802117:	8b 40 08             	mov    0x8(%eax),%eax
  80211a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80211d:	75 05                	jne    802124 <find_block+0x20>
			return (blk);
  80211f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802122:	eb 36                	jmp    80215a <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	8b 40 08             	mov    0x8(%eax),%eax
  80212a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80212d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802131:	74 07                	je     80213a <find_block+0x36>
  802133:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802136:	8b 00                	mov    (%eax),%eax
  802138:	eb 05                	jmp    80213f <find_block+0x3b>
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
  80213f:	8b 55 08             	mov    0x8(%ebp),%edx
  802142:	89 42 08             	mov    %eax,0x8(%edx)
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	8b 40 08             	mov    0x8(%eax),%eax
  80214b:	85 c0                	test   %eax,%eax
  80214d:	75 c5                	jne    802114 <find_block+0x10>
  80214f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802153:	75 bf                	jne    802114 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802155:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802162:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802167:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80216a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802174:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802177:	75 65                	jne    8021de <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802179:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80217d:	75 14                	jne    802193 <insert_sorted_allocList+0x37>
  80217f:	83 ec 04             	sub    $0x4,%esp
  802182:	68 70 3c 80 00       	push   $0x803c70
  802187:	6a 5c                	push   $0x5c
  802189:	68 93 3c 80 00       	push   $0x803c93
  80218e:	e8 3b e1 ff ff       	call   8002ce <_panic>
  802193:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	89 10                	mov    %edx,(%eax)
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	8b 00                	mov    (%eax),%eax
  8021a3:	85 c0                	test   %eax,%eax
  8021a5:	74 0d                	je     8021b4 <insert_sorted_allocList+0x58>
  8021a7:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8021af:	89 50 04             	mov    %edx,0x4(%eax)
  8021b2:	eb 08                	jmp    8021bc <insert_sorted_allocList+0x60>
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	a3 44 40 80 00       	mov    %eax,0x804044
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	a3 40 40 80 00       	mov    %eax,0x804040
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ce:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021d3:	40                   	inc    %eax
  8021d4:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8021d9:	e9 7b 01 00 00       	jmp    802359 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8021de:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8021e6:	a1 40 40 80 00       	mov    0x804040,%eax
  8021eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	8b 50 08             	mov    0x8(%eax),%edx
  8021f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021f7:	8b 40 08             	mov    0x8(%eax),%eax
  8021fa:	39 c2                	cmp    %eax,%edx
  8021fc:	76 65                	jbe    802263 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8021fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802202:	75 14                	jne    802218 <insert_sorted_allocList+0xbc>
  802204:	83 ec 04             	sub    $0x4,%esp
  802207:	68 ac 3c 80 00       	push   $0x803cac
  80220c:	6a 64                	push   $0x64
  80220e:	68 93 3c 80 00       	push   $0x803c93
  802213:	e8 b6 e0 ff ff       	call   8002ce <_panic>
  802218:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	89 50 04             	mov    %edx,0x4(%eax)
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	8b 40 04             	mov    0x4(%eax),%eax
  80222a:	85 c0                	test   %eax,%eax
  80222c:	74 0c                	je     80223a <insert_sorted_allocList+0xde>
  80222e:	a1 44 40 80 00       	mov    0x804044,%eax
  802233:	8b 55 08             	mov    0x8(%ebp),%edx
  802236:	89 10                	mov    %edx,(%eax)
  802238:	eb 08                	jmp    802242 <insert_sorted_allocList+0xe6>
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	a3 40 40 80 00       	mov    %eax,0x804040
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	a3 44 40 80 00       	mov    %eax,0x804044
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802253:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802258:	40                   	inc    %eax
  802259:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80225e:	e9 f6 00 00 00       	jmp    802359 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	8b 50 08             	mov    0x8(%eax),%edx
  802269:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80226c:	8b 40 08             	mov    0x8(%eax),%eax
  80226f:	39 c2                	cmp    %eax,%edx
  802271:	73 65                	jae    8022d8 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802273:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802277:	75 14                	jne    80228d <insert_sorted_allocList+0x131>
  802279:	83 ec 04             	sub    $0x4,%esp
  80227c:	68 70 3c 80 00       	push   $0x803c70
  802281:	6a 68                	push   $0x68
  802283:	68 93 3c 80 00       	push   $0x803c93
  802288:	e8 41 e0 ff ff       	call   8002ce <_panic>
  80228d:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	89 10                	mov    %edx,(%eax)
  802298:	8b 45 08             	mov    0x8(%ebp),%eax
  80229b:	8b 00                	mov    (%eax),%eax
  80229d:	85 c0                	test   %eax,%eax
  80229f:	74 0d                	je     8022ae <insert_sorted_allocList+0x152>
  8022a1:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a9:	89 50 04             	mov    %edx,0x4(%eax)
  8022ac:	eb 08                	jmp    8022b6 <insert_sorted_allocList+0x15a>
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b9:	a3 40 40 80 00       	mov    %eax,0x804040
  8022be:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022c8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022cd:	40                   	inc    %eax
  8022ce:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022d3:	e9 81 00 00 00       	jmp    802359 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022d8:	a1 40 40 80 00       	mov    0x804040,%eax
  8022dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e0:	eb 51                	jmp    802333 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8022e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e5:	8b 50 08             	mov    0x8(%eax),%edx
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ee:	39 c2                	cmp    %eax,%edx
  8022f0:	73 39                	jae    80232b <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8022f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f5:	8b 40 04             	mov    0x4(%eax),%eax
  8022f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8022fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802301:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802303:	8b 45 08             	mov    0x8(%ebp),%eax
  802306:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802309:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802312:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802317:	8b 55 08             	mov    0x8(%ebp),%edx
  80231a:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80231d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802322:	40                   	inc    %eax
  802323:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802328:	90                   	nop
				}
			}
		 }

	}
}
  802329:	eb 2e                	jmp    802359 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80232b:	a1 48 40 80 00       	mov    0x804048,%eax
  802330:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802337:	74 07                	je     802340 <insert_sorted_allocList+0x1e4>
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	8b 00                	mov    (%eax),%eax
  80233e:	eb 05                	jmp    802345 <insert_sorted_allocList+0x1e9>
  802340:	b8 00 00 00 00       	mov    $0x0,%eax
  802345:	a3 48 40 80 00       	mov    %eax,0x804048
  80234a:	a1 48 40 80 00       	mov    0x804048,%eax
  80234f:	85 c0                	test   %eax,%eax
  802351:	75 8f                	jne    8022e2 <insert_sorted_allocList+0x186>
  802353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802357:	75 89                	jne    8022e2 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802359:	90                   	nop
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802362:	a1 38 41 80 00       	mov    0x804138,%eax
  802367:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80236a:	e9 76 01 00 00       	jmp    8024e5 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 40 0c             	mov    0xc(%eax),%eax
  802375:	3b 45 08             	cmp    0x8(%ebp),%eax
  802378:	0f 85 8a 00 00 00    	jne    802408 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80237e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802382:	75 17                	jne    80239b <alloc_block_FF+0x3f>
  802384:	83 ec 04             	sub    $0x4,%esp
  802387:	68 cf 3c 80 00       	push   $0x803ccf
  80238c:	68 8a 00 00 00       	push   $0x8a
  802391:	68 93 3c 80 00       	push   $0x803c93
  802396:	e8 33 df ff ff       	call   8002ce <_panic>
  80239b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239e:	8b 00                	mov    (%eax),%eax
  8023a0:	85 c0                	test   %eax,%eax
  8023a2:	74 10                	je     8023b4 <alloc_block_FF+0x58>
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 00                	mov    (%eax),%eax
  8023a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ac:	8b 52 04             	mov    0x4(%edx),%edx
  8023af:	89 50 04             	mov    %edx,0x4(%eax)
  8023b2:	eb 0b                	jmp    8023bf <alloc_block_FF+0x63>
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 40 04             	mov    0x4(%eax),%eax
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	74 0f                	je     8023d8 <alloc_block_FF+0x7c>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 40 04             	mov    0x4(%eax),%eax
  8023cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d2:	8b 12                	mov    (%edx),%edx
  8023d4:	89 10                	mov    %edx,(%eax)
  8023d6:	eb 0a                	jmp    8023e2 <alloc_block_FF+0x86>
  8023d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023db:	8b 00                	mov    (%eax),%eax
  8023dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f5:	a1 44 41 80 00       	mov    0x804144,%eax
  8023fa:	48                   	dec    %eax
  8023fb:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802403:	e9 10 01 00 00       	jmp    802518 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 40 0c             	mov    0xc(%eax),%eax
  80240e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802411:	0f 86 c6 00 00 00    	jbe    8024dd <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802417:	a1 48 41 80 00       	mov    0x804148,%eax
  80241c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80241f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802423:	75 17                	jne    80243c <alloc_block_FF+0xe0>
  802425:	83 ec 04             	sub    $0x4,%esp
  802428:	68 cf 3c 80 00       	push   $0x803ccf
  80242d:	68 90 00 00 00       	push   $0x90
  802432:	68 93 3c 80 00       	push   $0x803c93
  802437:	e8 92 de ff ff       	call   8002ce <_panic>
  80243c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243f:	8b 00                	mov    (%eax),%eax
  802441:	85 c0                	test   %eax,%eax
  802443:	74 10                	je     802455 <alloc_block_FF+0xf9>
  802445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802448:	8b 00                	mov    (%eax),%eax
  80244a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80244d:	8b 52 04             	mov    0x4(%edx),%edx
  802450:	89 50 04             	mov    %edx,0x4(%eax)
  802453:	eb 0b                	jmp    802460 <alloc_block_FF+0x104>
  802455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802458:	8b 40 04             	mov    0x4(%eax),%eax
  80245b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802463:	8b 40 04             	mov    0x4(%eax),%eax
  802466:	85 c0                	test   %eax,%eax
  802468:	74 0f                	je     802479 <alloc_block_FF+0x11d>
  80246a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246d:	8b 40 04             	mov    0x4(%eax),%eax
  802470:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802473:	8b 12                	mov    (%edx),%edx
  802475:	89 10                	mov    %edx,(%eax)
  802477:	eb 0a                	jmp    802483 <alloc_block_FF+0x127>
  802479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247c:	8b 00                	mov    (%eax),%eax
  80247e:	a3 48 41 80 00       	mov    %eax,0x804148
  802483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802486:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802496:	a1 54 41 80 00       	mov    0x804154,%eax
  80249b:	48                   	dec    %eax
  80249c:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8024a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8024a7:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 50 08             	mov    0x8(%eax),%edx
  8024b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b3:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 50 08             	mov    0x8(%eax),%edx
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	01 c2                	add    %eax,%edx
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8024c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8024d0:	89 c2                	mov    %eax,%edx
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8024d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024db:	eb 3b                	jmp    802518 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8024dd:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e9:	74 07                	je     8024f2 <alloc_block_FF+0x196>
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 00                	mov    (%eax),%eax
  8024f0:	eb 05                	jmp    8024f7 <alloc_block_FF+0x19b>
  8024f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f7:	a3 40 41 80 00       	mov    %eax,0x804140
  8024fc:	a1 40 41 80 00       	mov    0x804140,%eax
  802501:	85 c0                	test   %eax,%eax
  802503:	0f 85 66 fe ff ff    	jne    80236f <alloc_block_FF+0x13>
  802509:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250d:	0f 85 5c fe ff ff    	jne    80236f <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802513:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802518:	c9                   	leave  
  802519:	c3                   	ret    

0080251a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80251a:	55                   	push   %ebp
  80251b:	89 e5                	mov    %esp,%ebp
  80251d:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802520:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802527:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  80252e:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802535:	a1 38 41 80 00       	mov    0x804138,%eax
  80253a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80253d:	e9 cf 00 00 00       	jmp    802611 <alloc_block_BF+0xf7>
		{
			c++;
  802542:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 40 0c             	mov    0xc(%eax),%eax
  80254b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80254e:	0f 85 8a 00 00 00    	jne    8025de <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802554:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802558:	75 17                	jne    802571 <alloc_block_BF+0x57>
  80255a:	83 ec 04             	sub    $0x4,%esp
  80255d:	68 cf 3c 80 00       	push   $0x803ccf
  802562:	68 a8 00 00 00       	push   $0xa8
  802567:	68 93 3c 80 00       	push   $0x803c93
  80256c:	e8 5d dd ff ff       	call   8002ce <_panic>
  802571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802574:	8b 00                	mov    (%eax),%eax
  802576:	85 c0                	test   %eax,%eax
  802578:	74 10                	je     80258a <alloc_block_BF+0x70>
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	8b 00                	mov    (%eax),%eax
  80257f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802582:	8b 52 04             	mov    0x4(%edx),%edx
  802585:	89 50 04             	mov    %edx,0x4(%eax)
  802588:	eb 0b                	jmp    802595 <alloc_block_BF+0x7b>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 40 04             	mov    0x4(%eax),%eax
  802590:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 40 04             	mov    0x4(%eax),%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	74 0f                	je     8025ae <alloc_block_BF+0x94>
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 40 04             	mov    0x4(%eax),%eax
  8025a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a8:	8b 12                	mov    (%edx),%edx
  8025aa:	89 10                	mov    %edx,(%eax)
  8025ac:	eb 0a                	jmp    8025b8 <alloc_block_BF+0x9e>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	a3 38 41 80 00       	mov    %eax,0x804138
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cb:	a1 44 41 80 00       	mov    0x804144,%eax
  8025d0:	48                   	dec    %eax
  8025d1:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d9:	e9 85 01 00 00       	jmp    802763 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8025de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025e7:	76 20                	jbe    802609 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8025e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ef:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f2:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8025f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025fb:	73 0c                	jae    802609 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8025fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802600:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802603:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802606:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802609:	a1 40 41 80 00       	mov    0x804140,%eax
  80260e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802615:	74 07                	je     80261e <alloc_block_BF+0x104>
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	eb 05                	jmp    802623 <alloc_block_BF+0x109>
  80261e:	b8 00 00 00 00       	mov    $0x0,%eax
  802623:	a3 40 41 80 00       	mov    %eax,0x804140
  802628:	a1 40 41 80 00       	mov    0x804140,%eax
  80262d:	85 c0                	test   %eax,%eax
  80262f:	0f 85 0d ff ff ff    	jne    802542 <alloc_block_BF+0x28>
  802635:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802639:	0f 85 03 ff ff ff    	jne    802542 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80263f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802646:	a1 38 41 80 00       	mov    0x804138,%eax
  80264b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80264e:	e9 dd 00 00 00       	jmp    802730 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802653:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802656:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802659:	0f 85 c6 00 00 00    	jne    802725 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80265f:	a1 48 41 80 00       	mov    0x804148,%eax
  802664:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802667:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80266b:	75 17                	jne    802684 <alloc_block_BF+0x16a>
  80266d:	83 ec 04             	sub    $0x4,%esp
  802670:	68 cf 3c 80 00       	push   $0x803ccf
  802675:	68 bb 00 00 00       	push   $0xbb
  80267a:	68 93 3c 80 00       	push   $0x803c93
  80267f:	e8 4a dc ff ff       	call   8002ce <_panic>
  802684:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802687:	8b 00                	mov    (%eax),%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	74 10                	je     80269d <alloc_block_BF+0x183>
  80268d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802690:	8b 00                	mov    (%eax),%eax
  802692:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802695:	8b 52 04             	mov    0x4(%edx),%edx
  802698:	89 50 04             	mov    %edx,0x4(%eax)
  80269b:	eb 0b                	jmp    8026a8 <alloc_block_BF+0x18e>
  80269d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a0:	8b 40 04             	mov    0x4(%eax),%eax
  8026a3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ab:	8b 40 04             	mov    0x4(%eax),%eax
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	74 0f                	je     8026c1 <alloc_block_BF+0x1a7>
  8026b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b5:	8b 40 04             	mov    0x4(%eax),%eax
  8026b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026bb:	8b 12                	mov    (%edx),%edx
  8026bd:	89 10                	mov    %edx,(%eax)
  8026bf:	eb 0a                	jmp    8026cb <alloc_block_BF+0x1b1>
  8026c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	a3 48 41 80 00       	mov    %eax,0x804148
  8026cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026de:	a1 54 41 80 00       	mov    0x804154,%eax
  8026e3:	48                   	dec    %eax
  8026e4:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8026e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ef:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	8b 50 08             	mov    0x8(%eax),%edx
  8026f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fb:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 50 08             	mov    0x8(%eax),%edx
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	01 c2                	add    %eax,%edx
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	8b 40 0c             	mov    0xc(%eax),%eax
  802715:	2b 45 08             	sub    0x8(%ebp),%eax
  802718:	89 c2                	mov    %eax,%edx
  80271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271d:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802720:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802723:	eb 3e                	jmp    802763 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802725:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802728:	a1 40 41 80 00       	mov    0x804140,%eax
  80272d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802730:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802734:	74 07                	je     80273d <alloc_block_BF+0x223>
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 00                	mov    (%eax),%eax
  80273b:	eb 05                	jmp    802742 <alloc_block_BF+0x228>
  80273d:	b8 00 00 00 00       	mov    $0x0,%eax
  802742:	a3 40 41 80 00       	mov    %eax,0x804140
  802747:	a1 40 41 80 00       	mov    0x804140,%eax
  80274c:	85 c0                	test   %eax,%eax
  80274e:	0f 85 ff fe ff ff    	jne    802653 <alloc_block_BF+0x139>
  802754:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802758:	0f 85 f5 fe ff ff    	jne    802653 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80275e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802763:	c9                   	leave  
  802764:	c3                   	ret    

00802765 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802765:	55                   	push   %ebp
  802766:	89 e5                	mov    %esp,%ebp
  802768:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80276b:	a1 28 40 80 00       	mov    0x804028,%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	75 14                	jne    802788 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802774:	a1 38 41 80 00       	mov    0x804138,%eax
  802779:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  80277e:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802785:	00 00 00 
	}
	uint32 c=1;
  802788:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80278f:	a1 60 41 80 00       	mov    0x804160,%eax
  802794:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802797:	e9 b3 01 00 00       	jmp    80294f <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80279c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279f:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027a5:	0f 85 a9 00 00 00    	jne    802854 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8027ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ae:	8b 00                	mov    (%eax),%eax
  8027b0:	85 c0                	test   %eax,%eax
  8027b2:	75 0c                	jne    8027c0 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8027b4:	a1 38 41 80 00       	mov    0x804138,%eax
  8027b9:	a3 60 41 80 00       	mov    %eax,0x804160
  8027be:	eb 0a                	jmp    8027ca <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8027c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c3:	8b 00                	mov    (%eax),%eax
  8027c5:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8027ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027ce:	75 17                	jne    8027e7 <alloc_block_NF+0x82>
  8027d0:	83 ec 04             	sub    $0x4,%esp
  8027d3:	68 cf 3c 80 00       	push   $0x803ccf
  8027d8:	68 e3 00 00 00       	push   $0xe3
  8027dd:	68 93 3c 80 00       	push   $0x803c93
  8027e2:	e8 e7 da ff ff       	call   8002ce <_panic>
  8027e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ea:	8b 00                	mov    (%eax),%eax
  8027ec:	85 c0                	test   %eax,%eax
  8027ee:	74 10                	je     802800 <alloc_block_NF+0x9b>
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	8b 00                	mov    (%eax),%eax
  8027f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027f8:	8b 52 04             	mov    0x4(%edx),%edx
  8027fb:	89 50 04             	mov    %edx,0x4(%eax)
  8027fe:	eb 0b                	jmp    80280b <alloc_block_NF+0xa6>
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	8b 40 04             	mov    0x4(%eax),%eax
  802811:	85 c0                	test   %eax,%eax
  802813:	74 0f                	je     802824 <alloc_block_NF+0xbf>
  802815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802818:	8b 40 04             	mov    0x4(%eax),%eax
  80281b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80281e:	8b 12                	mov    (%edx),%edx
  802820:	89 10                	mov    %edx,(%eax)
  802822:	eb 0a                	jmp    80282e <alloc_block_NF+0xc9>
  802824:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802827:	8b 00                	mov    (%eax),%eax
  802829:	a3 38 41 80 00       	mov    %eax,0x804138
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802841:	a1 44 41 80 00       	mov    0x804144,%eax
  802846:	48                   	dec    %eax
  802847:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  80284c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284f:	e9 0e 01 00 00       	jmp    802962 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802854:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802857:	8b 40 0c             	mov    0xc(%eax),%eax
  80285a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80285d:	0f 86 ce 00 00 00    	jbe    802931 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802863:	a1 48 41 80 00       	mov    0x804148,%eax
  802868:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80286b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80286f:	75 17                	jne    802888 <alloc_block_NF+0x123>
  802871:	83 ec 04             	sub    $0x4,%esp
  802874:	68 cf 3c 80 00       	push   $0x803ccf
  802879:	68 e9 00 00 00       	push   $0xe9
  80287e:	68 93 3c 80 00       	push   $0x803c93
  802883:	e8 46 da ff ff       	call   8002ce <_panic>
  802888:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288b:	8b 00                	mov    (%eax),%eax
  80288d:	85 c0                	test   %eax,%eax
  80288f:	74 10                	je     8028a1 <alloc_block_NF+0x13c>
  802891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802894:	8b 00                	mov    (%eax),%eax
  802896:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802899:	8b 52 04             	mov    0x4(%edx),%edx
  80289c:	89 50 04             	mov    %edx,0x4(%eax)
  80289f:	eb 0b                	jmp    8028ac <alloc_block_NF+0x147>
  8028a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a4:	8b 40 04             	mov    0x4(%eax),%eax
  8028a7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028af:	8b 40 04             	mov    0x4(%eax),%eax
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	74 0f                	je     8028c5 <alloc_block_NF+0x160>
  8028b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028bf:	8b 12                	mov    (%edx),%edx
  8028c1:	89 10                	mov    %edx,(%eax)
  8028c3:	eb 0a                	jmp    8028cf <alloc_block_NF+0x16a>
  8028c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c8:	8b 00                	mov    (%eax),%eax
  8028ca:	a3 48 41 80 00       	mov    %eax,0x804148
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028e2:	a1 54 41 80 00       	mov    0x804154,%eax
  8028e7:	48                   	dec    %eax
  8028e8:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8028ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f3:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	8b 50 08             	mov    0x8(%eax),%edx
  8028fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ff:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	8b 50 08             	mov    0x8(%eax),%edx
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	01 c2                	add    %eax,%edx
  80290d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802910:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	8b 40 0c             	mov    0xc(%eax),%eax
  802919:	2b 45 08             	sub    0x8(%ebp),%eax
  80291c:	89 c2                	mov    %eax,%edx
  80291e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802921:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802924:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802927:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  80292c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292f:	eb 31                	jmp    802962 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802931:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802937:	8b 00                	mov    (%eax),%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	75 0a                	jne    802947 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  80293d:	a1 38 41 80 00       	mov    0x804138,%eax
  802942:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802945:	eb 08                	jmp    80294f <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802947:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80294f:	a1 44 41 80 00       	mov    0x804144,%eax
  802954:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802957:	0f 85 3f fe ff ff    	jne    80279c <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  80295d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802962:	c9                   	leave  
  802963:	c3                   	ret    

00802964 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802964:	55                   	push   %ebp
  802965:	89 e5                	mov    %esp,%ebp
  802967:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80296a:	a1 44 41 80 00       	mov    0x804144,%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	75 68                	jne    8029db <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802973:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802977:	75 17                	jne    802990 <insert_sorted_with_merge_freeList+0x2c>
  802979:	83 ec 04             	sub    $0x4,%esp
  80297c:	68 70 3c 80 00       	push   $0x803c70
  802981:	68 0e 01 00 00       	push   $0x10e
  802986:	68 93 3c 80 00       	push   $0x803c93
  80298b:	e8 3e d9 ff ff       	call   8002ce <_panic>
  802990:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	89 10                	mov    %edx,(%eax)
  80299b:	8b 45 08             	mov    0x8(%ebp),%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	74 0d                	je     8029b1 <insert_sorted_with_merge_freeList+0x4d>
  8029a4:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ac:	89 50 04             	mov    %edx,0x4(%eax)
  8029af:	eb 08                	jmp    8029b9 <insert_sorted_with_merge_freeList+0x55>
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bc:	a3 38 41 80 00       	mov    %eax,0x804138
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029cb:	a1 44 41 80 00       	mov    0x804144,%eax
  8029d0:	40                   	inc    %eax
  8029d1:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8029d6:	e9 8c 06 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8029db:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8029e3:	a1 38 41 80 00       	mov    0x804138,%eax
  8029e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	8b 50 08             	mov    0x8(%eax),%edx
  8029f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f4:	8b 40 08             	mov    0x8(%eax),%eax
  8029f7:	39 c2                	cmp    %eax,%edx
  8029f9:	0f 86 14 01 00 00    	jbe    802b13 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8029ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a02:	8b 50 0c             	mov    0xc(%eax),%edx
  802a05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a08:	8b 40 08             	mov    0x8(%eax),%eax
  802a0b:	01 c2                	add    %eax,%edx
  802a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a10:	8b 40 08             	mov    0x8(%eax),%eax
  802a13:	39 c2                	cmp    %eax,%edx
  802a15:	0f 85 90 00 00 00    	jne    802aab <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1e:	8b 50 0c             	mov    0xc(%eax),%edx
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 40 0c             	mov    0xc(%eax),%eax
  802a27:	01 c2                	add    %eax,%edx
  802a29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a2c:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802a39:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a47:	75 17                	jne    802a60 <insert_sorted_with_merge_freeList+0xfc>
  802a49:	83 ec 04             	sub    $0x4,%esp
  802a4c:	68 70 3c 80 00       	push   $0x803c70
  802a51:	68 1b 01 00 00       	push   $0x11b
  802a56:	68 93 3c 80 00       	push   $0x803c93
  802a5b:	e8 6e d8 ff ff       	call   8002ce <_panic>
  802a60:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	89 10                	mov    %edx,(%eax)
  802a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6e:	8b 00                	mov    (%eax),%eax
  802a70:	85 c0                	test   %eax,%eax
  802a72:	74 0d                	je     802a81 <insert_sorted_with_merge_freeList+0x11d>
  802a74:	a1 48 41 80 00       	mov    0x804148,%eax
  802a79:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7c:	89 50 04             	mov    %edx,0x4(%eax)
  802a7f:	eb 08                	jmp    802a89 <insert_sorted_with_merge_freeList+0x125>
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	a3 48 41 80 00       	mov    %eax,0x804148
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9b:	a1 54 41 80 00       	mov    0x804154,%eax
  802aa0:	40                   	inc    %eax
  802aa1:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802aa6:	e9 bc 05 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802aab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aaf:	75 17                	jne    802ac8 <insert_sorted_with_merge_freeList+0x164>
  802ab1:	83 ec 04             	sub    $0x4,%esp
  802ab4:	68 ac 3c 80 00       	push   $0x803cac
  802ab9:	68 1f 01 00 00       	push   $0x11f
  802abe:	68 93 3c 80 00       	push   $0x803c93
  802ac3:	e8 06 d8 ff ff       	call   8002ce <_panic>
  802ac8:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ace:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad1:	89 50 04             	mov    %edx,0x4(%eax)
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	74 0c                	je     802aea <insert_sorted_with_merge_freeList+0x186>
  802ade:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae6:	89 10                	mov    %edx,(%eax)
  802ae8:	eb 08                	jmp    802af2 <insert_sorted_with_merge_freeList+0x18e>
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	a3 38 41 80 00       	mov    %eax,0x804138
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b03:	a1 44 41 80 00       	mov    0x804144,%eax
  802b08:	40                   	inc    %eax
  802b09:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802b0e:	e9 54 05 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	8b 50 08             	mov    0x8(%eax),%edx
  802b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b1c:	8b 40 08             	mov    0x8(%eax),%eax
  802b1f:	39 c2                	cmp    %eax,%edx
  802b21:	0f 83 20 01 00 00    	jae    802c47 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	8b 40 08             	mov    0x8(%eax),%eax
  802b33:	01 c2                	add    %eax,%edx
  802b35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b38:	8b 40 08             	mov    0x8(%eax),%eax
  802b3b:	39 c2                	cmp    %eax,%edx
  802b3d:	0f 85 9c 00 00 00    	jne    802bdf <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	8b 50 08             	mov    0x8(%eax),%edx
  802b49:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4c:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b52:	8b 50 0c             	mov    0xc(%eax),%edx
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5b:	01 c2                	add    %eax,%edx
  802b5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b60:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7b:	75 17                	jne    802b94 <insert_sorted_with_merge_freeList+0x230>
  802b7d:	83 ec 04             	sub    $0x4,%esp
  802b80:	68 70 3c 80 00       	push   $0x803c70
  802b85:	68 2a 01 00 00       	push   $0x12a
  802b8a:	68 93 3c 80 00       	push   $0x803c93
  802b8f:	e8 3a d7 ff ff       	call   8002ce <_panic>
  802b94:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	89 10                	mov    %edx,(%eax)
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0d                	je     802bb5 <insert_sorted_with_merge_freeList+0x251>
  802ba8:	a1 48 41 80 00       	mov    0x804148,%eax
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	eb 08                	jmp    802bbd <insert_sorted_with_merge_freeList+0x259>
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	a3 48 41 80 00       	mov    %eax,0x804148
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcf:	a1 54 41 80 00       	mov    0x804154,%eax
  802bd4:	40                   	inc    %eax
  802bd5:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802bda:	e9 88 04 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be3:	75 17                	jne    802bfc <insert_sorted_with_merge_freeList+0x298>
  802be5:	83 ec 04             	sub    $0x4,%esp
  802be8:	68 70 3c 80 00       	push   $0x803c70
  802bed:	68 2e 01 00 00       	push   $0x12e
  802bf2:	68 93 3c 80 00       	push   $0x803c93
  802bf7:	e8 d2 d6 ff ff       	call   8002ce <_panic>
  802bfc:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	89 10                	mov    %edx,(%eax)
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0d                	je     802c1d <insert_sorted_with_merge_freeList+0x2b9>
  802c10:	a1 38 41 80 00       	mov    0x804138,%eax
  802c15:	8b 55 08             	mov    0x8(%ebp),%edx
  802c18:	89 50 04             	mov    %edx,0x4(%eax)
  802c1b:	eb 08                	jmp    802c25 <insert_sorted_with_merge_freeList+0x2c1>
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	a3 38 41 80 00       	mov    %eax,0x804138
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c37:	a1 44 41 80 00       	mov    0x804144,%eax
  802c3c:	40                   	inc    %eax
  802c3d:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c42:	e9 20 04 00 00       	jmp    803067 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802c47:	a1 38 41 80 00       	mov    0x804138,%eax
  802c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c4f:	e9 e2 03 00 00       	jmp    803036 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	8b 50 08             	mov    0x8(%eax),%edx
  802c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5d:	8b 40 08             	mov    0x8(%eax),%eax
  802c60:	39 c2                	cmp    %eax,%edx
  802c62:	0f 83 c6 03 00 00    	jae    80302e <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6b:	8b 40 04             	mov    0x4(%eax),%eax
  802c6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c74:	8b 50 08             	mov    0x8(%eax),%edx
  802c77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7d:	01 d0                	add    %edx,%eax
  802c7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	8b 50 0c             	mov    0xc(%eax),%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	8b 40 08             	mov    0x8(%eax),%eax
  802c8e:	01 d0                	add    %edx,%eax
  802c90:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	8b 40 08             	mov    0x8(%eax),%eax
  802c99:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c9c:	74 7a                	je     802d18 <insert_sorted_with_merge_freeList+0x3b4>
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 40 08             	mov    0x8(%eax),%eax
  802ca4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ca7:	74 6f                	je     802d18 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802ca9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cad:	74 06                	je     802cb5 <insert_sorted_with_merge_freeList+0x351>
  802caf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb3:	75 17                	jne    802ccc <insert_sorted_with_merge_freeList+0x368>
  802cb5:	83 ec 04             	sub    $0x4,%esp
  802cb8:	68 f0 3c 80 00       	push   $0x803cf0
  802cbd:	68 43 01 00 00       	push   $0x143
  802cc2:	68 93 3c 80 00       	push   $0x803c93
  802cc7:	e8 02 d6 ff ff       	call   8002ce <_panic>
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 50 04             	mov    0x4(%eax),%edx
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	89 50 04             	mov    %edx,0x4(%eax)
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cde:	89 10                	mov    %edx,(%eax)
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 40 04             	mov    0x4(%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	74 0d                	je     802cf7 <insert_sorted_with_merge_freeList+0x393>
  802cea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ced:	8b 40 04             	mov    0x4(%eax),%eax
  802cf0:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf3:	89 10                	mov    %edx,(%eax)
  802cf5:	eb 08                	jmp    802cff <insert_sorted_with_merge_freeList+0x39b>
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	a3 38 41 80 00       	mov    %eax,0x804138
  802cff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d02:	8b 55 08             	mov    0x8(%ebp),%edx
  802d05:	89 50 04             	mov    %edx,0x4(%eax)
  802d08:	a1 44 41 80 00       	mov    0x804144,%eax
  802d0d:	40                   	inc    %eax
  802d0e:	a3 44 41 80 00       	mov    %eax,0x804144
  802d13:	e9 14 03 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	8b 40 08             	mov    0x8(%eax),%eax
  802d1e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d21:	0f 85 a0 01 00 00    	jne    802ec7 <insert_sorted_with_merge_freeList+0x563>
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	8b 40 08             	mov    0x8(%eax),%eax
  802d2d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d30:	0f 85 91 01 00 00    	jne    802ec7 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d39:	8b 50 0c             	mov    0xc(%eax),%edx
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 0c             	mov    0xc(%eax),%eax
  802d48:	01 c8                	add    %ecx,%eax
  802d4a:	01 c2                	add    %eax,%edx
  802d4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4f:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d7e:	75 17                	jne    802d97 <insert_sorted_with_merge_freeList+0x433>
  802d80:	83 ec 04             	sub    $0x4,%esp
  802d83:	68 70 3c 80 00       	push   $0x803c70
  802d88:	68 4d 01 00 00       	push   $0x14d
  802d8d:	68 93 3c 80 00       	push   $0x803c93
  802d92:	e8 37 d5 ff ff       	call   8002ce <_panic>
  802d97:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	74 0d                	je     802db8 <insert_sorted_with_merge_freeList+0x454>
  802dab:	a1 48 41 80 00       	mov    0x804148,%eax
  802db0:	8b 55 08             	mov    0x8(%ebp),%edx
  802db3:	89 50 04             	mov    %edx,0x4(%eax)
  802db6:	eb 08                	jmp    802dc0 <insert_sorted_with_merge_freeList+0x45c>
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc3:	a3 48 41 80 00       	mov    %eax,0x804148
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd2:	a1 54 41 80 00       	mov    0x804154,%eax
  802dd7:	40                   	inc    %eax
  802dd8:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802ddd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de1:	75 17                	jne    802dfa <insert_sorted_with_merge_freeList+0x496>
  802de3:	83 ec 04             	sub    $0x4,%esp
  802de6:	68 cf 3c 80 00       	push   $0x803ccf
  802deb:	68 4e 01 00 00       	push   $0x14e
  802df0:	68 93 3c 80 00       	push   $0x803c93
  802df5:	e8 d4 d4 ff ff       	call   8002ce <_panic>
  802dfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfd:	8b 00                	mov    (%eax),%eax
  802dff:	85 c0                	test   %eax,%eax
  802e01:	74 10                	je     802e13 <insert_sorted_with_merge_freeList+0x4af>
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	8b 00                	mov    (%eax),%eax
  802e08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e0b:	8b 52 04             	mov    0x4(%edx),%edx
  802e0e:	89 50 04             	mov    %edx,0x4(%eax)
  802e11:	eb 0b                	jmp    802e1e <insert_sorted_with_merge_freeList+0x4ba>
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 40 04             	mov    0x4(%eax),%eax
  802e19:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	74 0f                	je     802e37 <insert_sorted_with_merge_freeList+0x4d3>
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 40 04             	mov    0x4(%eax),%eax
  802e2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e31:	8b 12                	mov    (%edx),%edx
  802e33:	89 10                	mov    %edx,(%eax)
  802e35:	eb 0a                	jmp    802e41 <insert_sorted_with_merge_freeList+0x4dd>
  802e37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3a:	8b 00                	mov    (%eax),%eax
  802e3c:	a3 38 41 80 00       	mov    %eax,0x804138
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e54:	a1 44 41 80 00       	mov    0x804144,%eax
  802e59:	48                   	dec    %eax
  802e5a:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e63:	75 17                	jne    802e7c <insert_sorted_with_merge_freeList+0x518>
  802e65:	83 ec 04             	sub    $0x4,%esp
  802e68:	68 70 3c 80 00       	push   $0x803c70
  802e6d:	68 4f 01 00 00       	push   $0x14f
  802e72:	68 93 3c 80 00       	push   $0x803c93
  802e77:	e8 52 d4 ff ff       	call   8002ce <_panic>
  802e7c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	89 10                	mov    %edx,(%eax)
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 00                	mov    (%eax),%eax
  802e8c:	85 c0                	test   %eax,%eax
  802e8e:	74 0d                	je     802e9d <insert_sorted_with_merge_freeList+0x539>
  802e90:	a1 48 41 80 00       	mov    0x804148,%eax
  802e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e98:	89 50 04             	mov    %edx,0x4(%eax)
  802e9b:	eb 08                	jmp    802ea5 <insert_sorted_with_merge_freeList+0x541>
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	a3 48 41 80 00       	mov    %eax,0x804148
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb7:	a1 54 41 80 00       	mov    0x804154,%eax
  802ebc:	40                   	inc    %eax
  802ebd:	a3 54 41 80 00       	mov    %eax,0x804154
  802ec2:	e9 65 01 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	8b 40 08             	mov    0x8(%eax),%eax
  802ecd:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ed0:	0f 85 9f 00 00 00    	jne    802f75 <insert_sorted_with_merge_freeList+0x611>
  802ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed9:	8b 40 08             	mov    0x8(%eax),%eax
  802edc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802edf:	0f 84 90 00 00 00    	je     802f75 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802ee5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee8:	8b 50 0c             	mov    0xc(%eax),%edx
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	8b 40 0c             	mov    0xc(%eax),%eax
  802ef1:	01 c2                	add    %eax,%edx
  802ef3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef6:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  802efc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f11:	75 17                	jne    802f2a <insert_sorted_with_merge_freeList+0x5c6>
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 70 3c 80 00       	push   $0x803c70
  802f1b:	68 58 01 00 00       	push   $0x158
  802f20:	68 93 3c 80 00       	push   $0x803c93
  802f25:	e8 a4 d3 ff ff       	call   8002ce <_panic>
  802f2a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f30:	8b 45 08             	mov    0x8(%ebp),%eax
  802f33:	89 10                	mov    %edx,(%eax)
  802f35:	8b 45 08             	mov    0x8(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	74 0d                	je     802f4b <insert_sorted_with_merge_freeList+0x5e7>
  802f3e:	a1 48 41 80 00       	mov    0x804148,%eax
  802f43:	8b 55 08             	mov    0x8(%ebp),%edx
  802f46:	89 50 04             	mov    %edx,0x4(%eax)
  802f49:	eb 08                	jmp    802f53 <insert_sorted_with_merge_freeList+0x5ef>
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	a3 48 41 80 00       	mov    %eax,0x804148
  802f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f65:	a1 54 41 80 00       	mov    0x804154,%eax
  802f6a:	40                   	inc    %eax
  802f6b:	a3 54 41 80 00       	mov    %eax,0x804154
  802f70:	e9 b7 00 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	8b 40 08             	mov    0x8(%eax),%eax
  802f7b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f7e:	0f 84 e2 00 00 00    	je     803066 <insert_sorted_with_merge_freeList+0x702>
  802f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f87:	8b 40 08             	mov    0x8(%eax),%eax
  802f8a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f8d:	0f 85 d3 00 00 00    	jne    803066 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	8b 50 08             	mov    0x8(%eax),%edx
  802f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9c:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 50 0c             	mov    0xc(%eax),%edx
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	8b 40 0c             	mov    0xc(%eax),%eax
  802fab:	01 c2                	add    %eax,%edx
  802fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb0:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fcb:	75 17                	jne    802fe4 <insert_sorted_with_merge_freeList+0x680>
  802fcd:	83 ec 04             	sub    $0x4,%esp
  802fd0:	68 70 3c 80 00       	push   $0x803c70
  802fd5:	68 61 01 00 00       	push   $0x161
  802fda:	68 93 3c 80 00       	push   $0x803c93
  802fdf:	e8 ea d2 ff ff       	call   8002ce <_panic>
  802fe4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fea:	8b 45 08             	mov    0x8(%ebp),%eax
  802fed:	89 10                	mov    %edx,(%eax)
  802fef:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff2:	8b 00                	mov    (%eax),%eax
  802ff4:	85 c0                	test   %eax,%eax
  802ff6:	74 0d                	je     803005 <insert_sorted_with_merge_freeList+0x6a1>
  802ff8:	a1 48 41 80 00       	mov    0x804148,%eax
  802ffd:	8b 55 08             	mov    0x8(%ebp),%edx
  803000:	89 50 04             	mov    %edx,0x4(%eax)
  803003:	eb 08                	jmp    80300d <insert_sorted_with_merge_freeList+0x6a9>
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	a3 48 41 80 00       	mov    %eax,0x804148
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80301f:	a1 54 41 80 00       	mov    0x804154,%eax
  803024:	40                   	inc    %eax
  803025:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  80302a:	eb 3a                	jmp    803066 <insert_sorted_with_merge_freeList+0x702>
  80302c:	eb 38                	jmp    803066 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80302e:	a1 40 41 80 00       	mov    0x804140,%eax
  803033:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803036:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303a:	74 07                	je     803043 <insert_sorted_with_merge_freeList+0x6df>
  80303c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303f:	8b 00                	mov    (%eax),%eax
  803041:	eb 05                	jmp    803048 <insert_sorted_with_merge_freeList+0x6e4>
  803043:	b8 00 00 00 00       	mov    $0x0,%eax
  803048:	a3 40 41 80 00       	mov    %eax,0x804140
  80304d:	a1 40 41 80 00       	mov    0x804140,%eax
  803052:	85 c0                	test   %eax,%eax
  803054:	0f 85 fa fb ff ff    	jne    802c54 <insert_sorted_with_merge_freeList+0x2f0>
  80305a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305e:	0f 85 f0 fb ff ff    	jne    802c54 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803064:	eb 01                	jmp    803067 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803066:	90                   	nop
							}

						}
		          }
		}
}
  803067:	90                   	nop
  803068:	c9                   	leave  
  803069:	c3                   	ret    

0080306a <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80306a:	55                   	push   %ebp
  80306b:	89 e5                	mov    %esp,%ebp
  80306d:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803070:	8b 55 08             	mov    0x8(%ebp),%edx
  803073:	89 d0                	mov    %edx,%eax
  803075:	c1 e0 02             	shl    $0x2,%eax
  803078:	01 d0                	add    %edx,%eax
  80307a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803081:	01 d0                	add    %edx,%eax
  803083:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80308a:	01 d0                	add    %edx,%eax
  80308c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803093:	01 d0                	add    %edx,%eax
  803095:	c1 e0 04             	shl    $0x4,%eax
  803098:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80309b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030a2:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030a5:	83 ec 0c             	sub    $0xc,%esp
  8030a8:	50                   	push   %eax
  8030a9:	e8 9c eb ff ff       	call   801c4a <sys_get_virtual_time>
  8030ae:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030b1:	eb 41                	jmp    8030f4 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030b6:	83 ec 0c             	sub    $0xc,%esp
  8030b9:	50                   	push   %eax
  8030ba:	e8 8b eb ff ff       	call   801c4a <sys_get_virtual_time>
  8030bf:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030c8:	29 c2                	sub    %eax,%edx
  8030ca:	89 d0                	mov    %edx,%eax
  8030cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d5:	89 d1                	mov    %edx,%ecx
  8030d7:	29 c1                	sub    %eax,%ecx
  8030d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030df:	39 c2                	cmp    %eax,%edx
  8030e1:	0f 97 c0             	seta   %al
  8030e4:	0f b6 c0             	movzbl %al,%eax
  8030e7:	29 c1                	sub    %eax,%ecx
  8030e9:	89 c8                	mov    %ecx,%eax
  8030eb:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030fa:	72 b7                	jb     8030b3 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030fc:	90                   	nop
  8030fd:	c9                   	leave  
  8030fe:	c3                   	ret    

008030ff <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030ff:	55                   	push   %ebp
  803100:	89 e5                	mov    %esp,%ebp
  803102:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803105:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80310c:	eb 03                	jmp    803111 <busy_wait+0x12>
  80310e:	ff 45 fc             	incl   -0x4(%ebp)
  803111:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803114:	3b 45 08             	cmp    0x8(%ebp),%eax
  803117:	72 f5                	jb     80310e <busy_wait+0xf>
	return i;
  803119:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80311c:	c9                   	leave  
  80311d:	c3                   	ret    
  80311e:	66 90                	xchg   %ax,%ax

00803120 <__udivdi3>:
  803120:	55                   	push   %ebp
  803121:	57                   	push   %edi
  803122:	56                   	push   %esi
  803123:	53                   	push   %ebx
  803124:	83 ec 1c             	sub    $0x1c,%esp
  803127:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80312b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80312f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803133:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803137:	89 ca                	mov    %ecx,%edx
  803139:	89 f8                	mov    %edi,%eax
  80313b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80313f:	85 f6                	test   %esi,%esi
  803141:	75 2d                	jne    803170 <__udivdi3+0x50>
  803143:	39 cf                	cmp    %ecx,%edi
  803145:	77 65                	ja     8031ac <__udivdi3+0x8c>
  803147:	89 fd                	mov    %edi,%ebp
  803149:	85 ff                	test   %edi,%edi
  80314b:	75 0b                	jne    803158 <__udivdi3+0x38>
  80314d:	b8 01 00 00 00       	mov    $0x1,%eax
  803152:	31 d2                	xor    %edx,%edx
  803154:	f7 f7                	div    %edi
  803156:	89 c5                	mov    %eax,%ebp
  803158:	31 d2                	xor    %edx,%edx
  80315a:	89 c8                	mov    %ecx,%eax
  80315c:	f7 f5                	div    %ebp
  80315e:	89 c1                	mov    %eax,%ecx
  803160:	89 d8                	mov    %ebx,%eax
  803162:	f7 f5                	div    %ebp
  803164:	89 cf                	mov    %ecx,%edi
  803166:	89 fa                	mov    %edi,%edx
  803168:	83 c4 1c             	add    $0x1c,%esp
  80316b:	5b                   	pop    %ebx
  80316c:	5e                   	pop    %esi
  80316d:	5f                   	pop    %edi
  80316e:	5d                   	pop    %ebp
  80316f:	c3                   	ret    
  803170:	39 ce                	cmp    %ecx,%esi
  803172:	77 28                	ja     80319c <__udivdi3+0x7c>
  803174:	0f bd fe             	bsr    %esi,%edi
  803177:	83 f7 1f             	xor    $0x1f,%edi
  80317a:	75 40                	jne    8031bc <__udivdi3+0x9c>
  80317c:	39 ce                	cmp    %ecx,%esi
  80317e:	72 0a                	jb     80318a <__udivdi3+0x6a>
  803180:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803184:	0f 87 9e 00 00 00    	ja     803228 <__udivdi3+0x108>
  80318a:	b8 01 00 00 00       	mov    $0x1,%eax
  80318f:	89 fa                	mov    %edi,%edx
  803191:	83 c4 1c             	add    $0x1c,%esp
  803194:	5b                   	pop    %ebx
  803195:	5e                   	pop    %esi
  803196:	5f                   	pop    %edi
  803197:	5d                   	pop    %ebp
  803198:	c3                   	ret    
  803199:	8d 76 00             	lea    0x0(%esi),%esi
  80319c:	31 ff                	xor    %edi,%edi
  80319e:	31 c0                	xor    %eax,%eax
  8031a0:	89 fa                	mov    %edi,%edx
  8031a2:	83 c4 1c             	add    $0x1c,%esp
  8031a5:	5b                   	pop    %ebx
  8031a6:	5e                   	pop    %esi
  8031a7:	5f                   	pop    %edi
  8031a8:	5d                   	pop    %ebp
  8031a9:	c3                   	ret    
  8031aa:	66 90                	xchg   %ax,%ax
  8031ac:	89 d8                	mov    %ebx,%eax
  8031ae:	f7 f7                	div    %edi
  8031b0:	31 ff                	xor    %edi,%edi
  8031b2:	89 fa                	mov    %edi,%edx
  8031b4:	83 c4 1c             	add    $0x1c,%esp
  8031b7:	5b                   	pop    %ebx
  8031b8:	5e                   	pop    %esi
  8031b9:	5f                   	pop    %edi
  8031ba:	5d                   	pop    %ebp
  8031bb:	c3                   	ret    
  8031bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031c1:	89 eb                	mov    %ebp,%ebx
  8031c3:	29 fb                	sub    %edi,%ebx
  8031c5:	89 f9                	mov    %edi,%ecx
  8031c7:	d3 e6                	shl    %cl,%esi
  8031c9:	89 c5                	mov    %eax,%ebp
  8031cb:	88 d9                	mov    %bl,%cl
  8031cd:	d3 ed                	shr    %cl,%ebp
  8031cf:	89 e9                	mov    %ebp,%ecx
  8031d1:	09 f1                	or     %esi,%ecx
  8031d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031d7:	89 f9                	mov    %edi,%ecx
  8031d9:	d3 e0                	shl    %cl,%eax
  8031db:	89 c5                	mov    %eax,%ebp
  8031dd:	89 d6                	mov    %edx,%esi
  8031df:	88 d9                	mov    %bl,%cl
  8031e1:	d3 ee                	shr    %cl,%esi
  8031e3:	89 f9                	mov    %edi,%ecx
  8031e5:	d3 e2                	shl    %cl,%edx
  8031e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031eb:	88 d9                	mov    %bl,%cl
  8031ed:	d3 e8                	shr    %cl,%eax
  8031ef:	09 c2                	or     %eax,%edx
  8031f1:	89 d0                	mov    %edx,%eax
  8031f3:	89 f2                	mov    %esi,%edx
  8031f5:	f7 74 24 0c          	divl   0xc(%esp)
  8031f9:	89 d6                	mov    %edx,%esi
  8031fb:	89 c3                	mov    %eax,%ebx
  8031fd:	f7 e5                	mul    %ebp
  8031ff:	39 d6                	cmp    %edx,%esi
  803201:	72 19                	jb     80321c <__udivdi3+0xfc>
  803203:	74 0b                	je     803210 <__udivdi3+0xf0>
  803205:	89 d8                	mov    %ebx,%eax
  803207:	31 ff                	xor    %edi,%edi
  803209:	e9 58 ff ff ff       	jmp    803166 <__udivdi3+0x46>
  80320e:	66 90                	xchg   %ax,%ax
  803210:	8b 54 24 08          	mov    0x8(%esp),%edx
  803214:	89 f9                	mov    %edi,%ecx
  803216:	d3 e2                	shl    %cl,%edx
  803218:	39 c2                	cmp    %eax,%edx
  80321a:	73 e9                	jae    803205 <__udivdi3+0xe5>
  80321c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80321f:	31 ff                	xor    %edi,%edi
  803221:	e9 40 ff ff ff       	jmp    803166 <__udivdi3+0x46>
  803226:	66 90                	xchg   %ax,%ax
  803228:	31 c0                	xor    %eax,%eax
  80322a:	e9 37 ff ff ff       	jmp    803166 <__udivdi3+0x46>
  80322f:	90                   	nop

00803230 <__umoddi3>:
  803230:	55                   	push   %ebp
  803231:	57                   	push   %edi
  803232:	56                   	push   %esi
  803233:	53                   	push   %ebx
  803234:	83 ec 1c             	sub    $0x1c,%esp
  803237:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80323b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80323f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803243:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803247:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80324b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80324f:	89 f3                	mov    %esi,%ebx
  803251:	89 fa                	mov    %edi,%edx
  803253:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803257:	89 34 24             	mov    %esi,(%esp)
  80325a:	85 c0                	test   %eax,%eax
  80325c:	75 1a                	jne    803278 <__umoddi3+0x48>
  80325e:	39 f7                	cmp    %esi,%edi
  803260:	0f 86 a2 00 00 00    	jbe    803308 <__umoddi3+0xd8>
  803266:	89 c8                	mov    %ecx,%eax
  803268:	89 f2                	mov    %esi,%edx
  80326a:	f7 f7                	div    %edi
  80326c:	89 d0                	mov    %edx,%eax
  80326e:	31 d2                	xor    %edx,%edx
  803270:	83 c4 1c             	add    $0x1c,%esp
  803273:	5b                   	pop    %ebx
  803274:	5e                   	pop    %esi
  803275:	5f                   	pop    %edi
  803276:	5d                   	pop    %ebp
  803277:	c3                   	ret    
  803278:	39 f0                	cmp    %esi,%eax
  80327a:	0f 87 ac 00 00 00    	ja     80332c <__umoddi3+0xfc>
  803280:	0f bd e8             	bsr    %eax,%ebp
  803283:	83 f5 1f             	xor    $0x1f,%ebp
  803286:	0f 84 ac 00 00 00    	je     803338 <__umoddi3+0x108>
  80328c:	bf 20 00 00 00       	mov    $0x20,%edi
  803291:	29 ef                	sub    %ebp,%edi
  803293:	89 fe                	mov    %edi,%esi
  803295:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803299:	89 e9                	mov    %ebp,%ecx
  80329b:	d3 e0                	shl    %cl,%eax
  80329d:	89 d7                	mov    %edx,%edi
  80329f:	89 f1                	mov    %esi,%ecx
  8032a1:	d3 ef                	shr    %cl,%edi
  8032a3:	09 c7                	or     %eax,%edi
  8032a5:	89 e9                	mov    %ebp,%ecx
  8032a7:	d3 e2                	shl    %cl,%edx
  8032a9:	89 14 24             	mov    %edx,(%esp)
  8032ac:	89 d8                	mov    %ebx,%eax
  8032ae:	d3 e0                	shl    %cl,%eax
  8032b0:	89 c2                	mov    %eax,%edx
  8032b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032b6:	d3 e0                	shl    %cl,%eax
  8032b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c0:	89 f1                	mov    %esi,%ecx
  8032c2:	d3 e8                	shr    %cl,%eax
  8032c4:	09 d0                	or     %edx,%eax
  8032c6:	d3 eb                	shr    %cl,%ebx
  8032c8:	89 da                	mov    %ebx,%edx
  8032ca:	f7 f7                	div    %edi
  8032cc:	89 d3                	mov    %edx,%ebx
  8032ce:	f7 24 24             	mull   (%esp)
  8032d1:	89 c6                	mov    %eax,%esi
  8032d3:	89 d1                	mov    %edx,%ecx
  8032d5:	39 d3                	cmp    %edx,%ebx
  8032d7:	0f 82 87 00 00 00    	jb     803364 <__umoddi3+0x134>
  8032dd:	0f 84 91 00 00 00    	je     803374 <__umoddi3+0x144>
  8032e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032e7:	29 f2                	sub    %esi,%edx
  8032e9:	19 cb                	sbb    %ecx,%ebx
  8032eb:	89 d8                	mov    %ebx,%eax
  8032ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032f1:	d3 e0                	shl    %cl,%eax
  8032f3:	89 e9                	mov    %ebp,%ecx
  8032f5:	d3 ea                	shr    %cl,%edx
  8032f7:	09 d0                	or     %edx,%eax
  8032f9:	89 e9                	mov    %ebp,%ecx
  8032fb:	d3 eb                	shr    %cl,%ebx
  8032fd:	89 da                	mov    %ebx,%edx
  8032ff:	83 c4 1c             	add    $0x1c,%esp
  803302:	5b                   	pop    %ebx
  803303:	5e                   	pop    %esi
  803304:	5f                   	pop    %edi
  803305:	5d                   	pop    %ebp
  803306:	c3                   	ret    
  803307:	90                   	nop
  803308:	89 fd                	mov    %edi,%ebp
  80330a:	85 ff                	test   %edi,%edi
  80330c:	75 0b                	jne    803319 <__umoddi3+0xe9>
  80330e:	b8 01 00 00 00       	mov    $0x1,%eax
  803313:	31 d2                	xor    %edx,%edx
  803315:	f7 f7                	div    %edi
  803317:	89 c5                	mov    %eax,%ebp
  803319:	89 f0                	mov    %esi,%eax
  80331b:	31 d2                	xor    %edx,%edx
  80331d:	f7 f5                	div    %ebp
  80331f:	89 c8                	mov    %ecx,%eax
  803321:	f7 f5                	div    %ebp
  803323:	89 d0                	mov    %edx,%eax
  803325:	e9 44 ff ff ff       	jmp    80326e <__umoddi3+0x3e>
  80332a:	66 90                	xchg   %ax,%ax
  80332c:	89 c8                	mov    %ecx,%eax
  80332e:	89 f2                	mov    %esi,%edx
  803330:	83 c4 1c             	add    $0x1c,%esp
  803333:	5b                   	pop    %ebx
  803334:	5e                   	pop    %esi
  803335:	5f                   	pop    %edi
  803336:	5d                   	pop    %ebp
  803337:	c3                   	ret    
  803338:	3b 04 24             	cmp    (%esp),%eax
  80333b:	72 06                	jb     803343 <__umoddi3+0x113>
  80333d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803341:	77 0f                	ja     803352 <__umoddi3+0x122>
  803343:	89 f2                	mov    %esi,%edx
  803345:	29 f9                	sub    %edi,%ecx
  803347:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80334b:	89 14 24             	mov    %edx,(%esp)
  80334e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803352:	8b 44 24 04          	mov    0x4(%esp),%eax
  803356:	8b 14 24             	mov    (%esp),%edx
  803359:	83 c4 1c             	add    $0x1c,%esp
  80335c:	5b                   	pop    %ebx
  80335d:	5e                   	pop    %esi
  80335e:	5f                   	pop    %edi
  80335f:	5d                   	pop    %ebp
  803360:	c3                   	ret    
  803361:	8d 76 00             	lea    0x0(%esi),%esi
  803364:	2b 04 24             	sub    (%esp),%eax
  803367:	19 fa                	sbb    %edi,%edx
  803369:	89 d1                	mov    %edx,%ecx
  80336b:	89 c6                	mov    %eax,%esi
  80336d:	e9 71 ff ff ff       	jmp    8032e3 <__umoddi3+0xb3>
  803372:	66 90                	xchg   %ax,%ax
  803374:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803378:	72 ea                	jb     803364 <__umoddi3+0x134>
  80337a:	89 d9                	mov    %ebx,%ecx
  80337c:	e9 62 ff ff ff       	jmp    8032e3 <__umoddi3+0xb3>

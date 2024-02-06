
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
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
	// Testing removing the shared variables
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 80 33 80 00       	push   $0x803380
  80004a:	e8 a5 15 00 00       	call   8015f4 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 aa 18 00 00       	call   80190d <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 42 19 00 00       	call   8019ad <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 90 33 80 00       	push   $0x803390
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 c3 33 80 00       	push   $0x8033c3
  80008f:	e8 eb 1a 00 00       	call   801b7f <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 cc 33 80 00       	push   $0x8033cc
  8000a8:	e8 d2 1a 00 00       	call   801b7f <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 df 1a 00 00       	call   801b9d <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 8b 2f 00 00       	call   803059 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 c1 1a 00 00       	call   801b9d <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 1e 18 00 00       	call   80190d <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 d8 33 80 00       	push   $0x8033d8
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 ae 1a 00 00       	call   801bb9 <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 a0 1a 00 00       	call   801bb9 <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 ec 17 00 00       	call   80190d <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 84 18 00 00       	call   8019ad <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 0c 34 80 00       	push   $0x80340c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 5c 34 80 00       	push   $0x80345c
  80014f:	6a 23                	push   $0x23
  800151:	68 92 34 80 00       	push   $0x803492
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 a8 34 80 00       	push   $0x8034a8
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 08 35 80 00       	push   $0x803508
  800176:	e8 f6 03 00 00       	call   800571 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 61 1a 00 00       	call   801bed <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	c1 e0 04             	shl    $0x4,%eax
  8001a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ae:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b8:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001be:	84 c0                	test   %al,%al
  8001c0:	74 0f                	je     8001d1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c7:	05 5c 05 00 00       	add    $0x55c,%eax
  8001cc:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d5:	7e 0a                	jle    8001e1 <libmain+0x60>
		binaryname = argv[0];
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 00                	mov    (%eax),%eax
  8001dc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 49 fe ff ff       	call   800038 <_main>
  8001ef:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f2:	e8 03 18 00 00       	call   8019fa <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 6c 35 80 00       	push   $0x80356c
  8001ff:	e8 6d 03 00 00       	call   800571 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800212:	a1 20 40 80 00       	mov    0x804020,%eax
  800217:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 94 35 80 00       	push   $0x803594
  800227:	e8 45 03 00 00       	call   800571 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800245:	a1 20 40 80 00       	mov    0x804020,%eax
  80024a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800250:	51                   	push   %ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 bc 35 80 00       	push   $0x8035bc
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 14 36 80 00       	push   $0x803614
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 6c 35 80 00       	push   $0x80356c
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 83 17 00 00       	call   801a14 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800291:	e8 19 00 00 00       	call   8002af <exit>
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	6a 00                	push   $0x0
  8002a4:	e8 10 19 00 00       	call   801bb9 <sys_destroy_env>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <exit>:

void
exit(void)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b5:	e8 65 19 00 00       	call   801c1f <sys_exit_env>
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8002c6:	83 c0 04             	add    $0x4,%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002cc:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	74 16                	je     8002eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002d5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 28 36 80 00       	push   $0x803628
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 40 80 00       	mov    0x804000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 2d 36 80 00       	push   $0x80362d
  8002fc:	e8 70 02 00 00       	call   800571 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800304:	8b 45 10             	mov    0x10(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	50                   	push   %eax
  80030e:	e8 f3 01 00 00       	call   800506 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 49 36 80 00       	push   $0x803649
  800320:	e8 e1 01 00 00       	call   800506 <vcprintf>
  800325:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800328:	e8 82 ff ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80032d:	eb fe                	jmp    80032d <_panic+0x70>

0080032f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800335:	a1 20 40 80 00       	mov    0x804020,%eax
  80033a:	8b 50 74             	mov    0x74(%eax),%edx
  80033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800340:	39 c2                	cmp    %eax,%edx
  800342:	74 14                	je     800358 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	68 4c 36 80 00       	push   $0x80364c
  80034c:	6a 26                	push   $0x26
  80034e:	68 98 36 80 00       	push   $0x803698
  800353:	e8 65 ff ff ff       	call   8002bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80035f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800366:	e9 c2 00 00 00       	jmp    80042d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	75 08                	jne    800388 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800380:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800383:	e9 a2 00 00 00       	jmp    80042a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800396:	eb 69                	jmp    800401 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800398:	a1 20 40 80 00       	mov    0x804020,%eax
  80039d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a6:	89 d0                	mov    %edx,%eax
  8003a8:	01 c0                	add    %eax,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	c1 e0 03             	shl    $0x3,%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8a 40 04             	mov    0x4(%eax),%al
  8003b4:	84 c0                	test   %al,%al
  8003b6:	75 46                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003bd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	c1 e0 03             	shl    $0x3,%eax
  8003cf:	01 c8                	add    %ecx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f1:	39 c2                	cmp    %eax,%edx
  8003f3:	75 09                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fc:	eb 12                	jmp    800410 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	ff 45 e8             	incl   -0x18(%ebp)
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 50 74             	mov    0x74(%eax),%edx
  800409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	77 88                	ja     800398 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800414:	75 14                	jne    80042a <CheckWSWithoutLastIndex+0xfb>
			panic(
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 a4 36 80 00       	push   $0x8036a4
  80041e:	6a 3a                	push   $0x3a
  800420:	68 98 36 80 00       	push   $0x803698
  800425:	e8 93 fe ff ff       	call   8002bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80042a:	ff 45 f0             	incl   -0x10(%ebp)
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800433:	0f 8c 32 ff ff ff    	jl     80036b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800440:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800447:	eb 26                	jmp    80046f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800449:	a1 20 40 80 00       	mov    0x804020,%eax
  80044e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8a 40 04             	mov    0x4(%eax),%al
  800465:	3c 01                	cmp    $0x1,%al
  800467:	75 03                	jne    80046c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800469:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e0             	incl   -0x20(%ebp)
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 50 74             	mov    0x74(%eax),%edx
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 cb                	ja     800449 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800484:	74 14                	je     80049a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 f8 36 80 00       	push   $0x8036f8
  80048e:	6a 44                	push   $0x44
  800490:	68 98 36 80 00       	push   $0x803698
  800495:	e8 23 fe ff ff       	call   8002bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	89 0a                	mov    %ecx,(%edx)
  8004b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b3:	88 d1                	mov    %dl,%cl
  8004b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c6:	75 2c                	jne    8004f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c8:	a0 24 40 80 00       	mov    0x804024,%al
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	8b 12                	mov    (%edx),%edx
  8004d5:	89 d1                	mov    %edx,%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	83 c2 08             	add    $0x8,%edx
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	50                   	push   %eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	e8 64 13 00 00       	call   80184c <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 40 04             	mov    0x4(%eax),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	89 50 04             	mov    %edx,0x4(%eax)
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800516:	00 00 00 
	b.cnt = 0;
  800519:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800520:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	68 9d 04 80 00       	push   $0x80049d
  800535:	e8 11 02 00 00       	call   80074b <vprintfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80053d:	a0 24 40 80 00       	mov    0x804024,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	50                   	push   %eax
  80054f:	52                   	push   %edx
  800550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800556:	83 c0 08             	add    $0x8,%eax
  800559:	50                   	push   %eax
  80055a:	e8 ed 12 00 00       	call   80184c <sys_cputs>
  80055f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800562:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <cprintf>:

int cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800577:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80057e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	50                   	push   %eax
  80058e:	e8 73 ff ff ff       	call   800506 <vcprintf>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a4:	e8 51 14 00 00       	call   8019fa <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 48 ff ff ff       	call   800506 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005c4:	e8 4b 14 00 00       	call   801a14 <sys_enable_interrupt>
	return cnt;
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 14             	sub    $0x14,%esp
  8005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ec:	77 55                	ja     800643 <printnum+0x75>
  8005ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f1:	72 05                	jb     8005f8 <printnum+0x2a>
  8005f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005f6:	77 4b                	ja     800643 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	ff 75 f0             	pushl  -0x10(%ebp)
  80060e:	e8 fd 2a 00 00       	call   803110 <__udivdi3>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	ff 75 20             	pushl  0x20(%ebp)
  80061c:	53                   	push   %ebx
  80061d:	ff 75 18             	pushl  0x18(%ebp)
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 a1 ff ff ff       	call   8005ce <printnum>
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	eb 1a                	jmp    80064c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 20             	pushl  0x20(%ebp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800643:	ff 4d 1c             	decl   0x1c(%ebp)
  800646:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064a:	7f e6                	jg     800632 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80064c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80064f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065a:	53                   	push   %ebx
  80065b:	51                   	push   %ecx
  80065c:	52                   	push   %edx
  80065d:	50                   	push   %eax
  80065e:	e8 bd 2b 00 00       	call   803220 <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 74 39 80 00       	add    $0x803974,%eax
  80066b:	8a 00                	mov    (%eax),%al
  80066d:	0f be c0             	movsbl %al,%eax
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	50                   	push   %eax
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	ff d0                	call   *%eax
  80067c:	83 c4 10             	add    $0x10,%esp
}
  80067f:	90                   	nop
  800680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068c:	7e 1c                	jle    8006aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 08             	sub    $0x8,%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	eb 40                	jmp    8006ea <getuint+0x65>
	else if (lflag)
  8006aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ae:	74 1e                	je     8006ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 04             	lea    0x4(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	eb 1c                	jmp    8006ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 04             	sub    $0x4,%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f3:	7e 1c                	jle    800711 <getint+0x25>
		return va_arg(*ap, long long);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 08             	lea    0x8(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 08             	sub    $0x8,%eax
  80070a:	8b 50 04             	mov    0x4(%eax),%edx
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	eb 38                	jmp    800749 <getint+0x5d>
	else if (lflag)
  800711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800715:	74 1a                	je     800731 <getint+0x45>
		return va_arg(*ap, long);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 50 04             	lea    0x4(%eax),%edx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 10                	mov    %edx,(%eax)
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	99                   	cltd   
  80072f:	eb 18                	jmp    800749 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	99                   	cltd   
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800753:	eb 17                	jmp    80076c <vprintfmt+0x21>
			if (ch == '\0')
  800755:	85 db                	test   %ebx,%ebx
  800757:	0f 84 af 03 00 00    	je     800b0c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	89 55 10             	mov    %edx,0x10(%ebp)
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f b6 d8             	movzbl %al,%ebx
  80077a:	83 fb 25             	cmp    $0x25,%ebx
  80077d:	75 d6                	jne    800755 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80077f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800791:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800798:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a2:	8d 50 01             	lea    0x1(%eax),%edx
  8007a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f b6 d8             	movzbl %al,%ebx
  8007ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b0:	83 f8 55             	cmp    $0x55,%eax
  8007b3:	0f 87 2b 03 00 00    	ja     800ae4 <vprintfmt+0x399>
  8007b9:	8b 04 85 98 39 80 00 	mov    0x803998(,%eax,4),%eax
  8007c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007c6:	eb d7                	jmp    80079f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d1                	jmp    80079f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	c1 e0 02             	shl    $0x2,%eax
  8007dd:	01 d0                	add    %edx,%eax
  8007df:	01 c0                	add    %eax,%eax
  8007e1:	01 d8                	add    %ebx,%eax
  8007e3:	83 e8 30             	sub    $0x30,%eax
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	8a 00                	mov    (%eax),%al
  8007ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f4:	7e 3e                	jle    800834 <vprintfmt+0xe9>
  8007f6:	83 fb 39             	cmp    $0x39,%ebx
  8007f9:	7f 39                	jg     800834 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007fe:	eb d5                	jmp    8007d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081a:	79 83                	jns    80079f <vprintfmt+0x54>
				width = 0;
  80081c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800823:	e9 77 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800828:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80082f:	e9 6b ff ff ff       	jmp    80079f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800839:	0f 89 60 ff ff ff    	jns    80079f <vprintfmt+0x54>
				width = precision, precision = -1;
  80083f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80084c:	e9 4e ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800851:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800854:	e9 46 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			break;
  800879:	e9 89 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80088f:	85 db                	test   %ebx,%ebx
  800891:	79 02                	jns    800895 <vprintfmt+0x14a>
				err = -err;
  800893:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800895:	83 fb 64             	cmp    $0x64,%ebx
  800898:	7f 0b                	jg     8008a5 <vprintfmt+0x15a>
  80089a:	8b 34 9d e0 37 80 00 	mov    0x8037e0(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 85 39 80 00       	push   $0x803985
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 5e 02 00 00       	call   800b14 <printfmt>
  8008b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b9:	e9 49 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008be:	56                   	push   %esi
  8008bf:	68 8e 39 80 00       	push   $0x80398e
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 45 02 00 00       	call   800b14 <printfmt>
  8008cf:	83 c4 10             	add    $0x10,%esp
			break;
  8008d2:	e9 30 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 30                	mov    (%eax),%esi
  8008e8:	85 f6                	test   %esi,%esi
  8008ea:	75 05                	jne    8008f1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ec:	be 91 39 80 00       	mov    $0x803991,%esi
			if (width > 0 && padc != '-')
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7e 6d                	jle    800964 <vprintfmt+0x219>
  8008f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008fb:	74 67                	je     800964 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	50                   	push   %eax
  800904:	56                   	push   %esi
  800905:	e8 0c 03 00 00       	call   800c16 <strnlen>
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800910:	eb 16                	jmp    800928 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800912:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800925:	ff 4d e4             	decl   -0x1c(%ebp)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	7f e4                	jg     800912 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	eb 34                	jmp    800964 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800934:	74 1c                	je     800952 <vprintfmt+0x207>
  800936:	83 fb 1f             	cmp    $0x1f,%ebx
  800939:	7e 05                	jle    800940 <vprintfmt+0x1f5>
  80093b:	83 fb 7e             	cmp    $0x7e,%ebx
  80093e:	7e 12                	jle    800952 <vprintfmt+0x207>
					putch('?', putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	6a 3f                	push   $0x3f
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb 0f                	jmp    800961 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	89 f0                	mov    %esi,%eax
  800966:	8d 70 01             	lea    0x1(%eax),%esi
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f be d8             	movsbl %al,%ebx
  80096e:	85 db                	test   %ebx,%ebx
  800970:	74 24                	je     800996 <vprintfmt+0x24b>
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	78 b8                	js     800930 <vprintfmt+0x1e5>
  800978:	ff 4d e0             	decl   -0x20(%ebp)
  80097b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097f:	79 af                	jns    800930 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	eb 13                	jmp    800996 <vprintfmt+0x24b>
				putch(' ', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 20                	push   $0x20
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7f e7                	jg     800983 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80099c:	e9 66 01 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 3c fd ff ff       	call   8006ec <getint>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	79 23                	jns    8009e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 2d                	push   $0x2d
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d9:	f7 d8                	neg    %eax
  8009db:	83 d2 00             	adc    $0x0,%edx
  8009de:	f7 da                	neg    %edx
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ed:	e9 bc 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 84 fc ff ff       	call   800685 <getuint>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a11:	e9 98 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 58                	push   $0x58
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 58                	push   $0x58
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	6a 58                	push   $0x58
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 bc 00 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 30                	push   $0x30
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 78                	push   $0x78
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 14             	mov    %eax,0x14(%ebp)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 e8 04             	sub    $0x4,%eax
  800a7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a8d:	eb 1f                	jmp    800aae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 e8             	pushl  -0x18(%ebp)
  800a95:	8d 45 14             	lea    0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	e8 e7 fb ff ff       	call   800685 <getuint>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	52                   	push   %edx
  800ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 00 fb ff ff       	call   8005ce <printnum>
  800ace:	83 c4 20             	add    $0x20,%esp
			break;
  800ad1:	eb 34                	jmp    800b07 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	eb 23                	jmp    800b07 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 25                	push   $0x25
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	eb 03                	jmp    800afc <vprintfmt+0x3b1>
  800af9:	ff 4d 10             	decl   0x10(%ebp)
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	48                   	dec    %eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	3c 25                	cmp    $0x25,%al
  800b04:	75 f3                	jne    800af9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b06:	90                   	nop
		}
	}
  800b07:	e9 47 fc ff ff       	jmp    800753 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1d:	83 c0 04             	add    $0x4,%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 16 fc ff ff       	call   80074b <vprintfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b38:	90                   	nop
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8b 40 08             	mov    0x8(%eax),%eax
  800b44:	8d 50 01             	lea    0x1(%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8b 10                	mov    (%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 04             	mov    0x4(%eax),%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	73 12                	jae    800b6e <sprintputch+0x33>
		*b->buf++ = ch;
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 48 01             	lea    0x1(%eax),%ecx
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 0a                	mov    %ecx,(%edx)
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	88 10                	mov    %dl,(%eax)
}
  800b6e:	90                   	nop
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b96:	74 06                	je     800b9e <vsnprintf+0x2d>
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	7f 07                	jg     800ba5 <vsnprintf+0x34>
		return -E_INVAL;
  800b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba3:	eb 20                	jmp    800bc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba5:	ff 75 14             	pushl  0x14(%ebp)
  800ba8:	ff 75 10             	pushl  0x10(%ebp)
  800bab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	68 3b 0b 80 00       	push   $0x800b3b
  800bb4:	e8 92 fb ff ff       	call   80074b <vprintfmt>
  800bb9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd0:	83 c0 04             	add    $0x4,%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 89 ff ff ff       	call   800b71 <vsnprintf>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c00:	eb 06                	jmp    800c08 <strlen+0x15>
		n++;
  800c02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 f1                	jne    800c02 <strlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c23:	eb 09                	jmp    800c2e <strnlen+0x18>
		n++;
  800c25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 4d 0c             	decl   0xc(%ebp)
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	74 09                	je     800c3d <strnlen+0x27>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e8                	jne    800c25 <strnlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4e:	90                   	nop
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8d 50 01             	lea    0x1(%eax),%edx
  800c55:	89 55 08             	mov    %edx,0x8(%ebp)
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	75 e4                	jne    800c4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 1f                	jmp    800ca4 <strncpy+0x34>
		*dst++ = *src;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 03                	je     800ca1 <strncpy+0x31>
			src++;
  800c9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca1:	ff 45 fc             	incl   -0x4(%ebp)
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800caa:	72 d9                	jb     800c85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	74 30                	je     800cf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc3:	eb 16                	jmp    800cdb <strlcpy+0x2a>
			*dst++ = *src++;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdb:	ff 4d 10             	decl   0x10(%ebp)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 09                	je     800ced <strlcpy+0x3c>
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 d8                	jne    800cc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	29 c2                	sub    %eax,%edx
  800cfb:	89 d0                	mov    %edx,%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d02:	eb 06                	jmp    800d0a <strcmp+0xb>
		p++, q++;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 0e                	je     800d21 <strcmp+0x22>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	38 c2                	cmp    %al,%dl
  800d1f:	74 e3                	je     800d04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	29 c2                	sub    %eax,%edx
  800d33:	89 d0                	mov    %edx,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3a:	eb 09                	jmp    800d45 <strncmp+0xe>
		n--, p++, q++;
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 17                	je     800d62 <strncmp+0x2b>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 da                	je     800d3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	75 07                	jne    800d6f <strncmp+0x38>
		return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	eb 14                	jmp    800d83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f b6 d0             	movzbl %al,%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 c0             	movzbl %al,%eax
  800d7f:	29 c2                	sub    %eax,%edx
  800d81:	89 d0                	mov    %edx,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d91:	eb 12                	jmp    800da5 <strchr+0x20>
		if (*s == c)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9b:	75 05                	jne    800da2 <strchr+0x1d>
			return (char *) s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	eb 11                	jmp    800db3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 e5                	jne    800d93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc1:	eb 0d                	jmp    800dd0 <strfind+0x1b>
		if (*s == c)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcb:	74 0e                	je     800ddb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 ea                	jne    800dc3 <strfind+0xe>
  800dd9:	eb 01                	jmp    800ddc <strfind+0x27>
		if (*s == c)
			break;
  800ddb:	90                   	nop
	return (char *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df3:	eb 0e                	jmp    800e03 <memset+0x22>
		*p++ = c;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e03:	ff 4d f8             	decl   -0x8(%ebp)
  800e06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0a:	79 e9                	jns    800df5 <memset+0x14>
		*p++ = c;

	return v;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e23:	eb 16                	jmp    800e3b <memcpy+0x2a>
		*d++ = *s++;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 dd                	jne    800e25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e65:	73 50                	jae    800eb7 <memmove+0x6a>
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	01 d0                	add    %edx,%eax
  800e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e72:	76 43                	jbe    800eb7 <memmove+0x6a>
		s += n;
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e80:	eb 10                	jmp    800e92 <memmove+0x45>
			*--d = *--s;
  800e82:	ff 4d f8             	decl   -0x8(%ebp)
  800e85:	ff 4d fc             	decl   -0x4(%ebp)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 e3                	jne    800e82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9f:	eb 23                	jmp    800ec4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 dd                	jne    800ea1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edb:	eb 2a                	jmp    800f07 <memcmp+0x3e>
		if (*s1 != *s2)
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	8a 10                	mov    (%eax),%dl
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	38 c2                	cmp    %al,%dl
  800ee9:	74 16                	je     800f01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 d0             	movzbl %al,%edx
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 c0             	movzbl %al,%eax
  800efb:	29 c2                	sub    %eax,%edx
  800efd:	89 d0                	mov    %edx,%eax
  800eff:	eb 18                	jmp    800f19 <memcmp+0x50>
		s1++, s2++;
  800f01:	ff 45 fc             	incl   -0x4(%ebp)
  800f04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 c9                	jne    800edd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2c:	eb 15                	jmp    800f43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d0             	movzbl %al,%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	39 c2                	cmp    %eax,%edx
  800f3e:	74 0d                	je     800f4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f49:	72 e3                	jb     800f2e <memfind+0x13>
  800f4b:	eb 01                	jmp    800f4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4d:	90                   	nop
	return (void *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f67:	eb 03                	jmp    800f6c <strtol+0x19>
		s++;
  800f69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 20                	cmp    $0x20,%al
  800f73:	74 f4                	je     800f69 <strtol+0x16>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 09                	cmp    $0x9,%al
  800f7c:	74 eb                	je     800f69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 2b                	cmp    $0x2b,%al
  800f85:	75 05                	jne    800f8c <strtol+0x39>
		s++;
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	eb 13                	jmp    800f9f <strtol+0x4c>
	else if (*s == '-')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2d                	cmp    $0x2d,%al
  800f93:	75 0a                	jne    800f9f <strtol+0x4c>
		s++, neg = 1;
  800f95:	ff 45 08             	incl   0x8(%ebp)
  800f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 06                	je     800fab <strtol+0x58>
  800fa5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa9:	75 20                	jne    800fcb <strtol+0x78>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 30                	cmp    $0x30,%al
  800fb2:	75 17                	jne    800fcb <strtol+0x78>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	40                   	inc    %eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 78                	cmp    $0x78,%al
  800fbc:	75 0d                	jne    800fcb <strtol+0x78>
		s += 2, base = 16;
  800fbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc9:	eb 28                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	75 15                	jne    800fe6 <strtol+0x93>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 30                	cmp    $0x30,%al
  800fd8:	75 0c                	jne    800fe6 <strtol+0x93>
		s++, base = 8;
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe4:	eb 0d                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	75 07                	jne    800ff3 <strtol+0xa0>
		base = 10;
  800fec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 2f                	cmp    $0x2f,%al
  800ffa:	7e 19                	jle    801015 <strtol+0xc2>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 39                	cmp    $0x39,%al
  801003:	7f 10                	jg     801015 <strtol+0xc2>
			dig = *s - '0';
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f be c0             	movsbl %al,%eax
  80100d:	83 e8 30             	sub    $0x30,%eax
  801010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801013:	eb 42                	jmp    801057 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 60                	cmp    $0x60,%al
  80101c:	7e 19                	jle    801037 <strtol+0xe4>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 7a                	cmp    $0x7a,%al
  801025:	7f 10                	jg     801037 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f be c0             	movsbl %al,%eax
  80102f:	83 e8 57             	sub    $0x57,%eax
  801032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801035:	eb 20                	jmp    801057 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 40                	cmp    $0x40,%al
  80103e:	7e 39                	jle    801079 <strtol+0x126>
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 5a                	cmp    $0x5a,%al
  801047:	7f 30                	jg     801079 <strtol+0x126>
			dig = *s - 'A' + 10;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be c0             	movsbl %al,%eax
  801051:	83 e8 37             	sub    $0x37,%eax
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105d:	7d 19                	jge    801078 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	0f af 45 10          	imul   0x10(%ebp),%eax
  801069:	89 c2                	mov    %eax,%edx
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801073:	e9 7b ff ff ff       	jmp    800ff3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801078:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107d:	74 08                	je     801087 <strtol+0x134>
		*endptr = (char *) s;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801087:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108b:	74 07                	je     801094 <strtol+0x141>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	f7 d8                	neg    %eax
  801092:	eb 03                	jmp    801097 <strtol+0x144>
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <ltostr>:

void
ltostr(long value, char *str)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b1:	79 13                	jns    8010c6 <ltostr+0x2d>
	{
		neg = 1;
  8010b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010ce:	99                   	cltd   
  8010cf:	f7 f9                	idiv   %ecx
  8010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e7:	83 c2 30             	add    $0x30,%edx
  8010ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f4:	f7 e9                	imul   %ecx
  8010f6:	c1 fa 02             	sar    $0x2,%edx
  8010f9:	89 c8                	mov    %ecx,%eax
  8010fb:	c1 f8 1f             	sar    $0x1f,%eax
  8010fe:	29 c2                	sub    %eax,%edx
  801100:	89 d0                	mov    %edx,%eax
  801102:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801108:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110d:	f7 e9                	imul   %ecx
  80110f:	c1 fa 02             	sar    $0x2,%edx
  801112:	89 c8                	mov    %ecx,%eax
  801114:	c1 f8 1f             	sar    $0x1f,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
  80111b:	c1 e0 02             	shl    $0x2,%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	01 c0                	add    %eax,%eax
  801122:	29 c1                	sub    %eax,%ecx
  801124:	89 ca                	mov    %ecx,%edx
  801126:	85 d2                	test   %edx,%edx
  801128:	75 9c                	jne    8010c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80112a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	48                   	dec    %eax
  801135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 3d                	je     80117b <ltostr+0xe2>
		start = 1 ;
  80113e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801145:	eb 34                	jmp    80117b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8a 45 eb             	mov    -0x15(%ebp),%al
  801173:	88 02                	mov    %al,(%edx)
		start++ ;
  801175:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801178:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801181:	7c c4                	jl     801147 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80118e:	90                   	nop
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 54 fa ff ff       	call   800bf3 <strlen>
  80119f:	83 c4 04             	add    $0x4,%esp
  8011a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 46 fa ff ff       	call   800bf3 <strlen>
  8011ad:	83 c4 04             	add    $0x4,%esp
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c1:	eb 17                	jmp    8011da <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	01 c8                	add    %ecx,%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d7:	ff 45 fc             	incl   -0x4(%ebp)
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e0:	7c e1                	jl     8011c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f0:	eb 1f                	jmp    801211 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801217:	7c d9                	jl     8011f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801219:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121c:	8b 45 10             	mov    0x10(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	c6 00 00             	movb   $0x0,(%eax)
}
  801224:	90                   	nop
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801233:	8b 45 14             	mov    0x14(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124a:	eb 0c                	jmp    801258 <strsplit+0x31>
			*string++ = 0;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	74 18                	je     801279 <strsplit+0x52>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	0f be c0             	movsbl %al,%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	e8 13 fb ff ff       	call   800d85 <strchr>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	75 d3                	jne    80124c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 5a                	je     8012dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	83 f8 0f             	cmp    $0xf,%eax
  80128a:	75 07                	jne    801293 <strsplit+0x6c>
		{
			return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
  801291:	eb 66                	jmp    8012f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 48 01             	lea    0x1(%eax),%ecx
  80129b:	8b 55 14             	mov    0x14(%ebp),%edx
  80129e:	89 0a                	mov    %ecx,(%edx)
  8012a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b1:	eb 03                	jmp    8012b6 <strsplit+0x8f>
			string++;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 8b                	je     80124a <strsplit+0x23>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	0f be c0             	movsbl %al,%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 b5 fa ff ff       	call   800d85 <strchr>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	74 dc                	je     8012b3 <strsplit+0x8c>
			string++;
	}
  8012d7:	e9 6e ff ff ff       	jmp    80124a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801301:	a1 04 40 80 00       	mov    0x804004,%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	74 1f                	je     801329 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80130a:	e8 1d 00 00 00       	call   80132c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	68 f0 3a 80 00       	push   $0x803af0
  801317:	e8 55 f2 ff ff       	call   800571 <cprintf>
  80131c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80131f:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801326:	00 00 00 
	}
}
  801329:	90                   	nop
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801332:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801339:	00 00 00 
  80133c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801343:	00 00 00 
  801346:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80134d:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801350:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801357:	00 00 00 
  80135a:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801361:	00 00 00 
  801364:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80136b:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80136e:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801375:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801378:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80137f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801387:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138c:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801391:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801398:	a1 20 41 80 00       	mov    0x804120,%eax
  80139d:	c1 e0 04             	shl    $0x4,%eax
  8013a0:	89 c2                	mov    %eax,%edx
  8013a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a5:	01 d0                	add    %edx,%eax
  8013a7:	48                   	dec    %eax
  8013a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b3:	f7 75 f0             	divl   -0x10(%ebp)
  8013b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b9:	29 d0                	sub    %edx,%eax
  8013bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8013be:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013cd:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013d2:	83 ec 04             	sub    $0x4,%esp
  8013d5:	6a 06                	push   $0x6
  8013d7:	ff 75 e8             	pushl  -0x18(%ebp)
  8013da:	50                   	push   %eax
  8013db:	e8 b0 05 00 00       	call   801990 <sys_allocate_chunk>
  8013e0:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013e3:	a1 20 41 80 00       	mov    0x804120,%eax
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	50                   	push   %eax
  8013ec:	e8 25 0c 00 00       	call   802016 <initialize_MemBlocksList>
  8013f1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8013f4:	a1 48 41 80 00       	mov    0x804148,%eax
  8013f9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8013fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801400:	75 14                	jne    801416 <initialize_dyn_block_system+0xea>
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	68 15 3b 80 00       	push   $0x803b15
  80140a:	6a 29                	push   $0x29
  80140c:	68 33 3b 80 00       	push   $0x803b33
  801411:	e8 a7 ee ff ff       	call   8002bd <_panic>
  801416:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801419:	8b 00                	mov    (%eax),%eax
  80141b:	85 c0                	test   %eax,%eax
  80141d:	74 10                	je     80142f <initialize_dyn_block_system+0x103>
  80141f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801422:	8b 00                	mov    (%eax),%eax
  801424:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801427:	8b 52 04             	mov    0x4(%edx),%edx
  80142a:	89 50 04             	mov    %edx,0x4(%eax)
  80142d:	eb 0b                	jmp    80143a <initialize_dyn_block_system+0x10e>
  80142f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801432:	8b 40 04             	mov    0x4(%eax),%eax
  801435:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80143a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143d:	8b 40 04             	mov    0x4(%eax),%eax
  801440:	85 c0                	test   %eax,%eax
  801442:	74 0f                	je     801453 <initialize_dyn_block_system+0x127>
  801444:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801447:	8b 40 04             	mov    0x4(%eax),%eax
  80144a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80144d:	8b 12                	mov    (%edx),%edx
  80144f:	89 10                	mov    %edx,(%eax)
  801451:	eb 0a                	jmp    80145d <initialize_dyn_block_system+0x131>
  801453:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801456:	8b 00                	mov    (%eax),%eax
  801458:	a3 48 41 80 00       	mov    %eax,0x804148
  80145d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801460:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801469:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801470:	a1 54 41 80 00       	mov    0x804154,%eax
  801475:	48                   	dec    %eax
  801476:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80147b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801485:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801488:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80148f:	83 ec 0c             	sub    $0xc,%esp
  801492:	ff 75 e0             	pushl  -0x20(%ebp)
  801495:	e8 b9 14 00 00       	call   802953 <insert_sorted_with_merge_freeList>
  80149a:	83 c4 10             	add    $0x10,%esp

}
  80149d:	90                   	nop
  80149e:	c9                   	leave  
  80149f:	c3                   	ret    

008014a0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014a6:	e8 50 fe ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  8014ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014af:	75 07                	jne    8014b8 <malloc+0x18>
  8014b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b6:	eb 68                	jmp    801520 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8014b8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c5:	01 d0                	add    %edx,%eax
  8014c7:	48                   	dec    %eax
  8014c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8014d3:	f7 75 f4             	divl   -0xc(%ebp)
  8014d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d9:	29 d0                	sub    %edx,%eax
  8014db:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8014de:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014e5:	e8 74 08 00 00       	call   801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	74 2d                	je     80151b <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8014ee:	83 ec 0c             	sub    $0xc,%esp
  8014f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8014f4:	e8 52 0e 00 00       	call   80234b <alloc_block_FF>
  8014f9:	83 c4 10             	add    $0x10,%esp
  8014fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8014ff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  801503:	74 16                	je     80151b <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801505:	83 ec 0c             	sub    $0xc,%esp
  801508:	ff 75 e8             	pushl  -0x18(%ebp)
  80150b:	e8 3b 0c 00 00       	call   80214b <insert_sorted_allocList>
  801510:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  801513:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801516:	8b 40 08             	mov    0x8(%eax),%eax
  801519:	eb 05                	jmp    801520 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801520:	c9                   	leave  
  801521:	c3                   	ret    

00801522 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801528:	8b 45 08             	mov    0x8(%ebp),%eax
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	50                   	push   %eax
  80152f:	68 40 40 80 00       	push   $0x804040
  801534:	e8 ba 0b 00 00       	call   8020f3 <find_block>
  801539:	83 c4 10             	add    $0x10,%esp
  80153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  80153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801542:	8b 40 0c             	mov    0xc(%eax),%eax
  801545:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801548:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80154c:	0f 84 9f 00 00 00    	je     8015f1 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	ff 75 f0             	pushl  -0x10(%ebp)
  80155b:	50                   	push   %eax
  80155c:	e8 f7 03 00 00       	call   801958 <sys_free_user_mem>
  801561:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801564:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801568:	75 14                	jne    80157e <free+0x5c>
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	68 15 3b 80 00       	push   $0x803b15
  801572:	6a 6a                	push   $0x6a
  801574:	68 33 3b 80 00       	push   $0x803b33
  801579:	e8 3f ed ff ff       	call   8002bd <_panic>
  80157e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801581:	8b 00                	mov    (%eax),%eax
  801583:	85 c0                	test   %eax,%eax
  801585:	74 10                	je     801597 <free+0x75>
  801587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158a:	8b 00                	mov    (%eax),%eax
  80158c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80158f:	8b 52 04             	mov    0x4(%edx),%edx
  801592:	89 50 04             	mov    %edx,0x4(%eax)
  801595:	eb 0b                	jmp    8015a2 <free+0x80>
  801597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159a:	8b 40 04             	mov    0x4(%eax),%eax
  80159d:	a3 44 40 80 00       	mov    %eax,0x804044
  8015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a5:	8b 40 04             	mov    0x4(%eax),%eax
  8015a8:	85 c0                	test   %eax,%eax
  8015aa:	74 0f                	je     8015bb <free+0x99>
  8015ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015af:	8b 40 04             	mov    0x4(%eax),%eax
  8015b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b5:	8b 12                	mov    (%edx),%edx
  8015b7:	89 10                	mov    %edx,(%eax)
  8015b9:	eb 0a                	jmp    8015c5 <free+0xa3>
  8015bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015be:	8b 00                	mov    (%eax),%eax
  8015c0:	a3 40 40 80 00       	mov    %eax,0x804040
  8015c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015d8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015dd:	48                   	dec    %eax
  8015de:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8015e3:	83 ec 0c             	sub    $0xc,%esp
  8015e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e9:	e8 65 13 00 00       	call   802953 <insert_sorted_with_merge_freeList>
  8015ee:	83 c4 10             	add    $0x10,%esp
	}
}
  8015f1:	90                   	nop
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	83 ec 28             	sub    $0x28,%esp
  8015fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8015fd:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801600:	e8 f6 fc ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  801605:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801609:	75 0a                	jne    801615 <smalloc+0x21>
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
  801610:	e9 af 00 00 00       	jmp    8016c4 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801615:	e8 44 07 00 00       	call   801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  80161a:	83 f8 01             	cmp    $0x1,%eax
  80161d:	0f 85 9c 00 00 00    	jne    8016bf <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801623:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80162a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80162d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801630:	01 d0                	add    %edx,%eax
  801632:	48                   	dec    %eax
  801633:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801636:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801639:	ba 00 00 00 00       	mov    $0x0,%edx
  80163e:	f7 75 f4             	divl   -0xc(%ebp)
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	29 d0                	sub    %edx,%eax
  801646:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801649:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801650:	76 07                	jbe    801659 <smalloc+0x65>
			return NULL;
  801652:	b8 00 00 00 00       	mov    $0x0,%eax
  801657:	eb 6b                	jmp    8016c4 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801659:	83 ec 0c             	sub    $0xc,%esp
  80165c:	ff 75 0c             	pushl  0xc(%ebp)
  80165f:	e8 e7 0c 00 00       	call   80234b <alloc_block_FF>
  801664:	83 c4 10             	add    $0x10,%esp
  801667:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80166a:	83 ec 0c             	sub    $0xc,%esp
  80166d:	ff 75 ec             	pushl  -0x14(%ebp)
  801670:	e8 d6 0a 00 00       	call   80214b <insert_sorted_allocList>
  801675:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801678:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80167c:	75 07                	jne    801685 <smalloc+0x91>
		{
			return NULL;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
  801683:	eb 3f                	jmp    8016c4 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801685:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801688:	8b 40 08             	mov    0x8(%eax),%eax
  80168b:	89 c2                	mov    %eax,%edx
  80168d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801691:	52                   	push   %edx
  801692:	50                   	push   %eax
  801693:	ff 75 0c             	pushl  0xc(%ebp)
  801696:	ff 75 08             	pushl  0x8(%ebp)
  801699:	e8 45 04 00 00       	call   801ae3 <sys_createSharedObject>
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8016a4:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016a8:	74 06                	je     8016b0 <smalloc+0xbc>
  8016aa:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016ae:	75 07                	jne    8016b7 <smalloc+0xc3>
		{
			return NULL;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 0d                	jmp    8016c4 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8016b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ba:	8b 40 08             	mov    0x8(%eax),%eax
  8016bd:	eb 05                	jmp    8016c4 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8016bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016cc:	e8 2a fc ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016d1:	83 ec 08             	sub    $0x8,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	ff 75 08             	pushl  0x8(%ebp)
  8016da:	e8 2e 04 00 00       	call   801b0d <sys_getSizeOfSharedObject>
  8016df:	83 c4 10             	add    $0x10,%esp
  8016e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8016e5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016e9:	75 0a                	jne    8016f5 <sget+0x2f>
	{
		return NULL;
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f0:	e9 94 00 00 00       	jmp    801789 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016f5:	e8 64 06 00 00       	call   801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	0f 84 82 00 00 00    	je     801784 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  801702:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801709:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801710:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801713:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801716:	01 d0                	add    %edx,%eax
  801718:	48                   	dec    %eax
  801719:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80171c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80171f:	ba 00 00 00 00       	mov    $0x0,%edx
  801724:	f7 75 ec             	divl   -0x14(%ebp)
  801727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80172a:	29 d0                	sub    %edx,%eax
  80172c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80172f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801732:	83 ec 0c             	sub    $0xc,%esp
  801735:	50                   	push   %eax
  801736:	e8 10 0c 00 00       	call   80234b <alloc_block_FF>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801741:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801745:	75 07                	jne    80174e <sget+0x88>
		{
			return NULL;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
  80174c:	eb 3b                	jmp    801789 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80174e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801751:	8b 40 08             	mov    0x8(%eax),%eax
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	50                   	push   %eax
  801758:	ff 75 0c             	pushl  0xc(%ebp)
  80175b:	ff 75 08             	pushl  0x8(%ebp)
  80175e:	e8 c7 03 00 00       	call   801b2a <sys_getSharedObject>
  801763:	83 c4 10             	add    $0x10,%esp
  801766:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801769:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80176d:	74 06                	je     801775 <sget+0xaf>
  80176f:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801773:	75 07                	jne    80177c <sget+0xb6>
		{
			return NULL;
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	eb 0d                	jmp    801789 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177f:	8b 40 08             	mov    0x8(%eax),%eax
  801782:	eb 05                	jmp    801789 <sget+0xc3>
		}
	}
	else
			return NULL;
  801784:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801789:	c9                   	leave  
  80178a:	c3                   	ret    

0080178b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801791:	e8 65 fb ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801796:	83 ec 04             	sub    $0x4,%esp
  801799:	68 40 3b 80 00       	push   $0x803b40
  80179e:	68 e1 00 00 00       	push   $0xe1
  8017a3:	68 33 3b 80 00       	push   $0x803b33
  8017a8:	e8 10 eb ff ff       	call   8002bd <_panic>

008017ad <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017b3:	83 ec 04             	sub    $0x4,%esp
  8017b6:	68 68 3b 80 00       	push   $0x803b68
  8017bb:	68 f5 00 00 00       	push   $0xf5
  8017c0:	68 33 3b 80 00       	push   $0x803b33
  8017c5:	e8 f3 ea ff ff       	call   8002bd <_panic>

008017ca <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017d0:	83 ec 04             	sub    $0x4,%esp
  8017d3:	68 8c 3b 80 00       	push   $0x803b8c
  8017d8:	68 00 01 00 00       	push   $0x100
  8017dd:	68 33 3b 80 00       	push   $0x803b33
  8017e2:	e8 d6 ea ff ff       	call   8002bd <_panic>

008017e7 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	68 8c 3b 80 00       	push   $0x803b8c
  8017f5:	68 05 01 00 00       	push   $0x105
  8017fa:	68 33 3b 80 00       	push   $0x803b33
  8017ff:	e8 b9 ea ff ff       	call   8002bd <_panic>

00801804 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	68 8c 3b 80 00       	push   $0x803b8c
  801812:	68 0a 01 00 00       	push   $0x10a
  801817:	68 33 3b 80 00       	push   $0x803b33
  80181c:	e8 9c ea ff ff       	call   8002bd <_panic>

00801821 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	57                   	push   %edi
  801825:	56                   	push   %esi
  801826:	53                   	push   %ebx
  801827:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80182a:	8b 45 08             	mov    0x8(%ebp),%eax
  80182d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801830:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801833:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801836:	8b 7d 18             	mov    0x18(%ebp),%edi
  801839:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80183c:	cd 30                	int    $0x30
  80183e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801841:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	5b                   	pop    %ebx
  801848:	5e                   	pop    %esi
  801849:	5f                   	pop    %edi
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    

0080184c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	83 ec 04             	sub    $0x4,%esp
  801852:	8b 45 10             	mov    0x10(%ebp),%eax
  801855:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801858:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	52                   	push   %edx
  801864:	ff 75 0c             	pushl  0xc(%ebp)
  801867:	50                   	push   %eax
  801868:	6a 00                	push   $0x0
  80186a:	e8 b2 ff ff ff       	call   801821 <syscall>
  80186f:	83 c4 18             	add    $0x18,%esp
}
  801872:	90                   	nop
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <sys_cgetc>:

int
sys_cgetc(void)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	6a 01                	push   $0x1
  801884:	e8 98 ff ff ff       	call   801821 <syscall>
  801889:	83 c4 18             	add    $0x18,%esp
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801891:	8b 55 0c             	mov    0xc(%ebp),%edx
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	52                   	push   %edx
  80189e:	50                   	push   %eax
  80189f:	6a 05                	push   $0x5
  8018a1:	e8 7b ff ff ff       	call   801821 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	56                   	push   %esi
  8018af:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018b0:	8b 75 18             	mov    0x18(%ebp),%esi
  8018b3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	51                   	push   %ecx
  8018c2:	52                   	push   %edx
  8018c3:	50                   	push   %eax
  8018c4:	6a 06                	push   $0x6
  8018c6:	e8 56 ff ff ff       	call   801821 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
}
  8018ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018d1:	5b                   	pop    %ebx
  8018d2:	5e                   	pop    %esi
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    

008018d5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	52                   	push   %edx
  8018e5:	50                   	push   %eax
  8018e6:	6a 07                	push   $0x7
  8018e8:	e8 34 ff ff ff       	call   801821 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	ff 75 0c             	pushl  0xc(%ebp)
  8018fe:	ff 75 08             	pushl  0x8(%ebp)
  801901:	6a 08                	push   $0x8
  801903:	e8 19 ff ff ff       	call   801821 <syscall>
  801908:	83 c4 18             	add    $0x18,%esp
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 09                	push   $0x9
  80191c:	e8 00 ff ff ff       	call   801821 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	c9                   	leave  
  801925:	c3                   	ret    

00801926 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801926:	55                   	push   %ebp
  801927:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 0a                	push   $0xa
  801935:	e8 e7 fe ff ff       	call   801821 <syscall>
  80193a:	83 c4 18             	add    $0x18,%esp
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 0b                	push   $0xb
  80194e:	e8 ce fe ff ff       	call   801821 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 0f                	push   $0xf
  801969:	e8 b3 fe ff ff       	call   801821 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
	return;
  801971:	90                   	nop
}
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	ff 75 08             	pushl  0x8(%ebp)
  801983:	6a 10                	push   $0x10
  801985:	e8 97 fe ff ff       	call   801821 <syscall>
  80198a:	83 c4 18             	add    $0x18,%esp
	return ;
  80198d:	90                   	nop
}
  80198e:	c9                   	leave  
  80198f:	c3                   	ret    

00801990 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801990:	55                   	push   %ebp
  801991:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	ff 75 10             	pushl  0x10(%ebp)
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	ff 75 08             	pushl  0x8(%ebp)
  8019a0:	6a 11                	push   $0x11
  8019a2:	e8 7a fe ff ff       	call   801821 <syscall>
  8019a7:	83 c4 18             	add    $0x18,%esp
	return ;
  8019aa:	90                   	nop
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 0c                	push   $0xc
  8019bc:	e8 60 fe ff ff       	call   801821 <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 0d                	push   $0xd
  8019d6:	e8 46 fe ff ff       	call   801821 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 0e                	push   $0xe
  8019ef:	e8 2d fe ff ff       	call   801821 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	90                   	nop
  8019f8:	c9                   	leave  
  8019f9:	c3                   	ret    

008019fa <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019fa:	55                   	push   %ebp
  8019fb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 13                	push   $0x13
  801a09:	e8 13 fe ff ff       	call   801821 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
}
  801a11:	90                   	nop
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 14                	push   $0x14
  801a23:	e8 f9 fd ff ff       	call   801821 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	90                   	nop
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_cputc>:


void
sys_cputc(const char c)
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 04             	sub    $0x4,%esp
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a3a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	50                   	push   %eax
  801a47:	6a 15                	push   $0x15
  801a49:	e8 d3 fd ff ff       	call   801821 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
}
  801a51:	90                   	nop
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 16                	push   $0x16
  801a63:	e8 b9 fd ff ff       	call   801821 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a71:	8b 45 08             	mov    0x8(%ebp),%eax
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	50                   	push   %eax
  801a7e:	6a 17                	push   $0x17
  801a80:	e8 9c fd ff ff       	call   801821 <syscall>
  801a85:	83 c4 18             	add    $0x18,%esp
}
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	6a 1a                	push   $0x1a
  801a9d:	e8 7f fd ff ff       	call   801821 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aad:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	52                   	push   %edx
  801ab7:	50                   	push   %eax
  801ab8:	6a 18                	push   $0x18
  801aba:	e8 62 fd ff ff       	call   801821 <syscall>
  801abf:	83 c4 18             	add    $0x18,%esp
}
  801ac2:	90                   	nop
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	52                   	push   %edx
  801ad5:	50                   	push   %eax
  801ad6:	6a 19                	push   $0x19
  801ad8:	e8 44 fd ff ff       	call   801821 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	90                   	nop
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	8b 45 10             	mov    0x10(%ebp),%eax
  801aec:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aef:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801af2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	51                   	push   %ecx
  801afc:	52                   	push   %edx
  801afd:	ff 75 0c             	pushl  0xc(%ebp)
  801b00:	50                   	push   %eax
  801b01:	6a 1b                	push   $0x1b
  801b03:	e8 19 fd ff ff       	call   801821 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 1c                	push   $0x1c
  801b20:	e8 fc fc ff ff       	call   801821 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b33:	8b 45 08             	mov    0x8(%ebp),%eax
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	51                   	push   %ecx
  801b3b:	52                   	push   %edx
  801b3c:	50                   	push   %eax
  801b3d:	6a 1d                	push   $0x1d
  801b3f:	e8 dd fc ff ff       	call   801821 <syscall>
  801b44:	83 c4 18             	add    $0x18,%esp
}
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	52                   	push   %edx
  801b59:	50                   	push   %eax
  801b5a:	6a 1e                	push   $0x1e
  801b5c:	e8 c0 fc ff ff       	call   801821 <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 1f                	push   $0x1f
  801b75:	e8 a7 fc ff ff       	call   801821 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	6a 00                	push   $0x0
  801b87:	ff 75 14             	pushl  0x14(%ebp)
  801b8a:	ff 75 10             	pushl  0x10(%ebp)
  801b8d:	ff 75 0c             	pushl  0xc(%ebp)
  801b90:	50                   	push   %eax
  801b91:	6a 20                	push   $0x20
  801b93:	e8 89 fc ff ff       	call   801821 <syscall>
  801b98:	83 c4 18             	add    $0x18,%esp
}
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	50                   	push   %eax
  801bac:	6a 21                	push   $0x21
  801bae:	e8 6e fc ff ff       	call   801821 <syscall>
  801bb3:	83 c4 18             	add    $0x18,%esp
}
  801bb6:	90                   	nop
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	50                   	push   %eax
  801bc8:	6a 22                	push   $0x22
  801bca:	e8 52 fc ff ff       	call   801821 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 02                	push   $0x2
  801be3:	e8 39 fc ff ff       	call   801821 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 03                	push   $0x3
  801bfc:	e8 20 fc ff ff       	call   801821 <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 04                	push   $0x4
  801c15:	e8 07 fc ff ff       	call   801821 <syscall>
  801c1a:	83 c4 18             	add    $0x18,%esp
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_exit_env>:


void sys_exit_env(void)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	6a 00                	push   $0x0
  801c2c:	6a 23                	push   $0x23
  801c2e:	e8 ee fb ff ff       	call   801821 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	90                   	nop
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c3f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c42:	8d 50 04             	lea    0x4(%eax),%edx
  801c45:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	52                   	push   %edx
  801c4f:	50                   	push   %eax
  801c50:	6a 24                	push   $0x24
  801c52:	e8 ca fb ff ff       	call   801821 <syscall>
  801c57:	83 c4 18             	add    $0x18,%esp
	return result;
  801c5a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c63:	89 01                	mov    %eax,(%ecx)
  801c65:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	c9                   	leave  
  801c6c:	c2 04 00             	ret    $0x4

00801c6f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	ff 75 10             	pushl  0x10(%ebp)
  801c79:	ff 75 0c             	pushl  0xc(%ebp)
  801c7c:	ff 75 08             	pushl  0x8(%ebp)
  801c7f:	6a 12                	push   $0x12
  801c81:	e8 9b fb ff ff       	call   801821 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
	return ;
  801c89:	90                   	nop
}
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_rcr2>:
uint32 sys_rcr2()
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 25                	push   $0x25
  801c9b:	e8 81 fb ff ff       	call   801821 <syscall>
  801ca0:	83 c4 18             	add    $0x18,%esp
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 04             	sub    $0x4,%esp
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cb1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	50                   	push   %eax
  801cbe:	6a 26                	push   $0x26
  801cc0:	e8 5c fb ff ff       	call   801821 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc8:	90                   	nop
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <rsttst>:
void rsttst()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 28                	push   $0x28
  801cda:	e8 42 fb ff ff       	call   801821 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 04             	sub    $0x4,%esp
  801ceb:	8b 45 14             	mov    0x14(%ebp),%eax
  801cee:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cf1:	8b 55 18             	mov    0x18(%ebp),%edx
  801cf4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf8:	52                   	push   %edx
  801cf9:	50                   	push   %eax
  801cfa:	ff 75 10             	pushl  0x10(%ebp)
  801cfd:	ff 75 0c             	pushl  0xc(%ebp)
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	6a 27                	push   $0x27
  801d05:	e8 17 fb ff ff       	call   801821 <syscall>
  801d0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0d:	90                   	nop
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <chktst>:
void chktst(uint32 n)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	ff 75 08             	pushl  0x8(%ebp)
  801d1e:	6a 29                	push   $0x29
  801d20:	e8 fc fa ff ff       	call   801821 <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
	return ;
  801d28:	90                   	nop
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <inctst>:

void inctst()
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 2a                	push   $0x2a
  801d3a:	e8 e2 fa ff ff       	call   801821 <syscall>
  801d3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d42:	90                   	nop
}
  801d43:	c9                   	leave  
  801d44:	c3                   	ret    

00801d45 <gettst>:
uint32 gettst()
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 00                	push   $0x0
  801d52:	6a 2b                	push   $0x2b
  801d54:	e8 c8 fa ff ff       	call   801821 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d5e:	55                   	push   %ebp
  801d5f:	89 e5                	mov    %esp,%ebp
  801d61:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 2c                	push   $0x2c
  801d70:	e8 ac fa ff ff       	call   801821 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
  801d78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d7b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d7f:	75 07                	jne    801d88 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	eb 05                	jmp    801d8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 2c                	push   $0x2c
  801da1:	e8 7b fa ff ff       	call   801821 <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
  801da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dac:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801db0:	75 07                	jne    801db9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801db2:	b8 01 00 00 00       	mov    $0x1,%eax
  801db7:	eb 05                	jmp    801dbe <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
  801dc3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 2c                	push   $0x2c
  801dd2:	e8 4a fa ff ff       	call   801821 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
  801dda:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ddd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801de1:	75 07                	jne    801dea <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801de3:	b8 01 00 00 00       	mov    $0x1,%eax
  801de8:	eb 05                	jmp    801def <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 2c                	push   $0x2c
  801e03:	e8 19 fa ff ff       	call   801821 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
  801e0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e0e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e12:	75 07                	jne    801e1b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e14:	b8 01 00 00 00       	mov    $0x1,%eax
  801e19:	eb 05                	jmp    801e20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	ff 75 08             	pushl  0x8(%ebp)
  801e30:	6a 2d                	push   $0x2d
  801e32:	e8 ea f9 ff ff       	call   801821 <syscall>
  801e37:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3a:	90                   	nop
}
  801e3b:	c9                   	leave  
  801e3c:	c3                   	ret    

00801e3d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e41:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e44:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	6a 00                	push   $0x0
  801e4f:	53                   	push   %ebx
  801e50:	51                   	push   %ecx
  801e51:	52                   	push   %edx
  801e52:	50                   	push   %eax
  801e53:	6a 2e                	push   $0x2e
  801e55:	e8 c7 f9 ff ff       	call   801821 <syscall>
  801e5a:	83 c4 18             	add    $0x18,%esp
}
  801e5d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	52                   	push   %edx
  801e72:	50                   	push   %eax
  801e73:	6a 2f                	push   $0x2f
  801e75:	e8 a7 f9 ff ff       	call   801821 <syscall>
  801e7a:	83 c4 18             	add    $0x18,%esp
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e85:	83 ec 0c             	sub    $0xc,%esp
  801e88:	68 9c 3b 80 00       	push   $0x803b9c
  801e8d:	e8 df e6 ff ff       	call   800571 <cprintf>
  801e92:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e95:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e9c:	83 ec 0c             	sub    $0xc,%esp
  801e9f:	68 c8 3b 80 00       	push   $0x803bc8
  801ea4:	e8 c8 e6 ff ff       	call   800571 <cprintf>
  801ea9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eac:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eb0:	a1 38 41 80 00       	mov    0x804138,%eax
  801eb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb8:	eb 56                	jmp    801f10 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ebe:	74 1c                	je     801edc <print_mem_block_lists+0x5d>
  801ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec3:	8b 50 08             	mov    0x8(%eax),%edx
  801ec6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec9:	8b 48 08             	mov    0x8(%eax),%ecx
  801ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecf:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed2:	01 c8                	add    %ecx,%eax
  801ed4:	39 c2                	cmp    %eax,%edx
  801ed6:	73 04                	jae    801edc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ed8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edf:	8b 50 08             	mov    0x8(%eax),%edx
  801ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee8:	01 c2                	add    %eax,%edx
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	8b 40 08             	mov    0x8(%eax),%eax
  801ef0:	83 ec 04             	sub    $0x4,%esp
  801ef3:	52                   	push   %edx
  801ef4:	50                   	push   %eax
  801ef5:	68 dd 3b 80 00       	push   $0x803bdd
  801efa:	e8 72 e6 ff ff       	call   800571 <cprintf>
  801eff:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f05:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f08:	a1 40 41 80 00       	mov    0x804140,%eax
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f14:	74 07                	je     801f1d <print_mem_block_lists+0x9e>
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	8b 00                	mov    (%eax),%eax
  801f1b:	eb 05                	jmp    801f22 <print_mem_block_lists+0xa3>
  801f1d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f22:	a3 40 41 80 00       	mov    %eax,0x804140
  801f27:	a1 40 41 80 00       	mov    0x804140,%eax
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	75 8a                	jne    801eba <print_mem_block_lists+0x3b>
  801f30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f34:	75 84                	jne    801eba <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f36:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f3a:	75 10                	jne    801f4c <print_mem_block_lists+0xcd>
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	68 ec 3b 80 00       	push   $0x803bec
  801f44:	e8 28 e6 ff ff       	call   800571 <cprintf>
  801f49:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f53:	83 ec 0c             	sub    $0xc,%esp
  801f56:	68 10 3c 80 00       	push   $0x803c10
  801f5b:	e8 11 e6 ff ff       	call   800571 <cprintf>
  801f60:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f63:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f67:	a1 40 40 80 00       	mov    0x804040,%eax
  801f6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6f:	eb 56                	jmp    801fc7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f71:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f75:	74 1c                	je     801f93 <print_mem_block_lists+0x114>
  801f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7a:	8b 50 08             	mov    0x8(%eax),%edx
  801f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f80:	8b 48 08             	mov    0x8(%eax),%ecx
  801f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f86:	8b 40 0c             	mov    0xc(%eax),%eax
  801f89:	01 c8                	add    %ecx,%eax
  801f8b:	39 c2                	cmp    %eax,%edx
  801f8d:	73 04                	jae    801f93 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f8f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 50 08             	mov    0x8(%eax),%edx
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9f:	01 c2                	add    %eax,%edx
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	8b 40 08             	mov    0x8(%eax),%eax
  801fa7:	83 ec 04             	sub    $0x4,%esp
  801faa:	52                   	push   %edx
  801fab:	50                   	push   %eax
  801fac:	68 dd 3b 80 00       	push   $0x803bdd
  801fb1:	e8 bb e5 ff ff       	call   800571 <cprintf>
  801fb6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fbf:	a1 48 40 80 00       	mov    0x804048,%eax
  801fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fcb:	74 07                	je     801fd4 <print_mem_block_lists+0x155>
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	8b 00                	mov    (%eax),%eax
  801fd2:	eb 05                	jmp    801fd9 <print_mem_block_lists+0x15a>
  801fd4:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd9:	a3 48 40 80 00       	mov    %eax,0x804048
  801fde:	a1 48 40 80 00       	mov    0x804048,%eax
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	75 8a                	jne    801f71 <print_mem_block_lists+0xf2>
  801fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801feb:	75 84                	jne    801f71 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fed:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ff1:	75 10                	jne    802003 <print_mem_block_lists+0x184>
  801ff3:	83 ec 0c             	sub    $0xc,%esp
  801ff6:	68 28 3c 80 00       	push   $0x803c28
  801ffb:	e8 71 e5 ff ff       	call   800571 <cprintf>
  802000:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	68 9c 3b 80 00       	push   $0x803b9c
  80200b:	e8 61 e5 ff ff       	call   800571 <cprintf>
  802010:	83 c4 10             	add    $0x10,%esp

}
  802013:	90                   	nop
  802014:	c9                   	leave  
  802015:	c3                   	ret    

00802016 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80201c:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802023:	00 00 00 
  802026:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80202d:	00 00 00 
  802030:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802037:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80203a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802041:	e9 9e 00 00 00       	jmp    8020e4 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802046:	a1 50 40 80 00       	mov    0x804050,%eax
  80204b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80204e:	c1 e2 04             	shl    $0x4,%edx
  802051:	01 d0                	add    %edx,%eax
  802053:	85 c0                	test   %eax,%eax
  802055:	75 14                	jne    80206b <initialize_MemBlocksList+0x55>
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	68 50 3c 80 00       	push   $0x803c50
  80205f:	6a 42                	push   $0x42
  802061:	68 73 3c 80 00       	push   $0x803c73
  802066:	e8 52 e2 ff ff       	call   8002bd <_panic>
  80206b:	a1 50 40 80 00       	mov    0x804050,%eax
  802070:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802073:	c1 e2 04             	shl    $0x4,%edx
  802076:	01 d0                	add    %edx,%eax
  802078:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80207e:	89 10                	mov    %edx,(%eax)
  802080:	8b 00                	mov    (%eax),%eax
  802082:	85 c0                	test   %eax,%eax
  802084:	74 18                	je     80209e <initialize_MemBlocksList+0x88>
  802086:	a1 48 41 80 00       	mov    0x804148,%eax
  80208b:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802091:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802094:	c1 e1 04             	shl    $0x4,%ecx
  802097:	01 ca                	add    %ecx,%edx
  802099:	89 50 04             	mov    %edx,0x4(%eax)
  80209c:	eb 12                	jmp    8020b0 <initialize_MemBlocksList+0x9a>
  80209e:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	c1 e2 04             	shl    $0x4,%edx
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020b0:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b8:	c1 e2 04             	shl    $0x4,%edx
  8020bb:	01 d0                	add    %edx,%eax
  8020bd:	a3 48 41 80 00       	mov    %eax,0x804148
  8020c2:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ca:	c1 e2 04             	shl    $0x4,%edx
  8020cd:	01 d0                	add    %edx,%eax
  8020cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020d6:	a1 54 41 80 00       	mov    0x804154,%eax
  8020db:	40                   	inc    %eax
  8020dc:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8020e1:	ff 45 f4             	incl   -0xc(%ebp)
  8020e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ea:	0f 82 56 ff ff ff    	jb     802046 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8020f0:	90                   	nop
  8020f1:	c9                   	leave  
  8020f2:	c3                   	ret    

008020f3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	8b 00                	mov    (%eax),%eax
  8020fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802101:	eb 19                	jmp    80211c <find_block+0x29>
	{
		if(blk->sva==va)
  802103:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802106:	8b 40 08             	mov    0x8(%eax),%eax
  802109:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80210c:	75 05                	jne    802113 <find_block+0x20>
			return (blk);
  80210e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802111:	eb 36                	jmp    802149 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802113:	8b 45 08             	mov    0x8(%ebp),%eax
  802116:	8b 40 08             	mov    0x8(%eax),%eax
  802119:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80211c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802120:	74 07                	je     802129 <find_block+0x36>
  802122:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802125:	8b 00                	mov    (%eax),%eax
  802127:	eb 05                	jmp    80212e <find_block+0x3b>
  802129:	b8 00 00 00 00       	mov    $0x0,%eax
  80212e:	8b 55 08             	mov    0x8(%ebp),%edx
  802131:	89 42 08             	mov    %eax,0x8(%edx)
  802134:	8b 45 08             	mov    0x8(%ebp),%eax
  802137:	8b 40 08             	mov    0x8(%eax),%eax
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 c5                	jne    802103 <find_block+0x10>
  80213e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802142:	75 bf                	jne    802103 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802144:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802151:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802156:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802159:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802160:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802163:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802166:	75 65                	jne    8021cd <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802168:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80216c:	75 14                	jne    802182 <insert_sorted_allocList+0x37>
  80216e:	83 ec 04             	sub    $0x4,%esp
  802171:	68 50 3c 80 00       	push   $0x803c50
  802176:	6a 5c                	push   $0x5c
  802178:	68 73 3c 80 00       	push   $0x803c73
  80217d:	e8 3b e1 ff ff       	call   8002bd <_panic>
  802182:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	89 10                	mov    %edx,(%eax)
  80218d:	8b 45 08             	mov    0x8(%ebp),%eax
  802190:	8b 00                	mov    (%eax),%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	74 0d                	je     8021a3 <insert_sorted_allocList+0x58>
  802196:	a1 40 40 80 00       	mov    0x804040,%eax
  80219b:	8b 55 08             	mov    0x8(%ebp),%edx
  80219e:	89 50 04             	mov    %edx,0x4(%eax)
  8021a1:	eb 08                	jmp    8021ab <insert_sorted_allocList+0x60>
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	a3 40 40 80 00       	mov    %eax,0x804040
  8021b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021bd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021c2:	40                   	inc    %eax
  8021c3:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8021c8:	e9 7b 01 00 00       	jmp    802348 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8021cd:	a1 44 40 80 00       	mov    0x804044,%eax
  8021d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8021d5:	a1 40 40 80 00       	mov    0x804040,%eax
  8021da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	8b 50 08             	mov    0x8(%eax),%edx
  8021e3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021e6:	8b 40 08             	mov    0x8(%eax),%eax
  8021e9:	39 c2                	cmp    %eax,%edx
  8021eb:	76 65                	jbe    802252 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8021ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f1:	75 14                	jne    802207 <insert_sorted_allocList+0xbc>
  8021f3:	83 ec 04             	sub    $0x4,%esp
  8021f6:	68 8c 3c 80 00       	push   $0x803c8c
  8021fb:	6a 64                	push   $0x64
  8021fd:	68 73 3c 80 00       	push   $0x803c73
  802202:	e8 b6 e0 ff ff       	call   8002bd <_panic>
  802207:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	89 50 04             	mov    %edx,0x4(%eax)
  802213:	8b 45 08             	mov    0x8(%ebp),%eax
  802216:	8b 40 04             	mov    0x4(%eax),%eax
  802219:	85 c0                	test   %eax,%eax
  80221b:	74 0c                	je     802229 <insert_sorted_allocList+0xde>
  80221d:	a1 44 40 80 00       	mov    0x804044,%eax
  802222:	8b 55 08             	mov    0x8(%ebp),%edx
  802225:	89 10                	mov    %edx,(%eax)
  802227:	eb 08                	jmp    802231 <insert_sorted_allocList+0xe6>
  802229:	8b 45 08             	mov    0x8(%ebp),%eax
  80222c:	a3 40 40 80 00       	mov    %eax,0x804040
  802231:	8b 45 08             	mov    0x8(%ebp),%eax
  802234:	a3 44 40 80 00       	mov    %eax,0x804044
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802242:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802247:	40                   	inc    %eax
  802248:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80224d:	e9 f6 00 00 00       	jmp    802348 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	8b 50 08             	mov    0x8(%eax),%edx
  802258:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80225b:	8b 40 08             	mov    0x8(%eax),%eax
  80225e:	39 c2                	cmp    %eax,%edx
  802260:	73 65                	jae    8022c7 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802262:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802266:	75 14                	jne    80227c <insert_sorted_allocList+0x131>
  802268:	83 ec 04             	sub    $0x4,%esp
  80226b:	68 50 3c 80 00       	push   $0x803c50
  802270:	6a 68                	push   $0x68
  802272:	68 73 3c 80 00       	push   $0x803c73
  802277:	e8 41 e0 ff ff       	call   8002bd <_panic>
  80227c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	89 10                	mov    %edx,(%eax)
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 0d                	je     80229d <insert_sorted_allocList+0x152>
  802290:	a1 40 40 80 00       	mov    0x804040,%eax
  802295:	8b 55 08             	mov    0x8(%ebp),%edx
  802298:	89 50 04             	mov    %edx,0x4(%eax)
  80229b:	eb 08                	jmp    8022a5 <insert_sorted_allocList+0x15a>
  80229d:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a0:	a3 44 40 80 00       	mov    %eax,0x804044
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022bc:	40                   	inc    %eax
  8022bd:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022c2:	e9 81 00 00 00       	jmp    802348 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022c7:	a1 40 40 80 00       	mov    0x804040,%eax
  8022cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022cf:	eb 51                	jmp    802322 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	8b 50 08             	mov    0x8(%eax),%edx
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	8b 40 08             	mov    0x8(%eax),%eax
  8022dd:	39 c2                	cmp    %eax,%edx
  8022df:	73 39                	jae    80231a <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8022e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e4:	8b 40 04             	mov    0x4(%eax),%eax
  8022e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8022ea:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f0:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022f8:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802301:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 55 08             	mov    0x8(%ebp),%edx
  802309:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  80230c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802311:	40                   	inc    %eax
  802312:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802317:	90                   	nop
				}
			}
		 }

	}
}
  802318:	eb 2e                	jmp    802348 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80231a:	a1 48 40 80 00       	mov    0x804048,%eax
  80231f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802322:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802326:	74 07                	je     80232f <insert_sorted_allocList+0x1e4>
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 00                	mov    (%eax),%eax
  80232d:	eb 05                	jmp    802334 <insert_sorted_allocList+0x1e9>
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
  802334:	a3 48 40 80 00       	mov    %eax,0x804048
  802339:	a1 48 40 80 00       	mov    0x804048,%eax
  80233e:	85 c0                	test   %eax,%eax
  802340:	75 8f                	jne    8022d1 <insert_sorted_allocList+0x186>
  802342:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802346:	75 89                	jne    8022d1 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802348:	90                   	nop
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802351:	a1 38 41 80 00       	mov    0x804138,%eax
  802356:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802359:	e9 76 01 00 00       	jmp    8024d4 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 40 0c             	mov    0xc(%eax),%eax
  802364:	3b 45 08             	cmp    0x8(%ebp),%eax
  802367:	0f 85 8a 00 00 00    	jne    8023f7 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80236d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802371:	75 17                	jne    80238a <alloc_block_FF+0x3f>
  802373:	83 ec 04             	sub    $0x4,%esp
  802376:	68 af 3c 80 00       	push   $0x803caf
  80237b:	68 8a 00 00 00       	push   $0x8a
  802380:	68 73 3c 80 00       	push   $0x803c73
  802385:	e8 33 df ff ff       	call   8002bd <_panic>
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	85 c0                	test   %eax,%eax
  802391:	74 10                	je     8023a3 <alloc_block_FF+0x58>
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	8b 00                	mov    (%eax),%eax
  802398:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239b:	8b 52 04             	mov    0x4(%edx),%edx
  80239e:	89 50 04             	mov    %edx,0x4(%eax)
  8023a1:	eb 0b                	jmp    8023ae <alloc_block_FF+0x63>
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	8b 40 04             	mov    0x4(%eax),%eax
  8023a9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 40 04             	mov    0x4(%eax),%eax
  8023b4:	85 c0                	test   %eax,%eax
  8023b6:	74 0f                	je     8023c7 <alloc_block_FF+0x7c>
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 40 04             	mov    0x4(%eax),%eax
  8023be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c1:	8b 12                	mov    (%edx),%edx
  8023c3:	89 10                	mov    %edx,(%eax)
  8023c5:	eb 0a                	jmp    8023d1 <alloc_block_FF+0x86>
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	8b 00                	mov    (%eax),%eax
  8023cc:	a3 38 41 80 00       	mov    %eax,0x804138
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e4:	a1 44 41 80 00       	mov    0x804144,%eax
  8023e9:	48                   	dec    %eax
  8023ea:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	e9 10 01 00 00       	jmp    802507 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8023f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8023fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802400:	0f 86 c6 00 00 00    	jbe    8024cc <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802406:	a1 48 41 80 00       	mov    0x804148,%eax
  80240b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80240e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802412:	75 17                	jne    80242b <alloc_block_FF+0xe0>
  802414:	83 ec 04             	sub    $0x4,%esp
  802417:	68 af 3c 80 00       	push   $0x803caf
  80241c:	68 90 00 00 00       	push   $0x90
  802421:	68 73 3c 80 00       	push   $0x803c73
  802426:	e8 92 de ff ff       	call   8002bd <_panic>
  80242b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242e:	8b 00                	mov    (%eax),%eax
  802430:	85 c0                	test   %eax,%eax
  802432:	74 10                	je     802444 <alloc_block_FF+0xf9>
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80243c:	8b 52 04             	mov    0x4(%edx),%edx
  80243f:	89 50 04             	mov    %edx,0x4(%eax)
  802442:	eb 0b                	jmp    80244f <alloc_block_FF+0x104>
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	8b 40 04             	mov    0x4(%eax),%eax
  80244a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80244f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802452:	8b 40 04             	mov    0x4(%eax),%eax
  802455:	85 c0                	test   %eax,%eax
  802457:	74 0f                	je     802468 <alloc_block_FF+0x11d>
  802459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245c:	8b 40 04             	mov    0x4(%eax),%eax
  80245f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802462:	8b 12                	mov    (%edx),%edx
  802464:	89 10                	mov    %edx,(%eax)
  802466:	eb 0a                	jmp    802472 <alloc_block_FF+0x127>
  802468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246b:	8b 00                	mov    (%eax),%eax
  80246d:	a3 48 41 80 00       	mov    %eax,0x804148
  802472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802475:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80247b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802485:	a1 54 41 80 00       	mov    0x804154,%eax
  80248a:	48                   	dec    %eax
  80248b:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802493:	8b 55 08             	mov    0x8(%ebp),%edx
  802496:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 50 08             	mov    0x8(%eax),%edx
  80249f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a2:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8024a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a8:	8b 50 08             	mov    0x8(%eax),%edx
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	01 c2                	add    %eax,%edx
  8024b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b3:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8024b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8024bf:	89 c2                	mov    %eax,%edx
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8024c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ca:	eb 3b                	jmp    802507 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8024cc:	a1 40 41 80 00       	mov    0x804140,%eax
  8024d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d8:	74 07                	je     8024e1 <alloc_block_FF+0x196>
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	8b 00                	mov    (%eax),%eax
  8024df:	eb 05                	jmp    8024e6 <alloc_block_FF+0x19b>
  8024e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8024e6:	a3 40 41 80 00       	mov    %eax,0x804140
  8024eb:	a1 40 41 80 00       	mov    0x804140,%eax
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	0f 85 66 fe ff ff    	jne    80235e <alloc_block_FF+0x13>
  8024f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fc:	0f 85 5c fe ff ff    	jne    80235e <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  802502:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802507:	c9                   	leave  
  802508:	c3                   	ret    

00802509 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802509:	55                   	push   %ebp
  80250a:	89 e5                	mov    %esp,%ebp
  80250c:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  80250f:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802516:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  80251d:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802524:	a1 38 41 80 00       	mov    0x804138,%eax
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252c:	e9 cf 00 00 00       	jmp    802600 <alloc_block_BF+0xf7>
		{
			c++;
  802531:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802537:	8b 40 0c             	mov    0xc(%eax),%eax
  80253a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80253d:	0f 85 8a 00 00 00    	jne    8025cd <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802543:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802547:	75 17                	jne    802560 <alloc_block_BF+0x57>
  802549:	83 ec 04             	sub    $0x4,%esp
  80254c:	68 af 3c 80 00       	push   $0x803caf
  802551:	68 a8 00 00 00       	push   $0xa8
  802556:	68 73 3c 80 00       	push   $0x803c73
  80255b:	e8 5d dd ff ff       	call   8002bd <_panic>
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 00                	mov    (%eax),%eax
  802565:	85 c0                	test   %eax,%eax
  802567:	74 10                	je     802579 <alloc_block_BF+0x70>
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	8b 00                	mov    (%eax),%eax
  80256e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802571:	8b 52 04             	mov    0x4(%edx),%edx
  802574:	89 50 04             	mov    %edx,0x4(%eax)
  802577:	eb 0b                	jmp    802584 <alloc_block_BF+0x7b>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 04             	mov    0x4(%eax),%eax
  80257f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 40 04             	mov    0x4(%eax),%eax
  80258a:	85 c0                	test   %eax,%eax
  80258c:	74 0f                	je     80259d <alloc_block_BF+0x94>
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	8b 40 04             	mov    0x4(%eax),%eax
  802594:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802597:	8b 12                	mov    (%edx),%edx
  802599:	89 10                	mov    %edx,(%eax)
  80259b:	eb 0a                	jmp    8025a7 <alloc_block_BF+0x9e>
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 00                	mov    (%eax),%eax
  8025a2:	a3 38 41 80 00       	mov    %eax,0x804138
  8025a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ba:	a1 44 41 80 00       	mov    0x804144,%eax
  8025bf:	48                   	dec    %eax
  8025c0:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	e9 85 01 00 00       	jmp    802752 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025d6:	76 20                	jbe    8025f8 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 40 0c             	mov    0xc(%eax),%eax
  8025de:	2b 45 08             	sub    0x8(%ebp),%eax
  8025e1:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8025e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025ea:	73 0c                	jae    8025f8 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8025ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8025f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025f8:	a1 40 41 80 00       	mov    0x804140,%eax
  8025fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802600:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802604:	74 07                	je     80260d <alloc_block_BF+0x104>
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 00                	mov    (%eax),%eax
  80260b:	eb 05                	jmp    802612 <alloc_block_BF+0x109>
  80260d:	b8 00 00 00 00       	mov    $0x0,%eax
  802612:	a3 40 41 80 00       	mov    %eax,0x804140
  802617:	a1 40 41 80 00       	mov    0x804140,%eax
  80261c:	85 c0                	test   %eax,%eax
  80261e:	0f 85 0d ff ff ff    	jne    802531 <alloc_block_BF+0x28>
  802624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802628:	0f 85 03 ff ff ff    	jne    802531 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80262e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802635:	a1 38 41 80 00       	mov    0x804138,%eax
  80263a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80263d:	e9 dd 00 00 00       	jmp    80271f <alloc_block_BF+0x216>
		{
			if(x==sol)
  802642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802645:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802648:	0f 85 c6 00 00 00    	jne    802714 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80264e:	a1 48 41 80 00       	mov    0x804148,%eax
  802653:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802656:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80265a:	75 17                	jne    802673 <alloc_block_BF+0x16a>
  80265c:	83 ec 04             	sub    $0x4,%esp
  80265f:	68 af 3c 80 00       	push   $0x803caf
  802664:	68 bb 00 00 00       	push   $0xbb
  802669:	68 73 3c 80 00       	push   $0x803c73
  80266e:	e8 4a dc ff ff       	call   8002bd <_panic>
  802673:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802676:	8b 00                	mov    (%eax),%eax
  802678:	85 c0                	test   %eax,%eax
  80267a:	74 10                	je     80268c <alloc_block_BF+0x183>
  80267c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267f:	8b 00                	mov    (%eax),%eax
  802681:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802684:	8b 52 04             	mov    0x4(%edx),%edx
  802687:	89 50 04             	mov    %edx,0x4(%eax)
  80268a:	eb 0b                	jmp    802697 <alloc_block_BF+0x18e>
  80268c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268f:	8b 40 04             	mov    0x4(%eax),%eax
  802692:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802697:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269a:	8b 40 04             	mov    0x4(%eax),%eax
  80269d:	85 c0                	test   %eax,%eax
  80269f:	74 0f                	je     8026b0 <alloc_block_BF+0x1a7>
  8026a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a4:	8b 40 04             	mov    0x4(%eax),%eax
  8026a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026aa:	8b 12                	mov    (%edx),%edx
  8026ac:	89 10                	mov    %edx,(%eax)
  8026ae:	eb 0a                	jmp    8026ba <alloc_block_BF+0x1b1>
  8026b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b3:	8b 00                	mov    (%eax),%eax
  8026b5:	a3 48 41 80 00       	mov    %eax,0x804148
  8026ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026cd:	a1 54 41 80 00       	mov    0x804154,%eax
  8026d2:	48                   	dec    %eax
  8026d3:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8026d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026db:	8b 55 08             	mov    0x8(%ebp),%edx
  8026de:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e4:	8b 50 08             	mov    0x8(%eax),%edx
  8026e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ea:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8026ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f0:	8b 50 08             	mov    0x8(%eax),%edx
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	01 c2                	add    %eax,%edx
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8026fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802701:	8b 40 0c             	mov    0xc(%eax),%eax
  802704:	2b 45 08             	sub    0x8(%ebp),%eax
  802707:	89 c2                	mov    %eax,%edx
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  80270f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802712:	eb 3e                	jmp    802752 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802714:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802717:	a1 40 41 80 00       	mov    0x804140,%eax
  80271c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802723:	74 07                	je     80272c <alloc_block_BF+0x223>
  802725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802728:	8b 00                	mov    (%eax),%eax
  80272a:	eb 05                	jmp    802731 <alloc_block_BF+0x228>
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	a3 40 41 80 00       	mov    %eax,0x804140
  802736:	a1 40 41 80 00       	mov    0x804140,%eax
  80273b:	85 c0                	test   %eax,%eax
  80273d:	0f 85 ff fe ff ff    	jne    802642 <alloc_block_BF+0x139>
  802743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802747:	0f 85 f5 fe ff ff    	jne    802642 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80274d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802752:	c9                   	leave  
  802753:	c3                   	ret    

00802754 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802754:	55                   	push   %ebp
  802755:	89 e5                	mov    %esp,%ebp
  802757:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80275a:	a1 28 40 80 00       	mov    0x804028,%eax
  80275f:	85 c0                	test   %eax,%eax
  802761:	75 14                	jne    802777 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802763:	a1 38 41 80 00       	mov    0x804138,%eax
  802768:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  80276d:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802774:	00 00 00 
	}
	uint32 c=1;
  802777:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80277e:	a1 60 41 80 00       	mov    0x804160,%eax
  802783:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802786:	e9 b3 01 00 00       	jmp    80293e <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80278b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278e:	8b 40 0c             	mov    0xc(%eax),%eax
  802791:	3b 45 08             	cmp    0x8(%ebp),%eax
  802794:	0f 85 a9 00 00 00    	jne    802843 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80279a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279d:	8b 00                	mov    (%eax),%eax
  80279f:	85 c0                	test   %eax,%eax
  8027a1:	75 0c                	jne    8027af <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8027a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8027a8:	a3 60 41 80 00       	mov    %eax,0x804160
  8027ad:	eb 0a                	jmp    8027b9 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b2:	8b 00                	mov    (%eax),%eax
  8027b4:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8027b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027bd:	75 17                	jne    8027d6 <alloc_block_NF+0x82>
  8027bf:	83 ec 04             	sub    $0x4,%esp
  8027c2:	68 af 3c 80 00       	push   $0x803caf
  8027c7:	68 e3 00 00 00       	push   $0xe3
  8027cc:	68 73 3c 80 00       	push   $0x803c73
  8027d1:	e8 e7 da ff ff       	call   8002bd <_panic>
  8027d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d9:	8b 00                	mov    (%eax),%eax
  8027db:	85 c0                	test   %eax,%eax
  8027dd:	74 10                	je     8027ef <alloc_block_NF+0x9b>
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e7:	8b 52 04             	mov    0x4(%edx),%edx
  8027ea:	89 50 04             	mov    %edx,0x4(%eax)
  8027ed:	eb 0b                	jmp    8027fa <alloc_block_NF+0xa6>
  8027ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f2:	8b 40 04             	mov    0x4(%eax),%eax
  8027f5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fd:	8b 40 04             	mov    0x4(%eax),%eax
  802800:	85 c0                	test   %eax,%eax
  802802:	74 0f                	je     802813 <alloc_block_NF+0xbf>
  802804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802807:	8b 40 04             	mov    0x4(%eax),%eax
  80280a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80280d:	8b 12                	mov    (%edx),%edx
  80280f:	89 10                	mov    %edx,(%eax)
  802811:	eb 0a                	jmp    80281d <alloc_block_NF+0xc9>
  802813:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	a3 38 41 80 00       	mov    %eax,0x804138
  80281d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802830:	a1 44 41 80 00       	mov    0x804144,%eax
  802835:	48                   	dec    %eax
  802836:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  80283b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283e:	e9 0e 01 00 00       	jmp    802951 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802843:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802846:	8b 40 0c             	mov    0xc(%eax),%eax
  802849:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284c:	0f 86 ce 00 00 00    	jbe    802920 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802852:	a1 48 41 80 00       	mov    0x804148,%eax
  802857:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80285a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80285e:	75 17                	jne    802877 <alloc_block_NF+0x123>
  802860:	83 ec 04             	sub    $0x4,%esp
  802863:	68 af 3c 80 00       	push   $0x803caf
  802868:	68 e9 00 00 00       	push   $0xe9
  80286d:	68 73 3c 80 00       	push   $0x803c73
  802872:	e8 46 da ff ff       	call   8002bd <_panic>
  802877:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	74 10                	je     802890 <alloc_block_NF+0x13c>
  802880:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802883:	8b 00                	mov    (%eax),%eax
  802885:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802888:	8b 52 04             	mov    0x4(%edx),%edx
  80288b:	89 50 04             	mov    %edx,0x4(%eax)
  80288e:	eb 0b                	jmp    80289b <alloc_block_NF+0x147>
  802890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802893:	8b 40 04             	mov    0x4(%eax),%eax
  802896:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80289b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289e:	8b 40 04             	mov    0x4(%eax),%eax
  8028a1:	85 c0                	test   %eax,%eax
  8028a3:	74 0f                	je     8028b4 <alloc_block_NF+0x160>
  8028a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a8:	8b 40 04             	mov    0x4(%eax),%eax
  8028ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028ae:	8b 12                	mov    (%edx),%edx
  8028b0:	89 10                	mov    %edx,(%eax)
  8028b2:	eb 0a                	jmp    8028be <alloc_block_NF+0x16a>
  8028b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b7:	8b 00                	mov    (%eax),%eax
  8028b9:	a3 48 41 80 00       	mov    %eax,0x804148
  8028be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d1:	a1 54 41 80 00       	mov    0x804154,%eax
  8028d6:	48                   	dec    %eax
  8028d7:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8028dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028df:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e2:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	8b 50 08             	mov    0x8(%eax),%edx
  8028eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ee:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	8b 50 08             	mov    0x8(%eax),%edx
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	01 c2                	add    %eax,%edx
  8028fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ff:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	8b 40 0c             	mov    0xc(%eax),%eax
  802908:	2b 45 08             	sub    0x8(%ebp),%eax
  80290b:	89 c2                	mov    %eax,%edx
  80290d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802910:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  802913:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802916:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  80291b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291e:	eb 31                	jmp    802951 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802920:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802926:	8b 00                	mov    (%eax),%eax
  802928:	85 c0                	test   %eax,%eax
  80292a:	75 0a                	jne    802936 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  80292c:	a1 38 41 80 00       	mov    0x804138,%eax
  802931:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802934:	eb 08                	jmp    80293e <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802936:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802939:	8b 00                	mov    (%eax),%eax
  80293b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80293e:	a1 44 41 80 00       	mov    0x804144,%eax
  802943:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802946:	0f 85 3f fe ff ff    	jne    80278b <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  80294c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802951:	c9                   	leave  
  802952:	c3                   	ret    

00802953 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802953:	55                   	push   %ebp
  802954:	89 e5                	mov    %esp,%ebp
  802956:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802959:	a1 44 41 80 00       	mov    0x804144,%eax
  80295e:	85 c0                	test   %eax,%eax
  802960:	75 68                	jne    8029ca <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802962:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802966:	75 17                	jne    80297f <insert_sorted_with_merge_freeList+0x2c>
  802968:	83 ec 04             	sub    $0x4,%esp
  80296b:	68 50 3c 80 00       	push   $0x803c50
  802970:	68 0e 01 00 00       	push   $0x10e
  802975:	68 73 3c 80 00       	push   $0x803c73
  80297a:	e8 3e d9 ff ff       	call   8002bd <_panic>
  80297f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802985:	8b 45 08             	mov    0x8(%ebp),%eax
  802988:	89 10                	mov    %edx,(%eax)
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	8b 00                	mov    (%eax),%eax
  80298f:	85 c0                	test   %eax,%eax
  802991:	74 0d                	je     8029a0 <insert_sorted_with_merge_freeList+0x4d>
  802993:	a1 38 41 80 00       	mov    0x804138,%eax
  802998:	8b 55 08             	mov    0x8(%ebp),%edx
  80299b:	89 50 04             	mov    %edx,0x4(%eax)
  80299e:	eb 08                	jmp    8029a8 <insert_sorted_with_merge_freeList+0x55>
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	a3 38 41 80 00       	mov    %eax,0x804138
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ba:	a1 44 41 80 00       	mov    0x804144,%eax
  8029bf:	40                   	inc    %eax
  8029c0:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8029c5:	e9 8c 06 00 00       	jmp    803056 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8029ca:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8029d2:	a1 38 41 80 00       	mov    0x804138,%eax
  8029d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	8b 50 08             	mov    0x8(%eax),%edx
  8029e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e3:	8b 40 08             	mov    0x8(%eax),%eax
  8029e6:	39 c2                	cmp    %eax,%edx
  8029e8:	0f 86 14 01 00 00    	jbe    802b02 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8029f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f7:	8b 40 08             	mov    0x8(%eax),%eax
  8029fa:	01 c2                	add    %eax,%edx
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	8b 40 08             	mov    0x8(%eax),%eax
  802a02:	39 c2                	cmp    %eax,%edx
  802a04:	0f 85 90 00 00 00    	jne    802a9a <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0d:	8b 50 0c             	mov    0xc(%eax),%edx
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	8b 40 0c             	mov    0xc(%eax),%eax
  802a16:	01 c2                	add    %eax,%edx
  802a18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1b:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a32:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a36:	75 17                	jne    802a4f <insert_sorted_with_merge_freeList+0xfc>
  802a38:	83 ec 04             	sub    $0x4,%esp
  802a3b:	68 50 3c 80 00       	push   $0x803c50
  802a40:	68 1b 01 00 00       	push   $0x11b
  802a45:	68 73 3c 80 00       	push   $0x803c73
  802a4a:	e8 6e d8 ff ff       	call   8002bd <_panic>
  802a4f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a55:	8b 45 08             	mov    0x8(%ebp),%eax
  802a58:	89 10                	mov    %edx,(%eax)
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	8b 00                	mov    (%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 0d                	je     802a70 <insert_sorted_with_merge_freeList+0x11d>
  802a63:	a1 48 41 80 00       	mov    0x804148,%eax
  802a68:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6b:	89 50 04             	mov    %edx,0x4(%eax)
  802a6e:	eb 08                	jmp    802a78 <insert_sorted_with_merge_freeList+0x125>
  802a70:	8b 45 08             	mov    0x8(%ebp),%eax
  802a73:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	a3 48 41 80 00       	mov    %eax,0x804148
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8a:	a1 54 41 80 00       	mov    0x804154,%eax
  802a8f:	40                   	inc    %eax
  802a90:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802a95:	e9 bc 05 00 00       	jmp    803056 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9e:	75 17                	jne    802ab7 <insert_sorted_with_merge_freeList+0x164>
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	68 8c 3c 80 00       	push   $0x803c8c
  802aa8:	68 1f 01 00 00       	push   $0x11f
  802aad:	68 73 3c 80 00       	push   $0x803c73
  802ab2:	e8 06 d8 ff ff       	call   8002bd <_panic>
  802ab7:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802abd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac0:	89 50 04             	mov    %edx,0x4(%eax)
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	8b 40 04             	mov    0x4(%eax),%eax
  802ac9:	85 c0                	test   %eax,%eax
  802acb:	74 0c                	je     802ad9 <insert_sorted_with_merge_freeList+0x186>
  802acd:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ad2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad5:	89 10                	mov    %edx,(%eax)
  802ad7:	eb 08                	jmp    802ae1 <insert_sorted_with_merge_freeList+0x18e>
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	a3 38 41 80 00       	mov    %eax,0x804138
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802af2:	a1 44 41 80 00       	mov    0x804144,%eax
  802af7:	40                   	inc    %eax
  802af8:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802afd:	e9 54 05 00 00       	jmp    803056 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802b02:	8b 45 08             	mov    0x8(%ebp),%eax
  802b05:	8b 50 08             	mov    0x8(%eax),%edx
  802b08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0b:	8b 40 08             	mov    0x8(%eax),%eax
  802b0e:	39 c2                	cmp    %eax,%edx
  802b10:	0f 83 20 01 00 00    	jae    802c36 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	8b 50 0c             	mov    0xc(%eax),%edx
  802b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1f:	8b 40 08             	mov    0x8(%eax),%eax
  802b22:	01 c2                	add    %eax,%edx
  802b24:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b27:	8b 40 08             	mov    0x8(%eax),%eax
  802b2a:	39 c2                	cmp    %eax,%edx
  802b2c:	0f 85 9c 00 00 00    	jne    802bce <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	8b 50 08             	mov    0x8(%eax),%edx
  802b38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3b:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b41:	8b 50 0c             	mov    0xc(%eax),%edx
  802b44:	8b 45 08             	mov    0x8(%ebp),%eax
  802b47:	8b 40 0c             	mov    0xc(%eax),%eax
  802b4a:	01 c2                	add    %eax,%edx
  802b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b4f:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b6a:	75 17                	jne    802b83 <insert_sorted_with_merge_freeList+0x230>
  802b6c:	83 ec 04             	sub    $0x4,%esp
  802b6f:	68 50 3c 80 00       	push   $0x803c50
  802b74:	68 2a 01 00 00       	push   $0x12a
  802b79:	68 73 3c 80 00       	push   $0x803c73
  802b7e:	e8 3a d7 ff ff       	call   8002bd <_panic>
  802b83:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	89 10                	mov    %edx,(%eax)
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	8b 00                	mov    (%eax),%eax
  802b93:	85 c0                	test   %eax,%eax
  802b95:	74 0d                	je     802ba4 <insert_sorted_with_merge_freeList+0x251>
  802b97:	a1 48 41 80 00       	mov    0x804148,%eax
  802b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9f:	89 50 04             	mov    %edx,0x4(%eax)
  802ba2:	eb 08                	jmp    802bac <insert_sorted_with_merge_freeList+0x259>
  802ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	a3 48 41 80 00       	mov    %eax,0x804148
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bbe:	a1 54 41 80 00       	mov    0x804154,%eax
  802bc3:	40                   	inc    %eax
  802bc4:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802bc9:	e9 88 04 00 00       	jmp    803056 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bce:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd2:	75 17                	jne    802beb <insert_sorted_with_merge_freeList+0x298>
  802bd4:	83 ec 04             	sub    $0x4,%esp
  802bd7:	68 50 3c 80 00       	push   $0x803c50
  802bdc:	68 2e 01 00 00       	push   $0x12e
  802be1:	68 73 3c 80 00       	push   $0x803c73
  802be6:	e8 d2 d6 ff ff       	call   8002bd <_panic>
  802beb:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	89 10                	mov    %edx,(%eax)
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	8b 00                	mov    (%eax),%eax
  802bfb:	85 c0                	test   %eax,%eax
  802bfd:	74 0d                	je     802c0c <insert_sorted_with_merge_freeList+0x2b9>
  802bff:	a1 38 41 80 00       	mov    0x804138,%eax
  802c04:	8b 55 08             	mov    0x8(%ebp),%edx
  802c07:	89 50 04             	mov    %edx,0x4(%eax)
  802c0a:	eb 08                	jmp    802c14 <insert_sorted_with_merge_freeList+0x2c1>
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c14:	8b 45 08             	mov    0x8(%ebp),%eax
  802c17:	a3 38 41 80 00       	mov    %eax,0x804138
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c26:	a1 44 41 80 00       	mov    0x804144,%eax
  802c2b:	40                   	inc    %eax
  802c2c:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c31:	e9 20 04 00 00       	jmp    803056 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802c36:	a1 38 41 80 00       	mov    0x804138,%eax
  802c3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c3e:	e9 e2 03 00 00       	jmp    803025 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	8b 50 08             	mov    0x8(%eax),%edx
  802c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4c:	8b 40 08             	mov    0x8(%eax),%eax
  802c4f:	39 c2                	cmp    %eax,%edx
  802c51:	0f 83 c6 03 00 00    	jae    80301d <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c63:	8b 50 08             	mov    0x8(%eax),%edx
  802c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c69:	8b 40 0c             	mov    0xc(%eax),%eax
  802c6c:	01 d0                	add    %edx,%eax
  802c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	8b 50 0c             	mov    0xc(%eax),%edx
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 40 08             	mov    0x8(%eax),%eax
  802c7d:	01 d0                	add    %edx,%eax
  802c7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	8b 40 08             	mov    0x8(%eax),%eax
  802c88:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c8b:	74 7a                	je     802d07 <insert_sorted_with_merge_freeList+0x3b4>
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 08             	mov    0x8(%eax),%eax
  802c93:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c96:	74 6f                	je     802d07 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802c98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9c:	74 06                	je     802ca4 <insert_sorted_with_merge_freeList+0x351>
  802c9e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca2:	75 17                	jne    802cbb <insert_sorted_with_merge_freeList+0x368>
  802ca4:	83 ec 04             	sub    $0x4,%esp
  802ca7:	68 d0 3c 80 00       	push   $0x803cd0
  802cac:	68 43 01 00 00       	push   $0x143
  802cb1:	68 73 3c 80 00       	push   $0x803c73
  802cb6:	e8 02 d6 ff ff       	call   8002bd <_panic>
  802cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbe:	8b 50 04             	mov    0x4(%eax),%edx
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	89 50 04             	mov    %edx,0x4(%eax)
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ccd:	89 10                	mov    %edx,(%eax)
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	85 c0                	test   %eax,%eax
  802cd7:	74 0d                	je     802ce6 <insert_sorted_with_merge_freeList+0x393>
  802cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdc:	8b 40 04             	mov    0x4(%eax),%eax
  802cdf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce2:	89 10                	mov    %edx,(%eax)
  802ce4:	eb 08                	jmp    802cee <insert_sorted_with_merge_freeList+0x39b>
  802ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce9:	a3 38 41 80 00       	mov    %eax,0x804138
  802cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf4:	89 50 04             	mov    %edx,0x4(%eax)
  802cf7:	a1 44 41 80 00       	mov    0x804144,%eax
  802cfc:	40                   	inc    %eax
  802cfd:	a3 44 41 80 00       	mov    %eax,0x804144
  802d02:	e9 14 03 00 00       	jmp    80301b <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	8b 40 08             	mov    0x8(%eax),%eax
  802d0d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d10:	0f 85 a0 01 00 00    	jne    802eb6 <insert_sorted_with_merge_freeList+0x563>
  802d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d19:	8b 40 08             	mov    0x8(%eax),%eax
  802d1c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d1f:	0f 85 91 01 00 00    	jne    802eb6 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802d25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d28:	8b 50 0c             	mov    0xc(%eax),%edx
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 40 0c             	mov    0xc(%eax),%eax
  802d37:	01 c8                	add    %ecx,%eax
  802d39:	01 c2                	add    %eax,%edx
  802d3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3e:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d41:	8b 45 08             	mov    0x8(%ebp),%eax
  802d44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d69:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d6d:	75 17                	jne    802d86 <insert_sorted_with_merge_freeList+0x433>
  802d6f:	83 ec 04             	sub    $0x4,%esp
  802d72:	68 50 3c 80 00       	push   $0x803c50
  802d77:	68 4d 01 00 00       	push   $0x14d
  802d7c:	68 73 3c 80 00       	push   $0x803c73
  802d81:	e8 37 d5 ff ff       	call   8002bd <_panic>
  802d86:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8f:	89 10                	mov    %edx,(%eax)
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 00                	mov    (%eax),%eax
  802d96:	85 c0                	test   %eax,%eax
  802d98:	74 0d                	je     802da7 <insert_sorted_with_merge_freeList+0x454>
  802d9a:	a1 48 41 80 00       	mov    0x804148,%eax
  802d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802da2:	89 50 04             	mov    %edx,0x4(%eax)
  802da5:	eb 08                	jmp    802daf <insert_sorted_with_merge_freeList+0x45c>
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	a3 48 41 80 00       	mov    %eax,0x804148
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc1:	a1 54 41 80 00       	mov    0x804154,%eax
  802dc6:	40                   	inc    %eax
  802dc7:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802dcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dd0:	75 17                	jne    802de9 <insert_sorted_with_merge_freeList+0x496>
  802dd2:	83 ec 04             	sub    $0x4,%esp
  802dd5:	68 af 3c 80 00       	push   $0x803caf
  802dda:	68 4e 01 00 00       	push   $0x14e
  802ddf:	68 73 3c 80 00       	push   $0x803c73
  802de4:	e8 d4 d4 ff ff       	call   8002bd <_panic>
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	74 10                	je     802e02 <insert_sorted_with_merge_freeList+0x4af>
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	8b 00                	mov    (%eax),%eax
  802df7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dfa:	8b 52 04             	mov    0x4(%edx),%edx
  802dfd:	89 50 04             	mov    %edx,0x4(%eax)
  802e00:	eb 0b                	jmp    802e0d <insert_sorted_with_merge_freeList+0x4ba>
  802e02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e05:	8b 40 04             	mov    0x4(%eax),%eax
  802e08:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e10:	8b 40 04             	mov    0x4(%eax),%eax
  802e13:	85 c0                	test   %eax,%eax
  802e15:	74 0f                	je     802e26 <insert_sorted_with_merge_freeList+0x4d3>
  802e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1a:	8b 40 04             	mov    0x4(%eax),%eax
  802e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e20:	8b 12                	mov    (%edx),%edx
  802e22:	89 10                	mov    %edx,(%eax)
  802e24:	eb 0a                	jmp    802e30 <insert_sorted_with_merge_freeList+0x4dd>
  802e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e29:	8b 00                	mov    (%eax),%eax
  802e2b:	a3 38 41 80 00       	mov    %eax,0x804138
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e43:	a1 44 41 80 00       	mov    0x804144,%eax
  802e48:	48                   	dec    %eax
  802e49:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e52:	75 17                	jne    802e6b <insert_sorted_with_merge_freeList+0x518>
  802e54:	83 ec 04             	sub    $0x4,%esp
  802e57:	68 50 3c 80 00       	push   $0x803c50
  802e5c:	68 4f 01 00 00       	push   $0x14f
  802e61:	68 73 3c 80 00       	push   $0x803c73
  802e66:	e8 52 d4 ff ff       	call   8002bd <_panic>
  802e6b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	89 10                	mov    %edx,(%eax)
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 00                	mov    (%eax),%eax
  802e7b:	85 c0                	test   %eax,%eax
  802e7d:	74 0d                	je     802e8c <insert_sorted_with_merge_freeList+0x539>
  802e7f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e87:	89 50 04             	mov    %edx,0x4(%eax)
  802e8a:	eb 08                	jmp    802e94 <insert_sorted_with_merge_freeList+0x541>
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e97:	a3 48 41 80 00       	mov    %eax,0x804148
  802e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea6:	a1 54 41 80 00       	mov    0x804154,%eax
  802eab:	40                   	inc    %eax
  802eac:	a3 54 41 80 00       	mov    %eax,0x804154
  802eb1:	e9 65 01 00 00       	jmp    80301b <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb9:	8b 40 08             	mov    0x8(%eax),%eax
  802ebc:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ebf:	0f 85 9f 00 00 00    	jne    802f64 <insert_sorted_with_merge_freeList+0x611>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 40 08             	mov    0x8(%eax),%eax
  802ecb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ece:	0f 84 90 00 00 00    	je     802f64 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802ed4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed7:	8b 50 0c             	mov    0xc(%eax),%edx
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee0:	01 c2                	add    %eax,%edx
  802ee2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ee5:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802efc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f00:	75 17                	jne    802f19 <insert_sorted_with_merge_freeList+0x5c6>
  802f02:	83 ec 04             	sub    $0x4,%esp
  802f05:	68 50 3c 80 00       	push   $0x803c50
  802f0a:	68 58 01 00 00       	push   $0x158
  802f0f:	68 73 3c 80 00       	push   $0x803c73
  802f14:	e8 a4 d3 ff ff       	call   8002bd <_panic>
  802f19:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 0d                	je     802f3a <insert_sorted_with_merge_freeList+0x5e7>
  802f2d:	a1 48 41 80 00       	mov    0x804148,%eax
  802f32:	8b 55 08             	mov    0x8(%ebp),%edx
  802f35:	89 50 04             	mov    %edx,0x4(%eax)
  802f38:	eb 08                	jmp    802f42 <insert_sorted_with_merge_freeList+0x5ef>
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	a3 48 41 80 00       	mov    %eax,0x804148
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f54:	a1 54 41 80 00       	mov    0x804154,%eax
  802f59:	40                   	inc    %eax
  802f5a:	a3 54 41 80 00       	mov    %eax,0x804154
  802f5f:	e9 b7 00 00 00       	jmp    80301b <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	8b 40 08             	mov    0x8(%eax),%eax
  802f6a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f6d:	0f 84 e2 00 00 00    	je     803055 <insert_sorted_with_merge_freeList+0x702>
  802f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f76:	8b 40 08             	mov    0x8(%eax),%eax
  802f79:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f7c:	0f 85 d3 00 00 00    	jne    803055 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f82:	8b 45 08             	mov    0x8(%ebp),%eax
  802f85:	8b 50 08             	mov    0x8(%eax),%edx
  802f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8b:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f91:	8b 50 0c             	mov    0xc(%eax),%edx
  802f94:	8b 45 08             	mov    0x8(%ebp),%eax
  802f97:	8b 40 0c             	mov    0xc(%eax),%eax
  802f9a:	01 c2                	add    %eax,%edx
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fba:	75 17                	jne    802fd3 <insert_sorted_with_merge_freeList+0x680>
  802fbc:	83 ec 04             	sub    $0x4,%esp
  802fbf:	68 50 3c 80 00       	push   $0x803c50
  802fc4:	68 61 01 00 00       	push   $0x161
  802fc9:	68 73 3c 80 00       	push   $0x803c73
  802fce:	e8 ea d2 ff ff       	call   8002bd <_panic>
  802fd3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	89 10                	mov    %edx,(%eax)
  802fde:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe1:	8b 00                	mov    (%eax),%eax
  802fe3:	85 c0                	test   %eax,%eax
  802fe5:	74 0d                	je     802ff4 <insert_sorted_with_merge_freeList+0x6a1>
  802fe7:	a1 48 41 80 00       	mov    0x804148,%eax
  802fec:	8b 55 08             	mov    0x8(%ebp),%edx
  802fef:	89 50 04             	mov    %edx,0x4(%eax)
  802ff2:	eb 08                	jmp    802ffc <insert_sorted_with_merge_freeList+0x6a9>
  802ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fff:	a3 48 41 80 00       	mov    %eax,0x804148
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80300e:	a1 54 41 80 00       	mov    0x804154,%eax
  803013:	40                   	inc    %eax
  803014:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803019:	eb 3a                	jmp    803055 <insert_sorted_with_merge_freeList+0x702>
  80301b:	eb 38                	jmp    803055 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  80301d:	a1 40 41 80 00       	mov    0x804140,%eax
  803022:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803029:	74 07                	je     803032 <insert_sorted_with_merge_freeList+0x6df>
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	eb 05                	jmp    803037 <insert_sorted_with_merge_freeList+0x6e4>
  803032:	b8 00 00 00 00       	mov    $0x0,%eax
  803037:	a3 40 41 80 00       	mov    %eax,0x804140
  80303c:	a1 40 41 80 00       	mov    0x804140,%eax
  803041:	85 c0                	test   %eax,%eax
  803043:	0f 85 fa fb ff ff    	jne    802c43 <insert_sorted_with_merge_freeList+0x2f0>
  803049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80304d:	0f 85 f0 fb ff ff    	jne    802c43 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803053:	eb 01                	jmp    803056 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803055:	90                   	nop
							}

						}
		          }
		}
}
  803056:	90                   	nop
  803057:	c9                   	leave  
  803058:	c3                   	ret    

00803059 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803059:	55                   	push   %ebp
  80305a:	89 e5                	mov    %esp,%ebp
  80305c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80305f:	8b 55 08             	mov    0x8(%ebp),%edx
  803062:	89 d0                	mov    %edx,%eax
  803064:	c1 e0 02             	shl    $0x2,%eax
  803067:	01 d0                	add    %edx,%eax
  803069:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803070:	01 d0                	add    %edx,%eax
  803072:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803079:	01 d0                	add    %edx,%eax
  80307b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803082:	01 d0                	add    %edx,%eax
  803084:	c1 e0 04             	shl    $0x4,%eax
  803087:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80308a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803091:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803094:	83 ec 0c             	sub    $0xc,%esp
  803097:	50                   	push   %eax
  803098:	e8 9c eb ff ff       	call   801c39 <sys_get_virtual_time>
  80309d:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030a0:	eb 41                	jmp    8030e3 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030a2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030a5:	83 ec 0c             	sub    $0xc,%esp
  8030a8:	50                   	push   %eax
  8030a9:	e8 8b eb ff ff       	call   801c39 <sys_get_virtual_time>
  8030ae:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030b1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b7:	29 c2                	sub    %eax,%edx
  8030b9:	89 d0                	mov    %edx,%eax
  8030bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030be:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030c4:	89 d1                	mov    %edx,%ecx
  8030c6:	29 c1                	sub    %eax,%ecx
  8030c8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ce:	39 c2                	cmp    %eax,%edx
  8030d0:	0f 97 c0             	seta   %al
  8030d3:	0f b6 c0             	movzbl %al,%eax
  8030d6:	29 c1                	sub    %eax,%ecx
  8030d8:	89 c8                	mov    %ecx,%eax
  8030da:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030e9:	72 b7                	jb     8030a2 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030eb:	90                   	nop
  8030ec:	c9                   	leave  
  8030ed:	c3                   	ret    

008030ee <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030ee:	55                   	push   %ebp
  8030ef:	89 e5                	mov    %esp,%ebp
  8030f1:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030fb:	eb 03                	jmp    803100 <busy_wait+0x12>
  8030fd:	ff 45 fc             	incl   -0x4(%ebp)
  803100:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803103:	3b 45 08             	cmp    0x8(%ebp),%eax
  803106:	72 f5                	jb     8030fd <busy_wait+0xf>
	return i;
  803108:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80310b:	c9                   	leave  
  80310c:	c3                   	ret    
  80310d:	66 90                	xchg   %ax,%ax
  80310f:	90                   	nop

00803110 <__udivdi3>:
  803110:	55                   	push   %ebp
  803111:	57                   	push   %edi
  803112:	56                   	push   %esi
  803113:	53                   	push   %ebx
  803114:	83 ec 1c             	sub    $0x1c,%esp
  803117:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80311b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80311f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803123:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803127:	89 ca                	mov    %ecx,%edx
  803129:	89 f8                	mov    %edi,%eax
  80312b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80312f:	85 f6                	test   %esi,%esi
  803131:	75 2d                	jne    803160 <__udivdi3+0x50>
  803133:	39 cf                	cmp    %ecx,%edi
  803135:	77 65                	ja     80319c <__udivdi3+0x8c>
  803137:	89 fd                	mov    %edi,%ebp
  803139:	85 ff                	test   %edi,%edi
  80313b:	75 0b                	jne    803148 <__udivdi3+0x38>
  80313d:	b8 01 00 00 00       	mov    $0x1,%eax
  803142:	31 d2                	xor    %edx,%edx
  803144:	f7 f7                	div    %edi
  803146:	89 c5                	mov    %eax,%ebp
  803148:	31 d2                	xor    %edx,%edx
  80314a:	89 c8                	mov    %ecx,%eax
  80314c:	f7 f5                	div    %ebp
  80314e:	89 c1                	mov    %eax,%ecx
  803150:	89 d8                	mov    %ebx,%eax
  803152:	f7 f5                	div    %ebp
  803154:	89 cf                	mov    %ecx,%edi
  803156:	89 fa                	mov    %edi,%edx
  803158:	83 c4 1c             	add    $0x1c,%esp
  80315b:	5b                   	pop    %ebx
  80315c:	5e                   	pop    %esi
  80315d:	5f                   	pop    %edi
  80315e:	5d                   	pop    %ebp
  80315f:	c3                   	ret    
  803160:	39 ce                	cmp    %ecx,%esi
  803162:	77 28                	ja     80318c <__udivdi3+0x7c>
  803164:	0f bd fe             	bsr    %esi,%edi
  803167:	83 f7 1f             	xor    $0x1f,%edi
  80316a:	75 40                	jne    8031ac <__udivdi3+0x9c>
  80316c:	39 ce                	cmp    %ecx,%esi
  80316e:	72 0a                	jb     80317a <__udivdi3+0x6a>
  803170:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803174:	0f 87 9e 00 00 00    	ja     803218 <__udivdi3+0x108>
  80317a:	b8 01 00 00 00       	mov    $0x1,%eax
  80317f:	89 fa                	mov    %edi,%edx
  803181:	83 c4 1c             	add    $0x1c,%esp
  803184:	5b                   	pop    %ebx
  803185:	5e                   	pop    %esi
  803186:	5f                   	pop    %edi
  803187:	5d                   	pop    %ebp
  803188:	c3                   	ret    
  803189:	8d 76 00             	lea    0x0(%esi),%esi
  80318c:	31 ff                	xor    %edi,%edi
  80318e:	31 c0                	xor    %eax,%eax
  803190:	89 fa                	mov    %edi,%edx
  803192:	83 c4 1c             	add    $0x1c,%esp
  803195:	5b                   	pop    %ebx
  803196:	5e                   	pop    %esi
  803197:	5f                   	pop    %edi
  803198:	5d                   	pop    %ebp
  803199:	c3                   	ret    
  80319a:	66 90                	xchg   %ax,%ax
  80319c:	89 d8                	mov    %ebx,%eax
  80319e:	f7 f7                	div    %edi
  8031a0:	31 ff                	xor    %edi,%edi
  8031a2:	89 fa                	mov    %edi,%edx
  8031a4:	83 c4 1c             	add    $0x1c,%esp
  8031a7:	5b                   	pop    %ebx
  8031a8:	5e                   	pop    %esi
  8031a9:	5f                   	pop    %edi
  8031aa:	5d                   	pop    %ebp
  8031ab:	c3                   	ret    
  8031ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031b1:	89 eb                	mov    %ebp,%ebx
  8031b3:	29 fb                	sub    %edi,%ebx
  8031b5:	89 f9                	mov    %edi,%ecx
  8031b7:	d3 e6                	shl    %cl,%esi
  8031b9:	89 c5                	mov    %eax,%ebp
  8031bb:	88 d9                	mov    %bl,%cl
  8031bd:	d3 ed                	shr    %cl,%ebp
  8031bf:	89 e9                	mov    %ebp,%ecx
  8031c1:	09 f1                	or     %esi,%ecx
  8031c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031c7:	89 f9                	mov    %edi,%ecx
  8031c9:	d3 e0                	shl    %cl,%eax
  8031cb:	89 c5                	mov    %eax,%ebp
  8031cd:	89 d6                	mov    %edx,%esi
  8031cf:	88 d9                	mov    %bl,%cl
  8031d1:	d3 ee                	shr    %cl,%esi
  8031d3:	89 f9                	mov    %edi,%ecx
  8031d5:	d3 e2                	shl    %cl,%edx
  8031d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031db:	88 d9                	mov    %bl,%cl
  8031dd:	d3 e8                	shr    %cl,%eax
  8031df:	09 c2                	or     %eax,%edx
  8031e1:	89 d0                	mov    %edx,%eax
  8031e3:	89 f2                	mov    %esi,%edx
  8031e5:	f7 74 24 0c          	divl   0xc(%esp)
  8031e9:	89 d6                	mov    %edx,%esi
  8031eb:	89 c3                	mov    %eax,%ebx
  8031ed:	f7 e5                	mul    %ebp
  8031ef:	39 d6                	cmp    %edx,%esi
  8031f1:	72 19                	jb     80320c <__udivdi3+0xfc>
  8031f3:	74 0b                	je     803200 <__udivdi3+0xf0>
  8031f5:	89 d8                	mov    %ebx,%eax
  8031f7:	31 ff                	xor    %edi,%edi
  8031f9:	e9 58 ff ff ff       	jmp    803156 <__udivdi3+0x46>
  8031fe:	66 90                	xchg   %ax,%ax
  803200:	8b 54 24 08          	mov    0x8(%esp),%edx
  803204:	89 f9                	mov    %edi,%ecx
  803206:	d3 e2                	shl    %cl,%edx
  803208:	39 c2                	cmp    %eax,%edx
  80320a:	73 e9                	jae    8031f5 <__udivdi3+0xe5>
  80320c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80320f:	31 ff                	xor    %edi,%edi
  803211:	e9 40 ff ff ff       	jmp    803156 <__udivdi3+0x46>
  803216:	66 90                	xchg   %ax,%ax
  803218:	31 c0                	xor    %eax,%eax
  80321a:	e9 37 ff ff ff       	jmp    803156 <__udivdi3+0x46>
  80321f:	90                   	nop

00803220 <__umoddi3>:
  803220:	55                   	push   %ebp
  803221:	57                   	push   %edi
  803222:	56                   	push   %esi
  803223:	53                   	push   %ebx
  803224:	83 ec 1c             	sub    $0x1c,%esp
  803227:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80322b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80322f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803233:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803237:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80323b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80323f:	89 f3                	mov    %esi,%ebx
  803241:	89 fa                	mov    %edi,%edx
  803243:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803247:	89 34 24             	mov    %esi,(%esp)
  80324a:	85 c0                	test   %eax,%eax
  80324c:	75 1a                	jne    803268 <__umoddi3+0x48>
  80324e:	39 f7                	cmp    %esi,%edi
  803250:	0f 86 a2 00 00 00    	jbe    8032f8 <__umoddi3+0xd8>
  803256:	89 c8                	mov    %ecx,%eax
  803258:	89 f2                	mov    %esi,%edx
  80325a:	f7 f7                	div    %edi
  80325c:	89 d0                	mov    %edx,%eax
  80325e:	31 d2                	xor    %edx,%edx
  803260:	83 c4 1c             	add    $0x1c,%esp
  803263:	5b                   	pop    %ebx
  803264:	5e                   	pop    %esi
  803265:	5f                   	pop    %edi
  803266:	5d                   	pop    %ebp
  803267:	c3                   	ret    
  803268:	39 f0                	cmp    %esi,%eax
  80326a:	0f 87 ac 00 00 00    	ja     80331c <__umoddi3+0xfc>
  803270:	0f bd e8             	bsr    %eax,%ebp
  803273:	83 f5 1f             	xor    $0x1f,%ebp
  803276:	0f 84 ac 00 00 00    	je     803328 <__umoddi3+0x108>
  80327c:	bf 20 00 00 00       	mov    $0x20,%edi
  803281:	29 ef                	sub    %ebp,%edi
  803283:	89 fe                	mov    %edi,%esi
  803285:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803289:	89 e9                	mov    %ebp,%ecx
  80328b:	d3 e0                	shl    %cl,%eax
  80328d:	89 d7                	mov    %edx,%edi
  80328f:	89 f1                	mov    %esi,%ecx
  803291:	d3 ef                	shr    %cl,%edi
  803293:	09 c7                	or     %eax,%edi
  803295:	89 e9                	mov    %ebp,%ecx
  803297:	d3 e2                	shl    %cl,%edx
  803299:	89 14 24             	mov    %edx,(%esp)
  80329c:	89 d8                	mov    %ebx,%eax
  80329e:	d3 e0                	shl    %cl,%eax
  8032a0:	89 c2                	mov    %eax,%edx
  8032a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032a6:	d3 e0                	shl    %cl,%eax
  8032a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032b0:	89 f1                	mov    %esi,%ecx
  8032b2:	d3 e8                	shr    %cl,%eax
  8032b4:	09 d0                	or     %edx,%eax
  8032b6:	d3 eb                	shr    %cl,%ebx
  8032b8:	89 da                	mov    %ebx,%edx
  8032ba:	f7 f7                	div    %edi
  8032bc:	89 d3                	mov    %edx,%ebx
  8032be:	f7 24 24             	mull   (%esp)
  8032c1:	89 c6                	mov    %eax,%esi
  8032c3:	89 d1                	mov    %edx,%ecx
  8032c5:	39 d3                	cmp    %edx,%ebx
  8032c7:	0f 82 87 00 00 00    	jb     803354 <__umoddi3+0x134>
  8032cd:	0f 84 91 00 00 00    	je     803364 <__umoddi3+0x144>
  8032d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032d7:	29 f2                	sub    %esi,%edx
  8032d9:	19 cb                	sbb    %ecx,%ebx
  8032db:	89 d8                	mov    %ebx,%eax
  8032dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032e1:	d3 e0                	shl    %cl,%eax
  8032e3:	89 e9                	mov    %ebp,%ecx
  8032e5:	d3 ea                	shr    %cl,%edx
  8032e7:	09 d0                	or     %edx,%eax
  8032e9:	89 e9                	mov    %ebp,%ecx
  8032eb:	d3 eb                	shr    %cl,%ebx
  8032ed:	89 da                	mov    %ebx,%edx
  8032ef:	83 c4 1c             	add    $0x1c,%esp
  8032f2:	5b                   	pop    %ebx
  8032f3:	5e                   	pop    %esi
  8032f4:	5f                   	pop    %edi
  8032f5:	5d                   	pop    %ebp
  8032f6:	c3                   	ret    
  8032f7:	90                   	nop
  8032f8:	89 fd                	mov    %edi,%ebp
  8032fa:	85 ff                	test   %edi,%edi
  8032fc:	75 0b                	jne    803309 <__umoddi3+0xe9>
  8032fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803303:	31 d2                	xor    %edx,%edx
  803305:	f7 f7                	div    %edi
  803307:	89 c5                	mov    %eax,%ebp
  803309:	89 f0                	mov    %esi,%eax
  80330b:	31 d2                	xor    %edx,%edx
  80330d:	f7 f5                	div    %ebp
  80330f:	89 c8                	mov    %ecx,%eax
  803311:	f7 f5                	div    %ebp
  803313:	89 d0                	mov    %edx,%eax
  803315:	e9 44 ff ff ff       	jmp    80325e <__umoddi3+0x3e>
  80331a:	66 90                	xchg   %ax,%ax
  80331c:	89 c8                	mov    %ecx,%eax
  80331e:	89 f2                	mov    %esi,%edx
  803320:	83 c4 1c             	add    $0x1c,%esp
  803323:	5b                   	pop    %ebx
  803324:	5e                   	pop    %esi
  803325:	5f                   	pop    %edi
  803326:	5d                   	pop    %ebp
  803327:	c3                   	ret    
  803328:	3b 04 24             	cmp    (%esp),%eax
  80332b:	72 06                	jb     803333 <__umoddi3+0x113>
  80332d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803331:	77 0f                	ja     803342 <__umoddi3+0x122>
  803333:	89 f2                	mov    %esi,%edx
  803335:	29 f9                	sub    %edi,%ecx
  803337:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80333b:	89 14 24             	mov    %edx,(%esp)
  80333e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803342:	8b 44 24 04          	mov    0x4(%esp),%eax
  803346:	8b 14 24             	mov    (%esp),%edx
  803349:	83 c4 1c             	add    $0x1c,%esp
  80334c:	5b                   	pop    %ebx
  80334d:	5e                   	pop    %esi
  80334e:	5f                   	pop    %edi
  80334f:	5d                   	pop    %ebp
  803350:	c3                   	ret    
  803351:	8d 76 00             	lea    0x0(%esi),%esi
  803354:	2b 04 24             	sub    (%esp),%eax
  803357:	19 fa                	sbb    %edi,%edx
  803359:	89 d1                	mov    %edx,%ecx
  80335b:	89 c6                	mov    %eax,%esi
  80335d:	e9 71 ff ff ff       	jmp    8032d3 <__umoddi3+0xb3>
  803362:	66 90                	xchg   %ax,%ax
  803364:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803368:	72 ea                	jb     803354 <__umoddi3+0x134>
  80336a:	89 d9                	mov    %ebx,%ecx
  80336c:	e9 62 ff ff ff       	jmp    8032d3 <__umoddi3+0xb3>

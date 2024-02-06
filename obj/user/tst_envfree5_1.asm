
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
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
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 32 80 00       	push   $0x8032a0
  80004a:	e8 6a 15 00 00       	call   8015b9 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 6f 18 00 00       	call   8018d2 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 07 19 00 00       	call   801972 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 32 80 00       	push   $0x8032b0
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 e3 32 80 00       	push   $0x8032e3
  800099:	e8 a6 1a 00 00       	call   801b44 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 b3 1a 00 00       	call   801b62 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 10 18 00 00       	call   8018d2 <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 ec 32 80 00       	push   $0x8032ec
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 a0 1a 00 00       	call   801b7e <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 ec 17 00 00       	call   8018d2 <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 84 18 00 00       	call   801972 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 20 33 80 00       	push   $0x803320
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 70 33 80 00       	push   $0x803370
  800114:	6a 1e                	push   $0x1e
  800116:	68 a6 33 80 00       	push   $0x8033a6
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 bc 33 80 00       	push   $0x8033bc
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 1c 34 80 00       	push   $0x80341c
  80013b:	e8 f6 03 00 00       	call   800536 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 61 1a 00 00       	call   801bb2 <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 04             	shl    $0x4,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 40 80 00       	mov    0x804020,%eax
  80017d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0f                	je     800196 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800187:	a1 20 40 80 00       	mov    0x804020,%eax
  80018c:	05 5c 05 00 00       	add    $0x55c,%eax
  800191:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x60>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b7:	e8 03 18 00 00       	call   8019bf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 80 34 80 00       	push   $0x803480
  8001c4:	e8 6d 03 00 00       	call   800536 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 a8 34 80 00       	push   $0x8034a8
  8001ec:	e8 45 03 00 00       	call   800536 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80020a:	a1 20 40 80 00       	mov    0x804020,%eax
  80020f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 d0 34 80 00       	push   $0x8034d0
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 28 35 80 00       	push   $0x803528
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 80 34 80 00       	push   $0x803480
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 83 17 00 00       	call   8019d9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 10 19 00 00       	call   801b7e <sys_destroy_env>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027a:	e8 65 19 00 00       	call   801be4 <sys_exit_env>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 3c 35 80 00       	push   $0x80353c
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 41 35 80 00       	push   $0x803541
  8002c1:	e8 70 02 00 00       	call   800536 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 f3 01 00 00       	call   8004cb <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 5d 35 80 00       	push   $0x80355d
  8002e5:	e8 e1 01 00 00       	call   8004cb <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 60 35 80 00       	push   $0x803560
  800311:	6a 26                	push   $0x26
  800313:	68 ac 35 80 00       	push   $0x8035ac
  800318:	e8 65 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032b:	e9 c2 00 00 00       	jmp    8003f2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	75 08                	jne    80034d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800345:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800348:	e9 a2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035b:	eb 69                	jmp    8003c6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035d:	a1 20 40 80 00       	mov    0x804020,%eax
  800362:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8a 40 04             	mov    0x4(%eax),%al
  800379:	84 c0                	test   %al,%al
  80037b:	75 46                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038b:	89 d0                	mov    %edx,%eax
  80038d:	01 c0                	add    %eax,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	c1 e0 03             	shl    $0x3,%eax
  800394:	01 c8                	add    %ecx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80039b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	75 09                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c1:	eb 12                	jmp    8003d5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	ff 45 e8             	incl   -0x18(%ebp)
  8003c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003cb:	8b 50 74             	mov    0x74(%eax),%edx
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 88                	ja     80035d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d9:	75 14                	jne    8003ef <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 b8 35 80 00       	push   $0x8035b8
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 ac 35 80 00       	push   $0x8035ac
  8003ea:	e8 93 fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ef:	ff 45 f0             	incl   -0x10(%ebp)
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	0f 8c 32 ff ff ff    	jl     800330 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040c:	eb 26                	jmp    800434 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
  800413:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	c1 e0 03             	shl    $0x3,%eax
  800425:	01 c8                	add    %ecx,%eax
  800427:	8a 40 04             	mov    0x4(%eax),%al
  80042a:	3c 01                	cmp    $0x1,%al
  80042c:	75 03                	jne    800431 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e0             	incl   -0x20(%ebp)
  800434:	a1 20 40 80 00       	mov    0x804020,%eax
  800439:	8b 50 74             	mov    0x74(%eax),%edx
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	77 cb                	ja     80040e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800449:	74 14                	je     80045f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	68 0c 36 80 00       	push   $0x80360c
  800453:	6a 44                	push   $0x44
  800455:	68 ac 35 80 00       	push   $0x8035ac
  80045a:	e8 23 fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 48 01             	lea    0x1(%eax),%ecx
  800470:	8b 55 0c             	mov    0xc(%ebp),%edx
  800473:	89 0a                	mov    %ecx,(%edx)
  800475:	8b 55 08             	mov    0x8(%ebp),%edx
  800478:	88 d1                	mov    %dl,%cl
  80047a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048b:	75 2c                	jne    8004b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048d:	a0 24 40 80 00       	mov    0x804024,%al
  800492:	0f b6 c0             	movzbl %al,%eax
  800495:	8b 55 0c             	mov    0xc(%ebp),%edx
  800498:	8b 12                	mov    (%edx),%edx
  80049a:	89 d1                	mov    %edx,%ecx
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	83 c2 08             	add    $0x8,%edx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	50                   	push   %eax
  8004a6:	51                   	push   %ecx
  8004a7:	52                   	push   %edx
  8004a8:	e8 64 13 00 00       	call   801811 <sys_cputs>
  8004ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	8b 40 04             	mov    0x4(%eax),%eax
  8004bf:	8d 50 01             	lea    0x1(%eax),%edx
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004db:	00 00 00 
	b.cnt = 0;
  8004de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	50                   	push   %eax
  8004f5:	68 62 04 80 00       	push   $0x800462
  8004fa:	e8 11 02 00 00       	call   800710 <vprintfmt>
  8004ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800502:	a0 24 40 80 00       	mov    0x804024,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	50                   	push   %eax
  800514:	52                   	push   %edx
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	83 c0 08             	add    $0x8,%eax
  80051e:	50                   	push   %eax
  80051f:	e8 ed 12 00 00       	call   801811 <sys_cputs>
  800524:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800527:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <cprintf>:

int cprintf(const char *fmt, ...) {
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800543:	8d 45 0c             	lea    0xc(%ebp),%eax
  800546:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 f4             	pushl  -0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	e8 73 ff ff ff       	call   8004cb <vcprintf>
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800569:	e8 51 14 00 00       	call   8019bf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 48 ff ff ff       	call   8004cb <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800589:	e8 4b 14 00 00       	call   8019d9 <sys_enable_interrupt>
	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	53                   	push   %ebx
  800597:	83 ec 14             	sub    $0x14,%esp
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	77 55                	ja     800608 <printnum+0x75>
  8005b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b6:	72 05                	jb     8005bd <printnum+0x2a>
  8005b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bb:	77 4b                	ja     800608 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d3:	e8 48 2a 00 00       	call   803020 <__udivdi3>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	ff 75 20             	pushl  0x20(%ebp)
  8005e1:	53                   	push   %ebx
  8005e2:	ff 75 18             	pushl  0x18(%ebp)
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 a1 ff ff ff       	call   800593 <printnum>
  8005f2:	83 c4 20             	add    $0x20,%esp
  8005f5:	eb 1a                	jmp    800611 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800608:	ff 4d 1c             	decl   0x1c(%ebp)
  80060b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060f:	7f e6                	jg     8005f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800611:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800614:	bb 00 00 00 00       	mov    $0x0,%ebx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061f:	53                   	push   %ebx
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	e8 08 2b 00 00       	call   803130 <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 74 38 80 00       	add    $0x803874,%eax
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f be c0             	movsbl %al,%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
}
  800644:	90                   	nop
  800645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800651:	7e 1c                	jle    80066f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 50 08             	lea    0x8(%eax),%edx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 10                	mov    %edx,(%eax)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	83 e8 08             	sub    $0x8,%eax
  800668:	8b 50 04             	mov    0x4(%eax),%edx
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	eb 40                	jmp    8006af <getuint+0x65>
	else if (lflag)
  80066f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800673:	74 1e                	je     800693 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	89 10                	mov    %edx,(%eax)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	eb 1c                	jmp    8006af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 04             	sub    $0x4,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    

008006b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getint+0x25>
		return va_arg(*ap, long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 38                	jmp    80070e <getint+0x5d>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1a                	je     8006f6 <getint+0x45>
		return va_arg(*ap, long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
  8006f4:	eb 18                	jmp    80070e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 04             	lea    0x4(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 04             	sub    $0x4,%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	99                   	cltd   
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	56                   	push   %esi
  800714:	53                   	push   %ebx
  800715:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800718:	eb 17                	jmp    800731 <vprintfmt+0x21>
			if (ch == '\0')
  80071a:	85 db                	test   %ebx,%ebx
  80071c:	0f 84 af 03 00 00    	je     800ad1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	53                   	push   %ebx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800731:	8b 45 10             	mov    0x10(%ebp),%eax
  800734:	8d 50 01             	lea    0x1(%eax),%edx
  800737:	89 55 10             	mov    %edx,0x10(%ebp)
  80073a:	8a 00                	mov    (%eax),%al
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d6                	jne    80071a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800748:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800756:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800775:	83 f8 55             	cmp    $0x55,%eax
  800778:	0f 87 2b 03 00 00    	ja     800aa9 <vprintfmt+0x399>
  80077e:	8b 04 85 98 38 80 00 	mov    0x803898(,%eax,4),%eax
  800785:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800787:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078b:	eb d7                	jmp    800764 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800791:	eb d1                	jmp    800764 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079d:	89 d0                	mov    %edx,%eax
  80079f:	c1 e0 02             	shl    $0x2,%eax
  8007a2:	01 d0                	add    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d8                	add    %ebx,%eax
  8007a8:	83 e8 30             	sub    $0x30,%eax
  8007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b9:	7e 3e                	jle    8007f9 <vprintfmt+0xe9>
  8007bb:	83 fb 39             	cmp    $0x39,%ebx
  8007be:	7f 39                	jg     8007f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c3:	eb d5                	jmp    80079a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 c0 04             	add    $0x4,%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d9:	eb 1f                	jmp    8007fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	79 83                	jns    800764 <vprintfmt+0x54>
				width = 0;
  8007e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e8:	e9 77 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f4:	e9 6b ff ff ff       	jmp    800764 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	0f 89 60 ff ff ff    	jns    800764 <vprintfmt+0x54>
				width = precision, precision = -1;
  800804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800811:	e9 4e ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800816:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800819:	e9 46 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 c0 04             	add    $0x4,%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			break;
  80083e:	e9 89 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800854:	85 db                	test   %ebx,%ebx
  800856:	79 02                	jns    80085a <vprintfmt+0x14a>
				err = -err;
  800858:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085a:	83 fb 64             	cmp    $0x64,%ebx
  80085d:	7f 0b                	jg     80086a <vprintfmt+0x15a>
  80085f:	8b 34 9d e0 36 80 00 	mov    0x8036e0(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 85 38 80 00       	push   $0x803885
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 5e 02 00 00       	call   800ad9 <printfmt>
  80087b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087e:	e9 49 02 00 00       	jmp    800acc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800883:	56                   	push   %esi
  800884:	68 8e 38 80 00       	push   $0x80388e
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 45 02 00 00       	call   800ad9 <printfmt>
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	e9 30 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 30                	mov    (%eax),%esi
  8008ad:	85 f6                	test   %esi,%esi
  8008af:	75 05                	jne    8008b6 <vprintfmt+0x1a6>
				p = "(null)";
  8008b1:	be 91 38 80 00       	mov    $0x803891,%esi
			if (width > 0 && padc != '-')
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	7e 6d                	jle    800929 <vprintfmt+0x219>
  8008bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c0:	74 67                	je     800929 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	50                   	push   %eax
  8008c9:	56                   	push   %esi
  8008ca:	e8 0c 03 00 00       	call   800bdb <strnlen>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f1:	7f e4                	jg     8008d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f3:	eb 34                	jmp    800929 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f9:	74 1c                	je     800917 <vprintfmt+0x207>
  8008fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fe:	7e 05                	jle    800905 <vprintfmt+0x1f5>
  800900:	83 fb 7e             	cmp    $0x7e,%ebx
  800903:	7e 12                	jle    800917 <vprintfmt+0x207>
					putch('?', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 3f                	push   $0x3f
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb 0f                	jmp    800926 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	ff 4d e4             	decl   -0x1c(%ebp)
  800929:	89 f0                	mov    %esi,%eax
  80092b:	8d 70 01             	lea    0x1(%eax),%esi
  80092e:	8a 00                	mov    (%eax),%al
  800930:	0f be d8             	movsbl %al,%ebx
  800933:	85 db                	test   %ebx,%ebx
  800935:	74 24                	je     80095b <vprintfmt+0x24b>
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	78 b8                	js     8008f5 <vprintfmt+0x1e5>
  80093d:	ff 4d e0             	decl   -0x20(%ebp)
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	79 af                	jns    8008f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	eb 13                	jmp    80095b <vprintfmt+0x24b>
				putch(' ', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 20                	push   $0x20
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	7f e7                	jg     800948 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800961:	e9 66 01 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 e8             	pushl  -0x18(%ebp)
  80096c:	8d 45 14             	lea    0x14(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	e8 3c fd ff ff       	call   8006b1 <getint>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	85 d2                	test   %edx,%edx
  800986:	79 23                	jns    8009ab <vprintfmt+0x29b>
				putch('-', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 2d                	push   $0x2d
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099e:	f7 d8                	neg    %eax
  8009a0:	83 d2 00             	adc    $0x0,%edx
  8009a3:	f7 da                	neg    %edx
  8009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b2:	e9 bc 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c0:	50                   	push   %eax
  8009c1:	e8 84 fc ff ff       	call   80064a <getuint>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d6:	e9 98 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 58                	push   $0x58
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 58                	push   $0x58
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 58                	push   $0x58
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			break;
  800a0b:	e9 bc 00 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	6a 30                	push   $0x30
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 78                	push   $0x78
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 e8 04             	sub    $0x4,%eax
  800a3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 e7 fb ff ff       	call   80064a <getuint>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	83 ec 04             	sub    $0x4,%esp
  800a7d:	52                   	push   %edx
  800a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a81:	50                   	push   %eax
  800a82:	ff 75 f4             	pushl  -0xc(%ebp)
  800a85:	ff 75 f0             	pushl  -0x10(%ebp)
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 00 fb ff ff       	call   800593 <printnum>
  800a93:	83 c4 20             	add    $0x20,%esp
			break;
  800a96:	eb 34                	jmp    800acc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	eb 23                	jmp    800acc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 25                	push   $0x25
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	eb 03                	jmp    800ac1 <vprintfmt+0x3b1>
  800abe:	ff 4d 10             	decl   0x10(%ebp)
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	48                   	dec    %eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	3c 25                	cmp    $0x25,%al
  800ac9:	75 f3                	jne    800abe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800acb:	90                   	nop
		}
	}
  800acc:	e9 47 fc ff ff       	jmp    800718 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 16 fc ff ff       	call   800710 <vprintfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afd:	90                   	nop
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 08             	mov    0x8(%eax),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 04             	mov    0x4(%eax),%eax
  800b1d:	39 c2                	cmp    %eax,%edx
  800b1f:	73 12                	jae    800b33 <sprintputch+0x33>
		*b->buf++ = ch;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 0a                	mov    %ecx,(%edx)
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
}
  800b33:	90                   	nop
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 06                	je     800b63 <vsnprintf+0x2d>
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	7f 07                	jg     800b6a <vsnprintf+0x34>
		return -E_INVAL;
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	eb 20                	jmp    800b8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6a:	ff 75 14             	pushl  0x14(%ebp)
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 00 0b 80 00       	push   $0x800b00
  800b79:	e8 92 fb ff ff       	call   800710 <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 89 ff ff ff       	call   800b36 <vsnprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc5:	eb 06                	jmp    800bcd <strlen+0x15>
		n++;
  800bc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bca:	ff 45 08             	incl   0x8(%ebp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 f1                	jne    800bc7 <strlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be8:	eb 09                	jmp    800bf3 <strnlen+0x18>
		n++;
  800bea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 4d 0c             	decl   0xc(%ebp)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 09                	je     800c02 <strnlen+0x27>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e8                	jne    800bea <strnlen+0xf>
		n++;
	return n;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c13:	90                   	nop
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e4                	jne    800c14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c48:	eb 1f                	jmp    800c69 <strncpy+0x34>
		*dst++ = *src;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 03                	je     800c66 <strncpy+0x31>
			src++;
  800c63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6f:	72 d9                	jb     800c4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 30                	je     800cb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c88:	eb 16                	jmp    800ca0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8d 50 01             	lea    0x1(%eax),%edx
  800c90:	89 55 08             	mov    %edx,0x8(%ebp)
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 09                	je     800cb2 <strlcpy+0x3c>
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 d8                	jne    800c8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	29 c2                	sub    %eax,%edx
  800cc0:	89 d0                	mov    %edx,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc7:	eb 06                	jmp    800ccf <strcmp+0xb>
		p++, q++;
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	74 0e                	je     800ce6 <strcmp+0x22>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 10                	mov    (%eax),%dl
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	38 c2                	cmp    %al,%dl
  800ce4:	74 e3                	je     800cc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d0             	movzbl %al,%edx
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 c0             	movzbl %al,%eax
  800cf6:	29 c2                	sub    %eax,%edx
  800cf8:	89 d0                	mov    %edx,%eax
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cff:	eb 09                	jmp    800d0a <strncmp+0xe>
		n--, p++, q++;
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 17                	je     800d27 <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 da                	je     800d01 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strncmp+0x38>
		return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	eb 14                	jmp    800d48 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 12                	jmp    800d6a <strchr+0x20>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	75 05                	jne    800d67 <strchr+0x1d>
			return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	eb 11                	jmp    800d78 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	75 e5                	jne    800d58 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 0d                	jmp    800d95 <strfind+0x1b>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	74 0e                	je     800da0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ea                	jne    800d88 <strfind+0xe>
  800d9e:	eb 01                	jmp    800da1 <strfind+0x27>
		if (*s == c)
			break;
  800da0:	90                   	nop
	return (char *) s;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db8:	eb 0e                	jmp    800dc8 <memset+0x22>
		*p++ = c;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc8:	ff 4d f8             	decl   -0x8(%ebp)
  800dcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcf:	79 e9                	jns    800dba <memset+0x14>
		*p++ = c;

	return v;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de8:	eb 16                	jmp    800e00 <memcpy+0x2a>
		*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2a:	73 50                	jae    800e7c <memmove+0x6a>
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	76 43                	jbe    800e7c <memmove+0x6a>
		s += n;
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e45:	eb 10                	jmp    800e57 <memmove+0x45>
			*--d = *--s;
  800e47:	ff 4d f8             	decl   -0x8(%ebp)
  800e4a:	ff 4d fc             	decl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 e3                	jne    800e47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e64:	eb 23                	jmp    800e89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea0:	eb 2a                	jmp    800ecc <memcmp+0x3e>
		if (*s1 != *s2)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 16                	je     800ec6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 d0             	movzbl %al,%edx
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	eb 18                	jmp    800ede <memcmp+0x50>
		s1++, s2++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 c9                	jne    800ea2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef1:	eb 15                	jmp    800f08 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 d0             	movzbl %al,%edx
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	39 c2                	cmp    %eax,%edx
  800f03:	74 0d                	je     800f12 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0e:	72 e3                	jb     800ef3 <memfind+0x13>
  800f10:	eb 01                	jmp    800f13 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f12:	90                   	nop
	return (void *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2c:	eb 03                	jmp    800f31 <strtol+0x19>
		s++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f4                	je     800f2e <strtol+0x16>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 09                	cmp    $0x9,%al
  800f41:	74 eb                	je     800f2e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2b                	cmp    $0x2b,%al
  800f4a:	75 05                	jne    800f51 <strtol+0x39>
		s++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	eb 13                	jmp    800f64 <strtol+0x4c>
	else if (*s == '-')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2d                	cmp    $0x2d,%al
  800f58:	75 0a                	jne    800f64 <strtol+0x4c>
		s++, neg = 1;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x58>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 20                	jne    800f90 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 30                	cmp    $0x30,%al
  800f77:	75 17                	jne    800f90 <strtol+0x78>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	40                   	inc    %eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 78                	cmp    $0x78,%al
  800f81:	75 0d                	jne    800f90 <strtol+0x78>
		s += 2, base = 16;
  800f83:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f87:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8e:	eb 28                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 15                	jne    800fab <strtol+0x93>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 30                	cmp    $0x30,%al
  800f9d:	75 0c                	jne    800fab <strtol+0x93>
		s++, base = 8;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa9:	eb 0d                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strtol+0xa0>
		base = 10;
  800fb1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2f                	cmp    $0x2f,%al
  800fbf:	7e 19                	jle    800fda <strtol+0xc2>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 39                	cmp    $0x39,%al
  800fc8:	7f 10                	jg     800fda <strtol+0xc2>
			dig = *s - '0';
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 30             	sub    $0x30,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd8:	eb 42                	jmp    80101c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 60                	cmp    $0x60,%al
  800fe1:	7e 19                	jle    800ffc <strtol+0xe4>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 7a                	cmp    $0x7a,%al
  800fea:	7f 10                	jg     800ffc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f be c0             	movsbl %al,%eax
  800ff4:	83 e8 57             	sub    $0x57,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffa:	eb 20                	jmp    80101c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 40                	cmp    $0x40,%al
  801003:	7e 39                	jle    80103e <strtol+0x126>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 5a                	cmp    $0x5a,%al
  80100c:	7f 30                	jg     80103e <strtol+0x126>
			dig = *s - 'A' + 10;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be c0             	movsbl %al,%eax
  801016:	83 e8 37             	sub    $0x37,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	7d 19                	jge    80103d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801038:	e9 7b ff ff ff       	jmp    800fb8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x134>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x141>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x144>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <ltostr>:

void
ltostr(long value, char *str)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801076:	79 13                	jns    80108b <ltostr+0x2d>
	{
		neg = 1;
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801085:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801088:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801093:	99                   	cltd   
  801094:	f7 f9                	idiv   %ecx
  801096:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ac:	83 c2 30             	add    $0x30,%edx
  8010af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b9:	f7 e9                	imul   %ecx
  8010bb:	c1 fa 02             	sar    $0x2,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	c1 f8 1f             	sar    $0x1f,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d2:	f7 e9                	imul   %ecx
  8010d4:	c1 fa 02             	sar    $0x2,%edx
  8010d7:	89 c8                	mov    %ecx,%eax
  8010d9:	c1 f8 1f             	sar    $0x1f,%eax
  8010dc:	29 c2                	sub    %eax,%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	c1 e0 02             	shl    $0x2,%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	01 c0                	add    %eax,%eax
  8010e7:	29 c1                	sub    %eax,%ecx
  8010e9:	89 ca                	mov    %ecx,%edx
  8010eb:	85 d2                	test   %edx,%edx
  8010ed:	75 9c                	jne    80108b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801101:	74 3d                	je     801140 <ltostr+0xe2>
		start = 1 ;
  801103:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110a:	eb 34                	jmp    801140 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8a 45 eb             	mov    -0x15(%ebp),%al
  801138:	88 02                	mov    %al,(%edx)
		start++ ;
  80113a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801146:	7c c4                	jl     80110c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801148:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801153:	90                   	nop
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 54 fa ff ff       	call   800bb8 <strlen>
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 46 fa ff ff       	call   800bb8 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801186:	eb 17                	jmp    80119f <strcconcat+0x49>
		final[s] = str1[s] ;
  801188:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	01 c8                	add    %ecx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119c:	ff 45 fc             	incl   -0x4(%ebp)
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a5:	7c e1                	jl     801188 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b5:	eb 1f                	jmp    8011d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c d9                	jl     8011b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120f:	eb 0c                	jmp    80121d <strsplit+0x31>
			*string++ = 0;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 08             	mov    %edx,0x8(%ebp)
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 18                	je     80123e <strsplit+0x52>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	e8 13 fb ff ff       	call   800d4a <strchr>
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 d3                	jne    801211 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 5a                	je     8012a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	83 f8 0f             	cmp    $0xf,%eax
  80124f:	75 07                	jne    801258 <strsplit+0x6c>
		{
			return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 66                	jmp    8012be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 14             	mov    0x14(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801276:	eb 03                	jmp    80127b <strsplit+0x8f>
			string++;
  801278:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	84 c0                	test   %al,%al
  801282:	74 8b                	je     80120f <strsplit+0x23>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 b5 fa ff ff       	call   800d4a <strchr>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 dc                	je     801278 <strsplit+0x8c>
			string++;
	}
  80129c:	e9 6e ff ff ff       	jmp    80120f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	8b 00                	mov    (%eax),%eax
  8012a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 1f                	je     8012ee <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cf:	e8 1d 00 00 00       	call   8012f1 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	68 f0 39 80 00       	push   $0x8039f0
  8012dc:	e8 55 f2 ff ff       	call   800536 <cprintf>
  8012e1:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e4:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012eb:	00 00 00 
	}
}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012f7:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012fe:	00 00 00 
  801301:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801308:	00 00 00 
  80130b:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801312:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801315:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80131c:	00 00 00 
  80131f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801326:	00 00 00 
  801329:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801330:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801333:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80133a:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80133d:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801347:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80134c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801351:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801356:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80135d:	a1 20 41 80 00       	mov    0x804120,%eax
  801362:	c1 e0 04             	shl    $0x4,%eax
  801365:	89 c2                	mov    %eax,%edx
  801367:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80136a:	01 d0                	add    %edx,%eax
  80136c:	48                   	dec    %eax
  80136d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801373:	ba 00 00 00 00       	mov    $0x0,%edx
  801378:	f7 75 f0             	divl   -0x10(%ebp)
  80137b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137e:	29 d0                	sub    %edx,%eax
  801380:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801383:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80138a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80138d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801392:	2d 00 10 00 00       	sub    $0x1000,%eax
  801397:	83 ec 04             	sub    $0x4,%esp
  80139a:	6a 06                	push   $0x6
  80139c:	ff 75 e8             	pushl  -0x18(%ebp)
  80139f:	50                   	push   %eax
  8013a0:	e8 b0 05 00 00       	call   801955 <sys_allocate_chunk>
  8013a5:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a8:	a1 20 41 80 00       	mov    0x804120,%eax
  8013ad:	83 ec 0c             	sub    $0xc,%esp
  8013b0:	50                   	push   %eax
  8013b1:	e8 25 0c 00 00       	call   801fdb <initialize_MemBlocksList>
  8013b6:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8013b9:	a1 48 41 80 00       	mov    0x804148,%eax
  8013be:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8013c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013c5:	75 14                	jne    8013db <initialize_dyn_block_system+0xea>
  8013c7:	83 ec 04             	sub    $0x4,%esp
  8013ca:	68 15 3a 80 00       	push   $0x803a15
  8013cf:	6a 29                	push   $0x29
  8013d1:	68 33 3a 80 00       	push   $0x803a33
  8013d6:	e8 a7 ee ff ff       	call   800282 <_panic>
  8013db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013de:	8b 00                	mov    (%eax),%eax
  8013e0:	85 c0                	test   %eax,%eax
  8013e2:	74 10                	je     8013f4 <initialize_dyn_block_system+0x103>
  8013e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e7:	8b 00                	mov    (%eax),%eax
  8013e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013ec:	8b 52 04             	mov    0x4(%edx),%edx
  8013ef:	89 50 04             	mov    %edx,0x4(%eax)
  8013f2:	eb 0b                	jmp    8013ff <initialize_dyn_block_system+0x10e>
  8013f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f7:	8b 40 04             	mov    0x4(%eax),%eax
  8013fa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801402:	8b 40 04             	mov    0x4(%eax),%eax
  801405:	85 c0                	test   %eax,%eax
  801407:	74 0f                	je     801418 <initialize_dyn_block_system+0x127>
  801409:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140c:	8b 40 04             	mov    0x4(%eax),%eax
  80140f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801412:	8b 12                	mov    (%edx),%edx
  801414:	89 10                	mov    %edx,(%eax)
  801416:	eb 0a                	jmp    801422 <initialize_dyn_block_system+0x131>
  801418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	a3 48 41 80 00       	mov    %eax,0x804148
  801422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801425:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80142b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801435:	a1 54 41 80 00       	mov    0x804154,%eax
  80143a:	48                   	dec    %eax
  80143b:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801440:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801443:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80144a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144d:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801454:	83 ec 0c             	sub    $0xc,%esp
  801457:	ff 75 e0             	pushl  -0x20(%ebp)
  80145a:	e8 b9 14 00 00       	call   802918 <insert_sorted_with_merge_freeList>
  80145f:	83 c4 10             	add    $0x10,%esp

}
  801462:	90                   	nop
  801463:	c9                   	leave  
  801464:	c3                   	ret    

00801465 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80146b:	e8 50 fe ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801470:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801474:	75 07                	jne    80147d <malloc+0x18>
  801476:	b8 00 00 00 00       	mov    $0x0,%eax
  80147b:	eb 68                	jmp    8014e5 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  80147d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801484:	8b 55 08             	mov    0x8(%ebp),%edx
  801487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148a:	01 d0                	add    %edx,%eax
  80148c:	48                   	dec    %eax
  80148d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801493:	ba 00 00 00 00       	mov    $0x0,%edx
  801498:	f7 75 f4             	divl   -0xc(%ebp)
  80149b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149e:	29 d0                	sub    %edx,%eax
  8014a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8014a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014aa:	e8 74 08 00 00       	call   801d23 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	74 2d                	je     8014e0 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8014b3:	83 ec 0c             	sub    $0xc,%esp
  8014b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b9:	e8 52 0e 00 00       	call   802310 <alloc_block_FF>
  8014be:	83 c4 10             	add    $0x10,%esp
  8014c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8014c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014c8:	74 16                	je     8014e0 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8014ca:	83 ec 0c             	sub    $0xc,%esp
  8014cd:	ff 75 e8             	pushl  -0x18(%ebp)
  8014d0:	e8 3b 0c 00 00       	call   802110 <insert_sorted_allocList>
  8014d5:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8014d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014db:	8b 40 08             	mov    0x8(%eax),%eax
  8014de:	eb 05                	jmp    8014e5 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8014e0:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8014e5:	c9                   	leave  
  8014e6:	c3                   	ret    

008014e7 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8014ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f0:	83 ec 08             	sub    $0x8,%esp
  8014f3:	50                   	push   %eax
  8014f4:	68 40 40 80 00       	push   $0x804040
  8014f9:	e8 ba 0b 00 00       	call   8020b8 <find_block>
  8014fe:	83 c4 10             	add    $0x10,%esp
  801501:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801507:	8b 40 0c             	mov    0xc(%eax),%eax
  80150a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80150d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801511:	0f 84 9f 00 00 00    	je     8015b6 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	83 ec 08             	sub    $0x8,%esp
  80151d:	ff 75 f0             	pushl  -0x10(%ebp)
  801520:	50                   	push   %eax
  801521:	e8 f7 03 00 00       	call   80191d <sys_free_user_mem>
  801526:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80152d:	75 14                	jne    801543 <free+0x5c>
  80152f:	83 ec 04             	sub    $0x4,%esp
  801532:	68 15 3a 80 00       	push   $0x803a15
  801537:	6a 6a                	push   $0x6a
  801539:	68 33 3a 80 00       	push   $0x803a33
  80153e:	e8 3f ed ff ff       	call   800282 <_panic>
  801543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801546:	8b 00                	mov    (%eax),%eax
  801548:	85 c0                	test   %eax,%eax
  80154a:	74 10                	je     80155c <free+0x75>
  80154c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154f:	8b 00                	mov    (%eax),%eax
  801551:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801554:	8b 52 04             	mov    0x4(%edx),%edx
  801557:	89 50 04             	mov    %edx,0x4(%eax)
  80155a:	eb 0b                	jmp    801567 <free+0x80>
  80155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155f:	8b 40 04             	mov    0x4(%eax),%eax
  801562:	a3 44 40 80 00       	mov    %eax,0x804044
  801567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156a:	8b 40 04             	mov    0x4(%eax),%eax
  80156d:	85 c0                	test   %eax,%eax
  80156f:	74 0f                	je     801580 <free+0x99>
  801571:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801574:	8b 40 04             	mov    0x4(%eax),%eax
  801577:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157a:	8b 12                	mov    (%edx),%edx
  80157c:	89 10                	mov    %edx,(%eax)
  80157e:	eb 0a                	jmp    80158a <free+0xa3>
  801580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801583:	8b 00                	mov    (%eax),%eax
  801585:	a3 40 40 80 00       	mov    %eax,0x804040
  80158a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801596:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80159d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015a2:	48                   	dec    %eax
  8015a3:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8015a8:	83 ec 0c             	sub    $0xc,%esp
  8015ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ae:	e8 65 13 00 00       	call   802918 <insert_sorted_with_merge_freeList>
  8015b3:	83 c4 10             	add    $0x10,%esp
	}
}
  8015b6:	90                   	nop
  8015b7:	c9                   	leave  
  8015b8:	c3                   	ret    

008015b9 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015b9:	55                   	push   %ebp
  8015ba:	89 e5                	mov    %esp,%ebp
  8015bc:	83 ec 28             	sub    $0x28,%esp
  8015bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8015c2:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c5:	e8 f6 fc ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015ca:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015ce:	75 0a                	jne    8015da <smalloc+0x21>
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	e9 af 00 00 00       	jmp    801689 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8015da:	e8 44 07 00 00       	call   801d23 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015df:	83 f8 01             	cmp    $0x1,%eax
  8015e2:	0f 85 9c 00 00 00    	jne    801684 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8015e8:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f5:	01 d0                	add    %edx,%eax
  8015f7:	48                   	dec    %eax
  8015f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801603:	f7 75 f4             	divl   -0xc(%ebp)
  801606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801609:	29 d0                	sub    %edx,%eax
  80160b:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80160e:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801615:	76 07                	jbe    80161e <smalloc+0x65>
			return NULL;
  801617:	b8 00 00 00 00       	mov    $0x0,%eax
  80161c:	eb 6b                	jmp    801689 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80161e:	83 ec 0c             	sub    $0xc,%esp
  801621:	ff 75 0c             	pushl  0xc(%ebp)
  801624:	e8 e7 0c 00 00       	call   802310 <alloc_block_FF>
  801629:	83 c4 10             	add    $0x10,%esp
  80162c:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80162f:	83 ec 0c             	sub    $0xc,%esp
  801632:	ff 75 ec             	pushl  -0x14(%ebp)
  801635:	e8 d6 0a 00 00       	call   802110 <insert_sorted_allocList>
  80163a:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80163d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801641:	75 07                	jne    80164a <smalloc+0x91>
		{
			return NULL;
  801643:	b8 00 00 00 00       	mov    $0x0,%eax
  801648:	eb 3f                	jmp    801689 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80164a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164d:	8b 40 08             	mov    0x8(%eax),%eax
  801650:	89 c2                	mov    %eax,%edx
  801652:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801656:	52                   	push   %edx
  801657:	50                   	push   %eax
  801658:	ff 75 0c             	pushl  0xc(%ebp)
  80165b:	ff 75 08             	pushl  0x8(%ebp)
  80165e:	e8 45 04 00 00       	call   801aa8 <sys_createSharedObject>
  801663:	83 c4 10             	add    $0x10,%esp
  801666:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801669:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80166d:	74 06                	je     801675 <smalloc+0xbc>
  80166f:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801673:	75 07                	jne    80167c <smalloc+0xc3>
		{
			return NULL;
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
  80167a:	eb 0d                	jmp    801689 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  80167c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167f:	8b 40 08             	mov    0x8(%eax),%eax
  801682:	eb 05                	jmp    801689 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801684:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801691:	e8 2a fc ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801696:	83 ec 08             	sub    $0x8,%esp
  801699:	ff 75 0c             	pushl  0xc(%ebp)
  80169c:	ff 75 08             	pushl  0x8(%ebp)
  80169f:	e8 2e 04 00 00       	call   801ad2 <sys_getSizeOfSharedObject>
  8016a4:	83 c4 10             	add    $0x10,%esp
  8016a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8016aa:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016ae:	75 0a                	jne    8016ba <sget+0x2f>
	{
		return NULL;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	e9 94 00 00 00       	jmp    80174e <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ba:	e8 64 06 00 00       	call   801d23 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	0f 84 82 00 00 00    	je     801749 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8016c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8016ce:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016db:	01 d0                	add    %edx,%eax
  8016dd:	48                   	dec    %eax
  8016de:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e9:	f7 75 ec             	divl   -0x14(%ebp)
  8016ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ef:	29 d0                	sub    %edx,%eax
  8016f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f7:	83 ec 0c             	sub    $0xc,%esp
  8016fa:	50                   	push   %eax
  8016fb:	e8 10 0c 00 00       	call   802310 <alloc_block_FF>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80170a:	75 07                	jne    801713 <sget+0x88>
		{
			return NULL;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
  801711:	eb 3b                	jmp    80174e <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801713:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801716:	8b 40 08             	mov    0x8(%eax),%eax
  801719:	83 ec 04             	sub    $0x4,%esp
  80171c:	50                   	push   %eax
  80171d:	ff 75 0c             	pushl  0xc(%ebp)
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	e8 c7 03 00 00       	call   801aef <sys_getSharedObject>
  801728:	83 c4 10             	add    $0x10,%esp
  80172b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80172e:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801732:	74 06                	je     80173a <sget+0xaf>
  801734:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801738:	75 07                	jne    801741 <sget+0xb6>
		{
			return NULL;
  80173a:	b8 00 00 00 00       	mov    $0x0,%eax
  80173f:	eb 0d                	jmp    80174e <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801741:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801744:	8b 40 08             	mov    0x8(%eax),%eax
  801747:	eb 05                	jmp    80174e <sget+0xc3>
		}
	}
	else
			return NULL;
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801756:	e8 65 fb ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80175b:	83 ec 04             	sub    $0x4,%esp
  80175e:	68 40 3a 80 00       	push   $0x803a40
  801763:	68 e1 00 00 00       	push   $0xe1
  801768:	68 33 3a 80 00       	push   $0x803a33
  80176d:	e8 10 eb ff ff       	call   800282 <_panic>

00801772 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801772:	55                   	push   %ebp
  801773:	89 e5                	mov    %esp,%ebp
  801775:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801778:	83 ec 04             	sub    $0x4,%esp
  80177b:	68 68 3a 80 00       	push   $0x803a68
  801780:	68 f5 00 00 00       	push   $0xf5
  801785:	68 33 3a 80 00       	push   $0x803a33
  80178a:	e8 f3 ea ff ff       	call   800282 <_panic>

0080178f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
  801792:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801795:	83 ec 04             	sub    $0x4,%esp
  801798:	68 8c 3a 80 00       	push   $0x803a8c
  80179d:	68 00 01 00 00       	push   $0x100
  8017a2:	68 33 3a 80 00       	push   $0x803a33
  8017a7:	e8 d6 ea ff ff       	call   800282 <_panic>

008017ac <shrink>:

}
void shrink(uint32 newSize)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
  8017af:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017b2:	83 ec 04             	sub    $0x4,%esp
  8017b5:	68 8c 3a 80 00       	push   $0x803a8c
  8017ba:	68 05 01 00 00       	push   $0x105
  8017bf:	68 33 3a 80 00       	push   $0x803a33
  8017c4:	e8 b9 ea ff ff       	call   800282 <_panic>

008017c9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017cf:	83 ec 04             	sub    $0x4,%esp
  8017d2:	68 8c 3a 80 00       	push   $0x803a8c
  8017d7:	68 0a 01 00 00       	push   $0x10a
  8017dc:	68 33 3a 80 00       	push   $0x803a33
  8017e1:	e8 9c ea ff ff       	call   800282 <_panic>

008017e6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	57                   	push   %edi
  8017ea:	56                   	push   %esi
  8017eb:	53                   	push   %ebx
  8017ec:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017fb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017fe:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801801:	cd 30                	int    $0x30
  801803:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801806:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	5b                   	pop    %ebx
  80180d:	5e                   	pop    %esi
  80180e:	5f                   	pop    %edi
  80180f:	5d                   	pop    %ebp
  801810:	c3                   	ret    

00801811 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801811:	55                   	push   %ebp
  801812:	89 e5                	mov    %esp,%ebp
  801814:	83 ec 04             	sub    $0x4,%esp
  801817:	8b 45 10             	mov    0x10(%ebp),%eax
  80181a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80181d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801821:	8b 45 08             	mov    0x8(%ebp),%eax
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	52                   	push   %edx
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	50                   	push   %eax
  80182d:	6a 00                	push   $0x0
  80182f:	e8 b2 ff ff ff       	call   8017e6 <syscall>
  801834:	83 c4 18             	add    $0x18,%esp
}
  801837:	90                   	nop
  801838:	c9                   	leave  
  801839:	c3                   	ret    

0080183a <sys_cgetc>:

int
sys_cgetc(void)
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 00                	push   $0x0
  801845:	6a 00                	push   $0x0
  801847:	6a 01                	push   $0x1
  801849:	e8 98 ff ff ff       	call   8017e6 <syscall>
  80184e:	83 c4 18             	add    $0x18,%esp
}
  801851:	c9                   	leave  
  801852:	c3                   	ret    

00801853 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801856:	8b 55 0c             	mov    0xc(%ebp),%edx
  801859:	8b 45 08             	mov    0x8(%ebp),%eax
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	52                   	push   %edx
  801863:	50                   	push   %eax
  801864:	6a 05                	push   $0x5
  801866:	e8 7b ff ff ff       	call   8017e6 <syscall>
  80186b:	83 c4 18             	add    $0x18,%esp
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801875:	8b 75 18             	mov    0x18(%ebp),%esi
  801878:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80187b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801881:	8b 45 08             	mov    0x8(%ebp),%eax
  801884:	56                   	push   %esi
  801885:	53                   	push   %ebx
  801886:	51                   	push   %ecx
  801887:	52                   	push   %edx
  801888:	50                   	push   %eax
  801889:	6a 06                	push   $0x6
  80188b:	e8 56 ff ff ff       	call   8017e6 <syscall>
  801890:	83 c4 18             	add    $0x18,%esp
}
  801893:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801896:	5b                   	pop    %ebx
  801897:	5e                   	pop    %esi
  801898:	5d                   	pop    %ebp
  801899:	c3                   	ret    

0080189a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80189d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	6a 00                	push   $0x0
  8018a5:	6a 00                	push   $0x0
  8018a7:	6a 00                	push   $0x0
  8018a9:	52                   	push   %edx
  8018aa:	50                   	push   %eax
  8018ab:	6a 07                	push   $0x7
  8018ad:	e8 34 ff ff ff       	call   8017e6 <syscall>
  8018b2:	83 c4 18             	add    $0x18,%esp
}
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	6a 00                	push   $0x0
  8018c0:	ff 75 0c             	pushl  0xc(%ebp)
  8018c3:	ff 75 08             	pushl  0x8(%ebp)
  8018c6:	6a 08                	push   $0x8
  8018c8:	e8 19 ff ff ff       	call   8017e6 <syscall>
  8018cd:	83 c4 18             	add    $0x18,%esp
}
  8018d0:	c9                   	leave  
  8018d1:	c3                   	ret    

008018d2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018d2:	55                   	push   %ebp
  8018d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 09                	push   $0x9
  8018e1:	e8 00 ff ff ff       	call   8017e6 <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 0a                	push   $0xa
  8018fa:	e8 e7 fe ff ff       	call   8017e6 <syscall>
  8018ff:	83 c4 18             	add    $0x18,%esp
}
  801902:	c9                   	leave  
  801903:	c3                   	ret    

00801904 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801904:	55                   	push   %ebp
  801905:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 0b                	push   $0xb
  801913:	e8 ce fe ff ff       	call   8017e6 <syscall>
  801918:	83 c4 18             	add    $0x18,%esp
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    

0080191d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	ff 75 0c             	pushl  0xc(%ebp)
  801929:	ff 75 08             	pushl  0x8(%ebp)
  80192c:	6a 0f                	push   $0xf
  80192e:	e8 b3 fe ff ff       	call   8017e6 <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
	return;
  801936:	90                   	nop
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	ff 75 0c             	pushl  0xc(%ebp)
  801945:	ff 75 08             	pushl  0x8(%ebp)
  801948:	6a 10                	push   $0x10
  80194a:	e8 97 fe ff ff       	call   8017e6 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
	return ;
  801952:	90                   	nop
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	ff 75 10             	pushl  0x10(%ebp)
  80195f:	ff 75 0c             	pushl  0xc(%ebp)
  801962:	ff 75 08             	pushl  0x8(%ebp)
  801965:	6a 11                	push   $0x11
  801967:	e8 7a fe ff ff       	call   8017e6 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
	return ;
  80196f:	90                   	nop
}
  801970:	c9                   	leave  
  801971:	c3                   	ret    

00801972 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801972:	55                   	push   %ebp
  801973:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 0c                	push   $0xc
  801981:	e8 60 fe ff ff       	call   8017e6 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	6a 0d                	push   $0xd
  80199b:	e8 46 fe ff ff       	call   8017e6 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 0e                	push   $0xe
  8019b4:	e8 2d fe ff ff       	call   8017e6 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	90                   	nop
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 13                	push   $0x13
  8019ce:	e8 13 fe ff ff       	call   8017e6 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	90                   	nop
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 14                	push   $0x14
  8019e8:	e8 f9 fd ff ff       	call   8017e6 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	90                   	nop
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	50                   	push   %eax
  801a0c:	6a 15                	push   $0x15
  801a0e:	e8 d3 fd ff ff       	call   8017e6 <syscall>
  801a13:	83 c4 18             	add    $0x18,%esp
}
  801a16:	90                   	nop
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 16                	push   $0x16
  801a28:	e8 b9 fd ff ff       	call   8017e6 <syscall>
  801a2d:	83 c4 18             	add    $0x18,%esp
}
  801a30:	90                   	nop
  801a31:	c9                   	leave  
  801a32:	c3                   	ret    

00801a33 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a33:	55                   	push   %ebp
  801a34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	50                   	push   %eax
  801a43:	6a 17                	push   $0x17
  801a45:	e8 9c fd ff ff       	call   8017e6 <syscall>
  801a4a:	83 c4 18             	add    $0x18,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	52                   	push   %edx
  801a5f:	50                   	push   %eax
  801a60:	6a 1a                	push   $0x1a
  801a62:	e8 7f fd ff ff       	call   8017e6 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a72:	8b 45 08             	mov    0x8(%ebp),%eax
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	52                   	push   %edx
  801a7c:	50                   	push   %eax
  801a7d:	6a 18                	push   $0x18
  801a7f:	e8 62 fd ff ff       	call   8017e6 <syscall>
  801a84:	83 c4 18             	add    $0x18,%esp
}
  801a87:	90                   	nop
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    

00801a8a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a8a:	55                   	push   %ebp
  801a8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a90:	8b 45 08             	mov    0x8(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	52                   	push   %edx
  801a9a:	50                   	push   %eax
  801a9b:	6a 19                	push   $0x19
  801a9d:	e8 44 fd ff ff       	call   8017e6 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	90                   	nop
  801aa6:	c9                   	leave  
  801aa7:	c3                   	ret    

00801aa8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aa8:	55                   	push   %ebp
  801aa9:	89 e5                	mov    %esp,%ebp
  801aab:	83 ec 04             	sub    $0x4,%esp
  801aae:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ab4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ab7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	6a 00                	push   $0x0
  801ac0:	51                   	push   %ecx
  801ac1:	52                   	push   %edx
  801ac2:	ff 75 0c             	pushl  0xc(%ebp)
  801ac5:	50                   	push   %eax
  801ac6:	6a 1b                	push   $0x1b
  801ac8:	e8 19 fd ff ff       	call   8017e6 <syscall>
  801acd:	83 c4 18             	add    $0x18,%esp
}
  801ad0:	c9                   	leave  
  801ad1:	c3                   	ret    

00801ad2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ad2:	55                   	push   %ebp
  801ad3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ad5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  801adb:	6a 00                	push   $0x0
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	52                   	push   %edx
  801ae2:	50                   	push   %eax
  801ae3:	6a 1c                	push   $0x1c
  801ae5:	e8 fc fc ff ff       	call   8017e6 <syscall>
  801aea:	83 c4 18             	add    $0x18,%esp
}
  801aed:	c9                   	leave  
  801aee:	c3                   	ret    

00801aef <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801af2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af8:	8b 45 08             	mov    0x8(%ebp),%eax
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	51                   	push   %ecx
  801b00:	52                   	push   %edx
  801b01:	50                   	push   %eax
  801b02:	6a 1d                	push   $0x1d
  801b04:	e8 dd fc ff ff       	call   8017e6 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	52                   	push   %edx
  801b1e:	50                   	push   %eax
  801b1f:	6a 1e                	push   $0x1e
  801b21:	e8 c0 fc ff ff       	call   8017e6 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 1f                	push   $0x1f
  801b3a:	e8 a7 fc ff ff       	call   8017e6 <syscall>
  801b3f:	83 c4 18             	add    $0x18,%esp
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	ff 75 14             	pushl  0x14(%ebp)
  801b4f:	ff 75 10             	pushl  0x10(%ebp)
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	50                   	push   %eax
  801b56:	6a 20                	push   $0x20
  801b58:	e8 89 fc ff ff       	call   8017e6 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 00                	push   $0x0
  801b70:	50                   	push   %eax
  801b71:	6a 21                	push   $0x21
  801b73:	e8 6e fc ff ff       	call   8017e6 <syscall>
  801b78:	83 c4 18             	add    $0x18,%esp
}
  801b7b:	90                   	nop
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 00                	push   $0x0
  801b8a:	6a 00                	push   $0x0
  801b8c:	50                   	push   %eax
  801b8d:	6a 22                	push   $0x22
  801b8f:	e8 52 fc ff ff       	call   8017e6 <syscall>
  801b94:	83 c4 18             	add    $0x18,%esp
}
  801b97:	c9                   	leave  
  801b98:	c3                   	ret    

00801b99 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b99:	55                   	push   %ebp
  801b9a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 02                	push   $0x2
  801ba8:	e8 39 fc ff ff       	call   8017e6 <syscall>
  801bad:	83 c4 18             	add    $0x18,%esp
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 03                	push   $0x3
  801bc1:	e8 20 fc ff ff       	call   8017e6 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 04                	push   $0x4
  801bda:	e8 07 fc ff ff       	call   8017e6 <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	c9                   	leave  
  801be3:	c3                   	ret    

00801be4 <sys_exit_env>:


void sys_exit_env(void)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 23                	push   $0x23
  801bf3:	e8 ee fb ff ff       	call   8017e6 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	90                   	nop
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
  801c01:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c04:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c07:	8d 50 04             	lea    0x4(%eax),%edx
  801c0a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	52                   	push   %edx
  801c14:	50                   	push   %eax
  801c15:	6a 24                	push   $0x24
  801c17:	e8 ca fb ff ff       	call   8017e6 <syscall>
  801c1c:	83 c4 18             	add    $0x18,%esp
	return result;
  801c1f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c22:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c25:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c28:	89 01                	mov    %eax,(%ecx)
  801c2a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	c9                   	leave  
  801c31:	c2 04 00             	ret    $0x4

00801c34 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	ff 75 10             	pushl  0x10(%ebp)
  801c3e:	ff 75 0c             	pushl  0xc(%ebp)
  801c41:	ff 75 08             	pushl  0x8(%ebp)
  801c44:	6a 12                	push   $0x12
  801c46:	e8 9b fb ff ff       	call   8017e6 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4e:	90                   	nop
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 25                	push   $0x25
  801c60:	e8 81 fb ff ff       	call   8017e6 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	83 ec 04             	sub    $0x4,%esp
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c76:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	50                   	push   %eax
  801c83:	6a 26                	push   $0x26
  801c85:	e8 5c fb ff ff       	call   8017e6 <syscall>
  801c8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8d:	90                   	nop
}
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <rsttst>:
void rsttst()
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	6a 28                	push   $0x28
  801c9f:	e8 42 fb ff ff       	call   8017e6 <syscall>
  801ca4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca7:	90                   	nop
}
  801ca8:	c9                   	leave  
  801ca9:	c3                   	ret    

00801caa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801caa:	55                   	push   %ebp
  801cab:	89 e5                	mov    %esp,%ebp
  801cad:	83 ec 04             	sub    $0x4,%esp
  801cb0:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cb6:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cbd:	52                   	push   %edx
  801cbe:	50                   	push   %eax
  801cbf:	ff 75 10             	pushl  0x10(%ebp)
  801cc2:	ff 75 0c             	pushl  0xc(%ebp)
  801cc5:	ff 75 08             	pushl  0x8(%ebp)
  801cc8:	6a 27                	push   $0x27
  801cca:	e8 17 fb ff ff       	call   8017e6 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cd2:	90                   	nop
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <chktst>:
void chktst(uint32 n)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	ff 75 08             	pushl  0x8(%ebp)
  801ce3:	6a 29                	push   $0x29
  801ce5:	e8 fc fa ff ff       	call   8017e6 <syscall>
  801cea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ced:	90                   	nop
}
  801cee:	c9                   	leave  
  801cef:	c3                   	ret    

00801cf0 <inctst>:

void inctst()
{
  801cf0:	55                   	push   %ebp
  801cf1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 2a                	push   $0x2a
  801cff:	e8 e2 fa ff ff       	call   8017e6 <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
	return ;
  801d07:	90                   	nop
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <gettst>:
uint32 gettst()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 2b                	push   $0x2b
  801d19:	e8 c8 fa ff ff       	call   8017e6 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 2c                	push   $0x2c
  801d35:	e8 ac fa ff ff       	call   8017e6 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
  801d3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d40:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d44:	75 07                	jne    801d4d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d46:	b8 01 00 00 00       	mov    $0x1,%eax
  801d4b:	eb 05                	jmp    801d52 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 2c                	push   $0x2c
  801d66:	e8 7b fa ff ff       	call   8017e6 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
  801d6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d71:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d75:	75 07                	jne    801d7e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d77:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7c:	eb 05                	jmp    801d83 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 2c                	push   $0x2c
  801d97:	e8 4a fa ff ff       	call   8017e6 <syscall>
  801d9c:	83 c4 18             	add    $0x18,%esp
  801d9f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801da2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801da6:	75 07                	jne    801daf <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801da8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dad:	eb 05                	jmp    801db4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 2c                	push   $0x2c
  801dc8:	e8 19 fa ff ff       	call   8017e6 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
  801dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dd3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dd7:	75 07                	jne    801de0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dde:	eb 05                	jmp    801de5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	ff 75 08             	pushl  0x8(%ebp)
  801df5:	6a 2d                	push   $0x2d
  801df7:	e8 ea f9 ff ff       	call   8017e6 <syscall>
  801dfc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dff:	90                   	nop
}
  801e00:	c9                   	leave  
  801e01:	c3                   	ret    

00801e02 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e06:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e09:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e12:	6a 00                	push   $0x0
  801e14:	53                   	push   %ebx
  801e15:	51                   	push   %ecx
  801e16:	52                   	push   %edx
  801e17:	50                   	push   %eax
  801e18:	6a 2e                	push   $0x2e
  801e1a:	e8 c7 f9 ff ff       	call   8017e6 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
}
  801e22:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e25:	c9                   	leave  
  801e26:	c3                   	ret    

00801e27 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e27:	55                   	push   %ebp
  801e28:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	52                   	push   %edx
  801e37:	50                   	push   %eax
  801e38:	6a 2f                	push   $0x2f
  801e3a:	e8 a7 f9 ff ff       	call   8017e6 <syscall>
  801e3f:	83 c4 18             	add    $0x18,%esp
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e4a:	83 ec 0c             	sub    $0xc,%esp
  801e4d:	68 9c 3a 80 00       	push   $0x803a9c
  801e52:	e8 df e6 ff ff       	call   800536 <cprintf>
  801e57:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e61:	83 ec 0c             	sub    $0xc,%esp
  801e64:	68 c8 3a 80 00       	push   $0x803ac8
  801e69:	e8 c8 e6 ff ff       	call   800536 <cprintf>
  801e6e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e71:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e75:	a1 38 41 80 00       	mov    0x804138,%eax
  801e7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7d:	eb 56                	jmp    801ed5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e83:	74 1c                	je     801ea1 <print_mem_block_lists+0x5d>
  801e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e88:	8b 50 08             	mov    0x8(%eax),%edx
  801e8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8e:	8b 48 08             	mov    0x8(%eax),%ecx
  801e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e94:	8b 40 0c             	mov    0xc(%eax),%eax
  801e97:	01 c8                	add    %ecx,%eax
  801e99:	39 c2                	cmp    %eax,%edx
  801e9b:	73 04                	jae    801ea1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e9d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea4:	8b 50 08             	mov    0x8(%eax),%edx
  801ea7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  801ead:	01 c2                	add    %eax,%edx
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb2:	8b 40 08             	mov    0x8(%eax),%eax
  801eb5:	83 ec 04             	sub    $0x4,%esp
  801eb8:	52                   	push   %edx
  801eb9:	50                   	push   %eax
  801eba:	68 dd 3a 80 00       	push   $0x803add
  801ebf:	e8 72 e6 ff ff       	call   800536 <cprintf>
  801ec4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ecd:	a1 40 41 80 00       	mov    0x804140,%eax
  801ed2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed9:	74 07                	je     801ee2 <print_mem_block_lists+0x9e>
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	8b 00                	mov    (%eax),%eax
  801ee0:	eb 05                	jmp    801ee7 <print_mem_block_lists+0xa3>
  801ee2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee7:	a3 40 41 80 00       	mov    %eax,0x804140
  801eec:	a1 40 41 80 00       	mov    0x804140,%eax
  801ef1:	85 c0                	test   %eax,%eax
  801ef3:	75 8a                	jne    801e7f <print_mem_block_lists+0x3b>
  801ef5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef9:	75 84                	jne    801e7f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801efb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eff:	75 10                	jne    801f11 <print_mem_block_lists+0xcd>
  801f01:	83 ec 0c             	sub    $0xc,%esp
  801f04:	68 ec 3a 80 00       	push   $0x803aec
  801f09:	e8 28 e6 ff ff       	call   800536 <cprintf>
  801f0e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f18:	83 ec 0c             	sub    $0xc,%esp
  801f1b:	68 10 3b 80 00       	push   $0x803b10
  801f20:	e8 11 e6 ff ff       	call   800536 <cprintf>
  801f25:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f28:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f2c:	a1 40 40 80 00       	mov    0x804040,%eax
  801f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f34:	eb 56                	jmp    801f8c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f36:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f3a:	74 1c                	je     801f58 <print_mem_block_lists+0x114>
  801f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3f:	8b 50 08             	mov    0x8(%eax),%edx
  801f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f45:	8b 48 08             	mov    0x8(%eax),%ecx
  801f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4e:	01 c8                	add    %ecx,%eax
  801f50:	39 c2                	cmp    %eax,%edx
  801f52:	73 04                	jae    801f58 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f54:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5b:	8b 50 08             	mov    0x8(%eax),%edx
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 40 0c             	mov    0xc(%eax),%eax
  801f64:	01 c2                	add    %eax,%edx
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	8b 40 08             	mov    0x8(%eax),%eax
  801f6c:	83 ec 04             	sub    $0x4,%esp
  801f6f:	52                   	push   %edx
  801f70:	50                   	push   %eax
  801f71:	68 dd 3a 80 00       	push   $0x803add
  801f76:	e8 bb e5 ff ff       	call   800536 <cprintf>
  801f7b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f84:	a1 48 40 80 00       	mov    0x804048,%eax
  801f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f90:	74 07                	je     801f99 <print_mem_block_lists+0x155>
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	8b 00                	mov    (%eax),%eax
  801f97:	eb 05                	jmp    801f9e <print_mem_block_lists+0x15a>
  801f99:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9e:	a3 48 40 80 00       	mov    %eax,0x804048
  801fa3:	a1 48 40 80 00       	mov    0x804048,%eax
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	75 8a                	jne    801f36 <print_mem_block_lists+0xf2>
  801fac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb0:	75 84                	jne    801f36 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fb2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fb6:	75 10                	jne    801fc8 <print_mem_block_lists+0x184>
  801fb8:	83 ec 0c             	sub    $0xc,%esp
  801fbb:	68 28 3b 80 00       	push   $0x803b28
  801fc0:	e8 71 e5 ff ff       	call   800536 <cprintf>
  801fc5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fc8:	83 ec 0c             	sub    $0xc,%esp
  801fcb:	68 9c 3a 80 00       	push   $0x803a9c
  801fd0:	e8 61 e5 ff ff       	call   800536 <cprintf>
  801fd5:	83 c4 10             	add    $0x10,%esp

}
  801fd8:	90                   	nop
  801fd9:	c9                   	leave  
  801fda:	c3                   	ret    

00801fdb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fdb:	55                   	push   %ebp
  801fdc:	89 e5                	mov    %esp,%ebp
  801fde:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fe1:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fe8:	00 00 00 
  801feb:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ff2:	00 00 00 
  801ff5:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ffc:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  801fff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802006:	e9 9e 00 00 00       	jmp    8020a9 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80200b:	a1 50 40 80 00       	mov    0x804050,%eax
  802010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802013:	c1 e2 04             	shl    $0x4,%edx
  802016:	01 d0                	add    %edx,%eax
  802018:	85 c0                	test   %eax,%eax
  80201a:	75 14                	jne    802030 <initialize_MemBlocksList+0x55>
  80201c:	83 ec 04             	sub    $0x4,%esp
  80201f:	68 50 3b 80 00       	push   $0x803b50
  802024:	6a 42                	push   $0x42
  802026:	68 73 3b 80 00       	push   $0x803b73
  80202b:	e8 52 e2 ff ff       	call   800282 <_panic>
  802030:	a1 50 40 80 00       	mov    0x804050,%eax
  802035:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802038:	c1 e2 04             	shl    $0x4,%edx
  80203b:	01 d0                	add    %edx,%eax
  80203d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802043:	89 10                	mov    %edx,(%eax)
  802045:	8b 00                	mov    (%eax),%eax
  802047:	85 c0                	test   %eax,%eax
  802049:	74 18                	je     802063 <initialize_MemBlocksList+0x88>
  80204b:	a1 48 41 80 00       	mov    0x804148,%eax
  802050:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802056:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802059:	c1 e1 04             	shl    $0x4,%ecx
  80205c:	01 ca                	add    %ecx,%edx
  80205e:	89 50 04             	mov    %edx,0x4(%eax)
  802061:	eb 12                	jmp    802075 <initialize_MemBlocksList+0x9a>
  802063:	a1 50 40 80 00       	mov    0x804050,%eax
  802068:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206b:	c1 e2 04             	shl    $0x4,%edx
  80206e:	01 d0                	add    %edx,%eax
  802070:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802075:	a1 50 40 80 00       	mov    0x804050,%eax
  80207a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207d:	c1 e2 04             	shl    $0x4,%edx
  802080:	01 d0                	add    %edx,%eax
  802082:	a3 48 41 80 00       	mov    %eax,0x804148
  802087:	a1 50 40 80 00       	mov    0x804050,%eax
  80208c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208f:	c1 e2 04             	shl    $0x4,%edx
  802092:	01 d0                	add    %edx,%eax
  802094:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80209b:	a1 54 41 80 00       	mov    0x804154,%eax
  8020a0:	40                   	inc    %eax
  8020a1:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8020a6:	ff 45 f4             	incl   -0xc(%ebp)
  8020a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020af:	0f 82 56 ff ff ff    	jb     80200b <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8020b5:	90                   	nop
  8020b6:	c9                   	leave  
  8020b7:	c3                   	ret    

008020b8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020b8:	55                   	push   %ebp
  8020b9:	89 e5                	mov    %esp,%ebp
  8020bb:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	8b 00                	mov    (%eax),%eax
  8020c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020c6:	eb 19                	jmp    8020e1 <find_block+0x29>
	{
		if(blk->sva==va)
  8020c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cb:	8b 40 08             	mov    0x8(%eax),%eax
  8020ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020d1:	75 05                	jne    8020d8 <find_block+0x20>
			return (blk);
  8020d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d6:	eb 36                	jmp    80210e <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8b 40 08             	mov    0x8(%eax),%eax
  8020de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020e1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020e5:	74 07                	je     8020ee <find_block+0x36>
  8020e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ea:	8b 00                	mov    (%eax),%eax
  8020ec:	eb 05                	jmp    8020f3 <find_block+0x3b>
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f6:	89 42 08             	mov    %eax,0x8(%edx)
  8020f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fc:	8b 40 08             	mov    0x8(%eax),%eax
  8020ff:	85 c0                	test   %eax,%eax
  802101:	75 c5                	jne    8020c8 <find_block+0x10>
  802103:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802107:	75 bf                	jne    8020c8 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802109:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    

00802110 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
  802113:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802116:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80211b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80211e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802125:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802128:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80212b:	75 65                	jne    802192 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80212d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802131:	75 14                	jne    802147 <insert_sorted_allocList+0x37>
  802133:	83 ec 04             	sub    $0x4,%esp
  802136:	68 50 3b 80 00       	push   $0x803b50
  80213b:	6a 5c                	push   $0x5c
  80213d:	68 73 3b 80 00       	push   $0x803b73
  802142:	e8 3b e1 ff ff       	call   800282 <_panic>
  802147:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80214d:	8b 45 08             	mov    0x8(%ebp),%eax
  802150:	89 10                	mov    %edx,(%eax)
  802152:	8b 45 08             	mov    0x8(%ebp),%eax
  802155:	8b 00                	mov    (%eax),%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	74 0d                	je     802168 <insert_sorted_allocList+0x58>
  80215b:	a1 40 40 80 00       	mov    0x804040,%eax
  802160:	8b 55 08             	mov    0x8(%ebp),%edx
  802163:	89 50 04             	mov    %edx,0x4(%eax)
  802166:	eb 08                	jmp    802170 <insert_sorted_allocList+0x60>
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	a3 44 40 80 00       	mov    %eax,0x804044
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	a3 40 40 80 00       	mov    %eax,0x804040
  802178:	8b 45 08             	mov    0x8(%ebp),%eax
  80217b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802182:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802187:	40                   	inc    %eax
  802188:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80218d:	e9 7b 01 00 00       	jmp    80230d <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802192:	a1 44 40 80 00       	mov    0x804044,%eax
  802197:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80219a:	a1 40 40 80 00       	mov    0x804040,%eax
  80219f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	8b 50 08             	mov    0x8(%eax),%edx
  8021a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021ab:	8b 40 08             	mov    0x8(%eax),%eax
  8021ae:	39 c2                	cmp    %eax,%edx
  8021b0:	76 65                	jbe    802217 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8021b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b6:	75 14                	jne    8021cc <insert_sorted_allocList+0xbc>
  8021b8:	83 ec 04             	sub    $0x4,%esp
  8021bb:	68 8c 3b 80 00       	push   $0x803b8c
  8021c0:	6a 64                	push   $0x64
  8021c2:	68 73 3b 80 00       	push   $0x803b73
  8021c7:	e8 b6 e0 ff ff       	call   800282 <_panic>
  8021cc:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	89 50 04             	mov    %edx,0x4(%eax)
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	8b 40 04             	mov    0x4(%eax),%eax
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	74 0c                	je     8021ee <insert_sorted_allocList+0xde>
  8021e2:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ea:	89 10                	mov    %edx,(%eax)
  8021ec:	eb 08                	jmp    8021f6 <insert_sorted_allocList+0xe6>
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	a3 44 40 80 00       	mov    %eax,0x804044
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802207:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80220c:	40                   	inc    %eax
  80220d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802212:	e9 f6 00 00 00       	jmp    80230d <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	8b 50 08             	mov    0x8(%eax),%edx
  80221d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802220:	8b 40 08             	mov    0x8(%eax),%eax
  802223:	39 c2                	cmp    %eax,%edx
  802225:	73 65                	jae    80228c <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802227:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80222b:	75 14                	jne    802241 <insert_sorted_allocList+0x131>
  80222d:	83 ec 04             	sub    $0x4,%esp
  802230:	68 50 3b 80 00       	push   $0x803b50
  802235:	6a 68                	push   $0x68
  802237:	68 73 3b 80 00       	push   $0x803b73
  80223c:	e8 41 e0 ff ff       	call   800282 <_panic>
  802241:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	89 10                	mov    %edx,(%eax)
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	8b 00                	mov    (%eax),%eax
  802251:	85 c0                	test   %eax,%eax
  802253:	74 0d                	je     802262 <insert_sorted_allocList+0x152>
  802255:	a1 40 40 80 00       	mov    0x804040,%eax
  80225a:	8b 55 08             	mov    0x8(%ebp),%edx
  80225d:	89 50 04             	mov    %edx,0x4(%eax)
  802260:	eb 08                	jmp    80226a <insert_sorted_allocList+0x15a>
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	a3 44 40 80 00       	mov    %eax,0x804044
  80226a:	8b 45 08             	mov    0x8(%ebp),%eax
  80226d:	a3 40 40 80 00       	mov    %eax,0x804040
  802272:	8b 45 08             	mov    0x8(%ebp),%eax
  802275:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80227c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802281:	40                   	inc    %eax
  802282:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802287:	e9 81 00 00 00       	jmp    80230d <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80228c:	a1 40 40 80 00       	mov    0x804040,%eax
  802291:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802294:	eb 51                	jmp    8022e7 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	8b 50 08             	mov    0x8(%eax),%edx
  80229c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229f:	8b 40 08             	mov    0x8(%eax),%eax
  8022a2:	39 c2                	cmp    %eax,%edx
  8022a4:	73 39                	jae    8022df <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8022a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a9:	8b 40 04             	mov    0x4(%eax),%eax
  8022ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8022af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b5:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022bd:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c6:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8022c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ce:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8022d1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d6:	40                   	inc    %eax
  8022d7:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8022dc:	90                   	nop
				}
			}
		 }

	}
}
  8022dd:	eb 2e                	jmp    80230d <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022df:	a1 48 40 80 00       	mov    0x804048,%eax
  8022e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022eb:	74 07                	je     8022f4 <insert_sorted_allocList+0x1e4>
  8022ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f0:	8b 00                	mov    (%eax),%eax
  8022f2:	eb 05                	jmp    8022f9 <insert_sorted_allocList+0x1e9>
  8022f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f9:	a3 48 40 80 00       	mov    %eax,0x804048
  8022fe:	a1 48 40 80 00       	mov    0x804048,%eax
  802303:	85 c0                	test   %eax,%eax
  802305:	75 8f                	jne    802296 <insert_sorted_allocList+0x186>
  802307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230b:	75 89                	jne    802296 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80230d:	90                   	nop
  80230e:	c9                   	leave  
  80230f:	c3                   	ret    

00802310 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802310:	55                   	push   %ebp
  802311:	89 e5                	mov    %esp,%ebp
  802313:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802316:	a1 38 41 80 00       	mov    0x804138,%eax
  80231b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231e:	e9 76 01 00 00       	jmp    802499 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 40 0c             	mov    0xc(%eax),%eax
  802329:	3b 45 08             	cmp    0x8(%ebp),%eax
  80232c:	0f 85 8a 00 00 00    	jne    8023bc <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802332:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802336:	75 17                	jne    80234f <alloc_block_FF+0x3f>
  802338:	83 ec 04             	sub    $0x4,%esp
  80233b:	68 af 3b 80 00       	push   $0x803baf
  802340:	68 8a 00 00 00       	push   $0x8a
  802345:	68 73 3b 80 00       	push   $0x803b73
  80234a:	e8 33 df ff ff       	call   800282 <_panic>
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 00                	mov    (%eax),%eax
  802354:	85 c0                	test   %eax,%eax
  802356:	74 10                	je     802368 <alloc_block_FF+0x58>
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 00                	mov    (%eax),%eax
  80235d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802360:	8b 52 04             	mov    0x4(%edx),%edx
  802363:	89 50 04             	mov    %edx,0x4(%eax)
  802366:	eb 0b                	jmp    802373 <alloc_block_FF+0x63>
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 40 04             	mov    0x4(%eax),%eax
  80236e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 40 04             	mov    0x4(%eax),%eax
  802379:	85 c0                	test   %eax,%eax
  80237b:	74 0f                	je     80238c <alloc_block_FF+0x7c>
  80237d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802380:	8b 40 04             	mov    0x4(%eax),%eax
  802383:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802386:	8b 12                	mov    (%edx),%edx
  802388:	89 10                	mov    %edx,(%eax)
  80238a:	eb 0a                	jmp    802396 <alloc_block_FF+0x86>
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	a3 38 41 80 00       	mov    %eax,0x804138
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a9:	a1 44 41 80 00       	mov    0x804144,%eax
  8023ae:	48                   	dec    %eax
  8023af:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	e9 10 01 00 00       	jmp    8024cc <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8023c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c5:	0f 86 c6 00 00 00    	jbe    802491 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8023cb:	a1 48 41 80 00       	mov    0x804148,%eax
  8023d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8023d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d7:	75 17                	jne    8023f0 <alloc_block_FF+0xe0>
  8023d9:	83 ec 04             	sub    $0x4,%esp
  8023dc:	68 af 3b 80 00       	push   $0x803baf
  8023e1:	68 90 00 00 00       	push   $0x90
  8023e6:	68 73 3b 80 00       	push   $0x803b73
  8023eb:	e8 92 de ff ff       	call   800282 <_panic>
  8023f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f3:	8b 00                	mov    (%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 10                	je     802409 <alloc_block_FF+0xf9>
  8023f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fc:	8b 00                	mov    (%eax),%eax
  8023fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802401:	8b 52 04             	mov    0x4(%edx),%edx
  802404:	89 50 04             	mov    %edx,0x4(%eax)
  802407:	eb 0b                	jmp    802414 <alloc_block_FF+0x104>
  802409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240c:	8b 40 04             	mov    0x4(%eax),%eax
  80240f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802417:	8b 40 04             	mov    0x4(%eax),%eax
  80241a:	85 c0                	test   %eax,%eax
  80241c:	74 0f                	je     80242d <alloc_block_FF+0x11d>
  80241e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802421:	8b 40 04             	mov    0x4(%eax),%eax
  802424:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802427:	8b 12                	mov    (%edx),%edx
  802429:	89 10                	mov    %edx,(%eax)
  80242b:	eb 0a                	jmp    802437 <alloc_block_FF+0x127>
  80242d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	a3 48 41 80 00       	mov    %eax,0x804148
  802437:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802443:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244a:	a1 54 41 80 00       	mov    0x804154,%eax
  80244f:	48                   	dec    %eax
  802450:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802458:	8b 55 08             	mov    0x8(%ebp),%edx
  80245b:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 50 08             	mov    0x8(%eax),%edx
  802464:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802467:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 50 08             	mov    0x8(%eax),%edx
  802470:	8b 45 08             	mov    0x8(%ebp),%eax
  802473:	01 c2                	add    %eax,%edx
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 40 0c             	mov    0xc(%eax),%eax
  802481:	2b 45 08             	sub    0x8(%ebp),%eax
  802484:	89 c2                	mov    %eax,%edx
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	eb 3b                	jmp    8024cc <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802491:	a1 40 41 80 00       	mov    0x804140,%eax
  802496:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802499:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249d:	74 07                	je     8024a6 <alloc_block_FF+0x196>
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	8b 00                	mov    (%eax),%eax
  8024a4:	eb 05                	jmp    8024ab <alloc_block_FF+0x19b>
  8024a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024ab:	a3 40 41 80 00       	mov    %eax,0x804140
  8024b0:	a1 40 41 80 00       	mov    0x804140,%eax
  8024b5:	85 c0                	test   %eax,%eax
  8024b7:	0f 85 66 fe ff ff    	jne    802323 <alloc_block_FF+0x13>
  8024bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c1:	0f 85 5c fe ff ff    	jne    802323 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8024c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024cc:	c9                   	leave  
  8024cd:	c3                   	ret    

008024ce <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024ce:	55                   	push   %ebp
  8024cf:	89 e5                	mov    %esp,%ebp
  8024d1:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8024d4:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8024db:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8024e2:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8024e9:	a1 38 41 80 00       	mov    0x804138,%eax
  8024ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f1:	e9 cf 00 00 00       	jmp    8025c5 <alloc_block_BF+0xf7>
		{
			c++;
  8024f6:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802502:	0f 85 8a 00 00 00    	jne    802592 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802508:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80250c:	75 17                	jne    802525 <alloc_block_BF+0x57>
  80250e:	83 ec 04             	sub    $0x4,%esp
  802511:	68 af 3b 80 00       	push   $0x803baf
  802516:	68 a8 00 00 00       	push   $0xa8
  80251b:	68 73 3b 80 00       	push   $0x803b73
  802520:	e8 5d dd ff ff       	call   800282 <_panic>
  802525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802528:	8b 00                	mov    (%eax),%eax
  80252a:	85 c0                	test   %eax,%eax
  80252c:	74 10                	je     80253e <alloc_block_BF+0x70>
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 00                	mov    (%eax),%eax
  802533:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802536:	8b 52 04             	mov    0x4(%edx),%edx
  802539:	89 50 04             	mov    %edx,0x4(%eax)
  80253c:	eb 0b                	jmp    802549 <alloc_block_BF+0x7b>
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 40 04             	mov    0x4(%eax),%eax
  802544:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	8b 40 04             	mov    0x4(%eax),%eax
  80254f:	85 c0                	test   %eax,%eax
  802551:	74 0f                	je     802562 <alloc_block_BF+0x94>
  802553:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802556:	8b 40 04             	mov    0x4(%eax),%eax
  802559:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80255c:	8b 12                	mov    (%edx),%edx
  80255e:	89 10                	mov    %edx,(%eax)
  802560:	eb 0a                	jmp    80256c <alloc_block_BF+0x9e>
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	a3 38 41 80 00       	mov    %eax,0x804138
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257f:	a1 44 41 80 00       	mov    0x804144,%eax
  802584:	48                   	dec    %eax
  802585:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	e9 85 01 00 00       	jmp    802717 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 0c             	mov    0xc(%eax),%eax
  802598:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259b:	76 20                	jbe    8025bd <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  80259d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a3:	2b 45 08             	sub    0x8(%ebp),%eax
  8025a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8025a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025ac:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025af:	73 0c                	jae    8025bd <alloc_block_BF+0xef>
				{
					ma=tempi;
  8025b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8025b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025bd:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c9:	74 07                	je     8025d2 <alloc_block_BF+0x104>
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	8b 00                	mov    (%eax),%eax
  8025d0:	eb 05                	jmp    8025d7 <alloc_block_BF+0x109>
  8025d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d7:	a3 40 41 80 00       	mov    %eax,0x804140
  8025dc:	a1 40 41 80 00       	mov    0x804140,%eax
  8025e1:	85 c0                	test   %eax,%eax
  8025e3:	0f 85 0d ff ff ff    	jne    8024f6 <alloc_block_BF+0x28>
  8025e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ed:	0f 85 03 ff ff ff    	jne    8024f6 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8025f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025fa:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802602:	e9 dd 00 00 00       	jmp    8026e4 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80260a:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80260d:	0f 85 c6 00 00 00    	jne    8026d9 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802613:	a1 48 41 80 00       	mov    0x804148,%eax
  802618:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80261b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80261f:	75 17                	jne    802638 <alloc_block_BF+0x16a>
  802621:	83 ec 04             	sub    $0x4,%esp
  802624:	68 af 3b 80 00       	push   $0x803baf
  802629:	68 bb 00 00 00       	push   $0xbb
  80262e:	68 73 3b 80 00       	push   $0x803b73
  802633:	e8 4a dc ff ff       	call   800282 <_panic>
  802638:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	85 c0                	test   %eax,%eax
  80263f:	74 10                	je     802651 <alloc_block_BF+0x183>
  802641:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802644:	8b 00                	mov    (%eax),%eax
  802646:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802649:	8b 52 04             	mov    0x4(%edx),%edx
  80264c:	89 50 04             	mov    %edx,0x4(%eax)
  80264f:	eb 0b                	jmp    80265c <alloc_block_BF+0x18e>
  802651:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802654:	8b 40 04             	mov    0x4(%eax),%eax
  802657:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80265c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265f:	8b 40 04             	mov    0x4(%eax),%eax
  802662:	85 c0                	test   %eax,%eax
  802664:	74 0f                	je     802675 <alloc_block_BF+0x1a7>
  802666:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802669:	8b 40 04             	mov    0x4(%eax),%eax
  80266c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80266f:	8b 12                	mov    (%edx),%edx
  802671:	89 10                	mov    %edx,(%eax)
  802673:	eb 0a                	jmp    80267f <alloc_block_BF+0x1b1>
  802675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	a3 48 41 80 00       	mov    %eax,0x804148
  80267f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802682:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802688:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802692:	a1 54 41 80 00       	mov    0x804154,%eax
  802697:	48                   	dec    %eax
  802698:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  80269d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a3:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8026a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a9:	8b 50 08             	mov    0x8(%eax),%edx
  8026ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026af:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 50 08             	mov    0x8(%eax),%edx
  8026b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bb:	01 c2                	add    %eax,%edx
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c9:	2b 45 08             	sub    0x8(%ebp),%eax
  8026cc:	89 c2                	mov    %eax,%edx
  8026ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d1:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8026d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d7:	eb 3e                	jmp    802717 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8026d9:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026dc:	a1 40 41 80 00       	mov    0x804140,%eax
  8026e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e8:	74 07                	je     8026f1 <alloc_block_BF+0x223>
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 00                	mov    (%eax),%eax
  8026ef:	eb 05                	jmp    8026f6 <alloc_block_BF+0x228>
  8026f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f6:	a3 40 41 80 00       	mov    %eax,0x804140
  8026fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802700:	85 c0                	test   %eax,%eax
  802702:	0f 85 ff fe ff ff    	jne    802607 <alloc_block_BF+0x139>
  802708:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80270c:	0f 85 f5 fe ff ff    	jne    802607 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802712:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802717:	c9                   	leave  
  802718:	c3                   	ret    

00802719 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802719:	55                   	push   %ebp
  80271a:	89 e5                	mov    %esp,%ebp
  80271c:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80271f:	a1 28 40 80 00       	mov    0x804028,%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	75 14                	jne    80273c <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802728:	a1 38 41 80 00       	mov    0x804138,%eax
  80272d:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802732:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802739:	00 00 00 
	}
	uint32 c=1;
  80273c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802743:	a1 60 41 80 00       	mov    0x804160,%eax
  802748:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80274b:	e9 b3 01 00 00       	jmp    802903 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802750:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802753:	8b 40 0c             	mov    0xc(%eax),%eax
  802756:	3b 45 08             	cmp    0x8(%ebp),%eax
  802759:	0f 85 a9 00 00 00    	jne    802808 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80275f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	75 0c                	jne    802774 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802768:	a1 38 41 80 00       	mov    0x804138,%eax
  80276d:	a3 60 41 80 00       	mov    %eax,0x804160
  802772:	eb 0a                	jmp    80277e <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  80277e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802782:	75 17                	jne    80279b <alloc_block_NF+0x82>
  802784:	83 ec 04             	sub    $0x4,%esp
  802787:	68 af 3b 80 00       	push   $0x803baf
  80278c:	68 e3 00 00 00       	push   $0xe3
  802791:	68 73 3b 80 00       	push   $0x803b73
  802796:	e8 e7 da ff ff       	call   800282 <_panic>
  80279b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279e:	8b 00                	mov    (%eax),%eax
  8027a0:	85 c0                	test   %eax,%eax
  8027a2:	74 10                	je     8027b4 <alloc_block_NF+0x9b>
  8027a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a7:	8b 00                	mov    (%eax),%eax
  8027a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ac:	8b 52 04             	mov    0x4(%edx),%edx
  8027af:	89 50 04             	mov    %edx,0x4(%eax)
  8027b2:	eb 0b                	jmp    8027bf <alloc_block_NF+0xa6>
  8027b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ba:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c2:	8b 40 04             	mov    0x4(%eax),%eax
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 0f                	je     8027d8 <alloc_block_NF+0xbf>
  8027c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027cc:	8b 40 04             	mov    0x4(%eax),%eax
  8027cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027d2:	8b 12                	mov    (%edx),%edx
  8027d4:	89 10                	mov    %edx,(%eax)
  8027d6:	eb 0a                	jmp    8027e2 <alloc_block_NF+0xc9>
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8027e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ee:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f5:	a1 44 41 80 00       	mov    0x804144,%eax
  8027fa:	48                   	dec    %eax
  8027fb:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802800:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802803:	e9 0e 01 00 00       	jmp    802916 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802808:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280b:	8b 40 0c             	mov    0xc(%eax),%eax
  80280e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802811:	0f 86 ce 00 00 00    	jbe    8028e5 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802817:	a1 48 41 80 00       	mov    0x804148,%eax
  80281c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80281f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802823:	75 17                	jne    80283c <alloc_block_NF+0x123>
  802825:	83 ec 04             	sub    $0x4,%esp
  802828:	68 af 3b 80 00       	push   $0x803baf
  80282d:	68 e9 00 00 00       	push   $0xe9
  802832:	68 73 3b 80 00       	push   $0x803b73
  802837:	e8 46 da ff ff       	call   800282 <_panic>
  80283c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283f:	8b 00                	mov    (%eax),%eax
  802841:	85 c0                	test   %eax,%eax
  802843:	74 10                	je     802855 <alloc_block_NF+0x13c>
  802845:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802848:	8b 00                	mov    (%eax),%eax
  80284a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80284d:	8b 52 04             	mov    0x4(%edx),%edx
  802850:	89 50 04             	mov    %edx,0x4(%eax)
  802853:	eb 0b                	jmp    802860 <alloc_block_NF+0x147>
  802855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802858:	8b 40 04             	mov    0x4(%eax),%eax
  80285b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802860:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802863:	8b 40 04             	mov    0x4(%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	74 0f                	je     802879 <alloc_block_NF+0x160>
  80286a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286d:	8b 40 04             	mov    0x4(%eax),%eax
  802870:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802873:	8b 12                	mov    (%edx),%edx
  802875:	89 10                	mov    %edx,(%eax)
  802877:	eb 0a                	jmp    802883 <alloc_block_NF+0x16a>
  802879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	a3 48 41 80 00       	mov    %eax,0x804148
  802883:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802886:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80288c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802896:	a1 54 41 80 00       	mov    0x804154,%eax
  80289b:	48                   	dec    %eax
  80289c:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8028a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a7:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8028aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ad:	8b 50 08             	mov    0x8(%eax),%edx
  8028b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b3:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 50 08             	mov    0x8(%eax),%edx
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	01 c2                	add    %eax,%edx
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	8b 40 0c             	mov    0xc(%eax),%eax
  8028cd:	2b 45 08             	sub    0x8(%ebp),%eax
  8028d0:	89 c2                	mov    %eax,%edx
  8028d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d5:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8028d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028db:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8028e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e3:	eb 31                	jmp    802916 <alloc_block_NF+0x1fd>
			 }
		 c++;
  8028e5:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8028e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028eb:	8b 00                	mov    (%eax),%eax
  8028ed:	85 c0                	test   %eax,%eax
  8028ef:	75 0a                	jne    8028fb <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8028f1:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028f9:	eb 08                	jmp    802903 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8028fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802903:	a1 44 41 80 00       	mov    0x804144,%eax
  802908:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80290b:	0f 85 3f fe ff ff    	jne    802750 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802911:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802916:	c9                   	leave  
  802917:	c3                   	ret    

00802918 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802918:	55                   	push   %ebp
  802919:	89 e5                	mov    %esp,%ebp
  80291b:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80291e:	a1 44 41 80 00       	mov    0x804144,%eax
  802923:	85 c0                	test   %eax,%eax
  802925:	75 68                	jne    80298f <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802927:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292b:	75 17                	jne    802944 <insert_sorted_with_merge_freeList+0x2c>
  80292d:	83 ec 04             	sub    $0x4,%esp
  802930:	68 50 3b 80 00       	push   $0x803b50
  802935:	68 0e 01 00 00       	push   $0x10e
  80293a:	68 73 3b 80 00       	push   $0x803b73
  80293f:	e8 3e d9 ff ff       	call   800282 <_panic>
  802944:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	89 10                	mov    %edx,(%eax)
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	85 c0                	test   %eax,%eax
  802956:	74 0d                	je     802965 <insert_sorted_with_merge_freeList+0x4d>
  802958:	a1 38 41 80 00       	mov    0x804138,%eax
  80295d:	8b 55 08             	mov    0x8(%ebp),%edx
  802960:	89 50 04             	mov    %edx,0x4(%eax)
  802963:	eb 08                	jmp    80296d <insert_sorted_with_merge_freeList+0x55>
  802965:	8b 45 08             	mov    0x8(%ebp),%eax
  802968:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	a3 38 41 80 00       	mov    %eax,0x804138
  802975:	8b 45 08             	mov    0x8(%ebp),%eax
  802978:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297f:	a1 44 41 80 00       	mov    0x804144,%eax
  802984:	40                   	inc    %eax
  802985:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  80298a:	e9 8c 06 00 00       	jmp    80301b <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  80298f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802994:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802997:	a1 38 41 80 00       	mov    0x804138,%eax
  80299c:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	8b 50 08             	mov    0x8(%eax),%edx
  8029a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a8:	8b 40 08             	mov    0x8(%eax),%eax
  8029ab:	39 c2                	cmp    %eax,%edx
  8029ad:	0f 86 14 01 00 00    	jbe    802ac7 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8029b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b6:	8b 50 0c             	mov    0xc(%eax),%edx
  8029b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bc:	8b 40 08             	mov    0x8(%eax),%eax
  8029bf:	01 c2                	add    %eax,%edx
  8029c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c4:	8b 40 08             	mov    0x8(%eax),%eax
  8029c7:	39 c2                	cmp    %eax,%edx
  8029c9:	0f 85 90 00 00 00    	jne    802a5f <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	8b 50 0c             	mov    0xc(%eax),%edx
  8029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029db:	01 c2                	add    %eax,%edx
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8029ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029fb:	75 17                	jne    802a14 <insert_sorted_with_merge_freeList+0xfc>
  8029fd:	83 ec 04             	sub    $0x4,%esp
  802a00:	68 50 3b 80 00       	push   $0x803b50
  802a05:	68 1b 01 00 00       	push   $0x11b
  802a0a:	68 73 3b 80 00       	push   $0x803b73
  802a0f:	e8 6e d8 ff ff       	call   800282 <_panic>
  802a14:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1d:	89 10                	mov    %edx,(%eax)
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	8b 00                	mov    (%eax),%eax
  802a24:	85 c0                	test   %eax,%eax
  802a26:	74 0d                	je     802a35 <insert_sorted_with_merge_freeList+0x11d>
  802a28:	a1 48 41 80 00       	mov    0x804148,%eax
  802a2d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a30:	89 50 04             	mov    %edx,0x4(%eax)
  802a33:	eb 08                	jmp    802a3d <insert_sorted_with_merge_freeList+0x125>
  802a35:	8b 45 08             	mov    0x8(%ebp),%eax
  802a38:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	a3 48 41 80 00       	mov    %eax,0x804148
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4f:	a1 54 41 80 00       	mov    0x804154,%eax
  802a54:	40                   	inc    %eax
  802a55:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802a5a:	e9 bc 05 00 00       	jmp    80301b <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a63:	75 17                	jne    802a7c <insert_sorted_with_merge_freeList+0x164>
  802a65:	83 ec 04             	sub    $0x4,%esp
  802a68:	68 8c 3b 80 00       	push   $0x803b8c
  802a6d:	68 1f 01 00 00       	push   $0x11f
  802a72:	68 73 3b 80 00       	push   $0x803b73
  802a77:	e8 06 d8 ff ff       	call   800282 <_panic>
  802a7c:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	89 50 04             	mov    %edx,0x4(%eax)
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	8b 40 04             	mov    0x4(%eax),%eax
  802a8e:	85 c0                	test   %eax,%eax
  802a90:	74 0c                	je     802a9e <insert_sorted_with_merge_freeList+0x186>
  802a92:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a97:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9a:	89 10                	mov    %edx,(%eax)
  802a9c:	eb 08                	jmp    802aa6 <insert_sorted_with_merge_freeList+0x18e>
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	a3 38 41 80 00       	mov    %eax,0x804138
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab7:	a1 44 41 80 00       	mov    0x804144,%eax
  802abc:	40                   	inc    %eax
  802abd:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802ac2:	e9 54 05 00 00       	jmp    80301b <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aca:	8b 50 08             	mov    0x8(%eax),%edx
  802acd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad0:	8b 40 08             	mov    0x8(%eax),%eax
  802ad3:	39 c2                	cmp    %eax,%edx
  802ad5:	0f 83 20 01 00 00    	jae    802bfb <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	8b 50 0c             	mov    0xc(%eax),%edx
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	8b 40 08             	mov    0x8(%eax),%eax
  802ae7:	01 c2                	add    %eax,%edx
  802ae9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aec:	8b 40 08             	mov    0x8(%eax),%eax
  802aef:	39 c2                	cmp    %eax,%edx
  802af1:	0f 85 9c 00 00 00    	jne    802b93 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802af7:	8b 45 08             	mov    0x8(%ebp),%eax
  802afa:	8b 50 08             	mov    0x8(%eax),%edx
  802afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b00:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b06:	8b 50 0c             	mov    0xc(%eax),%edx
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0f:	01 c2                	add    %eax,%edx
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2f:	75 17                	jne    802b48 <insert_sorted_with_merge_freeList+0x230>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 50 3b 80 00       	push   $0x803b50
  802b39:	68 2a 01 00 00       	push   $0x12a
  802b3e:	68 73 3b 80 00       	push   $0x803b73
  802b43:	e8 3a d7 ff ff       	call   800282 <_panic>
  802b48:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	89 10                	mov    %edx,(%eax)
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	74 0d                	je     802b69 <insert_sorted_with_merge_freeList+0x251>
  802b5c:	a1 48 41 80 00       	mov    0x804148,%eax
  802b61:	8b 55 08             	mov    0x8(%ebp),%edx
  802b64:	89 50 04             	mov    %edx,0x4(%eax)
  802b67:	eb 08                	jmp    802b71 <insert_sorted_with_merge_freeList+0x259>
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	a3 48 41 80 00       	mov    %eax,0x804148
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b83:	a1 54 41 80 00       	mov    0x804154,%eax
  802b88:	40                   	inc    %eax
  802b89:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b8e:	e9 88 04 00 00       	jmp    80301b <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b97:	75 17                	jne    802bb0 <insert_sorted_with_merge_freeList+0x298>
  802b99:	83 ec 04             	sub    $0x4,%esp
  802b9c:	68 50 3b 80 00       	push   $0x803b50
  802ba1:	68 2e 01 00 00       	push   $0x12e
  802ba6:	68 73 3b 80 00       	push   $0x803b73
  802bab:	e8 d2 d6 ff ff       	call   800282 <_panic>
  802bb0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	89 10                	mov    %edx,(%eax)
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	8b 00                	mov    (%eax),%eax
  802bc0:	85 c0                	test   %eax,%eax
  802bc2:	74 0d                	je     802bd1 <insert_sorted_with_merge_freeList+0x2b9>
  802bc4:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcc:	89 50 04             	mov    %edx,0x4(%eax)
  802bcf:	eb 08                	jmp    802bd9 <insert_sorted_with_merge_freeList+0x2c1>
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	a3 38 41 80 00       	mov    %eax,0x804138
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802beb:	a1 44 41 80 00       	mov    0x804144,%eax
  802bf0:	40                   	inc    %eax
  802bf1:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bf6:	e9 20 04 00 00       	jmp    80301b <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802bfb:	a1 38 41 80 00       	mov    0x804138,%eax
  802c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c03:	e9 e2 03 00 00       	jmp    802fea <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	8b 50 08             	mov    0x8(%eax),%edx
  802c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c11:	8b 40 08             	mov    0x8(%eax),%eax
  802c14:	39 c2                	cmp    %eax,%edx
  802c16:	0f 83 c6 03 00 00    	jae    802fe2 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 04             	mov    0x4(%eax),%eax
  802c22:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c28:	8b 50 08             	mov    0x8(%eax),%edx
  802c2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c31:	01 d0                	add    %edx,%eax
  802c33:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	8b 50 0c             	mov    0xc(%eax),%edx
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 40 08             	mov    0x8(%eax),%eax
  802c42:	01 d0                	add    %edx,%eax
  802c44:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c50:	74 7a                	je     802ccc <insert_sorted_with_merge_freeList+0x3b4>
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	8b 40 08             	mov    0x8(%eax),%eax
  802c58:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c5b:	74 6f                	je     802ccc <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802c5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c61:	74 06                	je     802c69 <insert_sorted_with_merge_freeList+0x351>
  802c63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c67:	75 17                	jne    802c80 <insert_sorted_with_merge_freeList+0x368>
  802c69:	83 ec 04             	sub    $0x4,%esp
  802c6c:	68 d0 3b 80 00       	push   $0x803bd0
  802c71:	68 43 01 00 00       	push   $0x143
  802c76:	68 73 3b 80 00       	push   $0x803b73
  802c7b:	e8 02 d6 ff ff       	call   800282 <_panic>
  802c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c83:	8b 50 04             	mov    0x4(%eax),%edx
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	89 50 04             	mov    %edx,0x4(%eax)
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c92:	89 10                	mov    %edx,(%eax)
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 04             	mov    0x4(%eax),%eax
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	74 0d                	je     802cab <insert_sorted_with_merge_freeList+0x393>
  802c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca1:	8b 40 04             	mov    0x4(%eax),%eax
  802ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca7:	89 10                	mov    %edx,(%eax)
  802ca9:	eb 08                	jmp    802cb3 <insert_sorted_with_merge_freeList+0x39b>
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	a3 38 41 80 00       	mov    %eax,0x804138
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb9:	89 50 04             	mov    %edx,0x4(%eax)
  802cbc:	a1 44 41 80 00       	mov    0x804144,%eax
  802cc1:	40                   	inc    %eax
  802cc2:	a3 44 41 80 00       	mov    %eax,0x804144
  802cc7:	e9 14 03 00 00       	jmp    802fe0 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	8b 40 08             	mov    0x8(%eax),%eax
  802cd2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cd5:	0f 85 a0 01 00 00    	jne    802e7b <insert_sorted_with_merge_freeList+0x563>
  802cdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cde:	8b 40 08             	mov    0x8(%eax),%eax
  802ce1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ce4:	0f 85 91 01 00 00    	jne    802e7b <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802cea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ced:	8b 50 0c             	mov    0xc(%eax),%edx
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	8b 48 0c             	mov    0xc(%eax),%ecx
  802cf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf9:	8b 40 0c             	mov    0xc(%eax),%eax
  802cfc:	01 c8                	add    %ecx,%eax
  802cfe:	01 c2                	add    %eax,%edx
  802d00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d03:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d06:	8b 45 08             	mov    0x8(%ebp),%eax
  802d09:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d27:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d32:	75 17                	jne    802d4b <insert_sorted_with_merge_freeList+0x433>
  802d34:	83 ec 04             	sub    $0x4,%esp
  802d37:	68 50 3b 80 00       	push   $0x803b50
  802d3c:	68 4d 01 00 00       	push   $0x14d
  802d41:	68 73 3b 80 00       	push   $0x803b73
  802d46:	e8 37 d5 ff ff       	call   800282 <_panic>
  802d4b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	89 10                	mov    %edx,(%eax)
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	85 c0                	test   %eax,%eax
  802d5d:	74 0d                	je     802d6c <insert_sorted_with_merge_freeList+0x454>
  802d5f:	a1 48 41 80 00       	mov    0x804148,%eax
  802d64:	8b 55 08             	mov    0x8(%ebp),%edx
  802d67:	89 50 04             	mov    %edx,0x4(%eax)
  802d6a:	eb 08                	jmp    802d74 <insert_sorted_with_merge_freeList+0x45c>
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d74:	8b 45 08             	mov    0x8(%ebp),%eax
  802d77:	a3 48 41 80 00       	mov    %eax,0x804148
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d86:	a1 54 41 80 00       	mov    0x804154,%eax
  802d8b:	40                   	inc    %eax
  802d8c:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802d91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d95:	75 17                	jne    802dae <insert_sorted_with_merge_freeList+0x496>
  802d97:	83 ec 04             	sub    $0x4,%esp
  802d9a:	68 af 3b 80 00       	push   $0x803baf
  802d9f:	68 4e 01 00 00       	push   $0x14e
  802da4:	68 73 3b 80 00       	push   $0x803b73
  802da9:	e8 d4 d4 ff ff       	call   800282 <_panic>
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	8b 00                	mov    (%eax),%eax
  802db3:	85 c0                	test   %eax,%eax
  802db5:	74 10                	je     802dc7 <insert_sorted_with_merge_freeList+0x4af>
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbf:	8b 52 04             	mov    0x4(%edx),%edx
  802dc2:	89 50 04             	mov    %edx,0x4(%eax)
  802dc5:	eb 0b                	jmp    802dd2 <insert_sorted_with_merge_freeList+0x4ba>
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 04             	mov    0x4(%eax),%eax
  802dcd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd5:	8b 40 04             	mov    0x4(%eax),%eax
  802dd8:	85 c0                	test   %eax,%eax
  802dda:	74 0f                	je     802deb <insert_sorted_with_merge_freeList+0x4d3>
  802ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddf:	8b 40 04             	mov    0x4(%eax),%eax
  802de2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de5:	8b 12                	mov    (%edx),%edx
  802de7:	89 10                	mov    %edx,(%eax)
  802de9:	eb 0a                	jmp    802df5 <insert_sorted_with_merge_freeList+0x4dd>
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	a3 38 41 80 00       	mov    %eax,0x804138
  802df5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e08:	a1 44 41 80 00       	mov    0x804144,%eax
  802e0d:	48                   	dec    %eax
  802e0e:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e17:	75 17                	jne    802e30 <insert_sorted_with_merge_freeList+0x518>
  802e19:	83 ec 04             	sub    $0x4,%esp
  802e1c:	68 50 3b 80 00       	push   $0x803b50
  802e21:	68 4f 01 00 00       	push   $0x14f
  802e26:	68 73 3b 80 00       	push   $0x803b73
  802e2b:	e8 52 d4 ff ff       	call   800282 <_panic>
  802e30:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e39:	89 10                	mov    %edx,(%eax)
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 00                	mov    (%eax),%eax
  802e40:	85 c0                	test   %eax,%eax
  802e42:	74 0d                	je     802e51 <insert_sorted_with_merge_freeList+0x539>
  802e44:	a1 48 41 80 00       	mov    0x804148,%eax
  802e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4c:	89 50 04             	mov    %edx,0x4(%eax)
  802e4f:	eb 08                	jmp    802e59 <insert_sorted_with_merge_freeList+0x541>
  802e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e54:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	a3 48 41 80 00       	mov    %eax,0x804148
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6b:	a1 54 41 80 00       	mov    0x804154,%eax
  802e70:	40                   	inc    %eax
  802e71:	a3 54 41 80 00       	mov    %eax,0x804154
  802e76:	e9 65 01 00 00       	jmp    802fe0 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7e:	8b 40 08             	mov    0x8(%eax),%eax
  802e81:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e84:	0f 85 9f 00 00 00    	jne    802f29 <insert_sorted_with_merge_freeList+0x611>
  802e8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8d:	8b 40 08             	mov    0x8(%eax),%eax
  802e90:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e93:	0f 84 90 00 00 00    	je     802f29 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802e99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea5:	01 c2                	add    %eax,%edx
  802ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaa:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ec1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec5:	75 17                	jne    802ede <insert_sorted_with_merge_freeList+0x5c6>
  802ec7:	83 ec 04             	sub    $0x4,%esp
  802eca:	68 50 3b 80 00       	push   $0x803b50
  802ecf:	68 58 01 00 00       	push   $0x158
  802ed4:	68 73 3b 80 00       	push   $0x803b73
  802ed9:	e8 a4 d3 ff ff       	call   800282 <_panic>
  802ede:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	89 10                	mov    %edx,(%eax)
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	85 c0                	test   %eax,%eax
  802ef0:	74 0d                	je     802eff <insert_sorted_with_merge_freeList+0x5e7>
  802ef2:	a1 48 41 80 00       	mov    0x804148,%eax
  802ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  802efa:	89 50 04             	mov    %edx,0x4(%eax)
  802efd:	eb 08                	jmp    802f07 <insert_sorted_with_merge_freeList+0x5ef>
  802eff:	8b 45 08             	mov    0x8(%ebp),%eax
  802f02:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	a3 48 41 80 00       	mov    %eax,0x804148
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f19:	a1 54 41 80 00       	mov    0x804154,%eax
  802f1e:	40                   	inc    %eax
  802f1f:	a3 54 41 80 00       	mov    %eax,0x804154
  802f24:	e9 b7 00 00 00       	jmp    802fe0 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	8b 40 08             	mov    0x8(%eax),%eax
  802f2f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f32:	0f 84 e2 00 00 00    	je     80301a <insert_sorted_with_merge_freeList+0x702>
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 40 08             	mov    0x8(%eax),%eax
  802f3e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f41:	0f 85 d3 00 00 00    	jne    80301a <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f47:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4a:	8b 50 08             	mov    0x8(%eax),%edx
  802f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f50:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 50 0c             	mov    0xc(%eax),%edx
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5f:	01 c2                	add    %eax,%edx
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f71:	8b 45 08             	mov    0x8(%ebp),%eax
  802f74:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7f:	75 17                	jne    802f98 <insert_sorted_with_merge_freeList+0x680>
  802f81:	83 ec 04             	sub    $0x4,%esp
  802f84:	68 50 3b 80 00       	push   $0x803b50
  802f89:	68 61 01 00 00       	push   $0x161
  802f8e:	68 73 3b 80 00       	push   $0x803b73
  802f93:	e8 ea d2 ff ff       	call   800282 <_panic>
  802f98:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa1:	89 10                	mov    %edx,(%eax)
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	85 c0                	test   %eax,%eax
  802faa:	74 0d                	je     802fb9 <insert_sorted_with_merge_freeList+0x6a1>
  802fac:	a1 48 41 80 00       	mov    0x804148,%eax
  802fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb4:	89 50 04             	mov    %edx,0x4(%eax)
  802fb7:	eb 08                	jmp    802fc1 <insert_sorted_with_merge_freeList+0x6a9>
  802fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc4:	a3 48 41 80 00       	mov    %eax,0x804148
  802fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd3:	a1 54 41 80 00       	mov    0x804154,%eax
  802fd8:	40                   	inc    %eax
  802fd9:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802fde:	eb 3a                	jmp    80301a <insert_sorted_with_merge_freeList+0x702>
  802fe0:	eb 38                	jmp    80301a <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802fe2:	a1 40 41 80 00       	mov    0x804140,%eax
  802fe7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fee:	74 07                	je     802ff7 <insert_sorted_with_merge_freeList+0x6df>
  802ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff3:	8b 00                	mov    (%eax),%eax
  802ff5:	eb 05                	jmp    802ffc <insert_sorted_with_merge_freeList+0x6e4>
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  802ffc:	a3 40 41 80 00       	mov    %eax,0x804140
  803001:	a1 40 41 80 00       	mov    0x804140,%eax
  803006:	85 c0                	test   %eax,%eax
  803008:	0f 85 fa fb ff ff    	jne    802c08 <insert_sorted_with_merge_freeList+0x2f0>
  80300e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803012:	0f 85 f0 fb ff ff    	jne    802c08 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803018:	eb 01                	jmp    80301b <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80301a:	90                   	nop
							}

						}
		          }
		}
}
  80301b:	90                   	nop
  80301c:	c9                   	leave  
  80301d:	c3                   	ret    
  80301e:	66 90                	xchg   %ax,%ax

00803020 <__udivdi3>:
  803020:	55                   	push   %ebp
  803021:	57                   	push   %edi
  803022:	56                   	push   %esi
  803023:	53                   	push   %ebx
  803024:	83 ec 1c             	sub    $0x1c,%esp
  803027:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80302b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80302f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803033:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803037:	89 ca                	mov    %ecx,%edx
  803039:	89 f8                	mov    %edi,%eax
  80303b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80303f:	85 f6                	test   %esi,%esi
  803041:	75 2d                	jne    803070 <__udivdi3+0x50>
  803043:	39 cf                	cmp    %ecx,%edi
  803045:	77 65                	ja     8030ac <__udivdi3+0x8c>
  803047:	89 fd                	mov    %edi,%ebp
  803049:	85 ff                	test   %edi,%edi
  80304b:	75 0b                	jne    803058 <__udivdi3+0x38>
  80304d:	b8 01 00 00 00       	mov    $0x1,%eax
  803052:	31 d2                	xor    %edx,%edx
  803054:	f7 f7                	div    %edi
  803056:	89 c5                	mov    %eax,%ebp
  803058:	31 d2                	xor    %edx,%edx
  80305a:	89 c8                	mov    %ecx,%eax
  80305c:	f7 f5                	div    %ebp
  80305e:	89 c1                	mov    %eax,%ecx
  803060:	89 d8                	mov    %ebx,%eax
  803062:	f7 f5                	div    %ebp
  803064:	89 cf                	mov    %ecx,%edi
  803066:	89 fa                	mov    %edi,%edx
  803068:	83 c4 1c             	add    $0x1c,%esp
  80306b:	5b                   	pop    %ebx
  80306c:	5e                   	pop    %esi
  80306d:	5f                   	pop    %edi
  80306e:	5d                   	pop    %ebp
  80306f:	c3                   	ret    
  803070:	39 ce                	cmp    %ecx,%esi
  803072:	77 28                	ja     80309c <__udivdi3+0x7c>
  803074:	0f bd fe             	bsr    %esi,%edi
  803077:	83 f7 1f             	xor    $0x1f,%edi
  80307a:	75 40                	jne    8030bc <__udivdi3+0x9c>
  80307c:	39 ce                	cmp    %ecx,%esi
  80307e:	72 0a                	jb     80308a <__udivdi3+0x6a>
  803080:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803084:	0f 87 9e 00 00 00    	ja     803128 <__udivdi3+0x108>
  80308a:	b8 01 00 00 00       	mov    $0x1,%eax
  80308f:	89 fa                	mov    %edi,%edx
  803091:	83 c4 1c             	add    $0x1c,%esp
  803094:	5b                   	pop    %ebx
  803095:	5e                   	pop    %esi
  803096:	5f                   	pop    %edi
  803097:	5d                   	pop    %ebp
  803098:	c3                   	ret    
  803099:	8d 76 00             	lea    0x0(%esi),%esi
  80309c:	31 ff                	xor    %edi,%edi
  80309e:	31 c0                	xor    %eax,%eax
  8030a0:	89 fa                	mov    %edi,%edx
  8030a2:	83 c4 1c             	add    $0x1c,%esp
  8030a5:	5b                   	pop    %ebx
  8030a6:	5e                   	pop    %esi
  8030a7:	5f                   	pop    %edi
  8030a8:	5d                   	pop    %ebp
  8030a9:	c3                   	ret    
  8030aa:	66 90                	xchg   %ax,%ax
  8030ac:	89 d8                	mov    %ebx,%eax
  8030ae:	f7 f7                	div    %edi
  8030b0:	31 ff                	xor    %edi,%edi
  8030b2:	89 fa                	mov    %edi,%edx
  8030b4:	83 c4 1c             	add    $0x1c,%esp
  8030b7:	5b                   	pop    %ebx
  8030b8:	5e                   	pop    %esi
  8030b9:	5f                   	pop    %edi
  8030ba:	5d                   	pop    %ebp
  8030bb:	c3                   	ret    
  8030bc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030c1:	89 eb                	mov    %ebp,%ebx
  8030c3:	29 fb                	sub    %edi,%ebx
  8030c5:	89 f9                	mov    %edi,%ecx
  8030c7:	d3 e6                	shl    %cl,%esi
  8030c9:	89 c5                	mov    %eax,%ebp
  8030cb:	88 d9                	mov    %bl,%cl
  8030cd:	d3 ed                	shr    %cl,%ebp
  8030cf:	89 e9                	mov    %ebp,%ecx
  8030d1:	09 f1                	or     %esi,%ecx
  8030d3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030d7:	89 f9                	mov    %edi,%ecx
  8030d9:	d3 e0                	shl    %cl,%eax
  8030db:	89 c5                	mov    %eax,%ebp
  8030dd:	89 d6                	mov    %edx,%esi
  8030df:	88 d9                	mov    %bl,%cl
  8030e1:	d3 ee                	shr    %cl,%esi
  8030e3:	89 f9                	mov    %edi,%ecx
  8030e5:	d3 e2                	shl    %cl,%edx
  8030e7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030eb:	88 d9                	mov    %bl,%cl
  8030ed:	d3 e8                	shr    %cl,%eax
  8030ef:	09 c2                	or     %eax,%edx
  8030f1:	89 d0                	mov    %edx,%eax
  8030f3:	89 f2                	mov    %esi,%edx
  8030f5:	f7 74 24 0c          	divl   0xc(%esp)
  8030f9:	89 d6                	mov    %edx,%esi
  8030fb:	89 c3                	mov    %eax,%ebx
  8030fd:	f7 e5                	mul    %ebp
  8030ff:	39 d6                	cmp    %edx,%esi
  803101:	72 19                	jb     80311c <__udivdi3+0xfc>
  803103:	74 0b                	je     803110 <__udivdi3+0xf0>
  803105:	89 d8                	mov    %ebx,%eax
  803107:	31 ff                	xor    %edi,%edi
  803109:	e9 58 ff ff ff       	jmp    803066 <__udivdi3+0x46>
  80310e:	66 90                	xchg   %ax,%ax
  803110:	8b 54 24 08          	mov    0x8(%esp),%edx
  803114:	89 f9                	mov    %edi,%ecx
  803116:	d3 e2                	shl    %cl,%edx
  803118:	39 c2                	cmp    %eax,%edx
  80311a:	73 e9                	jae    803105 <__udivdi3+0xe5>
  80311c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80311f:	31 ff                	xor    %edi,%edi
  803121:	e9 40 ff ff ff       	jmp    803066 <__udivdi3+0x46>
  803126:	66 90                	xchg   %ax,%ax
  803128:	31 c0                	xor    %eax,%eax
  80312a:	e9 37 ff ff ff       	jmp    803066 <__udivdi3+0x46>
  80312f:	90                   	nop

00803130 <__umoddi3>:
  803130:	55                   	push   %ebp
  803131:	57                   	push   %edi
  803132:	56                   	push   %esi
  803133:	53                   	push   %ebx
  803134:	83 ec 1c             	sub    $0x1c,%esp
  803137:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80313b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80313f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803143:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803147:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80314b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80314f:	89 f3                	mov    %esi,%ebx
  803151:	89 fa                	mov    %edi,%edx
  803153:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803157:	89 34 24             	mov    %esi,(%esp)
  80315a:	85 c0                	test   %eax,%eax
  80315c:	75 1a                	jne    803178 <__umoddi3+0x48>
  80315e:	39 f7                	cmp    %esi,%edi
  803160:	0f 86 a2 00 00 00    	jbe    803208 <__umoddi3+0xd8>
  803166:	89 c8                	mov    %ecx,%eax
  803168:	89 f2                	mov    %esi,%edx
  80316a:	f7 f7                	div    %edi
  80316c:	89 d0                	mov    %edx,%eax
  80316e:	31 d2                	xor    %edx,%edx
  803170:	83 c4 1c             	add    $0x1c,%esp
  803173:	5b                   	pop    %ebx
  803174:	5e                   	pop    %esi
  803175:	5f                   	pop    %edi
  803176:	5d                   	pop    %ebp
  803177:	c3                   	ret    
  803178:	39 f0                	cmp    %esi,%eax
  80317a:	0f 87 ac 00 00 00    	ja     80322c <__umoddi3+0xfc>
  803180:	0f bd e8             	bsr    %eax,%ebp
  803183:	83 f5 1f             	xor    $0x1f,%ebp
  803186:	0f 84 ac 00 00 00    	je     803238 <__umoddi3+0x108>
  80318c:	bf 20 00 00 00       	mov    $0x20,%edi
  803191:	29 ef                	sub    %ebp,%edi
  803193:	89 fe                	mov    %edi,%esi
  803195:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803199:	89 e9                	mov    %ebp,%ecx
  80319b:	d3 e0                	shl    %cl,%eax
  80319d:	89 d7                	mov    %edx,%edi
  80319f:	89 f1                	mov    %esi,%ecx
  8031a1:	d3 ef                	shr    %cl,%edi
  8031a3:	09 c7                	or     %eax,%edi
  8031a5:	89 e9                	mov    %ebp,%ecx
  8031a7:	d3 e2                	shl    %cl,%edx
  8031a9:	89 14 24             	mov    %edx,(%esp)
  8031ac:	89 d8                	mov    %ebx,%eax
  8031ae:	d3 e0                	shl    %cl,%eax
  8031b0:	89 c2                	mov    %eax,%edx
  8031b2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031b6:	d3 e0                	shl    %cl,%eax
  8031b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031bc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031c0:	89 f1                	mov    %esi,%ecx
  8031c2:	d3 e8                	shr    %cl,%eax
  8031c4:	09 d0                	or     %edx,%eax
  8031c6:	d3 eb                	shr    %cl,%ebx
  8031c8:	89 da                	mov    %ebx,%edx
  8031ca:	f7 f7                	div    %edi
  8031cc:	89 d3                	mov    %edx,%ebx
  8031ce:	f7 24 24             	mull   (%esp)
  8031d1:	89 c6                	mov    %eax,%esi
  8031d3:	89 d1                	mov    %edx,%ecx
  8031d5:	39 d3                	cmp    %edx,%ebx
  8031d7:	0f 82 87 00 00 00    	jb     803264 <__umoddi3+0x134>
  8031dd:	0f 84 91 00 00 00    	je     803274 <__umoddi3+0x144>
  8031e3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031e7:	29 f2                	sub    %esi,%edx
  8031e9:	19 cb                	sbb    %ecx,%ebx
  8031eb:	89 d8                	mov    %ebx,%eax
  8031ed:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031f1:	d3 e0                	shl    %cl,%eax
  8031f3:	89 e9                	mov    %ebp,%ecx
  8031f5:	d3 ea                	shr    %cl,%edx
  8031f7:	09 d0                	or     %edx,%eax
  8031f9:	89 e9                	mov    %ebp,%ecx
  8031fb:	d3 eb                	shr    %cl,%ebx
  8031fd:	89 da                	mov    %ebx,%edx
  8031ff:	83 c4 1c             	add    $0x1c,%esp
  803202:	5b                   	pop    %ebx
  803203:	5e                   	pop    %esi
  803204:	5f                   	pop    %edi
  803205:	5d                   	pop    %ebp
  803206:	c3                   	ret    
  803207:	90                   	nop
  803208:	89 fd                	mov    %edi,%ebp
  80320a:	85 ff                	test   %edi,%edi
  80320c:	75 0b                	jne    803219 <__umoddi3+0xe9>
  80320e:	b8 01 00 00 00       	mov    $0x1,%eax
  803213:	31 d2                	xor    %edx,%edx
  803215:	f7 f7                	div    %edi
  803217:	89 c5                	mov    %eax,%ebp
  803219:	89 f0                	mov    %esi,%eax
  80321b:	31 d2                	xor    %edx,%edx
  80321d:	f7 f5                	div    %ebp
  80321f:	89 c8                	mov    %ecx,%eax
  803221:	f7 f5                	div    %ebp
  803223:	89 d0                	mov    %edx,%eax
  803225:	e9 44 ff ff ff       	jmp    80316e <__umoddi3+0x3e>
  80322a:	66 90                	xchg   %ax,%ax
  80322c:	89 c8                	mov    %ecx,%eax
  80322e:	89 f2                	mov    %esi,%edx
  803230:	83 c4 1c             	add    $0x1c,%esp
  803233:	5b                   	pop    %ebx
  803234:	5e                   	pop    %esi
  803235:	5f                   	pop    %edi
  803236:	5d                   	pop    %ebp
  803237:	c3                   	ret    
  803238:	3b 04 24             	cmp    (%esp),%eax
  80323b:	72 06                	jb     803243 <__umoddi3+0x113>
  80323d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803241:	77 0f                	ja     803252 <__umoddi3+0x122>
  803243:	89 f2                	mov    %esi,%edx
  803245:	29 f9                	sub    %edi,%ecx
  803247:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80324b:	89 14 24             	mov    %edx,(%esp)
  80324e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803252:	8b 44 24 04          	mov    0x4(%esp),%eax
  803256:	8b 14 24             	mov    (%esp),%edx
  803259:	83 c4 1c             	add    $0x1c,%esp
  80325c:	5b                   	pop    %ebx
  80325d:	5e                   	pop    %esi
  80325e:	5f                   	pop    %edi
  80325f:	5d                   	pop    %ebp
  803260:	c3                   	ret    
  803261:	8d 76 00             	lea    0x0(%esi),%esi
  803264:	2b 04 24             	sub    (%esp),%eax
  803267:	19 fa                	sbb    %edi,%edx
  803269:	89 d1                	mov    %edx,%ecx
  80326b:	89 c6                	mov    %eax,%esi
  80326d:	e9 71 ff ff ff       	jmp    8031e3 <__umoddi3+0xb3>
  803272:	66 90                	xchg   %ax,%ax
  803274:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803278:	72 ea                	jb     803264 <__umoddi3+0x134>
  80327a:	89 d9                	mov    %ebx,%ecx
  80327c:	e9 62 ff ff ff       	jmp    8031e3 <__umoddi3+0xb3>

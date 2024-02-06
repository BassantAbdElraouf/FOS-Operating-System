
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
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
	// Testing scenario 4: Freeing the allocated semaphores
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 80 32 80 00       	push   $0x803280
  80004a:	e8 67 15 00 00       	call   8015b6 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 6c 18 00 00       	call   8018cf <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 04 19 00 00       	call   80196f <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 90 32 80 00       	push   $0x803290
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 c3 32 80 00       	push   $0x8032c3
  800096:	e8 a6 1a 00 00       	call   801b41 <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 b3 1a 00 00       	call   801b5f <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 10 18 00 00       	call   8018cf <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 cc 32 80 00       	push   $0x8032cc
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 a0 1a 00 00       	call   801b7b <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 ec 17 00 00       	call   8018cf <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 84 18 00 00       	call   80196f <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 00 33 80 00       	push   $0x803300
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 50 33 80 00       	push   $0x803350
  800111:	6a 1f                	push   $0x1f
  800113:	68 86 33 80 00       	push   $0x803386
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 9c 33 80 00       	push   $0x80339c
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 fc 33 80 00       	push   $0x8033fc
  800138:	e8 f6 03 00 00       	call   800533 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 61 1a 00 00       	call   801baf <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	01 c0                	add    %eax,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 04             	shl    $0x4,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 20 40 80 00       	mov    0x804020,%eax
  80017a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0f                	je     800193 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	05 5c 05 00 00       	add    $0x55c,%eax
  80018e:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800197:	7e 0a                	jle    8001a3 <libmain+0x60>
		binaryname = argv[0];
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 87 fe ff ff       	call   800038 <_main>
  8001b1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b4:	e8 03 18 00 00       	call   8019bc <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 60 34 80 00       	push   $0x803460
  8001c1:	e8 6d 03 00 00       	call   800533 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	68 88 34 80 00       	push   $0x803488
  8001e9:	e8 45 03 00 00       	call   800533 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800212:	51                   	push   %ecx
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 b0 34 80 00       	push   $0x8034b0
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 08 35 80 00       	push   $0x803508
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 60 34 80 00       	push   $0x803460
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 83 17 00 00       	call   8019d6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800253:	e8 19 00 00 00       	call   800271 <exit>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	6a 00                	push   $0x0
  800266:	e8 10 19 00 00       	call   801b7b <sys_destroy_env>
  80026b:	83 c4 10             	add    $0x10,%esp
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <exit>:

void
exit(void)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800277:	e8 65 19 00 00       	call   801be1 <sys_exit_env>
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800285:	8d 45 10             	lea    0x10(%ebp),%eax
  800288:	83 c0 04             	add    $0x4,%eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	74 16                	je     8002ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800297:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 1c 35 80 00       	push   $0x80351c
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 21 35 80 00       	push   $0x803521
  8002be:	e8 70 02 00 00       	call   800533 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	e8 f3 01 00 00       	call   8004c8 <vcprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	6a 00                	push   $0x0
  8002dd:	68 3d 35 80 00       	push   $0x80353d
  8002e2:	e8 e1 01 00 00       	call   8004c8 <vcprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ea:	e8 82 ff ff ff       	call   800271 <exit>

	// should not return here
	while (1) ;
  8002ef:	eb fe                	jmp    8002ef <_panic+0x70>

008002f1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fc:	8b 50 74             	mov    0x74(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 40 35 80 00       	push   $0x803540
  80030e:	6a 26                	push   $0x26
  800310:	68 8c 35 80 00       	push   $0x80358c
  800315:	e8 65 ff ff ff       	call   80027f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	e9 c2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 08                	jne    80034a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800342:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800345:	e9 a2 00 00 00       	jmp    8003ec <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800358:	eb 69                	jmp    8003c3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035a:	a1 20 40 80 00       	mov    0x804020,%eax
  80035f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	c1 e0 03             	shl    $0x3,%eax
  800371:	01 c8                	add    %ecx,%eax
  800373:	8a 40 04             	mov    0x4(%eax),%al
  800376:	84 c0                	test   %al,%al
  800378:	75 46                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037a:	a1 20 40 80 00       	mov    0x804020,%eax
  80037f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	c1 e0 03             	shl    $0x3,%eax
  800391:	01 c8                	add    %ecx,%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	75 09                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003be:	eb 12                	jmp    8003d2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e8             	incl   -0x18(%ebp)
  8003c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c8:	8b 50 74             	mov    0x74(%eax),%edx
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	77 88                	ja     80035a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d6:	75 14                	jne    8003ec <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 98 35 80 00       	push   $0x803598
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 8c 35 80 00       	push   $0x80358c
  8003e7:	e8 93 fe ff ff       	call   80027f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ec:	ff 45 f0             	incl   -0x10(%ebp)
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f5:	0f 8c 32 ff ff ff    	jl     80032d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	eb 26                	jmp    800431 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800416:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	01 c0                	add    %eax,%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c1 e0 03             	shl    $0x3,%eax
  800422:	01 c8                	add    %ecx,%eax
  800424:	8a 40 04             	mov    0x4(%eax),%al
  800427:	3c 01                	cmp    $0x1,%al
  800429:	75 03                	jne    80042e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042e:	ff 45 e0             	incl   -0x20(%ebp)
  800431:	a1 20 40 80 00       	mov    0x804020,%eax
  800436:	8b 50 74             	mov    0x74(%eax),%edx
  800439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043c:	39 c2                	cmp    %eax,%edx
  80043e:	77 cb                	ja     80040b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800443:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800446:	74 14                	je     80045c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	68 ec 35 80 00       	push   $0x8035ec
  800450:	6a 44                	push   $0x44
  800452:	68 8c 35 80 00       	push   $0x80358c
  800457:	e8 23 fe ff ff       	call   80027f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045c:	90                   	nop
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 48 01             	lea    0x1(%eax),%ecx
  80046d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800470:	89 0a                	mov    %ecx,(%edx)
  800472:	8b 55 08             	mov    0x8(%ebp),%edx
  800475:	88 d1                	mov    %dl,%cl
  800477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	3d ff 00 00 00       	cmp    $0xff,%eax
  800488:	75 2c                	jne    8004b6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048a:	a0 24 40 80 00       	mov    0x804024,%al
  80048f:	0f b6 c0             	movzbl %al,%eax
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	8b 12                	mov    (%edx),%edx
  800497:	89 d1                	mov    %edx,%ecx
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	83 c2 08             	add    $0x8,%edx
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	50                   	push   %eax
  8004a3:	51                   	push   %ecx
  8004a4:	52                   	push   %edx
  8004a5:	e8 64 13 00 00       	call   80180e <sys_cputs>
  8004aa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	8b 40 04             	mov    0x4(%eax),%eax
  8004bc:	8d 50 01             	lea    0x1(%eax),%edx
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d8:	00 00 00 
	b.cnt = 0;
  8004db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	ff 75 08             	pushl  0x8(%ebp)
  8004eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	68 5f 04 80 00       	push   $0x80045f
  8004f7:	e8 11 02 00 00       	call   80070d <vprintfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ff:	a0 24 40 80 00       	mov    0x804024,%al
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	50                   	push   %eax
  800511:	52                   	push   %edx
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	83 c0 08             	add    $0x8,%eax
  80051b:	50                   	push   %eax
  80051c:	e8 ed 12 00 00       	call   80180e <sys_cputs>
  800521:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800524:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <cprintf>:

int cprintf(const char *fmt, ...) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800539:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800540:	8d 45 0c             	lea    0xc(%ebp),%eax
  800543:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 f4             	pushl  -0xc(%ebp)
  80054f:	50                   	push   %eax
  800550:	e8 73 ff ff ff       	call   8004c8 <vcprintf>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800566:	e8 51 14 00 00       	call   8019bc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 48 ff ff ff       	call   8004c8 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800586:	e8 4b 14 00 00       	call   8019d6 <sys_enable_interrupt>
	return cnt;
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	53                   	push   %ebx
  800594:	83 ec 14             	sub    $0x14,%esp
  800597:	8b 45 10             	mov    0x10(%ebp),%eax
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ae:	77 55                	ja     800605 <printnum+0x75>
  8005b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b3:	72 05                	jb     8005ba <printnum+0x2a>
  8005b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b8:	77 4b                	ja     800605 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d0:	e8 47 2a 00 00       	call   80301c <__udivdi3>
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	ff 75 20             	pushl  0x20(%ebp)
  8005de:	53                   	push   %ebx
  8005df:	ff 75 18             	pushl  0x18(%ebp)
  8005e2:	52                   	push   %edx
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	e8 a1 ff ff ff       	call   800590 <printnum>
  8005ef:	83 c4 20             	add    $0x20,%esp
  8005f2:	eb 1a                	jmp    80060e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	ff 75 20             	pushl  0x20(%ebp)
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	ff d0                	call   *%eax
  800602:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800605:	ff 4d 1c             	decl   0x1c(%ebp)
  800608:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060c:	7f e6                	jg     8005f4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800611:	bb 00 00 00 00       	mov    $0x0,%ebx
  800616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061c:	53                   	push   %ebx
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	e8 07 2b 00 00       	call   80312c <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 54 38 80 00       	add    $0x803854,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	0f be c0             	movsbl %al,%eax
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	50                   	push   %eax
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	ff d0                	call   *%eax
  80063e:	83 c4 10             	add    $0x10,%esp
}
  800641:	90                   	nop
  800642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064e:	7e 1c                	jle    80066c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	8d 50 08             	lea    0x8(%eax),%edx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 10                	mov    %edx,(%eax)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 e8 08             	sub    $0x8,%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	eb 40                	jmp    8006ac <getuint+0x65>
	else if (lflag)
  80066c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800670:	74 1e                	je     800690 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 1c                	jmp    8006ac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	8d 50 04             	lea    0x4(%eax),%edx
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	89 10                	mov    %edx,(%eax)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b5:	7e 1c                	jle    8006d3 <getint+0x25>
		return va_arg(*ap, long long);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	8d 50 08             	lea    0x8(%eax),%edx
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	89 10                	mov    %edx,(%eax)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	83 e8 08             	sub    $0x8,%eax
  8006cc:	8b 50 04             	mov    0x4(%eax),%edx
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	eb 38                	jmp    80070b <getint+0x5d>
	else if (lflag)
  8006d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d7:	74 1a                	je     8006f3 <getint+0x45>
		return va_arg(*ap, long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	eb 18                	jmp    80070b <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	99                   	cltd   
}
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	eb 17                	jmp    80072e <vprintfmt+0x21>
			if (ch == '\0')
  800717:	85 db                	test   %ebx,%ebx
  800719:	0f 84 af 03 00 00    	je     800ace <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	83 fb 25             	cmp    $0x25,%ebx
  80073f:	75 d6                	jne    800717 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800741:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800745:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800753:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800772:	83 f8 55             	cmp    $0x55,%eax
  800775:	0f 87 2b 03 00 00    	ja     800aa6 <vprintfmt+0x399>
  80077b:	8b 04 85 78 38 80 00 	mov    0x803878(,%eax,4),%eax
  800782:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800784:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800788:	eb d7                	jmp    800761 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078e:	eb d1                	jmp    800761 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079a:	89 d0                	mov    %edx,%eax
  80079c:	c1 e0 02             	shl    $0x2,%eax
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	01 c0                	add    %eax,%eax
  8007a3:	01 d8                	add    %ebx,%eax
  8007a5:	83 e8 30             	sub    $0x30,%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b6:	7e 3e                	jle    8007f6 <vprintfmt+0xe9>
  8007b8:	83 fb 39             	cmp    $0x39,%ebx
  8007bb:	7f 39                	jg     8007f6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c0:	eb d5                	jmp    800797 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dc:	79 83                	jns    800761 <vprintfmt+0x54>
				width = 0;
  8007de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e5:	e9 77 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f1:	e9 6b ff ff ff       	jmp    800761 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	0f 89 60 ff ff ff    	jns    800761 <vprintfmt+0x54>
				width = precision, precision = -1;
  800801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800807:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080e:	e9 4e ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800813:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800816:	e9 46 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			break;
  80083b:	e9 89 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 c0 04             	add    $0x4,%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 e8 04             	sub    $0x4,%eax
  80084f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800851:	85 db                	test   %ebx,%ebx
  800853:	79 02                	jns    800857 <vprintfmt+0x14a>
				err = -err;
  800855:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800857:	83 fb 64             	cmp    $0x64,%ebx
  80085a:	7f 0b                	jg     800867 <vprintfmt+0x15a>
  80085c:	8b 34 9d c0 36 80 00 	mov    0x8036c0(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 65 38 80 00       	push   $0x803865
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 5e 02 00 00       	call   800ad6 <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087b:	e9 49 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800880:	56                   	push   %esi
  800881:	68 6e 38 80 00       	push   $0x80386e
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	e8 45 02 00 00       	call   800ad6 <printfmt>
  800891:	83 c4 10             	add    $0x10,%esp
			break;
  800894:	e9 30 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 30                	mov    (%eax),%esi
  8008aa:	85 f6                	test   %esi,%esi
  8008ac:	75 05                	jne    8008b3 <vprintfmt+0x1a6>
				p = "(null)";
  8008ae:	be 71 38 80 00       	mov    $0x803871,%esi
			if (width > 0 && padc != '-')
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	7e 6d                	jle    800926 <vprintfmt+0x219>
  8008b9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bd:	74 67                	je     800926 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	56                   	push   %esi
  8008c7:	e8 0c 03 00 00       	call   800bd8 <strnlen>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d2:	eb 16                	jmp    8008ea <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7f e4                	jg     8008d4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	eb 34                	jmp    800926 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f6:	74 1c                	je     800914 <vprintfmt+0x207>
  8008f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fb:	7e 05                	jle    800902 <vprintfmt+0x1f5>
  8008fd:	83 fb 7e             	cmp    $0x7e,%ebx
  800900:	7e 12                	jle    800914 <vprintfmt+0x207>
					putch('?', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 3f                	push   $0x3f
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	eb 0f                	jmp    800923 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	ff 4d e4             	decl   -0x1c(%ebp)
  800926:	89 f0                	mov    %esi,%eax
  800928:	8d 70 01             	lea    0x1(%eax),%esi
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
  800930:	85 db                	test   %ebx,%ebx
  800932:	74 24                	je     800958 <vprintfmt+0x24b>
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	78 b8                	js     8008f2 <vprintfmt+0x1e5>
  80093a:	ff 4d e0             	decl   -0x20(%ebp)
  80093d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800941:	79 af                	jns    8008f2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800943:	eb 13                	jmp    800958 <vprintfmt+0x24b>
				putch(' ', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 20                	push   $0x20
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800955:	ff 4d e4             	decl   -0x1c(%ebp)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	7f e7                	jg     800945 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095e:	e9 66 01 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 e8             	pushl  -0x18(%ebp)
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	50                   	push   %eax
  80096d:	e8 3c fd ff ff       	call   8006ae <getint>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800978:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800981:	85 d2                	test   %edx,%edx
  800983:	79 23                	jns    8009a8 <vprintfmt+0x29b>
				putch('-', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 2d                	push   $0x2d
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099b:	f7 d8                	neg    %eax
  80099d:	83 d2 00             	adc    $0x0,%edx
  8009a0:	f7 da                	neg    %edx
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 bc 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 84 fc ff ff       	call   800647 <getuint>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d3:	e9 98 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			break;
  800a08:	e9 bc 00 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 30                	push   $0x30
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 78                	push   $0x78
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4f:	eb 1f                	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 e8             	pushl  -0x18(%ebp)
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 e7 fb ff ff       	call   800647 <getuint>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a70:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	52                   	push   %edx
  800a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a82:	ff 75 f0             	pushl  -0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 00 fb ff ff       	call   800590 <printnum>
  800a90:	83 c4 20             	add    $0x20,%esp
			break;
  800a93:	eb 34                	jmp    800ac9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	eb 23                	jmp    800ac9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 25                	push   $0x25
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab6:	ff 4d 10             	decl   0x10(%ebp)
  800ab9:	eb 03                	jmp    800abe <vprintfmt+0x3b1>
  800abb:	ff 4d 10             	decl   0x10(%ebp)
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	48                   	dec    %eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	3c 25                	cmp    $0x25,%al
  800ac6:	75 f3                	jne    800abb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac8:	90                   	nop
		}
	}
  800ac9:	e9 47 fc ff ff       	jmp    800715 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ace:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adc:	8d 45 10             	lea    0x10(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 16 fc ff ff       	call   80070d <vprintfmt>
  800af7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afa:	90                   	nop
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 40 08             	mov    0x8(%eax),%eax
  800b06:	8d 50 01             	lea    0x1(%eax),%edx
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8b 10                	mov    (%eax),%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	8b 40 04             	mov    0x4(%eax),%eax
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	73 12                	jae    800b30 <sprintputch+0x33>
		*b->buf++ = ch;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	8d 48 01             	lea    0x1(%eax),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 0a                	mov    %ecx,(%edx)
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	88 10                	mov    %dl,(%eax)
}
  800b30:	90                   	nop
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b58:	74 06                	je     800b60 <vsnprintf+0x2d>
  800b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5e:	7f 07                	jg     800b67 <vsnprintf+0x34>
		return -E_INVAL;
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	eb 20                	jmp    800b87 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b67:	ff 75 14             	pushl  0x14(%ebp)
  800b6a:	ff 75 10             	pushl  0x10(%ebp)
  800b6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b70:	50                   	push   %eax
  800b71:	68 fd 0a 80 00       	push   $0x800afd
  800b76:	e8 92 fb ff ff       	call   80070d <vprintfmt>
  800b7b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b92:	83 c0 04             	add    $0x4,%eax
  800b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	ff 75 08             	pushl  0x8(%ebp)
  800ba5:	e8 89 ff ff ff       	call   800b33 <vsnprintf>
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc2:	eb 06                	jmp    800bca <strlen+0x15>
		n++;
  800bc4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc7:	ff 45 08             	incl   0x8(%ebp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	75 f1                	jne    800bc4 <strlen+0xf>
		n++;
	return n;
  800bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be5:	eb 09                	jmp    800bf0 <strnlen+0x18>
		n++;
  800be7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	ff 4d 0c             	decl   0xc(%ebp)
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	74 09                	je     800bff <strnlen+0x27>
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 e8                	jne    800be7 <strnlen+0xf>
		n++;
	return n;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c10:	90                   	nop
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8d 50 01             	lea    0x1(%eax),%edx
  800c17:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c23:	8a 12                	mov    (%edx),%dl
  800c25:	88 10                	mov    %dl,(%eax)
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	75 e4                	jne    800c11 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c45:	eb 1f                	jmp    800c66 <strncpy+0x34>
		*dst++ = *src;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8d 50 01             	lea    0x1(%eax),%edx
  800c4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c53:	8a 12                	mov    (%edx),%dl
  800c55:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 03                	je     800c63 <strncpy+0x31>
			src++;
  800c60:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c69:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6c:	72 d9                	jb     800c47 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c83:	74 30                	je     800cb5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c85:	eb 16                	jmp    800c9d <strlcpy+0x2a>
			*dst++ = *src++;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c99:	8a 12                	mov    (%edx),%dl
  800c9b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9d:	ff 4d 10             	decl   0x10(%ebp)
  800ca0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca4:	74 09                	je     800caf <strlcpy+0x3c>
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 d8                	jne    800c87 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	29 c2                	sub    %eax,%edx
  800cbd:	89 d0                	mov    %edx,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc4:	eb 06                	jmp    800ccc <strcmp+0xb>
		p++, q++;
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	74 0e                	je     800ce3 <strcmp+0x22>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 10                	mov    (%eax),%dl
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	38 c2                	cmp    %al,%dl
  800ce1:	74 e3                	je     800cc6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 d0             	movzbl %al,%edx
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f b6 c0             	movzbl %al,%eax
  800cf3:	29 c2                	sub    %eax,%edx
  800cf5:	89 d0                	mov    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfc:	eb 09                	jmp    800d07 <strncmp+0xe>
		n--, p++, q++;
  800cfe:	ff 4d 10             	decl   0x10(%ebp)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	74 17                	je     800d24 <strncmp+0x2b>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 0e                	je     800d24 <strncmp+0x2b>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 10                	mov    (%eax),%dl
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	38 c2                	cmp    %al,%dl
  800d22:	74 da                	je     800cfe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d28:	75 07                	jne    800d31 <strncmp+0x38>
		return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	eb 14                	jmp    800d45 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 d0             	movzbl %al,%edx
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 c0             	movzbl %al,%eax
  800d41:	29 c2                	sub    %eax,%edx
  800d43:	89 d0                	mov    %edx,%eax
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 04             	sub    $0x4,%esp
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d53:	eb 12                	jmp    800d67 <strchr+0x20>
		if (*s == c)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5d:	75 05                	jne    800d64 <strchr+0x1d>
			return (char *) s;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	eb 11                	jmp    800d75 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e5                	jne    800d55 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 04             	sub    $0x4,%esp
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d83:	eb 0d                	jmp    800d92 <strfind+0x1b>
		if (*s == c)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8d:	74 0e                	je     800d9d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	75 ea                	jne    800d85 <strfind+0xe>
  800d9b:	eb 01                	jmp    800d9e <strfind+0x27>
		if (*s == c)
			break;
  800d9d:	90                   	nop
	return (char *) s;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db5:	eb 0e                	jmp    800dc5 <memset+0x22>
		*p++ = c;
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	8d 50 01             	lea    0x1(%eax),%edx
  800dbd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc5:	ff 4d f8             	decl   -0x8(%ebp)
  800dc8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcc:	79 e9                	jns    800db7 <memset+0x14>
		*p++ = c;

	return v;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de5:	eb 16                	jmp    800dfd <memcpy+0x2a>
		*d++ = *s++;
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df9:	8a 12                	mov    (%edx),%dl
  800dfb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e03:	89 55 10             	mov    %edx,0x10(%ebp)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	75 dd                	jne    800de7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e27:	73 50                	jae    800e79 <memmove+0x6a>
  800e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e34:	76 43                	jbe    800e79 <memmove+0x6a>
		s += n;
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e42:	eb 10                	jmp    800e54 <memmove+0x45>
			*--d = *--s;
  800e44:	ff 4d f8             	decl   -0x8(%ebp)
  800e47:	ff 4d fc             	decl   -0x4(%ebp)
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 e3                	jne    800e44 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e61:	eb 23                	jmp    800e86 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e72:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e75:	8a 12                	mov    (%edx),%dl
  800e77:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 dd                	jne    800e63 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9d:	eb 2a                	jmp    800ec9 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 10                	mov    (%eax),%dl
  800ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	38 c2                	cmp    %al,%dl
  800eab:	74 16                	je     800ec3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 d0             	movzbl %al,%edx
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	29 c2                	sub    %eax,%edx
  800ebf:	89 d0                	mov    %edx,%eax
  800ec1:	eb 18                	jmp    800edb <memcmp+0x50>
		s1++, s2++;
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	75 c9                	jne    800e9f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee9:	01 d0                	add    %edx,%eax
  800eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eee:	eb 15                	jmp    800f05 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f b6 d0             	movzbl %al,%edx
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	0f b6 c0             	movzbl %al,%eax
  800efe:	39 c2                	cmp    %eax,%edx
  800f00:	74 0d                	je     800f0f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0b:	72 e3                	jb     800ef0 <memfind+0x13>
  800f0d:	eb 01                	jmp    800f10 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0f:	90                   	nop
	return (void *) s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f29:	eb 03                	jmp    800f2e <strtol+0x19>
		s++;
  800f2b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 20                	cmp    $0x20,%al
  800f35:	74 f4                	je     800f2b <strtol+0x16>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 09                	cmp    $0x9,%al
  800f3e:	74 eb                	je     800f2b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2b                	cmp    $0x2b,%al
  800f47:	75 05                	jne    800f4e <strtol+0x39>
		s++;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	eb 13                	jmp    800f61 <strtol+0x4c>
	else if (*s == '-')
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 2d                	cmp    $0x2d,%al
  800f55:	75 0a                	jne    800f61 <strtol+0x4c>
		s++, neg = 1;
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	74 06                	je     800f6d <strtol+0x58>
  800f67:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6b:	75 20                	jne    800f8d <strtol+0x78>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 30                	cmp    $0x30,%al
  800f74:	75 17                	jne    800f8d <strtol+0x78>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	40                   	inc    %eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 78                	cmp    $0x78,%al
  800f7e:	75 0d                	jne    800f8d <strtol+0x78>
		s += 2, base = 16;
  800f80:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f84:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8b:	eb 28                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	75 15                	jne    800fa8 <strtol+0x93>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 30                	cmp    $0x30,%al
  800f9a:	75 0c                	jne    800fa8 <strtol+0x93>
		s++, base = 8;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa6:	eb 0d                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	75 07                	jne    800fb5 <strtol+0xa0>
		base = 10;
  800fae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 2f                	cmp    $0x2f,%al
  800fbc:	7e 19                	jle    800fd7 <strtol+0xc2>
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 39                	cmp    $0x39,%al
  800fc5:	7f 10                	jg     800fd7 <strtol+0xc2>
			dig = *s - '0';
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f be c0             	movsbl %al,%eax
  800fcf:	83 e8 30             	sub    $0x30,%eax
  800fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd5:	eb 42                	jmp    801019 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 60                	cmp    $0x60,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xe4>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 7a                	cmp    $0x7a,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 57             	sub    $0x57,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 20                	jmp    801019 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 40                	cmp    $0x40,%al
  801000:	7e 39                	jle    80103b <strtol+0x126>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 5a                	cmp    $0x5a,%al
  801009:	7f 30                	jg     80103b <strtol+0x126>
			dig = *s - 'A' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 37             	sub    $0x37,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101f:	7d 19                	jge    80103a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102b:	89 c2                	mov    %eax,%edx
  80102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801035:	e9 7b ff ff ff       	jmp    800fb5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103f:	74 08                	je     801049 <strtol+0x134>
		*endptr = (char *) s;
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104d:	74 07                	je     801056 <strtol+0x141>
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	f7 d8                	neg    %eax
  801054:	eb 03                	jmp    801059 <strtol+0x144>
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <ltostr>:

void
ltostr(long value, char *str)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801073:	79 13                	jns    801088 <ltostr+0x2d>
	{
		neg = 1;
  801075:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801082:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801085:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801090:	99                   	cltd   
  801091:	f7 f9                	idiv   %ecx
  801093:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	8d 50 01             	lea    0x1(%eax),%edx
  80109c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a9:	83 c2 30             	add    $0x30,%edx
  8010ac:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b6:	f7 e9                	imul   %ecx
  8010b8:	c1 fa 02             	sar    $0x2,%edx
  8010bb:	89 c8                	mov    %ecx,%eax
  8010bd:	c1 f8 1f             	sar    $0x1f,%eax
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	89 d0                	mov    %edx,%eax
  8010c4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cf:	f7 e9                	imul   %ecx
  8010d1:	c1 fa 02             	sar    $0x2,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	c1 f8 1f             	sar    $0x1f,%eax
  8010d9:	29 c2                	sub    %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	c1 e0 02             	shl    $0x2,%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	01 c0                	add    %eax,%eax
  8010e4:	29 c1                	sub    %eax,%ecx
  8010e6:	89 ca                	mov    %ecx,%edx
  8010e8:	85 d2                	test   %edx,%edx
  8010ea:	75 9c                	jne    801088 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	48                   	dec    %eax
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fe:	74 3d                	je     80113d <ltostr+0xe2>
		start = 1 ;
  801100:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801107:	eb 34                	jmp    80113d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	01 c8                	add    %ecx,%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	01 c2                	add    %eax,%edx
  801132:	8a 45 eb             	mov    -0x15(%ebp),%al
  801135:	88 02                	mov    %al,(%edx)
		start++ ;
  801137:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801143:	7c c4                	jl     801109 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801145:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801150:	90                   	nop
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801159:	ff 75 08             	pushl  0x8(%ebp)
  80115c:	e8 54 fa ff ff       	call   800bb5 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	e8 46 fa ff ff       	call   800bb5 <strlen>
  80116f:	83 c4 04             	add    $0x4,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801183:	eb 17                	jmp    80119c <strcconcat+0x49>
		final[s] = str1[s] ;
  801185:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	01 c8                	add    %ecx,%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801199:	ff 45 fc             	incl   -0x4(%ebp)
  80119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a2:	7c e1                	jl     801185 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b2:	eb 1f                	jmp    8011d3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d0:	ff 45 f8             	incl   -0x8(%ebp)
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c d9                	jl     8011b4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f8:	8b 00                	mov    (%eax),%eax
  8011fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	eb 0c                	jmp    80121a <strsplit+0x31>
			*string++ = 0;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8d 50 01             	lea    0x1(%eax),%edx
  801214:	89 55 08             	mov    %edx,0x8(%ebp)
  801217:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	84 c0                	test   %al,%al
  801221:	74 18                	je     80123b <strsplit+0x52>
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f be c0             	movsbl %al,%eax
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	e8 13 fb ff ff       	call   800d47 <strchr>
  801234:	83 c4 08             	add    $0x8,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	75 d3                	jne    80120e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	84 c0                	test   %al,%al
  801242:	74 5a                	je     80129e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	83 f8 0f             	cmp    $0xf,%eax
  80124c:	75 07                	jne    801255 <strsplit+0x6c>
		{
			return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	eb 66                	jmp    8012bb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 48 01             	lea    0x1(%eax),%ecx
  80125d:	8b 55 14             	mov    0x14(%ebp),%edx
  801260:	89 0a                	mov    %ecx,(%edx)
  801262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801273:	eb 03                	jmp    801278 <strsplit+0x8f>
			string++;
  801275:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	84 c0                	test   %al,%al
  80127f:	74 8b                	je     80120c <strsplit+0x23>
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	0f be c0             	movsbl %al,%eax
  801289:	50                   	push   %eax
  80128a:	ff 75 0c             	pushl  0xc(%ebp)
  80128d:	e8 b5 fa ff ff       	call   800d47 <strchr>
  801292:	83 c4 08             	add    $0x8,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	74 dc                	je     801275 <strsplit+0x8c>
			string++;
	}
  801299:	e9 6e ff ff ff       	jmp    80120c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80129e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 1f                	je     8012eb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cc:	e8 1d 00 00 00       	call   8012ee <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	68 d0 39 80 00       	push   $0x8039d0
  8012d9:	e8 55 f2 ff ff       	call   800533 <cprintf>
  8012de:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e1:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e8:	00 00 00 
	}
}
  8012eb:	90                   	nop
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012f4:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012fb:	00 00 00 
  8012fe:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801305:	00 00 00 
  801308:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80130f:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801312:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801319:	00 00 00 
  80131c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801323:	00 00 00 
  801326:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80132d:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801330:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801337:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80133a:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801349:	2d 00 10 00 00       	sub    $0x1000,%eax
  80134e:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801353:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80135a:	a1 20 41 80 00       	mov    0x804120,%eax
  80135f:	c1 e0 04             	shl    $0x4,%eax
  801362:	89 c2                	mov    %eax,%edx
  801364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801367:	01 d0                	add    %edx,%eax
  801369:	48                   	dec    %eax
  80136a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80136d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801370:	ba 00 00 00 00       	mov    $0x0,%edx
  801375:	f7 75 f0             	divl   -0x10(%ebp)
  801378:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80137b:	29 d0                	sub    %edx,%eax
  80137d:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801380:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801387:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80138a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801394:	83 ec 04             	sub    $0x4,%esp
  801397:	6a 06                	push   $0x6
  801399:	ff 75 e8             	pushl  -0x18(%ebp)
  80139c:	50                   	push   %eax
  80139d:	e8 b0 05 00 00       	call   801952 <sys_allocate_chunk>
  8013a2:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013a5:	a1 20 41 80 00       	mov    0x804120,%eax
  8013aa:	83 ec 0c             	sub    $0xc,%esp
  8013ad:	50                   	push   %eax
  8013ae:	e8 25 0c 00 00       	call   801fd8 <initialize_MemBlocksList>
  8013b3:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8013b6:	a1 48 41 80 00       	mov    0x804148,%eax
  8013bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8013be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013c2:	75 14                	jne    8013d8 <initialize_dyn_block_system+0xea>
  8013c4:	83 ec 04             	sub    $0x4,%esp
  8013c7:	68 f5 39 80 00       	push   $0x8039f5
  8013cc:	6a 29                	push   $0x29
  8013ce:	68 13 3a 80 00       	push   $0x803a13
  8013d3:	e8 a7 ee ff ff       	call   80027f <_panic>
  8013d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013db:	8b 00                	mov    (%eax),%eax
  8013dd:	85 c0                	test   %eax,%eax
  8013df:	74 10                	je     8013f1 <initialize_dyn_block_system+0x103>
  8013e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e4:	8b 00                	mov    (%eax),%eax
  8013e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013e9:	8b 52 04             	mov    0x4(%edx),%edx
  8013ec:	89 50 04             	mov    %edx,0x4(%eax)
  8013ef:	eb 0b                	jmp    8013fc <initialize_dyn_block_system+0x10e>
  8013f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f4:	8b 40 04             	mov    0x4(%eax),%eax
  8013f7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ff:	8b 40 04             	mov    0x4(%eax),%eax
  801402:	85 c0                	test   %eax,%eax
  801404:	74 0f                	je     801415 <initialize_dyn_block_system+0x127>
  801406:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801409:	8b 40 04             	mov    0x4(%eax),%eax
  80140c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80140f:	8b 12                	mov    (%edx),%edx
  801411:	89 10                	mov    %edx,(%eax)
  801413:	eb 0a                	jmp    80141f <initialize_dyn_block_system+0x131>
  801415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801418:	8b 00                	mov    (%eax),%eax
  80141a:	a3 48 41 80 00       	mov    %eax,0x804148
  80141f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801422:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801432:	a1 54 41 80 00       	mov    0x804154,%eax
  801437:	48                   	dec    %eax
  801438:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80143d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801440:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801447:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	ff 75 e0             	pushl  -0x20(%ebp)
  801457:	e8 b9 14 00 00       	call   802915 <insert_sorted_with_merge_freeList>
  80145c:	83 c4 10             	add    $0x10,%esp

}
  80145f:	90                   	nop
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801468:	e8 50 fe ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  80146d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801471:	75 07                	jne    80147a <malloc+0x18>
  801473:	b8 00 00 00 00       	mov    $0x0,%eax
  801478:	eb 68                	jmp    8014e2 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  80147a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801481:	8b 55 08             	mov    0x8(%ebp),%edx
  801484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801487:	01 d0                	add    %edx,%eax
  801489:	48                   	dec    %eax
  80148a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801490:	ba 00 00 00 00       	mov    $0x0,%edx
  801495:	f7 75 f4             	divl   -0xc(%ebp)
  801498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149b:	29 d0                	sub    %edx,%eax
  80149d:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8014a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014a7:	e8 74 08 00 00       	call   801d20 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	74 2d                	je     8014dd <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8014b0:	83 ec 0c             	sub    $0xc,%esp
  8014b3:	ff 75 ec             	pushl  -0x14(%ebp)
  8014b6:	e8 52 0e 00 00       	call   80230d <alloc_block_FF>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8014c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014c5:	74 16                	je     8014dd <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8014c7:	83 ec 0c             	sub    $0xc,%esp
  8014ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8014cd:	e8 3b 0c 00 00       	call   80210d <insert_sorted_allocList>
  8014d2:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8014d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014d8:	8b 40 08             	mov    0x8(%eax),%eax
  8014db:	eb 05                	jmp    8014e2 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8014e2:	c9                   	leave  
  8014e3:	c3                   	ret    

008014e4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014e4:	55                   	push   %ebp
  8014e5:	89 e5                	mov    %esp,%ebp
  8014e7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	83 ec 08             	sub    $0x8,%esp
  8014f0:	50                   	push   %eax
  8014f1:	68 40 40 80 00       	push   $0x804040
  8014f6:	e8 ba 0b 00 00       	call   8020b5 <find_block>
  8014fb:	83 c4 10             	add    $0x10,%esp
  8014fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801501:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801504:	8b 40 0c             	mov    0xc(%eax),%eax
  801507:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80150a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80150e:	0f 84 9f 00 00 00    	je     8015b3 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801514:	8b 45 08             	mov    0x8(%ebp),%eax
  801517:	83 ec 08             	sub    $0x8,%esp
  80151a:	ff 75 f0             	pushl  -0x10(%ebp)
  80151d:	50                   	push   %eax
  80151e:	e8 f7 03 00 00       	call   80191a <sys_free_user_mem>
  801523:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801526:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80152a:	75 14                	jne    801540 <free+0x5c>
  80152c:	83 ec 04             	sub    $0x4,%esp
  80152f:	68 f5 39 80 00       	push   $0x8039f5
  801534:	6a 6a                	push   $0x6a
  801536:	68 13 3a 80 00       	push   $0x803a13
  80153b:	e8 3f ed ff ff       	call   80027f <_panic>
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801543:	8b 00                	mov    (%eax),%eax
  801545:	85 c0                	test   %eax,%eax
  801547:	74 10                	je     801559 <free+0x75>
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801551:	8b 52 04             	mov    0x4(%edx),%edx
  801554:	89 50 04             	mov    %edx,0x4(%eax)
  801557:	eb 0b                	jmp    801564 <free+0x80>
  801559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155c:	8b 40 04             	mov    0x4(%eax),%eax
  80155f:	a3 44 40 80 00       	mov    %eax,0x804044
  801564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801567:	8b 40 04             	mov    0x4(%eax),%eax
  80156a:	85 c0                	test   %eax,%eax
  80156c:	74 0f                	je     80157d <free+0x99>
  80156e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801571:	8b 40 04             	mov    0x4(%eax),%eax
  801574:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801577:	8b 12                	mov    (%edx),%edx
  801579:	89 10                	mov    %edx,(%eax)
  80157b:	eb 0a                	jmp    801587 <free+0xa3>
  80157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801580:	8b 00                	mov    (%eax),%eax
  801582:	a3 40 40 80 00       	mov    %eax,0x804040
  801587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80159a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80159f:	48                   	dec    %eax
  8015a0:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8015a5:	83 ec 0c             	sub    $0xc,%esp
  8015a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015ab:	e8 65 13 00 00       	call   802915 <insert_sorted_with_merge_freeList>
  8015b0:	83 c4 10             	add    $0x10,%esp
	}
}
  8015b3:	90                   	nop
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 28             	sub    $0x28,%esp
  8015bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8015bf:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015c2:	e8 f6 fc ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  8015c7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015cb:	75 0a                	jne    8015d7 <smalloc+0x21>
  8015cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d2:	e9 af 00 00 00       	jmp    801686 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8015d7:	e8 44 07 00 00       	call   801d20 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015dc:	83 f8 01             	cmp    $0x1,%eax
  8015df:	0f 85 9c 00 00 00    	jne    801681 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8015e5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f2:	01 d0                	add    %edx,%eax
  8015f4:	48                   	dec    %eax
  8015f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801600:	f7 75 f4             	divl   -0xc(%ebp)
  801603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801606:	29 d0                	sub    %edx,%eax
  801608:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80160b:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801612:	76 07                	jbe    80161b <smalloc+0x65>
			return NULL;
  801614:	b8 00 00 00 00       	mov    $0x0,%eax
  801619:	eb 6b                	jmp    801686 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80161b:	83 ec 0c             	sub    $0xc,%esp
  80161e:	ff 75 0c             	pushl  0xc(%ebp)
  801621:	e8 e7 0c 00 00       	call   80230d <alloc_block_FF>
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80162c:	83 ec 0c             	sub    $0xc,%esp
  80162f:	ff 75 ec             	pushl  -0x14(%ebp)
  801632:	e8 d6 0a 00 00       	call   80210d <insert_sorted_allocList>
  801637:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80163a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80163e:	75 07                	jne    801647 <smalloc+0x91>
		{
			return NULL;
  801640:	b8 00 00 00 00       	mov    $0x0,%eax
  801645:	eb 3f                	jmp    801686 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801647:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80164a:	8b 40 08             	mov    0x8(%eax),%eax
  80164d:	89 c2                	mov    %eax,%edx
  80164f:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801653:	52                   	push   %edx
  801654:	50                   	push   %eax
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	ff 75 08             	pushl  0x8(%ebp)
  80165b:	e8 45 04 00 00       	call   801aa5 <sys_createSharedObject>
  801660:	83 c4 10             	add    $0x10,%esp
  801663:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801666:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80166a:	74 06                	je     801672 <smalloc+0xbc>
  80166c:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801670:	75 07                	jne    801679 <smalloc+0xc3>
		{
			return NULL;
  801672:	b8 00 00 00 00       	mov    $0x0,%eax
  801677:	eb 0d                	jmp    801686 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801679:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80167c:	8b 40 08             	mov    0x8(%eax),%eax
  80167f:	eb 05                	jmp    801686 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801681:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
  80168b:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80168e:	e8 2a fc ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801693:	83 ec 08             	sub    $0x8,%esp
  801696:	ff 75 0c             	pushl  0xc(%ebp)
  801699:	ff 75 08             	pushl  0x8(%ebp)
  80169c:	e8 2e 04 00 00       	call   801acf <sys_getSizeOfSharedObject>
  8016a1:	83 c4 10             	add    $0x10,%esp
  8016a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8016a7:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016ab:	75 0a                	jne    8016b7 <sget+0x2f>
	{
		return NULL;
  8016ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b2:	e9 94 00 00 00       	jmp    80174b <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016b7:	e8 64 06 00 00       	call   801d20 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016bc:	85 c0                	test   %eax,%eax
  8016be:	0f 84 82 00 00 00    	je     801746 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8016c4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8016cb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d8:	01 d0                	add    %edx,%eax
  8016da:	48                   	dec    %eax
  8016db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e6:	f7 75 ec             	divl   -0x14(%ebp)
  8016e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ec:	29 d0                	sub    %edx,%eax
  8016ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8016f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f4:	83 ec 0c             	sub    $0xc,%esp
  8016f7:	50                   	push   %eax
  8016f8:	e8 10 0c 00 00       	call   80230d <alloc_block_FF>
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801703:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801707:	75 07                	jne    801710 <sget+0x88>
		{
			return NULL;
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
  80170e:	eb 3b                	jmp    80174b <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801710:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801713:	8b 40 08             	mov    0x8(%eax),%eax
  801716:	83 ec 04             	sub    $0x4,%esp
  801719:	50                   	push   %eax
  80171a:	ff 75 0c             	pushl  0xc(%ebp)
  80171d:	ff 75 08             	pushl  0x8(%ebp)
  801720:	e8 c7 03 00 00       	call   801aec <sys_getSharedObject>
  801725:	83 c4 10             	add    $0x10,%esp
  801728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80172b:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80172f:	74 06                	je     801737 <sget+0xaf>
  801731:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801735:	75 07                	jne    80173e <sget+0xb6>
		{
			return NULL;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
  80173c:	eb 0d                	jmp    80174b <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80173e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801741:	8b 40 08             	mov    0x8(%eax),%eax
  801744:	eb 05                	jmp    80174b <sget+0xc3>
		}
	}
	else
			return NULL;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174b:	c9                   	leave  
  80174c:	c3                   	ret    

0080174d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80174d:	55                   	push   %ebp
  80174e:	89 e5                	mov    %esp,%ebp
  801750:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801753:	e8 65 fb ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	68 20 3a 80 00       	push   $0x803a20
  801760:	68 e1 00 00 00       	push   $0xe1
  801765:	68 13 3a 80 00       	push   $0x803a13
  80176a:	e8 10 eb ff ff       	call   80027f <_panic>

0080176f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801775:	83 ec 04             	sub    $0x4,%esp
  801778:	68 48 3a 80 00       	push   $0x803a48
  80177d:	68 f5 00 00 00       	push   $0xf5
  801782:	68 13 3a 80 00       	push   $0x803a13
  801787:	e8 f3 ea ff ff       	call   80027f <_panic>

0080178c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801792:	83 ec 04             	sub    $0x4,%esp
  801795:	68 6c 3a 80 00       	push   $0x803a6c
  80179a:	68 00 01 00 00       	push   $0x100
  80179f:	68 13 3a 80 00       	push   $0x803a13
  8017a4:	e8 d6 ea ff ff       	call   80027f <_panic>

008017a9 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
  8017ac:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017af:	83 ec 04             	sub    $0x4,%esp
  8017b2:	68 6c 3a 80 00       	push   $0x803a6c
  8017b7:	68 05 01 00 00       	push   $0x105
  8017bc:	68 13 3a 80 00       	push   $0x803a13
  8017c1:	e8 b9 ea ff ff       	call   80027f <_panic>

008017c6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017cc:	83 ec 04             	sub    $0x4,%esp
  8017cf:	68 6c 3a 80 00       	push   $0x803a6c
  8017d4:	68 0a 01 00 00       	push   $0x10a
  8017d9:	68 13 3a 80 00       	push   $0x803a13
  8017de:	e8 9c ea ff ff       	call   80027f <_panic>

008017e3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	57                   	push   %edi
  8017e7:	56                   	push   %esi
  8017e8:	53                   	push   %ebx
  8017e9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017f5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017fb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017fe:	cd 30                	int    $0x30
  801800:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801803:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801806:	83 c4 10             	add    $0x10,%esp
  801809:	5b                   	pop    %ebx
  80180a:	5e                   	pop    %esi
  80180b:	5f                   	pop    %edi
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    

0080180e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80180e:	55                   	push   %ebp
  80180f:	89 e5                	mov    %esp,%ebp
  801811:	83 ec 04             	sub    $0x4,%esp
  801814:	8b 45 10             	mov    0x10(%ebp),%eax
  801817:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80181a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	52                   	push   %edx
  801826:	ff 75 0c             	pushl  0xc(%ebp)
  801829:	50                   	push   %eax
  80182a:	6a 00                	push   $0x0
  80182c:	e8 b2 ff ff ff       	call   8017e3 <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	90                   	nop
  801835:	c9                   	leave  
  801836:	c3                   	ret    

00801837 <sys_cgetc>:

int
sys_cgetc(void)
{
  801837:	55                   	push   %ebp
  801838:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80183a:	6a 00                	push   $0x0
  80183c:	6a 00                	push   $0x0
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	6a 00                	push   $0x0
  801844:	6a 01                	push   $0x1
  801846:	e8 98 ff ff ff       	call   8017e3 <syscall>
  80184b:	83 c4 18             	add    $0x18,%esp
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801853:	8b 55 0c             	mov    0xc(%ebp),%edx
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	52                   	push   %edx
  801860:	50                   	push   %eax
  801861:	6a 05                	push   $0x5
  801863:	e8 7b ff ff ff       	call   8017e3 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
  801870:	56                   	push   %esi
  801871:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801872:	8b 75 18             	mov    0x18(%ebp),%esi
  801875:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801878:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80187b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80187e:	8b 45 08             	mov    0x8(%ebp),%eax
  801881:	56                   	push   %esi
  801882:	53                   	push   %ebx
  801883:	51                   	push   %ecx
  801884:	52                   	push   %edx
  801885:	50                   	push   %eax
  801886:	6a 06                	push   $0x6
  801888:	e8 56 ff ff ff       	call   8017e3 <syscall>
  80188d:	83 c4 18             	add    $0x18,%esp
}
  801890:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801893:	5b                   	pop    %ebx
  801894:	5e                   	pop    %esi
  801895:	5d                   	pop    %ebp
  801896:	c3                   	ret    

00801897 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80189a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 00                	push   $0x0
  8018a6:	52                   	push   %edx
  8018a7:	50                   	push   %eax
  8018a8:	6a 07                	push   $0x7
  8018aa:	e8 34 ff ff ff       	call   8017e3 <syscall>
  8018af:	83 c4 18             	add    $0x18,%esp
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	ff 75 0c             	pushl  0xc(%ebp)
  8018c0:	ff 75 08             	pushl  0x8(%ebp)
  8018c3:	6a 08                	push   $0x8
  8018c5:	e8 19 ff ff ff       	call   8017e3 <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	c9                   	leave  
  8018ce:	c3                   	ret    

008018cf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018cf:	55                   	push   %ebp
  8018d0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 09                	push   $0x9
  8018de:	e8 00 ff ff ff       	call   8017e3 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	6a 0a                	push   $0xa
  8018f7:	e8 e7 fe ff ff       	call   8017e3 <syscall>
  8018fc:	83 c4 18             	add    $0x18,%esp
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 0b                	push   $0xb
  801910:	e8 ce fe ff ff       	call   8017e3 <syscall>
  801915:	83 c4 18             	add    $0x18,%esp
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	ff 75 0c             	pushl  0xc(%ebp)
  801926:	ff 75 08             	pushl  0x8(%ebp)
  801929:	6a 0f                	push   $0xf
  80192b:	e8 b3 fe ff ff       	call   8017e3 <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
	return;
  801933:	90                   	nop
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	ff 75 0c             	pushl  0xc(%ebp)
  801942:	ff 75 08             	pushl  0x8(%ebp)
  801945:	6a 10                	push   $0x10
  801947:	e8 97 fe ff ff       	call   8017e3 <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
	return ;
  80194f:	90                   	nop
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	ff 75 10             	pushl  0x10(%ebp)
  80195c:	ff 75 0c             	pushl  0xc(%ebp)
  80195f:	ff 75 08             	pushl  0x8(%ebp)
  801962:	6a 11                	push   $0x11
  801964:	e8 7a fe ff ff       	call   8017e3 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
	return ;
  80196c:	90                   	nop
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 0c                	push   $0xc
  80197e:	e8 60 fe ff ff       	call   8017e3 <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	ff 75 08             	pushl  0x8(%ebp)
  801996:	6a 0d                	push   $0xd
  801998:	e8 46 fe ff ff       	call   8017e3 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 0e                	push   $0xe
  8019b1:	e8 2d fe ff ff       	call   8017e3 <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	90                   	nop
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 13                	push   $0x13
  8019cb:	e8 13 fe ff ff       	call   8017e3 <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	90                   	nop
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 14                	push   $0x14
  8019e5:	e8 f9 fd ff ff       	call   8017e3 <syscall>
  8019ea:	83 c4 18             	add    $0x18,%esp
}
  8019ed:	90                   	nop
  8019ee:	c9                   	leave  
  8019ef:	c3                   	ret    

008019f0 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 04             	sub    $0x4,%esp
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019fc:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	50                   	push   %eax
  801a09:	6a 15                	push   $0x15
  801a0b:	e8 d3 fd ff ff       	call   8017e3 <syscall>
  801a10:	83 c4 18             	add    $0x18,%esp
}
  801a13:	90                   	nop
  801a14:	c9                   	leave  
  801a15:	c3                   	ret    

00801a16 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a16:	55                   	push   %ebp
  801a17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 16                	push   $0x16
  801a25:	e8 b9 fd ff ff       	call   8017e3 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
}
  801a2d:	90                   	nop
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	50                   	push   %eax
  801a40:	6a 17                	push   $0x17
  801a42:	e8 9c fd ff ff       	call   8017e3 <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	c9                   	leave  
  801a4b:	c3                   	ret    

00801a4c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a52:	8b 45 08             	mov    0x8(%ebp),%eax
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	52                   	push   %edx
  801a5c:	50                   	push   %eax
  801a5d:	6a 1a                	push   $0x1a
  801a5f:	e8 7f fd ff ff       	call   8017e3 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	52                   	push   %edx
  801a79:	50                   	push   %eax
  801a7a:	6a 18                	push   $0x18
  801a7c:	e8 62 fd ff ff       	call   8017e3 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	90                   	nop
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	52                   	push   %edx
  801a97:	50                   	push   %eax
  801a98:	6a 19                	push   $0x19
  801a9a:	e8 44 fd ff ff       	call   8017e3 <syscall>
  801a9f:	83 c4 18             	add    $0x18,%esp
}
  801aa2:	90                   	nop
  801aa3:	c9                   	leave  
  801aa4:	c3                   	ret    

00801aa5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 04             	sub    $0x4,%esp
  801aab:	8b 45 10             	mov    0x10(%ebp),%eax
  801aae:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ab1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ab4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  801abb:	6a 00                	push   $0x0
  801abd:	51                   	push   %ecx
  801abe:	52                   	push   %edx
  801abf:	ff 75 0c             	pushl  0xc(%ebp)
  801ac2:	50                   	push   %eax
  801ac3:	6a 1b                	push   $0x1b
  801ac5:	e8 19 fd ff ff       	call   8017e3 <syscall>
  801aca:	83 c4 18             	add    $0x18,%esp
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ad2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	52                   	push   %edx
  801adf:	50                   	push   %eax
  801ae0:	6a 1c                	push   $0x1c
  801ae2:	e8 fc fc ff ff       	call   8017e3 <syscall>
  801ae7:	83 c4 18             	add    $0x18,%esp
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801aef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801af2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af5:	8b 45 08             	mov    0x8(%ebp),%eax
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	51                   	push   %ecx
  801afd:	52                   	push   %edx
  801afe:	50                   	push   %eax
  801aff:	6a 1d                	push   $0x1d
  801b01:	e8 dd fc ff ff       	call   8017e3 <syscall>
  801b06:	83 c4 18             	add    $0x18,%esp
}
  801b09:	c9                   	leave  
  801b0a:	c3                   	ret    

00801b0b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b0b:	55                   	push   %ebp
  801b0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	52                   	push   %edx
  801b1b:	50                   	push   %eax
  801b1c:	6a 1e                	push   $0x1e
  801b1e:	e8 c0 fc ff ff       	call   8017e3 <syscall>
  801b23:	83 c4 18             	add    $0x18,%esp
}
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 1f                	push   $0x1f
  801b37:	e8 a7 fc ff ff       	call   8017e3 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	ff 75 14             	pushl  0x14(%ebp)
  801b4c:	ff 75 10             	pushl  0x10(%ebp)
  801b4f:	ff 75 0c             	pushl  0xc(%ebp)
  801b52:	50                   	push   %eax
  801b53:	6a 20                	push   $0x20
  801b55:	e8 89 fc ff ff       	call   8017e3 <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	50                   	push   %eax
  801b6e:	6a 21                	push   $0x21
  801b70:	e8 6e fc ff ff       	call   8017e3 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	90                   	nop
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b81:	6a 00                	push   $0x0
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	50                   	push   %eax
  801b8a:	6a 22                	push   $0x22
  801b8c:	e8 52 fc ff ff       	call   8017e3 <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 02                	push   $0x2
  801ba5:	e8 39 fc ff ff       	call   8017e3 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 03                	push   $0x3
  801bbe:	e8 20 fc ff ff       	call   8017e3 <syscall>
  801bc3:	83 c4 18             	add    $0x18,%esp
}
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 04                	push   $0x4
  801bd7:	e8 07 fc ff ff       	call   8017e3 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <sys_exit_env>:


void sys_exit_env(void)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	6a 23                	push   $0x23
  801bf0:	e8 ee fb ff ff       	call   8017e3 <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
}
  801bf8:	90                   	nop
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c01:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c04:	8d 50 04             	lea    0x4(%eax),%edx
  801c07:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	52                   	push   %edx
  801c11:	50                   	push   %eax
  801c12:	6a 24                	push   $0x24
  801c14:	e8 ca fb ff ff       	call   8017e3 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
	return result;
  801c1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c25:	89 01                	mov    %eax,(%ecx)
  801c27:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2d:	c9                   	leave  
  801c2e:	c2 04 00             	ret    $0x4

00801c31 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	ff 75 10             	pushl  0x10(%ebp)
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	ff 75 08             	pushl  0x8(%ebp)
  801c41:	6a 12                	push   $0x12
  801c43:	e8 9b fb ff ff       	call   8017e3 <syscall>
  801c48:	83 c4 18             	add    $0x18,%esp
	return ;
  801c4b:	90                   	nop
}
  801c4c:	c9                   	leave  
  801c4d:	c3                   	ret    

00801c4e <sys_rcr2>:
uint32 sys_rcr2()
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 25                	push   $0x25
  801c5d:	e8 81 fb ff ff       	call   8017e3 <syscall>
  801c62:	83 c4 18             	add    $0x18,%esp
}
  801c65:	c9                   	leave  
  801c66:	c3                   	ret    

00801c67 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c73:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	50                   	push   %eax
  801c80:	6a 26                	push   $0x26
  801c82:	e8 5c fb ff ff       	call   8017e3 <syscall>
  801c87:	83 c4 18             	add    $0x18,%esp
	return ;
  801c8a:	90                   	nop
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <rsttst>:
void rsttst()
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 28                	push   $0x28
  801c9c:	e8 42 fb ff ff       	call   8017e3 <syscall>
  801ca1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ca4:	90                   	nop
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	83 ec 04             	sub    $0x4,%esp
  801cad:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cb3:	8b 55 18             	mov    0x18(%ebp),%edx
  801cb6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cba:	52                   	push   %edx
  801cbb:	50                   	push   %eax
  801cbc:	ff 75 10             	pushl  0x10(%ebp)
  801cbf:	ff 75 0c             	pushl  0xc(%ebp)
  801cc2:	ff 75 08             	pushl  0x8(%ebp)
  801cc5:	6a 27                	push   $0x27
  801cc7:	e8 17 fb ff ff       	call   8017e3 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccf:	90                   	nop
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <chktst>:
void chktst(uint32 n)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	ff 75 08             	pushl  0x8(%ebp)
  801ce0:	6a 29                	push   $0x29
  801ce2:	e8 fc fa ff ff       	call   8017e3 <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
	return ;
  801cea:	90                   	nop
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <inctst>:

void inctst()
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 2a                	push   $0x2a
  801cfc:	e8 e2 fa ff ff       	call   8017e3 <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
	return ;
  801d04:	90                   	nop
}
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <gettst>:
uint32 gettst()
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 2b                	push   $0x2b
  801d16:	e8 c8 fa ff ff       	call   8017e3 <syscall>
  801d1b:	83 c4 18             	add    $0x18,%esp
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 2c                	push   $0x2c
  801d32:	e8 ac fa ff ff       	call   8017e3 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
  801d3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d3d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d41:	75 07                	jne    801d4a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d43:	b8 01 00 00 00       	mov    $0x1,%eax
  801d48:	eb 05                	jmp    801d4f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d4f:	c9                   	leave  
  801d50:	c3                   	ret    

00801d51 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d51:	55                   	push   %ebp
  801d52:	89 e5                	mov    %esp,%ebp
  801d54:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 2c                	push   $0x2c
  801d63:	e8 7b fa ff ff       	call   8017e3 <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
  801d6b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d6e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d72:	75 07                	jne    801d7b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d74:	b8 01 00 00 00       	mov    $0x1,%eax
  801d79:	eb 05                	jmp    801d80 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 2c                	push   $0x2c
  801d94:	e8 4a fa ff ff       	call   8017e3 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
  801d9c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d9f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801da3:	75 07                	jne    801dac <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801da5:	b8 01 00 00 00       	mov    $0x1,%eax
  801daa:	eb 05                	jmp    801db1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 2c                	push   $0x2c
  801dc5:	e8 19 fa ff ff       	call   8017e3 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
  801dcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dd0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dd4:	75 07                	jne    801ddd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddb:	eb 05                	jmp    801de2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	ff 75 08             	pushl  0x8(%ebp)
  801df2:	6a 2d                	push   $0x2d
  801df4:	e8 ea f9 ff ff       	call   8017e3 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfc:	90                   	nop
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e03:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e06:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0f:	6a 00                	push   $0x0
  801e11:	53                   	push   %ebx
  801e12:	51                   	push   %ecx
  801e13:	52                   	push   %edx
  801e14:	50                   	push   %eax
  801e15:	6a 2e                	push   $0x2e
  801e17:	e8 c7 f9 ff ff       	call   8017e3 <syscall>
  801e1c:	83 c4 18             	add    $0x18,%esp
}
  801e1f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	52                   	push   %edx
  801e34:	50                   	push   %eax
  801e35:	6a 2f                	push   $0x2f
  801e37:	e8 a7 f9 ff ff       	call   8017e3 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e47:	83 ec 0c             	sub    $0xc,%esp
  801e4a:	68 7c 3a 80 00       	push   $0x803a7c
  801e4f:	e8 df e6 ff ff       	call   800533 <cprintf>
  801e54:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e5e:	83 ec 0c             	sub    $0xc,%esp
  801e61:	68 a8 3a 80 00       	push   $0x803aa8
  801e66:	e8 c8 e6 ff ff       	call   800533 <cprintf>
  801e6b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e6e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e72:	a1 38 41 80 00       	mov    0x804138,%eax
  801e77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e7a:	eb 56                	jmp    801ed2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e80:	74 1c                	je     801e9e <print_mem_block_lists+0x5d>
  801e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e85:	8b 50 08             	mov    0x8(%eax),%edx
  801e88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e8b:	8b 48 08             	mov    0x8(%eax),%ecx
  801e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e91:	8b 40 0c             	mov    0xc(%eax),%eax
  801e94:	01 c8                	add    %ecx,%eax
  801e96:	39 c2                	cmp    %eax,%edx
  801e98:	73 04                	jae    801e9e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e9a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea1:	8b 50 08             	mov    0x8(%eax),%edx
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	8b 40 0c             	mov    0xc(%eax),%eax
  801eaa:	01 c2                	add    %eax,%edx
  801eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eaf:	8b 40 08             	mov    0x8(%eax),%eax
  801eb2:	83 ec 04             	sub    $0x4,%esp
  801eb5:	52                   	push   %edx
  801eb6:	50                   	push   %eax
  801eb7:	68 bd 3a 80 00       	push   $0x803abd
  801ebc:	e8 72 e6 ff ff       	call   800533 <cprintf>
  801ec1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eca:	a1 40 41 80 00       	mov    0x804140,%eax
  801ecf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ed2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed6:	74 07                	je     801edf <print_mem_block_lists+0x9e>
  801ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801edb:	8b 00                	mov    (%eax),%eax
  801edd:	eb 05                	jmp    801ee4 <print_mem_block_lists+0xa3>
  801edf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ee4:	a3 40 41 80 00       	mov    %eax,0x804140
  801ee9:	a1 40 41 80 00       	mov    0x804140,%eax
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	75 8a                	jne    801e7c <print_mem_block_lists+0x3b>
  801ef2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef6:	75 84                	jne    801e7c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ef8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801efc:	75 10                	jne    801f0e <print_mem_block_lists+0xcd>
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	68 cc 3a 80 00       	push   $0x803acc
  801f06:	e8 28 e6 ff ff       	call   800533 <cprintf>
  801f0b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f0e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f15:	83 ec 0c             	sub    $0xc,%esp
  801f18:	68 f0 3a 80 00       	push   $0x803af0
  801f1d:	e8 11 e6 ff ff       	call   800533 <cprintf>
  801f22:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f25:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f29:	a1 40 40 80 00       	mov    0x804040,%eax
  801f2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f31:	eb 56                	jmp    801f89 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f37:	74 1c                	je     801f55 <print_mem_block_lists+0x114>
  801f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3c:	8b 50 08             	mov    0x8(%eax),%edx
  801f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f42:	8b 48 08             	mov    0x8(%eax),%ecx
  801f45:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f48:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4b:	01 c8                	add    %ecx,%eax
  801f4d:	39 c2                	cmp    %eax,%edx
  801f4f:	73 04                	jae    801f55 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f51:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 50 08             	mov    0x8(%eax),%edx
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f61:	01 c2                	add    %eax,%edx
  801f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f66:	8b 40 08             	mov    0x8(%eax),%eax
  801f69:	83 ec 04             	sub    $0x4,%esp
  801f6c:	52                   	push   %edx
  801f6d:	50                   	push   %eax
  801f6e:	68 bd 3a 80 00       	push   $0x803abd
  801f73:	e8 bb e5 ff ff       	call   800533 <cprintf>
  801f78:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f81:	a1 48 40 80 00       	mov    0x804048,%eax
  801f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8d:	74 07                	je     801f96 <print_mem_block_lists+0x155>
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	8b 00                	mov    (%eax),%eax
  801f94:	eb 05                	jmp    801f9b <print_mem_block_lists+0x15a>
  801f96:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9b:	a3 48 40 80 00       	mov    %eax,0x804048
  801fa0:	a1 48 40 80 00       	mov    0x804048,%eax
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	75 8a                	jne    801f33 <print_mem_block_lists+0xf2>
  801fa9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fad:	75 84                	jne    801f33 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801faf:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fb3:	75 10                	jne    801fc5 <print_mem_block_lists+0x184>
  801fb5:	83 ec 0c             	sub    $0xc,%esp
  801fb8:	68 08 3b 80 00       	push   $0x803b08
  801fbd:	e8 71 e5 ff ff       	call   800533 <cprintf>
  801fc2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fc5:	83 ec 0c             	sub    $0xc,%esp
  801fc8:	68 7c 3a 80 00       	push   $0x803a7c
  801fcd:	e8 61 e5 ff ff       	call   800533 <cprintf>
  801fd2:	83 c4 10             	add    $0x10,%esp

}
  801fd5:	90                   	nop
  801fd6:	c9                   	leave  
  801fd7:	c3                   	ret    

00801fd8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fd8:	55                   	push   %ebp
  801fd9:	89 e5                	mov    %esp,%ebp
  801fdb:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fde:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fe5:	00 00 00 
  801fe8:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fef:	00 00 00 
  801ff2:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ff9:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  801ffc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802003:	e9 9e 00 00 00       	jmp    8020a6 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802008:	a1 50 40 80 00       	mov    0x804050,%eax
  80200d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802010:	c1 e2 04             	shl    $0x4,%edx
  802013:	01 d0                	add    %edx,%eax
  802015:	85 c0                	test   %eax,%eax
  802017:	75 14                	jne    80202d <initialize_MemBlocksList+0x55>
  802019:	83 ec 04             	sub    $0x4,%esp
  80201c:	68 30 3b 80 00       	push   $0x803b30
  802021:	6a 42                	push   $0x42
  802023:	68 53 3b 80 00       	push   $0x803b53
  802028:	e8 52 e2 ff ff       	call   80027f <_panic>
  80202d:	a1 50 40 80 00       	mov    0x804050,%eax
  802032:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802035:	c1 e2 04             	shl    $0x4,%edx
  802038:	01 d0                	add    %edx,%eax
  80203a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802040:	89 10                	mov    %edx,(%eax)
  802042:	8b 00                	mov    (%eax),%eax
  802044:	85 c0                	test   %eax,%eax
  802046:	74 18                	je     802060 <initialize_MemBlocksList+0x88>
  802048:	a1 48 41 80 00       	mov    0x804148,%eax
  80204d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802053:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802056:	c1 e1 04             	shl    $0x4,%ecx
  802059:	01 ca                	add    %ecx,%edx
  80205b:	89 50 04             	mov    %edx,0x4(%eax)
  80205e:	eb 12                	jmp    802072 <initialize_MemBlocksList+0x9a>
  802060:	a1 50 40 80 00       	mov    0x804050,%eax
  802065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802068:	c1 e2 04             	shl    $0x4,%edx
  80206b:	01 d0                	add    %edx,%eax
  80206d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802072:	a1 50 40 80 00       	mov    0x804050,%eax
  802077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207a:	c1 e2 04             	shl    $0x4,%edx
  80207d:	01 d0                	add    %edx,%eax
  80207f:	a3 48 41 80 00       	mov    %eax,0x804148
  802084:	a1 50 40 80 00       	mov    0x804050,%eax
  802089:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208c:	c1 e2 04             	shl    $0x4,%edx
  80208f:	01 d0                	add    %edx,%eax
  802091:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802098:	a1 54 41 80 00       	mov    0x804154,%eax
  80209d:	40                   	inc    %eax
  80209e:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8020a3:	ff 45 f4             	incl   -0xc(%ebp)
  8020a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020ac:	0f 82 56 ff ff ff    	jb     802008 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8020b2:	90                   	nop
  8020b3:	c9                   	leave  
  8020b4:	c3                   	ret    

008020b5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020be:	8b 00                	mov    (%eax),%eax
  8020c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020c3:	eb 19                	jmp    8020de <find_block+0x29>
	{
		if(blk->sva==va)
  8020c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c8:	8b 40 08             	mov    0x8(%eax),%eax
  8020cb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020ce:	75 05                	jne    8020d5 <find_block+0x20>
			return (blk);
  8020d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d3:	eb 36                	jmp    80210b <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	8b 40 08             	mov    0x8(%eax),%eax
  8020db:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020de:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020e2:	74 07                	je     8020eb <find_block+0x36>
  8020e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e7:	8b 00                	mov    (%eax),%eax
  8020e9:	eb 05                	jmp    8020f0 <find_block+0x3b>
  8020eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8020f3:	89 42 08             	mov    %eax,0x8(%edx)
  8020f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f9:	8b 40 08             	mov    0x8(%eax),%eax
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	75 c5                	jne    8020c5 <find_block+0x10>
  802100:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802104:	75 bf                	jne    8020c5 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802106:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    

0080210d <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80210d:	55                   	push   %ebp
  80210e:	89 e5                	mov    %esp,%ebp
  802110:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802113:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802118:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80211b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802122:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802125:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802128:	75 65                	jne    80218f <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80212a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80212e:	75 14                	jne    802144 <insert_sorted_allocList+0x37>
  802130:	83 ec 04             	sub    $0x4,%esp
  802133:	68 30 3b 80 00       	push   $0x803b30
  802138:	6a 5c                	push   $0x5c
  80213a:	68 53 3b 80 00       	push   $0x803b53
  80213f:	e8 3b e1 ff ff       	call   80027f <_panic>
  802144:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80214a:	8b 45 08             	mov    0x8(%ebp),%eax
  80214d:	89 10                	mov    %edx,(%eax)
  80214f:	8b 45 08             	mov    0x8(%ebp),%eax
  802152:	8b 00                	mov    (%eax),%eax
  802154:	85 c0                	test   %eax,%eax
  802156:	74 0d                	je     802165 <insert_sorted_allocList+0x58>
  802158:	a1 40 40 80 00       	mov    0x804040,%eax
  80215d:	8b 55 08             	mov    0x8(%ebp),%edx
  802160:	89 50 04             	mov    %edx,0x4(%eax)
  802163:	eb 08                	jmp    80216d <insert_sorted_allocList+0x60>
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	a3 44 40 80 00       	mov    %eax,0x804044
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	a3 40 40 80 00       	mov    %eax,0x804040
  802175:	8b 45 08             	mov    0x8(%ebp),%eax
  802178:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80217f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802184:	40                   	inc    %eax
  802185:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80218a:	e9 7b 01 00 00       	jmp    80230a <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80218f:	a1 44 40 80 00       	mov    0x804044,%eax
  802194:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802197:	a1 40 40 80 00       	mov    0x804040,%eax
  80219c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80219f:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a2:	8b 50 08             	mov    0x8(%eax),%edx
  8021a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a8:	8b 40 08             	mov    0x8(%eax),%eax
  8021ab:	39 c2                	cmp    %eax,%edx
  8021ad:	76 65                	jbe    802214 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8021af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021b3:	75 14                	jne    8021c9 <insert_sorted_allocList+0xbc>
  8021b5:	83 ec 04             	sub    $0x4,%esp
  8021b8:	68 6c 3b 80 00       	push   $0x803b6c
  8021bd:	6a 64                	push   $0x64
  8021bf:	68 53 3b 80 00       	push   $0x803b53
  8021c4:	e8 b6 e0 ff ff       	call   80027f <_panic>
  8021c9:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	89 50 04             	mov    %edx,0x4(%eax)
  8021d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d8:	8b 40 04             	mov    0x4(%eax),%eax
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	74 0c                	je     8021eb <insert_sorted_allocList+0xde>
  8021df:	a1 44 40 80 00       	mov    0x804044,%eax
  8021e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021e7:	89 10                	mov    %edx,(%eax)
  8021e9:	eb 08                	jmp    8021f3 <insert_sorted_allocList+0xe6>
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	a3 44 40 80 00       	mov    %eax,0x804044
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802204:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802209:	40                   	inc    %eax
  80220a:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80220f:	e9 f6 00 00 00       	jmp    80230a <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	8b 50 08             	mov    0x8(%eax),%edx
  80221a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80221d:	8b 40 08             	mov    0x8(%eax),%eax
  802220:	39 c2                	cmp    %eax,%edx
  802222:	73 65                	jae    802289 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802224:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802228:	75 14                	jne    80223e <insert_sorted_allocList+0x131>
  80222a:	83 ec 04             	sub    $0x4,%esp
  80222d:	68 30 3b 80 00       	push   $0x803b30
  802232:	6a 68                	push   $0x68
  802234:	68 53 3b 80 00       	push   $0x803b53
  802239:	e8 41 e0 ff ff       	call   80027f <_panic>
  80223e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	89 10                	mov    %edx,(%eax)
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	8b 00                	mov    (%eax),%eax
  80224e:	85 c0                	test   %eax,%eax
  802250:	74 0d                	je     80225f <insert_sorted_allocList+0x152>
  802252:	a1 40 40 80 00       	mov    0x804040,%eax
  802257:	8b 55 08             	mov    0x8(%ebp),%edx
  80225a:	89 50 04             	mov    %edx,0x4(%eax)
  80225d:	eb 08                	jmp    802267 <insert_sorted_allocList+0x15a>
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	a3 44 40 80 00       	mov    %eax,0x804044
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	a3 40 40 80 00       	mov    %eax,0x804040
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802279:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80227e:	40                   	inc    %eax
  80227f:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802284:	e9 81 00 00 00       	jmp    80230a <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802289:	a1 40 40 80 00       	mov    0x804040,%eax
  80228e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802291:	eb 51                	jmp    8022e4 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	8b 50 08             	mov    0x8(%eax),%edx
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 40 08             	mov    0x8(%eax),%eax
  80229f:	39 c2                	cmp    %eax,%edx
  8022a1:	73 39                	jae    8022dc <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8022a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a6:	8b 40 04             	mov    0x4(%eax),%eax
  8022a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8022ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022af:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b2:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8022b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022ba:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8022c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022cb:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8022ce:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022d3:	40                   	inc    %eax
  8022d4:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8022d9:	90                   	nop
				}
			}
		 }

	}
}
  8022da:	eb 2e                	jmp    80230a <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022dc:	a1 48 40 80 00       	mov    0x804048,%eax
  8022e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e8:	74 07                	je     8022f1 <insert_sorted_allocList+0x1e4>
  8022ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ed:	8b 00                	mov    (%eax),%eax
  8022ef:	eb 05                	jmp    8022f6 <insert_sorted_allocList+0x1e9>
  8022f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022f6:	a3 48 40 80 00       	mov    %eax,0x804048
  8022fb:	a1 48 40 80 00       	mov    0x804048,%eax
  802300:	85 c0                	test   %eax,%eax
  802302:	75 8f                	jne    802293 <insert_sorted_allocList+0x186>
  802304:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802308:	75 89                	jne    802293 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80230a:	90                   	nop
  80230b:	c9                   	leave  
  80230c:	c3                   	ret    

0080230d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80230d:	55                   	push   %ebp
  80230e:	89 e5                	mov    %esp,%ebp
  802310:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802313:	a1 38 41 80 00       	mov    0x804138,%eax
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231b:	e9 76 01 00 00       	jmp    802496 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 40 0c             	mov    0xc(%eax),%eax
  802326:	3b 45 08             	cmp    0x8(%ebp),%eax
  802329:	0f 85 8a 00 00 00    	jne    8023b9 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80232f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802333:	75 17                	jne    80234c <alloc_block_FF+0x3f>
  802335:	83 ec 04             	sub    $0x4,%esp
  802338:	68 8f 3b 80 00       	push   $0x803b8f
  80233d:	68 8a 00 00 00       	push   $0x8a
  802342:	68 53 3b 80 00       	push   $0x803b53
  802347:	e8 33 df ff ff       	call   80027f <_panic>
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 00                	mov    (%eax),%eax
  802351:	85 c0                	test   %eax,%eax
  802353:	74 10                	je     802365 <alloc_block_FF+0x58>
  802355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802358:	8b 00                	mov    (%eax),%eax
  80235a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235d:	8b 52 04             	mov    0x4(%edx),%edx
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	eb 0b                	jmp    802370 <alloc_block_FF+0x63>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 40 04             	mov    0x4(%eax),%eax
  80236b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802370:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802373:	8b 40 04             	mov    0x4(%eax),%eax
  802376:	85 c0                	test   %eax,%eax
  802378:	74 0f                	je     802389 <alloc_block_FF+0x7c>
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 40 04             	mov    0x4(%eax),%eax
  802380:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802383:	8b 12                	mov    (%edx),%edx
  802385:	89 10                	mov    %edx,(%eax)
  802387:	eb 0a                	jmp    802393 <alloc_block_FF+0x86>
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 00                	mov    (%eax),%eax
  80238e:	a3 38 41 80 00       	mov    %eax,0x804138
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023a6:	a1 44 41 80 00       	mov    0x804144,%eax
  8023ab:	48                   	dec    %eax
  8023ac:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	e9 10 01 00 00       	jmp    8024c9 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023c2:	0f 86 c6 00 00 00    	jbe    80248e <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8023c8:	a1 48 41 80 00       	mov    0x804148,%eax
  8023cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8023d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023d4:	75 17                	jne    8023ed <alloc_block_FF+0xe0>
  8023d6:	83 ec 04             	sub    $0x4,%esp
  8023d9:	68 8f 3b 80 00       	push   $0x803b8f
  8023de:	68 90 00 00 00       	push   $0x90
  8023e3:	68 53 3b 80 00       	push   $0x803b53
  8023e8:	e8 92 de ff ff       	call   80027f <_panic>
  8023ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f0:	8b 00                	mov    (%eax),%eax
  8023f2:	85 c0                	test   %eax,%eax
  8023f4:	74 10                	je     802406 <alloc_block_FF+0xf9>
  8023f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f9:	8b 00                	mov    (%eax),%eax
  8023fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023fe:	8b 52 04             	mov    0x4(%edx),%edx
  802401:	89 50 04             	mov    %edx,0x4(%eax)
  802404:	eb 0b                	jmp    802411 <alloc_block_FF+0x104>
  802406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802409:	8b 40 04             	mov    0x4(%eax),%eax
  80240c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802411:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802414:	8b 40 04             	mov    0x4(%eax),%eax
  802417:	85 c0                	test   %eax,%eax
  802419:	74 0f                	je     80242a <alloc_block_FF+0x11d>
  80241b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802424:	8b 12                	mov    (%edx),%edx
  802426:	89 10                	mov    %edx,(%eax)
  802428:	eb 0a                	jmp    802434 <alloc_block_FF+0x127>
  80242a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242d:	8b 00                	mov    (%eax),%eax
  80242f:	a3 48 41 80 00       	mov    %eax,0x804148
  802434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802437:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80243d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802440:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802447:	a1 54 41 80 00       	mov    0x804154,%eax
  80244c:	48                   	dec    %eax
  80244d:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802455:	8b 55 08             	mov    0x8(%ebp),%edx
  802458:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 50 08             	mov    0x8(%eax),%edx
  802461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802464:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	8b 50 08             	mov    0x8(%eax),%edx
  80246d:	8b 45 08             	mov    0x8(%ebp),%eax
  802470:	01 c2                	add    %eax,%edx
  802472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802475:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 40 0c             	mov    0xc(%eax),%eax
  80247e:	2b 45 08             	sub    0x8(%ebp),%eax
  802481:	89 c2                	mov    %eax,%edx
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248c:	eb 3b                	jmp    8024c9 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80248e:	a1 40 41 80 00       	mov    0x804140,%eax
  802493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249a:	74 07                	je     8024a3 <alloc_block_FF+0x196>
  80249c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249f:	8b 00                	mov    (%eax),%eax
  8024a1:	eb 05                	jmp    8024a8 <alloc_block_FF+0x19b>
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	a3 40 41 80 00       	mov    %eax,0x804140
  8024ad:	a1 40 41 80 00       	mov    0x804140,%eax
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	0f 85 66 fe ff ff    	jne    802320 <alloc_block_FF+0x13>
  8024ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024be:	0f 85 5c fe ff ff    	jne    802320 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8024c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c9:	c9                   	leave  
  8024ca:	c3                   	ret    

008024cb <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024cb:	55                   	push   %ebp
  8024cc:	89 e5                	mov    %esp,%ebp
  8024ce:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8024d1:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8024d8:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8024df:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8024e6:	a1 38 41 80 00       	mov    0x804138,%eax
  8024eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ee:	e9 cf 00 00 00       	jmp    8025c2 <alloc_block_BF+0xf7>
		{
			c++;
  8024f3:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024ff:	0f 85 8a 00 00 00    	jne    80258f <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802509:	75 17                	jne    802522 <alloc_block_BF+0x57>
  80250b:	83 ec 04             	sub    $0x4,%esp
  80250e:	68 8f 3b 80 00       	push   $0x803b8f
  802513:	68 a8 00 00 00       	push   $0xa8
  802518:	68 53 3b 80 00       	push   $0x803b53
  80251d:	e8 5d dd ff ff       	call   80027f <_panic>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	85 c0                	test   %eax,%eax
  802529:	74 10                	je     80253b <alloc_block_BF+0x70>
  80252b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252e:	8b 00                	mov    (%eax),%eax
  802530:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802533:	8b 52 04             	mov    0x4(%edx),%edx
  802536:	89 50 04             	mov    %edx,0x4(%eax)
  802539:	eb 0b                	jmp    802546 <alloc_block_BF+0x7b>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 40 04             	mov    0x4(%eax),%eax
  802541:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802549:	8b 40 04             	mov    0x4(%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	74 0f                	je     80255f <alloc_block_BF+0x94>
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 40 04             	mov    0x4(%eax),%eax
  802556:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802559:	8b 12                	mov    (%edx),%edx
  80255b:	89 10                	mov    %edx,(%eax)
  80255d:	eb 0a                	jmp    802569 <alloc_block_BF+0x9e>
  80255f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802562:	8b 00                	mov    (%eax),%eax
  802564:	a3 38 41 80 00       	mov    %eax,0x804138
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257c:	a1 44 41 80 00       	mov    0x804144,%eax
  802581:	48                   	dec    %eax
  802582:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	e9 85 01 00 00       	jmp    802714 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 0c             	mov    0xc(%eax),%eax
  802595:	3b 45 08             	cmp    0x8(%ebp),%eax
  802598:	76 20                	jbe    8025ba <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  80259a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259d:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8025a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8025a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025ac:	73 0c                	jae    8025ba <alloc_block_BF+0xef>
				{
					ma=tempi;
  8025ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8025b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025ba:	a1 40 41 80 00       	mov    0x804140,%eax
  8025bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c6:	74 07                	je     8025cf <alloc_block_BF+0x104>
  8025c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	eb 05                	jmp    8025d4 <alloc_block_BF+0x109>
  8025cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025d4:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d9:	a1 40 41 80 00       	mov    0x804140,%eax
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	0f 85 0d ff ff ff    	jne    8024f3 <alloc_block_BF+0x28>
  8025e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ea:	0f 85 03 ff ff ff    	jne    8024f3 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8025f0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8025fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ff:	e9 dd 00 00 00       	jmp    8026e1 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802604:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802607:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80260a:	0f 85 c6 00 00 00    	jne    8026d6 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802610:	a1 48 41 80 00       	mov    0x804148,%eax
  802615:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802618:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80261c:	75 17                	jne    802635 <alloc_block_BF+0x16a>
  80261e:	83 ec 04             	sub    $0x4,%esp
  802621:	68 8f 3b 80 00       	push   $0x803b8f
  802626:	68 bb 00 00 00       	push   $0xbb
  80262b:	68 53 3b 80 00       	push   $0x803b53
  802630:	e8 4a dc ff ff       	call   80027f <_panic>
  802635:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802638:	8b 00                	mov    (%eax),%eax
  80263a:	85 c0                	test   %eax,%eax
  80263c:	74 10                	je     80264e <alloc_block_BF+0x183>
  80263e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802641:	8b 00                	mov    (%eax),%eax
  802643:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802646:	8b 52 04             	mov    0x4(%edx),%edx
  802649:	89 50 04             	mov    %edx,0x4(%eax)
  80264c:	eb 0b                	jmp    802659 <alloc_block_BF+0x18e>
  80264e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802651:	8b 40 04             	mov    0x4(%eax),%eax
  802654:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802659:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265c:	8b 40 04             	mov    0x4(%eax),%eax
  80265f:	85 c0                	test   %eax,%eax
  802661:	74 0f                	je     802672 <alloc_block_BF+0x1a7>
  802663:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802666:	8b 40 04             	mov    0x4(%eax),%eax
  802669:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80266c:	8b 12                	mov    (%edx),%edx
  80266e:	89 10                	mov    %edx,(%eax)
  802670:	eb 0a                	jmp    80267c <alloc_block_BF+0x1b1>
  802672:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802675:	8b 00                	mov    (%eax),%eax
  802677:	a3 48 41 80 00       	mov    %eax,0x804148
  80267c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802688:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268f:	a1 54 41 80 00       	mov    0x804154,%eax
  802694:	48                   	dec    %eax
  802695:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  80269a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269d:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a0:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 50 08             	mov    0x8(%eax),%edx
  8026a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ac:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	8b 50 08             	mov    0x8(%eax),%edx
  8026b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b8:	01 c2                	add    %eax,%edx
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c6:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c9:	89 c2                	mov    %eax,%edx
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8026d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d4:	eb 3e                	jmp    802714 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8026d6:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026d9:	a1 40 41 80 00       	mov    0x804140,%eax
  8026de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e5:	74 07                	je     8026ee <alloc_block_BF+0x223>
  8026e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ea:	8b 00                	mov    (%eax),%eax
  8026ec:	eb 05                	jmp    8026f3 <alloc_block_BF+0x228>
  8026ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f3:	a3 40 41 80 00       	mov    %eax,0x804140
  8026f8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	0f 85 ff fe ff ff    	jne    802604 <alloc_block_BF+0x139>
  802705:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802709:	0f 85 f5 fe ff ff    	jne    802604 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80270f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802714:	c9                   	leave  
  802715:	c3                   	ret    

00802716 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802716:	55                   	push   %ebp
  802717:	89 e5                	mov    %esp,%ebp
  802719:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80271c:	a1 28 40 80 00       	mov    0x804028,%eax
  802721:	85 c0                	test   %eax,%eax
  802723:	75 14                	jne    802739 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802725:	a1 38 41 80 00       	mov    0x804138,%eax
  80272a:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  80272f:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802736:	00 00 00 
	}
	uint32 c=1;
  802739:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802740:	a1 60 41 80 00       	mov    0x804160,%eax
  802745:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802748:	e9 b3 01 00 00       	jmp    802900 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802750:	8b 40 0c             	mov    0xc(%eax),%eax
  802753:	3b 45 08             	cmp    0x8(%ebp),%eax
  802756:	0f 85 a9 00 00 00    	jne    802805 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80275c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80275f:	8b 00                	mov    (%eax),%eax
  802761:	85 c0                	test   %eax,%eax
  802763:	75 0c                	jne    802771 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802765:	a1 38 41 80 00       	mov    0x804138,%eax
  80276a:	a3 60 41 80 00       	mov    %eax,0x804160
  80276f:	eb 0a                	jmp    80277b <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802771:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802774:	8b 00                	mov    (%eax),%eax
  802776:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  80277b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80277f:	75 17                	jne    802798 <alloc_block_NF+0x82>
  802781:	83 ec 04             	sub    $0x4,%esp
  802784:	68 8f 3b 80 00       	push   $0x803b8f
  802789:	68 e3 00 00 00       	push   $0xe3
  80278e:	68 53 3b 80 00       	push   $0x803b53
  802793:	e8 e7 da ff ff       	call   80027f <_panic>
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	8b 00                	mov    (%eax),%eax
  80279d:	85 c0                	test   %eax,%eax
  80279f:	74 10                	je     8027b1 <alloc_block_NF+0x9b>
  8027a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a4:	8b 00                	mov    (%eax),%eax
  8027a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a9:	8b 52 04             	mov    0x4(%edx),%edx
  8027ac:	89 50 04             	mov    %edx,0x4(%eax)
  8027af:	eb 0b                	jmp    8027bc <alloc_block_NF+0xa6>
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	8b 40 04             	mov    0x4(%eax),%eax
  8027b7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bf:	8b 40 04             	mov    0x4(%eax),%eax
  8027c2:	85 c0                	test   %eax,%eax
  8027c4:	74 0f                	je     8027d5 <alloc_block_NF+0xbf>
  8027c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c9:	8b 40 04             	mov    0x4(%eax),%eax
  8027cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027cf:	8b 12                	mov    (%edx),%edx
  8027d1:	89 10                	mov    %edx,(%eax)
  8027d3:	eb 0a                	jmp    8027df <alloc_block_NF+0xc9>
  8027d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d8:	8b 00                	mov    (%eax),%eax
  8027da:	a3 38 41 80 00       	mov    %eax,0x804138
  8027df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027f2:	a1 44 41 80 00       	mov    0x804144,%eax
  8027f7:	48                   	dec    %eax
  8027f8:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  8027fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802800:	e9 0e 01 00 00       	jmp    802913 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802808:	8b 40 0c             	mov    0xc(%eax),%eax
  80280b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280e:	0f 86 ce 00 00 00    	jbe    8028e2 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802814:	a1 48 41 80 00       	mov    0x804148,%eax
  802819:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80281c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802820:	75 17                	jne    802839 <alloc_block_NF+0x123>
  802822:	83 ec 04             	sub    $0x4,%esp
  802825:	68 8f 3b 80 00       	push   $0x803b8f
  80282a:	68 e9 00 00 00       	push   $0xe9
  80282f:	68 53 3b 80 00       	push   $0x803b53
  802834:	e8 46 da ff ff       	call   80027f <_panic>
  802839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283c:	8b 00                	mov    (%eax),%eax
  80283e:	85 c0                	test   %eax,%eax
  802840:	74 10                	je     802852 <alloc_block_NF+0x13c>
  802842:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802845:	8b 00                	mov    (%eax),%eax
  802847:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80284a:	8b 52 04             	mov    0x4(%edx),%edx
  80284d:	89 50 04             	mov    %edx,0x4(%eax)
  802850:	eb 0b                	jmp    80285d <alloc_block_NF+0x147>
  802852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80285d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	85 c0                	test   %eax,%eax
  802865:	74 0f                	je     802876 <alloc_block_NF+0x160>
  802867:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802870:	8b 12                	mov    (%edx),%edx
  802872:	89 10                	mov    %edx,(%eax)
  802874:	eb 0a                	jmp    802880 <alloc_block_NF+0x16a>
  802876:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802879:	8b 00                	mov    (%eax),%eax
  80287b:	a3 48 41 80 00       	mov    %eax,0x804148
  802880:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802883:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802893:	a1 54 41 80 00       	mov    0x804154,%eax
  802898:	48                   	dec    %eax
  802899:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  80289e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a4:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8028a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028aa:	8b 50 08             	mov    0x8(%eax),%edx
  8028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b0:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8028b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b6:	8b 50 08             	mov    0x8(%eax),%edx
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	01 c2                	add    %eax,%edx
  8028be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c1:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8028c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ca:	2b 45 08             	sub    0x8(%ebp),%eax
  8028cd:	89 c2                	mov    %eax,%edx
  8028cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d2:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8028d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d8:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8028dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e0:	eb 31                	jmp    802913 <alloc_block_NF+0x1fd>
			 }
		 c++;
  8028e2:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8028e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e8:	8b 00                	mov    (%eax),%eax
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	75 0a                	jne    8028f8 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8028ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028f6:	eb 08                	jmp    802900 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8028f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802900:	a1 44 41 80 00       	mov    0x804144,%eax
  802905:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802908:	0f 85 3f fe ff ff    	jne    80274d <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  80290e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
  802918:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80291b:	a1 44 41 80 00       	mov    0x804144,%eax
  802920:	85 c0                	test   %eax,%eax
  802922:	75 68                	jne    80298c <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802924:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802928:	75 17                	jne    802941 <insert_sorted_with_merge_freeList+0x2c>
  80292a:	83 ec 04             	sub    $0x4,%esp
  80292d:	68 30 3b 80 00       	push   $0x803b30
  802932:	68 0e 01 00 00       	push   $0x10e
  802937:	68 53 3b 80 00       	push   $0x803b53
  80293c:	e8 3e d9 ff ff       	call   80027f <_panic>
  802941:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802947:	8b 45 08             	mov    0x8(%ebp),%eax
  80294a:	89 10                	mov    %edx,(%eax)
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	8b 00                	mov    (%eax),%eax
  802951:	85 c0                	test   %eax,%eax
  802953:	74 0d                	je     802962 <insert_sorted_with_merge_freeList+0x4d>
  802955:	a1 38 41 80 00       	mov    0x804138,%eax
  80295a:	8b 55 08             	mov    0x8(%ebp),%edx
  80295d:	89 50 04             	mov    %edx,0x4(%eax)
  802960:	eb 08                	jmp    80296a <insert_sorted_with_merge_freeList+0x55>
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	a3 38 41 80 00       	mov    %eax,0x804138
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80297c:	a1 44 41 80 00       	mov    0x804144,%eax
  802981:	40                   	inc    %eax
  802982:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802987:	e9 8c 06 00 00       	jmp    803018 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  80298c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802991:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802994:	a1 38 41 80 00       	mov    0x804138,%eax
  802999:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  80299c:	8b 45 08             	mov    0x8(%ebp),%eax
  80299f:	8b 50 08             	mov    0x8(%eax),%edx
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 40 08             	mov    0x8(%eax),%eax
  8029a8:	39 c2                	cmp    %eax,%edx
  8029aa:	0f 86 14 01 00 00    	jbe    802ac4 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8029b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b3:	8b 50 0c             	mov    0xc(%eax),%edx
  8029b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b9:	8b 40 08             	mov    0x8(%eax),%eax
  8029bc:	01 c2                	add    %eax,%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	8b 40 08             	mov    0x8(%eax),%eax
  8029c4:	39 c2                	cmp    %eax,%edx
  8029c6:	0f 85 90 00 00 00    	jne    802a5c <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8029cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cf:	8b 50 0c             	mov    0xc(%eax),%edx
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d8:	01 c2                	add    %eax,%edx
  8029da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dd:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f8:	75 17                	jne    802a11 <insert_sorted_with_merge_freeList+0xfc>
  8029fa:	83 ec 04             	sub    $0x4,%esp
  8029fd:	68 30 3b 80 00       	push   $0x803b30
  802a02:	68 1b 01 00 00       	push   $0x11b
  802a07:	68 53 3b 80 00       	push   $0x803b53
  802a0c:	e8 6e d8 ff ff       	call   80027f <_panic>
  802a11:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	89 10                	mov    %edx,(%eax)
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	74 0d                	je     802a32 <insert_sorted_with_merge_freeList+0x11d>
  802a25:	a1 48 41 80 00       	mov    0x804148,%eax
  802a2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2d:	89 50 04             	mov    %edx,0x4(%eax)
  802a30:	eb 08                	jmp    802a3a <insert_sorted_with_merge_freeList+0x125>
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	a3 48 41 80 00       	mov    %eax,0x804148
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4c:	a1 54 41 80 00       	mov    0x804154,%eax
  802a51:	40                   	inc    %eax
  802a52:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802a57:	e9 bc 05 00 00       	jmp    803018 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a5c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a60:	75 17                	jne    802a79 <insert_sorted_with_merge_freeList+0x164>
  802a62:	83 ec 04             	sub    $0x4,%esp
  802a65:	68 6c 3b 80 00       	push   $0x803b6c
  802a6a:	68 1f 01 00 00       	push   $0x11f
  802a6f:	68 53 3b 80 00       	push   $0x803b53
  802a74:	e8 06 d8 ff ff       	call   80027f <_panic>
  802a79:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	89 50 04             	mov    %edx,0x4(%eax)
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	8b 40 04             	mov    0x4(%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 0c                	je     802a9b <insert_sorted_with_merge_freeList+0x186>
  802a8f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a94:	8b 55 08             	mov    0x8(%ebp),%edx
  802a97:	89 10                	mov    %edx,(%eax)
  802a99:	eb 08                	jmp    802aa3 <insert_sorted_with_merge_freeList+0x18e>
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	a3 38 41 80 00       	mov    %eax,0x804138
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aab:	8b 45 08             	mov    0x8(%ebp),%eax
  802aae:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab4:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab9:	40                   	inc    %eax
  802aba:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802abf:	e9 54 05 00 00       	jmp    803018 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	8b 50 08             	mov    0x8(%eax),%edx
  802aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802acd:	8b 40 08             	mov    0x8(%eax),%eax
  802ad0:	39 c2                	cmp    %eax,%edx
  802ad2:	0f 83 20 01 00 00    	jae    802bf8 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  802adb:	8b 50 0c             	mov    0xc(%eax),%edx
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	8b 40 08             	mov    0x8(%eax),%eax
  802ae4:	01 c2                	add    %eax,%edx
  802ae6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae9:	8b 40 08             	mov    0x8(%eax),%eax
  802aec:	39 c2                	cmp    %eax,%edx
  802aee:	0f 85 9c 00 00 00    	jne    802b90 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 50 08             	mov    0x8(%eax),%edx
  802afa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afd:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b03:	8b 50 0c             	mov    0xc(%eax),%edx
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0c:	01 c2                	add    %eax,%edx
  802b0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b11:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b14:	8b 45 08             	mov    0x8(%ebp),%eax
  802b17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2c:	75 17                	jne    802b45 <insert_sorted_with_merge_freeList+0x230>
  802b2e:	83 ec 04             	sub    $0x4,%esp
  802b31:	68 30 3b 80 00       	push   $0x803b30
  802b36:	68 2a 01 00 00       	push   $0x12a
  802b3b:	68 53 3b 80 00       	push   $0x803b53
  802b40:	e8 3a d7 ff ff       	call   80027f <_panic>
  802b45:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	89 10                	mov    %edx,(%eax)
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	8b 00                	mov    (%eax),%eax
  802b55:	85 c0                	test   %eax,%eax
  802b57:	74 0d                	je     802b66 <insert_sorted_with_merge_freeList+0x251>
  802b59:	a1 48 41 80 00       	mov    0x804148,%eax
  802b5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b61:	89 50 04             	mov    %edx,0x4(%eax)
  802b64:	eb 08                	jmp    802b6e <insert_sorted_with_merge_freeList+0x259>
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	a3 48 41 80 00       	mov    %eax,0x804148
  802b76:	8b 45 08             	mov    0x8(%ebp),%eax
  802b79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b80:	a1 54 41 80 00       	mov    0x804154,%eax
  802b85:	40                   	inc    %eax
  802b86:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b8b:	e9 88 04 00 00       	jmp    803018 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b94:	75 17                	jne    802bad <insert_sorted_with_merge_freeList+0x298>
  802b96:	83 ec 04             	sub    $0x4,%esp
  802b99:	68 30 3b 80 00       	push   $0x803b30
  802b9e:	68 2e 01 00 00       	push   $0x12e
  802ba3:	68 53 3b 80 00       	push   $0x803b53
  802ba8:	e8 d2 d6 ff ff       	call   80027f <_panic>
  802bad:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	89 10                	mov    %edx,(%eax)
  802bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbb:	8b 00                	mov    (%eax),%eax
  802bbd:	85 c0                	test   %eax,%eax
  802bbf:	74 0d                	je     802bce <insert_sorted_with_merge_freeList+0x2b9>
  802bc1:	a1 38 41 80 00       	mov    0x804138,%eax
  802bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc9:	89 50 04             	mov    %edx,0x4(%eax)
  802bcc:	eb 08                	jmp    802bd6 <insert_sorted_with_merge_freeList+0x2c1>
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	a3 38 41 80 00       	mov    %eax,0x804138
  802bde:	8b 45 08             	mov    0x8(%ebp),%eax
  802be1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be8:	a1 44 41 80 00       	mov    0x804144,%eax
  802bed:	40                   	inc    %eax
  802bee:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bf3:	e9 20 04 00 00       	jmp    803018 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802bf8:	a1 38 41 80 00       	mov    0x804138,%eax
  802bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c00:	e9 e2 03 00 00       	jmp    802fe7 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	8b 50 08             	mov    0x8(%eax),%edx
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 08             	mov    0x8(%eax),%eax
  802c11:	39 c2                	cmp    %eax,%edx
  802c13:	0f 83 c6 03 00 00    	jae    802fdf <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 40 04             	mov    0x4(%eax),%eax
  802c1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c25:	8b 50 08             	mov    0x8(%eax),%edx
  802c28:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2e:	01 d0                	add    %edx,%eax
  802c30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	8b 50 0c             	mov    0xc(%eax),%edx
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	8b 40 08             	mov    0x8(%eax),%eax
  802c3f:	01 d0                	add    %edx,%eax
  802c41:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	8b 40 08             	mov    0x8(%eax),%eax
  802c4a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c4d:	74 7a                	je     802cc9 <insert_sorted_with_merge_freeList+0x3b4>
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 08             	mov    0x8(%eax),%eax
  802c55:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c58:	74 6f                	je     802cc9 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802c5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c5e:	74 06                	je     802c66 <insert_sorted_with_merge_freeList+0x351>
  802c60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c64:	75 17                	jne    802c7d <insert_sorted_with_merge_freeList+0x368>
  802c66:	83 ec 04             	sub    $0x4,%esp
  802c69:	68 b0 3b 80 00       	push   $0x803bb0
  802c6e:	68 43 01 00 00       	push   $0x143
  802c73:	68 53 3b 80 00       	push   $0x803b53
  802c78:	e8 02 d6 ff ff       	call   80027f <_panic>
  802c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c80:	8b 50 04             	mov    0x4(%eax),%edx
  802c83:	8b 45 08             	mov    0x8(%ebp),%eax
  802c86:	89 50 04             	mov    %edx,0x4(%eax)
  802c89:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8f:	89 10                	mov    %edx,(%eax)
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	74 0d                	je     802ca8 <insert_sorted_with_merge_freeList+0x393>
  802c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ca1:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca4:	89 10                	mov    %edx,(%eax)
  802ca6:	eb 08                	jmp    802cb0 <insert_sorted_with_merge_freeList+0x39b>
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	a3 38 41 80 00       	mov    %eax,0x804138
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb6:	89 50 04             	mov    %edx,0x4(%eax)
  802cb9:	a1 44 41 80 00       	mov    0x804144,%eax
  802cbe:	40                   	inc    %eax
  802cbf:	a3 44 41 80 00       	mov    %eax,0x804144
  802cc4:	e9 14 03 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	8b 40 08             	mov    0x8(%eax),%eax
  802ccf:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cd2:	0f 85 a0 01 00 00    	jne    802e78 <insert_sorted_with_merge_freeList+0x563>
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	8b 40 08             	mov    0x8(%eax),%eax
  802cde:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ce1:	0f 85 91 01 00 00    	jne    802e78 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cea:	8b 50 0c             	mov    0xc(%eax),%edx
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	8b 48 0c             	mov    0xc(%eax),%ecx
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf9:	01 c8                	add    %ecx,%eax
  802cfb:	01 c2                	add    %eax,%edx
  802cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d00:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2f:	75 17                	jne    802d48 <insert_sorted_with_merge_freeList+0x433>
  802d31:	83 ec 04             	sub    $0x4,%esp
  802d34:	68 30 3b 80 00       	push   $0x803b30
  802d39:	68 4d 01 00 00       	push   $0x14d
  802d3e:	68 53 3b 80 00       	push   $0x803b53
  802d43:	e8 37 d5 ff ff       	call   80027f <_panic>
  802d48:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	89 10                	mov    %edx,(%eax)
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 00                	mov    (%eax),%eax
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	74 0d                	je     802d69 <insert_sorted_with_merge_freeList+0x454>
  802d5c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d61:	8b 55 08             	mov    0x8(%ebp),%edx
  802d64:	89 50 04             	mov    %edx,0x4(%eax)
  802d67:	eb 08                	jmp    802d71 <insert_sorted_with_merge_freeList+0x45c>
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	a3 48 41 80 00       	mov    %eax,0x804148
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d83:	a1 54 41 80 00       	mov    0x804154,%eax
  802d88:	40                   	inc    %eax
  802d89:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802d8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d92:	75 17                	jne    802dab <insert_sorted_with_merge_freeList+0x496>
  802d94:	83 ec 04             	sub    $0x4,%esp
  802d97:	68 8f 3b 80 00       	push   $0x803b8f
  802d9c:	68 4e 01 00 00       	push   $0x14e
  802da1:	68 53 3b 80 00       	push   $0x803b53
  802da6:	e8 d4 d4 ff ff       	call   80027f <_panic>
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 00                	mov    (%eax),%eax
  802db0:	85 c0                	test   %eax,%eax
  802db2:	74 10                	je     802dc4 <insert_sorted_with_merge_freeList+0x4af>
  802db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db7:	8b 00                	mov    (%eax),%eax
  802db9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbc:	8b 52 04             	mov    0x4(%edx),%edx
  802dbf:	89 50 04             	mov    %edx,0x4(%eax)
  802dc2:	eb 0b                	jmp    802dcf <insert_sorted_with_merge_freeList+0x4ba>
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 40 04             	mov    0x4(%eax),%eax
  802dca:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd2:	8b 40 04             	mov    0x4(%eax),%eax
  802dd5:	85 c0                	test   %eax,%eax
  802dd7:	74 0f                	je     802de8 <insert_sorted_with_merge_freeList+0x4d3>
  802dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddc:	8b 40 04             	mov    0x4(%eax),%eax
  802ddf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802de2:	8b 12                	mov    (%edx),%edx
  802de4:	89 10                	mov    %edx,(%eax)
  802de6:	eb 0a                	jmp    802df2 <insert_sorted_with_merge_freeList+0x4dd>
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	8b 00                	mov    (%eax),%eax
  802ded:	a3 38 41 80 00       	mov    %eax,0x804138
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e05:	a1 44 41 80 00       	mov    0x804144,%eax
  802e0a:	48                   	dec    %eax
  802e0b:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e14:	75 17                	jne    802e2d <insert_sorted_with_merge_freeList+0x518>
  802e16:	83 ec 04             	sub    $0x4,%esp
  802e19:	68 30 3b 80 00       	push   $0x803b30
  802e1e:	68 4f 01 00 00       	push   $0x14f
  802e23:	68 53 3b 80 00       	push   $0x803b53
  802e28:	e8 52 d4 ff ff       	call   80027f <_panic>
  802e2d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	89 10                	mov    %edx,(%eax)
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	85 c0                	test   %eax,%eax
  802e3f:	74 0d                	je     802e4e <insert_sorted_with_merge_freeList+0x539>
  802e41:	a1 48 41 80 00       	mov    0x804148,%eax
  802e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e49:	89 50 04             	mov    %edx,0x4(%eax)
  802e4c:	eb 08                	jmp    802e56 <insert_sorted_with_merge_freeList+0x541>
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	a3 48 41 80 00       	mov    %eax,0x804148
  802e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e68:	a1 54 41 80 00       	mov    0x804154,%eax
  802e6d:	40                   	inc    %eax
  802e6e:	a3 54 41 80 00       	mov    %eax,0x804154
  802e73:	e9 65 01 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 40 08             	mov    0x8(%eax),%eax
  802e7e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e81:	0f 85 9f 00 00 00    	jne    802f26 <insert_sorted_with_merge_freeList+0x611>
  802e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8a:	8b 40 08             	mov    0x8(%eax),%eax
  802e8d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e90:	0f 84 90 00 00 00    	je     802f26 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e99:	8b 50 0c             	mov    0xc(%eax),%edx
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea2:	01 c2                	add    %eax,%edx
  802ea4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea7:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ead:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec2:	75 17                	jne    802edb <insert_sorted_with_merge_freeList+0x5c6>
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	68 30 3b 80 00       	push   $0x803b30
  802ecc:	68 58 01 00 00       	push   $0x158
  802ed1:	68 53 3b 80 00       	push   $0x803b53
  802ed6:	e8 a4 d3 ff ff       	call   80027f <_panic>
  802edb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	89 10                	mov    %edx,(%eax)
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0d                	je     802efc <insert_sorted_with_merge_freeList+0x5e7>
  802eef:	a1 48 41 80 00       	mov    0x804148,%eax
  802ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef7:	89 50 04             	mov    %edx,0x4(%eax)
  802efa:	eb 08                	jmp    802f04 <insert_sorted_with_merge_freeList+0x5ef>
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	a3 48 41 80 00       	mov    %eax,0x804148
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 54 41 80 00       	mov    0x804154,%eax
  802f1b:	40                   	inc    %eax
  802f1c:	a3 54 41 80 00       	mov    %eax,0x804154
  802f21:	e9 b7 00 00 00       	jmp    802fdd <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f26:	8b 45 08             	mov    0x8(%ebp),%eax
  802f29:	8b 40 08             	mov    0x8(%eax),%eax
  802f2c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f2f:	0f 84 e2 00 00 00    	je     803017 <insert_sorted_with_merge_freeList+0x702>
  802f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f38:	8b 40 08             	mov    0x8(%eax),%eax
  802f3b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f3e:	0f 85 d3 00 00 00    	jne    803017 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 50 08             	mov    0x8(%eax),%edx
  802f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4d:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 50 0c             	mov    0xc(%eax),%edx
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	8b 40 0c             	mov    0xc(%eax),%eax
  802f5c:	01 c2                	add    %eax,%edx
  802f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f61:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f64:	8b 45 08             	mov    0x8(%ebp),%eax
  802f67:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f7c:	75 17                	jne    802f95 <insert_sorted_with_merge_freeList+0x680>
  802f7e:	83 ec 04             	sub    $0x4,%esp
  802f81:	68 30 3b 80 00       	push   $0x803b30
  802f86:	68 61 01 00 00       	push   $0x161
  802f8b:	68 53 3b 80 00       	push   $0x803b53
  802f90:	e8 ea d2 ff ff       	call   80027f <_panic>
  802f95:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	89 10                	mov    %edx,(%eax)
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	8b 00                	mov    (%eax),%eax
  802fa5:	85 c0                	test   %eax,%eax
  802fa7:	74 0d                	je     802fb6 <insert_sorted_with_merge_freeList+0x6a1>
  802fa9:	a1 48 41 80 00       	mov    0x804148,%eax
  802fae:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb1:	89 50 04             	mov    %edx,0x4(%eax)
  802fb4:	eb 08                	jmp    802fbe <insert_sorted_with_merge_freeList+0x6a9>
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	a3 48 41 80 00       	mov    %eax,0x804148
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd0:	a1 54 41 80 00       	mov    0x804154,%eax
  802fd5:	40                   	inc    %eax
  802fd6:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802fdb:	eb 3a                	jmp    803017 <insert_sorted_with_merge_freeList+0x702>
  802fdd:	eb 38                	jmp    803017 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802fdf:	a1 40 41 80 00       	mov    0x804140,%eax
  802fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802feb:	74 07                	je     802ff4 <insert_sorted_with_merge_freeList+0x6df>
  802fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	eb 05                	jmp    802ff9 <insert_sorted_with_merge_freeList+0x6e4>
  802ff4:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff9:	a3 40 41 80 00       	mov    %eax,0x804140
  802ffe:	a1 40 41 80 00       	mov    0x804140,%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	0f 85 fa fb ff ff    	jne    802c05 <insert_sorted_with_merge_freeList+0x2f0>
  80300b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300f:	0f 85 f0 fb ff ff    	jne    802c05 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803015:	eb 01                	jmp    803018 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803017:	90                   	nop
							}

						}
		          }
		}
}
  803018:	90                   	nop
  803019:	c9                   	leave  
  80301a:	c3                   	ret    
  80301b:	90                   	nop

0080301c <__udivdi3>:
  80301c:	55                   	push   %ebp
  80301d:	57                   	push   %edi
  80301e:	56                   	push   %esi
  80301f:	53                   	push   %ebx
  803020:	83 ec 1c             	sub    $0x1c,%esp
  803023:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803027:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80302b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80302f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803033:	89 ca                	mov    %ecx,%edx
  803035:	89 f8                	mov    %edi,%eax
  803037:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80303b:	85 f6                	test   %esi,%esi
  80303d:	75 2d                	jne    80306c <__udivdi3+0x50>
  80303f:	39 cf                	cmp    %ecx,%edi
  803041:	77 65                	ja     8030a8 <__udivdi3+0x8c>
  803043:	89 fd                	mov    %edi,%ebp
  803045:	85 ff                	test   %edi,%edi
  803047:	75 0b                	jne    803054 <__udivdi3+0x38>
  803049:	b8 01 00 00 00       	mov    $0x1,%eax
  80304e:	31 d2                	xor    %edx,%edx
  803050:	f7 f7                	div    %edi
  803052:	89 c5                	mov    %eax,%ebp
  803054:	31 d2                	xor    %edx,%edx
  803056:	89 c8                	mov    %ecx,%eax
  803058:	f7 f5                	div    %ebp
  80305a:	89 c1                	mov    %eax,%ecx
  80305c:	89 d8                	mov    %ebx,%eax
  80305e:	f7 f5                	div    %ebp
  803060:	89 cf                	mov    %ecx,%edi
  803062:	89 fa                	mov    %edi,%edx
  803064:	83 c4 1c             	add    $0x1c,%esp
  803067:	5b                   	pop    %ebx
  803068:	5e                   	pop    %esi
  803069:	5f                   	pop    %edi
  80306a:	5d                   	pop    %ebp
  80306b:	c3                   	ret    
  80306c:	39 ce                	cmp    %ecx,%esi
  80306e:	77 28                	ja     803098 <__udivdi3+0x7c>
  803070:	0f bd fe             	bsr    %esi,%edi
  803073:	83 f7 1f             	xor    $0x1f,%edi
  803076:	75 40                	jne    8030b8 <__udivdi3+0x9c>
  803078:	39 ce                	cmp    %ecx,%esi
  80307a:	72 0a                	jb     803086 <__udivdi3+0x6a>
  80307c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803080:	0f 87 9e 00 00 00    	ja     803124 <__udivdi3+0x108>
  803086:	b8 01 00 00 00       	mov    $0x1,%eax
  80308b:	89 fa                	mov    %edi,%edx
  80308d:	83 c4 1c             	add    $0x1c,%esp
  803090:	5b                   	pop    %ebx
  803091:	5e                   	pop    %esi
  803092:	5f                   	pop    %edi
  803093:	5d                   	pop    %ebp
  803094:	c3                   	ret    
  803095:	8d 76 00             	lea    0x0(%esi),%esi
  803098:	31 ff                	xor    %edi,%edi
  80309a:	31 c0                	xor    %eax,%eax
  80309c:	89 fa                	mov    %edi,%edx
  80309e:	83 c4 1c             	add    $0x1c,%esp
  8030a1:	5b                   	pop    %ebx
  8030a2:	5e                   	pop    %esi
  8030a3:	5f                   	pop    %edi
  8030a4:	5d                   	pop    %ebp
  8030a5:	c3                   	ret    
  8030a6:	66 90                	xchg   %ax,%ax
  8030a8:	89 d8                	mov    %ebx,%eax
  8030aa:	f7 f7                	div    %edi
  8030ac:	31 ff                	xor    %edi,%edi
  8030ae:	89 fa                	mov    %edi,%edx
  8030b0:	83 c4 1c             	add    $0x1c,%esp
  8030b3:	5b                   	pop    %ebx
  8030b4:	5e                   	pop    %esi
  8030b5:	5f                   	pop    %edi
  8030b6:	5d                   	pop    %ebp
  8030b7:	c3                   	ret    
  8030b8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030bd:	89 eb                	mov    %ebp,%ebx
  8030bf:	29 fb                	sub    %edi,%ebx
  8030c1:	89 f9                	mov    %edi,%ecx
  8030c3:	d3 e6                	shl    %cl,%esi
  8030c5:	89 c5                	mov    %eax,%ebp
  8030c7:	88 d9                	mov    %bl,%cl
  8030c9:	d3 ed                	shr    %cl,%ebp
  8030cb:	89 e9                	mov    %ebp,%ecx
  8030cd:	09 f1                	or     %esi,%ecx
  8030cf:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030d3:	89 f9                	mov    %edi,%ecx
  8030d5:	d3 e0                	shl    %cl,%eax
  8030d7:	89 c5                	mov    %eax,%ebp
  8030d9:	89 d6                	mov    %edx,%esi
  8030db:	88 d9                	mov    %bl,%cl
  8030dd:	d3 ee                	shr    %cl,%esi
  8030df:	89 f9                	mov    %edi,%ecx
  8030e1:	d3 e2                	shl    %cl,%edx
  8030e3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030e7:	88 d9                	mov    %bl,%cl
  8030e9:	d3 e8                	shr    %cl,%eax
  8030eb:	09 c2                	or     %eax,%edx
  8030ed:	89 d0                	mov    %edx,%eax
  8030ef:	89 f2                	mov    %esi,%edx
  8030f1:	f7 74 24 0c          	divl   0xc(%esp)
  8030f5:	89 d6                	mov    %edx,%esi
  8030f7:	89 c3                	mov    %eax,%ebx
  8030f9:	f7 e5                	mul    %ebp
  8030fb:	39 d6                	cmp    %edx,%esi
  8030fd:	72 19                	jb     803118 <__udivdi3+0xfc>
  8030ff:	74 0b                	je     80310c <__udivdi3+0xf0>
  803101:	89 d8                	mov    %ebx,%eax
  803103:	31 ff                	xor    %edi,%edi
  803105:	e9 58 ff ff ff       	jmp    803062 <__udivdi3+0x46>
  80310a:	66 90                	xchg   %ax,%ax
  80310c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803110:	89 f9                	mov    %edi,%ecx
  803112:	d3 e2                	shl    %cl,%edx
  803114:	39 c2                	cmp    %eax,%edx
  803116:	73 e9                	jae    803101 <__udivdi3+0xe5>
  803118:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80311b:	31 ff                	xor    %edi,%edi
  80311d:	e9 40 ff ff ff       	jmp    803062 <__udivdi3+0x46>
  803122:	66 90                	xchg   %ax,%ax
  803124:	31 c0                	xor    %eax,%eax
  803126:	e9 37 ff ff ff       	jmp    803062 <__udivdi3+0x46>
  80312b:	90                   	nop

0080312c <__umoddi3>:
  80312c:	55                   	push   %ebp
  80312d:	57                   	push   %edi
  80312e:	56                   	push   %esi
  80312f:	53                   	push   %ebx
  803130:	83 ec 1c             	sub    $0x1c,%esp
  803133:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803137:	8b 74 24 34          	mov    0x34(%esp),%esi
  80313b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80313f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803143:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803147:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80314b:	89 f3                	mov    %esi,%ebx
  80314d:	89 fa                	mov    %edi,%edx
  80314f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803153:	89 34 24             	mov    %esi,(%esp)
  803156:	85 c0                	test   %eax,%eax
  803158:	75 1a                	jne    803174 <__umoddi3+0x48>
  80315a:	39 f7                	cmp    %esi,%edi
  80315c:	0f 86 a2 00 00 00    	jbe    803204 <__umoddi3+0xd8>
  803162:	89 c8                	mov    %ecx,%eax
  803164:	89 f2                	mov    %esi,%edx
  803166:	f7 f7                	div    %edi
  803168:	89 d0                	mov    %edx,%eax
  80316a:	31 d2                	xor    %edx,%edx
  80316c:	83 c4 1c             	add    $0x1c,%esp
  80316f:	5b                   	pop    %ebx
  803170:	5e                   	pop    %esi
  803171:	5f                   	pop    %edi
  803172:	5d                   	pop    %ebp
  803173:	c3                   	ret    
  803174:	39 f0                	cmp    %esi,%eax
  803176:	0f 87 ac 00 00 00    	ja     803228 <__umoddi3+0xfc>
  80317c:	0f bd e8             	bsr    %eax,%ebp
  80317f:	83 f5 1f             	xor    $0x1f,%ebp
  803182:	0f 84 ac 00 00 00    	je     803234 <__umoddi3+0x108>
  803188:	bf 20 00 00 00       	mov    $0x20,%edi
  80318d:	29 ef                	sub    %ebp,%edi
  80318f:	89 fe                	mov    %edi,%esi
  803191:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803195:	89 e9                	mov    %ebp,%ecx
  803197:	d3 e0                	shl    %cl,%eax
  803199:	89 d7                	mov    %edx,%edi
  80319b:	89 f1                	mov    %esi,%ecx
  80319d:	d3 ef                	shr    %cl,%edi
  80319f:	09 c7                	or     %eax,%edi
  8031a1:	89 e9                	mov    %ebp,%ecx
  8031a3:	d3 e2                	shl    %cl,%edx
  8031a5:	89 14 24             	mov    %edx,(%esp)
  8031a8:	89 d8                	mov    %ebx,%eax
  8031aa:	d3 e0                	shl    %cl,%eax
  8031ac:	89 c2                	mov    %eax,%edx
  8031ae:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031b2:	d3 e0                	shl    %cl,%eax
  8031b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031b8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031bc:	89 f1                	mov    %esi,%ecx
  8031be:	d3 e8                	shr    %cl,%eax
  8031c0:	09 d0                	or     %edx,%eax
  8031c2:	d3 eb                	shr    %cl,%ebx
  8031c4:	89 da                	mov    %ebx,%edx
  8031c6:	f7 f7                	div    %edi
  8031c8:	89 d3                	mov    %edx,%ebx
  8031ca:	f7 24 24             	mull   (%esp)
  8031cd:	89 c6                	mov    %eax,%esi
  8031cf:	89 d1                	mov    %edx,%ecx
  8031d1:	39 d3                	cmp    %edx,%ebx
  8031d3:	0f 82 87 00 00 00    	jb     803260 <__umoddi3+0x134>
  8031d9:	0f 84 91 00 00 00    	je     803270 <__umoddi3+0x144>
  8031df:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031e3:	29 f2                	sub    %esi,%edx
  8031e5:	19 cb                	sbb    %ecx,%ebx
  8031e7:	89 d8                	mov    %ebx,%eax
  8031e9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031ed:	d3 e0                	shl    %cl,%eax
  8031ef:	89 e9                	mov    %ebp,%ecx
  8031f1:	d3 ea                	shr    %cl,%edx
  8031f3:	09 d0                	or     %edx,%eax
  8031f5:	89 e9                	mov    %ebp,%ecx
  8031f7:	d3 eb                	shr    %cl,%ebx
  8031f9:	89 da                	mov    %ebx,%edx
  8031fb:	83 c4 1c             	add    $0x1c,%esp
  8031fe:	5b                   	pop    %ebx
  8031ff:	5e                   	pop    %esi
  803200:	5f                   	pop    %edi
  803201:	5d                   	pop    %ebp
  803202:	c3                   	ret    
  803203:	90                   	nop
  803204:	89 fd                	mov    %edi,%ebp
  803206:	85 ff                	test   %edi,%edi
  803208:	75 0b                	jne    803215 <__umoddi3+0xe9>
  80320a:	b8 01 00 00 00       	mov    $0x1,%eax
  80320f:	31 d2                	xor    %edx,%edx
  803211:	f7 f7                	div    %edi
  803213:	89 c5                	mov    %eax,%ebp
  803215:	89 f0                	mov    %esi,%eax
  803217:	31 d2                	xor    %edx,%edx
  803219:	f7 f5                	div    %ebp
  80321b:	89 c8                	mov    %ecx,%eax
  80321d:	f7 f5                	div    %ebp
  80321f:	89 d0                	mov    %edx,%eax
  803221:	e9 44 ff ff ff       	jmp    80316a <__umoddi3+0x3e>
  803226:	66 90                	xchg   %ax,%ax
  803228:	89 c8                	mov    %ecx,%eax
  80322a:	89 f2                	mov    %esi,%edx
  80322c:	83 c4 1c             	add    $0x1c,%esp
  80322f:	5b                   	pop    %ebx
  803230:	5e                   	pop    %esi
  803231:	5f                   	pop    %edi
  803232:	5d                   	pop    %ebp
  803233:	c3                   	ret    
  803234:	3b 04 24             	cmp    (%esp),%eax
  803237:	72 06                	jb     80323f <__umoddi3+0x113>
  803239:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80323d:	77 0f                	ja     80324e <__umoddi3+0x122>
  80323f:	89 f2                	mov    %esi,%edx
  803241:	29 f9                	sub    %edi,%ecx
  803243:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803247:	89 14 24             	mov    %edx,(%esp)
  80324a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80324e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803252:	8b 14 24             	mov    (%esp),%edx
  803255:	83 c4 1c             	add    $0x1c,%esp
  803258:	5b                   	pop    %ebx
  803259:	5e                   	pop    %esi
  80325a:	5f                   	pop    %edi
  80325b:	5d                   	pop    %ebp
  80325c:	c3                   	ret    
  80325d:	8d 76 00             	lea    0x0(%esi),%esi
  803260:	2b 04 24             	sub    (%esp),%eax
  803263:	19 fa                	sbb    %edi,%edx
  803265:	89 d1                	mov    %edx,%ecx
  803267:	89 c6                	mov    %eax,%esi
  803269:	e9 71 ff ff ff       	jmp    8031df <__umoddi3+0xb3>
  80326e:	66 90                	xchg   %ax,%ax
  803270:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803274:	72 ea                	jb     803260 <__umoddi3+0x134>
  803276:	89 d9                	mov    %ebx,%ecx
  803278:	e9 62 ff ff ff       	jmp    8031df <__umoddi3+0xb3>

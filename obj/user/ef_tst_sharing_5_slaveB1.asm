
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 05 01 00 00       	call   80013b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 40 80 00       	mov    0x804020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 40 80 00       	mov    0x804020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 40 33 80 00       	push   $0x803340
  800091:	6a 12                	push   $0x12
  800093:	68 5c 33 80 00       	push   $0x80335c
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 1e 1b 00 00       	call   801bc0 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 7c 33 80 00       	push   $0x80337c
  8000aa:	50                   	push   %eax
  8000ab:	e8 d0 15 00 00       	call   801680 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 80 33 80 00       	push   $0x803380
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 a8 33 80 00       	push   $0x8033a8
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 30 2f 00 00       	call   803013 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 dc 17 00 00       	call   8018c7 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 6e 16 00 00       	call   801767 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 c8 33 80 00       	push   $0x8033c8
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 b6 17 00 00       	call   8018c7 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 e0 33 80 00       	push   $0x8033e0
  800127:	6a 20                	push   $0x20
  800129:	68 5c 33 80 00       	push   $0x80335c
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 ad 1b 00 00       	call   801ce5 <inctst>
	return;
  800138:	90                   	nop
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800141:	e8 61 1a 00 00       	call   801ba7 <sys_getenvindex>
  800146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	01 c0                	add    %eax,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015e:	01 d0                	add    %edx,%eax
  800160:	c1 e0 04             	shl    $0x4,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016d:	a1 20 40 80 00       	mov    0x804020,%eax
  800172:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800178:	84 c0                	test   %al,%al
  80017a:	74 0f                	je     80018b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80017c:	a1 20 40 80 00       	mov    0x804020,%eax
  800181:	05 5c 05 00 00       	add    $0x55c,%eax
  800186:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x60>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ac:	e8 03 18 00 00       	call   8019b4 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 a0 34 80 00       	push   $0x8034a0
  8001b9:	e8 6d 03 00 00       	call   80052b <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 c8 34 80 00       	push   $0x8034c8
  8001e1:	e8 45 03 00 00       	call   80052b <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ee:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 f0 34 80 00       	push   $0x8034f0
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 48 35 80 00       	push   $0x803548
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 a0 34 80 00       	push   $0x8034a0
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 83 17 00 00       	call   8019ce <sys_enable_interrupt>

	// exit gracefully
	exit();
  80024b:	e8 19 00 00 00       	call   800269 <exit>
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	e8 10 19 00 00       	call   801b73 <sys_destroy_env>
  800263:	83 c4 10             	add    $0x10,%esp
}
  800266:	90                   	nop
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <exit>:

void
exit(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026f:	e8 65 19 00 00       	call   801bd9 <sys_exit_env>
}
  800274:	90                   	nop
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027d:	8d 45 10             	lea    0x10(%ebp),%eax
  800280:	83 c0 04             	add    $0x4,%eax
  800283:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800286:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	74 16                	je     8002a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	50                   	push   %eax
  800298:	68 5c 35 80 00       	push   $0x80355c
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 61 35 80 00       	push   $0x803561
  8002b6:	e8 70 02 00 00       	call   80052b <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002be:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c7:	50                   	push   %eax
  8002c8:	e8 f3 01 00 00       	call   8004c0 <vcprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	6a 00                	push   $0x0
  8002d5:	68 7d 35 80 00       	push   $0x80357d
  8002da:	e8 e1 01 00 00       	call   8004c0 <vcprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e2:	e8 82 ff ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8002e7:	eb fe                	jmp    8002e7 <_panic+0x70>

008002e9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f4:	8b 50 74             	mov    0x74(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 80 35 80 00       	push   $0x803580
  800306:	6a 26                	push   $0x26
  800308:	68 cc 35 80 00       	push   $0x8035cc
  80030d:	e8 65 ff ff ff       	call   800277 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800320:	e9 c2 00 00 00       	jmp    8003e7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	75 08                	jne    800342 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80033a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033d:	e9 a2 00 00 00       	jmp    8003e4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800342:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800350:	eb 69                	jmp    8003bb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800352:	a1 20 40 80 00       	mov    0x804020,%eax
  800357:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80035d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	84 c0                	test   %al,%al
  800370:	75 46                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800372:	a1 20 40 80 00       	mov    0x804020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	75 09                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b6:	eb 12                	jmp    8003ca <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b8:	ff 45 e8             	incl   -0x18(%ebp)
  8003bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c0:	8b 50 74             	mov    0x74(%eax),%edx
  8003c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c6:	39 c2                	cmp    %eax,%edx
  8003c8:	77 88                	ja     800352 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ce:	75 14                	jne    8003e4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	68 d8 35 80 00       	push   $0x8035d8
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 cc 35 80 00       	push   $0x8035cc
  8003df:	e8 93 fe ff ff       	call   800277 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e4:	ff 45 f0             	incl   -0x10(%ebp)
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ed:	0f 8c 32 ff ff ff    	jl     800325 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800401:	eb 26                	jmp    800429 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800403:	a1 20 40 80 00       	mov    0x804020,%eax
  800408:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800411:	89 d0                	mov    %edx,%eax
  800413:	01 c0                	add    %eax,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	c1 e0 03             	shl    $0x3,%eax
  80041a:	01 c8                	add    %ecx,%eax
  80041c:	8a 40 04             	mov    0x4(%eax),%al
  80041f:	3c 01                	cmp    $0x1,%al
  800421:	75 03                	jne    800426 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800423:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800426:	ff 45 e0             	incl   -0x20(%ebp)
  800429:	a1 20 40 80 00       	mov    0x804020,%eax
  80042e:	8b 50 74             	mov    0x74(%eax),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	39 c2                	cmp    %eax,%edx
  800436:	77 cb                	ja     800403 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043e:	74 14                	je     800454 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 2c 36 80 00       	push   $0x80362c
  800448:	6a 44                	push   $0x44
  80044a:	68 cc 35 80 00       	push   $0x8035cc
  80044f:	e8 23 fe ff ff       	call   800277 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 48 01             	lea    0x1(%eax),%ecx
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	89 0a                	mov    %ecx,(%edx)
  80046a:	8b 55 08             	mov    0x8(%ebp),%edx
  80046d:	88 d1                	mov    %dl,%cl
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 2c                	jne    8004ae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800482:	a0 24 40 80 00       	mov    0x804024,%al
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	8b 12                	mov    (%edx),%edx
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	83 c2 08             	add    $0x8,%edx
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	50                   	push   %eax
  80049b:	51                   	push   %ecx
  80049c:	52                   	push   %edx
  80049d:	e8 64 13 00 00       	call   801806 <sys_cputs>
  8004a2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	8b 40 04             	mov    0x4(%eax),%eax
  8004b4:	8d 50 01             	lea    0x1(%eax),%edx
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d0:	00 00 00 
	b.cnt = 0;
  8004d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e9:	50                   	push   %eax
  8004ea:	68 57 04 80 00       	push   $0x800457
  8004ef:	e8 11 02 00 00       	call   800705 <vprintfmt>
  8004f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f7:	a0 24 40 80 00       	mov    0x804024,%al
  8004fc:	0f b6 c0             	movzbl %al,%eax
  8004ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	50                   	push   %eax
  800509:	52                   	push   %edx
  80050a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800510:	83 c0 08             	add    $0x8,%eax
  800513:	50                   	push   %eax
  800514:	e8 ed 12 00 00       	call   801806 <sys_cputs>
  800519:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800523:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <cprintf>:

int cprintf(const char *fmt, ...) {
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800531:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 73 ff ff ff       	call   8004c0 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80055e:	e8 51 14 00 00       	call   8019b4 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800563:	8d 45 0c             	lea    0xc(%ebp),%eax
  800566:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	50                   	push   %eax
  800573:	e8 48 ff ff ff       	call   8004c0 <vcprintf>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80057e:	e8 4b 14 00 00       	call   8019ce <sys_enable_interrupt>
	return cnt;
  800583:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 14             	sub    $0x14,%esp
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059b:	8b 45 18             	mov    0x18(%ebp),%eax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a6:	77 55                	ja     8005fd <printnum+0x75>
  8005a8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ab:	72 05                	jb     8005b2 <printnum+0x2a>
  8005ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b0:	77 4b                	ja     8005fd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	52                   	push   %edx
  8005c1:	50                   	push   %eax
  8005c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c8:	e8 fb 2a 00 00       	call   8030c8 <__udivdi3>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	ff 75 20             	pushl  0x20(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	ff 75 18             	pushl  0x18(%ebp)
  8005da:	52                   	push   %edx
  8005db:	50                   	push   %eax
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 08             	pushl  0x8(%ebp)
  8005e2:	e8 a1 ff ff ff       	call   800588 <printnum>
  8005e7:	83 c4 20             	add    $0x20,%esp
  8005ea:	eb 1a                	jmp    800606 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	ff d0                	call   *%eax
  8005fa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	ff 4d 1c             	decl   0x1c(%ebp)
  800600:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800604:	7f e6                	jg     8005ec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800606:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800609:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800614:	53                   	push   %ebx
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	e8 bb 2b 00 00       	call   8031d8 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 94 38 80 00       	add    $0x803894,%eax
  800625:	8a 00                	mov    (%eax),%al
  800627:	0f be c0             	movsbl %al,%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
}
  800639:	90                   	nop
  80063a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800642:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800646:	7e 1c                	jle    800664 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 50 08             	lea    0x8(%eax),%edx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	89 10                	mov    %edx,(%eax)
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	83 e8 08             	sub    $0x8,%eax
  80065d:	8b 50 04             	mov    0x4(%eax),%edx
  800660:	8b 00                	mov    (%eax),%eax
  800662:	eb 40                	jmp    8006a4 <getuint+0x65>
	else if (lflag)
  800664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800668:	74 1e                	je     800688 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 10                	mov    %edx,(%eax)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	eb 1c                	jmp    8006a4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ad:	7e 1c                	jle    8006cb <getint+0x25>
		return va_arg(*ap, long long);
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	8d 50 08             	lea    0x8(%eax),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	89 10                	mov    %edx,(%eax)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	83 e8 08             	sub    $0x8,%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	eb 38                	jmp    800703 <getint+0x5d>
	else if (lflag)
  8006cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cf:	74 1a                	je     8006eb <getint+0x45>
		return va_arg(*ap, long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 04             	lea    0x4(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 04             	sub    $0x4,%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	99                   	cltd   
  8006e9:	eb 18                	jmp    800703 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	99                   	cltd   
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x21>
			if (ch == '\0')
  80070f:	85 db                	test   %ebx,%ebx
  800711:	0f 84 af 03 00 00    	je     800ac6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	53                   	push   %ebx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	8d 50 01             	lea    0x1(%eax),%edx
  80072c:	89 55 10             	mov    %edx,0x10(%ebp)
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f b6 d8             	movzbl %al,%ebx
  800734:	83 fb 25             	cmp    $0x25,%ebx
  800737:	75 d6                	jne    80070f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800739:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800744:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076a:	83 f8 55             	cmp    $0x55,%eax
  80076d:	0f 87 2b 03 00 00    	ja     800a9e <vprintfmt+0x399>
  800773:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  80077a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800780:	eb d7                	jmp    800759 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800782:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800786:	eb d1                	jmp    800759 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800788:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	01 d8                	add    %ebx,%eax
  80079d:	83 e8 30             	sub    $0x30,%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	8a 00                	mov    (%eax),%al
  8007a8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ab:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ae:	7e 3e                	jle    8007ee <vprintfmt+0xe9>
  8007b0:	83 fb 39             	cmp    $0x39,%ebx
  8007b3:	7f 39                	jg     8007ee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b8:	eb d5                	jmp    80078f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ce:	eb 1f                	jmp    8007ef <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d4:	79 83                	jns    800759 <vprintfmt+0x54>
				width = 0;
  8007d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dd:	e9 77 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e9:	e9 6b ff ff ff       	jmp    800759 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	0f 89 60 ff ff ff    	jns    800759 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800806:	e9 4e ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080e:	e9 46 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	50                   	push   %eax
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	e9 89 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800849:	85 db                	test   %ebx,%ebx
  80084b:	79 02                	jns    80084f <vprintfmt+0x14a>
				err = -err;
  80084d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084f:	83 fb 64             	cmp    $0x64,%ebx
  800852:	7f 0b                	jg     80085f <vprintfmt+0x15a>
  800854:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 a5 38 80 00       	push   $0x8038a5
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 5e 02 00 00       	call   800ace <printfmt>
  800870:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800873:	e9 49 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800878:	56                   	push   %esi
  800879:	68 ae 38 80 00       	push   $0x8038ae
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 45 02 00 00       	call   800ace <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 30 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 30                	mov    (%eax),%esi
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	75 05                	jne    8008ab <vprintfmt+0x1a6>
				p = "(null)";
  8008a6:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7e 6d                	jle    80091e <vprintfmt+0x219>
  8008b1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b5:	74 67                	je     80091e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	56                   	push   %esi
  8008bf:	e8 0c 03 00 00       	call   800bd0 <strnlen>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ca:	eb 16                	jmp    8008e2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008df:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	7f e4                	jg     8008cc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e8:	eb 34                	jmp    80091e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ee:	74 1c                	je     80090c <vprintfmt+0x207>
  8008f0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f3:	7e 05                	jle    8008fa <vprintfmt+0x1f5>
  8008f5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f8:	7e 12                	jle    80090c <vprintfmt+0x207>
					putch('?', putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	6a 3f                	push   $0x3f
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	eb 0f                	jmp    80091b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	ff 4d e4             	decl   -0x1c(%ebp)
  80091e:	89 f0                	mov    %esi,%eax
  800920:	8d 70 01             	lea    0x1(%eax),%esi
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
  800928:	85 db                	test   %ebx,%ebx
  80092a:	74 24                	je     800950 <vprintfmt+0x24b>
  80092c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800930:	78 b8                	js     8008ea <vprintfmt+0x1e5>
  800932:	ff 4d e0             	decl   -0x20(%ebp)
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	79 af                	jns    8008ea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093b:	eb 13                	jmp    800950 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 20                	push   $0x20
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094d:	ff 4d e4             	decl   -0x1c(%ebp)
  800950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800954:	7f e7                	jg     80093d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800956:	e9 66 01 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 e8             	pushl  -0x18(%ebp)
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	e8 3c fd ff ff       	call   8006a6 <getint>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800979:	85 d2                	test   %edx,%edx
  80097b:	79 23                	jns    8009a0 <vprintfmt+0x29b>
				putch('-', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	6a 2d                	push   $0x2d
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800993:	f7 d8                	neg    %eax
  800995:	83 d2 00             	adc    $0x0,%edx
  800998:	f7 da                	neg    %edx
  80099a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a7:	e9 bc 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 84 fc ff ff       	call   80063f <getuint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cb:	e9 98 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 58                	push   $0x58
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 58                	push   $0x58
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 58                	push   $0x58
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			break;
  800a00:	e9 bc 00 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 30                	push   $0x30
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	6a 78                	push   $0x78
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a47:	eb 1f                	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 e7 fb ff ff       	call   80063f <getuint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a61:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a68:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6f:	83 ec 04             	sub    $0x4,%esp
  800a72:	52                   	push   %edx
  800a73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a76:	50                   	push   %eax
  800a77:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 00 fb ff ff       	call   800588 <printnum>
  800a88:	83 c4 20             	add    $0x20,%esp
			break;
  800a8b:	eb 34                	jmp    800ac1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			break;
  800a9c:	eb 23                	jmp    800ac1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 25                	push   $0x25
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aae:	ff 4d 10             	decl   0x10(%ebp)
  800ab1:	eb 03                	jmp    800ab6 <vprintfmt+0x3b1>
  800ab3:	ff 4d 10             	decl   0x10(%ebp)
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	48                   	dec    %eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	3c 25                	cmp    $0x25,%al
  800abe:	75 f3                	jne    800ab3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac0:	90                   	nop
		}
	}
  800ac1:	e9 47 fc ff ff       	jmp    80070d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800add:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 16 fc ff ff       	call   800705 <vprintfmt>
  800aef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af2:	90                   	nop
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8b 40 08             	mov    0x8(%eax),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 10                	mov    (%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 40 04             	mov    0x4(%eax),%eax
  800b12:	39 c2                	cmp    %eax,%edx
  800b14:	73 12                	jae    800b28 <sprintputch+0x33>
		*b->buf++ = ch;
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 00                	mov    (%eax),%eax
  800b1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 0a                	mov    %ecx,(%edx)
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
  800b26:	88 10                	mov    %dl,(%eax)
}
  800b28:	90                   	nop
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b50:	74 06                	je     800b58 <vsnprintf+0x2d>
  800b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b56:	7f 07                	jg     800b5f <vsnprintf+0x34>
		return -E_INVAL;
  800b58:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5d:	eb 20                	jmp    800b7f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5f:	ff 75 14             	pushl  0x14(%ebp)
  800b62:	ff 75 10             	pushl  0x10(%ebp)
  800b65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b68:	50                   	push   %eax
  800b69:	68 f5 0a 80 00       	push   $0x800af5
  800b6e:	e8 92 fb ff ff       	call   800705 <vprintfmt>
  800b73:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b79:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b87:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8a:	83 c0 04             	add    $0x4,%eax
  800b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	ff 75 f4             	pushl  -0xc(%ebp)
  800b96:	50                   	push   %eax
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 89 ff ff ff       	call   800b2b <vsnprintf>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bba:	eb 06                	jmp    800bc2 <strlen+0x15>
		n++;
  800bbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 f1                	jne    800bbc <strlen+0xf>
		n++;
	return n;
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdd:	eb 09                	jmp    800be8 <strnlen+0x18>
		n++;
  800bdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be2:	ff 45 08             	incl   0x8(%ebp)
  800be5:	ff 4d 0c             	decl   0xc(%ebp)
  800be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bec:	74 09                	je     800bf7 <strnlen+0x27>
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	84 c0                	test   %al,%al
  800bf5:	75 e8                	jne    800bdf <strnlen+0xf>
		n++;
	return n;
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c08:	90                   	nop
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1b:	8a 12                	mov    (%edx),%dl
  800c1d:	88 10                	mov    %dl,(%eax)
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 e4                	jne    800c09 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3d:	eb 1f                	jmp    800c5e <strncpy+0x34>
		*dst++ = *src;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8d 50 01             	lea    0x1(%eax),%edx
  800c45:	89 55 08             	mov    %edx,0x8(%ebp)
  800c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4b:	8a 12                	mov    (%edx),%dl
  800c4d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	74 03                	je     800c5b <strncpy+0x31>
			src++;
  800c58:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5b:	ff 45 fc             	incl   -0x4(%ebp)
  800c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c64:	72 d9                	jb     800c3f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	74 30                	je     800cad <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7d:	eb 16                	jmp    800c95 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8d 50 01             	lea    0x1(%eax),%edx
  800c85:	89 55 08             	mov    %edx,0x8(%ebp)
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c95:	ff 4d 10             	decl   0x10(%ebp)
  800c98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9c:	74 09                	je     800ca7 <strlcpy+0x3c>
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	75 d8                	jne    800c7f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb3:	29 c2                	sub    %eax,%edx
  800cb5:	89 d0                	mov    %edx,%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbc:	eb 06                	jmp    800cc4 <strcmp+0xb>
		p++, q++;
  800cbe:	ff 45 08             	incl   0x8(%ebp)
  800cc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 0e                	je     800cdb <strcmp+0x22>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 10                	mov    (%eax),%dl
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	38 c2                	cmp    %al,%dl
  800cd9:	74 e3                	je     800cbe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d0             	movzbl %al,%edx
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 c0             	movzbl %al,%eax
  800ceb:	29 c2                	sub    %eax,%edx
  800ced:	89 d0                	mov    %edx,%eax
}
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf4:	eb 09                	jmp    800cff <strncmp+0xe>
		n--, p++, q++;
  800cf6:	ff 4d 10             	decl   0x10(%ebp)
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d03:	74 17                	je     800d1c <strncmp+0x2b>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	74 0e                	je     800d1c <strncmp+0x2b>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 10                	mov    (%eax),%dl
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 da                	je     800cf6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	75 07                	jne    800d29 <strncmp+0x38>
		return 0;
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	eb 14                	jmp    800d3d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 d0             	movzbl %al,%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 c0             	movzbl %al,%eax
  800d39:	29 c2                	sub    %eax,%edx
  800d3b:	89 d0                	mov    %edx,%eax
}
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4b:	eb 12                	jmp    800d5f <strchr+0x20>
		if (*s == c)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d55:	75 05                	jne    800d5c <strchr+0x1d>
			return (char *) s;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	eb 11                	jmp    800d6d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 e5                	jne    800d4d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7b:	eb 0d                	jmp    800d8a <strfind+0x1b>
		if (*s == c)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d85:	74 0e                	je     800d95 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 ea                	jne    800d7d <strfind+0xe>
  800d93:	eb 01                	jmp    800d96 <strfind+0x27>
		if (*s == c)
			break;
  800d95:	90                   	nop
	return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dad:	eb 0e                	jmp    800dbd <memset+0x22>
		*p++ = c;
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dbd:	ff 4d f8             	decl   -0x8(%ebp)
  800dc0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc4:	79 e9                	jns    800daf <memset+0x14>
		*p++ = c;

	return v;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ddd:	eb 16                	jmp    800df5 <memcpy+0x2a>
		*d++ = *s++;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800deb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	75 dd                	jne    800ddf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1f:	73 50                	jae    800e71 <memmove+0x6a>
  800e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
  800e29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2c:	76 43                	jbe    800e71 <memmove+0x6a>
		s += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3a:	eb 10                	jmp    800e4c <memmove+0x45>
			*--d = *--s;
  800e3c:	ff 4d f8             	decl   -0x8(%ebp)
  800e3f:	ff 4d fc             	decl   -0x4(%ebp)
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e45:	8a 10                	mov    (%eax),%dl
  800e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 e3                	jne    800e3c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e59:	eb 23                	jmp    800e7e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5e:	8d 50 01             	lea    0x1(%eax),%edx
  800e61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e77:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	75 dd                	jne    800e5b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e95:	eb 2a                	jmp    800ec1 <memcmp+0x3e>
		if (*s1 != *s2)
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9a:	8a 10                	mov    (%eax),%dl
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	38 c2                	cmp    %al,%dl
  800ea3:	74 16                	je     800ebb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f b6 d0             	movzbl %al,%edx
  800ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 c0             	movzbl %al,%eax
  800eb5:	29 c2                	sub    %eax,%edx
  800eb7:	89 d0                	mov    %edx,%eax
  800eb9:	eb 18                	jmp    800ed3 <memcmp+0x50>
		s1++, s2++;
  800ebb:	ff 45 fc             	incl   -0x4(%ebp)
  800ebe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 c9                	jne    800e97 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee6:	eb 15                	jmp    800efd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 d0             	movzbl %al,%edx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	0f b6 c0             	movzbl %al,%eax
  800ef6:	39 c2                	cmp    %eax,%edx
  800ef8:	74 0d                	je     800f07 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f03:	72 e3                	jb     800ee8 <memfind+0x13>
  800f05:	eb 01                	jmp    800f08 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f07:	90                   	nop
	return (void *) s;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f21:	eb 03                	jmp    800f26 <strtol+0x19>
		s++;
  800f23:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 20                	cmp    $0x20,%al
  800f2d:	74 f4                	je     800f23 <strtol+0x16>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 09                	cmp    $0x9,%al
  800f36:	74 eb                	je     800f23 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 2b                	cmp    $0x2b,%al
  800f3f:	75 05                	jne    800f46 <strtol+0x39>
		s++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	eb 13                	jmp    800f59 <strtol+0x4c>
	else if (*s == '-')
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 2d                	cmp    $0x2d,%al
  800f4d:	75 0a                	jne    800f59 <strtol+0x4c>
		s++, neg = 1;
  800f4f:	ff 45 08             	incl   0x8(%ebp)
  800f52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5d:	74 06                	je     800f65 <strtol+0x58>
  800f5f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f63:	75 20                	jne    800f85 <strtol+0x78>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 30                	cmp    $0x30,%al
  800f6c:	75 17                	jne    800f85 <strtol+0x78>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	40                   	inc    %eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 78                	cmp    $0x78,%al
  800f76:	75 0d                	jne    800f85 <strtol+0x78>
		s += 2, base = 16;
  800f78:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f83:	eb 28                	jmp    800fad <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f89:	75 15                	jne    800fa0 <strtol+0x93>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 30                	cmp    $0x30,%al
  800f92:	75 0c                	jne    800fa0 <strtol+0x93>
		s++, base = 8;
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9e:	eb 0d                	jmp    800fad <strtol+0xa0>
	else if (base == 0)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	75 07                	jne    800fad <strtol+0xa0>
		base = 10;
  800fa6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 2f                	cmp    $0x2f,%al
  800fb4:	7e 19                	jle    800fcf <strtol+0xc2>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 39                	cmp    $0x39,%al
  800fbd:	7f 10                	jg     800fcf <strtol+0xc2>
			dig = *s - '0';
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f be c0             	movsbl %al,%eax
  800fc7:	83 e8 30             	sub    $0x30,%eax
  800fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcd:	eb 42                	jmp    801011 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 60                	cmp    $0x60,%al
  800fd6:	7e 19                	jle    800ff1 <strtol+0xe4>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 7a                	cmp    $0x7a,%al
  800fdf:	7f 10                	jg     800ff1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be c0             	movsbl %al,%eax
  800fe9:	83 e8 57             	sub    $0x57,%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fef:	eb 20                	jmp    801011 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 40                	cmp    $0x40,%al
  800ff8:	7e 39                	jle    801033 <strtol+0x126>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 5a                	cmp    $0x5a,%al
  801001:	7f 30                	jg     801033 <strtol+0x126>
			dig = *s - 'A' + 10;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	83 e8 37             	sub    $0x37,%eax
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801014:	3b 45 10             	cmp    0x10(%ebp),%eax
  801017:	7d 19                	jge    801032 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801023:	89 c2                	mov    %eax,%edx
  801025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102d:	e9 7b ff ff ff       	jmp    800fad <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801032:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801037:	74 08                	je     801041 <strtol+0x134>
		*endptr = (char *) s;
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801041:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801045:	74 07                	je     80104e <strtol+0x141>
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	f7 d8                	neg    %eax
  80104c:	eb 03                	jmp    801051 <strtol+0x144>
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <ltostr>:

void
ltostr(long value, char *str)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801060:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106b:	79 13                	jns    801080 <ltostr+0x2d>
	{
		neg = 1;
  80106d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801088:	99                   	cltd   
  801089:	f7 f9                	idiv   %ecx
  80108b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	8d 50 01             	lea    0x1(%eax),%edx
  801094:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801097:	89 c2                	mov    %eax,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a1:	83 c2 30             	add    $0x30,%edx
  8010a4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ae:	f7 e9                	imul   %ecx
  8010b0:	c1 fa 02             	sar    $0x2,%edx
  8010b3:	89 c8                	mov    %ecx,%eax
  8010b5:	c1 f8 1f             	sar    $0x1f,%eax
  8010b8:	29 c2                	sub    %eax,%edx
  8010ba:	89 d0                	mov    %edx,%eax
  8010bc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	c1 e0 02             	shl    $0x2,%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	01 c0                	add    %eax,%eax
  8010dc:	29 c1                	sub    %eax,%ecx
  8010de:	89 ca                	mov    %ecx,%edx
  8010e0:	85 d2                	test   %edx,%edx
  8010e2:	75 9c                	jne    801080 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ee:	48                   	dec    %eax
  8010ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f6:	74 3d                	je     801135 <ltostr+0xe2>
		start = 1 ;
  8010f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ff:	eb 34                	jmp    801135 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c2                	add    %eax,%edx
  801116:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c8                	add    %ecx,%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	01 c2                	add    %eax,%edx
  80112a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112d:	88 02                	mov    %al,(%edx)
		start++ ;
  80112f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801132:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801138:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113b:	7c c4                	jl     801101 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	01 d0                	add    %edx,%eax
  801145:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801148:	90                   	nop
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801151:	ff 75 08             	pushl  0x8(%ebp)
  801154:	e8 54 fa ff ff       	call   800bad <strlen>
  801159:	83 c4 04             	add    $0x4,%esp
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	e8 46 fa ff ff       	call   800bad <strlen>
  801167:	83 c4 04             	add    $0x4,%esp
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117b:	eb 17                	jmp    801194 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	01 c8                	add    %ecx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801191:	ff 45 fc             	incl   -0x4(%ebp)
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801197:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119a:	7c e1                	jl     80117d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011aa:	eb 1f                	jmp    8011cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8d 50 01             	lea    0x1(%eax),%edx
  8011b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d1:	7c d9                	jl     8011ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
}
  8011de:	90                   	nop
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801204:	eb 0c                	jmp    801212 <strsplit+0x31>
			*string++ = 0;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 08             	mov    %edx,0x8(%ebp)
  80120f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 18                	je     801233 <strsplit+0x52>
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	0f be c0             	movsbl %al,%eax
  801223:	50                   	push   %eax
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	e8 13 fb ff ff       	call   800d3f <strchr>
  80122c:	83 c4 08             	add    $0x8,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	75 d3                	jne    801206 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	84 c0                	test   %al,%al
  80123a:	74 5a                	je     801296 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123c:	8b 45 14             	mov    0x14(%ebp),%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	83 f8 0f             	cmp    $0xf,%eax
  801244:	75 07                	jne    80124d <strsplit+0x6c>
		{
			return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 66                	jmp    8012b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 48 01             	lea    0x1(%eax),%ecx
  801255:	8b 55 14             	mov    0x14(%ebp),%edx
  801258:	89 0a                	mov    %ecx,(%edx)
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126b:	eb 03                	jmp    801270 <strsplit+0x8f>
			string++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	84 c0                	test   %al,%al
  801277:	74 8b                	je     801204 <strsplit+0x23>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	0f be c0             	movsbl %al,%eax
  801281:	50                   	push   %eax
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	e8 b5 fa ff ff       	call   800d3f <strchr>
  80128a:	83 c4 08             	add    $0x8,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	74 dc                	je     80126d <strsplit+0x8c>
			string++;
	}
  801291:	e9 6e ff ff ff       	jmp    801204 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801296:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	8b 00                	mov    (%eax),%eax
  80129c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	74 1f                	je     8012e3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012c4:	e8 1d 00 00 00       	call   8012e6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	68 10 3a 80 00       	push   $0x803a10
  8012d1:	e8 55 f2 ff ff       	call   80052b <cprintf>
  8012d6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d9:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e0:	00 00 00 
	}
}
  8012e3:	90                   	nop
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012ec:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012f3:	00 00 00 
  8012f6:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012fd:	00 00 00 
  801300:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801307:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80130a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801311:	00 00 00 
  801314:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80131b:	00 00 00 
  80131e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801325:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801328:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80132f:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801332:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801341:	2d 00 10 00 00       	sub    $0x1000,%eax
  801346:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80134b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801352:	a1 20 41 80 00       	mov    0x804120,%eax
  801357:	c1 e0 04             	shl    $0x4,%eax
  80135a:	89 c2                	mov    %eax,%edx
  80135c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135f:	01 d0                	add    %edx,%eax
  801361:	48                   	dec    %eax
  801362:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801365:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801368:	ba 00 00 00 00       	mov    $0x0,%edx
  80136d:	f7 75 f0             	divl   -0x10(%ebp)
  801370:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801373:	29 d0                	sub    %edx,%eax
  801375:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801378:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80137f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801382:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801387:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	6a 06                	push   $0x6
  801391:	ff 75 e8             	pushl  -0x18(%ebp)
  801394:	50                   	push   %eax
  801395:	e8 b0 05 00 00       	call   80194a <sys_allocate_chunk>
  80139a:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80139d:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a2:	83 ec 0c             	sub    $0xc,%esp
  8013a5:	50                   	push   %eax
  8013a6:	e8 25 0c 00 00       	call   801fd0 <initialize_MemBlocksList>
  8013ab:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8013ae:	a1 48 41 80 00       	mov    0x804148,%eax
  8013b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8013b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013ba:	75 14                	jne    8013d0 <initialize_dyn_block_system+0xea>
  8013bc:	83 ec 04             	sub    $0x4,%esp
  8013bf:	68 35 3a 80 00       	push   $0x803a35
  8013c4:	6a 29                	push   $0x29
  8013c6:	68 53 3a 80 00       	push   $0x803a53
  8013cb:	e8 a7 ee ff ff       	call   800277 <_panic>
  8013d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d3:	8b 00                	mov    (%eax),%eax
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	74 10                	je     8013e9 <initialize_dyn_block_system+0x103>
  8013d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013dc:	8b 00                	mov    (%eax),%eax
  8013de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013e1:	8b 52 04             	mov    0x4(%edx),%edx
  8013e4:	89 50 04             	mov    %edx,0x4(%eax)
  8013e7:	eb 0b                	jmp    8013f4 <initialize_dyn_block_system+0x10e>
  8013e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ec:	8b 40 04             	mov    0x4(%eax),%eax
  8013ef:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f7:	8b 40 04             	mov    0x4(%eax),%eax
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	74 0f                	je     80140d <initialize_dyn_block_system+0x127>
  8013fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801401:	8b 40 04             	mov    0x4(%eax),%eax
  801404:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801407:	8b 12                	mov    (%edx),%edx
  801409:	89 10                	mov    %edx,(%eax)
  80140b:	eb 0a                	jmp    801417 <initialize_dyn_block_system+0x131>
  80140d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801410:	8b 00                	mov    (%eax),%eax
  801412:	a3 48 41 80 00       	mov    %eax,0x804148
  801417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801423:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80142a:	a1 54 41 80 00       	mov    0x804154,%eax
  80142f:	48                   	dec    %eax
  801430:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801435:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801438:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80143f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801442:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801449:	83 ec 0c             	sub    $0xc,%esp
  80144c:	ff 75 e0             	pushl  -0x20(%ebp)
  80144f:	e8 b9 14 00 00       	call   80290d <insert_sorted_with_merge_freeList>
  801454:	83 c4 10             	add    $0x10,%esp

}
  801457:	90                   	nop
  801458:	c9                   	leave  
  801459:	c3                   	ret    

0080145a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801460:	e8 50 fe ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801465:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801469:	75 07                	jne    801472 <malloc+0x18>
  80146b:	b8 00 00 00 00       	mov    $0x0,%eax
  801470:	eb 68                	jmp    8014da <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801472:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801479:	8b 55 08             	mov    0x8(%ebp),%edx
  80147c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147f:	01 d0                	add    %edx,%eax
  801481:	48                   	dec    %eax
  801482:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801488:	ba 00 00 00 00       	mov    $0x0,%edx
  80148d:	f7 75 f4             	divl   -0xc(%ebp)
  801490:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801493:	29 d0                	sub    %edx,%eax
  801495:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801498:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80149f:	e8 74 08 00 00       	call   801d18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	74 2d                	je     8014d5 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8014a8:	83 ec 0c             	sub    $0xc,%esp
  8014ab:	ff 75 ec             	pushl  -0x14(%ebp)
  8014ae:	e8 52 0e 00 00       	call   802305 <alloc_block_FF>
  8014b3:	83 c4 10             	add    $0x10,%esp
  8014b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8014b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014bd:	74 16                	je     8014d5 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8014bf:	83 ec 0c             	sub    $0xc,%esp
  8014c2:	ff 75 e8             	pushl  -0x18(%ebp)
  8014c5:	e8 3b 0c 00 00       	call   802105 <insert_sorted_allocList>
  8014ca:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8014cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014d0:	8b 40 08             	mov    0x8(%eax),%eax
  8014d3:	eb 05                	jmp    8014da <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8014d5:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8014da:	c9                   	leave  
  8014db:	c3                   	ret    

008014dc <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8014e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e5:	83 ec 08             	sub    $0x8,%esp
  8014e8:	50                   	push   %eax
  8014e9:	68 40 40 80 00       	push   $0x804040
  8014ee:	e8 ba 0b 00 00       	call   8020ad <find_block>
  8014f3:	83 c4 10             	add    $0x10,%esp
  8014f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8014f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801506:	0f 84 9f 00 00 00    	je     8015ab <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	ff 75 f0             	pushl  -0x10(%ebp)
  801515:	50                   	push   %eax
  801516:	e8 f7 03 00 00       	call   801912 <sys_free_user_mem>
  80151b:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80151e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801522:	75 14                	jne    801538 <free+0x5c>
  801524:	83 ec 04             	sub    $0x4,%esp
  801527:	68 35 3a 80 00       	push   $0x803a35
  80152c:	6a 6a                	push   $0x6a
  80152e:	68 53 3a 80 00       	push   $0x803a53
  801533:	e8 3f ed ff ff       	call   800277 <_panic>
  801538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153b:	8b 00                	mov    (%eax),%eax
  80153d:	85 c0                	test   %eax,%eax
  80153f:	74 10                	je     801551 <free+0x75>
  801541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801544:	8b 00                	mov    (%eax),%eax
  801546:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801549:	8b 52 04             	mov    0x4(%edx),%edx
  80154c:	89 50 04             	mov    %edx,0x4(%eax)
  80154f:	eb 0b                	jmp    80155c <free+0x80>
  801551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801554:	8b 40 04             	mov    0x4(%eax),%eax
  801557:	a3 44 40 80 00       	mov    %eax,0x804044
  80155c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155f:	8b 40 04             	mov    0x4(%eax),%eax
  801562:	85 c0                	test   %eax,%eax
  801564:	74 0f                	je     801575 <free+0x99>
  801566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801569:	8b 40 04             	mov    0x4(%eax),%eax
  80156c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156f:	8b 12                	mov    (%edx),%edx
  801571:	89 10                	mov    %edx,(%eax)
  801573:	eb 0a                	jmp    80157f <free+0xa3>
  801575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801578:	8b 00                	mov    (%eax),%eax
  80157a:	a3 40 40 80 00       	mov    %eax,0x804040
  80157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801582:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80158b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801592:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801597:	48                   	dec    %eax
  801598:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  80159d:	83 ec 0c             	sub    $0xc,%esp
  8015a0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015a3:	e8 65 13 00 00       	call   80290d <insert_sorted_with_merge_freeList>
  8015a8:	83 c4 10             	add    $0x10,%esp
	}
}
  8015ab:	90                   	nop
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	83 ec 28             	sub    $0x28,%esp
  8015b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b7:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015ba:	e8 f6 fc ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015c3:	75 0a                	jne    8015cf <smalloc+0x21>
  8015c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ca:	e9 af 00 00 00       	jmp    80167e <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8015cf:	e8 44 07 00 00       	call   801d18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015d4:	83 f8 01             	cmp    $0x1,%eax
  8015d7:	0f 85 9c 00 00 00    	jne    801679 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8015dd:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	48                   	dec    %eax
  8015ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f8:	f7 75 f4             	divl   -0xc(%ebp)
  8015fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fe:	29 d0                	sub    %edx,%eax
  801600:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801603:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80160a:	76 07                	jbe    801613 <smalloc+0x65>
			return NULL;
  80160c:	b8 00 00 00 00       	mov    $0x0,%eax
  801611:	eb 6b                	jmp    80167e <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801613:	83 ec 0c             	sub    $0xc,%esp
  801616:	ff 75 0c             	pushl  0xc(%ebp)
  801619:	e8 e7 0c 00 00       	call   802305 <alloc_block_FF>
  80161e:	83 c4 10             	add    $0x10,%esp
  801621:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801624:	83 ec 0c             	sub    $0xc,%esp
  801627:	ff 75 ec             	pushl  -0x14(%ebp)
  80162a:	e8 d6 0a 00 00       	call   802105 <insert_sorted_allocList>
  80162f:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801632:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801636:	75 07                	jne    80163f <smalloc+0x91>
		{
			return NULL;
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
  80163d:	eb 3f                	jmp    80167e <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80163f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801642:	8b 40 08             	mov    0x8(%eax),%eax
  801645:	89 c2                	mov    %eax,%edx
  801647:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80164b:	52                   	push   %edx
  80164c:	50                   	push   %eax
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	ff 75 08             	pushl  0x8(%ebp)
  801653:	e8 45 04 00 00       	call   801a9d <sys_createSharedObject>
  801658:	83 c4 10             	add    $0x10,%esp
  80165b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80165e:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801662:	74 06                	je     80166a <smalloc+0xbc>
  801664:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801668:	75 07                	jne    801671 <smalloc+0xc3>
		{
			return NULL;
  80166a:	b8 00 00 00 00       	mov    $0x0,%eax
  80166f:	eb 0d                	jmp    80167e <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801671:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801674:	8b 40 08             	mov    0x8(%eax),%eax
  801677:	eb 05                	jmp    80167e <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801679:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    

00801680 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801686:	e8 2a fc ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	ff 75 08             	pushl  0x8(%ebp)
  801694:	e8 2e 04 00 00       	call   801ac7 <sys_getSizeOfSharedObject>
  801699:	83 c4 10             	add    $0x10,%esp
  80169c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  80169f:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016a3:	75 0a                	jne    8016af <sget+0x2f>
	{
		return NULL;
  8016a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016aa:	e9 94 00 00 00       	jmp    801743 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016af:	e8 64 06 00 00       	call   801d18 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	0f 84 82 00 00 00    	je     80173e <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8016bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8016c3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016d0:	01 d0                	add    %edx,%eax
  8016d2:	48                   	dec    %eax
  8016d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016de:	f7 75 ec             	divl   -0x14(%ebp)
  8016e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016e4:	29 d0                	sub    %edx,%eax
  8016e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8016e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ec:	83 ec 0c             	sub    $0xc,%esp
  8016ef:	50                   	push   %eax
  8016f0:	e8 10 0c 00 00       	call   802305 <alloc_block_FF>
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8016fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016ff:	75 07                	jne    801708 <sget+0x88>
		{
			return NULL;
  801701:	b8 00 00 00 00       	mov    $0x0,%eax
  801706:	eb 3b                	jmp    801743 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170b:	8b 40 08             	mov    0x8(%eax),%eax
  80170e:	83 ec 04             	sub    $0x4,%esp
  801711:	50                   	push   %eax
  801712:	ff 75 0c             	pushl  0xc(%ebp)
  801715:	ff 75 08             	pushl  0x8(%ebp)
  801718:	e8 c7 03 00 00       	call   801ae4 <sys_getSharedObject>
  80171d:	83 c4 10             	add    $0x10,%esp
  801720:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801723:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801727:	74 06                	je     80172f <sget+0xaf>
  801729:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80172d:	75 07                	jne    801736 <sget+0xb6>
		{
			return NULL;
  80172f:	b8 00 00 00 00       	mov    $0x0,%eax
  801734:	eb 0d                	jmp    801743 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801739:	8b 40 08             	mov    0x8(%eax),%eax
  80173c:	eb 05                	jmp    801743 <sget+0xc3>
		}
	}
	else
			return NULL;
  80173e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801743:	c9                   	leave  
  801744:	c3                   	ret    

00801745 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80174b:	e8 65 fb ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	68 60 3a 80 00       	push   $0x803a60
  801758:	68 e1 00 00 00       	push   $0xe1
  80175d:	68 53 3a 80 00       	push   $0x803a53
  801762:	e8 10 eb ff ff       	call   800277 <_panic>

00801767 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	68 88 3a 80 00       	push   $0x803a88
  801775:	68 f5 00 00 00       	push   $0xf5
  80177a:	68 53 3a 80 00       	push   $0x803a53
  80177f:	e8 f3 ea ff ff       	call   800277 <_panic>

00801784 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178a:	83 ec 04             	sub    $0x4,%esp
  80178d:	68 ac 3a 80 00       	push   $0x803aac
  801792:	68 00 01 00 00       	push   $0x100
  801797:	68 53 3a 80 00       	push   $0x803a53
  80179c:	e8 d6 ea ff ff       	call   800277 <_panic>

008017a1 <shrink>:

}
void shrink(uint32 newSize)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a7:	83 ec 04             	sub    $0x4,%esp
  8017aa:	68 ac 3a 80 00       	push   $0x803aac
  8017af:	68 05 01 00 00       	push   $0x105
  8017b4:	68 53 3a 80 00       	push   $0x803a53
  8017b9:	e8 b9 ea ff ff       	call   800277 <_panic>

008017be <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c4:	83 ec 04             	sub    $0x4,%esp
  8017c7:	68 ac 3a 80 00       	push   $0x803aac
  8017cc:	68 0a 01 00 00       	push   $0x10a
  8017d1:	68 53 3a 80 00       	push   $0x803a53
  8017d6:	e8 9c ea ff ff       	call   800277 <_panic>

008017db <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	57                   	push   %edi
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ea:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017f0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017f3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f6:	cd 30                	int    $0x30
  8017f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	5b                   	pop    %ebx
  801802:	5e                   	pop    %esi
  801803:	5f                   	pop    %edi
  801804:	5d                   	pop    %ebp
  801805:	c3                   	ret    

00801806 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 04             	sub    $0x4,%esp
  80180c:	8b 45 10             	mov    0x10(%ebp),%eax
  80180f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801812:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801816:	8b 45 08             	mov    0x8(%ebp),%eax
  801819:	6a 00                	push   $0x0
  80181b:	6a 00                	push   $0x0
  80181d:	52                   	push   %edx
  80181e:	ff 75 0c             	pushl  0xc(%ebp)
  801821:	50                   	push   %eax
  801822:	6a 00                	push   $0x0
  801824:	e8 b2 ff ff ff       	call   8017db <syscall>
  801829:	83 c4 18             	add    $0x18,%esp
}
  80182c:	90                   	nop
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_cgetc>:

int
sys_cgetc(void)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 00                	push   $0x0
  80183c:	6a 01                	push   $0x1
  80183e:	e8 98 ff ff ff       	call   8017db <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80184b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	52                   	push   %edx
  801858:	50                   	push   %eax
  801859:	6a 05                	push   $0x5
  80185b:	e8 7b ff ff ff       	call   8017db <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	56                   	push   %esi
  801869:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80186a:	8b 75 18             	mov    0x18(%ebp),%esi
  80186d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801870:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801873:	8b 55 0c             	mov    0xc(%ebp),%edx
  801876:	8b 45 08             	mov    0x8(%ebp),%eax
  801879:	56                   	push   %esi
  80187a:	53                   	push   %ebx
  80187b:	51                   	push   %ecx
  80187c:	52                   	push   %edx
  80187d:	50                   	push   %eax
  80187e:	6a 06                	push   $0x6
  801880:	e8 56 ff ff ff       	call   8017db <syscall>
  801885:	83 c4 18             	add    $0x18,%esp
}
  801888:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5d                   	pop    %ebp
  80188e:	c3                   	ret    

0080188f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801892:	8b 55 0c             	mov    0xc(%ebp),%edx
  801895:	8b 45 08             	mov    0x8(%ebp),%eax
  801898:	6a 00                	push   $0x0
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	52                   	push   %edx
  80189f:	50                   	push   %eax
  8018a0:	6a 07                	push   $0x7
  8018a2:	e8 34 ff ff ff       	call   8017db <syscall>
  8018a7:	83 c4 18             	add    $0x18,%esp
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 0c             	pushl  0xc(%ebp)
  8018b8:	ff 75 08             	pushl  0x8(%ebp)
  8018bb:	6a 08                	push   $0x8
  8018bd:	e8 19 ff ff ff       	call   8017db <syscall>
  8018c2:	83 c4 18             	add    $0x18,%esp
}
  8018c5:	c9                   	leave  
  8018c6:	c3                   	ret    

008018c7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 09                	push   $0x9
  8018d6:	e8 00 ff ff ff       	call   8017db <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 0a                	push   $0xa
  8018ef:	e8 e7 fe ff ff       	call   8017db <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 0b                	push   $0xb
  801908:	e8 ce fe ff ff       	call   8017db <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	ff 75 0c             	pushl  0xc(%ebp)
  80191e:	ff 75 08             	pushl  0x8(%ebp)
  801921:	6a 0f                	push   $0xf
  801923:	e8 b3 fe ff ff       	call   8017db <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
	return;
  80192b:	90                   	nop
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	ff 75 08             	pushl  0x8(%ebp)
  80193d:	6a 10                	push   $0x10
  80193f:	e8 97 fe ff ff       	call   8017db <syscall>
  801944:	83 c4 18             	add    $0x18,%esp
	return ;
  801947:	90                   	nop
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	ff 75 10             	pushl  0x10(%ebp)
  801954:	ff 75 0c             	pushl  0xc(%ebp)
  801957:	ff 75 08             	pushl  0x8(%ebp)
  80195a:	6a 11                	push   $0x11
  80195c:	e8 7a fe ff ff       	call   8017db <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
	return ;
  801964:	90                   	nop
}
  801965:	c9                   	leave  
  801966:	c3                   	ret    

00801967 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801967:	55                   	push   %ebp
  801968:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 0c                	push   $0xc
  801976:	e8 60 fe ff ff       	call   8017db <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	ff 75 08             	pushl  0x8(%ebp)
  80198e:	6a 0d                	push   $0xd
  801990:	e8 46 fe ff ff       	call   8017db <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 0e                	push   $0xe
  8019a9:	e8 2d fe ff ff       	call   8017db <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	90                   	nop
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 13                	push   $0x13
  8019c3:	e8 13 fe ff ff       	call   8017db <syscall>
  8019c8:	83 c4 18             	add    $0x18,%esp
}
  8019cb:	90                   	nop
  8019cc:	c9                   	leave  
  8019cd:	c3                   	ret    

008019ce <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 14                	push   $0x14
  8019dd:	e8 f9 fd ff ff       	call   8017db <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
}
  8019e5:	90                   	nop
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
  8019eb:	83 ec 04             	sub    $0x4,%esp
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019f4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	50                   	push   %eax
  801a01:	6a 15                	push   $0x15
  801a03:	e8 d3 fd ff ff       	call   8017db <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	90                   	nop
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 16                	push   $0x16
  801a1d:	e8 b9 fd ff ff       	call   8017db <syscall>
  801a22:	83 c4 18             	add    $0x18,%esp
}
  801a25:	90                   	nop
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	50                   	push   %eax
  801a38:	6a 17                	push   $0x17
  801a3a:	e8 9c fd ff ff       	call   8017db <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a47:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	52                   	push   %edx
  801a54:	50                   	push   %eax
  801a55:	6a 1a                	push   $0x1a
  801a57:	e8 7f fd ff ff       	call   8017db <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
}
  801a5f:	c9                   	leave  
  801a60:	c3                   	ret    

00801a61 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	52                   	push   %edx
  801a71:	50                   	push   %eax
  801a72:	6a 18                	push   $0x18
  801a74:	e8 62 fd ff ff       	call   8017db <syscall>
  801a79:	83 c4 18             	add    $0x18,%esp
}
  801a7c:	90                   	nop
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a85:	8b 45 08             	mov    0x8(%ebp),%eax
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	52                   	push   %edx
  801a8f:	50                   	push   %eax
  801a90:	6a 19                	push   $0x19
  801a92:	e8 44 fd ff ff       	call   8017db <syscall>
  801a97:	83 c4 18             	add    $0x18,%esp
}
  801a9a:	90                   	nop
  801a9b:	c9                   	leave  
  801a9c:	c3                   	ret    

00801a9d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a9d:	55                   	push   %ebp
  801a9e:	89 e5                	mov    %esp,%ebp
  801aa0:	83 ec 04             	sub    $0x4,%esp
  801aa3:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aa9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aac:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	51                   	push   %ecx
  801ab6:	52                   	push   %edx
  801ab7:	ff 75 0c             	pushl  0xc(%ebp)
  801aba:	50                   	push   %eax
  801abb:	6a 1b                	push   $0x1b
  801abd:	e8 19 fd ff ff       	call   8017db <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	52                   	push   %edx
  801ad7:	50                   	push   %eax
  801ad8:	6a 1c                	push   $0x1c
  801ada:	e8 fc fc ff ff       	call   8017db <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	51                   	push   %ecx
  801af5:	52                   	push   %edx
  801af6:	50                   	push   %eax
  801af7:	6a 1d                	push   $0x1d
  801af9:	e8 dd fc ff ff       	call   8017db <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	52                   	push   %edx
  801b13:	50                   	push   %eax
  801b14:	6a 1e                	push   $0x1e
  801b16:	e8 c0 fc ff ff       	call   8017db <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 1f                	push   $0x1f
  801b2f:	e8 a7 fc ff ff       	call   8017db <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	6a 00                	push   $0x0
  801b41:	ff 75 14             	pushl  0x14(%ebp)
  801b44:	ff 75 10             	pushl  0x10(%ebp)
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	50                   	push   %eax
  801b4b:	6a 20                	push   $0x20
  801b4d:	e8 89 fc ff ff       	call   8017db <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	50                   	push   %eax
  801b66:	6a 21                	push   $0x21
  801b68:	e8 6e fc ff ff       	call   8017db <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	90                   	nop
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	50                   	push   %eax
  801b82:	6a 22                	push   $0x22
  801b84:	e8 52 fc ff ff       	call   8017db <syscall>
  801b89:	83 c4 18             	add    $0x18,%esp
}
  801b8c:	c9                   	leave  
  801b8d:	c3                   	ret    

00801b8e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b8e:	55                   	push   %ebp
  801b8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 02                	push   $0x2
  801b9d:	e8 39 fc ff ff       	call   8017db <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 03                	push   $0x3
  801bb6:	e8 20 fc ff ff       	call   8017db <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 04                	push   $0x4
  801bcf:	e8 07 fc ff ff       	call   8017db <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 23                	push   $0x23
  801be8:	e8 ee fb ff ff       	call   8017db <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	90                   	nop
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfc:	8d 50 04             	lea    0x4(%eax),%edx
  801bff:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	52                   	push   %edx
  801c09:	50                   	push   %eax
  801c0a:	6a 24                	push   $0x24
  801c0c:	e8 ca fb ff ff       	call   8017db <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
	return result;
  801c14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c1d:	89 01                	mov    %eax,(%ecx)
  801c1f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	c9                   	leave  
  801c26:	c2 04 00             	ret    $0x4

00801c29 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	ff 75 10             	pushl  0x10(%ebp)
  801c33:	ff 75 0c             	pushl  0xc(%ebp)
  801c36:	ff 75 08             	pushl  0x8(%ebp)
  801c39:	6a 12                	push   $0x12
  801c3b:	e8 9b fb ff ff       	call   8017db <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
	return ;
  801c43:	90                   	nop
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 25                	push   $0x25
  801c55:	e8 81 fb ff ff       	call   8017db <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
  801c62:	83 ec 04             	sub    $0x4,%esp
  801c65:	8b 45 08             	mov    0x8(%ebp),%eax
  801c68:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c6b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	50                   	push   %eax
  801c78:	6a 26                	push   $0x26
  801c7a:	e8 5c fb ff ff       	call   8017db <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c82:	90                   	nop
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <rsttst>:
void rsttst()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 28                	push   $0x28
  801c94:	e8 42 fb ff ff       	call   8017db <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9c:	90                   	nop
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 04             	sub    $0x4,%esp
  801ca5:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cab:	8b 55 18             	mov    0x18(%ebp),%edx
  801cae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cb2:	52                   	push   %edx
  801cb3:	50                   	push   %eax
  801cb4:	ff 75 10             	pushl  0x10(%ebp)
  801cb7:	ff 75 0c             	pushl  0xc(%ebp)
  801cba:	ff 75 08             	pushl  0x8(%ebp)
  801cbd:	6a 27                	push   $0x27
  801cbf:	e8 17 fb ff ff       	call   8017db <syscall>
  801cc4:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc7:	90                   	nop
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <chktst>:
void chktst(uint32 n)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 08             	pushl  0x8(%ebp)
  801cd8:	6a 29                	push   $0x29
  801cda:	e8 fc fa ff ff       	call   8017db <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce2:	90                   	nop
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    

00801ce5 <inctst>:

void inctst()
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 2a                	push   $0x2a
  801cf4:	e8 e2 fa ff ff       	call   8017db <syscall>
  801cf9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfc:	90                   	nop
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <gettst>:
uint32 gettst()
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 2b                	push   $0x2b
  801d0e:	e8 c8 fa ff ff       	call   8017db <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
  801d1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 2c                	push   $0x2c
  801d2a:	e8 ac fa ff ff       	call   8017db <syscall>
  801d2f:	83 c4 18             	add    $0x18,%esp
  801d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d35:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d39:	75 07                	jne    801d42 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d40:	eb 05                	jmp    801d47 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d47:	c9                   	leave  
  801d48:	c3                   	ret    

00801d49 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	6a 00                	push   $0x0
  801d59:	6a 2c                	push   $0x2c
  801d5b:	e8 7b fa ff ff       	call   8017db <syscall>
  801d60:	83 c4 18             	add    $0x18,%esp
  801d63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d66:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d6a:	75 07                	jne    801d73 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d71:	eb 05                	jmp    801d78 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
  801d7d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 2c                	push   $0x2c
  801d8c:	e8 4a fa ff ff       	call   8017db <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
  801d94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d97:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d9b:	75 07                	jne    801da4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d9d:	b8 01 00 00 00       	mov    $0x1,%eax
  801da2:	eb 05                	jmp    801da9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801da4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
  801dae:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	6a 00                	push   $0x0
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 2c                	push   $0x2c
  801dbd:	e8 19 fa ff ff       	call   8017db <syscall>
  801dc2:	83 c4 18             	add    $0x18,%esp
  801dc5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dcc:	75 07                	jne    801dd5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dce:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd3:	eb 05                	jmp    801dda <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	ff 75 08             	pushl  0x8(%ebp)
  801dea:	6a 2d                	push   $0x2d
  801dec:	e8 ea f9 ff ff       	call   8017db <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
	return ;
  801df4:	90                   	nop
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
  801dfa:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dfb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dfe:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	53                   	push   %ebx
  801e0a:	51                   	push   %ecx
  801e0b:	52                   	push   %edx
  801e0c:	50                   	push   %eax
  801e0d:	6a 2e                	push   $0x2e
  801e0f:	e8 c7 f9 ff ff       	call   8017db <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
}
  801e17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e1a:	c9                   	leave  
  801e1b:	c3                   	ret    

00801e1c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e22:	8b 45 08             	mov    0x8(%ebp),%eax
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	52                   	push   %edx
  801e2c:	50                   	push   %eax
  801e2d:	6a 2f                	push   $0x2f
  801e2f:	e8 a7 f9 ff ff       	call   8017db <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e3f:	83 ec 0c             	sub    $0xc,%esp
  801e42:	68 bc 3a 80 00       	push   $0x803abc
  801e47:	e8 df e6 ff ff       	call   80052b <cprintf>
  801e4c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	68 e8 3a 80 00       	push   $0x803ae8
  801e5e:	e8 c8 e6 ff ff       	call   80052b <cprintf>
  801e63:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e66:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e6a:	a1 38 41 80 00       	mov    0x804138,%eax
  801e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e72:	eb 56                	jmp    801eca <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e74:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e78:	74 1c                	je     801e96 <print_mem_block_lists+0x5d>
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	8b 50 08             	mov    0x8(%eax),%edx
  801e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e83:	8b 48 08             	mov    0x8(%eax),%ecx
  801e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e89:	8b 40 0c             	mov    0xc(%eax),%eax
  801e8c:	01 c8                	add    %ecx,%eax
  801e8e:	39 c2                	cmp    %eax,%edx
  801e90:	73 04                	jae    801e96 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e92:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	8b 50 08             	mov    0x8(%eax),%edx
  801e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e9f:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea2:	01 c2                	add    %eax,%edx
  801ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea7:	8b 40 08             	mov    0x8(%eax),%eax
  801eaa:	83 ec 04             	sub    $0x4,%esp
  801ead:	52                   	push   %edx
  801eae:	50                   	push   %eax
  801eaf:	68 fd 3a 80 00       	push   $0x803afd
  801eb4:	e8 72 e6 ff ff       	call   80052b <cprintf>
  801eb9:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ec2:	a1 40 41 80 00       	mov    0x804140,%eax
  801ec7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ece:	74 07                	je     801ed7 <print_mem_block_lists+0x9e>
  801ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed3:	8b 00                	mov    (%eax),%eax
  801ed5:	eb 05                	jmp    801edc <print_mem_block_lists+0xa3>
  801ed7:	b8 00 00 00 00       	mov    $0x0,%eax
  801edc:	a3 40 41 80 00       	mov    %eax,0x804140
  801ee1:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee6:	85 c0                	test   %eax,%eax
  801ee8:	75 8a                	jne    801e74 <print_mem_block_lists+0x3b>
  801eea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eee:	75 84                	jne    801e74 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ef0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ef4:	75 10                	jne    801f06 <print_mem_block_lists+0xcd>
  801ef6:	83 ec 0c             	sub    $0xc,%esp
  801ef9:	68 0c 3b 80 00       	push   $0x803b0c
  801efe:	e8 28 e6 ff ff       	call   80052b <cprintf>
  801f03:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f06:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f0d:	83 ec 0c             	sub    $0xc,%esp
  801f10:	68 30 3b 80 00       	push   $0x803b30
  801f15:	e8 11 e6 ff ff       	call   80052b <cprintf>
  801f1a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f1d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f21:	a1 40 40 80 00       	mov    0x804040,%eax
  801f26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f29:	eb 56                	jmp    801f81 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f2f:	74 1c                	je     801f4d <print_mem_block_lists+0x114>
  801f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f34:	8b 50 08             	mov    0x8(%eax),%edx
  801f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f40:	8b 40 0c             	mov    0xc(%eax),%eax
  801f43:	01 c8                	add    %ecx,%eax
  801f45:	39 c2                	cmp    %eax,%edx
  801f47:	73 04                	jae    801f4d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f49:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 50 08             	mov    0x8(%eax),%edx
  801f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f56:	8b 40 0c             	mov    0xc(%eax),%eax
  801f59:	01 c2                	add    %eax,%edx
  801f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5e:	8b 40 08             	mov    0x8(%eax),%eax
  801f61:	83 ec 04             	sub    $0x4,%esp
  801f64:	52                   	push   %edx
  801f65:	50                   	push   %eax
  801f66:	68 fd 3a 80 00       	push   $0x803afd
  801f6b:	e8 bb e5 ff ff       	call   80052b <cprintf>
  801f70:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f79:	a1 48 40 80 00       	mov    0x804048,%eax
  801f7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f85:	74 07                	je     801f8e <print_mem_block_lists+0x155>
  801f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8a:	8b 00                	mov    (%eax),%eax
  801f8c:	eb 05                	jmp    801f93 <print_mem_block_lists+0x15a>
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	a3 48 40 80 00       	mov    %eax,0x804048
  801f98:	a1 48 40 80 00       	mov    0x804048,%eax
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	75 8a                	jne    801f2b <print_mem_block_lists+0xf2>
  801fa1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa5:	75 84                	jne    801f2b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fab:	75 10                	jne    801fbd <print_mem_block_lists+0x184>
  801fad:	83 ec 0c             	sub    $0xc,%esp
  801fb0:	68 48 3b 80 00       	push   $0x803b48
  801fb5:	e8 71 e5 ff ff       	call   80052b <cprintf>
  801fba:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fbd:	83 ec 0c             	sub    $0xc,%esp
  801fc0:	68 bc 3a 80 00       	push   $0x803abc
  801fc5:	e8 61 e5 ff ff       	call   80052b <cprintf>
  801fca:	83 c4 10             	add    $0x10,%esp

}
  801fcd:	90                   	nop
  801fce:	c9                   	leave  
  801fcf:	c3                   	ret    

00801fd0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fd0:	55                   	push   %ebp
  801fd1:	89 e5                	mov    %esp,%ebp
  801fd3:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fd6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fdd:	00 00 00 
  801fe0:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fe7:	00 00 00 
  801fea:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ff1:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  801ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ffb:	e9 9e 00 00 00       	jmp    80209e <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802000:	a1 50 40 80 00       	mov    0x804050,%eax
  802005:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802008:	c1 e2 04             	shl    $0x4,%edx
  80200b:	01 d0                	add    %edx,%eax
  80200d:	85 c0                	test   %eax,%eax
  80200f:	75 14                	jne    802025 <initialize_MemBlocksList+0x55>
  802011:	83 ec 04             	sub    $0x4,%esp
  802014:	68 70 3b 80 00       	push   $0x803b70
  802019:	6a 42                	push   $0x42
  80201b:	68 93 3b 80 00       	push   $0x803b93
  802020:	e8 52 e2 ff ff       	call   800277 <_panic>
  802025:	a1 50 40 80 00       	mov    0x804050,%eax
  80202a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80202d:	c1 e2 04             	shl    $0x4,%edx
  802030:	01 d0                	add    %edx,%eax
  802032:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802038:	89 10                	mov    %edx,(%eax)
  80203a:	8b 00                	mov    (%eax),%eax
  80203c:	85 c0                	test   %eax,%eax
  80203e:	74 18                	je     802058 <initialize_MemBlocksList+0x88>
  802040:	a1 48 41 80 00       	mov    0x804148,%eax
  802045:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80204b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80204e:	c1 e1 04             	shl    $0x4,%ecx
  802051:	01 ca                	add    %ecx,%edx
  802053:	89 50 04             	mov    %edx,0x4(%eax)
  802056:	eb 12                	jmp    80206a <initialize_MemBlocksList+0x9a>
  802058:	a1 50 40 80 00       	mov    0x804050,%eax
  80205d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802060:	c1 e2 04             	shl    $0x4,%edx
  802063:	01 d0                	add    %edx,%eax
  802065:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80206a:	a1 50 40 80 00       	mov    0x804050,%eax
  80206f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802072:	c1 e2 04             	shl    $0x4,%edx
  802075:	01 d0                	add    %edx,%eax
  802077:	a3 48 41 80 00       	mov    %eax,0x804148
  80207c:	a1 50 40 80 00       	mov    0x804050,%eax
  802081:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802084:	c1 e2 04             	shl    $0x4,%edx
  802087:	01 d0                	add    %edx,%eax
  802089:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802090:	a1 54 41 80 00       	mov    0x804154,%eax
  802095:	40                   	inc    %eax
  802096:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80209b:	ff 45 f4             	incl   -0xc(%ebp)
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020a4:	0f 82 56 ff ff ff    	jb     802000 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8020aa:	90                   	nop
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b6:	8b 00                	mov    (%eax),%eax
  8020b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020bb:	eb 19                	jmp    8020d6 <find_block+0x29>
	{
		if(blk->sva==va)
  8020bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c0:	8b 40 08             	mov    0x8(%eax),%eax
  8020c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020c6:	75 05                	jne    8020cd <find_block+0x20>
			return (blk);
  8020c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020cb:	eb 36                	jmp    802103 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d0:	8b 40 08             	mov    0x8(%eax),%eax
  8020d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020da:	74 07                	je     8020e3 <find_block+0x36>
  8020dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020df:	8b 00                	mov    (%eax),%eax
  8020e1:	eb 05                	jmp    8020e8 <find_block+0x3b>
  8020e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8020eb:	89 42 08             	mov    %eax,0x8(%edx)
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8b 40 08             	mov    0x8(%eax),%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	75 c5                	jne    8020bd <find_block+0x10>
  8020f8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020fc:	75 bf                	jne    8020bd <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8020fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802103:	c9                   	leave  
  802104:	c3                   	ret    

00802105 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802105:	55                   	push   %ebp
  802106:	89 e5                	mov    %esp,%ebp
  802108:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80210b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802110:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802113:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80211a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80211d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802120:	75 65                	jne    802187 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802122:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802126:	75 14                	jne    80213c <insert_sorted_allocList+0x37>
  802128:	83 ec 04             	sub    $0x4,%esp
  80212b:	68 70 3b 80 00       	push   $0x803b70
  802130:	6a 5c                	push   $0x5c
  802132:	68 93 3b 80 00       	push   $0x803b93
  802137:	e8 3b e1 ff ff       	call   800277 <_panic>
  80213c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	89 10                	mov    %edx,(%eax)
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	8b 00                	mov    (%eax),%eax
  80214c:	85 c0                	test   %eax,%eax
  80214e:	74 0d                	je     80215d <insert_sorted_allocList+0x58>
  802150:	a1 40 40 80 00       	mov    0x804040,%eax
  802155:	8b 55 08             	mov    0x8(%ebp),%edx
  802158:	89 50 04             	mov    %edx,0x4(%eax)
  80215b:	eb 08                	jmp    802165 <insert_sorted_allocList+0x60>
  80215d:	8b 45 08             	mov    0x8(%ebp),%eax
  802160:	a3 44 40 80 00       	mov    %eax,0x804044
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	a3 40 40 80 00       	mov    %eax,0x804040
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802177:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80217c:	40                   	inc    %eax
  80217d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802182:	e9 7b 01 00 00       	jmp    802302 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802187:	a1 44 40 80 00       	mov    0x804044,%eax
  80218c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80218f:	a1 40 40 80 00       	mov    0x804040,%eax
  802194:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802197:	8b 45 08             	mov    0x8(%ebp),%eax
  80219a:	8b 50 08             	mov    0x8(%eax),%edx
  80219d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021a0:	8b 40 08             	mov    0x8(%eax),%eax
  8021a3:	39 c2                	cmp    %eax,%edx
  8021a5:	76 65                	jbe    80220c <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8021a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ab:	75 14                	jne    8021c1 <insert_sorted_allocList+0xbc>
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	68 ac 3b 80 00       	push   $0x803bac
  8021b5:	6a 64                	push   $0x64
  8021b7:	68 93 3b 80 00       	push   $0x803b93
  8021bc:	e8 b6 e0 ff ff       	call   800277 <_panic>
  8021c1:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	89 50 04             	mov    %edx,0x4(%eax)
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	8b 40 04             	mov    0x4(%eax),%eax
  8021d3:	85 c0                	test   %eax,%eax
  8021d5:	74 0c                	je     8021e3 <insert_sorted_allocList+0xde>
  8021d7:	a1 44 40 80 00       	mov    0x804044,%eax
  8021dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8021df:	89 10                	mov    %edx,(%eax)
  8021e1:	eb 08                	jmp    8021eb <insert_sorted_allocList+0xe6>
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	a3 40 40 80 00       	mov    %eax,0x804040
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	a3 44 40 80 00       	mov    %eax,0x804044
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021fc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802201:	40                   	inc    %eax
  802202:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802207:	e9 f6 00 00 00       	jmp    802302 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 50 08             	mov    0x8(%eax),%edx
  802212:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802215:	8b 40 08             	mov    0x8(%eax),%eax
  802218:	39 c2                	cmp    %eax,%edx
  80221a:	73 65                	jae    802281 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80221c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802220:	75 14                	jne    802236 <insert_sorted_allocList+0x131>
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 70 3b 80 00       	push   $0x803b70
  80222a:	6a 68                	push   $0x68
  80222c:	68 93 3b 80 00       	push   $0x803b93
  802231:	e8 41 e0 ff ff       	call   800277 <_panic>
  802236:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	89 10                	mov    %edx,(%eax)
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	8b 00                	mov    (%eax),%eax
  802246:	85 c0                	test   %eax,%eax
  802248:	74 0d                	je     802257 <insert_sorted_allocList+0x152>
  80224a:	a1 40 40 80 00       	mov    0x804040,%eax
  80224f:	8b 55 08             	mov    0x8(%ebp),%edx
  802252:	89 50 04             	mov    %edx,0x4(%eax)
  802255:	eb 08                	jmp    80225f <insert_sorted_allocList+0x15a>
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	a3 44 40 80 00       	mov    %eax,0x804044
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	a3 40 40 80 00       	mov    %eax,0x804040
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802271:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802276:	40                   	inc    %eax
  802277:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80227c:	e9 81 00 00 00       	jmp    802302 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802281:	a1 40 40 80 00       	mov    0x804040,%eax
  802286:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802289:	eb 51                	jmp    8022dc <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	8b 50 08             	mov    0x8(%eax),%edx
  802291:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802294:	8b 40 08             	mov    0x8(%eax),%eax
  802297:	39 c2                	cmp    %eax,%edx
  802299:	73 39                	jae    8022d4 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  80229b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229e:	8b 40 04             	mov    0x4(%eax),%eax
  8022a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8022a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022aa:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022b2:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bb:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c3:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8022c6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022cb:	40                   	inc    %eax
  8022cc:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8022d1:	90                   	nop
				}
			}
		 }

	}
}
  8022d2:	eb 2e                	jmp    802302 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022d4:	a1 48 40 80 00       	mov    0x804048,%eax
  8022d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e0:	74 07                	je     8022e9 <insert_sorted_allocList+0x1e4>
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 00                	mov    (%eax),%eax
  8022e7:	eb 05                	jmp    8022ee <insert_sorted_allocList+0x1e9>
  8022e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ee:	a3 48 40 80 00       	mov    %eax,0x804048
  8022f3:	a1 48 40 80 00       	mov    0x804048,%eax
  8022f8:	85 c0                	test   %eax,%eax
  8022fa:	75 8f                	jne    80228b <insert_sorted_allocList+0x186>
  8022fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802300:	75 89                	jne    80228b <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802302:	90                   	nop
  802303:	c9                   	leave  
  802304:	c3                   	ret    

00802305 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802305:	55                   	push   %ebp
  802306:	89 e5                	mov    %esp,%ebp
  802308:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80230b:	a1 38 41 80 00       	mov    0x804138,%eax
  802310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802313:	e9 76 01 00 00       	jmp    80248e <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 40 0c             	mov    0xc(%eax),%eax
  80231e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802321:	0f 85 8a 00 00 00    	jne    8023b1 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802327:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80232b:	75 17                	jne    802344 <alloc_block_FF+0x3f>
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	68 cf 3b 80 00       	push   $0x803bcf
  802335:	68 8a 00 00 00       	push   $0x8a
  80233a:	68 93 3b 80 00       	push   $0x803b93
  80233f:	e8 33 df ff ff       	call   800277 <_panic>
  802344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802347:	8b 00                	mov    (%eax),%eax
  802349:	85 c0                	test   %eax,%eax
  80234b:	74 10                	je     80235d <alloc_block_FF+0x58>
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	8b 00                	mov    (%eax),%eax
  802352:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802355:	8b 52 04             	mov    0x4(%edx),%edx
  802358:	89 50 04             	mov    %edx,0x4(%eax)
  80235b:	eb 0b                	jmp    802368 <alloc_block_FF+0x63>
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	8b 40 04             	mov    0x4(%eax),%eax
  802363:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236b:	8b 40 04             	mov    0x4(%eax),%eax
  80236e:	85 c0                	test   %eax,%eax
  802370:	74 0f                	je     802381 <alloc_block_FF+0x7c>
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 40 04             	mov    0x4(%eax),%eax
  802378:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80237b:	8b 12                	mov    (%edx),%edx
  80237d:	89 10                	mov    %edx,(%eax)
  80237f:	eb 0a                	jmp    80238b <alloc_block_FF+0x86>
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 00                	mov    (%eax),%eax
  802386:	a3 38 41 80 00       	mov    %eax,0x804138
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802397:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80239e:	a1 44 41 80 00       	mov    0x804144,%eax
  8023a3:	48                   	dec    %eax
  8023a4:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	e9 10 01 00 00       	jmp    8024c1 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023ba:	0f 86 c6 00 00 00    	jbe    802486 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8023c0:	a1 48 41 80 00       	mov    0x804148,%eax
  8023c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8023c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023cc:	75 17                	jne    8023e5 <alloc_block_FF+0xe0>
  8023ce:	83 ec 04             	sub    $0x4,%esp
  8023d1:	68 cf 3b 80 00       	push   $0x803bcf
  8023d6:	68 90 00 00 00       	push   $0x90
  8023db:	68 93 3b 80 00       	push   $0x803b93
  8023e0:	e8 92 de ff ff       	call   800277 <_panic>
  8023e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	85 c0                	test   %eax,%eax
  8023ec:	74 10                	je     8023fe <alloc_block_FF+0xf9>
  8023ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f6:	8b 52 04             	mov    0x4(%edx),%edx
  8023f9:	89 50 04             	mov    %edx,0x4(%eax)
  8023fc:	eb 0b                	jmp    802409 <alloc_block_FF+0x104>
  8023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802401:	8b 40 04             	mov    0x4(%eax),%eax
  802404:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802409:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240c:	8b 40 04             	mov    0x4(%eax),%eax
  80240f:	85 c0                	test   %eax,%eax
  802411:	74 0f                	je     802422 <alloc_block_FF+0x11d>
  802413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802416:	8b 40 04             	mov    0x4(%eax),%eax
  802419:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80241c:	8b 12                	mov    (%edx),%edx
  80241e:	89 10                	mov    %edx,(%eax)
  802420:	eb 0a                	jmp    80242c <alloc_block_FF+0x127>
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	8b 00                	mov    (%eax),%eax
  802427:	a3 48 41 80 00       	mov    %eax,0x804148
  80242c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802435:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802438:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243f:	a1 54 41 80 00       	mov    0x804154,%eax
  802444:	48                   	dec    %eax
  802445:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  80244a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244d:	8b 55 08             	mov    0x8(%ebp),%edx
  802450:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802456:	8b 50 08             	mov    0x8(%eax),%edx
  802459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245c:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	8b 50 08             	mov    0x8(%eax),%edx
  802465:	8b 45 08             	mov    0x8(%ebp),%eax
  802468:	01 c2                	add    %eax,%edx
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802470:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802473:	8b 40 0c             	mov    0xc(%eax),%eax
  802476:	2b 45 08             	sub    0x8(%ebp),%eax
  802479:	89 c2                	mov    %eax,%edx
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802484:	eb 3b                	jmp    8024c1 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802486:	a1 40 41 80 00       	mov    0x804140,%eax
  80248b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802492:	74 07                	je     80249b <alloc_block_FF+0x196>
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	eb 05                	jmp    8024a0 <alloc_block_FF+0x19b>
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a0:	a3 40 41 80 00       	mov    %eax,0x804140
  8024a5:	a1 40 41 80 00       	mov    0x804140,%eax
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	0f 85 66 fe ff ff    	jne    802318 <alloc_block_FF+0x13>
  8024b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b6:	0f 85 5c fe ff ff    	jne    802318 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8024c9:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8024d0:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8024d7:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8024de:	a1 38 41 80 00       	mov    0x804138,%eax
  8024e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e6:	e9 cf 00 00 00       	jmp    8025ba <alloc_block_BF+0xf7>
		{
			c++;
  8024eb:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f7:	0f 85 8a 00 00 00    	jne    802587 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8024fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802501:	75 17                	jne    80251a <alloc_block_BF+0x57>
  802503:	83 ec 04             	sub    $0x4,%esp
  802506:	68 cf 3b 80 00       	push   $0x803bcf
  80250b:	68 a8 00 00 00       	push   $0xa8
  802510:	68 93 3b 80 00       	push   $0x803b93
  802515:	e8 5d dd ff ff       	call   800277 <_panic>
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 00                	mov    (%eax),%eax
  80251f:	85 c0                	test   %eax,%eax
  802521:	74 10                	je     802533 <alloc_block_BF+0x70>
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 00                	mov    (%eax),%eax
  802528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252b:	8b 52 04             	mov    0x4(%edx),%edx
  80252e:	89 50 04             	mov    %edx,0x4(%eax)
  802531:	eb 0b                	jmp    80253e <alloc_block_BF+0x7b>
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 40 04             	mov    0x4(%eax),%eax
  802539:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 40 04             	mov    0x4(%eax),%eax
  802544:	85 c0                	test   %eax,%eax
  802546:	74 0f                	je     802557 <alloc_block_BF+0x94>
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 04             	mov    0x4(%eax),%eax
  80254e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802551:	8b 12                	mov    (%edx),%edx
  802553:	89 10                	mov    %edx,(%eax)
  802555:	eb 0a                	jmp    802561 <alloc_block_BF+0x9e>
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 00                	mov    (%eax),%eax
  80255c:	a3 38 41 80 00       	mov    %eax,0x804138
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802574:	a1 44 41 80 00       	mov    0x804144,%eax
  802579:	48                   	dec    %eax
  80257a:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  80257f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802582:	e9 85 01 00 00       	jmp    80270c <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 0c             	mov    0xc(%eax),%eax
  80258d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802590:	76 20                	jbe    8025b2 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 40 0c             	mov    0xc(%eax),%eax
  802598:	2b 45 08             	sub    0x8(%ebp),%eax
  80259b:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  80259e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025a1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025a4:	73 0c                	jae    8025b2 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8025a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8025ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025af:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025be:	74 07                	je     8025c7 <alloc_block_BF+0x104>
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	eb 05                	jmp    8025cc <alloc_block_BF+0x109>
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	0f 85 0d ff ff ff    	jne    8024eb <alloc_block_BF+0x28>
  8025de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e2:	0f 85 03 ff ff ff    	jne    8024eb <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8025e8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025ef:	a1 38 41 80 00       	mov    0x804138,%eax
  8025f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f7:	e9 dd 00 00 00       	jmp    8026d9 <alloc_block_BF+0x216>
		{
			if(x==sol)
  8025fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ff:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802602:	0f 85 c6 00 00 00    	jne    8026ce <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802608:	a1 48 41 80 00       	mov    0x804148,%eax
  80260d:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802610:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802614:	75 17                	jne    80262d <alloc_block_BF+0x16a>
  802616:	83 ec 04             	sub    $0x4,%esp
  802619:	68 cf 3b 80 00       	push   $0x803bcf
  80261e:	68 bb 00 00 00       	push   $0xbb
  802623:	68 93 3b 80 00       	push   $0x803b93
  802628:	e8 4a dc ff ff       	call   800277 <_panic>
  80262d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	85 c0                	test   %eax,%eax
  802634:	74 10                	je     802646 <alloc_block_BF+0x183>
  802636:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802639:	8b 00                	mov    (%eax),%eax
  80263b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80263e:	8b 52 04             	mov    0x4(%edx),%edx
  802641:	89 50 04             	mov    %edx,0x4(%eax)
  802644:	eb 0b                	jmp    802651 <alloc_block_BF+0x18e>
  802646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802649:	8b 40 04             	mov    0x4(%eax),%eax
  80264c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802651:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802654:	8b 40 04             	mov    0x4(%eax),%eax
  802657:	85 c0                	test   %eax,%eax
  802659:	74 0f                	je     80266a <alloc_block_BF+0x1a7>
  80265b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265e:	8b 40 04             	mov    0x4(%eax),%eax
  802661:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802664:	8b 12                	mov    (%edx),%edx
  802666:	89 10                	mov    %edx,(%eax)
  802668:	eb 0a                	jmp    802674 <alloc_block_BF+0x1b1>
  80266a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266d:	8b 00                	mov    (%eax),%eax
  80266f:	a3 48 41 80 00       	mov    %eax,0x804148
  802674:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802677:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802680:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802687:	a1 54 41 80 00       	mov    0x804154,%eax
  80268c:	48                   	dec    %eax
  80268d:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802692:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802695:	8b 55 08             	mov    0x8(%ebp),%edx
  802698:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  80269b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269e:	8b 50 08             	mov    0x8(%eax),%edx
  8026a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a4:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	8b 50 08             	mov    0x8(%eax),%edx
  8026ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b0:	01 c2                	add    %eax,%edx
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026be:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c1:	89 c2                	mov    %eax,%edx
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8026c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026cc:	eb 3e                	jmp    80270c <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8026ce:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dd:	74 07                	je     8026e6 <alloc_block_BF+0x223>
  8026df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e2:	8b 00                	mov    (%eax),%eax
  8026e4:	eb 05                	jmp    8026eb <alloc_block_BF+0x228>
  8026e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8026eb:	a3 40 41 80 00       	mov    %eax,0x804140
  8026f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	0f 85 ff fe ff ff    	jne    8025fc <alloc_block_BF+0x139>
  8026fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802701:	0f 85 f5 fe ff ff    	jne    8025fc <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
  802711:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802714:	a1 28 40 80 00       	mov    0x804028,%eax
  802719:	85 c0                	test   %eax,%eax
  80271b:	75 14                	jne    802731 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80271d:	a1 38 41 80 00       	mov    0x804138,%eax
  802722:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802727:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80272e:	00 00 00 
	}
	uint32 c=1;
  802731:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802738:	a1 60 41 80 00       	mov    0x804160,%eax
  80273d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802740:	e9 b3 01 00 00       	jmp    8028f8 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802745:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802748:	8b 40 0c             	mov    0xc(%eax),%eax
  80274b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80274e:	0f 85 a9 00 00 00    	jne    8027fd <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802754:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802757:	8b 00                	mov    (%eax),%eax
  802759:	85 c0                	test   %eax,%eax
  80275b:	75 0c                	jne    802769 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80275d:	a1 38 41 80 00       	mov    0x804138,%eax
  802762:	a3 60 41 80 00       	mov    %eax,0x804160
  802767:	eb 0a                	jmp    802773 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802769:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802773:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802777:	75 17                	jne    802790 <alloc_block_NF+0x82>
  802779:	83 ec 04             	sub    $0x4,%esp
  80277c:	68 cf 3b 80 00       	push   $0x803bcf
  802781:	68 e3 00 00 00       	push   $0xe3
  802786:	68 93 3b 80 00       	push   $0x803b93
  80278b:	e8 e7 da ff ff       	call   800277 <_panic>
  802790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802793:	8b 00                	mov    (%eax),%eax
  802795:	85 c0                	test   %eax,%eax
  802797:	74 10                	je     8027a9 <alloc_block_NF+0x9b>
  802799:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279c:	8b 00                	mov    (%eax),%eax
  80279e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a1:	8b 52 04             	mov    0x4(%edx),%edx
  8027a4:	89 50 04             	mov    %edx,0x4(%eax)
  8027a7:	eb 0b                	jmp    8027b4 <alloc_block_NF+0xa6>
  8027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ac:	8b 40 04             	mov    0x4(%eax),%eax
  8027af:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b7:	8b 40 04             	mov    0x4(%eax),%eax
  8027ba:	85 c0                	test   %eax,%eax
  8027bc:	74 0f                	je     8027cd <alloc_block_NF+0xbf>
  8027be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c1:	8b 40 04             	mov    0x4(%eax),%eax
  8027c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c7:	8b 12                	mov    (%edx),%edx
  8027c9:	89 10                	mov    %edx,(%eax)
  8027cb:	eb 0a                	jmp    8027d7 <alloc_block_NF+0xc9>
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	8b 00                	mov    (%eax),%eax
  8027d2:	a3 38 41 80 00       	mov    %eax,0x804138
  8027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ea:	a1 44 41 80 00       	mov    0x804144,%eax
  8027ef:	48                   	dec    %eax
  8027f0:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  8027f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f8:	e9 0e 01 00 00       	jmp    80290b <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8027fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802800:	8b 40 0c             	mov    0xc(%eax),%eax
  802803:	3b 45 08             	cmp    0x8(%ebp),%eax
  802806:	0f 86 ce 00 00 00    	jbe    8028da <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80280c:	a1 48 41 80 00       	mov    0x804148,%eax
  802811:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802814:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802818:	75 17                	jne    802831 <alloc_block_NF+0x123>
  80281a:	83 ec 04             	sub    $0x4,%esp
  80281d:	68 cf 3b 80 00       	push   $0x803bcf
  802822:	68 e9 00 00 00       	push   $0xe9
  802827:	68 93 3b 80 00       	push   $0x803b93
  80282c:	e8 46 da ff ff       	call   800277 <_panic>
  802831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802834:	8b 00                	mov    (%eax),%eax
  802836:	85 c0                	test   %eax,%eax
  802838:	74 10                	je     80284a <alloc_block_NF+0x13c>
  80283a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283d:	8b 00                	mov    (%eax),%eax
  80283f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802842:	8b 52 04             	mov    0x4(%edx),%edx
  802845:	89 50 04             	mov    %edx,0x4(%eax)
  802848:	eb 0b                	jmp    802855 <alloc_block_NF+0x147>
  80284a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284d:	8b 40 04             	mov    0x4(%eax),%eax
  802850:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802858:	8b 40 04             	mov    0x4(%eax),%eax
  80285b:	85 c0                	test   %eax,%eax
  80285d:	74 0f                	je     80286e <alloc_block_NF+0x160>
  80285f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802862:	8b 40 04             	mov    0x4(%eax),%eax
  802865:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802868:	8b 12                	mov    (%edx),%edx
  80286a:	89 10                	mov    %edx,(%eax)
  80286c:	eb 0a                	jmp    802878 <alloc_block_NF+0x16a>
  80286e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802871:	8b 00                	mov    (%eax),%eax
  802873:	a3 48 41 80 00       	mov    %eax,0x804148
  802878:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802881:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802884:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80288b:	a1 54 41 80 00       	mov    0x804154,%eax
  802890:	48                   	dec    %eax
  802891:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802896:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802899:	8b 55 08             	mov    0x8(%ebp),%edx
  80289c:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  80289f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a2:	8b 50 08             	mov    0x8(%eax),%edx
  8028a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a8:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8028ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ae:	8b 50 08             	mov    0x8(%eax),%edx
  8028b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b4:	01 c2                	add    %eax,%edx
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8028bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c2:	2b 45 08             	sub    0x8(%ebp),%eax
  8028c5:	89 c2                	mov    %eax,%edx
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8028d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d8:	eb 31                	jmp    80290b <alloc_block_NF+0x1fd>
			 }
		 c++;
  8028da:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	75 0a                	jne    8028f0 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8028e6:	a1 38 41 80 00       	mov    0x804138,%eax
  8028eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028ee:	eb 08                	jmp    8028f8 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8028f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f3:	8b 00                	mov    (%eax),%eax
  8028f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8028f8:	a1 44 41 80 00       	mov    0x804144,%eax
  8028fd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802900:	0f 85 3f fe ff ff    	jne    802745 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802906:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80290b:	c9                   	leave  
  80290c:	c3                   	ret    

0080290d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80290d:	55                   	push   %ebp
  80290e:	89 e5                	mov    %esp,%ebp
  802910:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802913:	a1 44 41 80 00       	mov    0x804144,%eax
  802918:	85 c0                	test   %eax,%eax
  80291a:	75 68                	jne    802984 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80291c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802920:	75 17                	jne    802939 <insert_sorted_with_merge_freeList+0x2c>
  802922:	83 ec 04             	sub    $0x4,%esp
  802925:	68 70 3b 80 00       	push   $0x803b70
  80292a:	68 0e 01 00 00       	push   $0x10e
  80292f:	68 93 3b 80 00       	push   $0x803b93
  802934:	e8 3e d9 ff ff       	call   800277 <_panic>
  802939:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80293f:	8b 45 08             	mov    0x8(%ebp),%eax
  802942:	89 10                	mov    %edx,(%eax)
  802944:	8b 45 08             	mov    0x8(%ebp),%eax
  802947:	8b 00                	mov    (%eax),%eax
  802949:	85 c0                	test   %eax,%eax
  80294b:	74 0d                	je     80295a <insert_sorted_with_merge_freeList+0x4d>
  80294d:	a1 38 41 80 00       	mov    0x804138,%eax
  802952:	8b 55 08             	mov    0x8(%ebp),%edx
  802955:	89 50 04             	mov    %edx,0x4(%eax)
  802958:	eb 08                	jmp    802962 <insert_sorted_with_merge_freeList+0x55>
  80295a:	8b 45 08             	mov    0x8(%ebp),%eax
  80295d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	a3 38 41 80 00       	mov    %eax,0x804138
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802974:	a1 44 41 80 00       	mov    0x804144,%eax
  802979:	40                   	inc    %eax
  80297a:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  80297f:	e9 8c 06 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802984:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802989:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  80298c:	a1 38 41 80 00       	mov    0x804138,%eax
  802991:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	8b 50 08             	mov    0x8(%eax),%edx
  80299a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299d:	8b 40 08             	mov    0x8(%eax),%eax
  8029a0:	39 c2                	cmp    %eax,%edx
  8029a2:	0f 86 14 01 00 00    	jbe    802abc <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8029a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8029ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b1:	8b 40 08             	mov    0x8(%eax),%eax
  8029b4:	01 c2                	add    %eax,%edx
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	8b 40 08             	mov    0x8(%eax),%eax
  8029bc:	39 c2                	cmp    %eax,%edx
  8029be:	0f 85 90 00 00 00    	jne    802a54 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 50 0c             	mov    0xc(%eax),%edx
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8029d0:	01 c2                	add    %eax,%edx
  8029d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d5:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f0:	75 17                	jne    802a09 <insert_sorted_with_merge_freeList+0xfc>
  8029f2:	83 ec 04             	sub    $0x4,%esp
  8029f5:	68 70 3b 80 00       	push   $0x803b70
  8029fa:	68 1b 01 00 00       	push   $0x11b
  8029ff:	68 93 3b 80 00       	push   $0x803b93
  802a04:	e8 6e d8 ff ff       	call   800277 <_panic>
  802a09:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	89 10                	mov    %edx,(%eax)
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	74 0d                	je     802a2a <insert_sorted_with_merge_freeList+0x11d>
  802a1d:	a1 48 41 80 00       	mov    0x804148,%eax
  802a22:	8b 55 08             	mov    0x8(%ebp),%edx
  802a25:	89 50 04             	mov    %edx,0x4(%eax)
  802a28:	eb 08                	jmp    802a32 <insert_sorted_with_merge_freeList+0x125>
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	a3 48 41 80 00       	mov    %eax,0x804148
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a44:	a1 54 41 80 00       	mov    0x804154,%eax
  802a49:	40                   	inc    %eax
  802a4a:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802a4f:	e9 bc 05 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a58:	75 17                	jne    802a71 <insert_sorted_with_merge_freeList+0x164>
  802a5a:	83 ec 04             	sub    $0x4,%esp
  802a5d:	68 ac 3b 80 00       	push   $0x803bac
  802a62:	68 1f 01 00 00       	push   $0x11f
  802a67:	68 93 3b 80 00       	push   $0x803b93
  802a6c:	e8 06 d8 ff ff       	call   800277 <_panic>
  802a71:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	89 50 04             	mov    %edx,0x4(%eax)
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	74 0c                	je     802a93 <insert_sorted_with_merge_freeList+0x186>
  802a87:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8f:	89 10                	mov    %edx,(%eax)
  802a91:	eb 08                	jmp    802a9b <insert_sorted_with_merge_freeList+0x18e>
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	a3 38 41 80 00       	mov    %eax,0x804138
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aac:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab1:	40                   	inc    %eax
  802ab2:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802ab7:	e9 54 05 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	8b 50 08             	mov    0x8(%eax),%edx
  802ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac5:	8b 40 08             	mov    0x8(%eax),%eax
  802ac8:	39 c2                	cmp    %eax,%edx
  802aca:	0f 83 20 01 00 00    	jae    802bf0 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	8b 40 08             	mov    0x8(%eax),%eax
  802adc:	01 c2                	add    %eax,%edx
  802ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ae1:	8b 40 08             	mov    0x8(%eax),%eax
  802ae4:	39 c2                	cmp    %eax,%edx
  802ae6:	0f 85 9c 00 00 00    	jne    802b88 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 50 08             	mov    0x8(%eax),%edx
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afb:	8b 50 0c             	mov    0xc(%eax),%edx
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	8b 40 0c             	mov    0xc(%eax),%eax
  802b04:	01 c2                	add    %eax,%edx
  802b06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b09:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b20:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b24:	75 17                	jne    802b3d <insert_sorted_with_merge_freeList+0x230>
  802b26:	83 ec 04             	sub    $0x4,%esp
  802b29:	68 70 3b 80 00       	push   $0x803b70
  802b2e:	68 2a 01 00 00       	push   $0x12a
  802b33:	68 93 3b 80 00       	push   $0x803b93
  802b38:	e8 3a d7 ff ff       	call   800277 <_panic>
  802b3d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	89 10                	mov    %edx,(%eax)
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 00                	mov    (%eax),%eax
  802b4d:	85 c0                	test   %eax,%eax
  802b4f:	74 0d                	je     802b5e <insert_sorted_with_merge_freeList+0x251>
  802b51:	a1 48 41 80 00       	mov    0x804148,%eax
  802b56:	8b 55 08             	mov    0x8(%ebp),%edx
  802b59:	89 50 04             	mov    %edx,0x4(%eax)
  802b5c:	eb 08                	jmp    802b66 <insert_sorted_with_merge_freeList+0x259>
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	a3 48 41 80 00       	mov    %eax,0x804148
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b78:	a1 54 41 80 00       	mov    0x804154,%eax
  802b7d:	40                   	inc    %eax
  802b7e:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b83:	e9 88 04 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8c:	75 17                	jne    802ba5 <insert_sorted_with_merge_freeList+0x298>
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	68 70 3b 80 00       	push   $0x803b70
  802b96:	68 2e 01 00 00       	push   $0x12e
  802b9b:	68 93 3b 80 00       	push   $0x803b93
  802ba0:	e8 d2 d6 ff ff       	call   800277 <_panic>
  802ba5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	89 10                	mov    %edx,(%eax)
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	74 0d                	je     802bc6 <insert_sorted_with_merge_freeList+0x2b9>
  802bb9:	a1 38 41 80 00       	mov    0x804138,%eax
  802bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc1:	89 50 04             	mov    %edx,0x4(%eax)
  802bc4:	eb 08                	jmp    802bce <insert_sorted_with_merge_freeList+0x2c1>
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	a3 38 41 80 00       	mov    %eax,0x804138
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be0:	a1 44 41 80 00       	mov    0x804144,%eax
  802be5:	40                   	inc    %eax
  802be6:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802beb:	e9 20 04 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802bf0:	a1 38 41 80 00       	mov    0x804138,%eax
  802bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf8:	e9 e2 03 00 00       	jmp    802fdf <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802c00:	8b 50 08             	mov    0x8(%eax),%edx
  802c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c06:	8b 40 08             	mov    0x8(%eax),%eax
  802c09:	39 c2                	cmp    %eax,%edx
  802c0b:	0f 83 c6 03 00 00    	jae    802fd7 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 40 04             	mov    0x4(%eax),%eax
  802c17:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1d:	8b 50 08             	mov    0x8(%eax),%edx
  802c20:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c23:	8b 40 0c             	mov    0xc(%eax),%eax
  802c26:	01 d0                	add    %edx,%eax
  802c28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	8b 50 0c             	mov    0xc(%eax),%edx
  802c31:	8b 45 08             	mov    0x8(%ebp),%eax
  802c34:	8b 40 08             	mov    0x8(%eax),%eax
  802c37:	01 d0                	add    %edx,%eax
  802c39:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 40 08             	mov    0x8(%eax),%eax
  802c42:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c45:	74 7a                	je     802cc1 <insert_sorted_with_merge_freeList+0x3b4>
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 40 08             	mov    0x8(%eax),%eax
  802c4d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c50:	74 6f                	je     802cc1 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802c52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c56:	74 06                	je     802c5e <insert_sorted_with_merge_freeList+0x351>
  802c58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5c:	75 17                	jne    802c75 <insert_sorted_with_merge_freeList+0x368>
  802c5e:	83 ec 04             	sub    $0x4,%esp
  802c61:	68 f0 3b 80 00       	push   $0x803bf0
  802c66:	68 43 01 00 00       	push   $0x143
  802c6b:	68 93 3b 80 00       	push   $0x803b93
  802c70:	e8 02 d6 ff ff       	call   800277 <_panic>
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 50 04             	mov    0x4(%eax),%edx
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	89 50 04             	mov    %edx,0x4(%eax)
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c87:	89 10                	mov    %edx,(%eax)
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 40 04             	mov    0x4(%eax),%eax
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	74 0d                	je     802ca0 <insert_sorted_with_merge_freeList+0x393>
  802c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c96:	8b 40 04             	mov    0x4(%eax),%eax
  802c99:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9c:	89 10                	mov    %edx,(%eax)
  802c9e:	eb 08                	jmp    802ca8 <insert_sorted_with_merge_freeList+0x39b>
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	a3 38 41 80 00       	mov    %eax,0x804138
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 55 08             	mov    0x8(%ebp),%edx
  802cae:	89 50 04             	mov    %edx,0x4(%eax)
  802cb1:	a1 44 41 80 00       	mov    0x804144,%eax
  802cb6:	40                   	inc    %eax
  802cb7:	a3 44 41 80 00       	mov    %eax,0x804144
  802cbc:	e9 14 03 00 00       	jmp    802fd5 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	8b 40 08             	mov    0x8(%eax),%eax
  802cc7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cca:	0f 85 a0 01 00 00    	jne    802e70 <insert_sorted_with_merge_freeList+0x563>
  802cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd3:	8b 40 08             	mov    0x8(%eax),%eax
  802cd6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cd9:	0f 85 91 01 00 00    	jne    802e70 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802cdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce8:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ceb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cee:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf1:	01 c8                	add    %ecx,%eax
  802cf3:	01 c2                	add    %eax,%edx
  802cf5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf8:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802cfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d27:	75 17                	jne    802d40 <insert_sorted_with_merge_freeList+0x433>
  802d29:	83 ec 04             	sub    $0x4,%esp
  802d2c:	68 70 3b 80 00       	push   $0x803b70
  802d31:	68 4d 01 00 00       	push   $0x14d
  802d36:	68 93 3b 80 00       	push   $0x803b93
  802d3b:	e8 37 d5 ff ff       	call   800277 <_panic>
  802d40:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d46:	8b 45 08             	mov    0x8(%ebp),%eax
  802d49:	89 10                	mov    %edx,(%eax)
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	8b 00                	mov    (%eax),%eax
  802d50:	85 c0                	test   %eax,%eax
  802d52:	74 0d                	je     802d61 <insert_sorted_with_merge_freeList+0x454>
  802d54:	a1 48 41 80 00       	mov    0x804148,%eax
  802d59:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5c:	89 50 04             	mov    %edx,0x4(%eax)
  802d5f:	eb 08                	jmp    802d69 <insert_sorted_with_merge_freeList+0x45c>
  802d61:	8b 45 08             	mov    0x8(%ebp),%eax
  802d64:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d69:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6c:	a3 48 41 80 00       	mov    %eax,0x804148
  802d71:	8b 45 08             	mov    0x8(%ebp),%eax
  802d74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7b:	a1 54 41 80 00       	mov    0x804154,%eax
  802d80:	40                   	inc    %eax
  802d81:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d8a:	75 17                	jne    802da3 <insert_sorted_with_merge_freeList+0x496>
  802d8c:	83 ec 04             	sub    $0x4,%esp
  802d8f:	68 cf 3b 80 00       	push   $0x803bcf
  802d94:	68 4e 01 00 00       	push   $0x14e
  802d99:	68 93 3b 80 00       	push   $0x803b93
  802d9e:	e8 d4 d4 ff ff       	call   800277 <_panic>
  802da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da6:	8b 00                	mov    (%eax),%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	74 10                	je     802dbc <insert_sorted_with_merge_freeList+0x4af>
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 00                	mov    (%eax),%eax
  802db1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802db4:	8b 52 04             	mov    0x4(%edx),%edx
  802db7:	89 50 04             	mov    %edx,0x4(%eax)
  802dba:	eb 0b                	jmp    802dc7 <insert_sorted_with_merge_freeList+0x4ba>
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 40 04             	mov    0x4(%eax),%eax
  802dc2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dca:	8b 40 04             	mov    0x4(%eax),%eax
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	74 0f                	je     802de0 <insert_sorted_with_merge_freeList+0x4d3>
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dda:	8b 12                	mov    (%edx),%edx
  802ddc:	89 10                	mov    %edx,(%eax)
  802dde:	eb 0a                	jmp    802dea <insert_sorted_with_merge_freeList+0x4dd>
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 00                	mov    (%eax),%eax
  802de5:	a3 38 41 80 00       	mov    %eax,0x804138
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfd:	a1 44 41 80 00       	mov    0x804144,%eax
  802e02:	48                   	dec    %eax
  802e03:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e0c:	75 17                	jne    802e25 <insert_sorted_with_merge_freeList+0x518>
  802e0e:	83 ec 04             	sub    $0x4,%esp
  802e11:	68 70 3b 80 00       	push   $0x803b70
  802e16:	68 4f 01 00 00       	push   $0x14f
  802e1b:	68 93 3b 80 00       	push   $0x803b93
  802e20:	e8 52 d4 ff ff       	call   800277 <_panic>
  802e25:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2e:	89 10                	mov    %edx,(%eax)
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	8b 00                	mov    (%eax),%eax
  802e35:	85 c0                	test   %eax,%eax
  802e37:	74 0d                	je     802e46 <insert_sorted_with_merge_freeList+0x539>
  802e39:	a1 48 41 80 00       	mov    0x804148,%eax
  802e3e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e41:	89 50 04             	mov    %edx,0x4(%eax)
  802e44:	eb 08                	jmp    802e4e <insert_sorted_with_merge_freeList+0x541>
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e51:	a3 48 41 80 00       	mov    %eax,0x804148
  802e56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e59:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e60:	a1 54 41 80 00       	mov    0x804154,%eax
  802e65:	40                   	inc    %eax
  802e66:	a3 54 41 80 00       	mov    %eax,0x804154
  802e6b:	e9 65 01 00 00       	jmp    802fd5 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	8b 40 08             	mov    0x8(%eax),%eax
  802e76:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e79:	0f 85 9f 00 00 00    	jne    802f1e <insert_sorted_with_merge_freeList+0x611>
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 40 08             	mov    0x8(%eax),%eax
  802e85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e88:	0f 84 90 00 00 00    	je     802f1e <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802e8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e91:	8b 50 0c             	mov    0xc(%eax),%edx
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 40 0c             	mov    0xc(%eax),%eax
  802e9a:	01 c2                	add    %eax,%edx
  802e9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e9f:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802eb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eba:	75 17                	jne    802ed3 <insert_sorted_with_merge_freeList+0x5c6>
  802ebc:	83 ec 04             	sub    $0x4,%esp
  802ebf:	68 70 3b 80 00       	push   $0x803b70
  802ec4:	68 58 01 00 00       	push   $0x158
  802ec9:	68 93 3b 80 00       	push   $0x803b93
  802ece:	e8 a4 d3 ff ff       	call   800277 <_panic>
  802ed3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ed9:	8b 45 08             	mov    0x8(%ebp),%eax
  802edc:	89 10                	mov    %edx,(%eax)
  802ede:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee1:	8b 00                	mov    (%eax),%eax
  802ee3:	85 c0                	test   %eax,%eax
  802ee5:	74 0d                	je     802ef4 <insert_sorted_with_merge_freeList+0x5e7>
  802ee7:	a1 48 41 80 00       	mov    0x804148,%eax
  802eec:	8b 55 08             	mov    0x8(%ebp),%edx
  802eef:	89 50 04             	mov    %edx,0x4(%eax)
  802ef2:	eb 08                	jmp    802efc <insert_sorted_with_merge_freeList+0x5ef>
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	a3 48 41 80 00       	mov    %eax,0x804148
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f0e:	a1 54 41 80 00       	mov    0x804154,%eax
  802f13:	40                   	inc    %eax
  802f14:	a3 54 41 80 00       	mov    %eax,0x804154
  802f19:	e9 b7 00 00 00       	jmp    802fd5 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	8b 40 08             	mov    0x8(%eax),%eax
  802f24:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f27:	0f 84 e2 00 00 00    	je     80300f <insert_sorted_with_merge_freeList+0x702>
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 40 08             	mov    0x8(%eax),%eax
  802f33:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f36:	0f 85 d3 00 00 00    	jne    80300f <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3f:	8b 50 08             	mov    0x8(%eax),%edx
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	8b 50 0c             	mov    0xc(%eax),%edx
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	8b 40 0c             	mov    0xc(%eax),%eax
  802f54:	01 c2                	add    %eax,%edx
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f74:	75 17                	jne    802f8d <insert_sorted_with_merge_freeList+0x680>
  802f76:	83 ec 04             	sub    $0x4,%esp
  802f79:	68 70 3b 80 00       	push   $0x803b70
  802f7e:	68 61 01 00 00       	push   $0x161
  802f83:	68 93 3b 80 00       	push   $0x803b93
  802f88:	e8 ea d2 ff ff       	call   800277 <_panic>
  802f8d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f93:	8b 45 08             	mov    0x8(%ebp),%eax
  802f96:	89 10                	mov    %edx,(%eax)
  802f98:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9b:	8b 00                	mov    (%eax),%eax
  802f9d:	85 c0                	test   %eax,%eax
  802f9f:	74 0d                	je     802fae <insert_sorted_with_merge_freeList+0x6a1>
  802fa1:	a1 48 41 80 00       	mov    0x804148,%eax
  802fa6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa9:	89 50 04             	mov    %edx,0x4(%eax)
  802fac:	eb 08                	jmp    802fb6 <insert_sorted_with_merge_freeList+0x6a9>
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb9:	a3 48 41 80 00       	mov    %eax,0x804148
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc8:	a1 54 41 80 00       	mov    0x804154,%eax
  802fcd:	40                   	inc    %eax
  802fce:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802fd3:	eb 3a                	jmp    80300f <insert_sorted_with_merge_freeList+0x702>
  802fd5:	eb 38                	jmp    80300f <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802fd7:	a1 40 41 80 00       	mov    0x804140,%eax
  802fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fdf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe3:	74 07                	je     802fec <insert_sorted_with_merge_freeList+0x6df>
  802fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe8:	8b 00                	mov    (%eax),%eax
  802fea:	eb 05                	jmp    802ff1 <insert_sorted_with_merge_freeList+0x6e4>
  802fec:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff1:	a3 40 41 80 00       	mov    %eax,0x804140
  802ff6:	a1 40 41 80 00       	mov    0x804140,%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	0f 85 fa fb ff ff    	jne    802bfd <insert_sorted_with_merge_freeList+0x2f0>
  803003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803007:	0f 85 f0 fb ff ff    	jne    802bfd <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80300d:	eb 01                	jmp    803010 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80300f:	90                   	nop
							}

						}
		          }
		}
}
  803010:	90                   	nop
  803011:	c9                   	leave  
  803012:	c3                   	ret    

00803013 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803013:	55                   	push   %ebp
  803014:	89 e5                	mov    %esp,%ebp
  803016:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803019:	8b 55 08             	mov    0x8(%ebp),%edx
  80301c:	89 d0                	mov    %edx,%eax
  80301e:	c1 e0 02             	shl    $0x2,%eax
  803021:	01 d0                	add    %edx,%eax
  803023:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80302a:	01 d0                	add    %edx,%eax
  80302c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803033:	01 d0                	add    %edx,%eax
  803035:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80303c:	01 d0                	add    %edx,%eax
  80303e:	c1 e0 04             	shl    $0x4,%eax
  803041:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803044:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80304b:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80304e:	83 ec 0c             	sub    $0xc,%esp
  803051:	50                   	push   %eax
  803052:	e8 9c eb ff ff       	call   801bf3 <sys_get_virtual_time>
  803057:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80305a:	eb 41                	jmp    80309d <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80305c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80305f:	83 ec 0c             	sub    $0xc,%esp
  803062:	50                   	push   %eax
  803063:	e8 8b eb ff ff       	call   801bf3 <sys_get_virtual_time>
  803068:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80306b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80306e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803071:	29 c2                	sub    %eax,%edx
  803073:	89 d0                	mov    %edx,%eax
  803075:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803078:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80307b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80307e:	89 d1                	mov    %edx,%ecx
  803080:	29 c1                	sub    %eax,%ecx
  803082:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803085:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803088:	39 c2                	cmp    %eax,%edx
  80308a:	0f 97 c0             	seta   %al
  80308d:	0f b6 c0             	movzbl %al,%eax
  803090:	29 c1                	sub    %eax,%ecx
  803092:	89 c8                	mov    %ecx,%eax
  803094:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803097:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80309a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80309d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030a3:	72 b7                	jb     80305c <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030a5:	90                   	nop
  8030a6:	c9                   	leave  
  8030a7:	c3                   	ret    

008030a8 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030a8:	55                   	push   %ebp
  8030a9:	89 e5                	mov    %esp,%ebp
  8030ab:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030b5:	eb 03                	jmp    8030ba <busy_wait+0x12>
  8030b7:	ff 45 fc             	incl   -0x4(%ebp)
  8030ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030c0:	72 f5                	jb     8030b7 <busy_wait+0xf>
	return i;
  8030c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030c5:	c9                   	leave  
  8030c6:	c3                   	ret    
  8030c7:	90                   	nop

008030c8 <__udivdi3>:
  8030c8:	55                   	push   %ebp
  8030c9:	57                   	push   %edi
  8030ca:	56                   	push   %esi
  8030cb:	53                   	push   %ebx
  8030cc:	83 ec 1c             	sub    $0x1c,%esp
  8030cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030df:	89 ca                	mov    %ecx,%edx
  8030e1:	89 f8                	mov    %edi,%eax
  8030e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030e7:	85 f6                	test   %esi,%esi
  8030e9:	75 2d                	jne    803118 <__udivdi3+0x50>
  8030eb:	39 cf                	cmp    %ecx,%edi
  8030ed:	77 65                	ja     803154 <__udivdi3+0x8c>
  8030ef:	89 fd                	mov    %edi,%ebp
  8030f1:	85 ff                	test   %edi,%edi
  8030f3:	75 0b                	jne    803100 <__udivdi3+0x38>
  8030f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8030fa:	31 d2                	xor    %edx,%edx
  8030fc:	f7 f7                	div    %edi
  8030fe:	89 c5                	mov    %eax,%ebp
  803100:	31 d2                	xor    %edx,%edx
  803102:	89 c8                	mov    %ecx,%eax
  803104:	f7 f5                	div    %ebp
  803106:	89 c1                	mov    %eax,%ecx
  803108:	89 d8                	mov    %ebx,%eax
  80310a:	f7 f5                	div    %ebp
  80310c:	89 cf                	mov    %ecx,%edi
  80310e:	89 fa                	mov    %edi,%edx
  803110:	83 c4 1c             	add    $0x1c,%esp
  803113:	5b                   	pop    %ebx
  803114:	5e                   	pop    %esi
  803115:	5f                   	pop    %edi
  803116:	5d                   	pop    %ebp
  803117:	c3                   	ret    
  803118:	39 ce                	cmp    %ecx,%esi
  80311a:	77 28                	ja     803144 <__udivdi3+0x7c>
  80311c:	0f bd fe             	bsr    %esi,%edi
  80311f:	83 f7 1f             	xor    $0x1f,%edi
  803122:	75 40                	jne    803164 <__udivdi3+0x9c>
  803124:	39 ce                	cmp    %ecx,%esi
  803126:	72 0a                	jb     803132 <__udivdi3+0x6a>
  803128:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80312c:	0f 87 9e 00 00 00    	ja     8031d0 <__udivdi3+0x108>
  803132:	b8 01 00 00 00       	mov    $0x1,%eax
  803137:	89 fa                	mov    %edi,%edx
  803139:	83 c4 1c             	add    $0x1c,%esp
  80313c:	5b                   	pop    %ebx
  80313d:	5e                   	pop    %esi
  80313e:	5f                   	pop    %edi
  80313f:	5d                   	pop    %ebp
  803140:	c3                   	ret    
  803141:	8d 76 00             	lea    0x0(%esi),%esi
  803144:	31 ff                	xor    %edi,%edi
  803146:	31 c0                	xor    %eax,%eax
  803148:	89 fa                	mov    %edi,%edx
  80314a:	83 c4 1c             	add    $0x1c,%esp
  80314d:	5b                   	pop    %ebx
  80314e:	5e                   	pop    %esi
  80314f:	5f                   	pop    %edi
  803150:	5d                   	pop    %ebp
  803151:	c3                   	ret    
  803152:	66 90                	xchg   %ax,%ax
  803154:	89 d8                	mov    %ebx,%eax
  803156:	f7 f7                	div    %edi
  803158:	31 ff                	xor    %edi,%edi
  80315a:	89 fa                	mov    %edi,%edx
  80315c:	83 c4 1c             	add    $0x1c,%esp
  80315f:	5b                   	pop    %ebx
  803160:	5e                   	pop    %esi
  803161:	5f                   	pop    %edi
  803162:	5d                   	pop    %ebp
  803163:	c3                   	ret    
  803164:	bd 20 00 00 00       	mov    $0x20,%ebp
  803169:	89 eb                	mov    %ebp,%ebx
  80316b:	29 fb                	sub    %edi,%ebx
  80316d:	89 f9                	mov    %edi,%ecx
  80316f:	d3 e6                	shl    %cl,%esi
  803171:	89 c5                	mov    %eax,%ebp
  803173:	88 d9                	mov    %bl,%cl
  803175:	d3 ed                	shr    %cl,%ebp
  803177:	89 e9                	mov    %ebp,%ecx
  803179:	09 f1                	or     %esi,%ecx
  80317b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80317f:	89 f9                	mov    %edi,%ecx
  803181:	d3 e0                	shl    %cl,%eax
  803183:	89 c5                	mov    %eax,%ebp
  803185:	89 d6                	mov    %edx,%esi
  803187:	88 d9                	mov    %bl,%cl
  803189:	d3 ee                	shr    %cl,%esi
  80318b:	89 f9                	mov    %edi,%ecx
  80318d:	d3 e2                	shl    %cl,%edx
  80318f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803193:	88 d9                	mov    %bl,%cl
  803195:	d3 e8                	shr    %cl,%eax
  803197:	09 c2                	or     %eax,%edx
  803199:	89 d0                	mov    %edx,%eax
  80319b:	89 f2                	mov    %esi,%edx
  80319d:	f7 74 24 0c          	divl   0xc(%esp)
  8031a1:	89 d6                	mov    %edx,%esi
  8031a3:	89 c3                	mov    %eax,%ebx
  8031a5:	f7 e5                	mul    %ebp
  8031a7:	39 d6                	cmp    %edx,%esi
  8031a9:	72 19                	jb     8031c4 <__udivdi3+0xfc>
  8031ab:	74 0b                	je     8031b8 <__udivdi3+0xf0>
  8031ad:	89 d8                	mov    %ebx,%eax
  8031af:	31 ff                	xor    %edi,%edi
  8031b1:	e9 58 ff ff ff       	jmp    80310e <__udivdi3+0x46>
  8031b6:	66 90                	xchg   %ax,%ax
  8031b8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031bc:	89 f9                	mov    %edi,%ecx
  8031be:	d3 e2                	shl    %cl,%edx
  8031c0:	39 c2                	cmp    %eax,%edx
  8031c2:	73 e9                	jae    8031ad <__udivdi3+0xe5>
  8031c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031c7:	31 ff                	xor    %edi,%edi
  8031c9:	e9 40 ff ff ff       	jmp    80310e <__udivdi3+0x46>
  8031ce:	66 90                	xchg   %ax,%ax
  8031d0:	31 c0                	xor    %eax,%eax
  8031d2:	e9 37 ff ff ff       	jmp    80310e <__udivdi3+0x46>
  8031d7:	90                   	nop

008031d8 <__umoddi3>:
  8031d8:	55                   	push   %ebp
  8031d9:	57                   	push   %edi
  8031da:	56                   	push   %esi
  8031db:	53                   	push   %ebx
  8031dc:	83 ec 1c             	sub    $0x1c,%esp
  8031df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031f7:	89 f3                	mov    %esi,%ebx
  8031f9:	89 fa                	mov    %edi,%edx
  8031fb:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031ff:	89 34 24             	mov    %esi,(%esp)
  803202:	85 c0                	test   %eax,%eax
  803204:	75 1a                	jne    803220 <__umoddi3+0x48>
  803206:	39 f7                	cmp    %esi,%edi
  803208:	0f 86 a2 00 00 00    	jbe    8032b0 <__umoddi3+0xd8>
  80320e:	89 c8                	mov    %ecx,%eax
  803210:	89 f2                	mov    %esi,%edx
  803212:	f7 f7                	div    %edi
  803214:	89 d0                	mov    %edx,%eax
  803216:	31 d2                	xor    %edx,%edx
  803218:	83 c4 1c             	add    $0x1c,%esp
  80321b:	5b                   	pop    %ebx
  80321c:	5e                   	pop    %esi
  80321d:	5f                   	pop    %edi
  80321e:	5d                   	pop    %ebp
  80321f:	c3                   	ret    
  803220:	39 f0                	cmp    %esi,%eax
  803222:	0f 87 ac 00 00 00    	ja     8032d4 <__umoddi3+0xfc>
  803228:	0f bd e8             	bsr    %eax,%ebp
  80322b:	83 f5 1f             	xor    $0x1f,%ebp
  80322e:	0f 84 ac 00 00 00    	je     8032e0 <__umoddi3+0x108>
  803234:	bf 20 00 00 00       	mov    $0x20,%edi
  803239:	29 ef                	sub    %ebp,%edi
  80323b:	89 fe                	mov    %edi,%esi
  80323d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803241:	89 e9                	mov    %ebp,%ecx
  803243:	d3 e0                	shl    %cl,%eax
  803245:	89 d7                	mov    %edx,%edi
  803247:	89 f1                	mov    %esi,%ecx
  803249:	d3 ef                	shr    %cl,%edi
  80324b:	09 c7                	or     %eax,%edi
  80324d:	89 e9                	mov    %ebp,%ecx
  80324f:	d3 e2                	shl    %cl,%edx
  803251:	89 14 24             	mov    %edx,(%esp)
  803254:	89 d8                	mov    %ebx,%eax
  803256:	d3 e0                	shl    %cl,%eax
  803258:	89 c2                	mov    %eax,%edx
  80325a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80325e:	d3 e0                	shl    %cl,%eax
  803260:	89 44 24 04          	mov    %eax,0x4(%esp)
  803264:	8b 44 24 08          	mov    0x8(%esp),%eax
  803268:	89 f1                	mov    %esi,%ecx
  80326a:	d3 e8                	shr    %cl,%eax
  80326c:	09 d0                	or     %edx,%eax
  80326e:	d3 eb                	shr    %cl,%ebx
  803270:	89 da                	mov    %ebx,%edx
  803272:	f7 f7                	div    %edi
  803274:	89 d3                	mov    %edx,%ebx
  803276:	f7 24 24             	mull   (%esp)
  803279:	89 c6                	mov    %eax,%esi
  80327b:	89 d1                	mov    %edx,%ecx
  80327d:	39 d3                	cmp    %edx,%ebx
  80327f:	0f 82 87 00 00 00    	jb     80330c <__umoddi3+0x134>
  803285:	0f 84 91 00 00 00    	je     80331c <__umoddi3+0x144>
  80328b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80328f:	29 f2                	sub    %esi,%edx
  803291:	19 cb                	sbb    %ecx,%ebx
  803293:	89 d8                	mov    %ebx,%eax
  803295:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803299:	d3 e0                	shl    %cl,%eax
  80329b:	89 e9                	mov    %ebp,%ecx
  80329d:	d3 ea                	shr    %cl,%edx
  80329f:	09 d0                	or     %edx,%eax
  8032a1:	89 e9                	mov    %ebp,%ecx
  8032a3:	d3 eb                	shr    %cl,%ebx
  8032a5:	89 da                	mov    %ebx,%edx
  8032a7:	83 c4 1c             	add    $0x1c,%esp
  8032aa:	5b                   	pop    %ebx
  8032ab:	5e                   	pop    %esi
  8032ac:	5f                   	pop    %edi
  8032ad:	5d                   	pop    %ebp
  8032ae:	c3                   	ret    
  8032af:	90                   	nop
  8032b0:	89 fd                	mov    %edi,%ebp
  8032b2:	85 ff                	test   %edi,%edi
  8032b4:	75 0b                	jne    8032c1 <__umoddi3+0xe9>
  8032b6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032bb:	31 d2                	xor    %edx,%edx
  8032bd:	f7 f7                	div    %edi
  8032bf:	89 c5                	mov    %eax,%ebp
  8032c1:	89 f0                	mov    %esi,%eax
  8032c3:	31 d2                	xor    %edx,%edx
  8032c5:	f7 f5                	div    %ebp
  8032c7:	89 c8                	mov    %ecx,%eax
  8032c9:	f7 f5                	div    %ebp
  8032cb:	89 d0                	mov    %edx,%eax
  8032cd:	e9 44 ff ff ff       	jmp    803216 <__umoddi3+0x3e>
  8032d2:	66 90                	xchg   %ax,%ax
  8032d4:	89 c8                	mov    %ecx,%eax
  8032d6:	89 f2                	mov    %esi,%edx
  8032d8:	83 c4 1c             	add    $0x1c,%esp
  8032db:	5b                   	pop    %ebx
  8032dc:	5e                   	pop    %esi
  8032dd:	5f                   	pop    %edi
  8032de:	5d                   	pop    %ebp
  8032df:	c3                   	ret    
  8032e0:	3b 04 24             	cmp    (%esp),%eax
  8032e3:	72 06                	jb     8032eb <__umoddi3+0x113>
  8032e5:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032e9:	77 0f                	ja     8032fa <__umoddi3+0x122>
  8032eb:	89 f2                	mov    %esi,%edx
  8032ed:	29 f9                	sub    %edi,%ecx
  8032ef:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032f3:	89 14 24             	mov    %edx,(%esp)
  8032f6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032fa:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032fe:	8b 14 24             	mov    (%esp),%edx
  803301:	83 c4 1c             	add    $0x1c,%esp
  803304:	5b                   	pop    %ebx
  803305:	5e                   	pop    %esi
  803306:	5f                   	pop    %edi
  803307:	5d                   	pop    %ebp
  803308:	c3                   	ret    
  803309:	8d 76 00             	lea    0x0(%esi),%esi
  80330c:	2b 04 24             	sub    (%esp),%eax
  80330f:	19 fa                	sbb    %edi,%edx
  803311:	89 d1                	mov    %edx,%ecx
  803313:	89 c6                	mov    %eax,%esi
  803315:	e9 71 ff ff ff       	jmp    80328b <__umoddi3+0xb3>
  80331a:	66 90                	xchg   %ax,%ax
  80331c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803320:	72 ea                	jb     80330c <__umoddi3+0x134>
  803322:	89 d9                	mov    %ebx,%ecx
  803324:	e9 62 ff ff ff       	jmp    80328b <__umoddi3+0xb3>

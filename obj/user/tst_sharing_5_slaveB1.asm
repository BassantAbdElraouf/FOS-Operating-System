
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 1e 01 00 00       	call   800154 <libmain>
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
  80003b:	83 ec 28             	sub    $0x28,%esp
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
  80008c:	68 60 33 80 00       	push   $0x803360
  800091:	6a 12                	push   $0x12
  800093:	68 7c 33 80 00       	push   $0x80337c
  800098:	e8 f3 01 00 00       	call   800290 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 cc 13 00 00       	call   801473 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 2a 1b 00 00       	call   801bd9 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 99 33 80 00       	push   $0x803399
  8000b7:	50                   	push   %eax
  8000b8:	e8 dc 15 00 00       	call   801699 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 9c 33 80 00       	push   $0x80339c
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 26 1c 00 00       	call   801cfe <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 c4 33 80 00       	push   $0x8033c4
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 37 2f 00 00       	call   80302c <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 e3 17 00 00       	call   8018e0 <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 75 16 00 00       	call   801780 <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 e4 33 80 00       	push   $0x8033e4
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 b6 17 00 00       	call   8018e0 <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 fc 33 80 00       	push   $0x8033fc
  800140:	6a 27                	push   $0x27
  800142:	68 7c 33 80 00       	push   $0x80337c
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 ad 1b 00 00       	call   801cfe <inctst>
	return;
  800151:	90                   	nop
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80015a:	e8 61 1a 00 00       	call   801bc0 <sys_getenvindex>
  80015f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800165:	89 d0                	mov    %edx,%eax
  800167:	c1 e0 03             	shl    $0x3,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	01 c0                	add    %eax,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800177:	01 d0                	add    %edx,%eax
  800179:	c1 e0 04             	shl    $0x4,%eax
  80017c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800181:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800186:	a1 20 40 80 00       	mov    0x804020,%eax
  80018b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800191:	84 c0                	test   %al,%al
  800193:	74 0f                	je     8001a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800195:	a1 20 40 80 00       	mov    0x804020,%eax
  80019a:	05 5c 05 00 00       	add    $0x55c,%eax
  80019f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a8:	7e 0a                	jle    8001b4 <libmain+0x60>
		binaryname = argv[0];
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 76 fe ff ff       	call   800038 <_main>
  8001c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c5:	e8 03 18 00 00       	call   8019cd <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 bc 34 80 00       	push   $0x8034bc
  8001d2:	e8 6d 03 00 00       	call   800544 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001da:	a1 20 40 80 00       	mov    0x804020,%eax
  8001df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 e4 34 80 00       	push   $0x8034e4
  8001fa:	e8 45 03 00 00       	call   800544 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800202:	a1 20 40 80 00       	mov    0x804020,%eax
  800207:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80020d:	a1 20 40 80 00       	mov    0x804020,%eax
  800212:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800223:	51                   	push   %ecx
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	68 0c 35 80 00       	push   $0x80350c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 64 35 80 00       	push   $0x803564
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 bc 34 80 00       	push   $0x8034bc
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 83 17 00 00       	call   8019e7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800264:	e8 19 00 00 00       	call   800282 <exit>
}
  800269:	90                   	nop
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	e8 10 19 00 00       	call   801b8c <sys_destroy_env>
  80027c:	83 c4 10             	add    $0x10,%esp
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <exit>:

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800288:	e8 65 19 00 00       	call   801bf2 <sys_exit_env>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800296:	8d 45 10             	lea    0x10(%ebp),%eax
  800299:	83 c0 04             	add    $0x4,%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 78 35 80 00       	push   $0x803578
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 40 80 00       	mov    0x804000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 7d 35 80 00       	push   $0x80357d
  8002cf:	e8 70 02 00 00       	call   800544 <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	50                   	push   %eax
  8002e1:	e8 f3 01 00 00       	call   8004d9 <vcprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	6a 00                	push   $0x0
  8002ee:	68 99 35 80 00       	push   $0x803599
  8002f3:	e8 e1 01 00 00       	call   8004d9 <vcprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fb:	e8 82 ff ff ff       	call   800282 <exit>

	// should not return here
	while (1) ;
  800300:	eb fe                	jmp    800300 <_panic+0x70>

00800302 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	8b 50 74             	mov    0x74(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	39 c2                	cmp    %eax,%edx
  800315:	74 14                	je     80032b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	68 9c 35 80 00       	push   $0x80359c
  80031f:	6a 26                	push   $0x26
  800321:	68 e8 35 80 00       	push   $0x8035e8
  800326:	e8 65 ff ff ff       	call   800290 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80032b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800332:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800339:	e9 c2 00 00 00       	jmp    800400 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800341:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	01 d0                	add    %edx,%eax
  80034d:	8b 00                	mov    (%eax),%eax
  80034f:	85 c0                	test   %eax,%eax
  800351:	75 08                	jne    80035b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800353:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800356:	e9 a2 00 00 00       	jmp    8003fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80035b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800362:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800369:	eb 69                	jmp    8003d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80036b:	a1 20 40 80 00       	mov    0x804020,%eax
  800370:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800379:	89 d0                	mov    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	c1 e0 03             	shl    $0x3,%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8a 40 04             	mov    0x4(%eax),%al
  800387:	84 c0                	test   %al,%al
  800389:	75 46                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038b:	a1 20 40 80 00       	mov    0x804020,%eax
  800390:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800396:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800399:	89 d0                	mov    %edx,%eax
  80039b:	01 c0                	add    %eax,%eax
  80039d:	01 d0                	add    %edx,%eax
  80039f:	c1 e0 03             	shl    $0x3,%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	75 09                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003cf:	eb 12                	jmp    8003e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d1:	ff 45 e8             	incl   -0x18(%ebp)
  8003d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d9:	8b 50 74             	mov    0x74(%eax),%edx
  8003dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003df:	39 c2                	cmp    %eax,%edx
  8003e1:	77 88                	ja     80036b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e7:	75 14                	jne    8003fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 f4 35 80 00       	push   $0x8035f4
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 e8 35 80 00       	push   $0x8035e8
  8003f8:	e8 93 fe ff ff       	call   800290 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003fd:	ff 45 f0             	incl   -0x10(%ebp)
  800400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800403:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800406:	0f 8c 32 ff ff ff    	jl     80033e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80040c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800413:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80041a:	eb 26                	jmp    800442 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80041c:	a1 20 40 80 00       	mov    0x804020,%eax
  800421:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042a:	89 d0                	mov    %edx,%eax
  80042c:	01 c0                	add    %eax,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 03             	shl    $0x3,%eax
  800433:	01 c8                	add    %ecx,%eax
  800435:	8a 40 04             	mov    0x4(%eax),%al
  800438:	3c 01                	cmp    $0x1,%al
  80043a:	75 03                	jne    80043f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80043c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043f:	ff 45 e0             	incl   -0x20(%ebp)
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 50 74             	mov    0x74(%eax),%edx
  80044a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044d:	39 c2                	cmp    %eax,%edx
  80044f:	77 cb                	ja     80041c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800457:	74 14                	je     80046d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 48 36 80 00       	push   $0x803648
  800461:	6a 44                	push   $0x44
  800463:	68 e8 35 80 00       	push   $0x8035e8
  800468:	e8 23 fe ff ff       	call   800290 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046d:	90                   	nop
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 48 01             	lea    0x1(%eax),%ecx
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 0a                	mov    %ecx,(%edx)
  800483:	8b 55 08             	mov    0x8(%ebp),%edx
  800486:	88 d1                	mov    %dl,%cl
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	3d ff 00 00 00       	cmp    $0xff,%eax
  800499:	75 2c                	jne    8004c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049b:	a0 24 40 80 00       	mov    0x804024,%al
  8004a0:	0f b6 c0             	movzbl %al,%eax
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	8b 12                	mov    (%edx),%edx
  8004a8:	89 d1                	mov    %edx,%ecx
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	83 c2 08             	add    $0x8,%edx
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	50                   	push   %eax
  8004b4:	51                   	push   %ecx
  8004b5:	52                   	push   %edx
  8004b6:	e8 64 13 00 00       	call   80181f <sys_cputs>
  8004bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	8b 40 04             	mov    0x4(%eax),%eax
  8004cd:	8d 50 01             	lea    0x1(%eax),%edx
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e9:	00 00 00 
	b.cnt = 0;
  8004ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800502:	50                   	push   %eax
  800503:	68 70 04 80 00       	push   $0x800470
  800508:	e8 11 02 00 00       	call   80071e <vprintfmt>
  80050d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800510:	a0 24 40 80 00       	mov    0x804024,%al
  800515:	0f b6 c0             	movzbl %al,%eax
  800518:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	50                   	push   %eax
  800522:	52                   	push   %edx
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	83 c0 08             	add    $0x8,%eax
  80052c:	50                   	push   %eax
  80052d:	e8 ed 12 00 00       	call   80181f <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800535:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80053c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <cprintf>:

int cprintf(const char *fmt, ...) {
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800551:	8d 45 0c             	lea    0xc(%ebp),%eax
  800554:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 f4             	pushl  -0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	e8 73 ff ff ff       	call   8004d9 <vcprintf>
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800577:	e8 51 14 00 00       	call   8019cd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80057c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 48 ff ff ff       	call   8004d9 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800597:	e8 4b 14 00 00       	call   8019e7 <sys_enable_interrupt>
	return cnt;
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 14             	sub    $0x14,%esp
  8005a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	77 55                	ja     800616 <printnum+0x75>
  8005c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c4:	72 05                	jb     8005cb <printnum+0x2a>
  8005c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c9:	77 4b                	ja     800616 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 f4             	pushl  -0xc(%ebp)
  8005de:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e1:	e8 fa 2a 00 00       	call   8030e0 <__udivdi3>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	53                   	push   %ebx
  8005f0:	ff 75 18             	pushl  0x18(%ebp)
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 a1 ff ff ff       	call   8005a1 <printnum>
  800600:	83 c4 20             	add    $0x20,%esp
  800603:	eb 1a                	jmp    80061f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 20             	pushl  0x20(%ebp)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800616:	ff 4d 1c             	decl   0x1c(%ebp)
  800619:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061d:	7f e6                	jg     800605 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800622:	bb 00 00 00 00       	mov    $0x0,%ebx
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062d:	53                   	push   %ebx
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	50                   	push   %eax
  800631:	e8 ba 2b 00 00       	call   8031f0 <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 b4 38 80 00       	add    $0x8038b4,%eax
  80063e:	8a 00                	mov    (%eax),%al
  800640:	0f be c0             	movsbl %al,%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
}
  800652:	90                   	nop
  800653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065f:	7e 1c                	jle    80067d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	89 10                	mov    %edx,(%eax)
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	83 e8 08             	sub    $0x8,%eax
  800676:	8b 50 04             	mov    0x4(%eax),%edx
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	eb 40                	jmp    8006bd <getuint+0x65>
	else if (lflag)
  80067d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800681:	74 1e                	je     8006a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	eb 1c                	jmp    8006bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 50 04             	lea    0x4(%eax),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	89 10                	mov    %edx,(%eax)
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	83 e8 04             	sub    $0x4,%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c6:	7e 1c                	jle    8006e4 <getint+0x25>
		return va_arg(*ap, long long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 08             	lea    0x8(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 08             	sub    $0x8,%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	eb 38                	jmp    80071c <getint+0x5d>
	else if (lflag)
  8006e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e8:	74 1a                	je     800704 <getint+0x45>
		return va_arg(*ap, long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	eb 18                	jmp    80071c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	56                   	push   %esi
  800722:	53                   	push   %ebx
  800723:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	eb 17                	jmp    80073f <vprintfmt+0x21>
			if (ch == '\0')
  800728:	85 db                	test   %ebx,%ebx
  80072a:	0f 84 af 03 00 00    	je     800adf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	53                   	push   %ebx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	89 55 10             	mov    %edx,0x10(%ebp)
  800748:	8a 00                	mov    (%eax),%al
  80074a:	0f b6 d8             	movzbl %al,%ebx
  80074d:	83 fb 25             	cmp    $0x25,%ebx
  800750:	75 d6                	jne    800728 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800752:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800756:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800764:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800783:	83 f8 55             	cmp    $0x55,%eax
  800786:	0f 87 2b 03 00 00    	ja     800ab7 <vprintfmt+0x399>
  80078c:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
  800793:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800795:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800799:	eb d7                	jmp    800772 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d1                	jmp    800772 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ab:	89 d0                	mov    %edx,%eax
  8007ad:	c1 e0 02             	shl    $0x2,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	01 c0                	add    %eax,%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	83 e8 30             	sub    $0x30,%eax
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8a 00                	mov    (%eax),%al
  8007c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c7:	7e 3e                	jle    800807 <vprintfmt+0xe9>
  8007c9:	83 fb 39             	cmp    $0x39,%ebx
  8007cc:	7f 39                	jg     800807 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d5                	jmp    8007a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 c0 04             	add    $0x4,%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 e8 04             	sub    $0x4,%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e7:	eb 1f                	jmp    800808 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	79 83                	jns    800772 <vprintfmt+0x54>
				width = 0;
  8007ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f6:	e9 77 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800802:	e9 6b ff ff ff       	jmp    800772 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800807:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	0f 89 60 ff ff ff    	jns    800772 <vprintfmt+0x54>
				width = precision, precision = -1;
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800818:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081f:	e9 4e ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800824:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800827:	e9 46 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	e9 89 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800862:	85 db                	test   %ebx,%ebx
  800864:	79 02                	jns    800868 <vprintfmt+0x14a>
				err = -err;
  800866:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800868:	83 fb 64             	cmp    $0x64,%ebx
  80086b:	7f 0b                	jg     800878 <vprintfmt+0x15a>
  80086d:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 c5 38 80 00       	push   $0x8038c5
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 5e 02 00 00       	call   800ae7 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088c:	e9 49 02 00 00       	jmp    800ada <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800891:	56                   	push   %esi
  800892:	68 ce 38 80 00       	push   $0x8038ce
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 45 02 00 00       	call   800ae7 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 30 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 30                	mov    (%eax),%esi
  8008bb:	85 f6                	test   %esi,%esi
  8008bd:	75 05                	jne    8008c4 <vprintfmt+0x1a6>
				p = "(null)";
  8008bf:	be d1 38 80 00       	mov    $0x8038d1,%esi
			if (width > 0 && padc != '-')
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7e 6d                	jle    800937 <vprintfmt+0x219>
  8008ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ce:	74 67                	je     800937 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	50                   	push   %eax
  8008d7:	56                   	push   %esi
  8008d8:	e8 0c 03 00 00       	call   800be9 <strnlen>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e3:	eb 16                	jmp    8008fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	7f e4                	jg     8008e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800901:	eb 34                	jmp    800937 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800903:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800907:	74 1c                	je     800925 <vprintfmt+0x207>
  800909:	83 fb 1f             	cmp    $0x1f,%ebx
  80090c:	7e 05                	jle    800913 <vprintfmt+0x1f5>
  80090e:	83 fb 7e             	cmp    $0x7e,%ebx
  800911:	7e 12                	jle    800925 <vprintfmt+0x207>
					putch('?', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 3f                	push   $0x3f
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	53                   	push   %ebx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	ff 4d e4             	decl   -0x1c(%ebp)
  800937:	89 f0                	mov    %esi,%eax
  800939:	8d 70 01             	lea    0x1(%eax),%esi
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	0f be d8             	movsbl %al,%ebx
  800941:	85 db                	test   %ebx,%ebx
  800943:	74 24                	je     800969 <vprintfmt+0x24b>
  800945:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800949:	78 b8                	js     800903 <vprintfmt+0x1e5>
  80094b:	ff 4d e0             	decl   -0x20(%ebp)
  80094e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800952:	79 af                	jns    800903 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	eb 13                	jmp    800969 <vprintfmt+0x24b>
				putch(' ', putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	6a 20                	push   $0x20
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	ff d0                	call   *%eax
  800963:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800966:	ff 4d e4             	decl   -0x1c(%ebp)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7f e7                	jg     800956 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096f:	e9 66 01 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 e8             	pushl  -0x18(%ebp)
  80097a:	8d 45 14             	lea    0x14(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	e8 3c fd ff ff       	call   8006bf <getint>
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800989:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	85 d2                	test   %edx,%edx
  800994:	79 23                	jns    8009b9 <vprintfmt+0x29b>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 2d                	push   $0x2d
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	f7 d8                	neg    %eax
  8009ae:	83 d2 00             	adc    $0x0,%edx
  8009b1:	f7 da                	neg    %edx
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c0:	e9 bc 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ce:	50                   	push   %eax
  8009cf:	e8 84 fc ff ff       	call   800658 <getuint>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 98 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 58                	push   $0x58
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 58                	push   $0x58
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			break;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 30                	push   $0x30
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 78                	push   $0x78
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a60:	eb 1f                	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 e7 fb ff ff       	call   800658 <getuint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	52                   	push   %edx
  800a8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	ff 75 f4             	pushl  -0xc(%ebp)
  800a93:	ff 75 f0             	pushl  -0x10(%ebp)
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 00 fb ff ff       	call   8005a1 <printnum>
  800aa1:	83 c4 20             	add    $0x20,%esp
			break;
  800aa4:	eb 34                	jmp    800ada <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 25                	push   $0x25
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	eb 03                	jmp    800acf <vprintfmt+0x3b1>
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	48                   	dec    %eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	3c 25                	cmp    $0x25,%al
  800ad7:	75 f3                	jne    800acc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ad9:	90                   	nop
		}
	}
  800ada:	e9 47 fc ff ff       	jmp    800726 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800adf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aed:	8d 45 10             	lea    0x10(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af6:	8b 45 10             	mov    0x10(%ebp),%eax
  800af9:	ff 75 f4             	pushl  -0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 16 fc ff ff       	call   80071e <vprintfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0b:	90                   	nop
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 40 08             	mov    0x8(%eax),%eax
  800b17:	8d 50 01             	lea    0x1(%eax),%edx
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 10                	mov    (%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 40 04             	mov    0x4(%eax),%eax
  800b2b:	39 c2                	cmp    %eax,%edx
  800b2d:	73 12                	jae    800b41 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 48 01             	lea    0x1(%eax),%ecx
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 0a                	mov    %ecx,(%edx)
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	88 10                	mov    %dl,(%eax)
}
  800b41:	90                   	nop
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b69:	74 06                	je     800b71 <vsnprintf+0x2d>
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	7f 07                	jg     800b78 <vsnprintf+0x34>
		return -E_INVAL;
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	eb 20                	jmp    800b98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b78:	ff 75 14             	pushl  0x14(%ebp)
  800b7b:	ff 75 10             	pushl  0x10(%ebp)
  800b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b81:	50                   	push   %eax
  800b82:	68 0e 0b 80 00       	push   $0x800b0e
  800b87:	e8 92 fb ff ff       	call   80071e <vprintfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	ff 75 f4             	pushl  -0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 89 ff ff ff       	call   800b44 <vsnprintf>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 06                	jmp    800bdb <strlen+0x15>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 f1                	jne    800bd5 <strlen+0xf>
		n++;
	return n;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 09                	jmp    800c01 <strnlen+0x18>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	ff 4d 0c             	decl   0xc(%ebp)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 09                	je     800c10 <strnlen+0x27>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e8                	jne    800bf8 <strnlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c21:	90                   	nop
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8d 50 01             	lea    0x1(%eax),%edx
  800c28:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c34:	8a 12                	mov    (%edx),%dl
  800c36:	88 10                	mov    %dl,(%eax)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e4                	jne    800c22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 1f                	jmp    800c77 <strncpy+0x34>
		*dst++ = *src;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8a 12                	mov    (%edx),%dl
  800c66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	74 03                	je     800c74 <strncpy+0x31>
			src++;
  800c71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c74:	ff 45 fc             	incl   -0x4(%ebp)
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7d:	72 d9                	jb     800c58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 30                	je     800cc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c96:	eb 16                	jmp    800cae <strlcpy+0x2a>
			*dst++ = *src++;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caa:	8a 12                	mov    (%edx),%dl
  800cac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb5:	74 09                	je     800cc0 <strlcpy+0x3c>
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 d8                	jne    800c98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	29 c2                	sub    %eax,%edx
  800cce:	89 d0                	mov    %edx,%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd5:	eb 06                	jmp    800cdd <strcmp+0xb>
		p++, q++;
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	74 0e                	je     800cf4 <strcmp+0x22>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 10                	mov    (%eax),%dl
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	38 c2                	cmp    %al,%dl
  800cf2:	74 e3                	je     800cd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	0f b6 d0             	movzbl %al,%edx
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 c0             	movzbl %al,%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0d:	eb 09                	jmp    800d18 <strncmp+0xe>
		n--, p++, q++;
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	74 17                	je     800d35 <strncmp+0x2b>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strncmp+0x2b>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 da                	je     800d0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	75 07                	jne    800d42 <strncmp+0x38>
		return 0;
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	eb 14                	jmp    800d56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d0             	movzbl %al,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 c0             	movzbl %al,%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d64:	eb 12                	jmp    800d78 <strchr+0x20>
		if (*s == c)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6e:	75 05                	jne    800d75 <strchr+0x1d>
			return (char *) s;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	eb 11                	jmp    800d86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 e5                	jne    800d66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d94:	eb 0d                	jmp    800da3 <strfind+0x1b>
		if (*s == c)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9e:	74 0e                	je     800dae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	75 ea                	jne    800d96 <strfind+0xe>
  800dac:	eb 01                	jmp    800daf <strfind+0x27>
		if (*s == c)
			break;
  800dae:	90                   	nop
	return (char *) s;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc6:	eb 0e                	jmp    800dd6 <memset+0x22>
		*p++ = c;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	8d 50 01             	lea    0x1(%eax),%edx
  800dce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd6:	ff 4d f8             	decl   -0x8(%ebp)
  800dd9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddd:	79 e9                	jns    800dc8 <memset+0x14>
		*p++ = c;

	return v;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df6:	eb 16                	jmp    800e0e <memcpy+0x2a>
		*d++ = *s++;
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e14:	89 55 10             	mov    %edx,0x10(%ebp)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	75 dd                	jne    800df8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e38:	73 50                	jae    800e8a <memmove+0x6a>
  800e3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e45:	76 43                	jbe    800e8a <memmove+0x6a>
		s += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e53:	eb 10                	jmp    800e65 <memmove+0x45>
			*--d = *--s;
  800e55:	ff 4d f8             	decl   -0x8(%ebp)
  800e58:	ff 4d fc             	decl   -0x4(%ebp)
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	8a 10                	mov    (%eax),%dl
  800e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 e3                	jne    800e55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	eb 23                	jmp    800e97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 dd                	jne    800e74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eae:	eb 2a                	jmp    800eda <memcmp+0x3e>
		if (*s1 != *s2)
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 10                	mov    (%eax),%dl
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	38 c2                	cmp    %al,%dl
  800ebc:	74 16                	je     800ed4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 d0             	movzbl %al,%edx
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 c0             	movzbl %al,%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	eb 18                	jmp    800eec <memcmp+0x50>
		s1++, s2++;
  800ed4:	ff 45 fc             	incl   -0x4(%ebp)
  800ed7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 c9                	jne    800eb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 d0                	add    %edx,%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eff:	eb 15                	jmp    800f16 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 d0             	movzbl %al,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	74 0d                	je     800f20 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1c:	72 e3                	jb     800f01 <memfind+0x13>
  800f1e:	eb 01                	jmp    800f21 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f20:	90                   	nop
	return (void *) s;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3a:	eb 03                	jmp    800f3f <strtol+0x19>
		s++;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 20                	cmp    $0x20,%al
  800f46:	74 f4                	je     800f3c <strtol+0x16>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	74 eb                	je     800f3c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2b                	cmp    $0x2b,%al
  800f58:	75 05                	jne    800f5f <strtol+0x39>
		s++;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	eb 13                	jmp    800f72 <strtol+0x4c>
	else if (*s == '-')
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 2d                	cmp    $0x2d,%al
  800f66:	75 0a                	jne    800f72 <strtol+0x4c>
		s++, neg = 1;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f76:	74 06                	je     800f7e <strtol+0x58>
  800f78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7c:	75 20                	jne    800f9e <strtol+0x78>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 30                	cmp    $0x30,%al
  800f85:	75 17                	jne    800f9e <strtol+0x78>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	40                   	inc    %eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 78                	cmp    $0x78,%al
  800f8f:	75 0d                	jne    800f9e <strtol+0x78>
		s += 2, base = 16;
  800f91:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f95:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9c:	eb 28                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	75 15                	jne    800fb9 <strtol+0x93>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 0c                	jne    800fb9 <strtol+0x93>
		s++, base = 8;
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb7:	eb 0d                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0)
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	75 07                	jne    800fc6 <strtol+0xa0>
		base = 10;
  800fbf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 2f                	cmp    $0x2f,%al
  800fcd:	7e 19                	jle    800fe8 <strtol+0xc2>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 39                	cmp    $0x39,%al
  800fd6:	7f 10                	jg     800fe8 <strtol+0xc2>
			dig = *s - '0';
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 30             	sub    $0x30,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 42                	jmp    80102a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 60                	cmp    $0x60,%al
  800fef:	7e 19                	jle    80100a <strtol+0xe4>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 7a                	cmp    $0x7a,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 57             	sub    $0x57,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 20                	jmp    80102a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 40                	cmp    $0x40,%al
  801011:	7e 39                	jle    80104c <strtol+0x126>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 5a                	cmp    $0x5a,%al
  80101a:	7f 30                	jg     80104c <strtol+0x126>
			dig = *s - 'A' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 37             	sub    $0x37,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801030:	7d 19                	jge    80104b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103c:	89 c2                	mov    %eax,%edx
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801041:	01 d0                	add    %edx,%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801046:	e9 7b ff ff ff       	jmp    800fc6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 08                	je     80105a <strtol+0x134>
		*endptr = (char *) s;
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105e:	74 07                	je     801067 <strtol+0x141>
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801063:	f7 d8                	neg    %eax
  801065:	eb 03                	jmp    80106a <strtol+0x144>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <ltostr>:

void
ltostr(long value, char *str)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801079:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801084:	79 13                	jns    801099 <ltostr+0x2d>
	{
		neg = 1;
  801086:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801093:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801096:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a1:	99                   	cltd   
  8010a2:	f7 f9                	idiv   %ecx
  8010a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b0:	89 c2                	mov    %eax,%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ba:	83 c2 30             	add    $0x30,%edx
  8010bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e0:	f7 e9                	imul   %ecx
  8010e2:	c1 fa 02             	sar    $0x2,%edx
  8010e5:	89 c8                	mov    %ecx,%eax
  8010e7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	c1 e0 02             	shl    $0x2,%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	01 c0                	add    %eax,%eax
  8010f5:	29 c1                	sub    %eax,%ecx
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	85 d2                	test   %edx,%edx
  8010fb:	75 9c                	jne    801099 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	48                   	dec    %eax
  801108:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80110b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110f:	74 3d                	je     80114e <ltostr+0xe2>
		start = 1 ;
  801111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801118:	eb 34                	jmp    80114e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	01 c2                	add    %eax,%edx
  80112f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	01 c8                	add    %ecx,%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80113b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	01 c2                	add    %eax,%edx
  801143:	8a 45 eb             	mov    -0x15(%ebp),%al
  801146:	88 02                	mov    %al,(%edx)
		start++ ;
  801148:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80114b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80114e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801151:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801154:	7c c4                	jl     80111a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801156:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801161:	90                   	nop
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 54 fa ff ff       	call   800bc6 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	e8 46 fa ff ff       	call   800bc6 <strlen>
  801180:	83 c4 04             	add    $0x4,%esp
  801183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801186:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801194:	eb 17                	jmp    8011ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 c2                	add    %eax,%edx
  80119e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	01 c8                	add    %ecx,%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011aa:	ff 45 fc             	incl   -0x4(%ebp)
  8011ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b3:	7c e1                	jl     801196 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c3:	eb 1f                	jmp    8011e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 c2                	add    %eax,%edx
  8011d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 c8                	add    %ecx,%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c d9                	jl     8011c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	8b 00                	mov    (%eax),%eax
  80120b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	eb 0c                	jmp    80122b <strsplit+0x31>
			*string++ = 0;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 08             	mov    %edx,0x8(%ebp)
  801228:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	84 c0                	test   %al,%al
  801232:	74 18                	je     80124c <strsplit+0x52>
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	0f be c0             	movsbl %al,%eax
  80123c:	50                   	push   %eax
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	e8 13 fb ff ff       	call   800d58 <strchr>
  801245:	83 c4 08             	add    $0x8,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	75 d3                	jne    80121f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	84 c0                	test   %al,%al
  801253:	74 5a                	je     8012af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	83 f8 0f             	cmp    $0xf,%eax
  80125d:	75 07                	jne    801266 <strsplit+0x6c>
		{
			return 0;
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	eb 66                	jmp    8012cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 48 01             	lea    0x1(%eax),%ecx
  80126e:	8b 55 14             	mov    0x14(%ebp),%edx
  801271:	89 0a                	mov    %ecx,(%edx)
  801273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 c2                	add    %eax,%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801284:	eb 03                	jmp    801289 <strsplit+0x8f>
			string++;
  801286:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	84 c0                	test   %al,%al
  801290:	74 8b                	je     80121d <strsplit+0x23>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	50                   	push   %eax
  80129b:	ff 75 0c             	pushl  0xc(%ebp)
  80129e:	e8 b5 fa ff ff       	call   800d58 <strchr>
  8012a3:	83 c4 08             	add    $0x8,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	74 dc                	je     801286 <strsplit+0x8c>
			string++;
	}
  8012aa:	e9 6e ff ff ff       	jmp    80121d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 1f                	je     8012fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012dd:	e8 1d 00 00 00       	call   8012ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	68 30 3a 80 00       	push   $0x803a30
  8012ea:	e8 55 f2 ff ff       	call   800544 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012f9:	00 00 00 
	}
}
  8012fc:	90                   	nop
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801305:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80130c:	00 00 00 
  80130f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801316:	00 00 00 
  801319:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801320:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801323:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80132a:	00 00 00 
  80132d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801334:	00 00 00 
  801337:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80133e:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801341:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801348:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80134b:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801355:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80135a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80135f:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801364:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80136b:	a1 20 41 80 00       	mov    0x804120,%eax
  801370:	c1 e0 04             	shl    $0x4,%eax
  801373:	89 c2                	mov    %eax,%edx
  801375:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	48                   	dec    %eax
  80137b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80137e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801381:	ba 00 00 00 00       	mov    $0x0,%edx
  801386:	f7 75 f0             	divl   -0x10(%ebp)
  801389:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80138c:	29 d0                	sub    %edx,%eax
  80138e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801391:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801398:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80139b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a5:	83 ec 04             	sub    $0x4,%esp
  8013a8:	6a 06                	push   $0x6
  8013aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8013ad:	50                   	push   %eax
  8013ae:	e8 b0 05 00 00       	call   801963 <sys_allocate_chunk>
  8013b3:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013b6:	a1 20 41 80 00       	mov    0x804120,%eax
  8013bb:	83 ec 0c             	sub    $0xc,%esp
  8013be:	50                   	push   %eax
  8013bf:	e8 25 0c 00 00       	call   801fe9 <initialize_MemBlocksList>
  8013c4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8013c7:	a1 48 41 80 00       	mov    0x804148,%eax
  8013cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8013cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013d3:	75 14                	jne    8013e9 <initialize_dyn_block_system+0xea>
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	68 55 3a 80 00       	push   $0x803a55
  8013dd:	6a 29                	push   $0x29
  8013df:	68 73 3a 80 00       	push   $0x803a73
  8013e4:	e8 a7 ee ff ff       	call   800290 <_panic>
  8013e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ec:	8b 00                	mov    (%eax),%eax
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	74 10                	je     801402 <initialize_dyn_block_system+0x103>
  8013f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f5:	8b 00                	mov    (%eax),%eax
  8013f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013fa:	8b 52 04             	mov    0x4(%edx),%edx
  8013fd:	89 50 04             	mov    %edx,0x4(%eax)
  801400:	eb 0b                	jmp    80140d <initialize_dyn_block_system+0x10e>
  801402:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801405:	8b 40 04             	mov    0x4(%eax),%eax
  801408:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80140d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801410:	8b 40 04             	mov    0x4(%eax),%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	74 0f                	je     801426 <initialize_dyn_block_system+0x127>
  801417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141a:	8b 40 04             	mov    0x4(%eax),%eax
  80141d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801420:	8b 12                	mov    (%edx),%edx
  801422:	89 10                	mov    %edx,(%eax)
  801424:	eb 0a                	jmp    801430 <initialize_dyn_block_system+0x131>
  801426:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801429:	8b 00                	mov    (%eax),%eax
  80142b:	a3 48 41 80 00       	mov    %eax,0x804148
  801430:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801433:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801443:	a1 54 41 80 00       	mov    0x804154,%eax
  801448:	48                   	dec    %eax
  801449:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80144e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801451:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801458:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801462:	83 ec 0c             	sub    $0xc,%esp
  801465:	ff 75 e0             	pushl  -0x20(%ebp)
  801468:	e8 b9 14 00 00       	call   802926 <insert_sorted_with_merge_freeList>
  80146d:	83 c4 10             	add    $0x10,%esp

}
  801470:	90                   	nop
  801471:	c9                   	leave  
  801472:	c3                   	ret    

00801473 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801479:	e8 50 fe ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80147e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801482:	75 07                	jne    80148b <malloc+0x18>
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
  801489:	eb 68                	jmp    8014f3 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  80148b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801492:	8b 55 08             	mov    0x8(%ebp),%edx
  801495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801498:	01 d0                	add    %edx,%eax
  80149a:	48                   	dec    %eax
  80149b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80149e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a6:	f7 75 f4             	divl   -0xc(%ebp)
  8014a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ac:	29 d0                	sub    %edx,%eax
  8014ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8014b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014b8:	e8 74 08 00 00       	call   801d31 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	74 2d                	je     8014ee <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8014c1:	83 ec 0c             	sub    $0xc,%esp
  8014c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8014c7:	e8 52 0e 00 00       	call   80231e <alloc_block_FF>
  8014cc:	83 c4 10             	add    $0x10,%esp
  8014cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8014d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014d6:	74 16                	je     8014ee <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8014d8:	83 ec 0c             	sub    $0xc,%esp
  8014db:	ff 75 e8             	pushl  -0x18(%ebp)
  8014de:	e8 3b 0c 00 00       	call   80211e <insert_sorted_allocList>
  8014e3:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8014e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014e9:	8b 40 08             	mov    0x8(%eax),%eax
  8014ec:	eb 05                	jmp    8014f3 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8014ee:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8014f3:	c9                   	leave  
  8014f4:	c3                   	ret    

008014f5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8014fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fe:	83 ec 08             	sub    $0x8,%esp
  801501:	50                   	push   %eax
  801502:	68 40 40 80 00       	push   $0x804040
  801507:	e8 ba 0b 00 00       	call   8020c6 <find_block>
  80150c:	83 c4 10             	add    $0x10,%esp
  80150f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801515:	8b 40 0c             	mov    0xc(%eax),%eax
  801518:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80151b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80151f:	0f 84 9f 00 00 00    	je     8015c4 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	ff 75 f0             	pushl  -0x10(%ebp)
  80152e:	50                   	push   %eax
  80152f:	e8 f7 03 00 00       	call   80192b <sys_free_user_mem>
  801534:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801537:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80153b:	75 14                	jne    801551 <free+0x5c>
  80153d:	83 ec 04             	sub    $0x4,%esp
  801540:	68 55 3a 80 00       	push   $0x803a55
  801545:	6a 6a                	push   $0x6a
  801547:	68 73 3a 80 00       	push   $0x803a73
  80154c:	e8 3f ed ff ff       	call   800290 <_panic>
  801551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801554:	8b 00                	mov    (%eax),%eax
  801556:	85 c0                	test   %eax,%eax
  801558:	74 10                	je     80156a <free+0x75>
  80155a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155d:	8b 00                	mov    (%eax),%eax
  80155f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801562:	8b 52 04             	mov    0x4(%edx),%edx
  801565:	89 50 04             	mov    %edx,0x4(%eax)
  801568:	eb 0b                	jmp    801575 <free+0x80>
  80156a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156d:	8b 40 04             	mov    0x4(%eax),%eax
  801570:	a3 44 40 80 00       	mov    %eax,0x804044
  801575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801578:	8b 40 04             	mov    0x4(%eax),%eax
  80157b:	85 c0                	test   %eax,%eax
  80157d:	74 0f                	je     80158e <free+0x99>
  80157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801582:	8b 40 04             	mov    0x4(%eax),%eax
  801585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801588:	8b 12                	mov    (%edx),%edx
  80158a:	89 10                	mov    %edx,(%eax)
  80158c:	eb 0a                	jmp    801598 <free+0xa3>
  80158e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801591:	8b 00                	mov    (%eax),%eax
  801593:	a3 40 40 80 00       	mov    %eax,0x804040
  801598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015ab:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015b0:	48                   	dec    %eax
  8015b1:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8015b6:	83 ec 0c             	sub    $0xc,%esp
  8015b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015bc:	e8 65 13 00 00       	call   802926 <insert_sorted_with_merge_freeList>
  8015c1:	83 c4 10             	add    $0x10,%esp
	}
}
  8015c4:	90                   	nop
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 28             	sub    $0x28,%esp
  8015cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015d3:	e8 f6 fc ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8015d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015dc:	75 0a                	jne    8015e8 <smalloc+0x21>
  8015de:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e3:	e9 af 00 00 00       	jmp    801697 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8015e8:	e8 44 07 00 00       	call   801d31 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ed:	83 f8 01             	cmp    $0x1,%eax
  8015f0:	0f 85 9c 00 00 00    	jne    801692 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8015f6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801603:	01 d0                	add    %edx,%eax
  801605:	48                   	dec    %eax
  801606:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801609:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160c:	ba 00 00 00 00       	mov    $0x0,%edx
  801611:	f7 75 f4             	divl   -0xc(%ebp)
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	29 d0                	sub    %edx,%eax
  801619:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80161c:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801623:	76 07                	jbe    80162c <smalloc+0x65>
			return NULL;
  801625:	b8 00 00 00 00       	mov    $0x0,%eax
  80162a:	eb 6b                	jmp    801697 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80162c:	83 ec 0c             	sub    $0xc,%esp
  80162f:	ff 75 0c             	pushl  0xc(%ebp)
  801632:	e8 e7 0c 00 00       	call   80231e <alloc_block_FF>
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80163d:	83 ec 0c             	sub    $0xc,%esp
  801640:	ff 75 ec             	pushl  -0x14(%ebp)
  801643:	e8 d6 0a 00 00       	call   80211e <insert_sorted_allocList>
  801648:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80164b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80164f:	75 07                	jne    801658 <smalloc+0x91>
		{
			return NULL;
  801651:	b8 00 00 00 00       	mov    $0x0,%eax
  801656:	eb 3f                	jmp    801697 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801658:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80165b:	8b 40 08             	mov    0x8(%eax),%eax
  80165e:	89 c2                	mov    %eax,%edx
  801660:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801664:	52                   	push   %edx
  801665:	50                   	push   %eax
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	ff 75 08             	pushl  0x8(%ebp)
  80166c:	e8 45 04 00 00       	call   801ab6 <sys_createSharedObject>
  801671:	83 c4 10             	add    $0x10,%esp
  801674:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801677:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80167b:	74 06                	je     801683 <smalloc+0xbc>
  80167d:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801681:	75 07                	jne    80168a <smalloc+0xc3>
		{
			return NULL;
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
  801688:	eb 0d                	jmp    801697 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  80168a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80168d:	8b 40 08             	mov    0x8(%eax),%eax
  801690:	eb 05                	jmp    801697 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801692:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801697:	c9                   	leave  
  801698:	c3                   	ret    

00801699 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801699:	55                   	push   %ebp
  80169a:	89 e5                	mov    %esp,%ebp
  80169c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80169f:	e8 2a fc ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016a4:	83 ec 08             	sub    $0x8,%esp
  8016a7:	ff 75 0c             	pushl  0xc(%ebp)
  8016aa:	ff 75 08             	pushl  0x8(%ebp)
  8016ad:	e8 2e 04 00 00       	call   801ae0 <sys_getSizeOfSharedObject>
  8016b2:	83 c4 10             	add    $0x10,%esp
  8016b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8016b8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016bc:	75 0a                	jne    8016c8 <sget+0x2f>
	{
		return NULL;
  8016be:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c3:	e9 94 00 00 00       	jmp    80175c <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016c8:	e8 64 06 00 00       	call   801d31 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016cd:	85 c0                	test   %eax,%eax
  8016cf:	0f 84 82 00 00 00    	je     801757 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8016d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8016dc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e9:	01 d0                	add    %edx,%eax
  8016eb:	48                   	dec    %eax
  8016ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f7:	f7 75 ec             	divl   -0x14(%ebp)
  8016fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016fd:	29 d0                	sub    %edx,%eax
  8016ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801705:	83 ec 0c             	sub    $0xc,%esp
  801708:	50                   	push   %eax
  801709:	e8 10 0c 00 00       	call   80231e <alloc_block_FF>
  80170e:	83 c4 10             	add    $0x10,%esp
  801711:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801714:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801718:	75 07                	jne    801721 <sget+0x88>
		{
			return NULL;
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
  80171f:	eb 3b                	jmp    80175c <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	8b 40 08             	mov    0x8(%eax),%eax
  801727:	83 ec 04             	sub    $0x4,%esp
  80172a:	50                   	push   %eax
  80172b:	ff 75 0c             	pushl  0xc(%ebp)
  80172e:	ff 75 08             	pushl  0x8(%ebp)
  801731:	e8 c7 03 00 00       	call   801afd <sys_getSharedObject>
  801736:	83 c4 10             	add    $0x10,%esp
  801739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80173c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801740:	74 06                	je     801748 <sget+0xaf>
  801742:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801746:	75 07                	jne    80174f <sget+0xb6>
		{
			return NULL;
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
  80174d:	eb 0d                	jmp    80175c <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80174f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801752:	8b 40 08             	mov    0x8(%eax),%eax
  801755:	eb 05                	jmp    80175c <sget+0xc3>
		}
	}
	else
			return NULL;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801764:	e8 65 fb ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801769:	83 ec 04             	sub    $0x4,%esp
  80176c:	68 80 3a 80 00       	push   $0x803a80
  801771:	68 e1 00 00 00       	push   $0xe1
  801776:	68 73 3a 80 00       	push   $0x803a73
  80177b:	e8 10 eb ff ff       	call   800290 <_panic>

00801780 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801786:	83 ec 04             	sub    $0x4,%esp
  801789:	68 a8 3a 80 00       	push   $0x803aa8
  80178e:	68 f5 00 00 00       	push   $0xf5
  801793:	68 73 3a 80 00       	push   $0x803a73
  801798:	e8 f3 ea ff ff       	call   800290 <_panic>

0080179d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a3:	83 ec 04             	sub    $0x4,%esp
  8017a6:	68 cc 3a 80 00       	push   $0x803acc
  8017ab:	68 00 01 00 00       	push   $0x100
  8017b0:	68 73 3a 80 00       	push   $0x803a73
  8017b5:	e8 d6 ea ff ff       	call   800290 <_panic>

008017ba <shrink>:

}
void shrink(uint32 newSize)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	68 cc 3a 80 00       	push   $0x803acc
  8017c8:	68 05 01 00 00       	push   $0x105
  8017cd:	68 73 3a 80 00       	push   $0x803a73
  8017d2:	e8 b9 ea ff ff       	call   800290 <_panic>

008017d7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017d7:	55                   	push   %ebp
  8017d8:	89 e5                	mov    %esp,%ebp
  8017da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017dd:	83 ec 04             	sub    $0x4,%esp
  8017e0:	68 cc 3a 80 00       	push   $0x803acc
  8017e5:	68 0a 01 00 00       	push   $0x10a
  8017ea:	68 73 3a 80 00       	push   $0x803a73
  8017ef:	e8 9c ea ff ff       	call   800290 <_panic>

008017f4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017f4:	55                   	push   %ebp
  8017f5:	89 e5                	mov    %esp,%ebp
  8017f7:	57                   	push   %edi
  8017f8:	56                   	push   %esi
  8017f9:	53                   	push   %ebx
  8017fa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801800:	8b 55 0c             	mov    0xc(%ebp),%edx
  801803:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801806:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801809:	8b 7d 18             	mov    0x18(%ebp),%edi
  80180c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80180f:	cd 30                	int    $0x30
  801811:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801814:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801817:	83 c4 10             	add    $0x10,%esp
  80181a:	5b                   	pop    %ebx
  80181b:	5e                   	pop    %esi
  80181c:	5f                   	pop    %edi
  80181d:	5d                   	pop    %ebp
  80181e:	c3                   	ret    

0080181f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 04             	sub    $0x4,%esp
  801825:	8b 45 10             	mov    0x10(%ebp),%eax
  801828:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80182b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	52                   	push   %edx
  801837:	ff 75 0c             	pushl  0xc(%ebp)
  80183a:	50                   	push   %eax
  80183b:	6a 00                	push   $0x0
  80183d:	e8 b2 ff ff ff       	call   8017f4 <syscall>
  801842:	83 c4 18             	add    $0x18,%esp
}
  801845:	90                   	nop
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_cgetc>:

int
sys_cgetc(void)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 01                	push   $0x1
  801857:	e8 98 ff ff ff       	call   8017f4 <syscall>
  80185c:	83 c4 18             	add    $0x18,%esp
}
  80185f:	c9                   	leave  
  801860:	c3                   	ret    

00801861 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801861:	55                   	push   %ebp
  801862:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801864:	8b 55 0c             	mov    0xc(%ebp),%edx
  801867:	8b 45 08             	mov    0x8(%ebp),%eax
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	6a 00                	push   $0x0
  801870:	52                   	push   %edx
  801871:	50                   	push   %eax
  801872:	6a 05                	push   $0x5
  801874:	e8 7b ff ff ff       	call   8017f4 <syscall>
  801879:	83 c4 18             	add    $0x18,%esp
}
  80187c:	c9                   	leave  
  80187d:	c3                   	ret    

0080187e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	56                   	push   %esi
  801882:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801883:	8b 75 18             	mov    0x18(%ebp),%esi
  801886:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801889:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	56                   	push   %esi
  801893:	53                   	push   %ebx
  801894:	51                   	push   %ecx
  801895:	52                   	push   %edx
  801896:	50                   	push   %eax
  801897:	6a 06                	push   $0x6
  801899:	e8 56 ff ff ff       	call   8017f4 <syscall>
  80189e:	83 c4 18             	add    $0x18,%esp
}
  8018a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a4:	5b                   	pop    %ebx
  8018a5:	5e                   	pop    %esi
  8018a6:	5d                   	pop    %ebp
  8018a7:	c3                   	ret    

008018a8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	52                   	push   %edx
  8018b8:	50                   	push   %eax
  8018b9:	6a 07                	push   $0x7
  8018bb:	e8 34 ff ff ff       	call   8017f4 <syscall>
  8018c0:	83 c4 18             	add    $0x18,%esp
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	ff 75 0c             	pushl  0xc(%ebp)
  8018d1:	ff 75 08             	pushl  0x8(%ebp)
  8018d4:	6a 08                	push   $0x8
  8018d6:	e8 19 ff ff ff       	call   8017f4 <syscall>
  8018db:	83 c4 18             	add    $0x18,%esp
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 09                	push   $0x9
  8018ef:	e8 00 ff ff ff       	call   8017f4 <syscall>
  8018f4:	83 c4 18             	add    $0x18,%esp
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 0a                	push   $0xa
  801908:	e8 e7 fe ff ff       	call   8017f4 <syscall>
  80190d:	83 c4 18             	add    $0x18,%esp
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 0b                	push   $0xb
  801921:	e8 ce fe ff ff       	call   8017f4 <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	c9                   	leave  
  80192a:	c3                   	ret    

0080192b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	ff 75 0c             	pushl  0xc(%ebp)
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	6a 0f                	push   $0xf
  80193c:	e8 b3 fe ff ff       	call   8017f4 <syscall>
  801941:	83 c4 18             	add    $0x18,%esp
	return;
  801944:	90                   	nop
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 10                	push   $0x10
  801958:	e8 97 fe ff ff       	call   8017f4 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
	return ;
  801960:	90                   	nop
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	ff 75 10             	pushl  0x10(%ebp)
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	ff 75 08             	pushl  0x8(%ebp)
  801973:	6a 11                	push   $0x11
  801975:	e8 7a fe ff ff       	call   8017f4 <syscall>
  80197a:	83 c4 18             	add    $0x18,%esp
	return ;
  80197d:	90                   	nop
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 0c                	push   $0xc
  80198f:	e8 60 fe ff ff       	call   8017f4 <syscall>
  801994:	83 c4 18             	add    $0x18,%esp
}
  801997:	c9                   	leave  
  801998:	c3                   	ret    

00801999 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801999:	55                   	push   %ebp
  80199a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	ff 75 08             	pushl  0x8(%ebp)
  8019a7:	6a 0d                	push   $0xd
  8019a9:	e8 46 fe ff ff       	call   8017f4 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 0e                	push   $0xe
  8019c2:	e8 2d fe ff ff       	call   8017f4 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	90                   	nop
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	6a 00                	push   $0x0
  8019da:	6a 13                	push   $0x13
  8019dc:	e8 13 fe ff ff       	call   8017f4 <syscall>
  8019e1:	83 c4 18             	add    $0x18,%esp
}
  8019e4:	90                   	nop
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 14                	push   $0x14
  8019f6:	e8 f9 fd ff ff       	call   8017f4 <syscall>
  8019fb:	83 c4 18             	add    $0x18,%esp
}
  8019fe:	90                   	nop
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 04             	sub    $0x4,%esp
  801a07:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a0d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	50                   	push   %eax
  801a1a:	6a 15                	push   $0x15
  801a1c:	e8 d3 fd ff ff       	call   8017f4 <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	90                   	nop
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	6a 16                	push   $0x16
  801a36:	e8 b9 fd ff ff       	call   8017f4 <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	90                   	nop
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	ff 75 0c             	pushl  0xc(%ebp)
  801a50:	50                   	push   %eax
  801a51:	6a 17                	push   $0x17
  801a53:	e8 9c fd ff ff       	call   8017f4 <syscall>
  801a58:	83 c4 18             	add    $0x18,%esp
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a63:	8b 45 08             	mov    0x8(%ebp),%eax
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	52                   	push   %edx
  801a6d:	50                   	push   %eax
  801a6e:	6a 1a                	push   $0x1a
  801a70:	e8 7f fd ff ff       	call   8017f4 <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	52                   	push   %edx
  801a8a:	50                   	push   %eax
  801a8b:	6a 18                	push   $0x18
  801a8d:	e8 62 fd ff ff       	call   8017f4 <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	90                   	nop
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	52                   	push   %edx
  801aa8:	50                   	push   %eax
  801aa9:	6a 19                	push   $0x19
  801aab:	e8 44 fd ff ff       	call   8017f4 <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
}
  801ab3:	90                   	nop
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
  801ab9:	83 ec 04             	sub    $0x4,%esp
  801abc:	8b 45 10             	mov    0x10(%ebp),%eax
  801abf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ac2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ac5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	51                   	push   %ecx
  801acf:	52                   	push   %edx
  801ad0:	ff 75 0c             	pushl  0xc(%ebp)
  801ad3:	50                   	push   %eax
  801ad4:	6a 1b                	push   $0x1b
  801ad6:	e8 19 fd ff ff       	call   8017f4 <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ae3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	6a 00                	push   $0x0
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	52                   	push   %edx
  801af0:	50                   	push   %eax
  801af1:	6a 1c                	push   $0x1c
  801af3:	e8 fc fc ff ff       	call   8017f4 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b06:	8b 45 08             	mov    0x8(%ebp),%eax
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	51                   	push   %ecx
  801b0e:	52                   	push   %edx
  801b0f:	50                   	push   %eax
  801b10:	6a 1d                	push   $0x1d
  801b12:	e8 dd fc ff ff       	call   8017f4 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	c9                   	leave  
  801b1b:	c3                   	ret    

00801b1c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b1c:	55                   	push   %ebp
  801b1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	52                   	push   %edx
  801b2c:	50                   	push   %eax
  801b2d:	6a 1e                	push   $0x1e
  801b2f:	e8 c0 fc ff ff       	call   8017f4 <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 1f                	push   $0x1f
  801b48:	e8 a7 fc ff ff       	call   8017f4 <syscall>
  801b4d:	83 c4 18             	add    $0x18,%esp
}
  801b50:	c9                   	leave  
  801b51:	c3                   	ret    

00801b52 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b52:	55                   	push   %ebp
  801b53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	6a 00                	push   $0x0
  801b5a:	ff 75 14             	pushl  0x14(%ebp)
  801b5d:	ff 75 10             	pushl  0x10(%ebp)
  801b60:	ff 75 0c             	pushl  0xc(%ebp)
  801b63:	50                   	push   %eax
  801b64:	6a 20                	push   $0x20
  801b66:	e8 89 fc ff ff       	call   8017f4 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b73:	8b 45 08             	mov    0x8(%ebp),%eax
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	50                   	push   %eax
  801b7f:	6a 21                	push   $0x21
  801b81:	e8 6e fc ff ff       	call   8017f4 <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	90                   	nop
  801b8a:	c9                   	leave  
  801b8b:	c3                   	ret    

00801b8c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 00                	push   $0x0
  801b9a:	50                   	push   %eax
  801b9b:	6a 22                	push   $0x22
  801b9d:	e8 52 fc ff ff       	call   8017f4 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 02                	push   $0x2
  801bb6:	e8 39 fc ff ff       	call   8017f4 <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 03                	push   $0x3
  801bcf:	e8 20 fc ff ff       	call   8017f4 <syscall>
  801bd4:	83 c4 18             	add    $0x18,%esp
}
  801bd7:	c9                   	leave  
  801bd8:	c3                   	ret    

00801bd9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bd9:	55                   	push   %ebp
  801bda:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 04                	push   $0x4
  801be8:	e8 07 fc ff ff       	call   8017f4 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_exit_env>:


void sys_exit_env(void)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 23                	push   $0x23
  801c01:	e8 ee fb ff ff       	call   8017f4 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	90                   	nop
  801c0a:	c9                   	leave  
  801c0b:	c3                   	ret    

00801c0c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c15:	8d 50 04             	lea    0x4(%eax),%edx
  801c18:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	52                   	push   %edx
  801c22:	50                   	push   %eax
  801c23:	6a 24                	push   $0x24
  801c25:	e8 ca fb ff ff       	call   8017f4 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return result;
  801c2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c36:	89 01                	mov    %eax,(%ecx)
  801c38:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	c9                   	leave  
  801c3f:	c2 04 00             	ret    $0x4

00801c42 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	ff 75 10             	pushl  0x10(%ebp)
  801c4c:	ff 75 0c             	pushl  0xc(%ebp)
  801c4f:	ff 75 08             	pushl  0x8(%ebp)
  801c52:	6a 12                	push   $0x12
  801c54:	e8 9b fb ff ff       	call   8017f4 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5c:	90                   	nop
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_rcr2>:
uint32 sys_rcr2()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 25                	push   $0x25
  801c6e:	e8 81 fb ff ff       	call   8017f4 <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 04             	sub    $0x4,%esp
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c84:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	50                   	push   %eax
  801c91:	6a 26                	push   $0x26
  801c93:	e8 5c fb ff ff       	call   8017f4 <syscall>
  801c98:	83 c4 18             	add    $0x18,%esp
	return ;
  801c9b:	90                   	nop
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <rsttst>:
void rsttst()
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 28                	push   $0x28
  801cad:	e8 42 fb ff ff       	call   8017f4 <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb5:	90                   	nop
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cc4:	8b 55 18             	mov    0x18(%ebp),%edx
  801cc7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ccb:	52                   	push   %edx
  801ccc:	50                   	push   %eax
  801ccd:	ff 75 10             	pushl  0x10(%ebp)
  801cd0:	ff 75 0c             	pushl  0xc(%ebp)
  801cd3:	ff 75 08             	pushl  0x8(%ebp)
  801cd6:	6a 27                	push   $0x27
  801cd8:	e8 17 fb ff ff       	call   8017f4 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce0:	90                   	nop
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <chktst>:
void chktst(uint32 n)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	ff 75 08             	pushl  0x8(%ebp)
  801cf1:	6a 29                	push   $0x29
  801cf3:	e8 fc fa ff ff       	call   8017f4 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfb:	90                   	nop
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <inctst>:

void inctst()
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d01:	6a 00                	push   $0x0
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 2a                	push   $0x2a
  801d0d:	e8 e2 fa ff ff       	call   8017f4 <syscall>
  801d12:	83 c4 18             	add    $0x18,%esp
	return ;
  801d15:	90                   	nop
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <gettst>:
uint32 gettst()
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 2b                	push   $0x2b
  801d27:	e8 c8 fa ff ff       	call   8017f4 <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 2c                	push   $0x2c
  801d43:	e8 ac fa ff ff       	call   8017f4 <syscall>
  801d48:	83 c4 18             	add    $0x18,%esp
  801d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d4e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d52:	75 07                	jne    801d5b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d54:	b8 01 00 00 00       	mov    $0x1,%eax
  801d59:	eb 05                	jmp    801d60 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d60:	c9                   	leave  
  801d61:	c3                   	ret    

00801d62 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d62:	55                   	push   %ebp
  801d63:	89 e5                	mov    %esp,%ebp
  801d65:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 2c                	push   $0x2c
  801d74:	e8 7b fa ff ff       	call   8017f4 <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
  801d7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d7f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d83:	75 07                	jne    801d8c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d85:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8a:	eb 05                	jmp    801d91 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
  801d96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 2c                	push   $0x2c
  801da5:	e8 4a fa ff ff       	call   8017f4 <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
  801dad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801db0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801db4:	75 07                	jne    801dbd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801db6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbb:	eb 05                	jmp    801dc2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801dbd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 2c                	push   $0x2c
  801dd6:	e8 19 fa ff ff       	call   8017f4 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
  801dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801de1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801de5:	75 07                	jne    801dee <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801de7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dec:	eb 05                	jmp    801df3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	6a 2d                	push   $0x2d
  801e05:	e8 ea f9 ff ff       	call   8017f4 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0d:	90                   	nop
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e20:	6a 00                	push   $0x0
  801e22:	53                   	push   %ebx
  801e23:	51                   	push   %ecx
  801e24:	52                   	push   %edx
  801e25:	50                   	push   %eax
  801e26:	6a 2e                	push   $0x2e
  801e28:	e8 c7 f9 ff ff       	call   8017f4 <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
}
  801e30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	52                   	push   %edx
  801e45:	50                   	push   %eax
  801e46:	6a 2f                	push   $0x2f
  801e48:	e8 a7 f9 ff ff       	call   8017f4 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
  801e55:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e58:	83 ec 0c             	sub    $0xc,%esp
  801e5b:	68 dc 3a 80 00       	push   $0x803adc
  801e60:	e8 df e6 ff ff       	call   800544 <cprintf>
  801e65:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e6f:	83 ec 0c             	sub    $0xc,%esp
  801e72:	68 08 3b 80 00       	push   $0x803b08
  801e77:	e8 c8 e6 ff ff       	call   800544 <cprintf>
  801e7c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e7f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e83:	a1 38 41 80 00       	mov    0x804138,%eax
  801e88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e8b:	eb 56                	jmp    801ee3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e91:	74 1c                	je     801eaf <print_mem_block_lists+0x5d>
  801e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e96:	8b 50 08             	mov    0x8(%eax),%edx
  801e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e9c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ea2:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea5:	01 c8                	add    %ecx,%eax
  801ea7:	39 c2                	cmp    %eax,%edx
  801ea9:	73 04                	jae    801eaf <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801eab:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb2:	8b 50 08             	mov    0x8(%eax),%edx
  801eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb8:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebb:	01 c2                	add    %eax,%edx
  801ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec0:	8b 40 08             	mov    0x8(%eax),%eax
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	52                   	push   %edx
  801ec7:	50                   	push   %eax
  801ec8:	68 1d 3b 80 00       	push   $0x803b1d
  801ecd:	e8 72 e6 ff ff       	call   800544 <cprintf>
  801ed2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801edb:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee7:	74 07                	je     801ef0 <print_mem_block_lists+0x9e>
  801ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eec:	8b 00                	mov    (%eax),%eax
  801eee:	eb 05                	jmp    801ef5 <print_mem_block_lists+0xa3>
  801ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef5:	a3 40 41 80 00       	mov    %eax,0x804140
  801efa:	a1 40 41 80 00       	mov    0x804140,%eax
  801eff:	85 c0                	test   %eax,%eax
  801f01:	75 8a                	jne    801e8d <print_mem_block_lists+0x3b>
  801f03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f07:	75 84                	jne    801e8d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f09:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f0d:	75 10                	jne    801f1f <print_mem_block_lists+0xcd>
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	68 2c 3b 80 00       	push   $0x803b2c
  801f17:	e8 28 e6 ff ff       	call   800544 <cprintf>
  801f1c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	68 50 3b 80 00       	push   $0x803b50
  801f2e:	e8 11 e6 ff ff       	call   800544 <cprintf>
  801f33:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f36:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f3a:	a1 40 40 80 00       	mov    0x804040,%eax
  801f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f42:	eb 56                	jmp    801f9a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f48:	74 1c                	je     801f66 <print_mem_block_lists+0x114>
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	8b 50 08             	mov    0x8(%eax),%edx
  801f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f53:	8b 48 08             	mov    0x8(%eax),%ecx
  801f56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f59:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5c:	01 c8                	add    %ecx,%eax
  801f5e:	39 c2                	cmp    %eax,%edx
  801f60:	73 04                	jae    801f66 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f62:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f69:	8b 50 08             	mov    0x8(%eax),%edx
  801f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f72:	01 c2                	add    %eax,%edx
  801f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f77:	8b 40 08             	mov    0x8(%eax),%eax
  801f7a:	83 ec 04             	sub    $0x4,%esp
  801f7d:	52                   	push   %edx
  801f7e:	50                   	push   %eax
  801f7f:	68 1d 3b 80 00       	push   $0x803b1d
  801f84:	e8 bb e5 ff ff       	call   800544 <cprintf>
  801f89:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f92:	a1 48 40 80 00       	mov    0x804048,%eax
  801f97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9e:	74 07                	je     801fa7 <print_mem_block_lists+0x155>
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 00                	mov    (%eax),%eax
  801fa5:	eb 05                	jmp    801fac <print_mem_block_lists+0x15a>
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fac:	a3 48 40 80 00       	mov    %eax,0x804048
  801fb1:	a1 48 40 80 00       	mov    0x804048,%eax
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	75 8a                	jne    801f44 <print_mem_block_lists+0xf2>
  801fba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fbe:	75 84                	jne    801f44 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fc0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fc4:	75 10                	jne    801fd6 <print_mem_block_lists+0x184>
  801fc6:	83 ec 0c             	sub    $0xc,%esp
  801fc9:	68 68 3b 80 00       	push   $0x803b68
  801fce:	e8 71 e5 ff ff       	call   800544 <cprintf>
  801fd3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	68 dc 3a 80 00       	push   $0x803adc
  801fde:	e8 61 e5 ff ff       	call   800544 <cprintf>
  801fe3:	83 c4 10             	add    $0x10,%esp

}
  801fe6:	90                   	nop
  801fe7:	c9                   	leave  
  801fe8:	c3                   	ret    

00801fe9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fef:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ff6:	00 00 00 
  801ff9:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802000:	00 00 00 
  802003:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80200a:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80200d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802014:	e9 9e 00 00 00       	jmp    8020b7 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802019:	a1 50 40 80 00       	mov    0x804050,%eax
  80201e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802021:	c1 e2 04             	shl    $0x4,%edx
  802024:	01 d0                	add    %edx,%eax
  802026:	85 c0                	test   %eax,%eax
  802028:	75 14                	jne    80203e <initialize_MemBlocksList+0x55>
  80202a:	83 ec 04             	sub    $0x4,%esp
  80202d:	68 90 3b 80 00       	push   $0x803b90
  802032:	6a 42                	push   $0x42
  802034:	68 b3 3b 80 00       	push   $0x803bb3
  802039:	e8 52 e2 ff ff       	call   800290 <_panic>
  80203e:	a1 50 40 80 00       	mov    0x804050,%eax
  802043:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802046:	c1 e2 04             	shl    $0x4,%edx
  802049:	01 d0                	add    %edx,%eax
  80204b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802051:	89 10                	mov    %edx,(%eax)
  802053:	8b 00                	mov    (%eax),%eax
  802055:	85 c0                	test   %eax,%eax
  802057:	74 18                	je     802071 <initialize_MemBlocksList+0x88>
  802059:	a1 48 41 80 00       	mov    0x804148,%eax
  80205e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802064:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802067:	c1 e1 04             	shl    $0x4,%ecx
  80206a:	01 ca                	add    %ecx,%edx
  80206c:	89 50 04             	mov    %edx,0x4(%eax)
  80206f:	eb 12                	jmp    802083 <initialize_MemBlocksList+0x9a>
  802071:	a1 50 40 80 00       	mov    0x804050,%eax
  802076:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802079:	c1 e2 04             	shl    $0x4,%edx
  80207c:	01 d0                	add    %edx,%eax
  80207e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802083:	a1 50 40 80 00       	mov    0x804050,%eax
  802088:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208b:	c1 e2 04             	shl    $0x4,%edx
  80208e:	01 d0                	add    %edx,%eax
  802090:	a3 48 41 80 00       	mov    %eax,0x804148
  802095:	a1 50 40 80 00       	mov    0x804050,%eax
  80209a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209d:	c1 e2 04             	shl    $0x4,%edx
  8020a0:	01 d0                	add    %edx,%eax
  8020a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020a9:	a1 54 41 80 00       	mov    0x804154,%eax
  8020ae:	40                   	inc    %eax
  8020af:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8020b4:	ff 45 f4             	incl   -0xc(%ebp)
  8020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020bd:	0f 82 56 ff ff ff    	jb     802019 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8020c3:	90                   	nop
  8020c4:	c9                   	leave  
  8020c5:	c3                   	ret    

008020c6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020c6:	55                   	push   %ebp
  8020c7:	89 e5                	mov    %esp,%ebp
  8020c9:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cf:	8b 00                	mov    (%eax),%eax
  8020d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d4:	eb 19                	jmp    8020ef <find_block+0x29>
	{
		if(blk->sva==va)
  8020d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d9:	8b 40 08             	mov    0x8(%eax),%eax
  8020dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020df:	75 05                	jne    8020e6 <find_block+0x20>
			return (blk);
  8020e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020e4:	eb 36                	jmp    80211c <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	8b 40 08             	mov    0x8(%eax),%eax
  8020ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f3:	74 07                	je     8020fc <find_block+0x36>
  8020f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020f8:	8b 00                	mov    (%eax),%eax
  8020fa:	eb 05                	jmp    802101 <find_block+0x3b>
  8020fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802101:	8b 55 08             	mov    0x8(%ebp),%edx
  802104:	89 42 08             	mov    %eax,0x8(%edx)
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	8b 40 08             	mov    0x8(%eax),%eax
  80210d:	85 c0                	test   %eax,%eax
  80210f:	75 c5                	jne    8020d6 <find_block+0x10>
  802111:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802115:	75 bf                	jne    8020d6 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802117:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802124:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802129:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80212c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802133:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802136:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802139:	75 65                	jne    8021a0 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80213b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80213f:	75 14                	jne    802155 <insert_sorted_allocList+0x37>
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	68 90 3b 80 00       	push   $0x803b90
  802149:	6a 5c                	push   $0x5c
  80214b:	68 b3 3b 80 00       	push   $0x803bb3
  802150:	e8 3b e1 ff ff       	call   800290 <_panic>
  802155:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80215b:	8b 45 08             	mov    0x8(%ebp),%eax
  80215e:	89 10                	mov    %edx,(%eax)
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	8b 00                	mov    (%eax),%eax
  802165:	85 c0                	test   %eax,%eax
  802167:	74 0d                	je     802176 <insert_sorted_allocList+0x58>
  802169:	a1 40 40 80 00       	mov    0x804040,%eax
  80216e:	8b 55 08             	mov    0x8(%ebp),%edx
  802171:	89 50 04             	mov    %edx,0x4(%eax)
  802174:	eb 08                	jmp    80217e <insert_sorted_allocList+0x60>
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	a3 44 40 80 00       	mov    %eax,0x804044
  80217e:	8b 45 08             	mov    0x8(%ebp),%eax
  802181:	a3 40 40 80 00       	mov    %eax,0x804040
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802190:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802195:	40                   	inc    %eax
  802196:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80219b:	e9 7b 01 00 00       	jmp    80231b <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8021a0:	a1 44 40 80 00       	mov    0x804044,%eax
  8021a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8021a8:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8021b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b3:	8b 50 08             	mov    0x8(%eax),%edx
  8021b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021b9:	8b 40 08             	mov    0x8(%eax),%eax
  8021bc:	39 c2                	cmp    %eax,%edx
  8021be:	76 65                	jbe    802225 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8021c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c4:	75 14                	jne    8021da <insert_sorted_allocList+0xbc>
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	68 cc 3b 80 00       	push   $0x803bcc
  8021ce:	6a 64                	push   $0x64
  8021d0:	68 b3 3b 80 00       	push   $0x803bb3
  8021d5:	e8 b6 e0 ff ff       	call   800290 <_panic>
  8021da:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	89 50 04             	mov    %edx,0x4(%eax)
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	8b 40 04             	mov    0x4(%eax),%eax
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	74 0c                	je     8021fc <insert_sorted_allocList+0xde>
  8021f0:	a1 44 40 80 00       	mov    0x804044,%eax
  8021f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f8:	89 10                	mov    %edx,(%eax)
  8021fa:	eb 08                	jmp    802204 <insert_sorted_allocList+0xe6>
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	a3 40 40 80 00       	mov    %eax,0x804040
  802204:	8b 45 08             	mov    0x8(%ebp),%eax
  802207:	a3 44 40 80 00       	mov    %eax,0x804044
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802215:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80221a:	40                   	inc    %eax
  80221b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802220:	e9 f6 00 00 00       	jmp    80231b <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	8b 50 08             	mov    0x8(%eax),%edx
  80222b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80222e:	8b 40 08             	mov    0x8(%eax),%eax
  802231:	39 c2                	cmp    %eax,%edx
  802233:	73 65                	jae    80229a <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802235:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802239:	75 14                	jne    80224f <insert_sorted_allocList+0x131>
  80223b:	83 ec 04             	sub    $0x4,%esp
  80223e:	68 90 3b 80 00       	push   $0x803b90
  802243:	6a 68                	push   $0x68
  802245:	68 b3 3b 80 00       	push   $0x803bb3
  80224a:	e8 41 e0 ff ff       	call   800290 <_panic>
  80224f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	89 10                	mov    %edx,(%eax)
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	8b 00                	mov    (%eax),%eax
  80225f:	85 c0                	test   %eax,%eax
  802261:	74 0d                	je     802270 <insert_sorted_allocList+0x152>
  802263:	a1 40 40 80 00       	mov    0x804040,%eax
  802268:	8b 55 08             	mov    0x8(%ebp),%edx
  80226b:	89 50 04             	mov    %edx,0x4(%eax)
  80226e:	eb 08                	jmp    802278 <insert_sorted_allocList+0x15a>
  802270:	8b 45 08             	mov    0x8(%ebp),%eax
  802273:	a3 44 40 80 00       	mov    %eax,0x804044
  802278:	8b 45 08             	mov    0x8(%ebp),%eax
  80227b:	a3 40 40 80 00       	mov    %eax,0x804040
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80228a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80228f:	40                   	inc    %eax
  802290:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802295:	e9 81 00 00 00       	jmp    80231b <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80229a:	a1 40 40 80 00       	mov    0x804040,%eax
  80229f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022a2:	eb 51                	jmp    8022f5 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	8b 50 08             	mov    0x8(%eax),%edx
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 08             	mov    0x8(%eax),%eax
  8022b0:	39 c2                	cmp    %eax,%edx
  8022b2:	73 39                	jae    8022ed <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8022bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c3:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022cb:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8022ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d4:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022dc:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8022df:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022e4:	40                   	inc    %eax
  8022e5:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8022ea:	90                   	nop
				}
			}
		 }

	}
}
  8022eb:	eb 2e                	jmp    80231b <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022ed:	a1 48 40 80 00       	mov    0x804048,%eax
  8022f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f9:	74 07                	je     802302 <insert_sorted_allocList+0x1e4>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 00                	mov    (%eax),%eax
  802300:	eb 05                	jmp    802307 <insert_sorted_allocList+0x1e9>
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
  802307:	a3 48 40 80 00       	mov    %eax,0x804048
  80230c:	a1 48 40 80 00       	mov    0x804048,%eax
  802311:	85 c0                	test   %eax,%eax
  802313:	75 8f                	jne    8022a4 <insert_sorted_allocList+0x186>
  802315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802319:	75 89                	jne    8022a4 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80231b:	90                   	nop
  80231c:	c9                   	leave  
  80231d:	c3                   	ret    

0080231e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80231e:	55                   	push   %ebp
  80231f:	89 e5                	mov    %esp,%ebp
  802321:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802324:	a1 38 41 80 00       	mov    0x804138,%eax
  802329:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232c:	e9 76 01 00 00       	jmp    8024a7 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 40 0c             	mov    0xc(%eax),%eax
  802337:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233a:	0f 85 8a 00 00 00    	jne    8023ca <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802340:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802344:	75 17                	jne    80235d <alloc_block_FF+0x3f>
  802346:	83 ec 04             	sub    $0x4,%esp
  802349:	68 ef 3b 80 00       	push   $0x803bef
  80234e:	68 8a 00 00 00       	push   $0x8a
  802353:	68 b3 3b 80 00       	push   $0x803bb3
  802358:	e8 33 df ff ff       	call   800290 <_panic>
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	8b 00                	mov    (%eax),%eax
  802362:	85 c0                	test   %eax,%eax
  802364:	74 10                	je     802376 <alloc_block_FF+0x58>
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 00                	mov    (%eax),%eax
  80236b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80236e:	8b 52 04             	mov    0x4(%edx),%edx
  802371:	89 50 04             	mov    %edx,0x4(%eax)
  802374:	eb 0b                	jmp    802381 <alloc_block_FF+0x63>
  802376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802379:	8b 40 04             	mov    0x4(%eax),%eax
  80237c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802381:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802384:	8b 40 04             	mov    0x4(%eax),%eax
  802387:	85 c0                	test   %eax,%eax
  802389:	74 0f                	je     80239a <alloc_block_FF+0x7c>
  80238b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238e:	8b 40 04             	mov    0x4(%eax),%eax
  802391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802394:	8b 12                	mov    (%edx),%edx
  802396:	89 10                	mov    %edx,(%eax)
  802398:	eb 0a                	jmp    8023a4 <alloc_block_FF+0x86>
  80239a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239d:	8b 00                	mov    (%eax),%eax
  80239f:	a3 38 41 80 00       	mov    %eax,0x804138
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023b7:	a1 44 41 80 00       	mov    0x804144,%eax
  8023bc:	48                   	dec    %eax
  8023bd:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	e9 10 01 00 00       	jmp    8024da <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d3:	0f 86 c6 00 00 00    	jbe    80249f <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8023d9:	a1 48 41 80 00       	mov    0x804148,%eax
  8023de:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8023e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023e5:	75 17                	jne    8023fe <alloc_block_FF+0xe0>
  8023e7:	83 ec 04             	sub    $0x4,%esp
  8023ea:	68 ef 3b 80 00       	push   $0x803bef
  8023ef:	68 90 00 00 00       	push   $0x90
  8023f4:	68 b3 3b 80 00       	push   $0x803bb3
  8023f9:	e8 92 de ff ff       	call   800290 <_panic>
  8023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802401:	8b 00                	mov    (%eax),%eax
  802403:	85 c0                	test   %eax,%eax
  802405:	74 10                	je     802417 <alloc_block_FF+0xf9>
  802407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80240a:	8b 00                	mov    (%eax),%eax
  80240c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80240f:	8b 52 04             	mov    0x4(%edx),%edx
  802412:	89 50 04             	mov    %edx,0x4(%eax)
  802415:	eb 0b                	jmp    802422 <alloc_block_FF+0x104>
  802417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241a:	8b 40 04             	mov    0x4(%eax),%eax
  80241d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802422:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	85 c0                	test   %eax,%eax
  80242a:	74 0f                	je     80243b <alloc_block_FF+0x11d>
  80242c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80242f:	8b 40 04             	mov    0x4(%eax),%eax
  802432:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802435:	8b 12                	mov    (%edx),%edx
  802437:	89 10                	mov    %edx,(%eax)
  802439:	eb 0a                	jmp    802445 <alloc_block_FF+0x127>
  80243b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	a3 48 41 80 00       	mov    %eax,0x804148
  802445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802448:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80244e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802451:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802458:	a1 54 41 80 00       	mov    0x804154,%eax
  80245d:	48                   	dec    %eax
  80245e:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	8b 55 08             	mov    0x8(%ebp),%edx
  802469:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 50 08             	mov    0x8(%eax),%edx
  802472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802475:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 50 08             	mov    0x8(%eax),%edx
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	01 c2                	add    %eax,%edx
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248c:	8b 40 0c             	mov    0xc(%eax),%eax
  80248f:	2b 45 08             	sub    0x8(%ebp),%eax
  802492:	89 c2                	mov    %eax,%edx
  802494:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802497:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  80249a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249d:	eb 3b                	jmp    8024da <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80249f:	a1 40 41 80 00       	mov    0x804140,%eax
  8024a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ab:	74 07                	je     8024b4 <alloc_block_FF+0x196>
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	8b 00                	mov    (%eax),%eax
  8024b2:	eb 05                	jmp    8024b9 <alloc_block_FF+0x19b>
  8024b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b9:	a3 40 41 80 00       	mov    %eax,0x804140
  8024be:	a1 40 41 80 00       	mov    0x804140,%eax
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	0f 85 66 fe ff ff    	jne    802331 <alloc_block_FF+0x13>
  8024cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cf:	0f 85 5c fe ff ff    	jne    802331 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8024d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024da:	c9                   	leave  
  8024db:	c3                   	ret    

008024dc <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024dc:	55                   	push   %ebp
  8024dd:	89 e5                	mov    %esp,%ebp
  8024df:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8024e2:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8024e9:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8024f0:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8024f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8024fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ff:	e9 cf 00 00 00       	jmp    8025d3 <alloc_block_BF+0xf7>
		{
			c++;
  802504:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 40 0c             	mov    0xc(%eax),%eax
  80250d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802510:	0f 85 8a 00 00 00    	jne    8025a0 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802516:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251a:	75 17                	jne    802533 <alloc_block_BF+0x57>
  80251c:	83 ec 04             	sub    $0x4,%esp
  80251f:	68 ef 3b 80 00       	push   $0x803bef
  802524:	68 a8 00 00 00       	push   $0xa8
  802529:	68 b3 3b 80 00       	push   $0x803bb3
  80252e:	e8 5d dd ff ff       	call   800290 <_panic>
  802533:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802536:	8b 00                	mov    (%eax),%eax
  802538:	85 c0                	test   %eax,%eax
  80253a:	74 10                	je     80254c <alloc_block_BF+0x70>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802544:	8b 52 04             	mov    0x4(%edx),%edx
  802547:	89 50 04             	mov    %edx,0x4(%eax)
  80254a:	eb 0b                	jmp    802557 <alloc_block_BF+0x7b>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 40 04             	mov    0x4(%eax),%eax
  802552:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 40 04             	mov    0x4(%eax),%eax
  80255d:	85 c0                	test   %eax,%eax
  80255f:	74 0f                	je     802570 <alloc_block_BF+0x94>
  802561:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802564:	8b 40 04             	mov    0x4(%eax),%eax
  802567:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256a:	8b 12                	mov    (%edx),%edx
  80256c:	89 10                	mov    %edx,(%eax)
  80256e:	eb 0a                	jmp    80257a <alloc_block_BF+0x9e>
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	8b 00                	mov    (%eax),%eax
  802575:	a3 38 41 80 00       	mov    %eax,0x804138
  80257a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80258d:	a1 44 41 80 00       	mov    0x804144,%eax
  802592:	48                   	dec    %eax
  802593:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  802598:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259b:	e9 85 01 00 00       	jmp    802725 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a9:	76 20                	jbe    8025cb <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8025ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8025b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8025b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025bd:	73 0c                	jae    8025cb <alloc_block_BF+0xef>
				{
					ma=tempi;
  8025bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8025c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025cb:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d7:	74 07                	je     8025e0 <alloc_block_BF+0x104>
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	8b 00                	mov    (%eax),%eax
  8025de:	eb 05                	jmp    8025e5 <alloc_block_BF+0x109>
  8025e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8025e5:	a3 40 41 80 00       	mov    %eax,0x804140
  8025ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	0f 85 0d ff ff ff    	jne    802504 <alloc_block_BF+0x28>
  8025f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fb:	0f 85 03 ff ff ff    	jne    802504 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802601:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802608:	a1 38 41 80 00       	mov    0x804138,%eax
  80260d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802610:	e9 dd 00 00 00       	jmp    8026f2 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802618:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80261b:	0f 85 c6 00 00 00    	jne    8026e7 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802621:	a1 48 41 80 00       	mov    0x804148,%eax
  802626:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802629:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80262d:	75 17                	jne    802646 <alloc_block_BF+0x16a>
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	68 ef 3b 80 00       	push   $0x803bef
  802637:	68 bb 00 00 00       	push   $0xbb
  80263c:	68 b3 3b 80 00       	push   $0x803bb3
  802641:	e8 4a dc ff ff       	call   800290 <_panic>
  802646:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	85 c0                	test   %eax,%eax
  80264d:	74 10                	je     80265f <alloc_block_BF+0x183>
  80264f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802657:	8b 52 04             	mov    0x4(%edx),%edx
  80265a:	89 50 04             	mov    %edx,0x4(%eax)
  80265d:	eb 0b                	jmp    80266a <alloc_block_BF+0x18e>
  80265f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802662:	8b 40 04             	mov    0x4(%eax),%eax
  802665:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80266a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266d:	8b 40 04             	mov    0x4(%eax),%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	74 0f                	je     802683 <alloc_block_BF+0x1a7>
  802674:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80267d:	8b 12                	mov    (%edx),%edx
  80267f:	89 10                	mov    %edx,(%eax)
  802681:	eb 0a                	jmp    80268d <alloc_block_BF+0x1b1>
  802683:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	a3 48 41 80 00       	mov    %eax,0x804148
  80268d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802696:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802699:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8026a5:	48                   	dec    %eax
  8026a6:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8026ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b1:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8026b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b7:	8b 50 08             	mov    0x8(%eax),%edx
  8026ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bd:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8026c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c3:	8b 50 08             	mov    0x8(%eax),%edx
  8026c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c9:	01 c2                	add    %eax,%edx
  8026cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ce:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d7:	2b 45 08             	sub    0x8(%ebp),%eax
  8026da:	89 c2                	mov    %eax,%edx
  8026dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026df:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8026e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e5:	eb 3e                	jmp    802725 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8026e7:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f6:	74 07                	je     8026ff <alloc_block_BF+0x223>
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 00                	mov    (%eax),%eax
  8026fd:	eb 05                	jmp    802704 <alloc_block_BF+0x228>
  8026ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802704:	a3 40 41 80 00       	mov    %eax,0x804140
  802709:	a1 40 41 80 00       	mov    0x804140,%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	0f 85 ff fe ff ff    	jne    802615 <alloc_block_BF+0x139>
  802716:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271a:	0f 85 f5 fe ff ff    	jne    802615 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802720:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802725:	c9                   	leave  
  802726:	c3                   	ret    

00802727 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802727:	55                   	push   %ebp
  802728:	89 e5                	mov    %esp,%ebp
  80272a:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80272d:	a1 28 40 80 00       	mov    0x804028,%eax
  802732:	85 c0                	test   %eax,%eax
  802734:	75 14                	jne    80274a <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802736:	a1 38 41 80 00       	mov    0x804138,%eax
  80273b:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802740:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802747:	00 00 00 
	}
	uint32 c=1;
  80274a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802751:	a1 60 41 80 00       	mov    0x804160,%eax
  802756:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802759:	e9 b3 01 00 00       	jmp    802911 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80275e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802761:	8b 40 0c             	mov    0xc(%eax),%eax
  802764:	3b 45 08             	cmp    0x8(%ebp),%eax
  802767:	0f 85 a9 00 00 00    	jne    802816 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80276d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	85 c0                	test   %eax,%eax
  802774:	75 0c                	jne    802782 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802776:	a1 38 41 80 00       	mov    0x804138,%eax
  80277b:	a3 60 41 80 00       	mov    %eax,0x804160
  802780:	eb 0a                	jmp    80278c <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802782:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802785:	8b 00                	mov    (%eax),%eax
  802787:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  80278c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802790:	75 17                	jne    8027a9 <alloc_block_NF+0x82>
  802792:	83 ec 04             	sub    $0x4,%esp
  802795:	68 ef 3b 80 00       	push   $0x803bef
  80279a:	68 e3 00 00 00       	push   $0xe3
  80279f:	68 b3 3b 80 00       	push   $0x803bb3
  8027a4:	e8 e7 da ff ff       	call   800290 <_panic>
  8027a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	74 10                	je     8027c2 <alloc_block_NF+0x9b>
  8027b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b5:	8b 00                	mov    (%eax),%eax
  8027b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ba:	8b 52 04             	mov    0x4(%edx),%edx
  8027bd:	89 50 04             	mov    %edx,0x4(%eax)
  8027c0:	eb 0b                	jmp    8027cd <alloc_block_NF+0xa6>
  8027c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c5:	8b 40 04             	mov    0x4(%eax),%eax
  8027c8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d0:	8b 40 04             	mov    0x4(%eax),%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 0f                	je     8027e6 <alloc_block_NF+0xbf>
  8027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027da:	8b 40 04             	mov    0x4(%eax),%eax
  8027dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e0:	8b 12                	mov    (%edx),%edx
  8027e2:	89 10                	mov    %edx,(%eax)
  8027e4:	eb 0a                	jmp    8027f0 <alloc_block_NF+0xc9>
  8027e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e9:	8b 00                	mov    (%eax),%eax
  8027eb:	a3 38 41 80 00       	mov    %eax,0x804138
  8027f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802803:	a1 44 41 80 00       	mov    0x804144,%eax
  802808:	48                   	dec    %eax
  802809:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  80280e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802811:	e9 0e 01 00 00       	jmp    802924 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	8b 40 0c             	mov    0xc(%eax),%eax
  80281c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80281f:	0f 86 ce 00 00 00    	jbe    8028f3 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802825:	a1 48 41 80 00       	mov    0x804148,%eax
  80282a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80282d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802831:	75 17                	jne    80284a <alloc_block_NF+0x123>
  802833:	83 ec 04             	sub    $0x4,%esp
  802836:	68 ef 3b 80 00       	push   $0x803bef
  80283b:	68 e9 00 00 00       	push   $0xe9
  802840:	68 b3 3b 80 00       	push   $0x803bb3
  802845:	e8 46 da ff ff       	call   800290 <_panic>
  80284a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284d:	8b 00                	mov    (%eax),%eax
  80284f:	85 c0                	test   %eax,%eax
  802851:	74 10                	je     802863 <alloc_block_NF+0x13c>
  802853:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802856:	8b 00                	mov    (%eax),%eax
  802858:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80285b:	8b 52 04             	mov    0x4(%edx),%edx
  80285e:	89 50 04             	mov    %edx,0x4(%eax)
  802861:	eb 0b                	jmp    80286e <alloc_block_NF+0x147>
  802863:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802866:	8b 40 04             	mov    0x4(%eax),%eax
  802869:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80286e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802871:	8b 40 04             	mov    0x4(%eax),%eax
  802874:	85 c0                	test   %eax,%eax
  802876:	74 0f                	je     802887 <alloc_block_NF+0x160>
  802878:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287b:	8b 40 04             	mov    0x4(%eax),%eax
  80287e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802881:	8b 12                	mov    (%edx),%edx
  802883:	89 10                	mov    %edx,(%eax)
  802885:	eb 0a                	jmp    802891 <alloc_block_NF+0x16a>
  802887:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	a3 48 41 80 00       	mov    %eax,0x804148
  802891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802894:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a4:	a1 54 41 80 00       	mov    0x804154,%eax
  8028a9:	48                   	dec    %eax
  8028aa:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8028af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b5:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8028b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028bb:	8b 50 08             	mov    0x8(%eax),%edx
  8028be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c1:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8028c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c7:	8b 50 08             	mov    0x8(%eax),%edx
  8028ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cd:	01 c2                	add    %eax,%edx
  8028cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d2:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8028d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8028db:	2b 45 08             	sub    0x8(%ebp),%eax
  8028de:	89 c2                	mov    %eax,%edx
  8028e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e3:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8028ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f1:	eb 31                	jmp    802924 <alloc_block_NF+0x1fd>
			 }
		 c++;
  8028f3:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8028f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	85 c0                	test   %eax,%eax
  8028fd:	75 0a                	jne    802909 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8028ff:	a1 38 41 80 00       	mov    0x804138,%eax
  802904:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802907:	eb 08                	jmp    802911 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 00                	mov    (%eax),%eax
  80290e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802911:	a1 44 41 80 00       	mov    0x804144,%eax
  802916:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802919:	0f 85 3f fe ff ff    	jne    80275e <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  80291f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802924:	c9                   	leave  
  802925:	c3                   	ret    

00802926 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802926:	55                   	push   %ebp
  802927:	89 e5                	mov    %esp,%ebp
  802929:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80292c:	a1 44 41 80 00       	mov    0x804144,%eax
  802931:	85 c0                	test   %eax,%eax
  802933:	75 68                	jne    80299d <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802935:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802939:	75 17                	jne    802952 <insert_sorted_with_merge_freeList+0x2c>
  80293b:	83 ec 04             	sub    $0x4,%esp
  80293e:	68 90 3b 80 00       	push   $0x803b90
  802943:	68 0e 01 00 00       	push   $0x10e
  802948:	68 b3 3b 80 00       	push   $0x803bb3
  80294d:	e8 3e d9 ff ff       	call   800290 <_panic>
  802952:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802958:	8b 45 08             	mov    0x8(%ebp),%eax
  80295b:	89 10                	mov    %edx,(%eax)
  80295d:	8b 45 08             	mov    0x8(%ebp),%eax
  802960:	8b 00                	mov    (%eax),%eax
  802962:	85 c0                	test   %eax,%eax
  802964:	74 0d                	je     802973 <insert_sorted_with_merge_freeList+0x4d>
  802966:	a1 38 41 80 00       	mov    0x804138,%eax
  80296b:	8b 55 08             	mov    0x8(%ebp),%edx
  80296e:	89 50 04             	mov    %edx,0x4(%eax)
  802971:	eb 08                	jmp    80297b <insert_sorted_with_merge_freeList+0x55>
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80297b:	8b 45 08             	mov    0x8(%ebp),%eax
  80297e:	a3 38 41 80 00       	mov    %eax,0x804138
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80298d:	a1 44 41 80 00       	mov    0x804144,%eax
  802992:	40                   	inc    %eax
  802993:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802998:	e9 8c 06 00 00       	jmp    803029 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  80299d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8029a5:	a1 38 41 80 00       	mov    0x804138,%eax
  8029aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8029ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b0:	8b 50 08             	mov    0x8(%eax),%edx
  8029b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b6:	8b 40 08             	mov    0x8(%eax),%eax
  8029b9:	39 c2                	cmp    %eax,%edx
  8029bb:	0f 86 14 01 00 00    	jbe    802ad5 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c4:	8b 50 0c             	mov    0xc(%eax),%edx
  8029c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ca:	8b 40 08             	mov    0x8(%eax),%eax
  8029cd:	01 c2                	add    %eax,%edx
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	8b 40 08             	mov    0x8(%eax),%eax
  8029d5:	39 c2                	cmp    %eax,%edx
  8029d7:	0f 85 90 00 00 00    	jne    802a6d <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8029dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e0:	8b 50 0c             	mov    0xc(%eax),%edx
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e9:	01 c2                	add    %eax,%edx
  8029eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ee:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8029fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a09:	75 17                	jne    802a22 <insert_sorted_with_merge_freeList+0xfc>
  802a0b:	83 ec 04             	sub    $0x4,%esp
  802a0e:	68 90 3b 80 00       	push   $0x803b90
  802a13:	68 1b 01 00 00       	push   $0x11b
  802a18:	68 b3 3b 80 00       	push   $0x803bb3
  802a1d:	e8 6e d8 ff ff       	call   800290 <_panic>
  802a22:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	89 10                	mov    %edx,(%eax)
  802a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a30:	8b 00                	mov    (%eax),%eax
  802a32:	85 c0                	test   %eax,%eax
  802a34:	74 0d                	je     802a43 <insert_sorted_with_merge_freeList+0x11d>
  802a36:	a1 48 41 80 00       	mov    0x804148,%eax
  802a3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a3e:	89 50 04             	mov    %edx,0x4(%eax)
  802a41:	eb 08                	jmp    802a4b <insert_sorted_with_merge_freeList+0x125>
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	a3 48 41 80 00       	mov    %eax,0x804148
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a5d:	a1 54 41 80 00       	mov    0x804154,%eax
  802a62:	40                   	inc    %eax
  802a63:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802a68:	e9 bc 05 00 00       	jmp    803029 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a71:	75 17                	jne    802a8a <insert_sorted_with_merge_freeList+0x164>
  802a73:	83 ec 04             	sub    $0x4,%esp
  802a76:	68 cc 3b 80 00       	push   $0x803bcc
  802a7b:	68 1f 01 00 00       	push   $0x11f
  802a80:	68 b3 3b 80 00       	push   $0x803bb3
  802a85:	e8 06 d8 ff ff       	call   800290 <_panic>
  802a8a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	89 50 04             	mov    %edx,0x4(%eax)
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	8b 40 04             	mov    0x4(%eax),%eax
  802a9c:	85 c0                	test   %eax,%eax
  802a9e:	74 0c                	je     802aac <insert_sorted_with_merge_freeList+0x186>
  802aa0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa8:	89 10                	mov    %edx,(%eax)
  802aaa:	eb 08                	jmp    802ab4 <insert_sorted_with_merge_freeList+0x18e>
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	a3 38 41 80 00       	mov    %eax,0x804138
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ac5:	a1 44 41 80 00       	mov    0x804144,%eax
  802aca:	40                   	inc    %eax
  802acb:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802ad0:	e9 54 05 00 00       	jmp    803029 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad8:	8b 50 08             	mov    0x8(%eax),%edx
  802adb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ade:	8b 40 08             	mov    0x8(%eax),%eax
  802ae1:	39 c2                	cmp    %eax,%edx
  802ae3:	0f 83 20 01 00 00    	jae    802c09 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	8b 50 0c             	mov    0xc(%eax),%edx
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	8b 40 08             	mov    0x8(%eax),%eax
  802af5:	01 c2                	add    %eax,%edx
  802af7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802afa:	8b 40 08             	mov    0x8(%eax),%eax
  802afd:	39 c2                	cmp    %eax,%edx
  802aff:	0f 85 9c 00 00 00    	jne    802ba1 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	8b 50 08             	mov    0x8(%eax),%edx
  802b0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b0e:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b14:	8b 50 0c             	mov    0xc(%eax),%edx
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b1d:	01 c2                	add    %eax,%edx
  802b1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b22:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3d:	75 17                	jne    802b56 <insert_sorted_with_merge_freeList+0x230>
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 90 3b 80 00       	push   $0x803b90
  802b47:	68 2a 01 00 00       	push   $0x12a
  802b4c:	68 b3 3b 80 00       	push   $0x803bb3
  802b51:	e8 3a d7 ff ff       	call   800290 <_panic>
  802b56:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	89 10                	mov    %edx,(%eax)
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 0d                	je     802b77 <insert_sorted_with_merge_freeList+0x251>
  802b6a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b72:	89 50 04             	mov    %edx,0x4(%eax)
  802b75:	eb 08                	jmp    802b7f <insert_sorted_with_merge_freeList+0x259>
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	a3 48 41 80 00       	mov    %eax,0x804148
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b91:	a1 54 41 80 00       	mov    0x804154,%eax
  802b96:	40                   	inc    %eax
  802b97:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b9c:	e9 88 04 00 00       	jmp    803029 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ba1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba5:	75 17                	jne    802bbe <insert_sorted_with_merge_freeList+0x298>
  802ba7:	83 ec 04             	sub    $0x4,%esp
  802baa:	68 90 3b 80 00       	push   $0x803b90
  802baf:	68 2e 01 00 00       	push   $0x12e
  802bb4:	68 b3 3b 80 00       	push   $0x803bb3
  802bb9:	e8 d2 d6 ff ff       	call   800290 <_panic>
  802bbe:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	89 10                	mov    %edx,(%eax)
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	74 0d                	je     802bdf <insert_sorted_with_merge_freeList+0x2b9>
  802bd2:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd7:	8b 55 08             	mov    0x8(%ebp),%edx
  802bda:	89 50 04             	mov    %edx,0x4(%eax)
  802bdd:	eb 08                	jmp    802be7 <insert_sorted_with_merge_freeList+0x2c1>
  802bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802be2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	a3 38 41 80 00       	mov    %eax,0x804138
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bf9:	a1 44 41 80 00       	mov    0x804144,%eax
  802bfe:	40                   	inc    %eax
  802bff:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c04:	e9 20 04 00 00       	jmp    803029 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802c09:	a1 38 41 80 00       	mov    0x804138,%eax
  802c0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c11:	e9 e2 03 00 00       	jmp    802ff8 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c16:	8b 45 08             	mov    0x8(%ebp),%eax
  802c19:	8b 50 08             	mov    0x8(%eax),%edx
  802c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1f:	8b 40 08             	mov    0x8(%eax),%eax
  802c22:	39 c2                	cmp    %eax,%edx
  802c24:	0f 83 c6 03 00 00    	jae    802ff0 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 40 04             	mov    0x4(%eax),%eax
  802c30:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c36:	8b 50 08             	mov    0x8(%eax),%edx
  802c39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3f:	01 d0                	add    %edx,%eax
  802c41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	8b 50 0c             	mov    0xc(%eax),%edx
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	8b 40 08             	mov    0x8(%eax),%eax
  802c50:	01 d0                	add    %edx,%eax
  802c52:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c55:	8b 45 08             	mov    0x8(%ebp),%eax
  802c58:	8b 40 08             	mov    0x8(%eax),%eax
  802c5b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c5e:	74 7a                	je     802cda <insert_sorted_with_merge_freeList+0x3b4>
  802c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c63:	8b 40 08             	mov    0x8(%eax),%eax
  802c66:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c69:	74 6f                	je     802cda <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802c6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6f:	74 06                	je     802c77 <insert_sorted_with_merge_freeList+0x351>
  802c71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c75:	75 17                	jne    802c8e <insert_sorted_with_merge_freeList+0x368>
  802c77:	83 ec 04             	sub    $0x4,%esp
  802c7a:	68 10 3c 80 00       	push   $0x803c10
  802c7f:	68 43 01 00 00       	push   $0x143
  802c84:	68 b3 3b 80 00       	push   $0x803bb3
  802c89:	e8 02 d6 ff ff       	call   800290 <_panic>
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 50 04             	mov    0x4(%eax),%edx
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	89 50 04             	mov    %edx,0x4(%eax)
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ca0:	89 10                	mov    %edx,(%eax)
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	74 0d                	je     802cb9 <insert_sorted_with_merge_freeList+0x393>
  802cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802caf:	8b 40 04             	mov    0x4(%eax),%eax
  802cb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb5:	89 10                	mov    %edx,(%eax)
  802cb7:	eb 08                	jmp    802cc1 <insert_sorted_with_merge_freeList+0x39b>
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	a3 38 41 80 00       	mov    %eax,0x804138
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc7:	89 50 04             	mov    %edx,0x4(%eax)
  802cca:	a1 44 41 80 00       	mov    0x804144,%eax
  802ccf:	40                   	inc    %eax
  802cd0:	a3 44 41 80 00       	mov    %eax,0x804144
  802cd5:	e9 14 03 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	8b 40 08             	mov    0x8(%eax),%eax
  802ce0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ce3:	0f 85 a0 01 00 00    	jne    802e89 <insert_sorted_with_merge_freeList+0x563>
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 40 08             	mov    0x8(%eax),%eax
  802cef:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cf2:	0f 85 91 01 00 00    	jne    802e89 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802cf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfb:	8b 50 0c             	mov    0xc(%eax),%edx
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d07:	8b 40 0c             	mov    0xc(%eax),%eax
  802d0a:	01 c8                	add    %ecx,%eax
  802d0c:	01 c2                	add    %eax,%edx
  802d0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d11:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d14:	8b 45 08             	mov    0x8(%ebp),%eax
  802d17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d40:	75 17                	jne    802d59 <insert_sorted_with_merge_freeList+0x433>
  802d42:	83 ec 04             	sub    $0x4,%esp
  802d45:	68 90 3b 80 00       	push   $0x803b90
  802d4a:	68 4d 01 00 00       	push   $0x14d
  802d4f:	68 b3 3b 80 00       	push   $0x803bb3
  802d54:	e8 37 d5 ff ff       	call   800290 <_panic>
  802d59:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	89 10                	mov    %edx,(%eax)
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	8b 00                	mov    (%eax),%eax
  802d69:	85 c0                	test   %eax,%eax
  802d6b:	74 0d                	je     802d7a <insert_sorted_with_merge_freeList+0x454>
  802d6d:	a1 48 41 80 00       	mov    0x804148,%eax
  802d72:	8b 55 08             	mov    0x8(%ebp),%edx
  802d75:	89 50 04             	mov    %edx,0x4(%eax)
  802d78:	eb 08                	jmp    802d82 <insert_sorted_with_merge_freeList+0x45c>
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	a3 48 41 80 00       	mov    %eax,0x804148
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d94:	a1 54 41 80 00       	mov    0x804154,%eax
  802d99:	40                   	inc    %eax
  802d9a:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802d9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da3:	75 17                	jne    802dbc <insert_sorted_with_merge_freeList+0x496>
  802da5:	83 ec 04             	sub    $0x4,%esp
  802da8:	68 ef 3b 80 00       	push   $0x803bef
  802dad:	68 4e 01 00 00       	push   $0x14e
  802db2:	68 b3 3b 80 00       	push   $0x803bb3
  802db7:	e8 d4 d4 ff ff       	call   800290 <_panic>
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	8b 00                	mov    (%eax),%eax
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	74 10                	je     802dd5 <insert_sorted_with_merge_freeList+0x4af>
  802dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc8:	8b 00                	mov    (%eax),%eax
  802dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dcd:	8b 52 04             	mov    0x4(%edx),%edx
  802dd0:	89 50 04             	mov    %edx,0x4(%eax)
  802dd3:	eb 0b                	jmp    802de0 <insert_sorted_with_merge_freeList+0x4ba>
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	8b 40 04             	mov    0x4(%eax),%eax
  802ddb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802de0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de3:	8b 40 04             	mov    0x4(%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	74 0f                	je     802df9 <insert_sorted_with_merge_freeList+0x4d3>
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 40 04             	mov    0x4(%eax),%eax
  802df0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df3:	8b 12                	mov    (%edx),%edx
  802df5:	89 10                	mov    %edx,(%eax)
  802df7:	eb 0a                	jmp    802e03 <insert_sorted_with_merge_freeList+0x4dd>
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	a3 38 41 80 00       	mov    %eax,0x804138
  802e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e16:	a1 44 41 80 00       	mov    0x804144,%eax
  802e1b:	48                   	dec    %eax
  802e1c:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e25:	75 17                	jne    802e3e <insert_sorted_with_merge_freeList+0x518>
  802e27:	83 ec 04             	sub    $0x4,%esp
  802e2a:	68 90 3b 80 00       	push   $0x803b90
  802e2f:	68 4f 01 00 00       	push   $0x14f
  802e34:	68 b3 3b 80 00       	push   $0x803bb3
  802e39:	e8 52 d4 ff ff       	call   800290 <_panic>
  802e3e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e47:	89 10                	mov    %edx,(%eax)
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 00                	mov    (%eax),%eax
  802e4e:	85 c0                	test   %eax,%eax
  802e50:	74 0d                	je     802e5f <insert_sorted_with_merge_freeList+0x539>
  802e52:	a1 48 41 80 00       	mov    0x804148,%eax
  802e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e5a:	89 50 04             	mov    %edx,0x4(%eax)
  802e5d:	eb 08                	jmp    802e67 <insert_sorted_with_merge_freeList+0x541>
  802e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e62:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e79:	a1 54 41 80 00       	mov    0x804154,%eax
  802e7e:	40                   	inc    %eax
  802e7f:	a3 54 41 80 00       	mov    %eax,0x804154
  802e84:	e9 65 01 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802e89:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8c:	8b 40 08             	mov    0x8(%eax),%eax
  802e8f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e92:	0f 85 9f 00 00 00    	jne    802f37 <insert_sorted_with_merge_freeList+0x611>
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 40 08             	mov    0x8(%eax),%eax
  802e9e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ea1:	0f 84 90 00 00 00    	je     802f37 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802ea7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eaa:	8b 50 0c             	mov    0xc(%eax),%edx
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb3:	01 c2                	add    %eax,%edx
  802eb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb8:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ecf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed3:	75 17                	jne    802eec <insert_sorted_with_merge_freeList+0x5c6>
  802ed5:	83 ec 04             	sub    $0x4,%esp
  802ed8:	68 90 3b 80 00       	push   $0x803b90
  802edd:	68 58 01 00 00       	push   $0x158
  802ee2:	68 b3 3b 80 00       	push   $0x803bb3
  802ee7:	e8 a4 d3 ff ff       	call   800290 <_panic>
  802eec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	89 10                	mov    %edx,(%eax)
  802ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  802efa:	8b 00                	mov    (%eax),%eax
  802efc:	85 c0                	test   %eax,%eax
  802efe:	74 0d                	je     802f0d <insert_sorted_with_merge_freeList+0x5e7>
  802f00:	a1 48 41 80 00       	mov    0x804148,%eax
  802f05:	8b 55 08             	mov    0x8(%ebp),%edx
  802f08:	89 50 04             	mov    %edx,0x4(%eax)
  802f0b:	eb 08                	jmp    802f15 <insert_sorted_with_merge_freeList+0x5ef>
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	a3 48 41 80 00       	mov    %eax,0x804148
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f27:	a1 54 41 80 00       	mov    0x804154,%eax
  802f2c:	40                   	inc    %eax
  802f2d:	a3 54 41 80 00       	mov    %eax,0x804154
  802f32:	e9 b7 00 00 00       	jmp    802fee <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f37:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3a:	8b 40 08             	mov    0x8(%eax),%eax
  802f3d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f40:	0f 84 e2 00 00 00    	je     803028 <insert_sorted_with_merge_freeList+0x702>
  802f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f49:	8b 40 08             	mov    0x8(%eax),%eax
  802f4c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f4f:	0f 85 d3 00 00 00    	jne    803028 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f55:	8b 45 08             	mov    0x8(%ebp),%eax
  802f58:	8b 50 08             	mov    0x8(%eax),%edx
  802f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5e:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f64:	8b 50 0c             	mov    0xc(%eax),%edx
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f6d:	01 c2                	add    %eax,%edx
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f75:	8b 45 08             	mov    0x8(%ebp),%eax
  802f78:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f89:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f8d:	75 17                	jne    802fa6 <insert_sorted_with_merge_freeList+0x680>
  802f8f:	83 ec 04             	sub    $0x4,%esp
  802f92:	68 90 3b 80 00       	push   $0x803b90
  802f97:	68 61 01 00 00       	push   $0x161
  802f9c:	68 b3 3b 80 00       	push   $0x803bb3
  802fa1:	e8 ea d2 ff ff       	call   800290 <_panic>
  802fa6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fac:	8b 45 08             	mov    0x8(%ebp),%eax
  802faf:	89 10                	mov    %edx,(%eax)
  802fb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	74 0d                	je     802fc7 <insert_sorted_with_merge_freeList+0x6a1>
  802fba:	a1 48 41 80 00       	mov    0x804148,%eax
  802fbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc2:	89 50 04             	mov    %edx,0x4(%eax)
  802fc5:	eb 08                	jmp    802fcf <insert_sorted_with_merge_freeList+0x6a9>
  802fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd2:	a3 48 41 80 00       	mov    %eax,0x804148
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe1:	a1 54 41 80 00       	mov    0x804154,%eax
  802fe6:	40                   	inc    %eax
  802fe7:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802fec:	eb 3a                	jmp    803028 <insert_sorted_with_merge_freeList+0x702>
  802fee:	eb 38                	jmp    803028 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802ff0:	a1 40 41 80 00       	mov    0x804140,%eax
  802ff5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffc:	74 07                	je     803005 <insert_sorted_with_merge_freeList+0x6df>
  802ffe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803001:	8b 00                	mov    (%eax),%eax
  803003:	eb 05                	jmp    80300a <insert_sorted_with_merge_freeList+0x6e4>
  803005:	b8 00 00 00 00       	mov    $0x0,%eax
  80300a:	a3 40 41 80 00       	mov    %eax,0x804140
  80300f:	a1 40 41 80 00       	mov    0x804140,%eax
  803014:	85 c0                	test   %eax,%eax
  803016:	0f 85 fa fb ff ff    	jne    802c16 <insert_sorted_with_merge_freeList+0x2f0>
  80301c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803020:	0f 85 f0 fb ff ff    	jne    802c16 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803026:	eb 01                	jmp    803029 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803028:	90                   	nop
							}

						}
		          }
		}
}
  803029:	90                   	nop
  80302a:	c9                   	leave  
  80302b:	c3                   	ret    

0080302c <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80302c:	55                   	push   %ebp
  80302d:	89 e5                	mov    %esp,%ebp
  80302f:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803032:	8b 55 08             	mov    0x8(%ebp),%edx
  803035:	89 d0                	mov    %edx,%eax
  803037:	c1 e0 02             	shl    $0x2,%eax
  80303a:	01 d0                	add    %edx,%eax
  80303c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803043:	01 d0                	add    %edx,%eax
  803045:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80304c:	01 d0                	add    %edx,%eax
  80304e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803055:	01 d0                	add    %edx,%eax
  803057:	c1 e0 04             	shl    $0x4,%eax
  80305a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80305d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803064:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803067:	83 ec 0c             	sub    $0xc,%esp
  80306a:	50                   	push   %eax
  80306b:	e8 9c eb ff ff       	call   801c0c <sys_get_virtual_time>
  803070:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803073:	eb 41                	jmp    8030b6 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803075:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803078:	83 ec 0c             	sub    $0xc,%esp
  80307b:	50                   	push   %eax
  80307c:	e8 8b eb ff ff       	call   801c0c <sys_get_virtual_time>
  803081:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803084:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803087:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308a:	29 c2                	sub    %eax,%edx
  80308c:	89 d0                	mov    %edx,%eax
  80308e:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803091:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803094:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803097:	89 d1                	mov    %edx,%ecx
  803099:	29 c1                	sub    %eax,%ecx
  80309b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80309e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a1:	39 c2                	cmp    %eax,%edx
  8030a3:	0f 97 c0             	seta   %al
  8030a6:	0f b6 c0             	movzbl %al,%eax
  8030a9:	29 c1                	sub    %eax,%ecx
  8030ab:	89 c8                	mov    %ecx,%eax
  8030ad:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030bc:	72 b7                	jb     803075 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030be:	90                   	nop
  8030bf:	c9                   	leave  
  8030c0:	c3                   	ret    

008030c1 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030c1:	55                   	push   %ebp
  8030c2:	89 e5                	mov    %esp,%ebp
  8030c4:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030ce:	eb 03                	jmp    8030d3 <busy_wait+0x12>
  8030d0:	ff 45 fc             	incl   -0x4(%ebp)
  8030d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030d6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030d9:	72 f5                	jb     8030d0 <busy_wait+0xf>
	return i;
  8030db:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030de:	c9                   	leave  
  8030df:	c3                   	ret    

008030e0 <__udivdi3>:
  8030e0:	55                   	push   %ebp
  8030e1:	57                   	push   %edi
  8030e2:	56                   	push   %esi
  8030e3:	53                   	push   %ebx
  8030e4:	83 ec 1c             	sub    $0x1c,%esp
  8030e7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030eb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030f7:	89 ca                	mov    %ecx,%edx
  8030f9:	89 f8                	mov    %edi,%eax
  8030fb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030ff:	85 f6                	test   %esi,%esi
  803101:	75 2d                	jne    803130 <__udivdi3+0x50>
  803103:	39 cf                	cmp    %ecx,%edi
  803105:	77 65                	ja     80316c <__udivdi3+0x8c>
  803107:	89 fd                	mov    %edi,%ebp
  803109:	85 ff                	test   %edi,%edi
  80310b:	75 0b                	jne    803118 <__udivdi3+0x38>
  80310d:	b8 01 00 00 00       	mov    $0x1,%eax
  803112:	31 d2                	xor    %edx,%edx
  803114:	f7 f7                	div    %edi
  803116:	89 c5                	mov    %eax,%ebp
  803118:	31 d2                	xor    %edx,%edx
  80311a:	89 c8                	mov    %ecx,%eax
  80311c:	f7 f5                	div    %ebp
  80311e:	89 c1                	mov    %eax,%ecx
  803120:	89 d8                	mov    %ebx,%eax
  803122:	f7 f5                	div    %ebp
  803124:	89 cf                	mov    %ecx,%edi
  803126:	89 fa                	mov    %edi,%edx
  803128:	83 c4 1c             	add    $0x1c,%esp
  80312b:	5b                   	pop    %ebx
  80312c:	5e                   	pop    %esi
  80312d:	5f                   	pop    %edi
  80312e:	5d                   	pop    %ebp
  80312f:	c3                   	ret    
  803130:	39 ce                	cmp    %ecx,%esi
  803132:	77 28                	ja     80315c <__udivdi3+0x7c>
  803134:	0f bd fe             	bsr    %esi,%edi
  803137:	83 f7 1f             	xor    $0x1f,%edi
  80313a:	75 40                	jne    80317c <__udivdi3+0x9c>
  80313c:	39 ce                	cmp    %ecx,%esi
  80313e:	72 0a                	jb     80314a <__udivdi3+0x6a>
  803140:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803144:	0f 87 9e 00 00 00    	ja     8031e8 <__udivdi3+0x108>
  80314a:	b8 01 00 00 00       	mov    $0x1,%eax
  80314f:	89 fa                	mov    %edi,%edx
  803151:	83 c4 1c             	add    $0x1c,%esp
  803154:	5b                   	pop    %ebx
  803155:	5e                   	pop    %esi
  803156:	5f                   	pop    %edi
  803157:	5d                   	pop    %ebp
  803158:	c3                   	ret    
  803159:	8d 76 00             	lea    0x0(%esi),%esi
  80315c:	31 ff                	xor    %edi,%edi
  80315e:	31 c0                	xor    %eax,%eax
  803160:	89 fa                	mov    %edi,%edx
  803162:	83 c4 1c             	add    $0x1c,%esp
  803165:	5b                   	pop    %ebx
  803166:	5e                   	pop    %esi
  803167:	5f                   	pop    %edi
  803168:	5d                   	pop    %ebp
  803169:	c3                   	ret    
  80316a:	66 90                	xchg   %ax,%ax
  80316c:	89 d8                	mov    %ebx,%eax
  80316e:	f7 f7                	div    %edi
  803170:	31 ff                	xor    %edi,%edi
  803172:	89 fa                	mov    %edi,%edx
  803174:	83 c4 1c             	add    $0x1c,%esp
  803177:	5b                   	pop    %ebx
  803178:	5e                   	pop    %esi
  803179:	5f                   	pop    %edi
  80317a:	5d                   	pop    %ebp
  80317b:	c3                   	ret    
  80317c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803181:	89 eb                	mov    %ebp,%ebx
  803183:	29 fb                	sub    %edi,%ebx
  803185:	89 f9                	mov    %edi,%ecx
  803187:	d3 e6                	shl    %cl,%esi
  803189:	89 c5                	mov    %eax,%ebp
  80318b:	88 d9                	mov    %bl,%cl
  80318d:	d3 ed                	shr    %cl,%ebp
  80318f:	89 e9                	mov    %ebp,%ecx
  803191:	09 f1                	or     %esi,%ecx
  803193:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803197:	89 f9                	mov    %edi,%ecx
  803199:	d3 e0                	shl    %cl,%eax
  80319b:	89 c5                	mov    %eax,%ebp
  80319d:	89 d6                	mov    %edx,%esi
  80319f:	88 d9                	mov    %bl,%cl
  8031a1:	d3 ee                	shr    %cl,%esi
  8031a3:	89 f9                	mov    %edi,%ecx
  8031a5:	d3 e2                	shl    %cl,%edx
  8031a7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ab:	88 d9                	mov    %bl,%cl
  8031ad:	d3 e8                	shr    %cl,%eax
  8031af:	09 c2                	or     %eax,%edx
  8031b1:	89 d0                	mov    %edx,%eax
  8031b3:	89 f2                	mov    %esi,%edx
  8031b5:	f7 74 24 0c          	divl   0xc(%esp)
  8031b9:	89 d6                	mov    %edx,%esi
  8031bb:	89 c3                	mov    %eax,%ebx
  8031bd:	f7 e5                	mul    %ebp
  8031bf:	39 d6                	cmp    %edx,%esi
  8031c1:	72 19                	jb     8031dc <__udivdi3+0xfc>
  8031c3:	74 0b                	je     8031d0 <__udivdi3+0xf0>
  8031c5:	89 d8                	mov    %ebx,%eax
  8031c7:	31 ff                	xor    %edi,%edi
  8031c9:	e9 58 ff ff ff       	jmp    803126 <__udivdi3+0x46>
  8031ce:	66 90                	xchg   %ax,%ax
  8031d0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031d4:	89 f9                	mov    %edi,%ecx
  8031d6:	d3 e2                	shl    %cl,%edx
  8031d8:	39 c2                	cmp    %eax,%edx
  8031da:	73 e9                	jae    8031c5 <__udivdi3+0xe5>
  8031dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031df:	31 ff                	xor    %edi,%edi
  8031e1:	e9 40 ff ff ff       	jmp    803126 <__udivdi3+0x46>
  8031e6:	66 90                	xchg   %ax,%ax
  8031e8:	31 c0                	xor    %eax,%eax
  8031ea:	e9 37 ff ff ff       	jmp    803126 <__udivdi3+0x46>
  8031ef:	90                   	nop

008031f0 <__umoddi3>:
  8031f0:	55                   	push   %ebp
  8031f1:	57                   	push   %edi
  8031f2:	56                   	push   %esi
  8031f3:	53                   	push   %ebx
  8031f4:	83 ec 1c             	sub    $0x1c,%esp
  8031f7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031fb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803203:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803207:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80320b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80320f:	89 f3                	mov    %esi,%ebx
  803211:	89 fa                	mov    %edi,%edx
  803213:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803217:	89 34 24             	mov    %esi,(%esp)
  80321a:	85 c0                	test   %eax,%eax
  80321c:	75 1a                	jne    803238 <__umoddi3+0x48>
  80321e:	39 f7                	cmp    %esi,%edi
  803220:	0f 86 a2 00 00 00    	jbe    8032c8 <__umoddi3+0xd8>
  803226:	89 c8                	mov    %ecx,%eax
  803228:	89 f2                	mov    %esi,%edx
  80322a:	f7 f7                	div    %edi
  80322c:	89 d0                	mov    %edx,%eax
  80322e:	31 d2                	xor    %edx,%edx
  803230:	83 c4 1c             	add    $0x1c,%esp
  803233:	5b                   	pop    %ebx
  803234:	5e                   	pop    %esi
  803235:	5f                   	pop    %edi
  803236:	5d                   	pop    %ebp
  803237:	c3                   	ret    
  803238:	39 f0                	cmp    %esi,%eax
  80323a:	0f 87 ac 00 00 00    	ja     8032ec <__umoddi3+0xfc>
  803240:	0f bd e8             	bsr    %eax,%ebp
  803243:	83 f5 1f             	xor    $0x1f,%ebp
  803246:	0f 84 ac 00 00 00    	je     8032f8 <__umoddi3+0x108>
  80324c:	bf 20 00 00 00       	mov    $0x20,%edi
  803251:	29 ef                	sub    %ebp,%edi
  803253:	89 fe                	mov    %edi,%esi
  803255:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803259:	89 e9                	mov    %ebp,%ecx
  80325b:	d3 e0                	shl    %cl,%eax
  80325d:	89 d7                	mov    %edx,%edi
  80325f:	89 f1                	mov    %esi,%ecx
  803261:	d3 ef                	shr    %cl,%edi
  803263:	09 c7                	or     %eax,%edi
  803265:	89 e9                	mov    %ebp,%ecx
  803267:	d3 e2                	shl    %cl,%edx
  803269:	89 14 24             	mov    %edx,(%esp)
  80326c:	89 d8                	mov    %ebx,%eax
  80326e:	d3 e0                	shl    %cl,%eax
  803270:	89 c2                	mov    %eax,%edx
  803272:	8b 44 24 08          	mov    0x8(%esp),%eax
  803276:	d3 e0                	shl    %cl,%eax
  803278:	89 44 24 04          	mov    %eax,0x4(%esp)
  80327c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803280:	89 f1                	mov    %esi,%ecx
  803282:	d3 e8                	shr    %cl,%eax
  803284:	09 d0                	or     %edx,%eax
  803286:	d3 eb                	shr    %cl,%ebx
  803288:	89 da                	mov    %ebx,%edx
  80328a:	f7 f7                	div    %edi
  80328c:	89 d3                	mov    %edx,%ebx
  80328e:	f7 24 24             	mull   (%esp)
  803291:	89 c6                	mov    %eax,%esi
  803293:	89 d1                	mov    %edx,%ecx
  803295:	39 d3                	cmp    %edx,%ebx
  803297:	0f 82 87 00 00 00    	jb     803324 <__umoddi3+0x134>
  80329d:	0f 84 91 00 00 00    	je     803334 <__umoddi3+0x144>
  8032a3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032a7:	29 f2                	sub    %esi,%edx
  8032a9:	19 cb                	sbb    %ecx,%ebx
  8032ab:	89 d8                	mov    %ebx,%eax
  8032ad:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032b1:	d3 e0                	shl    %cl,%eax
  8032b3:	89 e9                	mov    %ebp,%ecx
  8032b5:	d3 ea                	shr    %cl,%edx
  8032b7:	09 d0                	or     %edx,%eax
  8032b9:	89 e9                	mov    %ebp,%ecx
  8032bb:	d3 eb                	shr    %cl,%ebx
  8032bd:	89 da                	mov    %ebx,%edx
  8032bf:	83 c4 1c             	add    $0x1c,%esp
  8032c2:	5b                   	pop    %ebx
  8032c3:	5e                   	pop    %esi
  8032c4:	5f                   	pop    %edi
  8032c5:	5d                   	pop    %ebp
  8032c6:	c3                   	ret    
  8032c7:	90                   	nop
  8032c8:	89 fd                	mov    %edi,%ebp
  8032ca:	85 ff                	test   %edi,%edi
  8032cc:	75 0b                	jne    8032d9 <__umoddi3+0xe9>
  8032ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d3:	31 d2                	xor    %edx,%edx
  8032d5:	f7 f7                	div    %edi
  8032d7:	89 c5                	mov    %eax,%ebp
  8032d9:	89 f0                	mov    %esi,%eax
  8032db:	31 d2                	xor    %edx,%edx
  8032dd:	f7 f5                	div    %ebp
  8032df:	89 c8                	mov    %ecx,%eax
  8032e1:	f7 f5                	div    %ebp
  8032e3:	89 d0                	mov    %edx,%eax
  8032e5:	e9 44 ff ff ff       	jmp    80322e <__umoddi3+0x3e>
  8032ea:	66 90                	xchg   %ax,%ax
  8032ec:	89 c8                	mov    %ecx,%eax
  8032ee:	89 f2                	mov    %esi,%edx
  8032f0:	83 c4 1c             	add    $0x1c,%esp
  8032f3:	5b                   	pop    %ebx
  8032f4:	5e                   	pop    %esi
  8032f5:	5f                   	pop    %edi
  8032f6:	5d                   	pop    %ebp
  8032f7:	c3                   	ret    
  8032f8:	3b 04 24             	cmp    (%esp),%eax
  8032fb:	72 06                	jb     803303 <__umoddi3+0x113>
  8032fd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803301:	77 0f                	ja     803312 <__umoddi3+0x122>
  803303:	89 f2                	mov    %esi,%edx
  803305:	29 f9                	sub    %edi,%ecx
  803307:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80330b:	89 14 24             	mov    %edx,(%esp)
  80330e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803312:	8b 44 24 04          	mov    0x4(%esp),%eax
  803316:	8b 14 24             	mov    (%esp),%edx
  803319:	83 c4 1c             	add    $0x1c,%esp
  80331c:	5b                   	pop    %ebx
  80331d:	5e                   	pop    %esi
  80331e:	5f                   	pop    %edi
  80331f:	5d                   	pop    %ebp
  803320:	c3                   	ret    
  803321:	8d 76 00             	lea    0x0(%esi),%esi
  803324:	2b 04 24             	sub    (%esp),%eax
  803327:	19 fa                	sbb    %edi,%edx
  803329:	89 d1                	mov    %edx,%ecx
  80332b:	89 c6                	mov    %eax,%esi
  80332d:	e9 71 ff ff ff       	jmp    8032a3 <__umoddi3+0xb3>
  803332:	66 90                	xchg   %ax,%ax
  803334:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803338:	72 ea                	jb     803324 <__umoddi3+0x134>
  80333a:	89 d9                	mov    %ebx,%ecx
  80333c:	e9 62 ff ff ff       	jmp    8032a3 <__umoddi3+0xb3>

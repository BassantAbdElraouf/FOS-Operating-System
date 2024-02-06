
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 44 01 00 00       	call   80017a <libmain>
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
  80008c:	68 80 33 80 00       	push   $0x803380
  800091:	6a 12                	push   $0x12
  800093:	68 9c 33 80 00       	push   $0x80339c
  800098:	e8 19 02 00 00       	call   8002b6 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 f2 13 00 00       	call   801499 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  8000aa:	e8 50 1b 00 00       	call   801bff <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 b9 33 80 00       	push   $0x8033b9
  8000b7:	50                   	push   %eax
  8000b8:	e8 02 16 00 00       	call   8016bf <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 bc 33 80 00       	push   $0x8033bc
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 4c 1c 00 00       	call   801d24 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 e4 33 80 00       	push   $0x8033e4
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 5d 2f 00 00       	call   803052 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 40 1c 00 00       	call   801d3e <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 fe 17 00 00       	call   801906 <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 90 16 00 00       	call   8017a6 <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 04 34 80 00       	push   $0x803404
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 d1 17 00 00       	call   801906 <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 1c 34 80 00       	push   $0x80341c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 9c 33 80 00       	push   $0x80339c
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 bc 34 80 00       	push   $0x8034bc
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 e0 34 80 00       	push   $0x8034e0
  80016f:	e8 f6 03 00 00       	call   80056a <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp

	return;
  800177:	90                   	nop
}
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800180:	e8 61 1a 00 00       	call   801be6 <sys_getenvindex>
  800185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 03             	shl    $0x3,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	01 c0                	add    %eax,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019d:	01 d0                	add    %edx,%eax
  80019f:	c1 e0 04             	shl    $0x4,%eax
  8001a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001b7:	84 c0                	test   %al,%al
  8001b9:	74 0f                	je     8001ca <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	05 5c 05 00 00       	add    $0x55c,%eax
  8001c5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ce:	7e 0a                	jle    8001da <libmain+0x60>
		binaryname = argv[0];
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 50 fe ff ff       	call   800038 <_main>
  8001e8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001eb:	e8 03 18 00 00       	call   8019f3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 44 35 80 00       	push   $0x803544
  8001f8:	e8 6d 03 00 00       	call   80056a <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800200:	a1 20 40 80 00       	mov    0x804020,%eax
  800205:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 6c 35 80 00       	push   $0x80356c
  800220:	e8 45 03 00 00       	call   80056a <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800228:	a1 20 40 80 00       	mov    0x804020,%eax
  80022d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800249:	51                   	push   %ecx
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	68 94 35 80 00       	push   $0x803594
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 ec 35 80 00       	push   $0x8035ec
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 44 35 80 00       	push   $0x803544
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 83 17 00 00       	call   801a0d <sys_enable_interrupt>

	// exit gracefully
	exit();
  80028a:	e8 19 00 00 00       	call   8002a8 <exit>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 00                	push   $0x0
  80029d:	e8 10 19 00 00       	call   801bb2 <sys_destroy_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <exit>:

void
exit(void)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ae:	e8 65 19 00 00       	call   801c18 <sys_exit_env>
}
  8002b3:	90                   	nop
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bf:	83 c0 04             	add    $0x4,%eax
  8002c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	74 16                	je     8002e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ce:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	50                   	push   %eax
  8002d7:	68 00 36 80 00       	push   $0x803600
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 40 80 00       	mov    0x804000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 05 36 80 00       	push   $0x803605
  8002f5:	e8 70 02 00 00       	call   80056a <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 f3 01 00 00       	call   8004ff <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	6a 00                	push   $0x0
  800314:	68 21 36 80 00       	push   $0x803621
  800319:	e8 e1 01 00 00       	call   8004ff <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800321:	e8 82 ff ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  800326:	eb fe                	jmp    800326 <_panic+0x70>

00800328 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032e:	a1 20 40 80 00       	mov    0x804020,%eax
  800333:	8b 50 74             	mov    0x74(%eax),%edx
  800336:	8b 45 0c             	mov    0xc(%ebp),%eax
  800339:	39 c2                	cmp    %eax,%edx
  80033b:	74 14                	je     800351 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 24 36 80 00       	push   $0x803624
  800345:	6a 26                	push   $0x26
  800347:	68 70 36 80 00       	push   $0x803670
  80034c:	e8 65 ff ff ff       	call   8002b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035f:	e9 c2 00 00 00       	jmp    800426 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	01 d0                	add    %edx,%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	85 c0                	test   %eax,%eax
  800377:	75 08                	jne    800381 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800379:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80037c:	e9 a2 00 00 00       	jmp    800423 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800388:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038f:	eb 69                	jmp    8003fa <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800391:	a1 20 40 80 00       	mov    0x804020,%eax
  800396:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80039c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	01 c0                	add    %eax,%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	c1 e0 03             	shl    $0x3,%eax
  8003a8:	01 c8                	add    %ecx,%eax
  8003aa:	8a 40 04             	mov    0x4(%eax),%al
  8003ad:	84 c0                	test   %al,%al
  8003af:	75 46                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003bf:	89 d0                	mov    %edx,%eax
  8003c1:	01 c0                	add    %eax,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	c1 e0 03             	shl    $0x3,%eax
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ea:	39 c2                	cmp    %eax,%edx
  8003ec:	75 09                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f5:	eb 12                	jmp    800409 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f7:	ff 45 e8             	incl   -0x18(%ebp)
  8003fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ff:	8b 50 74             	mov    0x74(%eax),%edx
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	39 c2                	cmp    %eax,%edx
  800407:	77 88                	ja     800391 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80040d:	75 14                	jne    800423 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 7c 36 80 00       	push   $0x80367c
  800417:	6a 3a                	push   $0x3a
  800419:	68 70 36 80 00       	push   $0x803670
  80041e:	e8 93 fe ff ff       	call   8002b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800423:	ff 45 f0             	incl   -0x10(%ebp)
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042c:	0f 8c 32 ff ff ff    	jl     800364 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800432:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800440:	eb 26                	jmp    800468 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80044d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800450:	89 d0                	mov    %edx,%eax
  800452:	01 c0                	add    %eax,%eax
  800454:	01 d0                	add    %edx,%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	01 c8                	add    %ecx,%eax
  80045b:	8a 40 04             	mov    0x4(%eax),%al
  80045e:	3c 01                	cmp    $0x1,%al
  800460:	75 03                	jne    800465 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800462:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	ff 45 e0             	incl   -0x20(%ebp)
  800468:	a1 20 40 80 00       	mov    0x804020,%eax
  80046d:	8b 50 74             	mov    0x74(%eax),%edx
  800470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800473:	39 c2                	cmp    %eax,%edx
  800475:	77 cb                	ja     800442 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047d:	74 14                	je     800493 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 d0 36 80 00       	push   $0x8036d0
  800487:	6a 44                	push   $0x44
  800489:	68 70 36 80 00       	push   $0x803670
  80048e:	e8 23 fe ff ff       	call   8002b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	89 0a                	mov    %ecx,(%edx)
  8004a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ac:	88 d1                	mov    %dl,%cl
  8004ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bf:	75 2c                	jne    8004ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c1:	a0 24 40 80 00       	mov    0x804024,%al
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	8b 12                	mov    (%edx),%edx
  8004ce:	89 d1                	mov    %edx,%ecx
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	83 c2 08             	add    $0x8,%edx
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	50                   	push   %eax
  8004da:	51                   	push   %ecx
  8004db:	52                   	push   %edx
  8004dc:	e8 64 13 00 00       	call   801845 <sys_cputs>
  8004e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 40 04             	mov    0x4(%eax),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	50                   	push   %eax
  800529:	68 96 04 80 00       	push   $0x800496
  80052e:	e8 11 02 00 00       	call   800744 <vprintfmt>
  800533:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800536:	a0 24 40 80 00       	mov    0x804024,%al
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	50                   	push   %eax
  800548:	52                   	push   %edx
  800549:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054f:	83 c0 08             	add    $0x8,%eax
  800552:	50                   	push   %eax
  800553:	e8 ed 12 00 00       	call   801845 <sys_cputs>
  800558:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800562:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <cprintf>:

int cprintf(const char *fmt, ...) {
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800570:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 73 ff ff ff       	call   8004ff <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059d:	e8 51 14 00 00       	call   8019f3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	e8 48 ff ff ff       	call   8004ff <vcprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bd:	e8 4b 14 00 00       	call   801a0d <sys_enable_interrupt>
	return cnt;
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 14             	sub    $0x14,%esp
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005da:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e5:	77 55                	ja     80063c <printnum+0x75>
  8005e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ea:	72 05                	jb     8005f1 <printnum+0x2a>
  8005ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ef:	77 4b                	ja     80063c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	ff 75 f0             	pushl  -0x10(%ebp)
  800607:	e8 fc 2a 00 00       	call   803108 <__udivdi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 20             	pushl  0x20(%ebp)
  800615:	53                   	push   %ebx
  800616:	ff 75 18             	pushl  0x18(%ebp)
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 ff ff ff       	call   8005c7 <printnum>
  800626:	83 c4 20             	add    $0x20,%esp
  800629:	eb 1a                	jmp    800645 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063c:	ff 4d 1c             	decl   0x1c(%ebp)
  80063f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800643:	7f e6                	jg     80062b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800645:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800653:	53                   	push   %ebx
  800654:	51                   	push   %ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	e8 bc 2b 00 00       	call   803218 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 34 39 80 00       	add    $0x803934,%eax
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f be c0             	movsbl %al,%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	50                   	push   %eax
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800685:	7e 1c                	jle    8006a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 08             	lea    0x8(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 08             	sub    $0x8,%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	eb 40                	jmp    8006e3 <getuint+0x65>
	else if (lflag)
  8006a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a7:	74 1e                	je     8006c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 04             	lea    0x4(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	eb 1c                	jmp    8006e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getint+0x25>
		return va_arg(*ap, long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 38                	jmp    800742 <getint+0x5d>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1a                	je     80072a <getint+0x45>
		return va_arg(*ap, long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	99                   	cltd   
  800728:	eb 18                	jmp    800742 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
  800749:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	eb 17                	jmp    800765 <vprintfmt+0x21>
			if (ch == '\0')
  80074e:	85 db                	test   %ebx,%ebx
  800750:	0f 84 af 03 00 00    	je     800b05 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	83 fb 25             	cmp    $0x25,%ebx
  800776:	75 d6                	jne    80074e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800778:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800783:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80078a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a9:	83 f8 55             	cmp    $0x55,%eax
  8007ac:	0f 87 2b 03 00 00    	ja     800add <vprintfmt+0x399>
  8007b2:	8b 04 85 58 39 80 00 	mov    0x803958(,%eax,4),%eax
  8007b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d7                	jmp    800798 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c5:	eb d1                	jmp    800798 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	01 d0                	add    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	83 e8 30             	sub    $0x30,%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ed:	7e 3e                	jle    80082d <vprintfmt+0xe9>
  8007ef:	83 fb 39             	cmp    $0x39,%ebx
  8007f2:	7f 39                	jg     80082d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d5                	jmp    8007ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800813:	79 83                	jns    800798 <vprintfmt+0x54>
				width = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081c:	e9 77 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800821:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800828:	e9 6b ff ff ff       	jmp    800798 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	0f 89 60 ff ff ff    	jns    800798 <vprintfmt+0x54>
				width = precision, precision = -1;
  800838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800845:	e9 4e ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084d:	e9 46 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			break;
  800872:	e9 89 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800888:	85 db                	test   %ebx,%ebx
  80088a:	79 02                	jns    80088e <vprintfmt+0x14a>
				err = -err;
  80088c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088e:	83 fb 64             	cmp    $0x64,%ebx
  800891:	7f 0b                	jg     80089e <vprintfmt+0x15a>
  800893:	8b 34 9d a0 37 80 00 	mov    0x8037a0(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 45 39 80 00       	push   $0x803945
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 5e 02 00 00       	call   800b0d <printfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b2:	e9 49 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b7:	56                   	push   %esi
  8008b8:	68 4e 39 80 00       	push   $0x80394e
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 45 02 00 00       	call   800b0d <printfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 30 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 30                	mov    (%eax),%esi
  8008e1:	85 f6                	test   %esi,%esi
  8008e3:	75 05                	jne    8008ea <vprintfmt+0x1a6>
				p = "(null)";
  8008e5:	be 51 39 80 00       	mov    $0x803951,%esi
			if (width > 0 && padc != '-')
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7e 6d                	jle    80095d <vprintfmt+0x219>
  8008f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f4:	74 67                	je     80095d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	50                   	push   %eax
  8008fd:	56                   	push   %esi
  8008fe:	e8 0c 03 00 00       	call   800c0f <strnlen>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800909:	eb 16                	jmp    800921 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091e:	ff 4d e4             	decl   -0x1c(%ebp)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800925:	7f e4                	jg     80090b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 34                	jmp    80095d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092d:	74 1c                	je     80094b <vprintfmt+0x207>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x1f5>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 12                	jle    80094b <vprintfmt+0x207>
					putch('?', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 3f                	push   $0x3f
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	eb 0f                	jmp    80095a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 70 01             	lea    0x1(%eax),%esi
  800962:	8a 00                	mov    (%eax),%al
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 24                	je     80098f <vprintfmt+0x24b>
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	78 b8                	js     800929 <vprintfmt+0x1e5>
  800971:	ff 4d e0             	decl   -0x20(%ebp)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 af                	jns    800929 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	eb 13                	jmp    80098f <vprintfmt+0x24b>
				putch(' ', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 20                	push   $0x20
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800993:	7f e7                	jg     80097c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800995:	e9 66 01 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 3c fd ff ff       	call   8006e5 <getint>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	79 23                	jns    8009df <vprintfmt+0x29b>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	6a 2d                	push   $0x2d
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	f7 d8                	neg    %eax
  8009d4:	83 d2 00             	adc    $0x0,%edx
  8009d7:	f7 da                	neg    %edx
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e6:	e9 bc 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 84 fc ff ff       	call   80067e <getuint>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 98 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 58                	push   $0x58
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			break;
  800a3f:	e9 bc 00 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 30                	push   $0x30
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 78                	push   $0x78
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 c0 04             	add    $0x4,%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 e8 04             	sub    $0x4,%eax
  800a73:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a86:	eb 1f                	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 e7 fb ff ff       	call   80067e <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	52                   	push   %edx
  800ab2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 00 fb ff ff       	call   8005c7 <printnum>
  800ac7:	83 c4 20             	add    $0x20,%esp
			break;
  800aca:	eb 34                	jmp    800b00 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	eb 23                	jmp    800b00 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	6a 25                	push   $0x25
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aed:	ff 4d 10             	decl   0x10(%ebp)
  800af0:	eb 03                	jmp    800af5 <vprintfmt+0x3b1>
  800af2:	ff 4d 10             	decl   0x10(%ebp)
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	48                   	dec    %eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	3c 25                	cmp    $0x25,%al
  800afd:	75 f3                	jne    800af2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aff:	90                   	nop
		}
	}
  800b00:	e9 47 fc ff ff       	jmp    80074c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b05:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b13:	8d 45 10             	lea    0x10(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	50                   	push   %eax
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 16 fc ff ff       	call   800744 <vprintfmt>
  800b2e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b31:	90                   	nop
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 40 08             	mov    0x8(%eax),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8b 10                	mov    (%eax),%edx
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 40 04             	mov    0x4(%eax),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	73 12                	jae    800b67 <sprintputch+0x33>
		*b->buf++ = ch;
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	89 0a                	mov    %ecx,(%edx)
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	88 10                	mov    %dl,(%eax)
}
  800b67:	90                   	nop
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8f:	74 06                	je     800b97 <vsnprintf+0x2d>
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	7f 07                	jg     800b9e <vsnprintf+0x34>
		return -E_INVAL;
  800b97:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9c:	eb 20                	jmp    800bbe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9e:	ff 75 14             	pushl  0x14(%ebp)
  800ba1:	ff 75 10             	pushl  0x10(%ebp)
  800ba4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba7:	50                   	push   %eax
  800ba8:	68 34 0b 80 00       	push   $0x800b34
  800bad:	e8 92 fb ff ff       	call   800744 <vprintfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc9:	83 c0 04             	add    $0x4,%eax
  800bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 89 ff ff ff       	call   800b6a <vsnprintf>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf9:	eb 06                	jmp    800c01 <strlen+0x15>
		n++;
  800bfb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 f1                	jne    800bfb <strlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 09                	jmp    800c27 <strnlen+0x18>
		n++;
  800c1e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c21:	ff 45 08             	incl   0x8(%ebp)
  800c24:	ff 4d 0c             	decl   0xc(%ebp)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 09                	je     800c36 <strnlen+0x27>
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	84 c0                	test   %al,%al
  800c34:	75 e8                	jne    800c1e <strnlen+0xf>
		n++;
	return n;
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c47:	90                   	nop
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8d 50 01             	lea    0x1(%eax),%edx
  800c4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 e4                	jne    800c48 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 1f                	jmp    800c9d <strncpy+0x34>
		*dst++ = *src;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	74 03                	je     800c9a <strncpy+0x31>
			src++;
  800c97:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9a:	ff 45 fc             	incl   -0x4(%ebp)
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca3:	72 d9                	jb     800c7e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 30                	je     800cec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbc:	eb 16                	jmp    800cd4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd4:	ff 4d 10             	decl   0x10(%ebp)
  800cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdb:	74 09                	je     800ce6 <strlcpy+0x3c>
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 d8                	jne    800cbe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf2:	29 c2                	sub    %eax,%edx
  800cf4:	89 d0                	mov    %edx,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfb:	eb 06                	jmp    800d03 <strcmp+0xb>
		p++, q++;
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 0e                	je     800d1a <strcmp+0x22>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 10                	mov    (%eax),%dl
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	38 c2                	cmp    %al,%dl
  800d18:	74 e3                	je     800cfd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f b6 d0             	movzbl %al,%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 c0             	movzbl %al,%eax
  800d2a:	29 c2                	sub    %eax,%edx
  800d2c:	89 d0                	mov    %edx,%eax
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d33:	eb 09                	jmp    800d3e <strncmp+0xe>
		n--, p++, q++;
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 17                	je     800d5b <strncmp+0x2b>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	74 0e                	je     800d5b <strncmp+0x2b>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 10                	mov    (%eax),%dl
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	38 c2                	cmp    %al,%dl
  800d59:	74 da                	je     800d35 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5f:	75 07                	jne    800d68 <strncmp+0x38>
		return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	eb 14                	jmp    800d7c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d0             	movzbl %al,%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8a:	eb 12                	jmp    800d9e <strchr+0x20>
		if (*s == c)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d94:	75 05                	jne    800d9b <strchr+0x1d>
			return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	eb 11                	jmp    800dac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 e5                	jne    800d8c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dba:	eb 0d                	jmp    800dc9 <strfind+0x1b>
		if (*s == c)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc4:	74 0e                	je     800dd4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	75 ea                	jne    800dbc <strfind+0xe>
  800dd2:	eb 01                	jmp    800dd5 <strfind+0x27>
		if (*s == c)
			break;
  800dd4:	90                   	nop
	return (char *) s;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dec:	eb 0e                	jmp    800dfc <memset+0x22>
		*p++ = c;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfc:	ff 4d f8             	decl   -0x8(%ebp)
  800dff:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e03:	79 e9                	jns    800dee <memset+0x14>
		*p++ = c;

	return v;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1c:	eb 16                	jmp    800e34 <memcpy+0x2a>
		*d++ = *s++;
  800e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e21:	8d 50 01             	lea    0x1(%eax),%edx
  800e24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e30:	8a 12                	mov    (%edx),%dl
  800e32:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	75 dd                	jne    800e1e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5e:	73 50                	jae    800eb0 <memmove+0x6a>
  800e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6b:	76 43                	jbe    800eb0 <memmove+0x6a>
		s += n;
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e79:	eb 10                	jmp    800e8b <memmove+0x45>
			*--d = *--s;
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	ff 4d fc             	decl   -0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	8a 10                	mov    (%eax),%dl
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	75 e3                	jne    800e7b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e98:	eb 23                	jmp    800ebd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 dd                	jne    800e9a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed4:	eb 2a                	jmp    800f00 <memcmp+0x3e>
		if (*s1 != *s2)
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	8a 10                	mov    (%eax),%dl
  800edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	38 c2                	cmp    %al,%dl
  800ee2:	74 16                	je     800efa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f b6 d0             	movzbl %al,%edx
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 c0             	movzbl %al,%eax
  800ef4:	29 c2                	sub    %eax,%edx
  800ef6:	89 d0                	mov    %edx,%eax
  800ef8:	eb 18                	jmp    800f12 <memcmp+0x50>
		s1++, s2++;
  800efa:	ff 45 fc             	incl   -0x4(%ebp)
  800efd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 c9                	jne    800ed6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f25:	eb 15                	jmp    800f3c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d0             	movzbl %al,%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 0d                	je     800f46 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f42:	72 e3                	jb     800f27 <memfind+0x13>
  800f44:	eb 01                	jmp    800f47 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f46:	90                   	nop
	return (void *) s;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x19>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 20                	cmp    $0x20,%al
  800f6c:	74 f4                	je     800f62 <strtol+0x16>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 09                	cmp    $0x9,%al
  800f75:	74 eb                	je     800f62 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 2b                	cmp    $0x2b,%al
  800f7e:	75 05                	jne    800f85 <strtol+0x39>
		s++;
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	eb 13                	jmp    800f98 <strtol+0x4c>
	else if (*s == '-')
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 2d                	cmp    $0x2d,%al
  800f8c:	75 0a                	jne    800f98 <strtol+0x4c>
		s++, neg = 1;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	74 06                	je     800fa4 <strtol+0x58>
  800f9e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa2:	75 20                	jne    800fc4 <strtol+0x78>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 17                	jne    800fc4 <strtol+0x78>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	40                   	inc    %eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 78                	cmp    $0x78,%al
  800fb5:	75 0d                	jne    800fc4 <strtol+0x78>
		s += 2, base = 16;
  800fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc2:	eb 28                	jmp    800fec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	75 15                	jne    800fdf <strtol+0x93>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 30                	cmp    $0x30,%al
  800fd1:	75 0c                	jne    800fdf <strtol+0x93>
		s++, base = 8;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdd:	eb 0d                	jmp    800fec <strtol+0xa0>
	else if (base == 0)
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 07                	jne    800fec <strtol+0xa0>
		base = 10;
  800fe5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2f                	cmp    $0x2f,%al
  800ff3:	7e 19                	jle    80100e <strtol+0xc2>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 39                	cmp    $0x39,%al
  800ffc:	7f 10                	jg     80100e <strtol+0xc2>
			dig = *s - '0';
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100c:	eb 42                	jmp    801050 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3c 60                	cmp    $0x60,%al
  801015:	7e 19                	jle    801030 <strtol+0xe4>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 7a                	cmp    $0x7a,%al
  80101e:	7f 10                	jg     801030 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f be c0             	movsbl %al,%eax
  801028:	83 e8 57             	sub    $0x57,%eax
  80102b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102e:	eb 20                	jmp    801050 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 40                	cmp    $0x40,%al
  801037:	7e 39                	jle    801072 <strtol+0x126>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 5a                	cmp    $0x5a,%al
  801040:	7f 30                	jg     801072 <strtol+0x126>
			dig = *s - 'A' + 10;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f be c0             	movsbl %al,%eax
  80104a:	83 e8 37             	sub    $0x37,%eax
  80104d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	3b 45 10             	cmp    0x10(%ebp),%eax
  801056:	7d 19                	jge    801071 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801062:	89 c2                	mov    %eax,%edx
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106c:	e9 7b ff ff ff       	jmp    800fec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801071:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	74 08                	je     801080 <strtol+0x134>
		*endptr = (char *) s;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801080:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801084:	74 07                	je     80108d <strtol+0x141>
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	f7 d8                	neg    %eax
  80108b:	eb 03                	jmp    801090 <strtol+0x144>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <ltostr>:

void
ltostr(long value, char *str)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	79 13                	jns    8010bf <ltostr+0x2d>
	{
		neg = 1;
  8010ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c7:	99                   	cltd   
  8010c8:	f7 f9                	idiv   %ecx
  8010ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e0:	83 c2 30             	add    $0x30,%edx
  8010e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ed:	f7 e9                	imul   %ecx
  8010ef:	c1 fa 02             	sar    $0x2,%edx
  8010f2:	89 c8                	mov    %ecx,%eax
  8010f4:	c1 f8 1f             	sar    $0x1f,%eax
  8010f7:	29 c2                	sub    %eax,%edx
  8010f9:	89 d0                	mov    %edx,%eax
  8010fb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801106:	f7 e9                	imul   %ecx
  801108:	c1 fa 02             	sar    $0x2,%edx
  80110b:	89 c8                	mov    %ecx,%eax
  80110d:	c1 f8 1f             	sar    $0x1f,%eax
  801110:	29 c2                	sub    %eax,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	c1 e0 02             	shl    $0x2,%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	01 c0                	add    %eax,%eax
  80111b:	29 c1                	sub    %eax,%ecx
  80111d:	89 ca                	mov    %ecx,%edx
  80111f:	85 d2                	test   %edx,%edx
  801121:	75 9c                	jne    8010bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	48                   	dec    %eax
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801135:	74 3d                	je     801174 <ltostr+0xe2>
		start = 1 ;
  801137:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113e:	eb 34                	jmp    801174 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116c:	88 02                	mov    %al,(%edx)
		start++ ;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801171:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80117a:	7c c4                	jl     801140 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 54 fa ff ff       	call   800bec <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 46 fa ff ff       	call   800bec <strlen>
  8011a6:	83 c4 04             	add    $0x4,%esp
  8011a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 17                	jmp    8011d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d9:	7c e1                	jl     8011bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e9:	eb 1f                	jmp    80120a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	01 c2                	add    %eax,%edx
  8011fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 c8                	add    %ecx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801207:	ff 45 f8             	incl   -0x8(%ebp)
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c d9                	jl     8011eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	eb 0c                	jmp    801251 <strsplit+0x31>
			*string++ = 0;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 18                	je     801272 <strsplit+0x52>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	50                   	push   %eax
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	e8 13 fb ff ff       	call   800d7e <strchr>
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	75 d3                	jne    801245 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 5a                	je     8012d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	83 f8 0f             	cmp    $0xf,%eax
  801283:	75 07                	jne    80128c <strsplit+0x6c>
		{
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 66                	jmp    8012f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 48 01             	lea    0x1(%eax),%ecx
  801294:	8b 55 14             	mov    0x14(%ebp),%edx
  801297:	89 0a                	mov    %ecx,(%edx)
  801299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012aa:	eb 03                	jmp    8012af <strsplit+0x8f>
			string++;
  8012ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 8b                	je     801243 <strsplit+0x23>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f be c0             	movsbl %al,%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 b5 fa ff ff       	call   800d7e <strchr>
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	74 dc                	je     8012ac <strsplit+0x8c>
			string++;
	}
  8012d0:	e9 6e ff ff ff       	jmp    801243 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 d0                	add    %edx,%eax
  8012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 1f                	je     801322 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801303:	e8 1d 00 00 00       	call   801325 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	68 b0 3a 80 00       	push   $0x803ab0
  801310:	e8 55 f2 ff ff       	call   80056a <cprintf>
  801315:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801318:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131f:	00 00 00 
	}
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80132b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801332:	00 00 00 
  801335:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80133c:	00 00 00 
  80133f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801346:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801349:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801350:	00 00 00 
  801353:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80135a:	00 00 00 
  80135d:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801364:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801367:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  80136e:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801371:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80137b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801380:	2d 00 10 00 00       	sub    $0x1000,%eax
  801385:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80138a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801391:	a1 20 41 80 00       	mov    0x804120,%eax
  801396:	c1 e0 04             	shl    $0x4,%eax
  801399:	89 c2                	mov    %eax,%edx
  80139b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139e:	01 d0                	add    %edx,%eax
  8013a0:	48                   	dec    %eax
  8013a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ac:	f7 75 f0             	divl   -0x10(%ebp)
  8013af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013b2:	29 d0                	sub    %edx,%eax
  8013b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8013b7:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013cb:	83 ec 04             	sub    $0x4,%esp
  8013ce:	6a 06                	push   $0x6
  8013d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8013d3:	50                   	push   %eax
  8013d4:	e8 b0 05 00 00       	call   801989 <sys_allocate_chunk>
  8013d9:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013dc:	a1 20 41 80 00       	mov    0x804120,%eax
  8013e1:	83 ec 0c             	sub    $0xc,%esp
  8013e4:	50                   	push   %eax
  8013e5:	e8 25 0c 00 00       	call   80200f <initialize_MemBlocksList>
  8013ea:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8013ed:	a1 48 41 80 00       	mov    0x804148,%eax
  8013f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8013f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013f9:	75 14                	jne    80140f <initialize_dyn_block_system+0xea>
  8013fb:	83 ec 04             	sub    $0x4,%esp
  8013fe:	68 d5 3a 80 00       	push   $0x803ad5
  801403:	6a 29                	push   $0x29
  801405:	68 f3 3a 80 00       	push   $0x803af3
  80140a:	e8 a7 ee ff ff       	call   8002b6 <_panic>
  80140f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	85 c0                	test   %eax,%eax
  801416:	74 10                	je     801428 <initialize_dyn_block_system+0x103>
  801418:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801420:	8b 52 04             	mov    0x4(%edx),%edx
  801423:	89 50 04             	mov    %edx,0x4(%eax)
  801426:	eb 0b                	jmp    801433 <initialize_dyn_block_system+0x10e>
  801428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142b:	8b 40 04             	mov    0x4(%eax),%eax
  80142e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	8b 40 04             	mov    0x4(%eax),%eax
  801439:	85 c0                	test   %eax,%eax
  80143b:	74 0f                	je     80144c <initialize_dyn_block_system+0x127>
  80143d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801440:	8b 40 04             	mov    0x4(%eax),%eax
  801443:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801446:	8b 12                	mov    (%edx),%edx
  801448:	89 10                	mov    %edx,(%eax)
  80144a:	eb 0a                	jmp    801456 <initialize_dyn_block_system+0x131>
  80144c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	a3 48 41 80 00       	mov    %eax,0x804148
  801456:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80145f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801462:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801469:	a1 54 41 80 00       	mov    0x804154,%eax
  80146e:	48                   	dec    %eax
  80146f:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801474:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801477:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  80147e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801481:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	ff 75 e0             	pushl  -0x20(%ebp)
  80148e:	e8 b9 14 00 00       	call   80294c <insert_sorted_with_merge_freeList>
  801493:	83 c4 10             	add    $0x10,%esp

}
  801496:	90                   	nop
  801497:	c9                   	leave  
  801498:	c3                   	ret    

00801499 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80149f:	e8 50 fe ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014a8:	75 07                	jne    8014b1 <malloc+0x18>
  8014aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8014af:	eb 68                	jmp    801519 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8014b1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014be:	01 d0                	add    %edx,%eax
  8014c0:	48                   	dec    %eax
  8014c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014cc:	f7 75 f4             	divl   -0xc(%ebp)
  8014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d2:	29 d0                	sub    %edx,%eax
  8014d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8014d7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8014de:	e8 74 08 00 00       	call   801d57 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014e3:	85 c0                	test   %eax,%eax
  8014e5:	74 2d                	je     801514 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8014e7:	83 ec 0c             	sub    $0xc,%esp
  8014ea:	ff 75 ec             	pushl  -0x14(%ebp)
  8014ed:	e8 52 0e 00 00       	call   802344 <alloc_block_FF>
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8014f8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014fc:	74 16                	je     801514 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8014fe:	83 ec 0c             	sub    $0xc,%esp
  801501:	ff 75 e8             	pushl  -0x18(%ebp)
  801504:	e8 3b 0c 00 00       	call   802144 <insert_sorted_allocList>
  801509:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80150c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80150f:	8b 40 08             	mov    0x8(%eax),%eax
  801512:	eb 05                	jmp    801519 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801514:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801519:	c9                   	leave  
  80151a:	c3                   	ret    

0080151b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801521:	8b 45 08             	mov    0x8(%ebp),%eax
  801524:	83 ec 08             	sub    $0x8,%esp
  801527:	50                   	push   %eax
  801528:	68 40 40 80 00       	push   $0x804040
  80152d:	e8 ba 0b 00 00       	call   8020ec <find_block>
  801532:	83 c4 10             	add    $0x10,%esp
  801535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153b:	8b 40 0c             	mov    0xc(%eax),%eax
  80153e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801541:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801545:	0f 84 9f 00 00 00    	je     8015ea <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80154b:	8b 45 08             	mov    0x8(%ebp),%eax
  80154e:	83 ec 08             	sub    $0x8,%esp
  801551:	ff 75 f0             	pushl  -0x10(%ebp)
  801554:	50                   	push   %eax
  801555:	e8 f7 03 00 00       	call   801951 <sys_free_user_mem>
  80155a:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  80155d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801561:	75 14                	jne    801577 <free+0x5c>
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	68 d5 3a 80 00       	push   $0x803ad5
  80156b:	6a 6a                	push   $0x6a
  80156d:	68 f3 3a 80 00       	push   $0x803af3
  801572:	e8 3f ed ff ff       	call   8002b6 <_panic>
  801577:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157a:	8b 00                	mov    (%eax),%eax
  80157c:	85 c0                	test   %eax,%eax
  80157e:	74 10                	je     801590 <free+0x75>
  801580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801583:	8b 00                	mov    (%eax),%eax
  801585:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801588:	8b 52 04             	mov    0x4(%edx),%edx
  80158b:	89 50 04             	mov    %edx,0x4(%eax)
  80158e:	eb 0b                	jmp    80159b <free+0x80>
  801590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801593:	8b 40 04             	mov    0x4(%eax),%eax
  801596:	a3 44 40 80 00       	mov    %eax,0x804044
  80159b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159e:	8b 40 04             	mov    0x4(%eax),%eax
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	74 0f                	je     8015b4 <free+0x99>
  8015a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a8:	8b 40 04             	mov    0x4(%eax),%eax
  8015ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ae:	8b 12                	mov    (%edx),%edx
  8015b0:	89 10                	mov    %edx,(%eax)
  8015b2:	eb 0a                	jmp    8015be <free+0xa3>
  8015b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b7:	8b 00                	mov    (%eax),%eax
  8015b9:	a3 40 40 80 00       	mov    %eax,0x804040
  8015be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015d1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8015d6:	48                   	dec    %eax
  8015d7:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e2:	e8 65 13 00 00       	call   80294c <insert_sorted_with_merge_freeList>
  8015e7:	83 c4 10             	add    $0x10,%esp
	}
}
  8015ea:	90                   	nop
  8015eb:	c9                   	leave  
  8015ec:	c3                   	ret    

008015ed <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 28             	sub    $0x28,%esp
  8015f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015f6:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015f9:	e8 f6 fc ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015fe:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801602:	75 0a                	jne    80160e <smalloc+0x21>
  801604:	b8 00 00 00 00       	mov    $0x0,%eax
  801609:	e9 af 00 00 00       	jmp    8016bd <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80160e:	e8 44 07 00 00       	call   801d57 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801613:	83 f8 01             	cmp    $0x1,%eax
  801616:	0f 85 9c 00 00 00    	jne    8016b8 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80161c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801623:	8b 55 0c             	mov    0xc(%ebp),%edx
  801626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801629:	01 d0                	add    %edx,%eax
  80162b:	48                   	dec    %eax
  80162c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801632:	ba 00 00 00 00       	mov    $0x0,%edx
  801637:	f7 75 f4             	divl   -0xc(%ebp)
  80163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163d:	29 d0                	sub    %edx,%eax
  80163f:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801642:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801649:	76 07                	jbe    801652 <smalloc+0x65>
			return NULL;
  80164b:	b8 00 00 00 00       	mov    $0x0,%eax
  801650:	eb 6b                	jmp    8016bd <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801652:	83 ec 0c             	sub    $0xc,%esp
  801655:	ff 75 0c             	pushl  0xc(%ebp)
  801658:	e8 e7 0c 00 00       	call   802344 <alloc_block_FF>
  80165d:	83 c4 10             	add    $0x10,%esp
  801660:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801663:	83 ec 0c             	sub    $0xc,%esp
  801666:	ff 75 ec             	pushl  -0x14(%ebp)
  801669:	e8 d6 0a 00 00       	call   802144 <insert_sorted_allocList>
  80166e:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801671:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801675:	75 07                	jne    80167e <smalloc+0x91>
		{
			return NULL;
  801677:	b8 00 00 00 00       	mov    $0x0,%eax
  80167c:	eb 3f                	jmp    8016bd <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  80167e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801681:	8b 40 08             	mov    0x8(%eax),%eax
  801684:	89 c2                	mov    %eax,%edx
  801686:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80168a:	52                   	push   %edx
  80168b:	50                   	push   %eax
  80168c:	ff 75 0c             	pushl  0xc(%ebp)
  80168f:	ff 75 08             	pushl  0x8(%ebp)
  801692:	e8 45 04 00 00       	call   801adc <sys_createSharedObject>
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80169d:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016a1:	74 06                	je     8016a9 <smalloc+0xbc>
  8016a3:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016a7:	75 07                	jne    8016b0 <smalloc+0xc3>
		{
			return NULL;
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ae:	eb 0d                	jmp    8016bd <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8016b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b3:	8b 40 08             	mov    0x8(%eax),%eax
  8016b6:	eb 05                	jmp    8016bd <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8016b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c5:	e8 2a fc ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016ca:	83 ec 08             	sub    $0x8,%esp
  8016cd:	ff 75 0c             	pushl  0xc(%ebp)
  8016d0:	ff 75 08             	pushl  0x8(%ebp)
  8016d3:	e8 2e 04 00 00       	call   801b06 <sys_getSizeOfSharedObject>
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8016de:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8016e2:	75 0a                	jne    8016ee <sget+0x2f>
	{
		return NULL;
  8016e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e9:	e9 94 00 00 00       	jmp    801782 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016ee:	e8 64 06 00 00       	call   801d57 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	0f 84 82 00 00 00    	je     80177d <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8016fb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801702:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801709:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80170c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80170f:	01 d0                	add    %edx,%eax
  801711:	48                   	dec    %eax
  801712:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801715:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801718:	ba 00 00 00 00       	mov    $0x0,%edx
  80171d:	f7 75 ec             	divl   -0x14(%ebp)
  801720:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801723:	29 d0                	sub    %edx,%eax
  801725:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80172b:	83 ec 0c             	sub    $0xc,%esp
  80172e:	50                   	push   %eax
  80172f:	e8 10 0c 00 00       	call   802344 <alloc_block_FF>
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80173a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80173e:	75 07                	jne    801747 <sget+0x88>
		{
			return NULL;
  801740:	b8 00 00 00 00       	mov    $0x0,%eax
  801745:	eb 3b                	jmp    801782 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801747:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80174a:	8b 40 08             	mov    0x8(%eax),%eax
  80174d:	83 ec 04             	sub    $0x4,%esp
  801750:	50                   	push   %eax
  801751:	ff 75 0c             	pushl  0xc(%ebp)
  801754:	ff 75 08             	pushl  0x8(%ebp)
  801757:	e8 c7 03 00 00       	call   801b23 <sys_getSharedObject>
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801762:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801766:	74 06                	je     80176e <sget+0xaf>
  801768:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80176c:	75 07                	jne    801775 <sget+0xb6>
		{
			return NULL;
  80176e:	b8 00 00 00 00       	mov    $0x0,%eax
  801773:	eb 0d                	jmp    801782 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801775:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801778:	8b 40 08             	mov    0x8(%eax),%eax
  80177b:	eb 05                	jmp    801782 <sget+0xc3>
		}
	}
	else
			return NULL;
  80177d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801782:	c9                   	leave  
  801783:	c3                   	ret    

00801784 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801784:	55                   	push   %ebp
  801785:	89 e5                	mov    %esp,%ebp
  801787:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80178a:	e8 65 fb ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80178f:	83 ec 04             	sub    $0x4,%esp
  801792:	68 00 3b 80 00       	push   $0x803b00
  801797:	68 e1 00 00 00       	push   $0xe1
  80179c:	68 f3 3a 80 00       	push   $0x803af3
  8017a1:	e8 10 eb ff ff       	call   8002b6 <_panic>

008017a6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	68 28 3b 80 00       	push   $0x803b28
  8017b4:	68 f5 00 00 00       	push   $0xf5
  8017b9:	68 f3 3a 80 00       	push   $0x803af3
  8017be:	e8 f3 ea ff ff       	call   8002b6 <_panic>

008017c3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017c9:	83 ec 04             	sub    $0x4,%esp
  8017cc:	68 4c 3b 80 00       	push   $0x803b4c
  8017d1:	68 00 01 00 00       	push   $0x100
  8017d6:	68 f3 3a 80 00       	push   $0x803af3
  8017db:	e8 d6 ea ff ff       	call   8002b6 <_panic>

008017e0 <shrink>:

}
void shrink(uint32 newSize)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 4c 3b 80 00       	push   $0x803b4c
  8017ee:	68 05 01 00 00       	push   $0x105
  8017f3:	68 f3 3a 80 00       	push   $0x803af3
  8017f8:	e8 b9 ea ff ff       	call   8002b6 <_panic>

008017fd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	68 4c 3b 80 00       	push   $0x803b4c
  80180b:	68 0a 01 00 00       	push   $0x10a
  801810:	68 f3 3a 80 00       	push   $0x803af3
  801815:	e8 9c ea ff ff       	call   8002b6 <_panic>

0080181a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80181a:	55                   	push   %ebp
  80181b:	89 e5                	mov    %esp,%ebp
  80181d:	57                   	push   %edi
  80181e:	56                   	push   %esi
  80181f:	53                   	push   %ebx
  801820:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	8b 55 0c             	mov    0xc(%ebp),%edx
  801829:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80182c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80182f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801832:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801835:	cd 30                	int    $0x30
  801837:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80183a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	5b                   	pop    %ebx
  801841:	5e                   	pop    %esi
  801842:	5f                   	pop    %edi
  801843:	5d                   	pop    %ebp
  801844:	c3                   	ret    

00801845 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801845:	55                   	push   %ebp
  801846:	89 e5                	mov    %esp,%ebp
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	8b 45 10             	mov    0x10(%ebp),%eax
  80184e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801851:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801855:	8b 45 08             	mov    0x8(%ebp),%eax
  801858:	6a 00                	push   $0x0
  80185a:	6a 00                	push   $0x0
  80185c:	52                   	push   %edx
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	50                   	push   %eax
  801861:	6a 00                	push   $0x0
  801863:	e8 b2 ff ff ff       	call   80181a <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	90                   	nop
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <sys_cgetc>:

int
sys_cgetc(void)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 01                	push   $0x1
  80187d:	e8 98 ff ff ff       	call   80181a <syscall>
  801882:	83 c4 18             	add    $0x18,%esp
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80188a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	52                   	push   %edx
  801897:	50                   	push   %eax
  801898:	6a 05                	push   $0x5
  80189a:	e8 7b ff ff ff       	call   80181a <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	56                   	push   %esi
  8018a8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8018ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b8:	56                   	push   %esi
  8018b9:	53                   	push   %ebx
  8018ba:	51                   	push   %ecx
  8018bb:	52                   	push   %edx
  8018bc:	50                   	push   %eax
  8018bd:	6a 06                	push   $0x6
  8018bf:	e8 56 ff ff ff       	call   80181a <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ca:	5b                   	pop    %ebx
  8018cb:	5e                   	pop    %esi
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    

008018ce <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8018d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	52                   	push   %edx
  8018de:	50                   	push   %eax
  8018df:	6a 07                	push   $0x7
  8018e1:	e8 34 ff ff ff       	call   80181a <syscall>
  8018e6:	83 c4 18             	add    $0x18,%esp
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	ff 75 0c             	pushl  0xc(%ebp)
  8018f7:	ff 75 08             	pushl  0x8(%ebp)
  8018fa:	6a 08                	push   $0x8
  8018fc:	e8 19 ff ff ff       	call   80181a <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 09                	push   $0x9
  801915:	e8 00 ff ff ff       	call   80181a <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	6a 00                	push   $0x0
  801928:	6a 00                	push   $0x0
  80192a:	6a 00                	push   $0x0
  80192c:	6a 0a                	push   $0xa
  80192e:	e8 e7 fe ff ff       	call   80181a <syscall>
  801933:	83 c4 18             	add    $0x18,%esp
}
  801936:	c9                   	leave  
  801937:	c3                   	ret    

00801938 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 0b                	push   $0xb
  801947:	e8 ce fe ff ff       	call   80181a <syscall>
  80194c:	83 c4 18             	add    $0x18,%esp
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	ff 75 08             	pushl  0x8(%ebp)
  801960:	6a 0f                	push   $0xf
  801962:	e8 b3 fe ff ff       	call   80181a <syscall>
  801967:	83 c4 18             	add    $0x18,%esp
	return;
  80196a:	90                   	nop
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	ff 75 0c             	pushl  0xc(%ebp)
  801979:	ff 75 08             	pushl  0x8(%ebp)
  80197c:	6a 10                	push   $0x10
  80197e:	e8 97 fe ff ff       	call   80181a <syscall>
  801983:	83 c4 18             	add    $0x18,%esp
	return ;
  801986:	90                   	nop
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	ff 75 10             	pushl  0x10(%ebp)
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	ff 75 08             	pushl  0x8(%ebp)
  801999:	6a 11                	push   $0x11
  80199b:	e8 7a fe ff ff       	call   80181a <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019a3:	90                   	nop
}
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 0c                	push   $0xc
  8019b5:	e8 60 fe ff ff       	call   80181a <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	ff 75 08             	pushl  0x8(%ebp)
  8019cd:	6a 0d                	push   $0xd
  8019cf:	e8 46 fe ff ff       	call   80181a <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 0e                	push   $0xe
  8019e8:	e8 2d fe ff ff       	call   80181a <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	90                   	nop
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 13                	push   $0x13
  801a02:	e8 13 fe ff ff       	call   80181a <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 14                	push   $0x14
  801a1c:	e8 f9 fd ff ff       	call   80181a <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	90                   	nop
  801a25:	c9                   	leave  
  801a26:	c3                   	ret    

00801a27 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	83 ec 04             	sub    $0x4,%esp
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a33:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	50                   	push   %eax
  801a40:	6a 15                	push   $0x15
  801a42:	e8 d3 fd ff ff       	call   80181a <syscall>
  801a47:	83 c4 18             	add    $0x18,%esp
}
  801a4a:	90                   	nop
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 16                	push   $0x16
  801a5c:	e8 b9 fd ff ff       	call   80181a <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	90                   	nop
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	ff 75 0c             	pushl  0xc(%ebp)
  801a76:	50                   	push   %eax
  801a77:	6a 17                	push   $0x17
  801a79:	e8 9c fd ff ff       	call   80181a <syscall>
  801a7e:	83 c4 18             	add    $0x18,%esp
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	6a 00                	push   $0x0
  801a92:	52                   	push   %edx
  801a93:	50                   	push   %eax
  801a94:	6a 1a                	push   $0x1a
  801a96:	e8 7f fd ff ff       	call   80181a <syscall>
  801a9b:	83 c4 18             	add    $0x18,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aa3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	52                   	push   %edx
  801ab0:	50                   	push   %eax
  801ab1:	6a 18                	push   $0x18
  801ab3:	e8 62 fd ff ff       	call   80181a <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	90                   	nop
  801abc:	c9                   	leave  
  801abd:	c3                   	ret    

00801abe <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801abe:	55                   	push   %ebp
  801abf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ac1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	52                   	push   %edx
  801ace:	50                   	push   %eax
  801acf:	6a 19                	push   $0x19
  801ad1:	e8 44 fd ff ff       	call   80181a <syscall>
  801ad6:	83 c4 18             	add    $0x18,%esp
}
  801ad9:	90                   	nop
  801ada:	c9                   	leave  
  801adb:	c3                   	ret    

00801adc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	8b 45 10             	mov    0x10(%ebp),%eax
  801ae5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ae8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aeb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	6a 00                	push   $0x0
  801af4:	51                   	push   %ecx
  801af5:	52                   	push   %edx
  801af6:	ff 75 0c             	pushl  0xc(%ebp)
  801af9:	50                   	push   %eax
  801afa:	6a 1b                	push   $0x1b
  801afc:	e8 19 fd ff ff       	call   80181a <syscall>
  801b01:	83 c4 18             	add    $0x18,%esp
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	52                   	push   %edx
  801b16:	50                   	push   %eax
  801b17:	6a 1c                	push   $0x1c
  801b19:	e8 fc fc ff ff       	call   80181a <syscall>
  801b1e:	83 c4 18             	add    $0x18,%esp
}
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	51                   	push   %ecx
  801b34:	52                   	push   %edx
  801b35:	50                   	push   %eax
  801b36:	6a 1d                	push   $0x1d
  801b38:	e8 dd fc ff ff       	call   80181a <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	52                   	push   %edx
  801b52:	50                   	push   %eax
  801b53:	6a 1e                	push   $0x1e
  801b55:	e8 c0 fc ff ff       	call   80181a <syscall>
  801b5a:	83 c4 18             	add    $0x18,%esp
}
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 1f                	push   $0x1f
  801b6e:	e8 a7 fc ff ff       	call   80181a <syscall>
  801b73:	83 c4 18             	add    $0x18,%esp
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	ff 75 14             	pushl  0x14(%ebp)
  801b83:	ff 75 10             	pushl  0x10(%ebp)
  801b86:	ff 75 0c             	pushl  0xc(%ebp)
  801b89:	50                   	push   %eax
  801b8a:	6a 20                	push   $0x20
  801b8c:	e8 89 fc ff ff       	call   80181a <syscall>
  801b91:	83 c4 18             	add    $0x18,%esp
}
  801b94:	c9                   	leave  
  801b95:	c3                   	ret    

00801b96 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b96:	55                   	push   %ebp
  801b97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 00                	push   $0x0
  801ba4:	50                   	push   %eax
  801ba5:	6a 21                	push   $0x21
  801ba7:	e8 6e fc ff ff       	call   80181a <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	90                   	nop
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	50                   	push   %eax
  801bc1:	6a 22                	push   $0x22
  801bc3:	e8 52 fc ff ff       	call   80181a <syscall>
  801bc8:	83 c4 18             	add    $0x18,%esp
}
  801bcb:	c9                   	leave  
  801bcc:	c3                   	ret    

00801bcd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 02                	push   $0x2
  801bdc:	e8 39 fc ff ff       	call   80181a <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	6a 03                	push   $0x3
  801bf5:	e8 20 fc ff ff       	call   80181a <syscall>
  801bfa:	83 c4 18             	add    $0x18,%esp
}
  801bfd:	c9                   	leave  
  801bfe:	c3                   	ret    

00801bff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 04                	push   $0x4
  801c0e:	e8 07 fc ff ff       	call   80181a <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_exit_env>:


void sys_exit_env(void)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 23                	push   $0x23
  801c27:	e8 ee fb ff ff       	call   80181a <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	90                   	nop
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
  801c35:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c3b:	8d 50 04             	lea    0x4(%eax),%edx
  801c3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	52                   	push   %edx
  801c48:	50                   	push   %eax
  801c49:	6a 24                	push   $0x24
  801c4b:	e8 ca fb ff ff       	call   80181a <syscall>
  801c50:	83 c4 18             	add    $0x18,%esp
	return result;
  801c53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c5c:	89 01                	mov    %eax,(%ecx)
  801c5e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	c9                   	leave  
  801c65:	c2 04 00             	ret    $0x4

00801c68 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c68:	55                   	push   %ebp
  801c69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	ff 75 10             	pushl  0x10(%ebp)
  801c72:	ff 75 0c             	pushl  0xc(%ebp)
  801c75:	ff 75 08             	pushl  0x8(%ebp)
  801c78:	6a 12                	push   $0x12
  801c7a:	e8 9b fb ff ff       	call   80181a <syscall>
  801c7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c82:	90                   	nop
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 25                	push   $0x25
  801c94:	e8 81 fb ff ff       	call   80181a <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	83 ec 04             	sub    $0x4,%esp
  801ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801caa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	50                   	push   %eax
  801cb7:	6a 26                	push   $0x26
  801cb9:	e8 5c fb ff ff       	call   80181a <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc1:	90                   	nop
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <rsttst>:
void rsttst()
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	6a 28                	push   $0x28
  801cd3:	e8 42 fb ff ff       	call   80181a <syscall>
  801cd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdb:	90                   	nop
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
  801ce1:	83 ec 04             	sub    $0x4,%esp
  801ce4:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801cea:	8b 55 18             	mov    0x18(%ebp),%edx
  801ced:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf1:	52                   	push   %edx
  801cf2:	50                   	push   %eax
  801cf3:	ff 75 10             	pushl  0x10(%ebp)
  801cf6:	ff 75 0c             	pushl  0xc(%ebp)
  801cf9:	ff 75 08             	pushl  0x8(%ebp)
  801cfc:	6a 27                	push   $0x27
  801cfe:	e8 17 fb ff ff       	call   80181a <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
	return ;
  801d06:	90                   	nop
}
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <chktst>:
void chktst(uint32 n)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	ff 75 08             	pushl  0x8(%ebp)
  801d17:	6a 29                	push   $0x29
  801d19:	e8 fc fa ff ff       	call   80181a <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <inctst>:

void inctst()
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 2a                	push   $0x2a
  801d33:	e8 e2 fa ff ff       	call   80181a <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <gettst>:
uint32 gettst()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 2b                	push   $0x2b
  801d4d:	e8 c8 fa ff ff       	call   80181a <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	6a 2c                	push   $0x2c
  801d69:	e8 ac fa ff ff       	call   80181a <syscall>
  801d6e:	83 c4 18             	add    $0x18,%esp
  801d71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d74:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d78:	75 07                	jne    801d81 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7f:	eb 05                	jmp    801d86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
  801d8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 2c                	push   $0x2c
  801d9a:	e8 7b fa ff ff       	call   80181a <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
  801da2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801da5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801da9:	75 07                	jne    801db2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dab:	b8 01 00 00 00       	mov    $0x1,%eax
  801db0:	eb 05                	jmp    801db7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801db2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 2c                	push   $0x2c
  801dcb:	e8 4a fa ff ff       	call   80181a <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
  801dd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801dd6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801dda:	75 07                	jne    801de3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ddc:	b8 01 00 00 00       	mov    $0x1,%eax
  801de1:	eb 05                	jmp    801de8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 2c                	push   $0x2c
  801dfc:	e8 19 fa ff ff       	call   80181a <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
  801e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e07:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e0b:	75 07                	jne    801e14 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e12:	eb 05                	jmp    801e19 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 08             	pushl  0x8(%ebp)
  801e29:	6a 2d                	push   $0x2d
  801e2b:	e8 ea f9 ff ff       	call   80181a <syscall>
  801e30:	83 c4 18             	add    $0x18,%esp
	return ;
  801e33:	90                   	nop
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e43:	8b 45 08             	mov    0x8(%ebp),%eax
  801e46:	6a 00                	push   $0x0
  801e48:	53                   	push   %ebx
  801e49:	51                   	push   %ecx
  801e4a:	52                   	push   %edx
  801e4b:	50                   	push   %eax
  801e4c:	6a 2e                	push   $0x2e
  801e4e:	e8 c7 f9 ff ff       	call   80181a <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
}
  801e56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e59:	c9                   	leave  
  801e5a:	c3                   	ret    

00801e5b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e5b:	55                   	push   %ebp
  801e5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	52                   	push   %edx
  801e6b:	50                   	push   %eax
  801e6c:	6a 2f                	push   $0x2f
  801e6e:	e8 a7 f9 ff ff       	call   80181a <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
}
  801e76:	c9                   	leave  
  801e77:	c3                   	ret    

00801e78 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e78:	55                   	push   %ebp
  801e79:	89 e5                	mov    %esp,%ebp
  801e7b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e7e:	83 ec 0c             	sub    $0xc,%esp
  801e81:	68 5c 3b 80 00       	push   $0x803b5c
  801e86:	e8 df e6 ff ff       	call   80056a <cprintf>
  801e8b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e8e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e95:	83 ec 0c             	sub    $0xc,%esp
  801e98:	68 88 3b 80 00       	push   $0x803b88
  801e9d:	e8 c8 e6 ff ff       	call   80056a <cprintf>
  801ea2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ea5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ea9:	a1 38 41 80 00       	mov    0x804138,%eax
  801eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eb1:	eb 56                	jmp    801f09 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801eb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eb7:	74 1c                	je     801ed5 <print_mem_block_lists+0x5d>
  801eb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebc:	8b 50 08             	mov    0x8(%eax),%edx
  801ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec2:	8b 48 08             	mov    0x8(%eax),%ecx
  801ec5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec8:	8b 40 0c             	mov    0xc(%eax),%eax
  801ecb:	01 c8                	add    %ecx,%eax
  801ecd:	39 c2                	cmp    %eax,%edx
  801ecf:	73 04                	jae    801ed5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ed1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ed8:	8b 50 08             	mov    0x8(%eax),%edx
  801edb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ede:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee1:	01 c2                	add    %eax,%edx
  801ee3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee6:	8b 40 08             	mov    0x8(%eax),%eax
  801ee9:	83 ec 04             	sub    $0x4,%esp
  801eec:	52                   	push   %edx
  801eed:	50                   	push   %eax
  801eee:	68 9d 3b 80 00       	push   $0x803b9d
  801ef3:	e8 72 e6 ff ff       	call   80056a <cprintf>
  801ef8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f01:	a1 40 41 80 00       	mov    0x804140,%eax
  801f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f0d:	74 07                	je     801f16 <print_mem_block_lists+0x9e>
  801f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f12:	8b 00                	mov    (%eax),%eax
  801f14:	eb 05                	jmp    801f1b <print_mem_block_lists+0xa3>
  801f16:	b8 00 00 00 00       	mov    $0x0,%eax
  801f1b:	a3 40 41 80 00       	mov    %eax,0x804140
  801f20:	a1 40 41 80 00       	mov    0x804140,%eax
  801f25:	85 c0                	test   %eax,%eax
  801f27:	75 8a                	jne    801eb3 <print_mem_block_lists+0x3b>
  801f29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f2d:	75 84                	jne    801eb3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f2f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f33:	75 10                	jne    801f45 <print_mem_block_lists+0xcd>
  801f35:	83 ec 0c             	sub    $0xc,%esp
  801f38:	68 ac 3b 80 00       	push   $0x803bac
  801f3d:	e8 28 e6 ff ff       	call   80056a <cprintf>
  801f42:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f45:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f4c:	83 ec 0c             	sub    $0xc,%esp
  801f4f:	68 d0 3b 80 00       	push   $0x803bd0
  801f54:	e8 11 e6 ff ff       	call   80056a <cprintf>
  801f59:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f5c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f60:	a1 40 40 80 00       	mov    0x804040,%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f68:	eb 56                	jmp    801fc0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f6e:	74 1c                	je     801f8c <print_mem_block_lists+0x114>
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	8b 50 08             	mov    0x8(%eax),%edx
  801f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f79:	8b 48 08             	mov    0x8(%eax),%ecx
  801f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f82:	01 c8                	add    %ecx,%eax
  801f84:	39 c2                	cmp    %eax,%edx
  801f86:	73 04                	jae    801f8c <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f88:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8f:	8b 50 08             	mov    0x8(%eax),%edx
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	8b 40 0c             	mov    0xc(%eax),%eax
  801f98:	01 c2                	add    %eax,%edx
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	8b 40 08             	mov    0x8(%eax),%eax
  801fa0:	83 ec 04             	sub    $0x4,%esp
  801fa3:	52                   	push   %edx
  801fa4:	50                   	push   %eax
  801fa5:	68 9d 3b 80 00       	push   $0x803b9d
  801faa:	e8 bb e5 ff ff       	call   80056a <cprintf>
  801faf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fb8:	a1 48 40 80 00       	mov    0x804048,%eax
  801fbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc4:	74 07                	je     801fcd <print_mem_block_lists+0x155>
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	8b 00                	mov    (%eax),%eax
  801fcb:	eb 05                	jmp    801fd2 <print_mem_block_lists+0x15a>
  801fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd2:	a3 48 40 80 00       	mov    %eax,0x804048
  801fd7:	a1 48 40 80 00       	mov    0x804048,%eax
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	75 8a                	jne    801f6a <print_mem_block_lists+0xf2>
  801fe0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe4:	75 84                	jne    801f6a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fe6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fea:	75 10                	jne    801ffc <print_mem_block_lists+0x184>
  801fec:	83 ec 0c             	sub    $0xc,%esp
  801fef:	68 e8 3b 80 00       	push   $0x803be8
  801ff4:	e8 71 e5 ff ff       	call   80056a <cprintf>
  801ff9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801ffc:	83 ec 0c             	sub    $0xc,%esp
  801fff:	68 5c 3b 80 00       	push   $0x803b5c
  802004:	e8 61 e5 ff ff       	call   80056a <cprintf>
  802009:	83 c4 10             	add    $0x10,%esp

}
  80200c:	90                   	nop
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
  802012:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802015:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80201c:	00 00 00 
  80201f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802026:	00 00 00 
  802029:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802030:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802033:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80203a:	e9 9e 00 00 00       	jmp    8020dd <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80203f:	a1 50 40 80 00       	mov    0x804050,%eax
  802044:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802047:	c1 e2 04             	shl    $0x4,%edx
  80204a:	01 d0                	add    %edx,%eax
  80204c:	85 c0                	test   %eax,%eax
  80204e:	75 14                	jne    802064 <initialize_MemBlocksList+0x55>
  802050:	83 ec 04             	sub    $0x4,%esp
  802053:	68 10 3c 80 00       	push   $0x803c10
  802058:	6a 42                	push   $0x42
  80205a:	68 33 3c 80 00       	push   $0x803c33
  80205f:	e8 52 e2 ff ff       	call   8002b6 <_panic>
  802064:	a1 50 40 80 00       	mov    0x804050,%eax
  802069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206c:	c1 e2 04             	shl    $0x4,%edx
  80206f:	01 d0                	add    %edx,%eax
  802071:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802077:	89 10                	mov    %edx,(%eax)
  802079:	8b 00                	mov    (%eax),%eax
  80207b:	85 c0                	test   %eax,%eax
  80207d:	74 18                	je     802097 <initialize_MemBlocksList+0x88>
  80207f:	a1 48 41 80 00       	mov    0x804148,%eax
  802084:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80208a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80208d:	c1 e1 04             	shl    $0x4,%ecx
  802090:	01 ca                	add    %ecx,%edx
  802092:	89 50 04             	mov    %edx,0x4(%eax)
  802095:	eb 12                	jmp    8020a9 <initialize_MemBlocksList+0x9a>
  802097:	a1 50 40 80 00       	mov    0x804050,%eax
  80209c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209f:	c1 e2 04             	shl    $0x4,%edx
  8020a2:	01 d0                	add    %edx,%eax
  8020a4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020a9:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b1:	c1 e2 04             	shl    $0x4,%edx
  8020b4:	01 d0                	add    %edx,%eax
  8020b6:	a3 48 41 80 00       	mov    %eax,0x804148
  8020bb:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c3:	c1 e2 04             	shl    $0x4,%edx
  8020c6:	01 d0                	add    %edx,%eax
  8020c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8020cf:	a1 54 41 80 00       	mov    0x804154,%eax
  8020d4:	40                   	inc    %eax
  8020d5:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8020da:	ff 45 f4             	incl   -0xc(%ebp)
  8020dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8020e3:	0f 82 56 ff ff ff    	jb     80203f <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8020e9:	90                   	nop
  8020ea:	c9                   	leave  
  8020eb:	c3                   	ret    

008020ec <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f5:	8b 00                	mov    (%eax),%eax
  8020f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020fa:	eb 19                	jmp    802115 <find_block+0x29>
	{
		if(blk->sva==va)
  8020fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ff:	8b 40 08             	mov    0x8(%eax),%eax
  802102:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802105:	75 05                	jne    80210c <find_block+0x20>
			return (blk);
  802107:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80210a:	eb 36                	jmp    802142 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	8b 40 08             	mov    0x8(%eax),%eax
  802112:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802115:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802119:	74 07                	je     802122 <find_block+0x36>
  80211b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80211e:	8b 00                	mov    (%eax),%eax
  802120:	eb 05                	jmp    802127 <find_block+0x3b>
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
  802127:	8b 55 08             	mov    0x8(%ebp),%edx
  80212a:	89 42 08             	mov    %eax,0x8(%edx)
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	8b 40 08             	mov    0x8(%eax),%eax
  802133:	85 c0                	test   %eax,%eax
  802135:	75 c5                	jne    8020fc <find_block+0x10>
  802137:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80213b:	75 bf                	jne    8020fc <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80213d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802142:	c9                   	leave  
  802143:	c3                   	ret    

00802144 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802144:	55                   	push   %ebp
  802145:	89 e5                	mov    %esp,%ebp
  802147:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80214a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80214f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802152:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802159:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80215f:	75 65                	jne    8021c6 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802161:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802165:	75 14                	jne    80217b <insert_sorted_allocList+0x37>
  802167:	83 ec 04             	sub    $0x4,%esp
  80216a:	68 10 3c 80 00       	push   $0x803c10
  80216f:	6a 5c                	push   $0x5c
  802171:	68 33 3c 80 00       	push   $0x803c33
  802176:	e8 3b e1 ff ff       	call   8002b6 <_panic>
  80217b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	89 10                	mov    %edx,(%eax)
  802186:	8b 45 08             	mov    0x8(%ebp),%eax
  802189:	8b 00                	mov    (%eax),%eax
  80218b:	85 c0                	test   %eax,%eax
  80218d:	74 0d                	je     80219c <insert_sorted_allocList+0x58>
  80218f:	a1 40 40 80 00       	mov    0x804040,%eax
  802194:	8b 55 08             	mov    0x8(%ebp),%edx
  802197:	89 50 04             	mov    %edx,0x4(%eax)
  80219a:	eb 08                	jmp    8021a4 <insert_sorted_allocList+0x60>
  80219c:	8b 45 08             	mov    0x8(%ebp),%eax
  80219f:	a3 44 40 80 00       	mov    %eax,0x804044
  8021a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a7:	a3 40 40 80 00       	mov    %eax,0x804040
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021bb:	40                   	inc    %eax
  8021bc:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8021c1:	e9 7b 01 00 00       	jmp    802341 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8021c6:	a1 44 40 80 00       	mov    0x804044,%eax
  8021cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8021ce:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	8b 50 08             	mov    0x8(%eax),%edx
  8021dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8021df:	8b 40 08             	mov    0x8(%eax),%eax
  8021e2:	39 c2                	cmp    %eax,%edx
  8021e4:	76 65                	jbe    80224b <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8021e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ea:	75 14                	jne    802200 <insert_sorted_allocList+0xbc>
  8021ec:	83 ec 04             	sub    $0x4,%esp
  8021ef:	68 4c 3c 80 00       	push   $0x803c4c
  8021f4:	6a 64                	push   $0x64
  8021f6:	68 33 3c 80 00       	push   $0x803c33
  8021fb:	e8 b6 e0 ff ff       	call   8002b6 <_panic>
  802200:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	89 50 04             	mov    %edx,0x4(%eax)
  80220c:	8b 45 08             	mov    0x8(%ebp),%eax
  80220f:	8b 40 04             	mov    0x4(%eax),%eax
  802212:	85 c0                	test   %eax,%eax
  802214:	74 0c                	je     802222 <insert_sorted_allocList+0xde>
  802216:	a1 44 40 80 00       	mov    0x804044,%eax
  80221b:	8b 55 08             	mov    0x8(%ebp),%edx
  80221e:	89 10                	mov    %edx,(%eax)
  802220:	eb 08                	jmp    80222a <insert_sorted_allocList+0xe6>
  802222:	8b 45 08             	mov    0x8(%ebp),%eax
  802225:	a3 40 40 80 00       	mov    %eax,0x804040
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	a3 44 40 80 00       	mov    %eax,0x804044
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80223b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802240:	40                   	inc    %eax
  802241:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802246:	e9 f6 00 00 00       	jmp    802341 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	8b 50 08             	mov    0x8(%eax),%edx
  802251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802254:	8b 40 08             	mov    0x8(%eax),%eax
  802257:	39 c2                	cmp    %eax,%edx
  802259:	73 65                	jae    8022c0 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80225b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225f:	75 14                	jne    802275 <insert_sorted_allocList+0x131>
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	68 10 3c 80 00       	push   $0x803c10
  802269:	6a 68                	push   $0x68
  80226b:	68 33 3c 80 00       	push   $0x803c33
  802270:	e8 41 e0 ff ff       	call   8002b6 <_panic>
  802275:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	89 10                	mov    %edx,(%eax)
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	74 0d                	je     802296 <insert_sorted_allocList+0x152>
  802289:	a1 40 40 80 00       	mov    0x804040,%eax
  80228e:	8b 55 08             	mov    0x8(%ebp),%edx
  802291:	89 50 04             	mov    %edx,0x4(%eax)
  802294:	eb 08                	jmp    80229e <insert_sorted_allocList+0x15a>
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	a3 44 40 80 00       	mov    %eax,0x804044
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	a3 40 40 80 00       	mov    %eax,0x804040
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b5:	40                   	inc    %eax
  8022b6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022bb:	e9 81 00 00 00       	jmp    802341 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022c0:	a1 40 40 80 00       	mov    0x804040,%eax
  8022c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c8:	eb 51                	jmp    80231b <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	8b 50 08             	mov    0x8(%eax),%edx
  8022d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d3:	8b 40 08             	mov    0x8(%eax),%eax
  8022d6:	39 c2                	cmp    %eax,%edx
  8022d8:	73 39                	jae    802313 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8022da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022dd:	8b 40 04             	mov    0x4(%eax),%eax
  8022e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8022e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e9:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022f1:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022fa:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802302:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802305:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80230a:	40                   	inc    %eax
  80230b:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802310:	90                   	nop
				}
			}
		 }

	}
}
  802311:	eb 2e                	jmp    802341 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802313:	a1 48 40 80 00       	mov    0x804048,%eax
  802318:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80231b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80231f:	74 07                	je     802328 <insert_sorted_allocList+0x1e4>
  802321:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802324:	8b 00                	mov    (%eax),%eax
  802326:	eb 05                	jmp    80232d <insert_sorted_allocList+0x1e9>
  802328:	b8 00 00 00 00       	mov    $0x0,%eax
  80232d:	a3 48 40 80 00       	mov    %eax,0x804048
  802332:	a1 48 40 80 00       	mov    0x804048,%eax
  802337:	85 c0                	test   %eax,%eax
  802339:	75 8f                	jne    8022ca <insert_sorted_allocList+0x186>
  80233b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80233f:	75 89                	jne    8022ca <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802341:	90                   	nop
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80234a:	a1 38 41 80 00       	mov    0x804138,%eax
  80234f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802352:	e9 76 01 00 00       	jmp    8024cd <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 0c             	mov    0xc(%eax),%eax
  80235d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802360:	0f 85 8a 00 00 00    	jne    8023f0 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80236a:	75 17                	jne    802383 <alloc_block_FF+0x3f>
  80236c:	83 ec 04             	sub    $0x4,%esp
  80236f:	68 6f 3c 80 00       	push   $0x803c6f
  802374:	68 8a 00 00 00       	push   $0x8a
  802379:	68 33 3c 80 00       	push   $0x803c33
  80237e:	e8 33 df ff ff       	call   8002b6 <_panic>
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 00                	mov    (%eax),%eax
  802388:	85 c0                	test   %eax,%eax
  80238a:	74 10                	je     80239c <alloc_block_FF+0x58>
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802394:	8b 52 04             	mov    0x4(%edx),%edx
  802397:	89 50 04             	mov    %edx,0x4(%eax)
  80239a:	eb 0b                	jmp    8023a7 <alloc_block_FF+0x63>
  80239c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239f:	8b 40 04             	mov    0x4(%eax),%eax
  8023a2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 40 04             	mov    0x4(%eax),%eax
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	74 0f                	je     8023c0 <alloc_block_FF+0x7c>
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 04             	mov    0x4(%eax),%eax
  8023b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ba:	8b 12                	mov    (%edx),%edx
  8023bc:	89 10                	mov    %edx,(%eax)
  8023be:	eb 0a                	jmp    8023ca <alloc_block_FF+0x86>
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	8b 00                	mov    (%eax),%eax
  8023c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023dd:	a1 44 41 80 00       	mov    0x804144,%eax
  8023e2:	48                   	dec    %eax
  8023e3:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8023e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023eb:	e9 10 01 00 00       	jmp    802500 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f9:	0f 86 c6 00 00 00    	jbe    8024c5 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8023ff:	a1 48 41 80 00       	mov    0x804148,%eax
  802404:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802407:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80240b:	75 17                	jne    802424 <alloc_block_FF+0xe0>
  80240d:	83 ec 04             	sub    $0x4,%esp
  802410:	68 6f 3c 80 00       	push   $0x803c6f
  802415:	68 90 00 00 00       	push   $0x90
  80241a:	68 33 3c 80 00       	push   $0x803c33
  80241f:	e8 92 de ff ff       	call   8002b6 <_panic>
  802424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802427:	8b 00                	mov    (%eax),%eax
  802429:	85 c0                	test   %eax,%eax
  80242b:	74 10                	je     80243d <alloc_block_FF+0xf9>
  80242d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802430:	8b 00                	mov    (%eax),%eax
  802432:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802435:	8b 52 04             	mov    0x4(%edx),%edx
  802438:	89 50 04             	mov    %edx,0x4(%eax)
  80243b:	eb 0b                	jmp    802448 <alloc_block_FF+0x104>
  80243d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802440:	8b 40 04             	mov    0x4(%eax),%eax
  802443:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	85 c0                	test   %eax,%eax
  802450:	74 0f                	je     802461 <alloc_block_FF+0x11d>
  802452:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802455:	8b 40 04             	mov    0x4(%eax),%eax
  802458:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80245b:	8b 12                	mov    (%edx),%edx
  80245d:	89 10                	mov    %edx,(%eax)
  80245f:	eb 0a                	jmp    80246b <alloc_block_FF+0x127>
  802461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802464:	8b 00                	mov    (%eax),%eax
  802466:	a3 48 41 80 00       	mov    %eax,0x804148
  80246b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802477:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80247e:	a1 54 41 80 00       	mov    0x804154,%eax
  802483:	48                   	dec    %eax
  802484:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248c:	8b 55 08             	mov    0x8(%ebp),%edx
  80248f:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 50 08             	mov    0x8(%eax),%edx
  802498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249b:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80249e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a1:	8b 50 08             	mov    0x8(%eax),%edx
  8024a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a7:	01 c2                	add    %eax,%edx
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8024b8:	89 c2                	mov    %eax,%edx
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	eb 3b                	jmp    802500 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8024c5:	a1 40 41 80 00       	mov    0x804140,%eax
  8024ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024d1:	74 07                	je     8024da <alloc_block_FF+0x196>
  8024d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	eb 05                	jmp    8024df <alloc_block_FF+0x19b>
  8024da:	b8 00 00 00 00       	mov    $0x0,%eax
  8024df:	a3 40 41 80 00       	mov    %eax,0x804140
  8024e4:	a1 40 41 80 00       	mov    0x804140,%eax
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	0f 85 66 fe ff ff    	jne    802357 <alloc_block_FF+0x13>
  8024f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f5:	0f 85 5c fe ff ff    	jne    802357 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8024fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802500:	c9                   	leave  
  802501:	c3                   	ret    

00802502 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802502:	55                   	push   %ebp
  802503:	89 e5                	mov    %esp,%ebp
  802505:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802508:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80250f:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802516:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80251d:	a1 38 41 80 00       	mov    0x804138,%eax
  802522:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802525:	e9 cf 00 00 00       	jmp    8025f9 <alloc_block_BF+0xf7>
		{
			c++;
  80252a:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 0c             	mov    0xc(%eax),%eax
  802533:	3b 45 08             	cmp    0x8(%ebp),%eax
  802536:	0f 85 8a 00 00 00    	jne    8025c6 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80253c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802540:	75 17                	jne    802559 <alloc_block_BF+0x57>
  802542:	83 ec 04             	sub    $0x4,%esp
  802545:	68 6f 3c 80 00       	push   $0x803c6f
  80254a:	68 a8 00 00 00       	push   $0xa8
  80254f:	68 33 3c 80 00       	push   $0x803c33
  802554:	e8 5d dd ff ff       	call   8002b6 <_panic>
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	8b 00                	mov    (%eax),%eax
  80255e:	85 c0                	test   %eax,%eax
  802560:	74 10                	je     802572 <alloc_block_BF+0x70>
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256a:	8b 52 04             	mov    0x4(%edx),%edx
  80256d:	89 50 04             	mov    %edx,0x4(%eax)
  802570:	eb 0b                	jmp    80257d <alloc_block_BF+0x7b>
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 40 04             	mov    0x4(%eax),%eax
  802583:	85 c0                	test   %eax,%eax
  802585:	74 0f                	je     802596 <alloc_block_BF+0x94>
  802587:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258a:	8b 40 04             	mov    0x4(%eax),%eax
  80258d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802590:	8b 12                	mov    (%edx),%edx
  802592:	89 10                	mov    %edx,(%eax)
  802594:	eb 0a                	jmp    8025a0 <alloc_block_BF+0x9e>
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	a3 38 41 80 00       	mov    %eax,0x804138
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8025b8:	48                   	dec    %eax
  8025b9:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	e9 85 01 00 00       	jmp    80274b <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8025cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025cf:	76 20                	jbe    8025f1 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d7:	2b 45 08             	sub    0x8(%ebp),%eax
  8025da:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8025dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025e0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8025e3:	73 0c                	jae    8025f1 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8025e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8025eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025f1:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fd:	74 07                	je     802606 <alloc_block_BF+0x104>
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	8b 00                	mov    (%eax),%eax
  802604:	eb 05                	jmp    80260b <alloc_block_BF+0x109>
  802606:	b8 00 00 00 00       	mov    $0x0,%eax
  80260b:	a3 40 41 80 00       	mov    %eax,0x804140
  802610:	a1 40 41 80 00       	mov    0x804140,%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	0f 85 0d ff ff ff    	jne    80252a <alloc_block_BF+0x28>
  80261d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802621:	0f 85 03 ff ff ff    	jne    80252a <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802627:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80262e:	a1 38 41 80 00       	mov    0x804138,%eax
  802633:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802636:	e9 dd 00 00 00       	jmp    802718 <alloc_block_BF+0x216>
		{
			if(x==sol)
  80263b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80263e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802641:	0f 85 c6 00 00 00    	jne    80270d <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802647:	a1 48 41 80 00       	mov    0x804148,%eax
  80264c:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80264f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802653:	75 17                	jne    80266c <alloc_block_BF+0x16a>
  802655:	83 ec 04             	sub    $0x4,%esp
  802658:	68 6f 3c 80 00       	push   $0x803c6f
  80265d:	68 bb 00 00 00       	push   $0xbb
  802662:	68 33 3c 80 00       	push   $0x803c33
  802667:	e8 4a dc ff ff       	call   8002b6 <_panic>
  80266c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	85 c0                	test   %eax,%eax
  802673:	74 10                	je     802685 <alloc_block_BF+0x183>
  802675:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802678:	8b 00                	mov    (%eax),%eax
  80267a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80267d:	8b 52 04             	mov    0x4(%edx),%edx
  802680:	89 50 04             	mov    %edx,0x4(%eax)
  802683:	eb 0b                	jmp    802690 <alloc_block_BF+0x18e>
  802685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802688:	8b 40 04             	mov    0x4(%eax),%eax
  80268b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802690:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802693:	8b 40 04             	mov    0x4(%eax),%eax
  802696:	85 c0                	test   %eax,%eax
  802698:	74 0f                	je     8026a9 <alloc_block_BF+0x1a7>
  80269a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269d:	8b 40 04             	mov    0x4(%eax),%eax
  8026a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026a3:	8b 12                	mov    (%edx),%edx
  8026a5:	89 10                	mov    %edx,(%eax)
  8026a7:	eb 0a                	jmp    8026b3 <alloc_block_BF+0x1b1>
  8026a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	a3 48 41 80 00       	mov    %eax,0x804148
  8026b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c6:	a1 54 41 80 00       	mov    0x804154,%eax
  8026cb:	48                   	dec    %eax
  8026cc:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8026d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d7:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8026da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dd:	8b 50 08             	mov    0x8(%eax),%edx
  8026e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e3:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 50 08             	mov    0x8(%eax),%edx
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	01 c2                	add    %eax,%edx
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8026f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fd:	2b 45 08             	sub    0x8(%ebp),%eax
  802700:	89 c2                	mov    %eax,%edx
  802702:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802705:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270b:	eb 3e                	jmp    80274b <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80270d:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802710:	a1 40 41 80 00       	mov    0x804140,%eax
  802715:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802718:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80271c:	74 07                	je     802725 <alloc_block_BF+0x223>
  80271e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802721:	8b 00                	mov    (%eax),%eax
  802723:	eb 05                	jmp    80272a <alloc_block_BF+0x228>
  802725:	b8 00 00 00 00       	mov    $0x0,%eax
  80272a:	a3 40 41 80 00       	mov    %eax,0x804140
  80272f:	a1 40 41 80 00       	mov    0x804140,%eax
  802734:	85 c0                	test   %eax,%eax
  802736:	0f 85 ff fe ff ff    	jne    80263b <alloc_block_BF+0x139>
  80273c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802740:	0f 85 f5 fe ff ff    	jne    80263b <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802746:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274b:	c9                   	leave  
  80274c:	c3                   	ret    

0080274d <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  80274d:	55                   	push   %ebp
  80274e:	89 e5                	mov    %esp,%ebp
  802750:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802753:	a1 28 40 80 00       	mov    0x804028,%eax
  802758:	85 c0                	test   %eax,%eax
  80275a:	75 14                	jne    802770 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80275c:	a1 38 41 80 00       	mov    0x804138,%eax
  802761:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802766:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  80276d:	00 00 00 
	}
	uint32 c=1;
  802770:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802777:	a1 60 41 80 00       	mov    0x804160,%eax
  80277c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80277f:	e9 b3 01 00 00       	jmp    802937 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802784:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802787:	8b 40 0c             	mov    0xc(%eax),%eax
  80278a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80278d:	0f 85 a9 00 00 00    	jne    80283c <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	85 c0                	test   %eax,%eax
  80279a:	75 0c                	jne    8027a8 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80279c:	a1 38 41 80 00       	mov    0x804138,%eax
  8027a1:	a3 60 41 80 00       	mov    %eax,0x804160
  8027a6:	eb 0a                	jmp    8027b2 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8027a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ab:	8b 00                	mov    (%eax),%eax
  8027ad:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8027b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027b6:	75 17                	jne    8027cf <alloc_block_NF+0x82>
  8027b8:	83 ec 04             	sub    $0x4,%esp
  8027bb:	68 6f 3c 80 00       	push   $0x803c6f
  8027c0:	68 e3 00 00 00       	push   $0xe3
  8027c5:	68 33 3c 80 00       	push   $0x803c33
  8027ca:	e8 e7 da ff ff       	call   8002b6 <_panic>
  8027cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	85 c0                	test   %eax,%eax
  8027d6:	74 10                	je     8027e8 <alloc_block_NF+0x9b>
  8027d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027db:	8b 00                	mov    (%eax),%eax
  8027dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027e0:	8b 52 04             	mov    0x4(%edx),%edx
  8027e3:	89 50 04             	mov    %edx,0x4(%eax)
  8027e6:	eb 0b                	jmp    8027f3 <alloc_block_NF+0xa6>
  8027e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027eb:	8b 40 04             	mov    0x4(%eax),%eax
  8027ee:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f6:	8b 40 04             	mov    0x4(%eax),%eax
  8027f9:	85 c0                	test   %eax,%eax
  8027fb:	74 0f                	je     80280c <alloc_block_NF+0xbf>
  8027fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802800:	8b 40 04             	mov    0x4(%eax),%eax
  802803:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802806:	8b 12                	mov    (%edx),%edx
  802808:	89 10                	mov    %edx,(%eax)
  80280a:	eb 0a                	jmp    802816 <alloc_block_NF+0xc9>
  80280c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280f:	8b 00                	mov    (%eax),%eax
  802811:	a3 38 41 80 00       	mov    %eax,0x804138
  802816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802819:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802822:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802829:	a1 44 41 80 00       	mov    0x804144,%eax
  80282e:	48                   	dec    %eax
  80282f:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802834:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802837:	e9 0e 01 00 00       	jmp    80294a <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80283c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283f:	8b 40 0c             	mov    0xc(%eax),%eax
  802842:	3b 45 08             	cmp    0x8(%ebp),%eax
  802845:	0f 86 ce 00 00 00    	jbe    802919 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80284b:	a1 48 41 80 00       	mov    0x804148,%eax
  802850:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802853:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802857:	75 17                	jne    802870 <alloc_block_NF+0x123>
  802859:	83 ec 04             	sub    $0x4,%esp
  80285c:	68 6f 3c 80 00       	push   $0x803c6f
  802861:	68 e9 00 00 00       	push   $0xe9
  802866:	68 33 3c 80 00       	push   $0x803c33
  80286b:	e8 46 da ff ff       	call   8002b6 <_panic>
  802870:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802873:	8b 00                	mov    (%eax),%eax
  802875:	85 c0                	test   %eax,%eax
  802877:	74 10                	je     802889 <alloc_block_NF+0x13c>
  802879:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287c:	8b 00                	mov    (%eax),%eax
  80287e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802881:	8b 52 04             	mov    0x4(%edx),%edx
  802884:	89 50 04             	mov    %edx,0x4(%eax)
  802887:	eb 0b                	jmp    802894 <alloc_block_NF+0x147>
  802889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288c:	8b 40 04             	mov    0x4(%eax),%eax
  80288f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	8b 40 04             	mov    0x4(%eax),%eax
  80289a:	85 c0                	test   %eax,%eax
  80289c:	74 0f                	je     8028ad <alloc_block_NF+0x160>
  80289e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a1:	8b 40 04             	mov    0x4(%eax),%eax
  8028a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028a7:	8b 12                	mov    (%edx),%edx
  8028a9:	89 10                	mov    %edx,(%eax)
  8028ab:	eb 0a                	jmp    8028b7 <alloc_block_NF+0x16a>
  8028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b0:	8b 00                	mov    (%eax),%eax
  8028b2:	a3 48 41 80 00       	mov    %eax,0x804148
  8028b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ca:	a1 54 41 80 00       	mov    0x804154,%eax
  8028cf:	48                   	dec    %eax
  8028d0:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8028d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8028db:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8028de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e1:	8b 50 08             	mov    0x8(%eax),%edx
  8028e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e7:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ed:	8b 50 08             	mov    0x8(%eax),%edx
  8028f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f3:	01 c2                	add    %eax,%edx
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8028fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802901:	2b 45 08             	sub    0x8(%ebp),%eax
  802904:	89 c2                	mov    %eax,%edx
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80290c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290f:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802914:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802917:	eb 31                	jmp    80294a <alloc_block_NF+0x1fd>
			 }
		 c++;
  802919:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80291c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291f:	8b 00                	mov    (%eax),%eax
  802921:	85 c0                	test   %eax,%eax
  802923:	75 0a                	jne    80292f <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802925:	a1 38 41 80 00       	mov    0x804138,%eax
  80292a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80292d:	eb 08                	jmp    802937 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	8b 00                	mov    (%eax),%eax
  802934:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802937:	a1 44 41 80 00       	mov    0x804144,%eax
  80293c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80293f:	0f 85 3f fe ff ff    	jne    802784 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802945:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80294a:	c9                   	leave  
  80294b:	c3                   	ret    

0080294c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80294c:	55                   	push   %ebp
  80294d:	89 e5                	mov    %esp,%ebp
  80294f:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802952:	a1 44 41 80 00       	mov    0x804144,%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	75 68                	jne    8029c3 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80295b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80295f:	75 17                	jne    802978 <insert_sorted_with_merge_freeList+0x2c>
  802961:	83 ec 04             	sub    $0x4,%esp
  802964:	68 10 3c 80 00       	push   $0x803c10
  802969:	68 0e 01 00 00       	push   $0x10e
  80296e:	68 33 3c 80 00       	push   $0x803c33
  802973:	e8 3e d9 ff ff       	call   8002b6 <_panic>
  802978:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80297e:	8b 45 08             	mov    0x8(%ebp),%eax
  802981:	89 10                	mov    %edx,(%eax)
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	8b 00                	mov    (%eax),%eax
  802988:	85 c0                	test   %eax,%eax
  80298a:	74 0d                	je     802999 <insert_sorted_with_merge_freeList+0x4d>
  80298c:	a1 38 41 80 00       	mov    0x804138,%eax
  802991:	8b 55 08             	mov    0x8(%ebp),%edx
  802994:	89 50 04             	mov    %edx,0x4(%eax)
  802997:	eb 08                	jmp    8029a1 <insert_sorted_with_merge_freeList+0x55>
  802999:	8b 45 08             	mov    0x8(%ebp),%eax
  80299c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8029b8:	40                   	inc    %eax
  8029b9:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8029be:	e9 8c 06 00 00       	jmp    80304f <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8029c3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8029cb:	a1 38 41 80 00       	mov    0x804138,%eax
  8029d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  8029d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d6:	8b 50 08             	mov    0x8(%eax),%edx
  8029d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029dc:	8b 40 08             	mov    0x8(%eax),%eax
  8029df:	39 c2                	cmp    %eax,%edx
  8029e1:	0f 86 14 01 00 00    	jbe    802afb <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8029e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ea:	8b 50 0c             	mov    0xc(%eax),%edx
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	8b 40 08             	mov    0x8(%eax),%eax
  8029f3:	01 c2                	add    %eax,%edx
  8029f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f8:	8b 40 08             	mov    0x8(%eax),%eax
  8029fb:	39 c2                	cmp    %eax,%edx
  8029fd:	0f 85 90 00 00 00    	jne    802a93 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a06:	8b 50 0c             	mov    0xc(%eax),%edx
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0f:	01 c2                	add    %eax,%edx
  802a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a14:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a2f:	75 17                	jne    802a48 <insert_sorted_with_merge_freeList+0xfc>
  802a31:	83 ec 04             	sub    $0x4,%esp
  802a34:	68 10 3c 80 00       	push   $0x803c10
  802a39:	68 1b 01 00 00       	push   $0x11b
  802a3e:	68 33 3c 80 00       	push   $0x803c33
  802a43:	e8 6e d8 ff ff       	call   8002b6 <_panic>
  802a48:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	89 10                	mov    %edx,(%eax)
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	8b 00                	mov    (%eax),%eax
  802a58:	85 c0                	test   %eax,%eax
  802a5a:	74 0d                	je     802a69 <insert_sorted_with_merge_freeList+0x11d>
  802a5c:	a1 48 41 80 00       	mov    0x804148,%eax
  802a61:	8b 55 08             	mov    0x8(%ebp),%edx
  802a64:	89 50 04             	mov    %edx,0x4(%eax)
  802a67:	eb 08                	jmp    802a71 <insert_sorted_with_merge_freeList+0x125>
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	a3 48 41 80 00       	mov    %eax,0x804148
  802a79:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a83:	a1 54 41 80 00       	mov    0x804154,%eax
  802a88:	40                   	inc    %eax
  802a89:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802a8e:	e9 bc 05 00 00       	jmp    80304f <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a93:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a97:	75 17                	jne    802ab0 <insert_sorted_with_merge_freeList+0x164>
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	68 4c 3c 80 00       	push   $0x803c4c
  802aa1:	68 1f 01 00 00       	push   $0x11f
  802aa6:	68 33 3c 80 00       	push   $0x803c33
  802aab:	e8 06 d8 ff ff       	call   8002b6 <_panic>
  802ab0:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	89 50 04             	mov    %edx,0x4(%eax)
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	8b 40 04             	mov    0x4(%eax),%eax
  802ac2:	85 c0                	test   %eax,%eax
  802ac4:	74 0c                	je     802ad2 <insert_sorted_with_merge_freeList+0x186>
  802ac6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802acb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ace:	89 10                	mov    %edx,(%eax)
  802ad0:	eb 08                	jmp    802ada <insert_sorted_with_merge_freeList+0x18e>
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	a3 38 41 80 00       	mov    %eax,0x804138
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aeb:	a1 44 41 80 00       	mov    0x804144,%eax
  802af0:	40                   	inc    %eax
  802af1:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802af6:	e9 54 05 00 00       	jmp    80304f <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	8b 50 08             	mov    0x8(%eax),%edx
  802b01:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b04:	8b 40 08             	mov    0x8(%eax),%eax
  802b07:	39 c2                	cmp    %eax,%edx
  802b09:	0f 83 20 01 00 00    	jae    802c2f <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	8b 50 0c             	mov    0xc(%eax),%edx
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	8b 40 08             	mov    0x8(%eax),%eax
  802b1b:	01 c2                	add    %eax,%edx
  802b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b20:	8b 40 08             	mov    0x8(%eax),%eax
  802b23:	39 c2                	cmp    %eax,%edx
  802b25:	0f 85 9c 00 00 00    	jne    802bc7 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2e:	8b 50 08             	mov    0x8(%eax),%edx
  802b31:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b34:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b3a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	8b 40 0c             	mov    0xc(%eax),%eax
  802b43:	01 c2                	add    %eax,%edx
  802b45:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b48:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b63:	75 17                	jne    802b7c <insert_sorted_with_merge_freeList+0x230>
  802b65:	83 ec 04             	sub    $0x4,%esp
  802b68:	68 10 3c 80 00       	push   $0x803c10
  802b6d:	68 2a 01 00 00       	push   $0x12a
  802b72:	68 33 3c 80 00       	push   $0x803c33
  802b77:	e8 3a d7 ff ff       	call   8002b6 <_panic>
  802b7c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	89 10                	mov    %edx,(%eax)
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	8b 00                	mov    (%eax),%eax
  802b8c:	85 c0                	test   %eax,%eax
  802b8e:	74 0d                	je     802b9d <insert_sorted_with_merge_freeList+0x251>
  802b90:	a1 48 41 80 00       	mov    0x804148,%eax
  802b95:	8b 55 08             	mov    0x8(%ebp),%edx
  802b98:	89 50 04             	mov    %edx,0x4(%eax)
  802b9b:	eb 08                	jmp    802ba5 <insert_sorted_with_merge_freeList+0x259>
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba8:	a3 48 41 80 00       	mov    %eax,0x804148
  802bad:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bb7:	a1 54 41 80 00       	mov    0x804154,%eax
  802bbc:	40                   	inc    %eax
  802bbd:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802bc2:	e9 88 04 00 00       	jmp    80304f <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bc7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bcb:	75 17                	jne    802be4 <insert_sorted_with_merge_freeList+0x298>
  802bcd:	83 ec 04             	sub    $0x4,%esp
  802bd0:	68 10 3c 80 00       	push   $0x803c10
  802bd5:	68 2e 01 00 00       	push   $0x12e
  802bda:	68 33 3c 80 00       	push   $0x803c33
  802bdf:	e8 d2 d6 ff ff       	call   8002b6 <_panic>
  802be4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bea:	8b 45 08             	mov    0x8(%ebp),%eax
  802bed:	89 10                	mov    %edx,(%eax)
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	8b 00                	mov    (%eax),%eax
  802bf4:	85 c0                	test   %eax,%eax
  802bf6:	74 0d                	je     802c05 <insert_sorted_with_merge_freeList+0x2b9>
  802bf8:	a1 38 41 80 00       	mov    0x804138,%eax
  802bfd:	8b 55 08             	mov    0x8(%ebp),%edx
  802c00:	89 50 04             	mov    %edx,0x4(%eax)
  802c03:	eb 08                	jmp    802c0d <insert_sorted_with_merge_freeList+0x2c1>
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	a3 38 41 80 00       	mov    %eax,0x804138
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c1f:	a1 44 41 80 00       	mov    0x804144,%eax
  802c24:	40                   	inc    %eax
  802c25:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c2a:	e9 20 04 00 00       	jmp    80304f <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802c2f:	a1 38 41 80 00       	mov    0x804138,%eax
  802c34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c37:	e9 e2 03 00 00       	jmp    80301e <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 50 08             	mov    0x8(%eax),%edx
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	8b 40 08             	mov    0x8(%eax),%eax
  802c48:	39 c2                	cmp    %eax,%edx
  802c4a:	0f 83 c6 03 00 00    	jae    803016 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c53:	8b 40 04             	mov    0x4(%eax),%eax
  802c56:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c59:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c5c:	8b 50 08             	mov    0x8(%eax),%edx
  802c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c62:	8b 40 0c             	mov    0xc(%eax),%eax
  802c65:	01 d0                	add    %edx,%eax
  802c67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c70:	8b 45 08             	mov    0x8(%ebp),%eax
  802c73:	8b 40 08             	mov    0x8(%eax),%eax
  802c76:	01 d0                	add    %edx,%eax
  802c78:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	8b 40 08             	mov    0x8(%eax),%eax
  802c81:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c84:	74 7a                	je     802d00 <insert_sorted_with_merge_freeList+0x3b4>
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 40 08             	mov    0x8(%eax),%eax
  802c8c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c8f:	74 6f                	je     802d00 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802c91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c95:	74 06                	je     802c9d <insert_sorted_with_merge_freeList+0x351>
  802c97:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9b:	75 17                	jne    802cb4 <insert_sorted_with_merge_freeList+0x368>
  802c9d:	83 ec 04             	sub    $0x4,%esp
  802ca0:	68 90 3c 80 00       	push   $0x803c90
  802ca5:	68 43 01 00 00       	push   $0x143
  802caa:	68 33 3c 80 00       	push   $0x803c33
  802caf:	e8 02 d6 ff ff       	call   8002b6 <_panic>
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 50 04             	mov    0x4(%eax),%edx
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	89 50 04             	mov    %edx,0x4(%eax)
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cc6:	89 10                	mov    %edx,(%eax)
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	74 0d                	je     802cdf <insert_sorted_with_merge_freeList+0x393>
  802cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd5:	8b 40 04             	mov    0x4(%eax),%eax
  802cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  802cdb:	89 10                	mov    %edx,(%eax)
  802cdd:	eb 08                	jmp    802ce7 <insert_sorted_with_merge_freeList+0x39b>
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	a3 38 41 80 00       	mov    %eax,0x804138
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 55 08             	mov    0x8(%ebp),%edx
  802ced:	89 50 04             	mov    %edx,0x4(%eax)
  802cf0:	a1 44 41 80 00       	mov    0x804144,%eax
  802cf5:	40                   	inc    %eax
  802cf6:	a3 44 41 80 00       	mov    %eax,0x804144
  802cfb:	e9 14 03 00 00       	jmp    803014 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	8b 40 08             	mov    0x8(%eax),%eax
  802d06:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d09:	0f 85 a0 01 00 00    	jne    802eaf <insert_sorted_with_merge_freeList+0x563>
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 40 08             	mov    0x8(%eax),%eax
  802d15:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d18:	0f 85 91 01 00 00    	jne    802eaf <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802d1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d21:	8b 50 0c             	mov    0xc(%eax),%edx
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d30:	01 c8                	add    %ecx,%eax
  802d32:	01 c2                	add    %eax,%edx
  802d34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d37:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d51:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d66:	75 17                	jne    802d7f <insert_sorted_with_merge_freeList+0x433>
  802d68:	83 ec 04             	sub    $0x4,%esp
  802d6b:	68 10 3c 80 00       	push   $0x803c10
  802d70:	68 4d 01 00 00       	push   $0x14d
  802d75:	68 33 3c 80 00       	push   $0x803c33
  802d7a:	e8 37 d5 ff ff       	call   8002b6 <_panic>
  802d7f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d85:	8b 45 08             	mov    0x8(%ebp),%eax
  802d88:	89 10                	mov    %edx,(%eax)
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 00                	mov    (%eax),%eax
  802d8f:	85 c0                	test   %eax,%eax
  802d91:	74 0d                	je     802da0 <insert_sorted_with_merge_freeList+0x454>
  802d93:	a1 48 41 80 00       	mov    0x804148,%eax
  802d98:	8b 55 08             	mov    0x8(%ebp),%edx
  802d9b:	89 50 04             	mov    %edx,0x4(%eax)
  802d9e:	eb 08                	jmp    802da8 <insert_sorted_with_merge_freeList+0x45c>
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802da8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dab:	a3 48 41 80 00       	mov    %eax,0x804148
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dba:	a1 54 41 80 00       	mov    0x804154,%eax
  802dbf:	40                   	inc    %eax
  802dc0:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dc9:	75 17                	jne    802de2 <insert_sorted_with_merge_freeList+0x496>
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	68 6f 3c 80 00       	push   $0x803c6f
  802dd3:	68 4e 01 00 00       	push   $0x14e
  802dd8:	68 33 3c 80 00       	push   $0x803c33
  802ddd:	e8 d4 d4 ff ff       	call   8002b6 <_panic>
  802de2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de5:	8b 00                	mov    (%eax),%eax
  802de7:	85 c0                	test   %eax,%eax
  802de9:	74 10                	je     802dfb <insert_sorted_with_merge_freeList+0x4af>
  802deb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dee:	8b 00                	mov    (%eax),%eax
  802df0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802df3:	8b 52 04             	mov    0x4(%edx),%edx
  802df6:	89 50 04             	mov    %edx,0x4(%eax)
  802df9:	eb 0b                	jmp    802e06 <insert_sorted_with_merge_freeList+0x4ba>
  802dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfe:	8b 40 04             	mov    0x4(%eax),%eax
  802e01:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 40 04             	mov    0x4(%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0f                	je     802e1f <insert_sorted_with_merge_freeList+0x4d3>
  802e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e13:	8b 40 04             	mov    0x4(%eax),%eax
  802e16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e19:	8b 12                	mov    (%edx),%edx
  802e1b:	89 10                	mov    %edx,(%eax)
  802e1d:	eb 0a                	jmp    802e29 <insert_sorted_with_merge_freeList+0x4dd>
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	a3 38 41 80 00       	mov    %eax,0x804138
  802e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e3c:	a1 44 41 80 00       	mov    0x804144,%eax
  802e41:	48                   	dec    %eax
  802e42:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4b:	75 17                	jne    802e64 <insert_sorted_with_merge_freeList+0x518>
  802e4d:	83 ec 04             	sub    $0x4,%esp
  802e50:	68 10 3c 80 00       	push   $0x803c10
  802e55:	68 4f 01 00 00       	push   $0x14f
  802e5a:	68 33 3c 80 00       	push   $0x803c33
  802e5f:	e8 52 d4 ff ff       	call   8002b6 <_panic>
  802e64:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	89 10                	mov    %edx,(%eax)
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 00                	mov    (%eax),%eax
  802e74:	85 c0                	test   %eax,%eax
  802e76:	74 0d                	je     802e85 <insert_sorted_with_merge_freeList+0x539>
  802e78:	a1 48 41 80 00       	mov    0x804148,%eax
  802e7d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e80:	89 50 04             	mov    %edx,0x4(%eax)
  802e83:	eb 08                	jmp    802e8d <insert_sorted_with_merge_freeList+0x541>
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e90:	a3 48 41 80 00       	mov    %eax,0x804148
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9f:	a1 54 41 80 00       	mov    0x804154,%eax
  802ea4:	40                   	inc    %eax
  802ea5:	a3 54 41 80 00       	mov    %eax,0x804154
  802eaa:	e9 65 01 00 00       	jmp    803014 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb2:	8b 40 08             	mov    0x8(%eax),%eax
  802eb5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802eb8:	0f 85 9f 00 00 00    	jne    802f5d <insert_sorted_with_merge_freeList+0x611>
  802ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec1:	8b 40 08             	mov    0x8(%eax),%eax
  802ec4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ec7:	0f 84 90 00 00 00    	je     802f5d <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ed0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed9:	01 c2                	add    %eax,%edx
  802edb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ede:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  802eee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802ef5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ef9:	75 17                	jne    802f12 <insert_sorted_with_merge_freeList+0x5c6>
  802efb:	83 ec 04             	sub    $0x4,%esp
  802efe:	68 10 3c 80 00       	push   $0x803c10
  802f03:	68 58 01 00 00       	push   $0x158
  802f08:	68 33 3c 80 00       	push   $0x803c33
  802f0d:	e8 a4 d3 ff ff       	call   8002b6 <_panic>
  802f12:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	89 10                	mov    %edx,(%eax)
  802f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f20:	8b 00                	mov    (%eax),%eax
  802f22:	85 c0                	test   %eax,%eax
  802f24:	74 0d                	je     802f33 <insert_sorted_with_merge_freeList+0x5e7>
  802f26:	a1 48 41 80 00       	mov    0x804148,%eax
  802f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802f2e:	89 50 04             	mov    %edx,0x4(%eax)
  802f31:	eb 08                	jmp    802f3b <insert_sorted_with_merge_freeList+0x5ef>
  802f33:	8b 45 08             	mov    0x8(%ebp),%eax
  802f36:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	a3 48 41 80 00       	mov    %eax,0x804148
  802f43:	8b 45 08             	mov    0x8(%ebp),%eax
  802f46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f4d:	a1 54 41 80 00       	mov    0x804154,%eax
  802f52:	40                   	inc    %eax
  802f53:	a3 54 41 80 00       	mov    %eax,0x804154
  802f58:	e9 b7 00 00 00       	jmp    803014 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f60:	8b 40 08             	mov    0x8(%eax),%eax
  802f63:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f66:	0f 84 e2 00 00 00    	je     80304e <insert_sorted_with_merge_freeList+0x702>
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	8b 40 08             	mov    0x8(%eax),%eax
  802f72:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f75:	0f 85 d3 00 00 00    	jne    80304e <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7e:	8b 50 08             	mov    0x8(%eax),%edx
  802f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f84:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	8b 40 0c             	mov    0xc(%eax),%eax
  802f93:	01 c2                	add    %eax,%edx
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802faf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb3:	75 17                	jne    802fcc <insert_sorted_with_merge_freeList+0x680>
  802fb5:	83 ec 04             	sub    $0x4,%esp
  802fb8:	68 10 3c 80 00       	push   $0x803c10
  802fbd:	68 61 01 00 00       	push   $0x161
  802fc2:	68 33 3c 80 00       	push   $0x803c33
  802fc7:	e8 ea d2 ff ff       	call   8002b6 <_panic>
  802fcc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	89 10                	mov    %edx,(%eax)
  802fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802fda:	8b 00                	mov    (%eax),%eax
  802fdc:	85 c0                	test   %eax,%eax
  802fde:	74 0d                	je     802fed <insert_sorted_with_merge_freeList+0x6a1>
  802fe0:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe8:	89 50 04             	mov    %edx,0x4(%eax)
  802feb:	eb 08                	jmp    802ff5 <insert_sorted_with_merge_freeList+0x6a9>
  802fed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff8:	a3 48 41 80 00       	mov    %eax,0x804148
  802ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  803000:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803007:	a1 54 41 80 00       	mov    0x804154,%eax
  80300c:	40                   	inc    %eax
  80300d:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803012:	eb 3a                	jmp    80304e <insert_sorted_with_merge_freeList+0x702>
  803014:	eb 38                	jmp    80304e <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803016:	a1 40 41 80 00       	mov    0x804140,%eax
  80301b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80301e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803022:	74 07                	je     80302b <insert_sorted_with_merge_freeList+0x6df>
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 00                	mov    (%eax),%eax
  803029:	eb 05                	jmp    803030 <insert_sorted_with_merge_freeList+0x6e4>
  80302b:	b8 00 00 00 00       	mov    $0x0,%eax
  803030:	a3 40 41 80 00       	mov    %eax,0x804140
  803035:	a1 40 41 80 00       	mov    0x804140,%eax
  80303a:	85 c0                	test   %eax,%eax
  80303c:	0f 85 fa fb ff ff    	jne    802c3c <insert_sorted_with_merge_freeList+0x2f0>
  803042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803046:	0f 85 f0 fb ff ff    	jne    802c3c <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80304c:	eb 01                	jmp    80304f <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  80304e:	90                   	nop
							}

						}
		          }
		}
}
  80304f:	90                   	nop
  803050:	c9                   	leave  
  803051:	c3                   	ret    

00803052 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803052:	55                   	push   %ebp
  803053:	89 e5                	mov    %esp,%ebp
  803055:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803058:	8b 55 08             	mov    0x8(%ebp),%edx
  80305b:	89 d0                	mov    %edx,%eax
  80305d:	c1 e0 02             	shl    $0x2,%eax
  803060:	01 d0                	add    %edx,%eax
  803062:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803069:	01 d0                	add    %edx,%eax
  80306b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803072:	01 d0                	add    %edx,%eax
  803074:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80307b:	01 d0                	add    %edx,%eax
  80307d:	c1 e0 04             	shl    $0x4,%eax
  803080:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803083:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80308a:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80308d:	83 ec 0c             	sub    $0xc,%esp
  803090:	50                   	push   %eax
  803091:	e8 9c eb ff ff       	call   801c32 <sys_get_virtual_time>
  803096:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803099:	eb 41                	jmp    8030dc <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80309b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80309e:	83 ec 0c             	sub    $0xc,%esp
  8030a1:	50                   	push   %eax
  8030a2:	e8 8b eb ff ff       	call   801c32 <sys_get_virtual_time>
  8030a7:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030aa:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030b0:	29 c2                	sub    %eax,%edx
  8030b2:	89 d0                	mov    %edx,%eax
  8030b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bd:	89 d1                	mov    %edx,%ecx
  8030bf:	29 c1                	sub    %eax,%ecx
  8030c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030c7:	39 c2                	cmp    %eax,%edx
  8030c9:	0f 97 c0             	seta   %al
  8030cc:	0f b6 c0             	movzbl %al,%eax
  8030cf:	29 c1                	sub    %eax,%ecx
  8030d1:	89 c8                	mov    %ecx,%eax
  8030d3:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030e2:	72 b7                	jb     80309b <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030e4:	90                   	nop
  8030e5:	c9                   	leave  
  8030e6:	c3                   	ret    

008030e7 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030e7:	55                   	push   %ebp
  8030e8:	89 e5                	mov    %esp,%ebp
  8030ea:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030f4:	eb 03                	jmp    8030f9 <busy_wait+0x12>
  8030f6:	ff 45 fc             	incl   -0x4(%ebp)
  8030f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030fc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030ff:	72 f5                	jb     8030f6 <busy_wait+0xf>
	return i;
  803101:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803104:	c9                   	leave  
  803105:	c3                   	ret    
  803106:	66 90                	xchg   %ax,%ax

00803108 <__udivdi3>:
  803108:	55                   	push   %ebp
  803109:	57                   	push   %edi
  80310a:	56                   	push   %esi
  80310b:	53                   	push   %ebx
  80310c:	83 ec 1c             	sub    $0x1c,%esp
  80310f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803113:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803117:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80311b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80311f:	89 ca                	mov    %ecx,%edx
  803121:	89 f8                	mov    %edi,%eax
  803123:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803127:	85 f6                	test   %esi,%esi
  803129:	75 2d                	jne    803158 <__udivdi3+0x50>
  80312b:	39 cf                	cmp    %ecx,%edi
  80312d:	77 65                	ja     803194 <__udivdi3+0x8c>
  80312f:	89 fd                	mov    %edi,%ebp
  803131:	85 ff                	test   %edi,%edi
  803133:	75 0b                	jne    803140 <__udivdi3+0x38>
  803135:	b8 01 00 00 00       	mov    $0x1,%eax
  80313a:	31 d2                	xor    %edx,%edx
  80313c:	f7 f7                	div    %edi
  80313e:	89 c5                	mov    %eax,%ebp
  803140:	31 d2                	xor    %edx,%edx
  803142:	89 c8                	mov    %ecx,%eax
  803144:	f7 f5                	div    %ebp
  803146:	89 c1                	mov    %eax,%ecx
  803148:	89 d8                	mov    %ebx,%eax
  80314a:	f7 f5                	div    %ebp
  80314c:	89 cf                	mov    %ecx,%edi
  80314e:	89 fa                	mov    %edi,%edx
  803150:	83 c4 1c             	add    $0x1c,%esp
  803153:	5b                   	pop    %ebx
  803154:	5e                   	pop    %esi
  803155:	5f                   	pop    %edi
  803156:	5d                   	pop    %ebp
  803157:	c3                   	ret    
  803158:	39 ce                	cmp    %ecx,%esi
  80315a:	77 28                	ja     803184 <__udivdi3+0x7c>
  80315c:	0f bd fe             	bsr    %esi,%edi
  80315f:	83 f7 1f             	xor    $0x1f,%edi
  803162:	75 40                	jne    8031a4 <__udivdi3+0x9c>
  803164:	39 ce                	cmp    %ecx,%esi
  803166:	72 0a                	jb     803172 <__udivdi3+0x6a>
  803168:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80316c:	0f 87 9e 00 00 00    	ja     803210 <__udivdi3+0x108>
  803172:	b8 01 00 00 00       	mov    $0x1,%eax
  803177:	89 fa                	mov    %edi,%edx
  803179:	83 c4 1c             	add    $0x1c,%esp
  80317c:	5b                   	pop    %ebx
  80317d:	5e                   	pop    %esi
  80317e:	5f                   	pop    %edi
  80317f:	5d                   	pop    %ebp
  803180:	c3                   	ret    
  803181:	8d 76 00             	lea    0x0(%esi),%esi
  803184:	31 ff                	xor    %edi,%edi
  803186:	31 c0                	xor    %eax,%eax
  803188:	89 fa                	mov    %edi,%edx
  80318a:	83 c4 1c             	add    $0x1c,%esp
  80318d:	5b                   	pop    %ebx
  80318e:	5e                   	pop    %esi
  80318f:	5f                   	pop    %edi
  803190:	5d                   	pop    %ebp
  803191:	c3                   	ret    
  803192:	66 90                	xchg   %ax,%ax
  803194:	89 d8                	mov    %ebx,%eax
  803196:	f7 f7                	div    %edi
  803198:	31 ff                	xor    %edi,%edi
  80319a:	89 fa                	mov    %edi,%edx
  80319c:	83 c4 1c             	add    $0x1c,%esp
  80319f:	5b                   	pop    %ebx
  8031a0:	5e                   	pop    %esi
  8031a1:	5f                   	pop    %edi
  8031a2:	5d                   	pop    %ebp
  8031a3:	c3                   	ret    
  8031a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031a9:	89 eb                	mov    %ebp,%ebx
  8031ab:	29 fb                	sub    %edi,%ebx
  8031ad:	89 f9                	mov    %edi,%ecx
  8031af:	d3 e6                	shl    %cl,%esi
  8031b1:	89 c5                	mov    %eax,%ebp
  8031b3:	88 d9                	mov    %bl,%cl
  8031b5:	d3 ed                	shr    %cl,%ebp
  8031b7:	89 e9                	mov    %ebp,%ecx
  8031b9:	09 f1                	or     %esi,%ecx
  8031bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031bf:	89 f9                	mov    %edi,%ecx
  8031c1:	d3 e0                	shl    %cl,%eax
  8031c3:	89 c5                	mov    %eax,%ebp
  8031c5:	89 d6                	mov    %edx,%esi
  8031c7:	88 d9                	mov    %bl,%cl
  8031c9:	d3 ee                	shr    %cl,%esi
  8031cb:	89 f9                	mov    %edi,%ecx
  8031cd:	d3 e2                	shl    %cl,%edx
  8031cf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d3:	88 d9                	mov    %bl,%cl
  8031d5:	d3 e8                	shr    %cl,%eax
  8031d7:	09 c2                	or     %eax,%edx
  8031d9:	89 d0                	mov    %edx,%eax
  8031db:	89 f2                	mov    %esi,%edx
  8031dd:	f7 74 24 0c          	divl   0xc(%esp)
  8031e1:	89 d6                	mov    %edx,%esi
  8031e3:	89 c3                	mov    %eax,%ebx
  8031e5:	f7 e5                	mul    %ebp
  8031e7:	39 d6                	cmp    %edx,%esi
  8031e9:	72 19                	jb     803204 <__udivdi3+0xfc>
  8031eb:	74 0b                	je     8031f8 <__udivdi3+0xf0>
  8031ed:	89 d8                	mov    %ebx,%eax
  8031ef:	31 ff                	xor    %edi,%edi
  8031f1:	e9 58 ff ff ff       	jmp    80314e <__udivdi3+0x46>
  8031f6:	66 90                	xchg   %ax,%ax
  8031f8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031fc:	89 f9                	mov    %edi,%ecx
  8031fe:	d3 e2                	shl    %cl,%edx
  803200:	39 c2                	cmp    %eax,%edx
  803202:	73 e9                	jae    8031ed <__udivdi3+0xe5>
  803204:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803207:	31 ff                	xor    %edi,%edi
  803209:	e9 40 ff ff ff       	jmp    80314e <__udivdi3+0x46>
  80320e:	66 90                	xchg   %ax,%ax
  803210:	31 c0                	xor    %eax,%eax
  803212:	e9 37 ff ff ff       	jmp    80314e <__udivdi3+0x46>
  803217:	90                   	nop

00803218 <__umoddi3>:
  803218:	55                   	push   %ebp
  803219:	57                   	push   %edi
  80321a:	56                   	push   %esi
  80321b:	53                   	push   %ebx
  80321c:	83 ec 1c             	sub    $0x1c,%esp
  80321f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803223:	8b 74 24 34          	mov    0x34(%esp),%esi
  803227:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80322b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80322f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803233:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803237:	89 f3                	mov    %esi,%ebx
  803239:	89 fa                	mov    %edi,%edx
  80323b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80323f:	89 34 24             	mov    %esi,(%esp)
  803242:	85 c0                	test   %eax,%eax
  803244:	75 1a                	jne    803260 <__umoddi3+0x48>
  803246:	39 f7                	cmp    %esi,%edi
  803248:	0f 86 a2 00 00 00    	jbe    8032f0 <__umoddi3+0xd8>
  80324e:	89 c8                	mov    %ecx,%eax
  803250:	89 f2                	mov    %esi,%edx
  803252:	f7 f7                	div    %edi
  803254:	89 d0                	mov    %edx,%eax
  803256:	31 d2                	xor    %edx,%edx
  803258:	83 c4 1c             	add    $0x1c,%esp
  80325b:	5b                   	pop    %ebx
  80325c:	5e                   	pop    %esi
  80325d:	5f                   	pop    %edi
  80325e:	5d                   	pop    %ebp
  80325f:	c3                   	ret    
  803260:	39 f0                	cmp    %esi,%eax
  803262:	0f 87 ac 00 00 00    	ja     803314 <__umoddi3+0xfc>
  803268:	0f bd e8             	bsr    %eax,%ebp
  80326b:	83 f5 1f             	xor    $0x1f,%ebp
  80326e:	0f 84 ac 00 00 00    	je     803320 <__umoddi3+0x108>
  803274:	bf 20 00 00 00       	mov    $0x20,%edi
  803279:	29 ef                	sub    %ebp,%edi
  80327b:	89 fe                	mov    %edi,%esi
  80327d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803281:	89 e9                	mov    %ebp,%ecx
  803283:	d3 e0                	shl    %cl,%eax
  803285:	89 d7                	mov    %edx,%edi
  803287:	89 f1                	mov    %esi,%ecx
  803289:	d3 ef                	shr    %cl,%edi
  80328b:	09 c7                	or     %eax,%edi
  80328d:	89 e9                	mov    %ebp,%ecx
  80328f:	d3 e2                	shl    %cl,%edx
  803291:	89 14 24             	mov    %edx,(%esp)
  803294:	89 d8                	mov    %ebx,%eax
  803296:	d3 e0                	shl    %cl,%eax
  803298:	89 c2                	mov    %eax,%edx
  80329a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80329e:	d3 e0                	shl    %cl,%eax
  8032a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032a4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032a8:	89 f1                	mov    %esi,%ecx
  8032aa:	d3 e8                	shr    %cl,%eax
  8032ac:	09 d0                	or     %edx,%eax
  8032ae:	d3 eb                	shr    %cl,%ebx
  8032b0:	89 da                	mov    %ebx,%edx
  8032b2:	f7 f7                	div    %edi
  8032b4:	89 d3                	mov    %edx,%ebx
  8032b6:	f7 24 24             	mull   (%esp)
  8032b9:	89 c6                	mov    %eax,%esi
  8032bb:	89 d1                	mov    %edx,%ecx
  8032bd:	39 d3                	cmp    %edx,%ebx
  8032bf:	0f 82 87 00 00 00    	jb     80334c <__umoddi3+0x134>
  8032c5:	0f 84 91 00 00 00    	je     80335c <__umoddi3+0x144>
  8032cb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032cf:	29 f2                	sub    %esi,%edx
  8032d1:	19 cb                	sbb    %ecx,%ebx
  8032d3:	89 d8                	mov    %ebx,%eax
  8032d5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032d9:	d3 e0                	shl    %cl,%eax
  8032db:	89 e9                	mov    %ebp,%ecx
  8032dd:	d3 ea                	shr    %cl,%edx
  8032df:	09 d0                	or     %edx,%eax
  8032e1:	89 e9                	mov    %ebp,%ecx
  8032e3:	d3 eb                	shr    %cl,%ebx
  8032e5:	89 da                	mov    %ebx,%edx
  8032e7:	83 c4 1c             	add    $0x1c,%esp
  8032ea:	5b                   	pop    %ebx
  8032eb:	5e                   	pop    %esi
  8032ec:	5f                   	pop    %edi
  8032ed:	5d                   	pop    %ebp
  8032ee:	c3                   	ret    
  8032ef:	90                   	nop
  8032f0:	89 fd                	mov    %edi,%ebp
  8032f2:	85 ff                	test   %edi,%edi
  8032f4:	75 0b                	jne    803301 <__umoddi3+0xe9>
  8032f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8032fb:	31 d2                	xor    %edx,%edx
  8032fd:	f7 f7                	div    %edi
  8032ff:	89 c5                	mov    %eax,%ebp
  803301:	89 f0                	mov    %esi,%eax
  803303:	31 d2                	xor    %edx,%edx
  803305:	f7 f5                	div    %ebp
  803307:	89 c8                	mov    %ecx,%eax
  803309:	f7 f5                	div    %ebp
  80330b:	89 d0                	mov    %edx,%eax
  80330d:	e9 44 ff ff ff       	jmp    803256 <__umoddi3+0x3e>
  803312:	66 90                	xchg   %ax,%ax
  803314:	89 c8                	mov    %ecx,%eax
  803316:	89 f2                	mov    %esi,%edx
  803318:	83 c4 1c             	add    $0x1c,%esp
  80331b:	5b                   	pop    %ebx
  80331c:	5e                   	pop    %esi
  80331d:	5f                   	pop    %edi
  80331e:	5d                   	pop    %ebp
  80331f:	c3                   	ret    
  803320:	3b 04 24             	cmp    (%esp),%eax
  803323:	72 06                	jb     80332b <__umoddi3+0x113>
  803325:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803329:	77 0f                	ja     80333a <__umoddi3+0x122>
  80332b:	89 f2                	mov    %esi,%edx
  80332d:	29 f9                	sub    %edi,%ecx
  80332f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803333:	89 14 24             	mov    %edx,(%esp)
  803336:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80333a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80333e:	8b 14 24             	mov    (%esp),%edx
  803341:	83 c4 1c             	add    $0x1c,%esp
  803344:	5b                   	pop    %ebx
  803345:	5e                   	pop    %esi
  803346:	5f                   	pop    %edi
  803347:	5d                   	pop    %ebp
  803348:	c3                   	ret    
  803349:	8d 76 00             	lea    0x0(%esi),%esi
  80334c:	2b 04 24             	sub    (%esp),%eax
  80334f:	19 fa                	sbb    %edi,%edx
  803351:	89 d1                	mov    %edx,%ecx
  803353:	89 c6                	mov    %eax,%esi
  803355:	e9 71 ff ff ff       	jmp    8032cb <__umoddi3+0xb3>
  80335a:	66 90                	xchg   %ax,%ax
  80335c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803360:	72 ea                	jb     80334c <__umoddi3+0x134>
  803362:	89 d9                	mov    %ebx,%ecx
  803364:	e9 62 ff ff ff       	jmp    8032cb <__umoddi3+0xb3>

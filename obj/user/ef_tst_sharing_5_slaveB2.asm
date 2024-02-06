
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 77 01 00 00       	call   8001ad <libmain>
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
  80008c:	68 a0 33 80 00       	push   $0x8033a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 33 80 00       	push   $0x8033bc
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 90 1b 00 00       	call   801c32 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 dc 33 80 00       	push   $0x8033dc
  8000aa:	50                   	push   %eax
  8000ab:	e8 42 16 00 00       	call   8016f2 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 e0 33 80 00       	push   $0x8033e0
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 08 34 80 00       	push   $0x803408
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 a2 2f 00 00       	call   803085 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 4e 18 00 00       	call   801939 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 e0 16 00 00       	call   8017d9 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 28 34 80 00       	push   $0x803428
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 28 18 00 00       	call   801939 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 40 34 80 00       	push   $0x803440
  800127:	6a 20                	push   $0x20
  800129:	68 bc 33 80 00       	push   $0x8033bc
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 39 1c 00 00       	call   801d71 <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 e0 34 80 00       	push   $0x8034e0
  800145:	6a 23                	push   $0x23
  800147:	68 bc 33 80 00       	push   $0x8033bc
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 ec 34 80 00       	push   $0x8034ec
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 10 35 80 00       	push   $0x803510
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 bc 1a 00 00       	call   801c32 <sys_getparentenvid>
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80017d:	7e 2b                	jle    8001aa <_main+0x172>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  80017f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 5c 35 80 00       	push   $0x80355c
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 5c 15 00 00       	call   8016f2 <sget>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 50 01             	lea    0x1(%eax),%edx
  8001a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a7:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a9:	90                   	nop
  8001aa:	90                   	nop
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b3:	e8 61 1a 00 00       	call   801c19 <sys_getenvindex>
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	c1 e0 03             	shl    $0x3,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	c1 e0 04             	shl    $0x4,%eax
  8001d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001da:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001df:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001ea:	84 c0                	test   %al,%al
  8001ec:	74 0f                	je     8001fd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	05 5c 05 00 00       	add    $0x55c,%eax
  8001f8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800201:	7e 0a                	jle    80020d <libmain+0x60>
		binaryname = argv[0];
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	ff 75 08             	pushl  0x8(%ebp)
  800216:	e8 1d fe ff ff       	call   800038 <_main>
  80021b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80021e:	e8 03 18 00 00       	call   801a26 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 84 35 80 00       	push   $0x803584
  80022b:	e8 6d 03 00 00       	call   80059d <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	52                   	push   %edx
  80024d:	50                   	push   %eax
  80024e:	68 ac 35 80 00       	push   $0x8035ac
  800253:	e8 45 03 00 00       	call   80059d <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025b:	a1 20 40 80 00       	mov    0x804020,%eax
  800260:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800266:	a1 20 40 80 00       	mov    0x804020,%eax
  80026b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80027c:	51                   	push   %ecx
  80027d:	52                   	push   %edx
  80027e:	50                   	push   %eax
  80027f:	68 d4 35 80 00       	push   $0x8035d4
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 40 80 00       	mov    0x804020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 2c 36 80 00       	push   $0x80362c
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 84 35 80 00       	push   $0x803584
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 83 17 00 00       	call   801a40 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bd:	e8 19 00 00 00       	call   8002db <exit>
}
  8002c2:	90                   	nop
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	6a 00                	push   $0x0
  8002d0:	e8 10 19 00 00       	call   801be5 <sys_destroy_env>
  8002d5:	83 c4 10             	add    $0x10,%esp
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <exit>:

void
exit(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e1:	e8 65 19 00 00       	call   801c4b <sys_exit_env>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f2:	83 c0 04             	add    $0x4,%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	74 16                	je     800317 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800301:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 40 36 80 00       	push   $0x803640
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 40 80 00       	mov    0x804000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 45 36 80 00       	push   $0x803645
  800328:	e8 70 02 00 00       	call   80059d <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800330:	8b 45 10             	mov    0x10(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 f4             	pushl  -0xc(%ebp)
  800339:	50                   	push   %eax
  80033a:	e8 f3 01 00 00       	call   800532 <vcprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	6a 00                	push   $0x0
  800347:	68 61 36 80 00       	push   $0x803661
  80034c:	e8 e1 01 00 00       	call   800532 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800354:	e8 82 ff ff ff       	call   8002db <exit>

	// should not return here
	while (1) ;
  800359:	eb fe                	jmp    800359 <_panic+0x70>

0080035b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800361:	a1 20 40 80 00       	mov    0x804020,%eax
  800366:	8b 50 74             	mov    0x74(%eax),%edx
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	74 14                	je     800384 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 64 36 80 00       	push   $0x803664
  800378:	6a 26                	push   $0x26
  80037a:	68 b0 36 80 00       	push   $0x8036b0
  80037f:	e8 65 ff ff ff       	call   8002e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800392:	e9 c2 00 00 00       	jmp    800459 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	75 08                	jne    8003b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003af:	e9 a2 00 00 00       	jmp    800456 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c2:	eb 69                	jmp    80042d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	c1 e0 03             	shl    $0x3,%eax
  8003db:	01 c8                	add    %ecx,%eax
  8003dd:	8a 40 04             	mov    0x4(%eax),%al
  8003e0:	84 c0                	test   %al,%al
  8003e2:	75 46                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f2:	89 d0                	mov    %edx,%eax
  8003f4:	01 c0                	add    %eax,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	c1 e0 03             	shl    $0x3,%eax
  8003fb:	01 c8                	add    %ecx,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	01 c8                	add    %ecx,%eax
  80041b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	75 09                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800428:	eb 12                	jmp    80043c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	ff 45 e8             	incl   -0x18(%ebp)
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 50 74             	mov    0x74(%eax),%edx
  800435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800438:	39 c2                	cmp    %eax,%edx
  80043a:	77 88                	ja     8003c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800440:	75 14                	jne    800456 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 bc 36 80 00       	push   $0x8036bc
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 b0 36 80 00       	push   $0x8036b0
  800451:	e8 93 fe ff ff       	call   8002e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800456:	ff 45 f0             	incl   -0x10(%ebp)
  800459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045f:	0f 8c 32 ff ff ff    	jl     800397 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800473:	eb 26                	jmp    80049b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800475:	a1 20 40 80 00       	mov    0x804020,%eax
  80047a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8a 40 04             	mov    0x4(%eax),%al
  800491:	3c 01                	cmp    $0x1,%al
  800493:	75 03                	jne    800498 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800495:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	ff 45 e0             	incl   -0x20(%ebp)
  80049b:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a0:	8b 50 74             	mov    0x74(%eax),%edx
  8004a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a6:	39 c2                	cmp    %eax,%edx
  8004a8:	77 cb                	ja     800475 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b0:	74 14                	je     8004c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 10 37 80 00       	push   $0x803710
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 b0 36 80 00       	push   $0x8036b0
  8004c1:	e8 23 fe ff ff       	call   8002e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	89 0a                	mov    %ecx,(%edx)
  8004dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004df:	88 d1                	mov    %dl,%cl
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f2:	75 2c                	jne    800520 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004f4:	a0 24 40 80 00       	mov    0x804024,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	8b 12                	mov    (%edx),%edx
  800501:	89 d1                	mov    %edx,%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	83 c2 08             	add    $0x8,%edx
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	50                   	push   %eax
  80050d:	51                   	push   %ecx
  80050e:	52                   	push   %edx
  80050f:	e8 64 13 00 00       	call   801878 <sys_cputs>
  800514:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 40 04             	mov    0x4(%eax),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052f:	90                   	nop
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800542:	00 00 00 
	b.cnt = 0;
  800545:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	ff 75 08             	pushl  0x8(%ebp)
  800555:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055b:	50                   	push   %eax
  80055c:	68 c9 04 80 00       	push   $0x8004c9
  800561:	e8 11 02 00 00       	call   800777 <vprintfmt>
  800566:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800569:	a0 24 40 80 00       	mov    0x804024,%al
  80056e:	0f b6 c0             	movzbl %al,%eax
  800571:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	50                   	push   %eax
  80057b:	52                   	push   %edx
  80057c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800582:	83 c0 08             	add    $0x8,%eax
  800585:	50                   	push   %eax
  800586:	e8 ed 12 00 00       	call   801878 <sys_cputs>
  80058b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80058e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800595:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <cprintf>:

int cprintf(const char *fmt, ...) {
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a3:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 73 ff ff ff       	call   800532 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005d0:	e8 51 14 00 00       	call   801a26 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	50                   	push   %eax
  8005e5:	e8 48 ff ff ff       	call   800532 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005f0:	e8 4b 14 00 00       	call   801a40 <sys_enable_interrupt>
	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 14             	sub    $0x14,%esp
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060d:	8b 45 18             	mov    0x18(%ebp),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	77 55                	ja     80066f <printnum+0x75>
  80061a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061d:	72 05                	jb     800624 <printnum+0x2a>
  80061f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800622:	77 4b                	ja     80066f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800624:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	8b 45 18             	mov    0x18(%ebp),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	ff 75 f0             	pushl  -0x10(%ebp)
  80063a:	e8 fd 2a 00 00       	call   80313c <__udivdi3>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	53                   	push   %ebx
  800649:	ff 75 18             	pushl  0x18(%ebp)
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	ff 75 08             	pushl  0x8(%ebp)
  800654:	e8 a1 ff ff ff       	call   8005fa <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
  80065c:	eb 1a                	jmp    800678 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	ff 4d 1c             	decl   0x1c(%ebp)
  800672:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800676:	7f e6                	jg     80065e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800678:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800686:	53                   	push   %ebx
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	e8 bd 2b 00 00       	call   80324c <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 74 39 80 00       	add    $0x803974,%eax
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f be c0             	movsbl %al,%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  8006d4:	eb 40                	jmp    800716 <getuint+0x65>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1e                	je     8006fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	eb 1c                	jmp    800716 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getint+0x25>
		return va_arg(*ap, long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 38                	jmp    800775 <getint+0x5d>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1a                	je     80075d <getint+0x45>
		return va_arg(*ap, long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	99                   	cltd   
  80075b:	eb 18                	jmp    800775 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	99                   	cltd   
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x21>
			if (ch == '\0')
  800781:	85 db                	test   %ebx,%ebx
  800783:	0f 84 af 03 00 00    	je     800b38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	53                   	push   %ebx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d6                	jne    800781 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	8d 50 01             	lea    0x1(%eax),%edx
  8007d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d4:	8a 00                	mov    (%eax),%al
  8007d6:	0f b6 d8             	movzbl %al,%ebx
  8007d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007dc:	83 f8 55             	cmp    $0x55,%eax
  8007df:	0f 87 2b 03 00 00    	ja     800b10 <vprintfmt+0x399>
  8007e5:	8b 04 85 98 39 80 00 	mov    0x803998(,%eax,4),%eax
  8007ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f2:	eb d7                	jmp    8007cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d1                	jmp    8007cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	c1 e0 02             	shl    $0x2,%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	01 c0                	add    %eax,%eax
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	83 e8 30             	sub    $0x30,%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081d:	83 fb 2f             	cmp    $0x2f,%ebx
  800820:	7e 3e                	jle    800860 <vprintfmt+0xe9>
  800822:	83 fb 39             	cmp    $0x39,%ebx
  800825:	7f 39                	jg     800860 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082a:	eb d5                	jmp    800801 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800840:	eb 1f                	jmp    800861 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	79 83                	jns    8007cb <vprintfmt+0x54>
				width = 0;
  800848:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800854:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085b:	e9 6b ff ff ff       	jmp    8007cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800860:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	0f 89 60 ff ff ff    	jns    8007cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80086b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800871:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800878:	e9 4e ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800880:	e9 46 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 89 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	79 02                	jns    8008c1 <vprintfmt+0x14a>
				err = -err;
  8008bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c1:	83 fb 64             	cmp    $0x64,%ebx
  8008c4:	7f 0b                	jg     8008d1 <vprintfmt+0x15a>
  8008c6:	8b 34 9d e0 37 80 00 	mov    0x8037e0(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 85 39 80 00       	push   $0x803985
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 5e 02 00 00       	call   800b40 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e5:	e9 49 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ea:	56                   	push   %esi
  8008eb:	68 8e 39 80 00       	push   $0x80398e
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 45 02 00 00       	call   800b40 <printfmt>
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 30 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 30                	mov    (%eax),%esi
  800914:	85 f6                	test   %esi,%esi
  800916:	75 05                	jne    80091d <vprintfmt+0x1a6>
				p = "(null)";
  800918:	be 91 39 80 00       	mov    $0x803991,%esi
			if (width > 0 && padc != '-')
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7e 6d                	jle    800990 <vprintfmt+0x219>
  800923:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800927:	74 67                	je     800990 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	50                   	push   %eax
  800930:	56                   	push   %esi
  800931:	e8 0c 03 00 00       	call   800c42 <strnlen>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093c:	eb 16                	jmp    800954 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e4                	jg     80093e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	eb 34                	jmp    800990 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	74 1c                	je     80097e <vprintfmt+0x207>
  800962:	83 fb 1f             	cmp    $0x1f,%ebx
  800965:	7e 05                	jle    80096c <vprintfmt+0x1f5>
  800967:	83 fb 7e             	cmp    $0x7e,%ebx
  80096a:	7e 12                	jle    80097e <vprintfmt+0x207>
					putch('?', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 3f                	push   $0x3f
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	eb 0f                	jmp    80098d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	89 f0                	mov    %esi,%eax
  800992:	8d 70 01             	lea    0x1(%eax),%esi
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	74 24                	je     8009c2 <vprintfmt+0x24b>
  80099e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a2:	78 b8                	js     80095c <vprintfmt+0x1e5>
  8009a4:	ff 4d e0             	decl   -0x20(%ebp)
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	79 af                	jns    80095c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ad:	eb 13                	jmp    8009c2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 20                	push   $0x20
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e7                	jg     8009af <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c8:	e9 66 01 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 3c fd ff ff       	call   800718 <getint>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	79 23                	jns    800a12 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 2d                	push   $0x2d
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a05:	f7 d8                	neg    %eax
  800a07:	83 d2 00             	adc    $0x0,%edx
  800a0a:	f7 da                	neg    %edx
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 84 fc ff ff       	call   8006b1 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3d:	e9 98 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 58                	push   $0x58
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			break;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 30                	push   $0x30
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 78                	push   $0x78
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab9:	eb 1f                	jmp    800ada <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	50                   	push   %eax
  800ac5:	e8 e7 fb ff ff       	call   8006b1 <getuint>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	52                   	push   %edx
  800ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aec:	ff 75 f0             	pushl  -0x10(%ebp)
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 00 fb ff ff       	call   8005fa <printnum>
  800afa:	83 c4 20             	add    $0x20,%esp
			break;
  800afd:	eb 34                	jmp    800b33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	eb 23                	jmp    800b33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 25                	push   $0x25
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	eb 03                	jmp    800b28 <vprintfmt+0x3b1>
  800b25:	ff 4d 10             	decl   0x10(%ebp)
  800b28:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2b:	48                   	dec    %eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	3c 25                	cmp    $0x25,%al
  800b30:	75 f3                	jne    800b25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b32:	90                   	nop
		}
	}
  800b33:	e9 47 fc ff ff       	jmp    80077f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b46:	8d 45 10             	lea    0x10(%ebp),%eax
  800b49:	83 c0 04             	add    $0x4,%eax
  800b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 16 fc ff ff       	call   800777 <vprintfmt>
  800b61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b64:	90                   	nop
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 40 08             	mov    0x8(%eax),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 10                	mov    (%eax),%edx
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8b 40 04             	mov    0x4(%eax),%eax
  800b84:	39 c2                	cmp    %eax,%edx
  800b86:	73 12                	jae    800b9a <sprintputch+0x33>
		*b->buf++ = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 10                	mov    %dl,(%eax)
}
  800b9a:	90                   	nop
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	74 06                	je     800bca <vsnprintf+0x2d>
  800bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc8:	7f 07                	jg     800bd1 <vsnprintf+0x34>
		return -E_INVAL;
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	eb 20                	jmp    800bf1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd1:	ff 75 14             	pushl  0x14(%ebp)
  800bd4:	ff 75 10             	pushl  0x10(%ebp)
  800bd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	68 67 0b 80 00       	push   $0x800b67
  800be0:	e8 92 fb ff ff       	call   800777 <vprintfmt>
  800be5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfc:	83 c0 04             	add    $0x4,%eax
  800bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	50                   	push   %eax
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 89 ff ff ff       	call   800b9d <vsnprintf>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 06                	jmp    800c34 <strlen+0x15>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 f1                	jne    800c2e <strlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4f:	eb 09                	jmp    800c5a <strnlen+0x18>
		n++;
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	ff 4d 0c             	decl   0xc(%ebp)
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	74 09                	je     800c69 <strnlen+0x27>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e8                	jne    800c51 <strnlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c7a:	90                   	nop
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e4                	jne    800c7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caf:	eb 1f                	jmp    800cd0 <strncpy+0x34>
		*dst++ = *src;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	84 c0                	test   %al,%al
  800cc8:	74 03                	je     800ccd <strncpy+0x31>
			src++;
  800cca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd6:	72 d9                	jb     800cb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 30                	je     800d1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cef:	eb 16                	jmp    800d07 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d03:	8a 12                	mov    (%edx),%dl
  800d05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d07:	ff 4d 10             	decl   0x10(%ebp)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 09                	je     800d19 <strlcpy+0x3c>
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	75 d8                	jne    800cf1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	29 c2                	sub    %eax,%edx
  800d27:	89 d0                	mov    %edx,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2e:	eb 06                	jmp    800d36 <strcmp+0xb>
		p++, q++;
  800d30:	ff 45 08             	incl   0x8(%ebp)
  800d33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0e                	je     800d4d <strcmp+0x22>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 e3                	je     800d30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d0             	movzbl %al,%edx
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 c0             	movzbl %al,%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d66:	eb 09                	jmp    800d71 <strncmp+0xe>
		n--, p++, q++;
  800d68:	ff 4d 10             	decl   0x10(%ebp)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 17                	je     800d8e <strncmp+0x2b>
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	74 0e                	je     800d8e <strncmp+0x2b>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 10                	mov    (%eax),%dl
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	38 c2                	cmp    %al,%dl
  800d8c:	74 da                	je     800d68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	75 07                	jne    800d9b <strncmp+0x38>
		return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb 14                	jmp    800daf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 d0             	movzbl %al,%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	29 c2                	sub    %eax,%edx
  800dad:	89 d0                	mov    %edx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 04             	sub    $0x4,%esp
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbd:	eb 12                	jmp    800dd1 <strchr+0x20>
		if (*s == c)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc7:	75 05                	jne    800dce <strchr+0x1d>
			return (char *) s;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	eb 11                	jmp    800ddf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	84 c0                	test   %al,%al
  800dd8:	75 e5                	jne    800dbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 0d                	jmp    800dfc <strfind+0x1b>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	74 0e                	je     800e07 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 ea                	jne    800def <strfind+0xe>
  800e05:	eb 01                	jmp    800e08 <strfind+0x27>
		if (*s == c)
			break;
  800e07:	90                   	nop
	return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1f:	eb 0e                	jmp    800e2f <memset+0x22>
		*p++ = c;
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2f:	ff 4d f8             	decl   -0x8(%ebp)
  800e32:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e36:	79 e9                	jns    800e21 <memset+0x14>
		*p++ = c;

	return v;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4f:	eb 16                	jmp    800e67 <memcpy+0x2a>
		*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e91:	73 50                	jae    800ee3 <memmove+0x6a>
  800e93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9e:	76 43                	jbe    800ee3 <memmove+0x6a>
		s += n;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eac:	eb 10                	jmp    800ebe <memmove+0x45>
			*--d = *--s;
  800eae:	ff 4d f8             	decl   -0x8(%ebp)
  800eb1:	ff 4d fc             	decl   -0x4(%ebp)
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 e3                	jne    800eae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ecb:	eb 23                	jmp    800ef0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edf:	8a 12                	mov    (%edx),%dl
  800ee1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	75 dd                	jne    800ecd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f07:	eb 2a                	jmp    800f33 <memcmp+0x3e>
		if (*s1 != *s2)
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 16                	je     800f2d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f b6 d0             	movzbl %al,%edx
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	eb 18                	jmp    800f45 <memcmp+0x50>
		s1++, s2++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
  800f30:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f39:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	75 c9                	jne    800f09 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f58:	eb 15                	jmp    800f6f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 d0             	movzbl %al,%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	0f b6 c0             	movzbl %al,%eax
  800f68:	39 c2                	cmp    %eax,%edx
  800f6a:	74 0d                	je     800f79 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f75:	72 e3                	jb     800f5a <memfind+0x13>
  800f77:	eb 01                	jmp    800f7a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f79:	90                   	nop
	return (void *) s;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f93:	eb 03                	jmp    800f98 <strtol+0x19>
		s++;
  800f95:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 20                	cmp    $0x20,%al
  800f9f:	74 f4                	je     800f95 <strtol+0x16>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 09                	cmp    $0x9,%al
  800fa8:	74 eb                	je     800f95 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 2b                	cmp    $0x2b,%al
  800fb1:	75 05                	jne    800fb8 <strtol+0x39>
		s++;
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	eb 13                	jmp    800fcb <strtol+0x4c>
	else if (*s == '-')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2d                	cmp    $0x2d,%al
  800fbf:	75 0a                	jne    800fcb <strtol+0x4c>
		s++, neg = 1;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	74 06                	je     800fd7 <strtol+0x58>
  800fd1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd5:	75 20                	jne    800ff7 <strtol+0x78>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 30                	cmp    $0x30,%al
  800fde:	75 17                	jne    800ff7 <strtol+0x78>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	40                   	inc    %eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 78                	cmp    $0x78,%al
  800fe8:	75 0d                	jne    800ff7 <strtol+0x78>
		s += 2, base = 16;
  800fea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff5:	eb 28                	jmp    80101f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 15                	jne    801012 <strtol+0x93>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 30                	cmp    $0x30,%al
  801004:	75 0c                	jne    801012 <strtol+0x93>
		s++, base = 8;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801010:	eb 0d                	jmp    80101f <strtol+0xa0>
	else if (base == 0)
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	75 07                	jne    80101f <strtol+0xa0>
		base = 10;
  801018:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 2f                	cmp    $0x2f,%al
  801026:	7e 19                	jle    801041 <strtol+0xc2>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 39                	cmp    $0x39,%al
  80102f:	7f 10                	jg     801041 <strtol+0xc2>
			dig = *s - '0';
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f be c0             	movsbl %al,%eax
  801039:	83 e8 30             	sub    $0x30,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103f:	eb 42                	jmp    801083 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 60                	cmp    $0x60,%al
  801048:	7e 19                	jle    801063 <strtol+0xe4>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 7a                	cmp    $0x7a,%al
  801051:	7f 10                	jg     801063 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 e8 57             	sub    $0x57,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801061:	eb 20                	jmp    801083 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 40                	cmp    $0x40,%al
  80106a:	7e 39                	jle    8010a5 <strtol+0x126>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 5a                	cmp    $0x5a,%al
  801073:	7f 30                	jg     8010a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f be c0             	movsbl %al,%eax
  80107d:	83 e8 37             	sub    $0x37,%eax
  801080:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 10             	cmp    0x10(%ebp),%eax
  801089:	7d 19                	jge    8010a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	0f af 45 10          	imul   0x10(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	01 d0                	add    %edx,%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109f:	e9 7b ff ff ff       	jmp    80101f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a9:	74 08                	je     8010b3 <strtol+0x134>
		*endptr = (char *) s;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b7:	74 07                	je     8010c0 <strtol+0x141>
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	f7 d8                	neg    %eax
  8010be:	eb 03                	jmp    8010c3 <strtol+0x144>
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dd:	79 13                	jns    8010f2 <ltostr+0x2d>
	{
		neg = 1;
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010fa:	99                   	cltd   
  8010fb:	f7 f9                	idiv   %ecx
  8010fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	8d 50 01             	lea    0x1(%eax),%edx
  801106:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801109:	89 c2                	mov    %eax,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801113:	83 c2 30             	add    $0x30,%edx
  801116:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801120:	f7 e9                	imul   %ecx
  801122:	c1 fa 02             	sar    $0x2,%edx
  801125:	89 c8                	mov    %ecx,%eax
  801127:	c1 f8 1f             	sar    $0x1f,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801139:	f7 e9                	imul   %ecx
  80113b:	c1 fa 02             	sar    $0x2,%edx
  80113e:	89 c8                	mov    %ecx,%eax
  801140:	c1 f8 1f             	sar    $0x1f,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
  801147:	c1 e0 02             	shl    $0x2,%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	01 c0                	add    %eax,%eax
  80114e:	29 c1                	sub    %eax,%ecx
  801150:	89 ca                	mov    %ecx,%edx
  801152:	85 d2                	test   %edx,%edx
  801154:	75 9c                	jne    8010f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80115d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801160:	48                   	dec    %eax
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801168:	74 3d                	je     8011a7 <ltostr+0xe2>
		start = 1 ;
  80116a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801171:	eb 34                	jmp    8011a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119f:	88 02                	mov    %al,(%edx)
		start++ ;
  8011a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ad:	7c c4                	jl     801173 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ba:	90                   	nop
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011c3:	ff 75 08             	pushl  0x8(%ebp)
  8011c6:	e8 54 fa ff ff       	call   800c1f <strlen>
  8011cb:	83 c4 04             	add    $0x4,%esp
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	e8 46 fa ff ff       	call   800c1f <strlen>
  8011d9:	83 c4 04             	add    $0x4,%esp
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 17                	jmp    801206 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80120c:	7c e1                	jl     8011ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80120e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801215:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80121c:	eb 1f                	jmp    80123d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801227:	89 c2                	mov    %eax,%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 c2                	add    %eax,%edx
  80122e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	01 c8                	add    %ecx,%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80123a:	ff 45 f8             	incl   -0x8(%ebp)
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801243:	7c d9                	jl     80121e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801245:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	c6 00 00             	movb   $0x0,(%eax)
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801256:	8b 45 14             	mov    0x14(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801276:	eb 0c                	jmp    801284 <strsplit+0x31>
			*string++ = 0;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 08             	mov    %edx,0x8(%ebp)
  801281:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 18                	je     8012a5 <strsplit+0x52>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	0f be c0             	movsbl %al,%eax
  801295:	50                   	push   %eax
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 13 fb ff ff       	call   800db1 <strchr>
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	75 d3                	jne    801278 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	74 5a                	je     801308 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b1:	8b 00                	mov    (%eax),%eax
  8012b3:	83 f8 0f             	cmp    $0xf,%eax
  8012b6:	75 07                	jne    8012bf <strsplit+0x6c>
		{
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 66                	jmp    801325 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ca:	89 0a                	mov    %ecx,(%edx)
  8012cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d6:	01 c2                	add    %eax,%edx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dd:	eb 03                	jmp    8012e2 <strsplit+0x8f>
			string++;
  8012df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 8b                	je     801276 <strsplit+0x23>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	e8 b5 fa ff ff       	call   800db1 <strchr>
  8012fc:	83 c4 08             	add    $0x8,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 dc                	je     8012df <strsplit+0x8c>
			string++;
	}
  801303:	e9 6e ff ff ff       	jmp    801276 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801308:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801309:	8b 45 14             	mov    0x14(%ebp),%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801320:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80132d:	a1 04 40 80 00       	mov    0x804004,%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	74 1f                	je     801355 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801336:	e8 1d 00 00 00       	call   801358 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	68 f0 3a 80 00       	push   $0x803af0
  801343:	e8 55 f2 ff ff       	call   80059d <cprintf>
  801348:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80134b:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801352:	00 00 00 
	}
}
  801355:	90                   	nop
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80135e:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801365:	00 00 00 
  801368:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80136f:	00 00 00 
  801372:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801379:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  80137c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801383:	00 00 00 
  801386:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80138d:	00 00 00 
  801390:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801397:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80139a:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013a1:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8013a4:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013b8:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8013bd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013c4:	a1 20 41 80 00       	mov    0x804120,%eax
  8013c9:	c1 e0 04             	shl    $0x4,%eax
  8013cc:	89 c2                	mov    %eax,%edx
  8013ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d1:	01 d0                	add    %edx,%eax
  8013d3:	48                   	dec    %eax
  8013d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8013d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013da:	ba 00 00 00 00       	mov    $0x0,%edx
  8013df:	f7 75 f0             	divl   -0x10(%ebp)
  8013e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013e5:	29 d0                	sub    %edx,%eax
  8013e7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  8013ea:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8013f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013f4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f9:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013fe:	83 ec 04             	sub    $0x4,%esp
  801401:	6a 06                	push   $0x6
  801403:	ff 75 e8             	pushl  -0x18(%ebp)
  801406:	50                   	push   %eax
  801407:	e8 b0 05 00 00       	call   8019bc <sys_allocate_chunk>
  80140c:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80140f:	a1 20 41 80 00       	mov    0x804120,%eax
  801414:	83 ec 0c             	sub    $0xc,%esp
  801417:	50                   	push   %eax
  801418:	e8 25 0c 00 00       	call   802042 <initialize_MemBlocksList>
  80141d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801420:	a1 48 41 80 00       	mov    0x804148,%eax
  801425:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801428:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80142c:	75 14                	jne    801442 <initialize_dyn_block_system+0xea>
  80142e:	83 ec 04             	sub    $0x4,%esp
  801431:	68 15 3b 80 00       	push   $0x803b15
  801436:	6a 29                	push   $0x29
  801438:	68 33 3b 80 00       	push   $0x803b33
  80143d:	e8 a7 ee ff ff       	call   8002e9 <_panic>
  801442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801445:	8b 00                	mov    (%eax),%eax
  801447:	85 c0                	test   %eax,%eax
  801449:	74 10                	je     80145b <initialize_dyn_block_system+0x103>
  80144b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80144e:	8b 00                	mov    (%eax),%eax
  801450:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801453:	8b 52 04             	mov    0x4(%edx),%edx
  801456:	89 50 04             	mov    %edx,0x4(%eax)
  801459:	eb 0b                	jmp    801466 <initialize_dyn_block_system+0x10e>
  80145b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80145e:	8b 40 04             	mov    0x4(%eax),%eax
  801461:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801466:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801469:	8b 40 04             	mov    0x4(%eax),%eax
  80146c:	85 c0                	test   %eax,%eax
  80146e:	74 0f                	je     80147f <initialize_dyn_block_system+0x127>
  801470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801473:	8b 40 04             	mov    0x4(%eax),%eax
  801476:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801479:	8b 12                	mov    (%edx),%edx
  80147b:	89 10                	mov    %edx,(%eax)
  80147d:	eb 0a                	jmp    801489 <initialize_dyn_block_system+0x131>
  80147f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801482:	8b 00                	mov    (%eax),%eax
  801484:	a3 48 41 80 00       	mov    %eax,0x804148
  801489:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801495:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80149c:	a1 54 41 80 00       	mov    0x804154,%eax
  8014a1:	48                   	dec    %eax
  8014a2:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  8014a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014aa:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8014b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b4:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8014bb:	83 ec 0c             	sub    $0xc,%esp
  8014be:	ff 75 e0             	pushl  -0x20(%ebp)
  8014c1:	e8 b9 14 00 00       	call   80297f <insert_sorted_with_merge_freeList>
  8014c6:	83 c4 10             	add    $0x10,%esp

}
  8014c9:	90                   	nop
  8014ca:	c9                   	leave  
  8014cb:	c3                   	ret    

008014cc <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014d2:	e8 50 fe ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014d7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014db:	75 07                	jne    8014e4 <malloc+0x18>
  8014dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e2:	eb 68                	jmp    80154c <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  8014e4:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f1:	01 d0                	add    %edx,%eax
  8014f3:	48                   	dec    %eax
  8014f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ff:	f7 75 f4             	divl   -0xc(%ebp)
  801502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801505:	29 d0                	sub    %edx,%eax
  801507:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  80150a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801511:	e8 74 08 00 00       	call   801d8a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801516:	85 c0                	test   %eax,%eax
  801518:	74 2d                	je     801547 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  80151a:	83 ec 0c             	sub    $0xc,%esp
  80151d:	ff 75 ec             	pushl  -0x14(%ebp)
  801520:	e8 52 0e 00 00       	call   802377 <alloc_block_FF>
  801525:	83 c4 10             	add    $0x10,%esp
  801528:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  80152b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80152f:	74 16                	je     801547 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  801531:	83 ec 0c             	sub    $0xc,%esp
  801534:	ff 75 e8             	pushl  -0x18(%ebp)
  801537:	e8 3b 0c 00 00       	call   802177 <insert_sorted_allocList>
  80153c:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80153f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801542:	8b 40 08             	mov    0x8(%eax),%eax
  801545:	eb 05                	jmp    80154c <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801547:	b8 00 00 00 00       	mov    $0x0,%eax

}
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    

0080154e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80154e:	55                   	push   %ebp
  80154f:	89 e5                	mov    %esp,%ebp
  801551:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801554:	8b 45 08             	mov    0x8(%ebp),%eax
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	50                   	push   %eax
  80155b:	68 40 40 80 00       	push   $0x804040
  801560:	e8 ba 0b 00 00       	call   80211f <find_block>
  801565:	83 c4 10             	add    $0x10,%esp
  801568:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  80156b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156e:	8b 40 0c             	mov    0xc(%eax),%eax
  801571:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801578:	0f 84 9f 00 00 00    	je     80161d <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  80157e:	8b 45 08             	mov    0x8(%ebp),%eax
  801581:	83 ec 08             	sub    $0x8,%esp
  801584:	ff 75 f0             	pushl  -0x10(%ebp)
  801587:	50                   	push   %eax
  801588:	e8 f7 03 00 00       	call   801984 <sys_free_user_mem>
  80158d:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801594:	75 14                	jne    8015aa <free+0x5c>
  801596:	83 ec 04             	sub    $0x4,%esp
  801599:	68 15 3b 80 00       	push   $0x803b15
  80159e:	6a 6a                	push   $0x6a
  8015a0:	68 33 3b 80 00       	push   $0x803b33
  8015a5:	e8 3f ed ff ff       	call   8002e9 <_panic>
  8015aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ad:	8b 00                	mov    (%eax),%eax
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	74 10                	je     8015c3 <free+0x75>
  8015b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b6:	8b 00                	mov    (%eax),%eax
  8015b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015bb:	8b 52 04             	mov    0x4(%edx),%edx
  8015be:	89 50 04             	mov    %edx,0x4(%eax)
  8015c1:	eb 0b                	jmp    8015ce <free+0x80>
  8015c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c6:	8b 40 04             	mov    0x4(%eax),%eax
  8015c9:	a3 44 40 80 00       	mov    %eax,0x804044
  8015ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d1:	8b 40 04             	mov    0x4(%eax),%eax
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	74 0f                	je     8015e7 <free+0x99>
  8015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015db:	8b 40 04             	mov    0x4(%eax),%eax
  8015de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e1:	8b 12                	mov    (%edx),%edx
  8015e3:	89 10                	mov    %edx,(%eax)
  8015e5:	eb 0a                	jmp    8015f1 <free+0xa3>
  8015e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ea:	8b 00                	mov    (%eax),%eax
  8015ec:	a3 40 40 80 00       	mov    %eax,0x804040
  8015f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801604:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801609:	48                   	dec    %eax
  80160a:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  80160f:	83 ec 0c             	sub    $0xc,%esp
  801612:	ff 75 f4             	pushl  -0xc(%ebp)
  801615:	e8 65 13 00 00       	call   80297f <insert_sorted_with_merge_freeList>
  80161a:	83 c4 10             	add    $0x10,%esp
	}
}
  80161d:	90                   	nop
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 28             	sub    $0x28,%esp
  801626:	8b 45 10             	mov    0x10(%ebp),%eax
  801629:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80162c:	e8 f6 fc ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  801631:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801635:	75 0a                	jne    801641 <smalloc+0x21>
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
  80163c:	e9 af 00 00 00       	jmp    8016f0 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  801641:	e8 44 07 00 00       	call   801d8a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801646:	83 f8 01             	cmp    $0x1,%eax
  801649:	0f 85 9c 00 00 00    	jne    8016eb <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80164f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801656:	8b 55 0c             	mov    0xc(%ebp),%edx
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	01 d0                	add    %edx,%eax
  80165e:	48                   	dec    %eax
  80165f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801665:	ba 00 00 00 00       	mov    $0x0,%edx
  80166a:	f7 75 f4             	divl   -0xc(%ebp)
  80166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801670:	29 d0                	sub    %edx,%eax
  801672:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801675:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  80167c:	76 07                	jbe    801685 <smalloc+0x65>
			return NULL;
  80167e:	b8 00 00 00 00       	mov    $0x0,%eax
  801683:	eb 6b                	jmp    8016f0 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801685:	83 ec 0c             	sub    $0xc,%esp
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	e8 e7 0c 00 00       	call   802377 <alloc_block_FF>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801696:	83 ec 0c             	sub    $0xc,%esp
  801699:	ff 75 ec             	pushl  -0x14(%ebp)
  80169c:	e8 d6 0a 00 00       	call   802177 <insert_sorted_allocList>
  8016a1:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8016a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016a8:	75 07                	jne    8016b1 <smalloc+0x91>
		{
			return NULL;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	eb 3f                	jmp    8016f0 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b4:	8b 40 08             	mov    0x8(%eax),%eax
  8016b7:	89 c2                	mov    %eax,%edx
  8016b9:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016bd:	52                   	push   %edx
  8016be:	50                   	push   %eax
  8016bf:	ff 75 0c             	pushl  0xc(%ebp)
  8016c2:	ff 75 08             	pushl  0x8(%ebp)
  8016c5:	e8 45 04 00 00       	call   801b0f <sys_createSharedObject>
  8016ca:	83 c4 10             	add    $0x10,%esp
  8016cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8016d0:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  8016d4:	74 06                	je     8016dc <smalloc+0xbc>
  8016d6:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  8016da:	75 07                	jne    8016e3 <smalloc+0xc3>
		{
			return NULL;
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e1:	eb 0d                	jmp    8016f0 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  8016e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e6:	8b 40 08             	mov    0x8(%eax),%eax
  8016e9:	eb 05                	jmp    8016f0 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f0:	c9                   	leave  
  8016f1:	c3                   	ret    

008016f2 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016f2:	55                   	push   %ebp
  8016f3:	89 e5                	mov    %esp,%ebp
  8016f5:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016f8:	e8 2a fc ff ff       	call   801327 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8016fd:	83 ec 08             	sub    $0x8,%esp
  801700:	ff 75 0c             	pushl  0xc(%ebp)
  801703:	ff 75 08             	pushl  0x8(%ebp)
  801706:	e8 2e 04 00 00       	call   801b39 <sys_getSizeOfSharedObject>
  80170b:	83 c4 10             	add    $0x10,%esp
  80170e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801711:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801715:	75 0a                	jne    801721 <sget+0x2f>
	{
		return NULL;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
  80171c:	e9 94 00 00 00       	jmp    8017b5 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801721:	e8 64 06 00 00       	call   801d8a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801726:	85 c0                	test   %eax,%eax
  801728:	0f 84 82 00 00 00    	je     8017b0 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  80172e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801735:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80173c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80173f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801742:	01 d0                	add    %edx,%eax
  801744:	48                   	dec    %eax
  801745:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801748:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80174b:	ba 00 00 00 00       	mov    $0x0,%edx
  801750:	f7 75 ec             	divl   -0x14(%ebp)
  801753:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801756:	29 d0                	sub    %edx,%eax
  801758:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175e:	83 ec 0c             	sub    $0xc,%esp
  801761:	50                   	push   %eax
  801762:	e8 10 0c 00 00       	call   802377 <alloc_block_FF>
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  80176d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801771:	75 07                	jne    80177a <sget+0x88>
		{
			return NULL;
  801773:	b8 00 00 00 00       	mov    $0x0,%eax
  801778:	eb 3b                	jmp    8017b5 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80177a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177d:	8b 40 08             	mov    0x8(%eax),%eax
  801780:	83 ec 04             	sub    $0x4,%esp
  801783:	50                   	push   %eax
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	ff 75 08             	pushl  0x8(%ebp)
  80178a:	e8 c7 03 00 00       	call   801b56 <sys_getSharedObject>
  80178f:	83 c4 10             	add    $0x10,%esp
  801792:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801795:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801799:	74 06                	je     8017a1 <sget+0xaf>
  80179b:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  80179f:	75 07                	jne    8017a8 <sget+0xb6>
		{
			return NULL;
  8017a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a6:	eb 0d                	jmp    8017b5 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8017a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ab:	8b 40 08             	mov    0x8(%eax),%eax
  8017ae:	eb 05                	jmp    8017b5 <sget+0xc3>
		}
	}
	else
			return NULL;
  8017b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b5:	c9                   	leave  
  8017b6:	c3                   	ret    

008017b7 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017b7:	55                   	push   %ebp
  8017b8:	89 e5                	mov    %esp,%ebp
  8017ba:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017bd:	e8 65 fb ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017c2:	83 ec 04             	sub    $0x4,%esp
  8017c5:	68 40 3b 80 00       	push   $0x803b40
  8017ca:	68 e1 00 00 00       	push   $0xe1
  8017cf:	68 33 3b 80 00       	push   $0x803b33
  8017d4:	e8 10 eb ff ff       	call   8002e9 <_panic>

008017d9 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017df:	83 ec 04             	sub    $0x4,%esp
  8017e2:	68 68 3b 80 00       	push   $0x803b68
  8017e7:	68 f5 00 00 00       	push   $0xf5
  8017ec:	68 33 3b 80 00       	push   $0x803b33
  8017f1:	e8 f3 ea ff ff       	call   8002e9 <_panic>

008017f6 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	68 8c 3b 80 00       	push   $0x803b8c
  801804:	68 00 01 00 00       	push   $0x100
  801809:	68 33 3b 80 00       	push   $0x803b33
  80180e:	e8 d6 ea ff ff       	call   8002e9 <_panic>

00801813 <shrink>:

}
void shrink(uint32 newSize)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	68 8c 3b 80 00       	push   $0x803b8c
  801821:	68 05 01 00 00       	push   $0x105
  801826:	68 33 3b 80 00       	push   $0x803b33
  80182b:	e8 b9 ea ff ff       	call   8002e9 <_panic>

00801830 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	68 8c 3b 80 00       	push   $0x803b8c
  80183e:	68 0a 01 00 00       	push   $0x10a
  801843:	68 33 3b 80 00       	push   $0x803b33
  801848:	e8 9c ea ff ff       	call   8002e9 <_panic>

0080184d <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	57                   	push   %edi
  801851:	56                   	push   %esi
  801852:	53                   	push   %ebx
  801853:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80185f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801862:	8b 7d 18             	mov    0x18(%ebp),%edi
  801865:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801868:	cd 30                	int    $0x30
  80186a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801870:	83 c4 10             	add    $0x10,%esp
  801873:	5b                   	pop    %ebx
  801874:	5e                   	pop    %esi
  801875:	5f                   	pop    %edi
  801876:	5d                   	pop    %ebp
  801877:	c3                   	ret    

00801878 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 04             	sub    $0x4,%esp
  80187e:	8b 45 10             	mov    0x10(%ebp),%eax
  801881:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801884:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801888:	8b 45 08             	mov    0x8(%ebp),%eax
  80188b:	6a 00                	push   $0x0
  80188d:	6a 00                	push   $0x0
  80188f:	52                   	push   %edx
  801890:	ff 75 0c             	pushl  0xc(%ebp)
  801893:	50                   	push   %eax
  801894:	6a 00                	push   $0x0
  801896:	e8 b2 ff ff ff       	call   80184d <syscall>
  80189b:	83 c4 18             	add    $0x18,%esp
}
  80189e:	90                   	nop
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 01                	push   $0x1
  8018b0:	e8 98 ff ff ff       	call   80184d <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	52                   	push   %edx
  8018ca:	50                   	push   %eax
  8018cb:	6a 05                	push   $0x5
  8018cd:	e8 7b ff ff ff       	call   80184d <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	c9                   	leave  
  8018d6:	c3                   	ret    

008018d7 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	56                   	push   %esi
  8018db:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018dc:	8b 75 18             	mov    0x18(%ebp),%esi
  8018df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	56                   	push   %esi
  8018ec:	53                   	push   %ebx
  8018ed:	51                   	push   %ecx
  8018ee:	52                   	push   %edx
  8018ef:	50                   	push   %eax
  8018f0:	6a 06                	push   $0x6
  8018f2:	e8 56 ff ff ff       	call   80184d <syscall>
  8018f7:	83 c4 18             	add    $0x18,%esp
}
  8018fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018fd:	5b                   	pop    %ebx
  8018fe:	5e                   	pop    %esi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    

00801901 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801904:	8b 55 0c             	mov    0xc(%ebp),%edx
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	6a 00                	push   $0x0
  80190c:	6a 00                	push   $0x0
  80190e:	6a 00                	push   $0x0
  801910:	52                   	push   %edx
  801911:	50                   	push   %eax
  801912:	6a 07                	push   $0x7
  801914:	e8 34 ff ff ff       	call   80184d <syscall>
  801919:	83 c4 18             	add    $0x18,%esp
}
  80191c:	c9                   	leave  
  80191d:	c3                   	ret    

0080191e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	ff 75 0c             	pushl  0xc(%ebp)
  80192a:	ff 75 08             	pushl  0x8(%ebp)
  80192d:	6a 08                	push   $0x8
  80192f:	e8 19 ff ff ff       	call   80184d <syscall>
  801934:	83 c4 18             	add    $0x18,%esp
}
  801937:	c9                   	leave  
  801938:	c3                   	ret    

00801939 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801939:	55                   	push   %ebp
  80193a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	6a 09                	push   $0x9
  801948:	e8 00 ff ff ff       	call   80184d <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 0a                	push   $0xa
  801961:	e8 e7 fe ff ff       	call   80184d <syscall>
  801966:	83 c4 18             	add    $0x18,%esp
}
  801969:	c9                   	leave  
  80196a:	c3                   	ret    

0080196b <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80196b:	55                   	push   %ebp
  80196c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 00                	push   $0x0
  801976:	6a 00                	push   $0x0
  801978:	6a 0b                	push   $0xb
  80197a:	e8 ce fe ff ff       	call   80184d <syscall>
  80197f:	83 c4 18             	add    $0x18,%esp
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	ff 75 0c             	pushl  0xc(%ebp)
  801990:	ff 75 08             	pushl  0x8(%ebp)
  801993:	6a 0f                	push   $0xf
  801995:	e8 b3 fe ff ff       	call   80184d <syscall>
  80199a:	83 c4 18             	add    $0x18,%esp
	return;
  80199d:	90                   	nop
}
  80199e:	c9                   	leave  
  80199f:	c3                   	ret    

008019a0 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019a0:	55                   	push   %ebp
  8019a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ac:	ff 75 08             	pushl  0x8(%ebp)
  8019af:	6a 10                	push   $0x10
  8019b1:	e8 97 fe ff ff       	call   80184d <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b9:	90                   	nop
}
  8019ba:	c9                   	leave  
  8019bb:	c3                   	ret    

008019bc <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019bc:	55                   	push   %ebp
  8019bd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019bf:	6a 00                	push   $0x0
  8019c1:	6a 00                	push   $0x0
  8019c3:	ff 75 10             	pushl  0x10(%ebp)
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	ff 75 08             	pushl  0x8(%ebp)
  8019cc:	6a 11                	push   $0x11
  8019ce:	e8 7a fe ff ff       	call   80184d <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
	return ;
  8019d6:	90                   	nop
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 0c                	push   $0xc
  8019e8:	e8 60 fe ff ff       	call   80184d <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	ff 75 08             	pushl  0x8(%ebp)
  801a00:	6a 0d                	push   $0xd
  801a02:	e8 46 fe ff ff       	call   80184d <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 0e                	push   $0xe
  801a1b:	e8 2d fe ff ff       	call   80184d <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	90                   	nop
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 13                	push   $0x13
  801a35:	e8 13 fe ff ff       	call   80184d <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	90                   	nop
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 14                	push   $0x14
  801a4f:	e8 f9 fd ff ff       	call   80184d <syscall>
  801a54:	83 c4 18             	add    $0x18,%esp
}
  801a57:	90                   	nop
  801a58:	c9                   	leave  
  801a59:	c3                   	ret    

00801a5a <sys_cputc>:


void
sys_cputc(const char c)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 04             	sub    $0x4,%esp
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a66:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	50                   	push   %eax
  801a73:	6a 15                	push   $0x15
  801a75:	e8 d3 fd ff ff       	call   80184d <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	90                   	nop
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 16                	push   $0x16
  801a8f:	e8 b9 fd ff ff       	call   80184d <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	90                   	nop
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	ff 75 0c             	pushl  0xc(%ebp)
  801aa9:	50                   	push   %eax
  801aaa:	6a 17                	push   $0x17
  801aac:	e8 9c fd ff ff       	call   80184d <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	c9                   	leave  
  801ab5:	c3                   	ret    

00801ab6 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ab6:	55                   	push   %ebp
  801ab7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ab9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	52                   	push   %edx
  801ac6:	50                   	push   %eax
  801ac7:	6a 1a                	push   $0x1a
  801ac9:	e8 7f fd ff ff       	call   80184d <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	6a 18                	push   $0x18
  801ae6:	e8 62 fd ff ff       	call   80184d <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	90                   	nop
  801aef:	c9                   	leave  
  801af0:	c3                   	ret    

00801af1 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801af1:	55                   	push   %ebp
  801af2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	52                   	push   %edx
  801b01:	50                   	push   %eax
  801b02:	6a 19                	push   $0x19
  801b04:	e8 44 fd ff ff       	call   80184d <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	90                   	nop
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 04             	sub    $0x4,%esp
  801b15:	8b 45 10             	mov    0x10(%ebp),%eax
  801b18:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b1b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b1e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b22:	8b 45 08             	mov    0x8(%ebp),%eax
  801b25:	6a 00                	push   $0x0
  801b27:	51                   	push   %ecx
  801b28:	52                   	push   %edx
  801b29:	ff 75 0c             	pushl  0xc(%ebp)
  801b2c:	50                   	push   %eax
  801b2d:	6a 1b                	push   $0x1b
  801b2f:	e8 19 fd ff ff       	call   80184d <syscall>
  801b34:	83 c4 18             	add    $0x18,%esp
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 1c                	push   $0x1c
  801b4c:	e8 fc fc ff ff       	call   80184d <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	c9                   	leave  
  801b55:	c3                   	ret    

00801b56 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b59:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	51                   	push   %ecx
  801b67:	52                   	push   %edx
  801b68:	50                   	push   %eax
  801b69:	6a 1d                	push   $0x1d
  801b6b:	e8 dd fc ff ff       	call   80184d <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
}
  801b73:	c9                   	leave  
  801b74:	c3                   	ret    

00801b75 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b75:	55                   	push   %ebp
  801b76:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	52                   	push   %edx
  801b85:	50                   	push   %eax
  801b86:	6a 1e                	push   $0x1e
  801b88:	e8 c0 fc ff ff       	call   80184d <syscall>
  801b8d:	83 c4 18             	add    $0x18,%esp
}
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 1f                	push   $0x1f
  801ba1:	e8 a7 fc ff ff       	call   80184d <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
}
  801ba9:	c9                   	leave  
  801baa:	c3                   	ret    

00801bab <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bab:	55                   	push   %ebp
  801bac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bae:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb1:	6a 00                	push   $0x0
  801bb3:	ff 75 14             	pushl  0x14(%ebp)
  801bb6:	ff 75 10             	pushl  0x10(%ebp)
  801bb9:	ff 75 0c             	pushl  0xc(%ebp)
  801bbc:	50                   	push   %eax
  801bbd:	6a 20                	push   $0x20
  801bbf:	e8 89 fc ff ff       	call   80184d <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	50                   	push   %eax
  801bd8:	6a 21                	push   $0x21
  801bda:	e8 6e fc ff ff       	call   80184d <syscall>
  801bdf:	83 c4 18             	add    $0x18,%esp
}
  801be2:	90                   	nop
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	6a 00                	push   $0x0
  801bf1:	6a 00                	push   $0x0
  801bf3:	50                   	push   %eax
  801bf4:	6a 22                	push   $0x22
  801bf6:	e8 52 fc ff ff       	call   80184d <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 02                	push   $0x2
  801c0f:	e8 39 fc ff ff       	call   80184d <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 03                	push   $0x3
  801c28:	e8 20 fc ff ff       	call   80184d <syscall>
  801c2d:	83 c4 18             	add    $0x18,%esp
}
  801c30:	c9                   	leave  
  801c31:	c3                   	ret    

00801c32 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c32:	55                   	push   %ebp
  801c33:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 04                	push   $0x4
  801c41:	e8 07 fc ff ff       	call   80184d <syscall>
  801c46:	83 c4 18             	add    $0x18,%esp
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <sys_exit_env>:


void sys_exit_env(void)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 23                	push   $0x23
  801c5a:	e8 ee fb ff ff       	call   80184d <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
}
  801c62:	90                   	nop
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
  801c68:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c6b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c6e:	8d 50 04             	lea    0x4(%eax),%edx
  801c71:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	52                   	push   %edx
  801c7b:	50                   	push   %eax
  801c7c:	6a 24                	push   $0x24
  801c7e:	e8 ca fb ff ff       	call   80184d <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
	return result;
  801c86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c89:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c8c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c8f:	89 01                	mov    %eax,(%ecx)
  801c91:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	c9                   	leave  
  801c98:	c2 04 00             	ret    $0x4

00801c9b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	ff 75 10             	pushl  0x10(%ebp)
  801ca5:	ff 75 0c             	pushl  0xc(%ebp)
  801ca8:	ff 75 08             	pushl  0x8(%ebp)
  801cab:	6a 12                	push   $0x12
  801cad:	e8 9b fb ff ff       	call   80184d <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb5:	90                   	nop
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 25                	push   $0x25
  801cc7:	e8 81 fb ff ff       	call   80184d <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	83 ec 04             	sub    $0x4,%esp
  801cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cda:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cdd:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	50                   	push   %eax
  801cea:	6a 26                	push   $0x26
  801cec:	e8 5c fb ff ff       	call   80184d <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf4:	90                   	nop
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <rsttst>:
void rsttst()
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 28                	push   $0x28
  801d06:	e8 42 fb ff ff       	call   80184d <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d0e:	90                   	nop
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 04             	sub    $0x4,%esp
  801d17:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d1d:	8b 55 18             	mov    0x18(%ebp),%edx
  801d20:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d24:	52                   	push   %edx
  801d25:	50                   	push   %eax
  801d26:	ff 75 10             	pushl  0x10(%ebp)
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	6a 27                	push   $0x27
  801d31:	e8 17 fb ff ff       	call   80184d <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
	return ;
  801d39:	90                   	nop
}
  801d3a:	c9                   	leave  
  801d3b:	c3                   	ret    

00801d3c <chktst>:
void chktst(uint32 n)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	ff 75 08             	pushl  0x8(%ebp)
  801d4a:	6a 29                	push   $0x29
  801d4c:	e8 fc fa ff ff       	call   80184d <syscall>
  801d51:	83 c4 18             	add    $0x18,%esp
	return ;
  801d54:	90                   	nop
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <inctst>:

void inctst()
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 2a                	push   $0x2a
  801d66:	e8 e2 fa ff ff       	call   80184d <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d6e:	90                   	nop
}
  801d6f:	c9                   	leave  
  801d70:	c3                   	ret    

00801d71 <gettst>:
uint32 gettst()
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 2b                	push   $0x2b
  801d80:	e8 c8 fa ff ff       	call   80184d <syscall>
  801d85:	83 c4 18             	add    $0x18,%esp
}
  801d88:	c9                   	leave  
  801d89:	c3                   	ret    

00801d8a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 2c                	push   $0x2c
  801d9c:	e8 ac fa ff ff       	call   80184d <syscall>
  801da1:	83 c4 18             	add    $0x18,%esp
  801da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801da7:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dab:	75 07                	jne    801db4 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dad:	b8 01 00 00 00       	mov    $0x1,%eax
  801db2:	eb 05                	jmp    801db9 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801db4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801db9:	c9                   	leave  
  801dba:	c3                   	ret    

00801dbb <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dbb:	55                   	push   %ebp
  801dbc:	89 e5                	mov    %esp,%ebp
  801dbe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 2c                	push   $0x2c
  801dcd:	e8 7b fa ff ff       	call   80184d <syscall>
  801dd2:	83 c4 18             	add    $0x18,%esp
  801dd5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801dd8:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ddc:	75 07                	jne    801de5 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801dde:	b8 01 00 00 00       	mov    $0x1,%eax
  801de3:	eb 05                	jmp    801dea <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 2c                	push   $0x2c
  801dfe:	e8 4a fa ff ff       	call   80184d <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
  801e06:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e09:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e0d:	75 07                	jne    801e16 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e0f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e14:	eb 05                	jmp    801e1b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e16:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 2c                	push   $0x2c
  801e2f:	e8 19 fa ff ff       	call   80184d <syscall>
  801e34:	83 c4 18             	add    $0x18,%esp
  801e37:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e3a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e3e:	75 07                	jne    801e47 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e40:	b8 01 00 00 00       	mov    $0x1,%eax
  801e45:	eb 05                	jmp    801e4c <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	ff 75 08             	pushl  0x8(%ebp)
  801e5c:	6a 2d                	push   $0x2d
  801e5e:	e8 ea f9 ff ff       	call   80184d <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
	return ;
  801e66:	90                   	nop
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e6d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e70:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	6a 00                	push   $0x0
  801e7b:	53                   	push   %ebx
  801e7c:	51                   	push   %ecx
  801e7d:	52                   	push   %edx
  801e7e:	50                   	push   %eax
  801e7f:	6a 2e                	push   $0x2e
  801e81:	e8 c7 f9 ff ff       	call   80184d <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e8c:	c9                   	leave  
  801e8d:	c3                   	ret    

00801e8e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e94:	8b 45 08             	mov    0x8(%ebp),%eax
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	52                   	push   %edx
  801e9e:	50                   	push   %eax
  801e9f:	6a 2f                	push   $0x2f
  801ea1:	e8 a7 f9 ff ff       	call   80184d <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
}
  801ea9:	c9                   	leave  
  801eaa:	c3                   	ret    

00801eab <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eab:	55                   	push   %ebp
  801eac:	89 e5                	mov    %esp,%ebp
  801eae:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eb1:	83 ec 0c             	sub    $0xc,%esp
  801eb4:	68 9c 3b 80 00       	push   $0x803b9c
  801eb9:	e8 df e6 ff ff       	call   80059d <cprintf>
  801ebe:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ec1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ec8:	83 ec 0c             	sub    $0xc,%esp
  801ecb:	68 c8 3b 80 00       	push   $0x803bc8
  801ed0:	e8 c8 e6 ff ff       	call   80059d <cprintf>
  801ed5:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ed8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801edc:	a1 38 41 80 00       	mov    0x804138,%eax
  801ee1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ee4:	eb 56                	jmp    801f3c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ee6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eea:	74 1c                	je     801f08 <print_mem_block_lists+0x5d>
  801eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eef:	8b 50 08             	mov    0x8(%eax),%edx
  801ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef5:	8b 48 08             	mov    0x8(%eax),%ecx
  801ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efb:	8b 40 0c             	mov    0xc(%eax),%eax
  801efe:	01 c8                	add    %ecx,%eax
  801f00:	39 c2                	cmp    %eax,%edx
  801f02:	73 04                	jae    801f08 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f04:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0b:	8b 50 08             	mov    0x8(%eax),%edx
  801f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f11:	8b 40 0c             	mov    0xc(%eax),%eax
  801f14:	01 c2                	add    %eax,%edx
  801f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f19:	8b 40 08             	mov    0x8(%eax),%eax
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	52                   	push   %edx
  801f20:	50                   	push   %eax
  801f21:	68 dd 3b 80 00       	push   $0x803bdd
  801f26:	e8 72 e6 ff ff       	call   80059d <cprintf>
  801f2b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f31:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f34:	a1 40 41 80 00       	mov    0x804140,%eax
  801f39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f3c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f40:	74 07                	je     801f49 <print_mem_block_lists+0x9e>
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 00                	mov    (%eax),%eax
  801f47:	eb 05                	jmp    801f4e <print_mem_block_lists+0xa3>
  801f49:	b8 00 00 00 00       	mov    $0x0,%eax
  801f4e:	a3 40 41 80 00       	mov    %eax,0x804140
  801f53:	a1 40 41 80 00       	mov    0x804140,%eax
  801f58:	85 c0                	test   %eax,%eax
  801f5a:	75 8a                	jne    801ee6 <print_mem_block_lists+0x3b>
  801f5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f60:	75 84                	jne    801ee6 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f62:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f66:	75 10                	jne    801f78 <print_mem_block_lists+0xcd>
  801f68:	83 ec 0c             	sub    $0xc,%esp
  801f6b:	68 ec 3b 80 00       	push   $0x803bec
  801f70:	e8 28 e6 ff ff       	call   80059d <cprintf>
  801f75:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f78:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f7f:	83 ec 0c             	sub    $0xc,%esp
  801f82:	68 10 3c 80 00       	push   $0x803c10
  801f87:	e8 11 e6 ff ff       	call   80059d <cprintf>
  801f8c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f8f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f93:	a1 40 40 80 00       	mov    0x804040,%eax
  801f98:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f9b:	eb 56                	jmp    801ff3 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fa1:	74 1c                	je     801fbf <print_mem_block_lists+0x114>
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	8b 50 08             	mov    0x8(%eax),%edx
  801fa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fac:	8b 48 08             	mov    0x8(%eax),%ecx
  801faf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb5:	01 c8                	add    %ecx,%eax
  801fb7:	39 c2                	cmp    %eax,%edx
  801fb9:	73 04                	jae    801fbf <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fbb:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc2:	8b 50 08             	mov    0x8(%eax),%edx
  801fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcb:	01 c2                	add    %eax,%edx
  801fcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd0:	8b 40 08             	mov    0x8(%eax),%eax
  801fd3:	83 ec 04             	sub    $0x4,%esp
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	68 dd 3b 80 00       	push   $0x803bdd
  801fdd:	e8 bb e5 ff ff       	call   80059d <cprintf>
  801fe2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801feb:	a1 48 40 80 00       	mov    0x804048,%eax
  801ff0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff7:	74 07                	je     802000 <print_mem_block_lists+0x155>
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 00                	mov    (%eax),%eax
  801ffe:	eb 05                	jmp    802005 <print_mem_block_lists+0x15a>
  802000:	b8 00 00 00 00       	mov    $0x0,%eax
  802005:	a3 48 40 80 00       	mov    %eax,0x804048
  80200a:	a1 48 40 80 00       	mov    0x804048,%eax
  80200f:	85 c0                	test   %eax,%eax
  802011:	75 8a                	jne    801f9d <print_mem_block_lists+0xf2>
  802013:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802017:	75 84                	jne    801f9d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802019:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80201d:	75 10                	jne    80202f <print_mem_block_lists+0x184>
  80201f:	83 ec 0c             	sub    $0xc,%esp
  802022:	68 28 3c 80 00       	push   $0x803c28
  802027:	e8 71 e5 ff ff       	call   80059d <cprintf>
  80202c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80202f:	83 ec 0c             	sub    $0xc,%esp
  802032:	68 9c 3b 80 00       	push   $0x803b9c
  802037:	e8 61 e5 ff ff       	call   80059d <cprintf>
  80203c:	83 c4 10             	add    $0x10,%esp

}
  80203f:	90                   	nop
  802040:	c9                   	leave  
  802041:	c3                   	ret    

00802042 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802048:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80204f:	00 00 00 
  802052:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802059:	00 00 00 
  80205c:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802063:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802066:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80206d:	e9 9e 00 00 00       	jmp    802110 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802072:	a1 50 40 80 00       	mov    0x804050,%eax
  802077:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207a:	c1 e2 04             	shl    $0x4,%edx
  80207d:	01 d0                	add    %edx,%eax
  80207f:	85 c0                	test   %eax,%eax
  802081:	75 14                	jne    802097 <initialize_MemBlocksList+0x55>
  802083:	83 ec 04             	sub    $0x4,%esp
  802086:	68 50 3c 80 00       	push   $0x803c50
  80208b:	6a 42                	push   $0x42
  80208d:	68 73 3c 80 00       	push   $0x803c73
  802092:	e8 52 e2 ff ff       	call   8002e9 <_panic>
  802097:	a1 50 40 80 00       	mov    0x804050,%eax
  80209c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80209f:	c1 e2 04             	shl    $0x4,%edx
  8020a2:	01 d0                	add    %edx,%eax
  8020a4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020aa:	89 10                	mov    %edx,(%eax)
  8020ac:	8b 00                	mov    (%eax),%eax
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	74 18                	je     8020ca <initialize_MemBlocksList+0x88>
  8020b2:	a1 48 41 80 00       	mov    0x804148,%eax
  8020b7:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020c0:	c1 e1 04             	shl    $0x4,%ecx
  8020c3:	01 ca                	add    %ecx,%edx
  8020c5:	89 50 04             	mov    %edx,0x4(%eax)
  8020c8:	eb 12                	jmp    8020dc <initialize_MemBlocksList+0x9a>
  8020ca:	a1 50 40 80 00       	mov    0x804050,%eax
  8020cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d2:	c1 e2 04             	shl    $0x4,%edx
  8020d5:	01 d0                	add    %edx,%eax
  8020d7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020dc:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e4:	c1 e2 04             	shl    $0x4,%edx
  8020e7:	01 d0                	add    %edx,%eax
  8020e9:	a3 48 41 80 00       	mov    %eax,0x804148
  8020ee:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f6:	c1 e2 04             	shl    $0x4,%edx
  8020f9:	01 d0                	add    %edx,%eax
  8020fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802102:	a1 54 41 80 00       	mov    0x804154,%eax
  802107:	40                   	inc    %eax
  802108:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80210d:	ff 45 f4             	incl   -0xc(%ebp)
  802110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802113:	3b 45 08             	cmp    0x8(%ebp),%eax
  802116:	0f 82 56 ff ff ff    	jb     802072 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80211c:	90                   	nop
  80211d:	c9                   	leave  
  80211e:	c3                   	ret    

0080211f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80211f:	55                   	push   %ebp
  802120:	89 e5                	mov    %esp,%ebp
  802122:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802125:	8b 45 08             	mov    0x8(%ebp),%eax
  802128:	8b 00                	mov    (%eax),%eax
  80212a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80212d:	eb 19                	jmp    802148 <find_block+0x29>
	{
		if(blk->sva==va)
  80212f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802132:	8b 40 08             	mov    0x8(%eax),%eax
  802135:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802138:	75 05                	jne    80213f <find_block+0x20>
			return (blk);
  80213a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80213d:	eb 36                	jmp    802175 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80213f:	8b 45 08             	mov    0x8(%ebp),%eax
  802142:	8b 40 08             	mov    0x8(%eax),%eax
  802145:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802148:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80214c:	74 07                	je     802155 <find_block+0x36>
  80214e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802151:	8b 00                	mov    (%eax),%eax
  802153:	eb 05                	jmp    80215a <find_block+0x3b>
  802155:	b8 00 00 00 00       	mov    $0x0,%eax
  80215a:	8b 55 08             	mov    0x8(%ebp),%edx
  80215d:	89 42 08             	mov    %eax,0x8(%edx)
  802160:	8b 45 08             	mov    0x8(%ebp),%eax
  802163:	8b 40 08             	mov    0x8(%eax),%eax
  802166:	85 c0                	test   %eax,%eax
  802168:	75 c5                	jne    80212f <find_block+0x10>
  80216a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80216e:	75 bf                	jne    80212f <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802170:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802175:	c9                   	leave  
  802176:	c3                   	ret    

00802177 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802177:	55                   	push   %ebp
  802178:	89 e5                	mov    %esp,%ebp
  80217a:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  80217d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802182:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802185:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  80218c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80218f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802192:	75 65                	jne    8021f9 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802194:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802198:	75 14                	jne    8021ae <insert_sorted_allocList+0x37>
  80219a:	83 ec 04             	sub    $0x4,%esp
  80219d:	68 50 3c 80 00       	push   $0x803c50
  8021a2:	6a 5c                	push   $0x5c
  8021a4:	68 73 3c 80 00       	push   $0x803c73
  8021a9:	e8 3b e1 ff ff       	call   8002e9 <_panic>
  8021ae:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	89 10                	mov    %edx,(%eax)
  8021b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bc:	8b 00                	mov    (%eax),%eax
  8021be:	85 c0                	test   %eax,%eax
  8021c0:	74 0d                	je     8021cf <insert_sorted_allocList+0x58>
  8021c2:	a1 40 40 80 00       	mov    0x804040,%eax
  8021c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ca:	89 50 04             	mov    %edx,0x4(%eax)
  8021cd:	eb 08                	jmp    8021d7 <insert_sorted_allocList+0x60>
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	a3 44 40 80 00       	mov    %eax,0x804044
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	a3 40 40 80 00       	mov    %eax,0x804040
  8021df:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ee:	40                   	inc    %eax
  8021ef:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8021f4:	e9 7b 01 00 00       	jmp    802374 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8021f9:	a1 44 40 80 00       	mov    0x804044,%eax
  8021fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802201:	a1 40 40 80 00       	mov    0x804040,%eax
  802206:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802209:	8b 45 08             	mov    0x8(%ebp),%eax
  80220c:	8b 50 08             	mov    0x8(%eax),%edx
  80220f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802212:	8b 40 08             	mov    0x8(%eax),%eax
  802215:	39 c2                	cmp    %eax,%edx
  802217:	76 65                	jbe    80227e <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221d:	75 14                	jne    802233 <insert_sorted_allocList+0xbc>
  80221f:	83 ec 04             	sub    $0x4,%esp
  802222:	68 8c 3c 80 00       	push   $0x803c8c
  802227:	6a 64                	push   $0x64
  802229:	68 73 3c 80 00       	push   $0x803c73
  80222e:	e8 b6 e0 ff ff       	call   8002e9 <_panic>
  802233:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	89 50 04             	mov    %edx,0x4(%eax)
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	8b 40 04             	mov    0x4(%eax),%eax
  802245:	85 c0                	test   %eax,%eax
  802247:	74 0c                	je     802255 <insert_sorted_allocList+0xde>
  802249:	a1 44 40 80 00       	mov    0x804044,%eax
  80224e:	8b 55 08             	mov    0x8(%ebp),%edx
  802251:	89 10                	mov    %edx,(%eax)
  802253:	eb 08                	jmp    80225d <insert_sorted_allocList+0xe6>
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	a3 40 40 80 00       	mov    %eax,0x804040
  80225d:	8b 45 08             	mov    0x8(%ebp),%eax
  802260:	a3 44 40 80 00       	mov    %eax,0x804044
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80226e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802273:	40                   	inc    %eax
  802274:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802279:	e9 f6 00 00 00       	jmp    802374 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	8b 50 08             	mov    0x8(%eax),%edx
  802284:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802287:	8b 40 08             	mov    0x8(%eax),%eax
  80228a:	39 c2                	cmp    %eax,%edx
  80228c:	73 65                	jae    8022f3 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80228e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802292:	75 14                	jne    8022a8 <insert_sorted_allocList+0x131>
  802294:	83 ec 04             	sub    $0x4,%esp
  802297:	68 50 3c 80 00       	push   $0x803c50
  80229c:	6a 68                	push   $0x68
  80229e:	68 73 3c 80 00       	push   $0x803c73
  8022a3:	e8 41 e0 ff ff       	call   8002e9 <_panic>
  8022a8:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b1:	89 10                	mov    %edx,(%eax)
  8022b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b6:	8b 00                	mov    (%eax),%eax
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	74 0d                	je     8022c9 <insert_sorted_allocList+0x152>
  8022bc:	a1 40 40 80 00       	mov    0x804040,%eax
  8022c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c4:	89 50 04             	mov    %edx,0x4(%eax)
  8022c7:	eb 08                	jmp    8022d1 <insert_sorted_allocList+0x15a>
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	a3 44 40 80 00       	mov    %eax,0x804044
  8022d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d4:	a3 40 40 80 00       	mov    %eax,0x804040
  8022d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022e8:	40                   	inc    %eax
  8022e9:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022ee:	e9 81 00 00 00       	jmp    802374 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022f3:	a1 40 40 80 00       	mov    0x804040,%eax
  8022f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022fb:	eb 51                	jmp    80234e <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	8b 50 08             	mov    0x8(%eax),%edx
  802303:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802306:	8b 40 08             	mov    0x8(%eax),%eax
  802309:	39 c2                	cmp    %eax,%edx
  80230b:	73 39                	jae    802346 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  80230d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802310:	8b 40 04             	mov    0x4(%eax),%eax
  802313:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802316:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802319:	8b 55 08             	mov    0x8(%ebp),%edx
  80231c:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802324:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80232d:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	8b 55 08             	mov    0x8(%ebp),%edx
  802335:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802338:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80233d:	40                   	inc    %eax
  80233e:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  802343:	90                   	nop
				}
			}
		 }

	}
}
  802344:	eb 2e                	jmp    802374 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802346:	a1 48 40 80 00       	mov    0x804048,%eax
  80234b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80234e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802352:	74 07                	je     80235b <insert_sorted_allocList+0x1e4>
  802354:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802357:	8b 00                	mov    (%eax),%eax
  802359:	eb 05                	jmp    802360 <insert_sorted_allocList+0x1e9>
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
  802360:	a3 48 40 80 00       	mov    %eax,0x804048
  802365:	a1 48 40 80 00       	mov    0x804048,%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	75 8f                	jne    8022fd <insert_sorted_allocList+0x186>
  80236e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802372:	75 89                	jne    8022fd <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802374:	90                   	nop
  802375:	c9                   	leave  
  802376:	c3                   	ret    

00802377 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802377:	55                   	push   %ebp
  802378:	89 e5                	mov    %esp,%ebp
  80237a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80237d:	a1 38 41 80 00       	mov    0x804138,%eax
  802382:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802385:	e9 76 01 00 00       	jmp    802500 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80238a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238d:	8b 40 0c             	mov    0xc(%eax),%eax
  802390:	3b 45 08             	cmp    0x8(%ebp),%eax
  802393:	0f 85 8a 00 00 00    	jne    802423 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239d:	75 17                	jne    8023b6 <alloc_block_FF+0x3f>
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	68 af 3c 80 00       	push   $0x803caf
  8023a7:	68 8a 00 00 00       	push   $0x8a
  8023ac:	68 73 3c 80 00       	push   $0x803c73
  8023b1:	e8 33 df ff ff       	call   8002e9 <_panic>
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	74 10                	je     8023cf <alloc_block_FF+0x58>
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c7:	8b 52 04             	mov    0x4(%edx),%edx
  8023ca:	89 50 04             	mov    %edx,0x4(%eax)
  8023cd:	eb 0b                	jmp    8023da <alloc_block_FF+0x63>
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 40 04             	mov    0x4(%eax),%eax
  8023d5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	8b 40 04             	mov    0x4(%eax),%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	74 0f                	je     8023f3 <alloc_block_FF+0x7c>
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ed:	8b 12                	mov    (%edx),%edx
  8023ef:	89 10                	mov    %edx,(%eax)
  8023f1:	eb 0a                	jmp    8023fd <alloc_block_FF+0x86>
  8023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	a3 38 41 80 00       	mov    %eax,0x804138
  8023fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802410:	a1 44 41 80 00       	mov    0x804144,%eax
  802415:	48                   	dec    %eax
  802416:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	e9 10 01 00 00       	jmp    802533 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 40 0c             	mov    0xc(%eax),%eax
  802429:	3b 45 08             	cmp    0x8(%ebp),%eax
  80242c:	0f 86 c6 00 00 00    	jbe    8024f8 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802432:	a1 48 41 80 00       	mov    0x804148,%eax
  802437:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80243a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80243e:	75 17                	jne    802457 <alloc_block_FF+0xe0>
  802440:	83 ec 04             	sub    $0x4,%esp
  802443:	68 af 3c 80 00       	push   $0x803caf
  802448:	68 90 00 00 00       	push   $0x90
  80244d:	68 73 3c 80 00       	push   $0x803c73
  802452:	e8 92 de ff ff       	call   8002e9 <_panic>
  802457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	85 c0                	test   %eax,%eax
  80245e:	74 10                	je     802470 <alloc_block_FF+0xf9>
  802460:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802463:	8b 00                	mov    (%eax),%eax
  802465:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802468:	8b 52 04             	mov    0x4(%edx),%edx
  80246b:	89 50 04             	mov    %edx,0x4(%eax)
  80246e:	eb 0b                	jmp    80247b <alloc_block_FF+0x104>
  802470:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802473:	8b 40 04             	mov    0x4(%eax),%eax
  802476:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80247b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247e:	8b 40 04             	mov    0x4(%eax),%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	74 0f                	je     802494 <alloc_block_FF+0x11d>
  802485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802488:	8b 40 04             	mov    0x4(%eax),%eax
  80248b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80248e:	8b 12                	mov    (%edx),%edx
  802490:	89 10                	mov    %edx,(%eax)
  802492:	eb 0a                	jmp    80249e <alloc_block_FF+0x127>
  802494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802497:	8b 00                	mov    (%eax),%eax
  802499:	a3 48 41 80 00       	mov    %eax,0x804148
  80249e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b1:	a1 54 41 80 00       	mov    0x804154,%eax
  8024b6:	48                   	dec    %eax
  8024b7:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8024bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c2:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	8b 50 08             	mov    0x8(%eax),%edx
  8024cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ce:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8024d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d4:	8b 50 08             	mov    0x8(%eax),%edx
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	01 c2                	add    %eax,%edx
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e8:	2b 45 08             	sub    0x8(%ebp),%eax
  8024eb:	89 c2                	mov    %eax,%edx
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	eb 3b                	jmp    802533 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8024f8:	a1 40 41 80 00       	mov    0x804140,%eax
  8024fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802504:	74 07                	je     80250d <alloc_block_FF+0x196>
  802506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802509:	8b 00                	mov    (%eax),%eax
  80250b:	eb 05                	jmp    802512 <alloc_block_FF+0x19b>
  80250d:	b8 00 00 00 00       	mov    $0x0,%eax
  802512:	a3 40 41 80 00       	mov    %eax,0x804140
  802517:	a1 40 41 80 00       	mov    0x804140,%eax
  80251c:	85 c0                	test   %eax,%eax
  80251e:	0f 85 66 fe ff ff    	jne    80238a <alloc_block_FF+0x13>
  802524:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802528:	0f 85 5c fe ff ff    	jne    80238a <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  80252e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802533:	c9                   	leave  
  802534:	c3                   	ret    

00802535 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802535:	55                   	push   %ebp
  802536:	89 e5                	mov    %esp,%ebp
  802538:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  80253b:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  802542:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802549:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802550:	a1 38 41 80 00       	mov    0x804138,%eax
  802555:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802558:	e9 cf 00 00 00       	jmp    80262c <alloc_block_BF+0xf7>
		{
			c++;
  80255d:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 40 0c             	mov    0xc(%eax),%eax
  802566:	3b 45 08             	cmp    0x8(%ebp),%eax
  802569:	0f 85 8a 00 00 00    	jne    8025f9 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80256f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802573:	75 17                	jne    80258c <alloc_block_BF+0x57>
  802575:	83 ec 04             	sub    $0x4,%esp
  802578:	68 af 3c 80 00       	push   $0x803caf
  80257d:	68 a8 00 00 00       	push   $0xa8
  802582:	68 73 3c 80 00       	push   $0x803c73
  802587:	e8 5d dd ff ff       	call   8002e9 <_panic>
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 00                	mov    (%eax),%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	74 10                	je     8025a5 <alloc_block_BF+0x70>
  802595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80259d:	8b 52 04             	mov    0x4(%edx),%edx
  8025a0:	89 50 04             	mov    %edx,0x4(%eax)
  8025a3:	eb 0b                	jmp    8025b0 <alloc_block_BF+0x7b>
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	8b 40 04             	mov    0x4(%eax),%eax
  8025ab:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 40 04             	mov    0x4(%eax),%eax
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 0f                	je     8025c9 <alloc_block_BF+0x94>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 40 04             	mov    0x4(%eax),%eax
  8025c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c3:	8b 12                	mov    (%edx),%edx
  8025c5:	89 10                	mov    %edx,(%eax)
  8025c7:	eb 0a                	jmp    8025d3 <alloc_block_BF+0x9e>
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	8b 00                	mov    (%eax),%eax
  8025ce:	a3 38 41 80 00       	mov    %eax,0x804138
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8025eb:	48                   	dec    %eax
  8025ec:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	e9 85 01 00 00       	jmp    80277e <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802602:	76 20                	jbe    802624 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 40 0c             	mov    0xc(%eax),%eax
  80260a:	2b 45 08             	sub    0x8(%ebp),%eax
  80260d:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802610:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802613:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802616:	73 0c                	jae    802624 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802618:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80261b:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  80261e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802621:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802624:	a1 40 41 80 00       	mov    0x804140,%eax
  802629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80262c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802630:	74 07                	je     802639 <alloc_block_BF+0x104>
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	8b 00                	mov    (%eax),%eax
  802637:	eb 05                	jmp    80263e <alloc_block_BF+0x109>
  802639:	b8 00 00 00 00       	mov    $0x0,%eax
  80263e:	a3 40 41 80 00       	mov    %eax,0x804140
  802643:	a1 40 41 80 00       	mov    0x804140,%eax
  802648:	85 c0                	test   %eax,%eax
  80264a:	0f 85 0d ff ff ff    	jne    80255d <alloc_block_BF+0x28>
  802650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802654:	0f 85 03 ff ff ff    	jne    80255d <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80265a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802661:	a1 38 41 80 00       	mov    0x804138,%eax
  802666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802669:	e9 dd 00 00 00       	jmp    80274b <alloc_block_BF+0x216>
		{
			if(x==sol)
  80266e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802671:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802674:	0f 85 c6 00 00 00    	jne    802740 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80267a:	a1 48 41 80 00       	mov    0x804148,%eax
  80267f:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802682:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802686:	75 17                	jne    80269f <alloc_block_BF+0x16a>
  802688:	83 ec 04             	sub    $0x4,%esp
  80268b:	68 af 3c 80 00       	push   $0x803caf
  802690:	68 bb 00 00 00       	push   $0xbb
  802695:	68 73 3c 80 00       	push   $0x803c73
  80269a:	e8 4a dc ff ff       	call   8002e9 <_panic>
  80269f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	74 10                	je     8026b8 <alloc_block_BF+0x183>
  8026a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ab:	8b 00                	mov    (%eax),%eax
  8026ad:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026b0:	8b 52 04             	mov    0x4(%edx),%edx
  8026b3:	89 50 04             	mov    %edx,0x4(%eax)
  8026b6:	eb 0b                	jmp    8026c3 <alloc_block_BF+0x18e>
  8026b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026bb:	8b 40 04             	mov    0x4(%eax),%eax
  8026be:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c6:	8b 40 04             	mov    0x4(%eax),%eax
  8026c9:	85 c0                	test   %eax,%eax
  8026cb:	74 0f                	je     8026dc <alloc_block_BF+0x1a7>
  8026cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d0:	8b 40 04             	mov    0x4(%eax),%eax
  8026d3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026d6:	8b 12                	mov    (%edx),%edx
  8026d8:	89 10                	mov    %edx,(%eax)
  8026da:	eb 0a                	jmp    8026e6 <alloc_block_BF+0x1b1>
  8026dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026df:	8b 00                	mov    (%eax),%eax
  8026e1:	a3 48 41 80 00       	mov    %eax,0x804148
  8026e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f9:	a1 54 41 80 00       	mov    0x804154,%eax
  8026fe:	48                   	dec    %eax
  8026ff:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802707:	8b 55 08             	mov    0x8(%ebp),%edx
  80270a:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 50 08             	mov    0x8(%eax),%edx
  802713:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802716:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271c:	8b 50 08             	mov    0x8(%eax),%edx
  80271f:	8b 45 08             	mov    0x8(%ebp),%eax
  802722:	01 c2                	add    %eax,%edx
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  80272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272d:	8b 40 0c             	mov    0xc(%eax),%eax
  802730:	2b 45 08             	sub    0x8(%ebp),%eax
  802733:	89 c2                	mov    %eax,%edx
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  80273b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273e:	eb 3e                	jmp    80277e <alloc_block_BF+0x249>
						 break;
			}
			x++;
  802740:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802743:	a1 40 41 80 00       	mov    0x804140,%eax
  802748:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80274b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80274f:	74 07                	je     802758 <alloc_block_BF+0x223>
  802751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802754:	8b 00                	mov    (%eax),%eax
  802756:	eb 05                	jmp    80275d <alloc_block_BF+0x228>
  802758:	b8 00 00 00 00       	mov    $0x0,%eax
  80275d:	a3 40 41 80 00       	mov    %eax,0x804140
  802762:	a1 40 41 80 00       	mov    0x804140,%eax
  802767:	85 c0                	test   %eax,%eax
  802769:	0f 85 ff fe ff ff    	jne    80266e <alloc_block_BF+0x139>
  80276f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802773:	0f 85 f5 fe ff ff    	jne    80266e <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802779:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277e:	c9                   	leave  
  80277f:	c3                   	ret    

00802780 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  802786:	a1 28 40 80 00       	mov    0x804028,%eax
  80278b:	85 c0                	test   %eax,%eax
  80278d:	75 14                	jne    8027a3 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  80278f:	a1 38 41 80 00       	mov    0x804138,%eax
  802794:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802799:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8027a0:	00 00 00 
	}
	uint32 c=1;
  8027a3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8027aa:	a1 60 41 80 00       	mov    0x804160,%eax
  8027af:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8027b2:	e9 b3 01 00 00       	jmp    80296a <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c0:	0f 85 a9 00 00 00    	jne    80286f <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8027c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c9:	8b 00                	mov    (%eax),%eax
  8027cb:	85 c0                	test   %eax,%eax
  8027cd:	75 0c                	jne    8027db <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8027cf:	a1 38 41 80 00       	mov    0x804138,%eax
  8027d4:	a3 60 41 80 00       	mov    %eax,0x804160
  8027d9:	eb 0a                	jmp    8027e5 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  8027db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027de:	8b 00                	mov    (%eax),%eax
  8027e0:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  8027e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027e9:	75 17                	jne    802802 <alloc_block_NF+0x82>
  8027eb:	83 ec 04             	sub    $0x4,%esp
  8027ee:	68 af 3c 80 00       	push   $0x803caf
  8027f3:	68 e3 00 00 00       	push   $0xe3
  8027f8:	68 73 3c 80 00       	push   $0x803c73
  8027fd:	e8 e7 da ff ff       	call   8002e9 <_panic>
  802802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802805:	8b 00                	mov    (%eax),%eax
  802807:	85 c0                	test   %eax,%eax
  802809:	74 10                	je     80281b <alloc_block_NF+0x9b>
  80280b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802813:	8b 52 04             	mov    0x4(%edx),%edx
  802816:	89 50 04             	mov    %edx,0x4(%eax)
  802819:	eb 0b                	jmp    802826 <alloc_block_NF+0xa6>
  80281b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281e:	8b 40 04             	mov    0x4(%eax),%eax
  802821:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802829:	8b 40 04             	mov    0x4(%eax),%eax
  80282c:	85 c0                	test   %eax,%eax
  80282e:	74 0f                	je     80283f <alloc_block_NF+0xbf>
  802830:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802833:	8b 40 04             	mov    0x4(%eax),%eax
  802836:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802839:	8b 12                	mov    (%edx),%edx
  80283b:	89 10                	mov    %edx,(%eax)
  80283d:	eb 0a                	jmp    802849 <alloc_block_NF+0xc9>
  80283f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802842:	8b 00                	mov    (%eax),%eax
  802844:	a3 38 41 80 00       	mov    %eax,0x804138
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80285c:	a1 44 41 80 00       	mov    0x804144,%eax
  802861:	48                   	dec    %eax
  802862:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	e9 0e 01 00 00       	jmp    80297d <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80286f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802872:	8b 40 0c             	mov    0xc(%eax),%eax
  802875:	3b 45 08             	cmp    0x8(%ebp),%eax
  802878:	0f 86 ce 00 00 00    	jbe    80294c <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80287e:	a1 48 41 80 00       	mov    0x804148,%eax
  802883:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802886:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80288a:	75 17                	jne    8028a3 <alloc_block_NF+0x123>
  80288c:	83 ec 04             	sub    $0x4,%esp
  80288f:	68 af 3c 80 00       	push   $0x803caf
  802894:	68 e9 00 00 00       	push   $0xe9
  802899:	68 73 3c 80 00       	push   $0x803c73
  80289e:	e8 46 da ff ff       	call   8002e9 <_panic>
  8028a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	74 10                	je     8028bc <alloc_block_NF+0x13c>
  8028ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028af:	8b 00                	mov    (%eax),%eax
  8028b1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028b4:	8b 52 04             	mov    0x4(%edx),%edx
  8028b7:	89 50 04             	mov    %edx,0x4(%eax)
  8028ba:	eb 0b                	jmp    8028c7 <alloc_block_NF+0x147>
  8028bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bf:	8b 40 04             	mov    0x4(%eax),%eax
  8028c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ca:	8b 40 04             	mov    0x4(%eax),%eax
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	74 0f                	je     8028e0 <alloc_block_NF+0x160>
  8028d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d4:	8b 40 04             	mov    0x4(%eax),%eax
  8028d7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028da:	8b 12                	mov    (%edx),%edx
  8028dc:	89 10                	mov    %edx,(%eax)
  8028de:	eb 0a                	jmp    8028ea <alloc_block_NF+0x16a>
  8028e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e3:	8b 00                	mov    (%eax),%eax
  8028e5:	a3 48 41 80 00       	mov    %eax,0x804148
  8028ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fd:	a1 54 41 80 00       	mov    0x804154,%eax
  802902:	48                   	dec    %eax
  802903:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	8b 55 08             	mov    0x8(%ebp),%edx
  80290e:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802911:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802914:	8b 50 08             	mov    0x8(%eax),%edx
  802917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291a:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  80291d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802920:	8b 50 08             	mov    0x8(%eax),%edx
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	01 c2                	add    %eax,%edx
  802928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292b:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  80292e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802931:	8b 40 0c             	mov    0xc(%eax),%eax
  802934:	2b 45 08             	sub    0x8(%ebp),%eax
  802937:	89 c2                	mov    %eax,%edx
  802939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293c:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80293f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802942:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802947:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294a:	eb 31                	jmp    80297d <alloc_block_NF+0x1fd>
			 }
		 c++;
  80294c:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80294f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802952:	8b 00                	mov    (%eax),%eax
  802954:	85 c0                	test   %eax,%eax
  802956:	75 0a                	jne    802962 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802958:	a1 38 41 80 00       	mov    0x804138,%eax
  80295d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802960:	eb 08                	jmp    80296a <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80296a:	a1 44 41 80 00       	mov    0x804144,%eax
  80296f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802972:	0f 85 3f fe ff ff    	jne    8027b7 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802978:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80297d:	c9                   	leave  
  80297e:	c3                   	ret    

0080297f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80297f:	55                   	push   %ebp
  802980:	89 e5                	mov    %esp,%ebp
  802982:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802985:	a1 44 41 80 00       	mov    0x804144,%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	75 68                	jne    8029f6 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  80298e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802992:	75 17                	jne    8029ab <insert_sorted_with_merge_freeList+0x2c>
  802994:	83 ec 04             	sub    $0x4,%esp
  802997:	68 50 3c 80 00       	push   $0x803c50
  80299c:	68 0e 01 00 00       	push   $0x10e
  8029a1:	68 73 3c 80 00       	push   $0x803c73
  8029a6:	e8 3e d9 ff ff       	call   8002e9 <_panic>
  8029ab:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	89 10                	mov    %edx,(%eax)
  8029b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b9:	8b 00                	mov    (%eax),%eax
  8029bb:	85 c0                	test   %eax,%eax
  8029bd:	74 0d                	je     8029cc <insert_sorted_with_merge_freeList+0x4d>
  8029bf:	a1 38 41 80 00       	mov    0x804138,%eax
  8029c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ca:	eb 08                	jmp    8029d4 <insert_sorted_with_merge_freeList+0x55>
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	a3 38 41 80 00       	mov    %eax,0x804138
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8029eb:	40                   	inc    %eax
  8029ec:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  8029f1:	e9 8c 06 00 00       	jmp    803082 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  8029f6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  8029fe:	a1 38 41 80 00       	mov    0x804138,%eax
  802a03:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	8b 50 08             	mov    0x8(%eax),%edx
  802a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0f:	8b 40 08             	mov    0x8(%eax),%eax
  802a12:	39 c2                	cmp    %eax,%edx
  802a14:	0f 86 14 01 00 00    	jbe    802b2e <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a1d:	8b 50 0c             	mov    0xc(%eax),%edx
  802a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a23:	8b 40 08             	mov    0x8(%eax),%eax
  802a26:	01 c2                	add    %eax,%edx
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	8b 40 08             	mov    0x8(%eax),%eax
  802a2e:	39 c2                	cmp    %eax,%edx
  802a30:	0f 85 90 00 00 00    	jne    802ac6 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a39:	8b 50 0c             	mov    0xc(%eax),%edx
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	8b 40 0c             	mov    0xc(%eax),%eax
  802a42:	01 c2                	add    %eax,%edx
  802a44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a47:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a62:	75 17                	jne    802a7b <insert_sorted_with_merge_freeList+0xfc>
  802a64:	83 ec 04             	sub    $0x4,%esp
  802a67:	68 50 3c 80 00       	push   $0x803c50
  802a6c:	68 1b 01 00 00       	push   $0x11b
  802a71:	68 73 3c 80 00       	push   $0x803c73
  802a76:	e8 6e d8 ff ff       	call   8002e9 <_panic>
  802a7b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a81:	8b 45 08             	mov    0x8(%ebp),%eax
  802a84:	89 10                	mov    %edx,(%eax)
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	8b 00                	mov    (%eax),%eax
  802a8b:	85 c0                	test   %eax,%eax
  802a8d:	74 0d                	je     802a9c <insert_sorted_with_merge_freeList+0x11d>
  802a8f:	a1 48 41 80 00       	mov    0x804148,%eax
  802a94:	8b 55 08             	mov    0x8(%ebp),%edx
  802a97:	89 50 04             	mov    %edx,0x4(%eax)
  802a9a:	eb 08                	jmp    802aa4 <insert_sorted_with_merge_freeList+0x125>
  802a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa7:	a3 48 41 80 00       	mov    %eax,0x804148
  802aac:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab6:	a1 54 41 80 00       	mov    0x804154,%eax
  802abb:	40                   	inc    %eax
  802abc:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802ac1:	e9 bc 05 00 00       	jmp    803082 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802ac6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aca:	75 17                	jne    802ae3 <insert_sorted_with_merge_freeList+0x164>
  802acc:	83 ec 04             	sub    $0x4,%esp
  802acf:	68 8c 3c 80 00       	push   $0x803c8c
  802ad4:	68 1f 01 00 00       	push   $0x11f
  802ad9:	68 73 3c 80 00       	push   $0x803c73
  802ade:	e8 06 d8 ff ff       	call   8002e9 <_panic>
  802ae3:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aec:	89 50 04             	mov    %edx,0x4(%eax)
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	8b 40 04             	mov    0x4(%eax),%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	74 0c                	je     802b05 <insert_sorted_with_merge_freeList+0x186>
  802af9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802afe:	8b 55 08             	mov    0x8(%ebp),%edx
  802b01:	89 10                	mov    %edx,(%eax)
  802b03:	eb 08                	jmp    802b0d <insert_sorted_with_merge_freeList+0x18e>
  802b05:	8b 45 08             	mov    0x8(%ebp),%eax
  802b08:	a3 38 41 80 00       	mov    %eax,0x804138
  802b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b10:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b1e:	a1 44 41 80 00       	mov    0x804144,%eax
  802b23:	40                   	inc    %eax
  802b24:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802b29:	e9 54 05 00 00       	jmp    803082 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b31:	8b 50 08             	mov    0x8(%eax),%edx
  802b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b37:	8b 40 08             	mov    0x8(%eax),%eax
  802b3a:	39 c2                	cmp    %eax,%edx
  802b3c:	0f 83 20 01 00 00    	jae    802c62 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	8b 50 0c             	mov    0xc(%eax),%edx
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 40 08             	mov    0x8(%eax),%eax
  802b4e:	01 c2                	add    %eax,%edx
  802b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b53:	8b 40 08             	mov    0x8(%eax),%eax
  802b56:	39 c2                	cmp    %eax,%edx
  802b58:	0f 85 9c 00 00 00    	jne    802bfa <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b61:	8b 50 08             	mov    0x8(%eax),%edx
  802b64:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b67:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b6d:	8b 50 0c             	mov    0xc(%eax),%edx
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	8b 40 0c             	mov    0xc(%eax),%eax
  802b76:	01 c2                	add    %eax,%edx
  802b78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7b:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b96:	75 17                	jne    802baf <insert_sorted_with_merge_freeList+0x230>
  802b98:	83 ec 04             	sub    $0x4,%esp
  802b9b:	68 50 3c 80 00       	push   $0x803c50
  802ba0:	68 2a 01 00 00       	push   $0x12a
  802ba5:	68 73 3c 80 00       	push   $0x803c73
  802baa:	e8 3a d7 ff ff       	call   8002e9 <_panic>
  802baf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	89 10                	mov    %edx,(%eax)
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	8b 00                	mov    (%eax),%eax
  802bbf:	85 c0                	test   %eax,%eax
  802bc1:	74 0d                	je     802bd0 <insert_sorted_with_merge_freeList+0x251>
  802bc3:	a1 48 41 80 00       	mov    0x804148,%eax
  802bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bcb:	89 50 04             	mov    %edx,0x4(%eax)
  802bce:	eb 08                	jmp    802bd8 <insert_sorted_with_merge_freeList+0x259>
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdb:	a3 48 41 80 00       	mov    %eax,0x804148
  802be0:	8b 45 08             	mov    0x8(%ebp),%eax
  802be3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bea:	a1 54 41 80 00       	mov    0x804154,%eax
  802bef:	40                   	inc    %eax
  802bf0:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802bf5:	e9 88 04 00 00       	jmp    803082 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802bfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bfe:	75 17                	jne    802c17 <insert_sorted_with_merge_freeList+0x298>
  802c00:	83 ec 04             	sub    $0x4,%esp
  802c03:	68 50 3c 80 00       	push   $0x803c50
  802c08:	68 2e 01 00 00       	push   $0x12e
  802c0d:	68 73 3c 80 00       	push   $0x803c73
  802c12:	e8 d2 d6 ff ff       	call   8002e9 <_panic>
  802c17:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	89 10                	mov    %edx,(%eax)
  802c22:	8b 45 08             	mov    0x8(%ebp),%eax
  802c25:	8b 00                	mov    (%eax),%eax
  802c27:	85 c0                	test   %eax,%eax
  802c29:	74 0d                	je     802c38 <insert_sorted_with_merge_freeList+0x2b9>
  802c2b:	a1 38 41 80 00       	mov    0x804138,%eax
  802c30:	8b 55 08             	mov    0x8(%ebp),%edx
  802c33:	89 50 04             	mov    %edx,0x4(%eax)
  802c36:	eb 08                	jmp    802c40 <insert_sorted_with_merge_freeList+0x2c1>
  802c38:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	a3 38 41 80 00       	mov    %eax,0x804138
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c52:	a1 44 41 80 00       	mov    0x804144,%eax
  802c57:	40                   	inc    %eax
  802c58:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c5d:	e9 20 04 00 00       	jmp    803082 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802c62:	a1 38 41 80 00       	mov    0x804138,%eax
  802c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c6a:	e9 e2 03 00 00       	jmp    803051 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 50 08             	mov    0x8(%eax),%edx
  802c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c78:	8b 40 08             	mov    0x8(%eax),%eax
  802c7b:	39 c2                	cmp    %eax,%edx
  802c7d:	0f 83 c6 03 00 00    	jae    803049 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 40 04             	mov    0x4(%eax),%eax
  802c89:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c8c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c8f:	8b 50 08             	mov    0x8(%eax),%edx
  802c92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c95:	8b 40 0c             	mov    0xc(%eax),%eax
  802c98:	01 d0                	add    %edx,%eax
  802c9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	8b 40 08             	mov    0x8(%eax),%eax
  802ca9:	01 d0                	add    %edx,%eax
  802cab:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	8b 40 08             	mov    0x8(%eax),%eax
  802cb4:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cb7:	74 7a                	je     802d33 <insert_sorted_with_merge_freeList+0x3b4>
  802cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbc:	8b 40 08             	mov    0x8(%eax),%eax
  802cbf:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cc2:	74 6f                	je     802d33 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802cc4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc8:	74 06                	je     802cd0 <insert_sorted_with_merge_freeList+0x351>
  802cca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cce:	75 17                	jne    802ce7 <insert_sorted_with_merge_freeList+0x368>
  802cd0:	83 ec 04             	sub    $0x4,%esp
  802cd3:	68 d0 3c 80 00       	push   $0x803cd0
  802cd8:	68 43 01 00 00       	push   $0x143
  802cdd:	68 73 3c 80 00       	push   $0x803c73
  802ce2:	e8 02 d6 ff ff       	call   8002e9 <_panic>
  802ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cea:	8b 50 04             	mov    0x4(%eax),%edx
  802ced:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf0:	89 50 04             	mov    %edx,0x4(%eax)
  802cf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cf9:	89 10                	mov    %edx,(%eax)
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	74 0d                	je     802d12 <insert_sorted_with_merge_freeList+0x393>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 04             	mov    0x4(%eax),%eax
  802d0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0e:	89 10                	mov    %edx,(%eax)
  802d10:	eb 08                	jmp    802d1a <insert_sorted_with_merge_freeList+0x39b>
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	a3 38 41 80 00       	mov    %eax,0x804138
  802d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d20:	89 50 04             	mov    %edx,0x4(%eax)
  802d23:	a1 44 41 80 00       	mov    0x804144,%eax
  802d28:	40                   	inc    %eax
  802d29:	a3 44 41 80 00       	mov    %eax,0x804144
  802d2e:	e9 14 03 00 00       	jmp    803047 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802d33:	8b 45 08             	mov    0x8(%ebp),%eax
  802d36:	8b 40 08             	mov    0x8(%eax),%eax
  802d39:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d3c:	0f 85 a0 01 00 00    	jne    802ee2 <insert_sorted_with_merge_freeList+0x563>
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 08             	mov    0x8(%eax),%eax
  802d48:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d4b:	0f 85 91 01 00 00    	jne    802ee2 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802d51:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d54:	8b 50 0c             	mov    0xc(%eax),%edx
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	8b 40 0c             	mov    0xc(%eax),%eax
  802d63:	01 c8                	add    %ecx,%eax
  802d65:	01 c2                	add    %eax,%edx
  802d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d6a:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d99:	75 17                	jne    802db2 <insert_sorted_with_merge_freeList+0x433>
  802d9b:	83 ec 04             	sub    $0x4,%esp
  802d9e:	68 50 3c 80 00       	push   $0x803c50
  802da3:	68 4d 01 00 00       	push   $0x14d
  802da8:	68 73 3c 80 00       	push   $0x803c73
  802dad:	e8 37 d5 ff ff       	call   8002e9 <_panic>
  802db2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	89 10                	mov    %edx,(%eax)
  802dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc0:	8b 00                	mov    (%eax),%eax
  802dc2:	85 c0                	test   %eax,%eax
  802dc4:	74 0d                	je     802dd3 <insert_sorted_with_merge_freeList+0x454>
  802dc6:	a1 48 41 80 00       	mov    0x804148,%eax
  802dcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dce:	89 50 04             	mov    %edx,0x4(%eax)
  802dd1:	eb 08                	jmp    802ddb <insert_sorted_with_merge_freeList+0x45c>
  802dd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dde:	a3 48 41 80 00       	mov    %eax,0x804148
  802de3:	8b 45 08             	mov    0x8(%ebp),%eax
  802de6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ded:	a1 54 41 80 00       	mov    0x804154,%eax
  802df2:	40                   	inc    %eax
  802df3:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802df8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802dfc:	75 17                	jne    802e15 <insert_sorted_with_merge_freeList+0x496>
  802dfe:	83 ec 04             	sub    $0x4,%esp
  802e01:	68 af 3c 80 00       	push   $0x803caf
  802e06:	68 4e 01 00 00       	push   $0x14e
  802e0b:	68 73 3c 80 00       	push   $0x803c73
  802e10:	e8 d4 d4 ff ff       	call   8002e9 <_panic>
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	8b 00                	mov    (%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 10                	je     802e2e <insert_sorted_with_merge_freeList+0x4af>
  802e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e21:	8b 00                	mov    (%eax),%eax
  802e23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e26:	8b 52 04             	mov    0x4(%edx),%edx
  802e29:	89 50 04             	mov    %edx,0x4(%eax)
  802e2c:	eb 0b                	jmp    802e39 <insert_sorted_with_merge_freeList+0x4ba>
  802e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e31:	8b 40 04             	mov    0x4(%eax),%eax
  802e34:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3c:	8b 40 04             	mov    0x4(%eax),%eax
  802e3f:	85 c0                	test   %eax,%eax
  802e41:	74 0f                	je     802e52 <insert_sorted_with_merge_freeList+0x4d3>
  802e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e46:	8b 40 04             	mov    0x4(%eax),%eax
  802e49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e4c:	8b 12                	mov    (%edx),%edx
  802e4e:	89 10                	mov    %edx,(%eax)
  802e50:	eb 0a                	jmp    802e5c <insert_sorted_with_merge_freeList+0x4dd>
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	a3 38 41 80 00       	mov    %eax,0x804138
  802e5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e6f:	a1 44 41 80 00       	mov    0x804144,%eax
  802e74:	48                   	dec    %eax
  802e75:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e7e:	75 17                	jne    802e97 <insert_sorted_with_merge_freeList+0x518>
  802e80:	83 ec 04             	sub    $0x4,%esp
  802e83:	68 50 3c 80 00       	push   $0x803c50
  802e88:	68 4f 01 00 00       	push   $0x14f
  802e8d:	68 73 3c 80 00       	push   $0x803c73
  802e92:	e8 52 d4 ff ff       	call   8002e9 <_panic>
  802e97:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	89 10                	mov    %edx,(%eax)
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 00                	mov    (%eax),%eax
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	74 0d                	je     802eb8 <insert_sorted_with_merge_freeList+0x539>
  802eab:	a1 48 41 80 00       	mov    0x804148,%eax
  802eb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eb3:	89 50 04             	mov    %edx,0x4(%eax)
  802eb6:	eb 08                	jmp    802ec0 <insert_sorted_with_merge_freeList+0x541>
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	a3 48 41 80 00       	mov    %eax,0x804148
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ed2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ed7:	40                   	inc    %eax
  802ed8:	a3 54 41 80 00       	mov    %eax,0x804154
  802edd:	e9 65 01 00 00       	jmp    803047 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee5:	8b 40 08             	mov    0x8(%eax),%eax
  802ee8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802eeb:	0f 85 9f 00 00 00    	jne    802f90 <insert_sorted_with_merge_freeList+0x611>
  802ef1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef4:	8b 40 08             	mov    0x8(%eax),%eax
  802ef7:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802efa:	0f 84 90 00 00 00    	je     802f90 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802f00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f03:	8b 50 0c             	mov    0xc(%eax),%edx
  802f06:	8b 45 08             	mov    0x8(%ebp),%eax
  802f09:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0c:	01 c2                	add    %eax,%edx
  802f0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f11:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2c:	75 17                	jne    802f45 <insert_sorted_with_merge_freeList+0x5c6>
  802f2e:	83 ec 04             	sub    $0x4,%esp
  802f31:	68 50 3c 80 00       	push   $0x803c50
  802f36:	68 58 01 00 00       	push   $0x158
  802f3b:	68 73 3c 80 00       	push   $0x803c73
  802f40:	e8 a4 d3 ff ff       	call   8002e9 <_panic>
  802f45:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	89 10                	mov    %edx,(%eax)
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	85 c0                	test   %eax,%eax
  802f57:	74 0d                	je     802f66 <insert_sorted_with_merge_freeList+0x5e7>
  802f59:	a1 48 41 80 00       	mov    0x804148,%eax
  802f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	eb 08                	jmp    802f6e <insert_sorted_with_merge_freeList+0x5ef>
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	a3 48 41 80 00       	mov    %eax,0x804148
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f80:	a1 54 41 80 00       	mov    0x804154,%eax
  802f85:	40                   	inc    %eax
  802f86:	a3 54 41 80 00       	mov    %eax,0x804154
  802f8b:	e9 b7 00 00 00       	jmp    803047 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f90:	8b 45 08             	mov    0x8(%ebp),%eax
  802f93:	8b 40 08             	mov    0x8(%eax),%eax
  802f96:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f99:	0f 84 e2 00 00 00    	je     803081 <insert_sorted_with_merge_freeList+0x702>
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	8b 40 08             	mov    0x8(%eax),%eax
  802fa5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802fa8:	0f 85 d3 00 00 00    	jne    803081 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802fae:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb1:	8b 50 08             	mov    0x8(%eax),%edx
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 50 0c             	mov    0xc(%eax),%edx
  802fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc3:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc6:	01 c2                	add    %eax,%edx
  802fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcb:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fe2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe6:	75 17                	jne    802fff <insert_sorted_with_merge_freeList+0x680>
  802fe8:	83 ec 04             	sub    $0x4,%esp
  802feb:	68 50 3c 80 00       	push   $0x803c50
  802ff0:	68 61 01 00 00       	push   $0x161
  802ff5:	68 73 3c 80 00       	push   $0x803c73
  802ffa:	e8 ea d2 ff ff       	call   8002e9 <_panic>
  802fff:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803005:	8b 45 08             	mov    0x8(%ebp),%eax
  803008:	89 10                	mov    %edx,(%eax)
  80300a:	8b 45 08             	mov    0x8(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	85 c0                	test   %eax,%eax
  803011:	74 0d                	je     803020 <insert_sorted_with_merge_freeList+0x6a1>
  803013:	a1 48 41 80 00       	mov    0x804148,%eax
  803018:	8b 55 08             	mov    0x8(%ebp),%edx
  80301b:	89 50 04             	mov    %edx,0x4(%eax)
  80301e:	eb 08                	jmp    803028 <insert_sorted_with_merge_freeList+0x6a9>
  803020:	8b 45 08             	mov    0x8(%ebp),%eax
  803023:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803028:	8b 45 08             	mov    0x8(%ebp),%eax
  80302b:	a3 48 41 80 00       	mov    %eax,0x804148
  803030:	8b 45 08             	mov    0x8(%ebp),%eax
  803033:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303a:	a1 54 41 80 00       	mov    0x804154,%eax
  80303f:	40                   	inc    %eax
  803040:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803045:	eb 3a                	jmp    803081 <insert_sorted_with_merge_freeList+0x702>
  803047:	eb 38                	jmp    803081 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803049:	a1 40 41 80 00       	mov    0x804140,%eax
  80304e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803051:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803055:	74 07                	je     80305e <insert_sorted_with_merge_freeList+0x6df>
  803057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305a:	8b 00                	mov    (%eax),%eax
  80305c:	eb 05                	jmp    803063 <insert_sorted_with_merge_freeList+0x6e4>
  80305e:	b8 00 00 00 00       	mov    $0x0,%eax
  803063:	a3 40 41 80 00       	mov    %eax,0x804140
  803068:	a1 40 41 80 00       	mov    0x804140,%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	0f 85 fa fb ff ff    	jne    802c6f <insert_sorted_with_merge_freeList+0x2f0>
  803075:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803079:	0f 85 f0 fb ff ff    	jne    802c6f <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  80307f:	eb 01                	jmp    803082 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803081:	90                   	nop
							}

						}
		          }
		}
}
  803082:	90                   	nop
  803083:	c9                   	leave  
  803084:	c3                   	ret    

00803085 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803085:	55                   	push   %ebp
  803086:	89 e5                	mov    %esp,%ebp
  803088:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80308b:	8b 55 08             	mov    0x8(%ebp),%edx
  80308e:	89 d0                	mov    %edx,%eax
  803090:	c1 e0 02             	shl    $0x2,%eax
  803093:	01 d0                	add    %edx,%eax
  803095:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80309c:	01 d0                	add    %edx,%eax
  80309e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030a5:	01 d0                	add    %edx,%eax
  8030a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030ae:	01 d0                	add    %edx,%eax
  8030b0:	c1 e0 04             	shl    $0x4,%eax
  8030b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030bd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030c0:	83 ec 0c             	sub    $0xc,%esp
  8030c3:	50                   	push   %eax
  8030c4:	e8 9c eb ff ff       	call   801c65 <sys_get_virtual_time>
  8030c9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030cc:	eb 41                	jmp    80310f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030ce:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030d1:	83 ec 0c             	sub    $0xc,%esp
  8030d4:	50                   	push   %eax
  8030d5:	e8 8b eb ff ff       	call   801c65 <sys_get_virtual_time>
  8030da:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e3:	29 c2                	sub    %eax,%edx
  8030e5:	89 d0                	mov    %edx,%eax
  8030e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f0:	89 d1                	mov    %edx,%ecx
  8030f2:	29 c1                	sub    %eax,%ecx
  8030f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fa:	39 c2                	cmp    %eax,%edx
  8030fc:	0f 97 c0             	seta   %al
  8030ff:	0f b6 c0             	movzbl %al,%eax
  803102:	29 c1                	sub    %eax,%ecx
  803104:	89 c8                	mov    %ecx,%eax
  803106:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803109:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80310c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803115:	72 b7                	jb     8030ce <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803117:	90                   	nop
  803118:	c9                   	leave  
  803119:	c3                   	ret    

0080311a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80311a:	55                   	push   %ebp
  80311b:	89 e5                	mov    %esp,%ebp
  80311d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803120:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803127:	eb 03                	jmp    80312c <busy_wait+0x12>
  803129:	ff 45 fc             	incl   -0x4(%ebp)
  80312c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80312f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803132:	72 f5                	jb     803129 <busy_wait+0xf>
	return i;
  803134:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803137:	c9                   	leave  
  803138:	c3                   	ret    
  803139:	66 90                	xchg   %ax,%ax
  80313b:	90                   	nop

0080313c <__udivdi3>:
  80313c:	55                   	push   %ebp
  80313d:	57                   	push   %edi
  80313e:	56                   	push   %esi
  80313f:	53                   	push   %ebx
  803140:	83 ec 1c             	sub    $0x1c,%esp
  803143:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803147:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80314b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80314f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803153:	89 ca                	mov    %ecx,%edx
  803155:	89 f8                	mov    %edi,%eax
  803157:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80315b:	85 f6                	test   %esi,%esi
  80315d:	75 2d                	jne    80318c <__udivdi3+0x50>
  80315f:	39 cf                	cmp    %ecx,%edi
  803161:	77 65                	ja     8031c8 <__udivdi3+0x8c>
  803163:	89 fd                	mov    %edi,%ebp
  803165:	85 ff                	test   %edi,%edi
  803167:	75 0b                	jne    803174 <__udivdi3+0x38>
  803169:	b8 01 00 00 00       	mov    $0x1,%eax
  80316e:	31 d2                	xor    %edx,%edx
  803170:	f7 f7                	div    %edi
  803172:	89 c5                	mov    %eax,%ebp
  803174:	31 d2                	xor    %edx,%edx
  803176:	89 c8                	mov    %ecx,%eax
  803178:	f7 f5                	div    %ebp
  80317a:	89 c1                	mov    %eax,%ecx
  80317c:	89 d8                	mov    %ebx,%eax
  80317e:	f7 f5                	div    %ebp
  803180:	89 cf                	mov    %ecx,%edi
  803182:	89 fa                	mov    %edi,%edx
  803184:	83 c4 1c             	add    $0x1c,%esp
  803187:	5b                   	pop    %ebx
  803188:	5e                   	pop    %esi
  803189:	5f                   	pop    %edi
  80318a:	5d                   	pop    %ebp
  80318b:	c3                   	ret    
  80318c:	39 ce                	cmp    %ecx,%esi
  80318e:	77 28                	ja     8031b8 <__udivdi3+0x7c>
  803190:	0f bd fe             	bsr    %esi,%edi
  803193:	83 f7 1f             	xor    $0x1f,%edi
  803196:	75 40                	jne    8031d8 <__udivdi3+0x9c>
  803198:	39 ce                	cmp    %ecx,%esi
  80319a:	72 0a                	jb     8031a6 <__udivdi3+0x6a>
  80319c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031a0:	0f 87 9e 00 00 00    	ja     803244 <__udivdi3+0x108>
  8031a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ab:	89 fa                	mov    %edi,%edx
  8031ad:	83 c4 1c             	add    $0x1c,%esp
  8031b0:	5b                   	pop    %ebx
  8031b1:	5e                   	pop    %esi
  8031b2:	5f                   	pop    %edi
  8031b3:	5d                   	pop    %ebp
  8031b4:	c3                   	ret    
  8031b5:	8d 76 00             	lea    0x0(%esi),%esi
  8031b8:	31 ff                	xor    %edi,%edi
  8031ba:	31 c0                	xor    %eax,%eax
  8031bc:	89 fa                	mov    %edi,%edx
  8031be:	83 c4 1c             	add    $0x1c,%esp
  8031c1:	5b                   	pop    %ebx
  8031c2:	5e                   	pop    %esi
  8031c3:	5f                   	pop    %edi
  8031c4:	5d                   	pop    %ebp
  8031c5:	c3                   	ret    
  8031c6:	66 90                	xchg   %ax,%ax
  8031c8:	89 d8                	mov    %ebx,%eax
  8031ca:	f7 f7                	div    %edi
  8031cc:	31 ff                	xor    %edi,%edi
  8031ce:	89 fa                	mov    %edi,%edx
  8031d0:	83 c4 1c             	add    $0x1c,%esp
  8031d3:	5b                   	pop    %ebx
  8031d4:	5e                   	pop    %esi
  8031d5:	5f                   	pop    %edi
  8031d6:	5d                   	pop    %ebp
  8031d7:	c3                   	ret    
  8031d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031dd:	89 eb                	mov    %ebp,%ebx
  8031df:	29 fb                	sub    %edi,%ebx
  8031e1:	89 f9                	mov    %edi,%ecx
  8031e3:	d3 e6                	shl    %cl,%esi
  8031e5:	89 c5                	mov    %eax,%ebp
  8031e7:	88 d9                	mov    %bl,%cl
  8031e9:	d3 ed                	shr    %cl,%ebp
  8031eb:	89 e9                	mov    %ebp,%ecx
  8031ed:	09 f1                	or     %esi,%ecx
  8031ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031f3:	89 f9                	mov    %edi,%ecx
  8031f5:	d3 e0                	shl    %cl,%eax
  8031f7:	89 c5                	mov    %eax,%ebp
  8031f9:	89 d6                	mov    %edx,%esi
  8031fb:	88 d9                	mov    %bl,%cl
  8031fd:	d3 ee                	shr    %cl,%esi
  8031ff:	89 f9                	mov    %edi,%ecx
  803201:	d3 e2                	shl    %cl,%edx
  803203:	8b 44 24 08          	mov    0x8(%esp),%eax
  803207:	88 d9                	mov    %bl,%cl
  803209:	d3 e8                	shr    %cl,%eax
  80320b:	09 c2                	or     %eax,%edx
  80320d:	89 d0                	mov    %edx,%eax
  80320f:	89 f2                	mov    %esi,%edx
  803211:	f7 74 24 0c          	divl   0xc(%esp)
  803215:	89 d6                	mov    %edx,%esi
  803217:	89 c3                	mov    %eax,%ebx
  803219:	f7 e5                	mul    %ebp
  80321b:	39 d6                	cmp    %edx,%esi
  80321d:	72 19                	jb     803238 <__udivdi3+0xfc>
  80321f:	74 0b                	je     80322c <__udivdi3+0xf0>
  803221:	89 d8                	mov    %ebx,%eax
  803223:	31 ff                	xor    %edi,%edi
  803225:	e9 58 ff ff ff       	jmp    803182 <__udivdi3+0x46>
  80322a:	66 90                	xchg   %ax,%ax
  80322c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803230:	89 f9                	mov    %edi,%ecx
  803232:	d3 e2                	shl    %cl,%edx
  803234:	39 c2                	cmp    %eax,%edx
  803236:	73 e9                	jae    803221 <__udivdi3+0xe5>
  803238:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80323b:	31 ff                	xor    %edi,%edi
  80323d:	e9 40 ff ff ff       	jmp    803182 <__udivdi3+0x46>
  803242:	66 90                	xchg   %ax,%ax
  803244:	31 c0                	xor    %eax,%eax
  803246:	e9 37 ff ff ff       	jmp    803182 <__udivdi3+0x46>
  80324b:	90                   	nop

0080324c <__umoddi3>:
  80324c:	55                   	push   %ebp
  80324d:	57                   	push   %edi
  80324e:	56                   	push   %esi
  80324f:	53                   	push   %ebx
  803250:	83 ec 1c             	sub    $0x1c,%esp
  803253:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803257:	8b 74 24 34          	mov    0x34(%esp),%esi
  80325b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80325f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803263:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803267:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80326b:	89 f3                	mov    %esi,%ebx
  80326d:	89 fa                	mov    %edi,%edx
  80326f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803273:	89 34 24             	mov    %esi,(%esp)
  803276:	85 c0                	test   %eax,%eax
  803278:	75 1a                	jne    803294 <__umoddi3+0x48>
  80327a:	39 f7                	cmp    %esi,%edi
  80327c:	0f 86 a2 00 00 00    	jbe    803324 <__umoddi3+0xd8>
  803282:	89 c8                	mov    %ecx,%eax
  803284:	89 f2                	mov    %esi,%edx
  803286:	f7 f7                	div    %edi
  803288:	89 d0                	mov    %edx,%eax
  80328a:	31 d2                	xor    %edx,%edx
  80328c:	83 c4 1c             	add    $0x1c,%esp
  80328f:	5b                   	pop    %ebx
  803290:	5e                   	pop    %esi
  803291:	5f                   	pop    %edi
  803292:	5d                   	pop    %ebp
  803293:	c3                   	ret    
  803294:	39 f0                	cmp    %esi,%eax
  803296:	0f 87 ac 00 00 00    	ja     803348 <__umoddi3+0xfc>
  80329c:	0f bd e8             	bsr    %eax,%ebp
  80329f:	83 f5 1f             	xor    $0x1f,%ebp
  8032a2:	0f 84 ac 00 00 00    	je     803354 <__umoddi3+0x108>
  8032a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8032ad:	29 ef                	sub    %ebp,%edi
  8032af:	89 fe                	mov    %edi,%esi
  8032b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032b5:	89 e9                	mov    %ebp,%ecx
  8032b7:	d3 e0                	shl    %cl,%eax
  8032b9:	89 d7                	mov    %edx,%edi
  8032bb:	89 f1                	mov    %esi,%ecx
  8032bd:	d3 ef                	shr    %cl,%edi
  8032bf:	09 c7                	or     %eax,%edi
  8032c1:	89 e9                	mov    %ebp,%ecx
  8032c3:	d3 e2                	shl    %cl,%edx
  8032c5:	89 14 24             	mov    %edx,(%esp)
  8032c8:	89 d8                	mov    %ebx,%eax
  8032ca:	d3 e0                	shl    %cl,%eax
  8032cc:	89 c2                	mov    %eax,%edx
  8032ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d2:	d3 e0                	shl    %cl,%eax
  8032d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032dc:	89 f1                	mov    %esi,%ecx
  8032de:	d3 e8                	shr    %cl,%eax
  8032e0:	09 d0                	or     %edx,%eax
  8032e2:	d3 eb                	shr    %cl,%ebx
  8032e4:	89 da                	mov    %ebx,%edx
  8032e6:	f7 f7                	div    %edi
  8032e8:	89 d3                	mov    %edx,%ebx
  8032ea:	f7 24 24             	mull   (%esp)
  8032ed:	89 c6                	mov    %eax,%esi
  8032ef:	89 d1                	mov    %edx,%ecx
  8032f1:	39 d3                	cmp    %edx,%ebx
  8032f3:	0f 82 87 00 00 00    	jb     803380 <__umoddi3+0x134>
  8032f9:	0f 84 91 00 00 00    	je     803390 <__umoddi3+0x144>
  8032ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  803303:	29 f2                	sub    %esi,%edx
  803305:	19 cb                	sbb    %ecx,%ebx
  803307:	89 d8                	mov    %ebx,%eax
  803309:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80330d:	d3 e0                	shl    %cl,%eax
  80330f:	89 e9                	mov    %ebp,%ecx
  803311:	d3 ea                	shr    %cl,%edx
  803313:	09 d0                	or     %edx,%eax
  803315:	89 e9                	mov    %ebp,%ecx
  803317:	d3 eb                	shr    %cl,%ebx
  803319:	89 da                	mov    %ebx,%edx
  80331b:	83 c4 1c             	add    $0x1c,%esp
  80331e:	5b                   	pop    %ebx
  80331f:	5e                   	pop    %esi
  803320:	5f                   	pop    %edi
  803321:	5d                   	pop    %ebp
  803322:	c3                   	ret    
  803323:	90                   	nop
  803324:	89 fd                	mov    %edi,%ebp
  803326:	85 ff                	test   %edi,%edi
  803328:	75 0b                	jne    803335 <__umoddi3+0xe9>
  80332a:	b8 01 00 00 00       	mov    $0x1,%eax
  80332f:	31 d2                	xor    %edx,%edx
  803331:	f7 f7                	div    %edi
  803333:	89 c5                	mov    %eax,%ebp
  803335:	89 f0                	mov    %esi,%eax
  803337:	31 d2                	xor    %edx,%edx
  803339:	f7 f5                	div    %ebp
  80333b:	89 c8                	mov    %ecx,%eax
  80333d:	f7 f5                	div    %ebp
  80333f:	89 d0                	mov    %edx,%eax
  803341:	e9 44 ff ff ff       	jmp    80328a <__umoddi3+0x3e>
  803346:	66 90                	xchg   %ax,%ax
  803348:	89 c8                	mov    %ecx,%eax
  80334a:	89 f2                	mov    %esi,%edx
  80334c:	83 c4 1c             	add    $0x1c,%esp
  80334f:	5b                   	pop    %ebx
  803350:	5e                   	pop    %esi
  803351:	5f                   	pop    %edi
  803352:	5d                   	pop    %ebp
  803353:	c3                   	ret    
  803354:	3b 04 24             	cmp    (%esp),%eax
  803357:	72 06                	jb     80335f <__umoddi3+0x113>
  803359:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80335d:	77 0f                	ja     80336e <__umoddi3+0x122>
  80335f:	89 f2                	mov    %esi,%edx
  803361:	29 f9                	sub    %edi,%ecx
  803363:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803367:	89 14 24             	mov    %edx,(%esp)
  80336a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80336e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803372:	8b 14 24             	mov    (%esp),%edx
  803375:	83 c4 1c             	add    $0x1c,%esp
  803378:	5b                   	pop    %ebx
  803379:	5e                   	pop    %esi
  80337a:	5f                   	pop    %edi
  80337b:	5d                   	pop    %ebp
  80337c:	c3                   	ret    
  80337d:	8d 76 00             	lea    0x0(%esi),%esi
  803380:	2b 04 24             	sub    (%esp),%eax
  803383:	19 fa                	sbb    %edi,%edx
  803385:	89 d1                	mov    %edx,%ecx
  803387:	89 c6                	mov    %eax,%esi
  803389:	e9 71 ff ff ff       	jmp    8032ff <__umoddi3+0xb3>
  80338e:	66 90                	xchg   %ax,%ax
  803390:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803394:	72 ea                	jb     803380 <__umoddi3+0x134>
  803396:	89 d9                	mov    %ebx,%ecx
  803398:	e9 62 ff ff ff       	jmp    8032ff <__umoddi3+0xb3>

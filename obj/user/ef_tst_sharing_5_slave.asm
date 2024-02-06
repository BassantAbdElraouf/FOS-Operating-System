
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 e9 00 00 00       	call   80011f <libmain>
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
  80008c:	68 60 32 80 00       	push   $0x803260
  800091:	6a 12                	push   $0x12
  800093:	68 7c 32 80 00       	push   $0x80327c
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 02 1b 00 00       	call   801ba4 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 9a 32 80 00       	push   $0x80329a
  8000aa:	50                   	push   %eax
  8000ab:	e8 b4 15 00 00       	call   801664 <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 f0 17 00 00       	call   8018ab <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 9c 32 80 00       	push   $0x80329c
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 72 16 00 00       	call   80174b <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 c0 32 80 00       	push   $0x8032c0
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 ba 17 00 00       	call   8018ab <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 d8 32 80 00       	push   $0x8032d8
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 7c 32 80 00       	push   $0x80327c
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 ad 1b 00 00       	call   801cc9 <inctst>

	return;
  80011c:	90                   	nop
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    

0080011f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800125:	e8 61 1a 00 00       	call   801b8b <sys_getenvindex>
  80012a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80012d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800130:	89 d0                	mov    %edx,%eax
  800132:	c1 e0 03             	shl    $0x3,%eax
  800135:	01 d0                	add    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800142:	01 d0                	add    %edx,%eax
  800144:	c1 e0 04             	shl    $0x4,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800151:	a1 20 40 80 00       	mov    0x804020,%eax
  800156:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80015c:	84 c0                	test   %al,%al
  80015e:	74 0f                	je     80016f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800160:	a1 20 40 80 00       	mov    0x804020,%eax
  800165:	05 5c 05 00 00       	add    $0x55c,%eax
  80016a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800173:	7e 0a                	jle    80017f <libmain+0x60>
		binaryname = argv[0];
  800175:	8b 45 0c             	mov    0xc(%ebp),%eax
  800178:	8b 00                	mov    (%eax),%eax
  80017a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	e8 ab fe ff ff       	call   800038 <_main>
  80018d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800190:	e8 03 18 00 00       	call   801998 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 7c 33 80 00       	push   $0x80337c
  80019d:	e8 6d 03 00 00       	call   80050f <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001aa:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	68 a4 33 80 00       	push   $0x8033a4
  8001c5:	e8 45 03 00 00       	call   80050f <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dd:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001ee:	51                   	push   %ecx
  8001ef:	52                   	push   %edx
  8001f0:	50                   	push   %eax
  8001f1:	68 cc 33 80 00       	push   $0x8033cc
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 24 34 80 00       	push   $0x803424
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 7c 33 80 00       	push   $0x80337c
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 83 17 00 00       	call   8019b2 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80022f:	e8 19 00 00 00       	call   80024d <exit>
}
  800234:	90                   	nop
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 00                	push   $0x0
  800242:	e8 10 19 00 00       	call   801b57 <sys_destroy_env>
  800247:	83 c4 10             	add    $0x10,%esp
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <exit>:

void
exit(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800253:	e8 65 19 00 00       	call   801bbd <sys_exit_env>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800261:	8d 45 10             	lea    0x10(%ebp),%eax
  800264:	83 c0 04             	add    $0x4,%eax
  800267:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80026f:	85 c0                	test   %eax,%eax
  800271:	74 16                	je     800289 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800273:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	50                   	push   %eax
  80027c:	68 38 34 80 00       	push   $0x803438
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 3d 34 80 00       	push   $0x80343d
  80029a:	e8 70 02 00 00       	call   80050f <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ab:	50                   	push   %eax
  8002ac:	e8 f3 01 00 00       	call   8004a4 <vcprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	6a 00                	push   $0x0
  8002b9:	68 59 34 80 00       	push   $0x803459
  8002be:	e8 e1 01 00 00       	call   8004a4 <vcprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c6:	e8 82 ff ff ff       	call   80024d <exit>

	// should not return here
	while (1) ;
  8002cb:	eb fe                	jmp    8002cb <_panic+0x70>

008002cd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 50 74             	mov    0x74(%eax),%edx
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	39 c2                	cmp    %eax,%edx
  8002e0:	74 14                	je     8002f6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	68 5c 34 80 00       	push   $0x80345c
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 a8 34 80 00       	push   $0x8034a8
  8002f1:	e8 65 ff ff ff       	call   80025b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800304:	e9 c2 00 00 00       	jmp    8003cb <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	01 d0                	add    %edx,%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	85 c0                	test   %eax,%eax
  80031c:	75 08                	jne    800326 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80031e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800321:	e9 a2 00 00 00       	jmp    8003c8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800326:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800334:	eb 69                	jmp    80039f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800336:	a1 20 40 80 00       	mov    0x804020,%eax
  80033b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800341:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800344:	89 d0                	mov    %edx,%eax
  800346:	01 c0                	add    %eax,%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	c1 e0 03             	shl    $0x3,%eax
  80034d:	01 c8                	add    %ecx,%eax
  80034f:	8a 40 04             	mov    0x4(%eax),%al
  800352:	84 c0                	test   %al,%al
  800354:	75 46                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800356:	a1 20 40 80 00       	mov    0x804020,%eax
  80035b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800361:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	01 c0                	add    %eax,%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	c1 e0 03             	shl    $0x3,%eax
  80036d:	01 c8                	add    %ecx,%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	75 09                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800393:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039a:	eb 12                	jmp    8003ae <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	ff 45 e8             	incl   -0x18(%ebp)
  80039f:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a4:	8b 50 74             	mov    0x74(%eax),%edx
  8003a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003aa:	39 c2                	cmp    %eax,%edx
  8003ac:	77 88                	ja     800336 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b2:	75 14                	jne    8003c8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	68 b4 34 80 00       	push   $0x8034b4
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 a8 34 80 00       	push   $0x8034a8
  8003c3:	e8 93 fe ff ff       	call   80025b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003c8:	ff 45 f0             	incl   -0x10(%ebp)
  8003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d1:	0f 8c 32 ff ff ff    	jl     800309 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e5:	eb 26                	jmp    80040d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	01 c0                	add    %eax,%eax
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	c1 e0 03             	shl    $0x3,%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8a 40 04             	mov    0x4(%eax),%al
  800403:	3c 01                	cmp    $0x1,%al
  800405:	75 03                	jne    80040a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800407:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040a:	ff 45 e0             	incl   -0x20(%ebp)
  80040d:	a1 20 40 80 00       	mov    0x804020,%eax
  800412:	8b 50 74             	mov    0x74(%eax),%edx
  800415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	77 cb                	ja     8003e7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 08 35 80 00       	push   $0x803508
  80042c:	6a 44                	push   $0x44
  80042e:	68 a8 34 80 00       	push   $0x8034a8
  800433:	e8 23 fe ff ff       	call   80025b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800438:	90                   	nop
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800441:	8b 45 0c             	mov    0xc(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	8d 48 01             	lea    0x1(%eax),%ecx
  800449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044c:	89 0a                	mov    %ecx,(%edx)
  80044e:	8b 55 08             	mov    0x8(%ebp),%edx
  800451:	88 d1                	mov    %dl,%cl
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800464:	75 2c                	jne    800492 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800466:	a0 24 40 80 00       	mov    0x804024,%al
  80046b:	0f b6 c0             	movzbl %al,%eax
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	8b 12                	mov    (%edx),%edx
  800473:	89 d1                	mov    %edx,%ecx
  800475:	8b 55 0c             	mov    0xc(%ebp),%edx
  800478:	83 c2 08             	add    $0x8,%edx
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	50                   	push   %eax
  80047f:	51                   	push   %ecx
  800480:	52                   	push   %edx
  800481:	e8 64 13 00 00       	call   8017ea <sys_cputs>
  800486:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
  800495:	8b 40 04             	mov    0x4(%eax),%eax
  800498:	8d 50 01             	lea    0x1(%eax),%edx
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004a1:	90                   	nop
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b4:	00 00 00 
	b.cnt = 0;
  8004b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004be:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	68 3b 04 80 00       	push   $0x80043b
  8004d3:	e8 11 02 00 00       	call   8006e9 <vprintfmt>
  8004d8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004db:	a0 24 40 80 00       	mov    0x804024,%al
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	50                   	push   %eax
  8004ed:	52                   	push   %edx
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	83 c0 08             	add    $0x8,%eax
  8004f7:	50                   	push   %eax
  8004f8:	e8 ed 12 00 00       	call   8017ea <sys_cputs>
  8004fd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800500:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int cprintf(const char *fmt, ...) {
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800515:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80051c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 f4             	pushl  -0xc(%ebp)
  80052b:	50                   	push   %eax
  80052c:	e8 73 ff ff ff       	call   8004a4 <vcprintf>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800537:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800542:	e8 51 14 00 00       	call   801998 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 48 ff ff ff       	call   8004a4 <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800562:	e8 4b 14 00 00       	call   8019b2 <sys_enable_interrupt>
	return cnt;
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	53                   	push   %ebx
  800570:	83 ec 14             	sub    $0x14,%esp
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 18             	mov    0x18(%ebp),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058a:	77 55                	ja     8005e1 <printnum+0x75>
  80058c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058f:	72 05                	jb     800596 <printnum+0x2a>
  800591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800594:	77 4b                	ja     8005e1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800596:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800599:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80059c:	8b 45 18             	mov    0x18(%ebp),%eax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	52                   	push   %edx
  8005a5:	50                   	push   %eax
  8005a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ac:	e8 47 2a 00 00       	call   802ff8 <__udivdi3>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	ff 75 20             	pushl  0x20(%ebp)
  8005ba:	53                   	push   %ebx
  8005bb:	ff 75 18             	pushl  0x18(%ebp)
  8005be:	52                   	push   %edx
  8005bf:	50                   	push   %eax
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 a1 ff ff ff       	call   80056c <printnum>
  8005cb:	83 c4 20             	add    $0x20,%esp
  8005ce:	eb 1a                	jmp    8005ea <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 20             	pushl  0x20(%ebp)
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	ff d0                	call   *%eax
  8005de:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e1:	ff 4d 1c             	decl   0x1c(%ebp)
  8005e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e8:	7f e6                	jg     8005d0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f8:	53                   	push   %ebx
  8005f9:	51                   	push   %ecx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 07 2b 00 00       	call   803108 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 74 37 80 00       	add    $0x803774,%eax
  800609:	8a 00                	mov    (%eax),%al
  80060b:	0f be c0             	movsbl %al,%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
}
  80061d:	90                   	nop
  80061e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800626:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80062a:	7e 1c                	jle    800648 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	8d 50 08             	lea    0x8(%eax),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 10                	mov    %edx,(%eax)
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 e8 08             	sub    $0x8,%eax
  800641:	8b 50 04             	mov    0x4(%eax),%edx
  800644:	8b 00                	mov    (%eax),%eax
  800646:	eb 40                	jmp    800688 <getuint+0x65>
	else if (lflag)
  800648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80064c:	74 1e                	je     80066c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	eb 1c                	jmp    800688 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 10                	mov    %edx,(%eax)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800688:	5d                   	pop    %ebp
  800689:	c3                   	ret    

0080068a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800691:	7e 1c                	jle    8006af <getint+0x25>
		return va_arg(*ap, long long);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 08             	sub    $0x8,%eax
  8006a8:	8b 50 04             	mov    0x4(%eax),%edx
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	eb 38                	jmp    8006e7 <getint+0x5d>
	else if (lflag)
  8006af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b3:	74 1a                	je     8006cf <getint+0x45>
		return va_arg(*ap, long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 04             	sub    $0x4,%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	99                   	cltd   
  8006cd:	eb 18                	jmp    8006e7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 50 04             	lea    0x4(%eax),%edx
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	89 10                	mov    %edx,(%eax)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
}
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f1:	eb 17                	jmp    80070a <vprintfmt+0x21>
			if (ch == '\0')
  8006f3:	85 db                	test   %ebx,%ebx
  8006f5:	0f 84 af 03 00 00    	je     800aaa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	53                   	push   %ebx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	ff d0                	call   *%eax
  800707:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	8d 50 01             	lea    0x1(%eax),%edx
  800710:	89 55 10             	mov    %edx,0x10(%ebp)
  800713:	8a 00                	mov    (%eax),%al
  800715:	0f b6 d8             	movzbl %al,%ebx
  800718:	83 fb 25             	cmp    $0x25,%ebx
  80071b:	75 d6                	jne    8006f3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80071d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800721:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800736:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 45 10             	mov    0x10(%ebp),%eax
  800740:	8d 50 01             	lea    0x1(%eax),%edx
  800743:	89 55 10             	mov    %edx,0x10(%ebp)
  800746:	8a 00                	mov    (%eax),%al
  800748:	0f b6 d8             	movzbl %al,%ebx
  80074b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80074e:	83 f8 55             	cmp    $0x55,%eax
  800751:	0f 87 2b 03 00 00    	ja     800a82 <vprintfmt+0x399>
  800757:	8b 04 85 98 37 80 00 	mov    0x803798(,%eax,4),%eax
  80075e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800760:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800764:	eb d7                	jmp    80073d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800766:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80076a:	eb d1                	jmp    80073d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800773:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800776:	89 d0                	mov    %edx,%eax
  800778:	c1 e0 02             	shl    $0x2,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	01 c0                	add    %eax,%eax
  80077f:	01 d8                	add    %ebx,%eax
  800781:	83 e8 30             	sub    $0x30,%eax
  800784:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800787:	8b 45 10             	mov    0x10(%ebp),%eax
  80078a:	8a 00                	mov    (%eax),%al
  80078c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80078f:	83 fb 2f             	cmp    $0x2f,%ebx
  800792:	7e 3e                	jle    8007d2 <vprintfmt+0xe9>
  800794:	83 fb 39             	cmp    $0x39,%ebx
  800797:	7f 39                	jg     8007d2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800799:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80079c:	eb d5                	jmp    800773 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	83 c0 04             	add    $0x4,%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b2:	eb 1f                	jmp    8007d3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b8:	79 83                	jns    80073d <vprintfmt+0x54>
				width = 0;
  8007ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007c1:	e9 77 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007c6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007cd:	e9 6b ff ff ff       	jmp    80073d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d7:	0f 89 60 ff ff ff    	jns    80073d <vprintfmt+0x54>
				width = precision, precision = -1;
  8007dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ea:	e9 4e ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ef:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f2:	e9 46 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
			break;
  800817:	e9 89 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 c0 04             	add    $0x4,%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80082d:	85 db                	test   %ebx,%ebx
  80082f:	79 02                	jns    800833 <vprintfmt+0x14a>
				err = -err;
  800831:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800833:	83 fb 64             	cmp    $0x64,%ebx
  800836:	7f 0b                	jg     800843 <vprintfmt+0x15a>
  800838:	8b 34 9d e0 35 80 00 	mov    0x8035e0(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 85 37 80 00       	push   $0x803785
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 5e 02 00 00       	call   800ab2 <printfmt>
  800854:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800857:	e9 49 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80085c:	56                   	push   %esi
  80085d:	68 8e 37 80 00       	push   $0x80378e
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 45 02 00 00       	call   800ab2 <printfmt>
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 30 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 30                	mov    (%eax),%esi
  800886:	85 f6                	test   %esi,%esi
  800888:	75 05                	jne    80088f <vprintfmt+0x1a6>
				p = "(null)";
  80088a:	be 91 37 80 00       	mov    $0x803791,%esi
			if (width > 0 && padc != '-')
  80088f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800893:	7e 6d                	jle    800902 <vprintfmt+0x219>
  800895:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800899:	74 67                	je     800902 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	50                   	push   %eax
  8008a2:	56                   	push   %esi
  8008a3:	e8 0c 03 00 00       	call   800bb4 <strnlen>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ae:	eb 16                	jmp    8008c6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ca:	7f e4                	jg     8008b0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cc:	eb 34                	jmp    800902 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d2:	74 1c                	je     8008f0 <vprintfmt+0x207>
  8008d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d7:	7e 05                	jle    8008de <vprintfmt+0x1f5>
  8008d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008dc:	7e 12                	jle    8008f0 <vprintfmt+0x207>
					putch('?', putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	6a 3f                	push   $0x3f
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	eb 0f                	jmp    8008ff <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	53                   	push   %ebx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ff:	ff 4d e4             	decl   -0x1c(%ebp)
  800902:	89 f0                	mov    %esi,%eax
  800904:	8d 70 01             	lea    0x1(%eax),%esi
  800907:	8a 00                	mov    (%eax),%al
  800909:	0f be d8             	movsbl %al,%ebx
  80090c:	85 db                	test   %ebx,%ebx
  80090e:	74 24                	je     800934 <vprintfmt+0x24b>
  800910:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800914:	78 b8                	js     8008ce <vprintfmt+0x1e5>
  800916:	ff 4d e0             	decl   -0x20(%ebp)
  800919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091d:	79 af                	jns    8008ce <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091f:	eb 13                	jmp    800934 <vprintfmt+0x24b>
				putch(' ', putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	6a 20                	push   $0x20
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800931:	ff 4d e4             	decl   -0x1c(%ebp)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7f e7                	jg     800921 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80093a:	e9 66 01 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 e8             	pushl  -0x18(%ebp)
  800945:	8d 45 14             	lea    0x14(%ebp),%eax
  800948:	50                   	push   %eax
  800949:	e8 3c fd ff ff       	call   80068a <getint>
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095d:	85 d2                	test   %edx,%edx
  80095f:	79 23                	jns    800984 <vprintfmt+0x29b>
				putch('-', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	6a 2d                	push   $0x2d
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800977:	f7 d8                	neg    %eax
  800979:	83 d2 00             	adc    $0x0,%edx
  80097c:	f7 da                	neg    %edx
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800984:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80098b:	e9 bc 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 e8             	pushl  -0x18(%ebp)
  800996:	8d 45 14             	lea    0x14(%ebp),%eax
  800999:	50                   	push   %eax
  80099a:	e8 84 fc ff ff       	call   800623 <getuint>
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 98 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	6a 58                	push   $0x58
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 58                	push   $0x58
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 58                	push   $0x58
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 30                	push   $0x30
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 78                	push   $0x78
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 e8 04             	sub    $0x4,%eax
  800a18:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a2b:	eb 1f                	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 e8             	pushl  -0x18(%ebp)
  800a33:	8d 45 14             	lea    0x14(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	e8 e7 fb ff ff       	call   800623 <getuint>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	52                   	push   %edx
  800a57:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 00 fb ff ff       	call   80056c <printnum>
  800a6c:	83 c4 20             	add    $0x20,%esp
			break;
  800a6f:	eb 34                	jmp    800aa5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
			break;
  800a80:	eb 23                	jmp    800aa5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 25                	push   $0x25
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a92:	ff 4d 10             	decl   0x10(%ebp)
  800a95:	eb 03                	jmp    800a9a <vprintfmt+0x3b1>
  800a97:	ff 4d 10             	decl   0x10(%ebp)
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9d:	48                   	dec    %eax
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	3c 25                	cmp    $0x25,%al
  800aa2:	75 f3                	jne    800a97 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aa4:	90                   	nop
		}
	}
  800aa5:	e9 47 fc ff ff       	jmp    8006f1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aaa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ab8:	8d 45 10             	lea    0x10(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 16 fc ff ff       	call   8006e9 <vprintfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ad6:	90                   	nop
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 40 08             	mov    0x8(%eax),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 10                	mov    (%eax),%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	8b 40 04             	mov    0x4(%eax),%eax
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	73 12                	jae    800b0c <sprintputch+0x33>
		*b->buf++ = ch;
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	8d 48 01             	lea    0x1(%eax),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 0a                	mov    %ecx,(%edx)
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	88 10                	mov    %dl,(%eax)
}
  800b0c:	90                   	nop
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b34:	74 06                	je     800b3c <vsnprintf+0x2d>
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	7f 07                	jg     800b43 <vsnprintf+0x34>
		return -E_INVAL;
  800b3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b41:	eb 20                	jmp    800b63 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b43:	ff 75 14             	pushl  0x14(%ebp)
  800b46:	ff 75 10             	pushl  0x10(%ebp)
  800b49:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	68 d9 0a 80 00       	push   $0x800ad9
  800b52:	e8 92 fb ff ff       	call   8006e9 <vprintfmt>
  800b57:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b6e:	83 c0 04             	add    $0x4,%eax
  800b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 89 ff ff ff       	call   800b0f <vsnprintf>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9e:	eb 06                	jmp    800ba6 <strlen+0x15>
		n++;
  800ba0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba3:	ff 45 08             	incl   0x8(%ebp)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	75 f1                	jne    800ba0 <strlen+0xf>
		n++;
	return n;
  800baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc1:	eb 09                	jmp    800bcc <strnlen+0x18>
		n++;
  800bc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc6:	ff 45 08             	incl   0x8(%ebp)
  800bc9:	ff 4d 0c             	decl   0xc(%ebp)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 09                	je     800bdb <strnlen+0x27>
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	84 c0                	test   %al,%al
  800bd9:	75 e8                	jne    800bc3 <strnlen+0xf>
		n++;
	return n;
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bec:	90                   	nop
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8d 50 01             	lea    0x1(%eax),%edx
  800bf3:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bff:	8a 12                	mov    (%edx),%dl
  800c01:	88 10                	mov    %dl,(%eax)
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	75 e4                	jne    800bed <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c21:	eb 1f                	jmp    800c42 <strncpy+0x34>
		*dst++ = *src;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2f:	8a 12                	mov    (%edx),%dl
  800c31:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	74 03                	je     800c3f <strncpy+0x31>
			src++;
  800c3c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3f:	ff 45 fc             	incl   -0x4(%ebp)
  800c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c48:	72 d9                	jb     800c23 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5f:	74 30                	je     800c91 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c61:	eb 16                	jmp    800c79 <strlcpy+0x2a>
			*dst++ = *src++;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c80:	74 09                	je     800c8b <strlcpy+0x3c>
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 d8                	jne    800c63 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c97:	29 c2                	sub    %eax,%edx
  800c99:	89 d0                	mov    %edx,%eax
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ca0:	eb 06                	jmp    800ca8 <strcmp+0xb>
		p++, q++;
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	74 0e                	je     800cbf <strcmp+0x22>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 10                	mov    (%eax),%dl
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	38 c2                	cmp    %al,%dl
  800cbd:	74 e3                	je     800ca2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f b6 d0             	movzbl %al,%edx
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f b6 c0             	movzbl %al,%eax
  800ccf:	29 c2                	sub    %eax,%edx
  800cd1:	89 d0                	mov    %edx,%eax
}
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd8:	eb 09                	jmp    800ce3 <strncmp+0xe>
		n--, p++, q++;
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	74 17                	je     800d00 <strncmp+0x2b>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	84 c0                	test   %al,%al
  800cf0:	74 0e                	je     800d00 <strncmp+0x2b>
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 10                	mov    (%eax),%dl
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	38 c2                	cmp    %al,%dl
  800cfe:	74 da                	je     800cda <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	75 07                	jne    800d0d <strncmp+0x38>
		return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb 14                	jmp    800d21 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 d0             	movzbl %al,%edx
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 c0             	movzbl %al,%eax
  800d1d:	29 c2                	sub    %eax,%edx
  800d1f:	89 d0                	mov    %edx,%eax
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2f:	eb 12                	jmp    800d43 <strchr+0x20>
		if (*s == c)
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d39:	75 05                	jne    800d40 <strchr+0x1d>
			return (char *) s;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	eb 11                	jmp    800d51 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	75 e5                	jne    800d31 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5f:	eb 0d                	jmp    800d6e <strfind+0x1b>
		if (*s == c)
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d69:	74 0e                	je     800d79 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	75 ea                	jne    800d61 <strfind+0xe>
  800d77:	eb 01                	jmp    800d7a <strfind+0x27>
		if (*s == c)
			break;
  800d79:	90                   	nop
	return (char *) s;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d91:	eb 0e                	jmp    800da1 <memset+0x22>
		*p++ = c;
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da1:	ff 4d f8             	decl   -0x8(%ebp)
  800da4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da8:	79 e9                	jns    800d93 <memset+0x14>
		*p++ = c;

	return v;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc1:	eb 16                	jmp    800dd9 <memcpy+0x2a>
		*d++ = *s++;
  800dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 dd                	jne    800dc3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e03:	73 50                	jae    800e55 <memmove+0x6a>
  800e05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e10:	76 43                	jbe    800e55 <memmove+0x6a>
		s += n;
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1e:	eb 10                	jmp    800e30 <memmove+0x45>
			*--d = *--s;
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	ff 4d fc             	decl   -0x4(%ebp)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 e3                	jne    800e20 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3d:	eb 23                	jmp    800e62 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e51:	8a 12                	mov    (%edx),%dl
  800e53:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	75 dd                	jne    800e3f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e79:	eb 2a                	jmp    800ea5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	38 c2                	cmp    %al,%dl
  800e87:	74 16                	je     800e9f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	29 c2                	sub    %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	eb 18                	jmp    800eb7 <memcmp+0x50>
		s1++, s2++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 c9                	jne    800e7b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eca:	eb 15                	jmp    800ee1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	39 c2                	cmp    %eax,%edx
  800edc:	74 0d                	je     800eeb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee7:	72 e3                	jb     800ecc <memfind+0x13>
  800ee9:	eb 01                	jmp    800eec <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eeb:	90                   	nop
	return (void *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	eb 03                	jmp    800f0a <strtol+0x19>
		s++;
  800f07:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 20                	cmp    $0x20,%al
  800f11:	74 f4                	je     800f07 <strtol+0x16>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 09                	cmp    $0x9,%al
  800f1a:	74 eb                	je     800f07 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 2b                	cmp    $0x2b,%al
  800f23:	75 05                	jne    800f2a <strtol+0x39>
		s++;
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	eb 13                	jmp    800f3d <strtol+0x4c>
	else if (*s == '-')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 2d                	cmp    $0x2d,%al
  800f31:	75 0a                	jne    800f3d <strtol+0x4c>
		s++, neg = 1;
  800f33:	ff 45 08             	incl   0x8(%ebp)
  800f36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	74 06                	je     800f49 <strtol+0x58>
  800f43:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f47:	75 20                	jne    800f69 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 30                	cmp    $0x30,%al
  800f50:	75 17                	jne    800f69 <strtol+0x78>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	40                   	inc    %eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 78                	cmp    $0x78,%al
  800f5a:	75 0d                	jne    800f69 <strtol+0x78>
		s += 2, base = 16;
  800f5c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f60:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f67:	eb 28                	jmp    800f91 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 15                	jne    800f84 <strtol+0x93>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 30                	cmp    $0x30,%al
  800f76:	75 0c                	jne    800f84 <strtol+0x93>
		s++, base = 8;
  800f78:	ff 45 08             	incl   0x8(%ebp)
  800f7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f82:	eb 0d                	jmp    800f91 <strtol+0xa0>
	else if (base == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strtol+0xa0>
		base = 10;
  800f8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 2f                	cmp    $0x2f,%al
  800f98:	7e 19                	jle    800fb3 <strtol+0xc2>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 39                	cmp    $0x39,%al
  800fa1:	7f 10                	jg     800fb3 <strtol+0xc2>
			dig = *s - '0';
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f be c0             	movsbl %al,%eax
  800fab:	83 e8 30             	sub    $0x30,%eax
  800fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb1:	eb 42                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 60                	cmp    $0x60,%al
  800fba:	7e 19                	jle    800fd5 <strtol+0xe4>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 7a                	cmp    $0x7a,%al
  800fc3:	7f 10                	jg     800fd5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f be c0             	movsbl %al,%eax
  800fcd:	83 e8 57             	sub    $0x57,%eax
  800fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd3:	eb 20                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 40                	cmp    $0x40,%al
  800fdc:	7e 39                	jle    801017 <strtol+0x126>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 5a                	cmp    $0x5a,%al
  800fe5:	7f 30                	jg     801017 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f be c0             	movsbl %al,%eax
  800fef:	83 e8 37             	sub    $0x37,%eax
  800ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffb:	7d 19                	jge    801016 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	0f af 45 10          	imul   0x10(%ebp),%eax
  801007:	89 c2                	mov    %eax,%edx
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	01 d0                	add    %edx,%eax
  80100e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801011:	e9 7b ff ff ff       	jmp    800f91 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801016:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 08                	je     801025 <strtol+0x134>
		*endptr = (char *) s;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801025:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801029:	74 07                	je     801032 <strtol+0x141>
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	f7 d8                	neg    %eax
  801030:	eb 03                	jmp    801035 <strtol+0x144>
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <ltostr>:

void
ltostr(long value, char *str)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801044:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104f:	79 13                	jns    801064 <ltostr+0x2d>
	{
		neg = 1;
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801061:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106c:	99                   	cltd   
  80106d:	f7 f9                	idiv   %ecx
  80106f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	8d 50 01             	lea    0x1(%eax),%edx
  801078:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801085:	83 c2 30             	add    $0x30,%edx
  801088:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801092:	f7 e9                	imul   %ecx
  801094:	c1 fa 02             	sar    $0x2,%edx
  801097:	89 c8                	mov    %ecx,%eax
  801099:	c1 f8 1f             	sar    $0x1f,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
  8010a0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ab:	f7 e9                	imul   %ecx
  8010ad:	c1 fa 02             	sar    $0x2,%edx
  8010b0:	89 c8                	mov    %ecx,%eax
  8010b2:	c1 f8 1f             	sar    $0x1f,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
  8010b9:	c1 e0 02             	shl    $0x2,%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	01 c0                	add    %eax,%eax
  8010c0:	29 c1                	sub    %eax,%ecx
  8010c2:	89 ca                	mov    %ecx,%edx
  8010c4:	85 d2                	test   %edx,%edx
  8010c6:	75 9c                	jne    801064 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	48                   	dec    %eax
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010da:	74 3d                	je     801119 <ltostr+0xe2>
		start = 1 ;
  8010dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e3:	eb 34                	jmp    801119 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c8                	add    %ecx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801111:	88 02                	mov    %al,(%edx)
		start++ ;
  801113:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801116:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c c4                	jl     8010e5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801121:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	e8 54 fa ff ff       	call   800b91 <strlen>
  80113d:	83 c4 04             	add    $0x4,%esp
  801140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	e8 46 fa ff ff       	call   800b91 <strlen>
  80114b:	83 c4 04             	add    $0x4,%esp
  80114e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 17                	jmp    801178 <strcconcat+0x49>
		final[s] = str1[s] ;
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	01 c8                	add    %ecx,%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801175:	ff 45 fc             	incl   -0x4(%ebp)
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117e:	7c e1                	jl     801161 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801180:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801187:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118e:	eb 1f                	jmp    8011af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 c2                	add    %eax,%edx
  8011a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 c8                	add    %ecx,%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ac:	ff 45 f8             	incl   -0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b5:	7c d9                	jl     801190 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c2:	90                   	nop
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e8:	eb 0c                	jmp    8011f6 <strsplit+0x31>
			*string++ = 0;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	84 c0                	test   %al,%al
  8011fd:	74 18                	je     801217 <strsplit+0x52>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f be c0             	movsbl %al,%eax
  801207:	50                   	push   %eax
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	e8 13 fb ff ff       	call   800d23 <strchr>
  801210:	83 c4 08             	add    $0x8,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	75 d3                	jne    8011ea <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	84 c0                	test   %al,%al
  80121e:	74 5a                	je     80127a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	83 f8 0f             	cmp    $0xf,%eax
  801228:	75 07                	jne    801231 <strsplit+0x6c>
		{
			return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	eb 66                	jmp    801297 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801231:	8b 45 14             	mov    0x14(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	8d 48 01             	lea    0x1(%eax),%ecx
  801239:	8b 55 14             	mov    0x14(%ebp),%edx
  80123c:	89 0a                	mov    %ecx,(%edx)
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	eb 03                	jmp    801254 <strsplit+0x8f>
			string++;
  801251:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	74 8b                	je     8011e8 <strsplit+0x23>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f be c0             	movsbl %al,%eax
  801265:	50                   	push   %eax
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 b5 fa ff ff       	call   800d23 <strchr>
  80126e:	83 c4 08             	add    $0x8,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	74 dc                	je     801251 <strsplit+0x8c>
			string++;
	}
  801275:	e9 6e ff ff ff       	jmp    8011e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80127a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80129f:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	74 1f                	je     8012c7 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012a8:	e8 1d 00 00 00       	call   8012ca <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	68 f0 38 80 00       	push   $0x8038f0
  8012b5:	e8 55 f2 ff ff       	call   80050f <cprintf>
  8012ba:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012bd:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012c4:	00 00 00 
	}
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012d0:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012d7:	00 00 00 
  8012da:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012e1:	00 00 00 
  8012e4:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8012eb:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8012ee:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012f5:	00 00 00 
  8012f8:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012ff:	00 00 00 
  801302:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801309:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80130c:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801313:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801316:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80131d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801320:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801325:	2d 00 10 00 00       	sub    $0x1000,%eax
  80132a:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  80132f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801336:	a1 20 41 80 00       	mov    0x804120,%eax
  80133b:	c1 e0 04             	shl    $0x4,%eax
  80133e:	89 c2                	mov    %eax,%edx
  801340:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801343:	01 d0                	add    %edx,%eax
  801345:	48                   	dec    %eax
  801346:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80134c:	ba 00 00 00 00       	mov    $0x0,%edx
  801351:	f7 75 f0             	divl   -0x10(%ebp)
  801354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801357:	29 d0                	sub    %edx,%eax
  801359:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80135c:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801363:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801366:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80136b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	6a 06                	push   $0x6
  801375:	ff 75 e8             	pushl  -0x18(%ebp)
  801378:	50                   	push   %eax
  801379:	e8 b0 05 00 00       	call   80192e <sys_allocate_chunk>
  80137e:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801381:	a1 20 41 80 00       	mov    0x804120,%eax
  801386:	83 ec 0c             	sub    $0xc,%esp
  801389:	50                   	push   %eax
  80138a:	e8 25 0c 00 00       	call   801fb4 <initialize_MemBlocksList>
  80138f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  801392:	a1 48 41 80 00       	mov    0x804148,%eax
  801397:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  80139a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80139e:	75 14                	jne    8013b4 <initialize_dyn_block_system+0xea>
  8013a0:	83 ec 04             	sub    $0x4,%esp
  8013a3:	68 15 39 80 00       	push   $0x803915
  8013a8:	6a 29                	push   $0x29
  8013aa:	68 33 39 80 00       	push   $0x803933
  8013af:	e8 a7 ee ff ff       	call   80025b <_panic>
  8013b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b7:	8b 00                	mov    (%eax),%eax
  8013b9:	85 c0                	test   %eax,%eax
  8013bb:	74 10                	je     8013cd <initialize_dyn_block_system+0x103>
  8013bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013c5:	8b 52 04             	mov    0x4(%edx),%edx
  8013c8:	89 50 04             	mov    %edx,0x4(%eax)
  8013cb:	eb 0b                	jmp    8013d8 <initialize_dyn_block_system+0x10e>
  8013cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d0:	8b 40 04             	mov    0x4(%eax),%eax
  8013d3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013db:	8b 40 04             	mov    0x4(%eax),%eax
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	74 0f                	je     8013f1 <initialize_dyn_block_system+0x127>
  8013e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e5:	8b 40 04             	mov    0x4(%eax),%eax
  8013e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013eb:	8b 12                	mov    (%edx),%edx
  8013ed:	89 10                	mov    %edx,(%eax)
  8013ef:	eb 0a                	jmp    8013fb <initialize_dyn_block_system+0x131>
  8013f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f4:	8b 00                	mov    (%eax),%eax
  8013f6:	a3 48 41 80 00       	mov    %eax,0x804148
  8013fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801404:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801407:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80140e:	a1 54 41 80 00       	mov    0x804154,%eax
  801413:	48                   	dec    %eax
  801414:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  801419:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801426:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80142d:	83 ec 0c             	sub    $0xc,%esp
  801430:	ff 75 e0             	pushl  -0x20(%ebp)
  801433:	e8 b9 14 00 00       	call   8028f1 <insert_sorted_with_merge_freeList>
  801438:	83 c4 10             	add    $0x10,%esp

}
  80143b:	90                   	nop
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    

0080143e <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801444:	e8 50 fe ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  801449:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80144d:	75 07                	jne    801456 <malloc+0x18>
  80144f:	b8 00 00 00 00       	mov    $0x0,%eax
  801454:	eb 68                	jmp    8014be <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801456:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80145d:	8b 55 08             	mov    0x8(%ebp),%edx
  801460:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801463:	01 d0                	add    %edx,%eax
  801465:	48                   	dec    %eax
  801466:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146c:	ba 00 00 00 00       	mov    $0x0,%edx
  801471:	f7 75 f4             	divl   -0xc(%ebp)
  801474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801477:	29 d0                	sub    %edx,%eax
  801479:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  80147c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801483:	e8 74 08 00 00       	call   801cfc <sys_isUHeapPlacementStrategyFIRSTFIT>
  801488:	85 c0                	test   %eax,%eax
  80148a:	74 2d                	je     8014b9 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  80148c:	83 ec 0c             	sub    $0xc,%esp
  80148f:	ff 75 ec             	pushl  -0x14(%ebp)
  801492:	e8 52 0e 00 00       	call   8022e9 <alloc_block_FF>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  80149d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014a1:	74 16                	je     8014b9 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8014a3:	83 ec 0c             	sub    $0xc,%esp
  8014a6:	ff 75 e8             	pushl  -0x18(%ebp)
  8014a9:	e8 3b 0c 00 00       	call   8020e9 <insert_sorted_allocList>
  8014ae:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8014b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014b4:	8b 40 08             	mov    0x8(%eax),%eax
  8014b7:	eb 05                	jmp    8014be <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8014b9:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    

008014c0 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8014c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c9:	83 ec 08             	sub    $0x8,%esp
  8014cc:	50                   	push   %eax
  8014cd:	68 40 40 80 00       	push   $0x804040
  8014d2:	e8 ba 0b 00 00       	call   802091 <find_block>
  8014d7:	83 c4 10             	add    $0x10,%esp
  8014da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8014dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8014e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8014e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8014ea:	0f 84 9f 00 00 00    	je     80158f <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	83 ec 08             	sub    $0x8,%esp
  8014f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8014f9:	50                   	push   %eax
  8014fa:	e8 f7 03 00 00       	call   8018f6 <sys_free_user_mem>
  8014ff:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801506:	75 14                	jne    80151c <free+0x5c>
  801508:	83 ec 04             	sub    $0x4,%esp
  80150b:	68 15 39 80 00       	push   $0x803915
  801510:	6a 6a                	push   $0x6a
  801512:	68 33 39 80 00       	push   $0x803933
  801517:	e8 3f ed ff ff       	call   80025b <_panic>
  80151c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151f:	8b 00                	mov    (%eax),%eax
  801521:	85 c0                	test   %eax,%eax
  801523:	74 10                	je     801535 <free+0x75>
  801525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801528:	8b 00                	mov    (%eax),%eax
  80152a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80152d:	8b 52 04             	mov    0x4(%edx),%edx
  801530:	89 50 04             	mov    %edx,0x4(%eax)
  801533:	eb 0b                	jmp    801540 <free+0x80>
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	8b 40 04             	mov    0x4(%eax),%eax
  80153b:	a3 44 40 80 00       	mov    %eax,0x804044
  801540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801543:	8b 40 04             	mov    0x4(%eax),%eax
  801546:	85 c0                	test   %eax,%eax
  801548:	74 0f                	je     801559 <free+0x99>
  80154a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154d:	8b 40 04             	mov    0x4(%eax),%eax
  801550:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801553:	8b 12                	mov    (%edx),%edx
  801555:	89 10                	mov    %edx,(%eax)
  801557:	eb 0a                	jmp    801563 <free+0xa3>
  801559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	a3 40 40 80 00       	mov    %eax,0x804040
  801563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80156c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801576:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80157b:	48                   	dec    %eax
  80157c:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  801581:	83 ec 0c             	sub    $0xc,%esp
  801584:	ff 75 f4             	pushl  -0xc(%ebp)
  801587:	e8 65 13 00 00       	call   8028f1 <insert_sorted_with_merge_freeList>
  80158c:	83 c4 10             	add    $0x10,%esp
	}
}
  80158f:	90                   	nop
  801590:	c9                   	leave  
  801591:	c3                   	ret    

00801592 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  801592:	55                   	push   %ebp
  801593:	89 e5                	mov    %esp,%ebp
  801595:	83 ec 28             	sub    $0x28,%esp
  801598:	8b 45 10             	mov    0x10(%ebp),%eax
  80159b:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80159e:	e8 f6 fc ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  8015a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015a7:	75 0a                	jne    8015b3 <smalloc+0x21>
  8015a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ae:	e9 af 00 00 00       	jmp    801662 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8015b3:	e8 44 07 00 00       	call   801cfc <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015b8:	83 f8 01             	cmp    $0x1,%eax
  8015bb:	0f 85 9c 00 00 00    	jne    80165d <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8015c1:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ce:	01 d0                	add    %edx,%eax
  8015d0:	48                   	dec    %eax
  8015d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015dc:	f7 75 f4             	divl   -0xc(%ebp)
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	29 d0                	sub    %edx,%eax
  8015e4:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8015e7:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  8015ee:	76 07                	jbe    8015f7 <smalloc+0x65>
			return NULL;
  8015f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f5:	eb 6b                	jmp    801662 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  8015f7:	83 ec 0c             	sub    $0xc,%esp
  8015fa:	ff 75 0c             	pushl  0xc(%ebp)
  8015fd:	e8 e7 0c 00 00       	call   8022e9 <alloc_block_FF>
  801602:	83 c4 10             	add    $0x10,%esp
  801605:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	ff 75 ec             	pushl  -0x14(%ebp)
  80160e:	e8 d6 0a 00 00       	call   8020e9 <insert_sorted_allocList>
  801613:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801616:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80161a:	75 07                	jne    801623 <smalloc+0x91>
		{
			return NULL;
  80161c:	b8 00 00 00 00       	mov    $0x0,%eax
  801621:	eb 3f                	jmp    801662 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801623:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801626:	8b 40 08             	mov    0x8(%eax),%eax
  801629:	89 c2                	mov    %eax,%edx
  80162b:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  80162f:	52                   	push   %edx
  801630:	50                   	push   %eax
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	e8 45 04 00 00       	call   801a81 <sys_createSharedObject>
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801642:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801646:	74 06                	je     80164e <smalloc+0xbc>
  801648:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80164c:	75 07                	jne    801655 <smalloc+0xc3>
		{
			return NULL;
  80164e:	b8 00 00 00 00       	mov    $0x0,%eax
  801653:	eb 0d                	jmp    801662 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801655:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801658:	8b 40 08             	mov    0x8(%eax),%eax
  80165b:	eb 05                	jmp    801662 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  80165d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166a:	e8 2a fc ff ff       	call   801299 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80166f:	83 ec 08             	sub    $0x8,%esp
  801672:	ff 75 0c             	pushl  0xc(%ebp)
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 2e 04 00 00       	call   801aab <sys_getSizeOfSharedObject>
  80167d:	83 c4 10             	add    $0x10,%esp
  801680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801683:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801687:	75 0a                	jne    801693 <sget+0x2f>
	{
		return NULL;
  801689:	b8 00 00 00 00       	mov    $0x0,%eax
  80168e:	e9 94 00 00 00       	jmp    801727 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801693:	e8 64 06 00 00       	call   801cfc <sys_isUHeapPlacementStrategyFIRSTFIT>
  801698:	85 c0                	test   %eax,%eax
  80169a:	0f 84 82 00 00 00    	je     801722 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8016a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8016a7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b4:	01 d0                	add    %edx,%eax
  8016b6:	48                   	dec    %eax
  8016b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c2:	f7 75 ec             	divl   -0x14(%ebp)
  8016c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016c8:	29 d0                	sub    %edx,%eax
  8016ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d0:	83 ec 0c             	sub    $0xc,%esp
  8016d3:	50                   	push   %eax
  8016d4:	e8 10 0c 00 00       	call   8022e9 <alloc_block_FF>
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8016df:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016e3:	75 07                	jne    8016ec <sget+0x88>
		{
			return NULL;
  8016e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ea:	eb 3b                	jmp    801727 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8016ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ef:	8b 40 08             	mov    0x8(%eax),%eax
  8016f2:	83 ec 04             	sub    $0x4,%esp
  8016f5:	50                   	push   %eax
  8016f6:	ff 75 0c             	pushl  0xc(%ebp)
  8016f9:	ff 75 08             	pushl  0x8(%ebp)
  8016fc:	e8 c7 03 00 00       	call   801ac8 <sys_getSharedObject>
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801707:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80170b:	74 06                	je     801713 <sget+0xaf>
  80170d:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801711:	75 07                	jne    80171a <sget+0xb6>
		{
			return NULL;
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
  801718:	eb 0d                	jmp    801727 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80171a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80171d:	8b 40 08             	mov    0x8(%eax),%eax
  801720:	eb 05                	jmp    801727 <sget+0xc3>
		}
	}
	else
			return NULL;
  801722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801727:	c9                   	leave  
  801728:	c3                   	ret    

00801729 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801729:	55                   	push   %ebp
  80172a:	89 e5                	mov    %esp,%ebp
  80172c:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80172f:	e8 65 fb ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801734:	83 ec 04             	sub    $0x4,%esp
  801737:	68 40 39 80 00       	push   $0x803940
  80173c:	68 e1 00 00 00       	push   $0xe1
  801741:	68 33 39 80 00       	push   $0x803933
  801746:	e8 10 eb ff ff       	call   80025b <_panic>

0080174b <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80174b:	55                   	push   %ebp
  80174c:	89 e5                	mov    %esp,%ebp
  80174e:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801751:	83 ec 04             	sub    $0x4,%esp
  801754:	68 68 39 80 00       	push   $0x803968
  801759:	68 f5 00 00 00       	push   $0xf5
  80175e:	68 33 39 80 00       	push   $0x803933
  801763:	e8 f3 ea ff ff       	call   80025b <_panic>

00801768 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801768:	55                   	push   %ebp
  801769:	89 e5                	mov    %esp,%ebp
  80176b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	68 8c 39 80 00       	push   $0x80398c
  801776:	68 00 01 00 00       	push   $0x100
  80177b:	68 33 39 80 00       	push   $0x803933
  801780:	e8 d6 ea ff ff       	call   80025b <_panic>

00801785 <shrink>:

}
void shrink(uint32 newSize)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
  801788:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80178b:	83 ec 04             	sub    $0x4,%esp
  80178e:	68 8c 39 80 00       	push   $0x80398c
  801793:	68 05 01 00 00       	push   $0x105
  801798:	68 33 39 80 00       	push   $0x803933
  80179d:	e8 b9 ea ff ff       	call   80025b <_panic>

008017a2 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017a2:	55                   	push   %ebp
  8017a3:	89 e5                	mov    %esp,%ebp
  8017a5:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a8:	83 ec 04             	sub    $0x4,%esp
  8017ab:	68 8c 39 80 00       	push   $0x80398c
  8017b0:	68 0a 01 00 00       	push   $0x10a
  8017b5:	68 33 39 80 00       	push   $0x803933
  8017ba:	e8 9c ea ff ff       	call   80025b <_panic>

008017bf <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	57                   	push   %edi
  8017c3:	56                   	push   %esi
  8017c4:	53                   	push   %ebx
  8017c5:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d1:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d4:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017d7:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017da:	cd 30                	int    $0x30
  8017dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017e2:	83 c4 10             	add    $0x10,%esp
  8017e5:	5b                   	pop    %ebx
  8017e6:	5e                   	pop    %esi
  8017e7:	5f                   	pop    %edi
  8017e8:	5d                   	pop    %ebp
  8017e9:	c3                   	ret    

008017ea <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 04             	sub    $0x4,%esp
  8017f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017f6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	6a 00                	push   $0x0
  8017ff:	6a 00                	push   $0x0
  801801:	52                   	push   %edx
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	50                   	push   %eax
  801806:	6a 00                	push   $0x0
  801808:	e8 b2 ff ff ff       	call   8017bf <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	90                   	nop
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <sys_cgetc>:

int
sys_cgetc(void)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801816:	6a 00                	push   $0x0
  801818:	6a 00                	push   $0x0
  80181a:	6a 00                	push   $0x0
  80181c:	6a 00                	push   $0x0
  80181e:	6a 00                	push   $0x0
  801820:	6a 01                	push   $0x1
  801822:	e8 98 ff ff ff       	call   8017bf <syscall>
  801827:	83 c4 18             	add    $0x18,%esp
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80182f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	6a 00                	push   $0x0
  801837:	6a 00                	push   $0x0
  801839:	6a 00                	push   $0x0
  80183b:	52                   	push   %edx
  80183c:	50                   	push   %eax
  80183d:	6a 05                	push   $0x5
  80183f:	e8 7b ff ff ff       	call   8017bf <syscall>
  801844:	83 c4 18             	add    $0x18,%esp
}
  801847:	c9                   	leave  
  801848:	c3                   	ret    

00801849 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801849:	55                   	push   %ebp
  80184a:	89 e5                	mov    %esp,%ebp
  80184c:	56                   	push   %esi
  80184d:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80184e:	8b 75 18             	mov    0x18(%ebp),%esi
  801851:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801854:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801857:	8b 55 0c             	mov    0xc(%ebp),%edx
  80185a:	8b 45 08             	mov    0x8(%ebp),%eax
  80185d:	56                   	push   %esi
  80185e:	53                   	push   %ebx
  80185f:	51                   	push   %ecx
  801860:	52                   	push   %edx
  801861:	50                   	push   %eax
  801862:	6a 06                	push   $0x6
  801864:	e8 56 ff ff ff       	call   8017bf <syscall>
  801869:	83 c4 18             	add    $0x18,%esp
}
  80186c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80186f:	5b                   	pop    %ebx
  801870:	5e                   	pop    %esi
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    

00801873 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801876:	8b 55 0c             	mov    0xc(%ebp),%edx
  801879:	8b 45 08             	mov    0x8(%ebp),%eax
  80187c:	6a 00                	push   $0x0
  80187e:	6a 00                	push   $0x0
  801880:	6a 00                	push   $0x0
  801882:	52                   	push   %edx
  801883:	50                   	push   %eax
  801884:	6a 07                	push   $0x7
  801886:	e8 34 ff ff ff       	call   8017bf <syscall>
  80188b:	83 c4 18             	add    $0x18,%esp
}
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    

00801890 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801890:	55                   	push   %ebp
  801891:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	ff 75 08             	pushl  0x8(%ebp)
  80189f:	6a 08                	push   $0x8
  8018a1:	e8 19 ff ff ff       	call   8017bf <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 00                	push   $0x0
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	6a 09                	push   $0x9
  8018ba:	e8 00 ff ff ff       	call   8017bf <syscall>
  8018bf:	83 c4 18             	add    $0x18,%esp
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 0a                	push   $0xa
  8018d3:	e8 e7 fe ff ff       	call   8017bf <syscall>
  8018d8:	83 c4 18             	add    $0x18,%esp
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    

008018dd <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018dd:	55                   	push   %ebp
  8018de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 00                	push   $0x0
  8018ea:	6a 0b                	push   $0xb
  8018ec:	e8 ce fe ff ff       	call   8017bf <syscall>
  8018f1:	83 c4 18             	add    $0x18,%esp
}
  8018f4:	c9                   	leave  
  8018f5:	c3                   	ret    

008018f6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018f6:	55                   	push   %ebp
  8018f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	ff 75 0c             	pushl  0xc(%ebp)
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	6a 0f                	push   $0xf
  801907:	e8 b3 fe ff ff       	call   8017bf <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
	return;
  80190f:	90                   	nop
}
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801915:	6a 00                	push   $0x0
  801917:	6a 00                	push   $0x0
  801919:	6a 00                	push   $0x0
  80191b:	ff 75 0c             	pushl  0xc(%ebp)
  80191e:	ff 75 08             	pushl  0x8(%ebp)
  801921:	6a 10                	push   $0x10
  801923:	e8 97 fe ff ff       	call   8017bf <syscall>
  801928:	83 c4 18             	add    $0x18,%esp
	return ;
  80192b:	90                   	nop
}
  80192c:	c9                   	leave  
  80192d:	c3                   	ret    

0080192e <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	ff 75 10             	pushl  0x10(%ebp)
  801938:	ff 75 0c             	pushl  0xc(%ebp)
  80193b:	ff 75 08             	pushl  0x8(%ebp)
  80193e:	6a 11                	push   $0x11
  801940:	e8 7a fe ff ff       	call   8017bf <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return ;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 0c                	push   $0xc
  80195a:	e8 60 fe ff ff       	call   8017bf <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	ff 75 08             	pushl  0x8(%ebp)
  801972:	6a 0d                	push   $0xd
  801974:	e8 46 fe ff ff       	call   8017bf <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_scarce_memory>:

void sys_scarce_memory()
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 0e                	push   $0xe
  80198d:	e8 2d fe ff ff       	call   8017bf <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	90                   	nop
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 13                	push   $0x13
  8019a7:	e8 13 fe ff ff       	call   8017bf <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
}
  8019af:	90                   	nop
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 00                	push   $0x0
  8019bd:	6a 00                	push   $0x0
  8019bf:	6a 14                	push   $0x14
  8019c1:	e8 f9 fd ff ff       	call   8017bf <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
}
  8019c9:	90                   	nop
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_cputc>:


void
sys_cputc(const char c)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 04             	sub    $0x4,%esp
  8019d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d5:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019d8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	50                   	push   %eax
  8019e5:	6a 15                	push   $0x15
  8019e7:	e8 d3 fd ff ff       	call   8017bf <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	90                   	nop
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 16                	push   $0x16
  801a01:	e8 b9 fd ff ff       	call   8017bf <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	90                   	nop
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	ff 75 0c             	pushl  0xc(%ebp)
  801a1b:	50                   	push   %eax
  801a1c:	6a 17                	push   $0x17
  801a1e:	e8 9c fd ff ff       	call   8017bf <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	52                   	push   %edx
  801a38:	50                   	push   %eax
  801a39:	6a 1a                	push   $0x1a
  801a3b:	e8 7f fd ff ff       	call   8017bf <syscall>
  801a40:	83 c4 18             	add    $0x18,%esp
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a48:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	52                   	push   %edx
  801a55:	50                   	push   %eax
  801a56:	6a 18                	push   $0x18
  801a58:	e8 62 fd ff ff       	call   8017bf <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	90                   	nop
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a66:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a69:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	52                   	push   %edx
  801a73:	50                   	push   %eax
  801a74:	6a 19                	push   $0x19
  801a76:	e8 44 fd ff ff       	call   8017bf <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	90                   	nop
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
  801a84:	83 ec 04             	sub    $0x4,%esp
  801a87:	8b 45 10             	mov    0x10(%ebp),%eax
  801a8a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a8d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a90:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a94:	8b 45 08             	mov    0x8(%ebp),%eax
  801a97:	6a 00                	push   $0x0
  801a99:	51                   	push   %ecx
  801a9a:	52                   	push   %edx
  801a9b:	ff 75 0c             	pushl  0xc(%ebp)
  801a9e:	50                   	push   %eax
  801a9f:	6a 1b                	push   $0x1b
  801aa1:	e8 19 fd ff ff       	call   8017bf <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	c9                   	leave  
  801aaa:	c3                   	ret    

00801aab <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801aae:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	52                   	push   %edx
  801abb:	50                   	push   %eax
  801abc:	6a 1c                	push   $0x1c
  801abe:	e8 fc fc ff ff       	call   8017bf <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801acb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ace:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	51                   	push   %ecx
  801ad9:	52                   	push   %edx
  801ada:	50                   	push   %eax
  801adb:	6a 1d                	push   $0x1d
  801add:	e8 dd fc ff ff       	call   8017bf <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
}
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801aea:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aed:	8b 45 08             	mov    0x8(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	52                   	push   %edx
  801af7:	50                   	push   %eax
  801af8:	6a 1e                	push   $0x1e
  801afa:	e8 c0 fc ff ff       	call   8017bf <syscall>
  801aff:	83 c4 18             	add    $0x18,%esp
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 1f                	push   $0x1f
  801b13:	e8 a7 fc ff ff       	call   8017bf <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	ff 75 14             	pushl  0x14(%ebp)
  801b28:	ff 75 10             	pushl  0x10(%ebp)
  801b2b:	ff 75 0c             	pushl  0xc(%ebp)
  801b2e:	50                   	push   %eax
  801b2f:	6a 20                	push   $0x20
  801b31:	e8 89 fc ff ff       	call   8017bf <syscall>
  801b36:	83 c4 18             	add    $0x18,%esp
}
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	50                   	push   %eax
  801b4a:	6a 21                	push   $0x21
  801b4c:	e8 6e fc ff ff       	call   8017bf <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	50                   	push   %eax
  801b66:	6a 22                	push   $0x22
  801b68:	e8 52 fc ff ff       	call   8017bf <syscall>
  801b6d:	83 c4 18             	add    $0x18,%esp
}
  801b70:	c9                   	leave  
  801b71:	c3                   	ret    

00801b72 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 02                	push   $0x2
  801b81:	e8 39 fc ff ff       	call   8017bf <syscall>
  801b86:	83 c4 18             	add    $0x18,%esp
}
  801b89:	c9                   	leave  
  801b8a:	c3                   	ret    

00801b8b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b8b:	55                   	push   %ebp
  801b8c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	6a 00                	push   $0x0
  801b98:	6a 03                	push   $0x3
  801b9a:	e8 20 fc ff ff       	call   8017bf <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 04                	push   $0x4
  801bb3:	e8 07 fc ff ff       	call   8017bf <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_exit_env>:


void sys_exit_env(void)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 23                	push   $0x23
  801bcc:	e8 ee fb ff ff       	call   8017bf <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
}
  801bd4:	90                   	nop
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bdd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be0:	8d 50 04             	lea    0x4(%eax),%edx
  801be3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	52                   	push   %edx
  801bed:	50                   	push   %eax
  801bee:	6a 24                	push   $0x24
  801bf0:	e8 ca fb ff ff       	call   8017bf <syscall>
  801bf5:	83 c4 18             	add    $0x18,%esp
	return result;
  801bf8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bfe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c01:	89 01                	mov    %eax,(%ecx)
  801c03:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	c9                   	leave  
  801c0a:	c2 04 00             	ret    $0x4

00801c0d <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	ff 75 10             	pushl  0x10(%ebp)
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	6a 12                	push   $0x12
  801c1f:	e8 9b fb ff ff       	call   8017bf <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
	return ;
  801c27:	90                   	nop
}
  801c28:	c9                   	leave  
  801c29:	c3                   	ret    

00801c2a <sys_rcr2>:
uint32 sys_rcr2()
{
  801c2a:	55                   	push   %ebp
  801c2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c2d:	6a 00                	push   $0x0
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 25                	push   $0x25
  801c39:	e8 81 fb ff ff       	call   8017bf <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
  801c46:	83 ec 04             	sub    $0x4,%esp
  801c49:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c4f:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	50                   	push   %eax
  801c5c:	6a 26                	push   $0x26
  801c5e:	e8 5c fb ff ff       	call   8017bf <syscall>
  801c63:	83 c4 18             	add    $0x18,%esp
	return ;
  801c66:	90                   	nop
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <rsttst>:
void rsttst()
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 28                	push   $0x28
  801c78:	e8 42 fb ff ff       	call   8017bf <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801c80:	90                   	nop
}
  801c81:	c9                   	leave  
  801c82:	c3                   	ret    

00801c83 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c83:	55                   	push   %ebp
  801c84:	89 e5                	mov    %esp,%ebp
  801c86:	83 ec 04             	sub    $0x4,%esp
  801c89:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c8f:	8b 55 18             	mov    0x18(%ebp),%edx
  801c92:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c96:	52                   	push   %edx
  801c97:	50                   	push   %eax
  801c98:	ff 75 10             	pushl  0x10(%ebp)
  801c9b:	ff 75 0c             	pushl  0xc(%ebp)
  801c9e:	ff 75 08             	pushl  0x8(%ebp)
  801ca1:	6a 27                	push   $0x27
  801ca3:	e8 17 fb ff ff       	call   8017bf <syscall>
  801ca8:	83 c4 18             	add    $0x18,%esp
	return ;
  801cab:	90                   	nop
}
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    

00801cae <chktst>:
void chktst(uint32 n)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	ff 75 08             	pushl  0x8(%ebp)
  801cbc:	6a 29                	push   $0x29
  801cbe:	e8 fc fa ff ff       	call   8017bf <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc6:	90                   	nop
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <inctst>:

void inctst()
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 2a                	push   $0x2a
  801cd8:	e8 e2 fa ff ff       	call   8017bf <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce0:	90                   	nop
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <gettst>:
uint32 gettst()
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 2b                	push   $0x2b
  801cf2:	e8 c8 fa ff ff       	call   8017bf <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
}
  801cfa:	c9                   	leave  
  801cfb:	c3                   	ret    

00801cfc <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801cfc:	55                   	push   %ebp
  801cfd:	89 e5                	mov    %esp,%ebp
  801cff:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 2c                	push   $0x2c
  801d0e:	e8 ac fa ff ff       	call   8017bf <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
  801d16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d19:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d1d:	75 07                	jne    801d26 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801d24:	eb 05                	jmp    801d2b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 2c                	push   $0x2c
  801d3f:	e8 7b fa ff ff       	call   8017bf <syscall>
  801d44:	83 c4 18             	add    $0x18,%esp
  801d47:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d4a:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d4e:	75 07                	jne    801d57 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d50:	b8 01 00 00 00       	mov    $0x1,%eax
  801d55:	eb 05                	jmp    801d5c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d5c:	c9                   	leave  
  801d5d:	c3                   	ret    

00801d5e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801d70:	e8 4a fa ff ff       	call   8017bf <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
  801d78:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d7b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d7f:	75 07                	jne    801d88 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d81:	b8 01 00 00 00       	mov    $0x1,%eax
  801d86:	eb 05                	jmp    801d8d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801da1:	e8 19 fa ff ff       	call   8017bf <syscall>
  801da6:	83 c4 18             	add    $0x18,%esp
  801da9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dac:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801db0:	75 07                	jne    801db9 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801db2:	b8 01 00 00 00       	mov    $0x1,%eax
  801db7:	eb 05                	jmp    801dbe <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801db9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dbe:	c9                   	leave  
  801dbf:	c3                   	ret    

00801dc0 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dc0:	55                   	push   %ebp
  801dc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	ff 75 08             	pushl  0x8(%ebp)
  801dce:	6a 2d                	push   $0x2d
  801dd0:	e8 ea f9 ff ff       	call   8017bf <syscall>
  801dd5:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd8:	90                   	nop
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ddf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801de2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	6a 00                	push   $0x0
  801ded:	53                   	push   %ebx
  801dee:	51                   	push   %ecx
  801def:	52                   	push   %edx
  801df0:	50                   	push   %eax
  801df1:	6a 2e                	push   $0x2e
  801df3:	e8 c7 f9 ff ff       	call   8017bf <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
}
  801dfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	52                   	push   %edx
  801e10:	50                   	push   %eax
  801e11:	6a 2f                	push   $0x2f
  801e13:	e8 a7 f9 ff ff       	call   8017bf <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e23:	83 ec 0c             	sub    $0xc,%esp
  801e26:	68 9c 39 80 00       	push   $0x80399c
  801e2b:	e8 df e6 ff ff       	call   80050f <cprintf>
  801e30:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e3a:	83 ec 0c             	sub    $0xc,%esp
  801e3d:	68 c8 39 80 00       	push   $0x8039c8
  801e42:	e8 c8 e6 ff ff       	call   80050f <cprintf>
  801e47:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e4a:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e4e:	a1 38 41 80 00       	mov    0x804138,%eax
  801e53:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e56:	eb 56                	jmp    801eae <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e5c:	74 1c                	je     801e7a <print_mem_block_lists+0x5d>
  801e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e61:	8b 50 08             	mov    0x8(%eax),%edx
  801e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e67:	8b 48 08             	mov    0x8(%eax),%ecx
  801e6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e70:	01 c8                	add    %ecx,%eax
  801e72:	39 c2                	cmp    %eax,%edx
  801e74:	73 04                	jae    801e7a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e76:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7d:	8b 50 08             	mov    0x8(%eax),%edx
  801e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e83:	8b 40 0c             	mov    0xc(%eax),%eax
  801e86:	01 c2                	add    %eax,%edx
  801e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8b:	8b 40 08             	mov    0x8(%eax),%eax
  801e8e:	83 ec 04             	sub    $0x4,%esp
  801e91:	52                   	push   %edx
  801e92:	50                   	push   %eax
  801e93:	68 dd 39 80 00       	push   $0x8039dd
  801e98:	e8 72 e6 ff ff       	call   80050f <cprintf>
  801e9d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ea6:	a1 40 41 80 00       	mov    0x804140,%eax
  801eab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801eae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801eb2:	74 07                	je     801ebb <print_mem_block_lists+0x9e>
  801eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb7:	8b 00                	mov    (%eax),%eax
  801eb9:	eb 05                	jmp    801ec0 <print_mem_block_lists+0xa3>
  801ebb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ec0:	a3 40 41 80 00       	mov    %eax,0x804140
  801ec5:	a1 40 41 80 00       	mov    0x804140,%eax
  801eca:	85 c0                	test   %eax,%eax
  801ecc:	75 8a                	jne    801e58 <print_mem_block_lists+0x3b>
  801ece:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ed2:	75 84                	jne    801e58 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ed4:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ed8:	75 10                	jne    801eea <print_mem_block_lists+0xcd>
  801eda:	83 ec 0c             	sub    $0xc,%esp
  801edd:	68 ec 39 80 00       	push   $0x8039ec
  801ee2:	e8 28 e6 ff ff       	call   80050f <cprintf>
  801ee7:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801eea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	68 10 3a 80 00       	push   $0x803a10
  801ef9:	e8 11 e6 ff ff       	call   80050f <cprintf>
  801efe:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f01:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f05:	a1 40 40 80 00       	mov    0x804040,%eax
  801f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0d:	eb 56                	jmp    801f65 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f13:	74 1c                	je     801f31 <print_mem_block_lists+0x114>
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 50 08             	mov    0x8(%eax),%edx
  801f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f24:	8b 40 0c             	mov    0xc(%eax),%eax
  801f27:	01 c8                	add    %ecx,%eax
  801f29:	39 c2                	cmp    %eax,%edx
  801f2b:	73 04                	jae    801f31 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f2d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f34:	8b 50 08             	mov    0x8(%eax),%edx
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3d:	01 c2                	add    %eax,%edx
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	8b 40 08             	mov    0x8(%eax),%eax
  801f45:	83 ec 04             	sub    $0x4,%esp
  801f48:	52                   	push   %edx
  801f49:	50                   	push   %eax
  801f4a:	68 dd 39 80 00       	push   $0x8039dd
  801f4f:	e8 bb e5 ff ff       	call   80050f <cprintf>
  801f54:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f5d:	a1 48 40 80 00       	mov    0x804048,%eax
  801f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f69:	74 07                	je     801f72 <print_mem_block_lists+0x155>
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 00                	mov    (%eax),%eax
  801f70:	eb 05                	jmp    801f77 <print_mem_block_lists+0x15a>
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
  801f77:	a3 48 40 80 00       	mov    %eax,0x804048
  801f7c:	a1 48 40 80 00       	mov    0x804048,%eax
  801f81:	85 c0                	test   %eax,%eax
  801f83:	75 8a                	jne    801f0f <print_mem_block_lists+0xf2>
  801f85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f89:	75 84                	jne    801f0f <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f8b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f8f:	75 10                	jne    801fa1 <print_mem_block_lists+0x184>
  801f91:	83 ec 0c             	sub    $0xc,%esp
  801f94:	68 28 3a 80 00       	push   $0x803a28
  801f99:	e8 71 e5 ff ff       	call   80050f <cprintf>
  801f9e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fa1:	83 ec 0c             	sub    $0xc,%esp
  801fa4:	68 9c 39 80 00       	push   $0x80399c
  801fa9:	e8 61 e5 ff ff       	call   80050f <cprintf>
  801fae:	83 c4 10             	add    $0x10,%esp

}
  801fb1:	90                   	nop
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    

00801fb4 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fb4:	55                   	push   %ebp
  801fb5:	89 e5                	mov    %esp,%ebp
  801fb7:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fba:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fc1:	00 00 00 
  801fc4:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fcb:	00 00 00 
  801fce:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fd5:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  801fd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fdf:	e9 9e 00 00 00       	jmp    802082 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801fe4:	a1 50 40 80 00       	mov    0x804050,%eax
  801fe9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fec:	c1 e2 04             	shl    $0x4,%edx
  801fef:	01 d0                	add    %edx,%eax
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	75 14                	jne    802009 <initialize_MemBlocksList+0x55>
  801ff5:	83 ec 04             	sub    $0x4,%esp
  801ff8:	68 50 3a 80 00       	push   $0x803a50
  801ffd:	6a 42                	push   $0x42
  801fff:	68 73 3a 80 00       	push   $0x803a73
  802004:	e8 52 e2 ff ff       	call   80025b <_panic>
  802009:	a1 50 40 80 00       	mov    0x804050,%eax
  80200e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802011:	c1 e2 04             	shl    $0x4,%edx
  802014:	01 d0                	add    %edx,%eax
  802016:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80201c:	89 10                	mov    %edx,(%eax)
  80201e:	8b 00                	mov    (%eax),%eax
  802020:	85 c0                	test   %eax,%eax
  802022:	74 18                	je     80203c <initialize_MemBlocksList+0x88>
  802024:	a1 48 41 80 00       	mov    0x804148,%eax
  802029:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80202f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802032:	c1 e1 04             	shl    $0x4,%ecx
  802035:	01 ca                	add    %ecx,%edx
  802037:	89 50 04             	mov    %edx,0x4(%eax)
  80203a:	eb 12                	jmp    80204e <initialize_MemBlocksList+0x9a>
  80203c:	a1 50 40 80 00       	mov    0x804050,%eax
  802041:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802044:	c1 e2 04             	shl    $0x4,%edx
  802047:	01 d0                	add    %edx,%eax
  802049:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80204e:	a1 50 40 80 00       	mov    0x804050,%eax
  802053:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802056:	c1 e2 04             	shl    $0x4,%edx
  802059:	01 d0                	add    %edx,%eax
  80205b:	a3 48 41 80 00       	mov    %eax,0x804148
  802060:	a1 50 40 80 00       	mov    0x804050,%eax
  802065:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802068:	c1 e2 04             	shl    $0x4,%edx
  80206b:	01 d0                	add    %edx,%eax
  80206d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802074:	a1 54 41 80 00       	mov    0x804154,%eax
  802079:	40                   	inc    %eax
  80207a:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  80207f:	ff 45 f4             	incl   -0xc(%ebp)
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	3b 45 08             	cmp    0x8(%ebp),%eax
  802088:	0f 82 56 ff ff ff    	jb     801fe4 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  80208e:	90                   	nop
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	8b 00                	mov    (%eax),%eax
  80209c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  80209f:	eb 19                	jmp    8020ba <find_block+0x29>
	{
		if(blk->sva==va)
  8020a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a4:	8b 40 08             	mov    0x8(%eax),%eax
  8020a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020aa:	75 05                	jne    8020b1 <find_block+0x20>
			return (blk);
  8020ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020af:	eb 36                	jmp    8020e7 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	8b 40 08             	mov    0x8(%eax),%eax
  8020b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020ba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020be:	74 07                	je     8020c7 <find_block+0x36>
  8020c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c3:	8b 00                	mov    (%eax),%eax
  8020c5:	eb 05                	jmp    8020cc <find_block+0x3b>
  8020c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8020cf:	89 42 08             	mov    %eax,0x8(%edx)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	8b 40 08             	mov    0x8(%eax),%eax
  8020d8:	85 c0                	test   %eax,%eax
  8020da:	75 c5                	jne    8020a1 <find_block+0x10>
  8020dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020e0:	75 bf                	jne    8020a1 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8020e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8020ef:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8020f7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8020fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802101:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802104:	75 65                	jne    80216b <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802106:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80210a:	75 14                	jne    802120 <insert_sorted_allocList+0x37>
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	68 50 3a 80 00       	push   $0x803a50
  802114:	6a 5c                	push   $0x5c
  802116:	68 73 3a 80 00       	push   $0x803a73
  80211b:	e8 3b e1 ff ff       	call   80025b <_panic>
  802120:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	89 10                	mov    %edx,(%eax)
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	8b 00                	mov    (%eax),%eax
  802130:	85 c0                	test   %eax,%eax
  802132:	74 0d                	je     802141 <insert_sorted_allocList+0x58>
  802134:	a1 40 40 80 00       	mov    0x804040,%eax
  802139:	8b 55 08             	mov    0x8(%ebp),%edx
  80213c:	89 50 04             	mov    %edx,0x4(%eax)
  80213f:	eb 08                	jmp    802149 <insert_sorted_allocList+0x60>
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	a3 44 40 80 00       	mov    %eax,0x804044
  802149:	8b 45 08             	mov    0x8(%ebp),%eax
  80214c:	a3 40 40 80 00       	mov    %eax,0x804040
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80215b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802160:	40                   	inc    %eax
  802161:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802166:	e9 7b 01 00 00       	jmp    8022e6 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  80216b:	a1 44 40 80 00       	mov    0x804044,%eax
  802170:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802173:	a1 40 40 80 00       	mov    0x804040,%eax
  802178:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  80217b:	8b 45 08             	mov    0x8(%ebp),%eax
  80217e:	8b 50 08             	mov    0x8(%eax),%edx
  802181:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802184:	8b 40 08             	mov    0x8(%eax),%eax
  802187:	39 c2                	cmp    %eax,%edx
  802189:	76 65                	jbe    8021f0 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  80218b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80218f:	75 14                	jne    8021a5 <insert_sorted_allocList+0xbc>
  802191:	83 ec 04             	sub    $0x4,%esp
  802194:	68 8c 3a 80 00       	push   $0x803a8c
  802199:	6a 64                	push   $0x64
  80219b:	68 73 3a 80 00       	push   $0x803a73
  8021a0:	e8 b6 e0 ff ff       	call   80025b <_panic>
  8021a5:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	89 50 04             	mov    %edx,0x4(%eax)
  8021b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b4:	8b 40 04             	mov    0x4(%eax),%eax
  8021b7:	85 c0                	test   %eax,%eax
  8021b9:	74 0c                	je     8021c7 <insert_sorted_allocList+0xde>
  8021bb:	a1 44 40 80 00       	mov    0x804044,%eax
  8021c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021c3:	89 10                	mov    %edx,(%eax)
  8021c5:	eb 08                	jmp    8021cf <insert_sorted_allocList+0xe6>
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	a3 40 40 80 00       	mov    %eax,0x804040
  8021cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d2:	a3 44 40 80 00       	mov    %eax,0x804044
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021e0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021e5:	40                   	inc    %eax
  8021e6:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8021eb:	e9 f6 00 00 00       	jmp    8022e6 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8b 50 08             	mov    0x8(%eax),%edx
  8021f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f9:	8b 40 08             	mov    0x8(%eax),%eax
  8021fc:	39 c2                	cmp    %eax,%edx
  8021fe:	73 65                	jae    802265 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802200:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802204:	75 14                	jne    80221a <insert_sorted_allocList+0x131>
  802206:	83 ec 04             	sub    $0x4,%esp
  802209:	68 50 3a 80 00       	push   $0x803a50
  80220e:	6a 68                	push   $0x68
  802210:	68 73 3a 80 00       	push   $0x803a73
  802215:	e8 41 e0 ff ff       	call   80025b <_panic>
  80221a:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	89 10                	mov    %edx,(%eax)
  802225:	8b 45 08             	mov    0x8(%ebp),%eax
  802228:	8b 00                	mov    (%eax),%eax
  80222a:	85 c0                	test   %eax,%eax
  80222c:	74 0d                	je     80223b <insert_sorted_allocList+0x152>
  80222e:	a1 40 40 80 00       	mov    0x804040,%eax
  802233:	8b 55 08             	mov    0x8(%ebp),%edx
  802236:	89 50 04             	mov    %edx,0x4(%eax)
  802239:	eb 08                	jmp    802243 <insert_sorted_allocList+0x15a>
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	a3 44 40 80 00       	mov    %eax,0x804044
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	a3 40 40 80 00       	mov    %eax,0x804040
  80224b:	8b 45 08             	mov    0x8(%ebp),%eax
  80224e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802255:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80225a:	40                   	inc    %eax
  80225b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802260:	e9 81 00 00 00       	jmp    8022e6 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802265:	a1 40 40 80 00       	mov    0x804040,%eax
  80226a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80226d:	eb 51                	jmp    8022c0 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  80226f:	8b 45 08             	mov    0x8(%ebp),%eax
  802272:	8b 50 08             	mov    0x8(%eax),%edx
  802275:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802278:	8b 40 08             	mov    0x8(%eax),%eax
  80227b:	39 c2                	cmp    %eax,%edx
  80227d:	73 39                	jae    8022b8 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	8b 40 04             	mov    0x4(%eax),%eax
  802285:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802288:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80228b:	8b 55 08             	mov    0x8(%ebp),%edx
  80228e:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802296:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229f:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8022a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a7:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8022aa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022af:	40                   	inc    %eax
  8022b0:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8022b5:	90                   	nop
				}
			}
		 }

	}
}
  8022b6:	eb 2e                	jmp    8022e6 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022b8:	a1 48 40 80 00       	mov    0x804048,%eax
  8022bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022c4:	74 07                	je     8022cd <insert_sorted_allocList+0x1e4>
  8022c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c9:	8b 00                	mov    (%eax),%eax
  8022cb:	eb 05                	jmp    8022d2 <insert_sorted_allocList+0x1e9>
  8022cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d2:	a3 48 40 80 00       	mov    %eax,0x804048
  8022d7:	a1 48 40 80 00       	mov    0x804048,%eax
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	75 8f                	jne    80226f <insert_sorted_allocList+0x186>
  8022e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022e4:	75 89                	jne    80226f <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8022e6:	90                   	nop
  8022e7:	c9                   	leave  
  8022e8:	c3                   	ret    

008022e9 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8022ef:	a1 38 41 80 00       	mov    0x804138,%eax
  8022f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022f7:	e9 76 01 00 00       	jmp    802472 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8022fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802302:	3b 45 08             	cmp    0x8(%ebp),%eax
  802305:	0f 85 8a 00 00 00    	jne    802395 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80230b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230f:	75 17                	jne    802328 <alloc_block_FF+0x3f>
  802311:	83 ec 04             	sub    $0x4,%esp
  802314:	68 af 3a 80 00       	push   $0x803aaf
  802319:	68 8a 00 00 00       	push   $0x8a
  80231e:	68 73 3a 80 00       	push   $0x803a73
  802323:	e8 33 df ff ff       	call   80025b <_panic>
  802328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232b:	8b 00                	mov    (%eax),%eax
  80232d:	85 c0                	test   %eax,%eax
  80232f:	74 10                	je     802341 <alloc_block_FF+0x58>
  802331:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802334:	8b 00                	mov    (%eax),%eax
  802336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802339:	8b 52 04             	mov    0x4(%edx),%edx
  80233c:	89 50 04             	mov    %edx,0x4(%eax)
  80233f:	eb 0b                	jmp    80234c <alloc_block_FF+0x63>
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 40 04             	mov    0x4(%eax),%eax
  802347:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 40 04             	mov    0x4(%eax),%eax
  802352:	85 c0                	test   %eax,%eax
  802354:	74 0f                	je     802365 <alloc_block_FF+0x7c>
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	8b 40 04             	mov    0x4(%eax),%eax
  80235c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80235f:	8b 12                	mov    (%edx),%edx
  802361:	89 10                	mov    %edx,(%eax)
  802363:	eb 0a                	jmp    80236f <alloc_block_FF+0x86>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 00                	mov    (%eax),%eax
  80236a:	a3 38 41 80 00       	mov    %eax,0x804138
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802382:	a1 44 41 80 00       	mov    0x804144,%eax
  802387:	48                   	dec    %eax
  802388:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	e9 10 01 00 00       	jmp    8024a5 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 40 0c             	mov    0xc(%eax),%eax
  80239b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80239e:	0f 86 c6 00 00 00    	jbe    80246a <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8023a4:	a1 48 41 80 00       	mov    0x804148,%eax
  8023a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8023ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023b0:	75 17                	jne    8023c9 <alloc_block_FF+0xe0>
  8023b2:	83 ec 04             	sub    $0x4,%esp
  8023b5:	68 af 3a 80 00       	push   $0x803aaf
  8023ba:	68 90 00 00 00       	push   $0x90
  8023bf:	68 73 3a 80 00       	push   $0x803a73
  8023c4:	e8 92 de ff ff       	call   80025b <_panic>
  8023c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	74 10                	je     8023e2 <alloc_block_FF+0xf9>
  8023d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d5:	8b 00                	mov    (%eax),%eax
  8023d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023da:	8b 52 04             	mov    0x4(%edx),%edx
  8023dd:	89 50 04             	mov    %edx,0x4(%eax)
  8023e0:	eb 0b                	jmp    8023ed <alloc_block_FF+0x104>
  8023e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e5:	8b 40 04             	mov    0x4(%eax),%eax
  8023e8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f0:	8b 40 04             	mov    0x4(%eax),%eax
  8023f3:	85 c0                	test   %eax,%eax
  8023f5:	74 0f                	je     802406 <alloc_block_FF+0x11d>
  8023f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fa:	8b 40 04             	mov    0x4(%eax),%eax
  8023fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802400:	8b 12                	mov    (%edx),%edx
  802402:	89 10                	mov    %edx,(%eax)
  802404:	eb 0a                	jmp    802410 <alloc_block_FF+0x127>
  802406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802409:	8b 00                	mov    (%eax),%eax
  80240b:	a3 48 41 80 00       	mov    %eax,0x804148
  802410:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802413:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802423:	a1 54 41 80 00       	mov    0x804154,%eax
  802428:	48                   	dec    %eax
  802429:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  80242e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802431:	8b 55 08             	mov    0x8(%ebp),%edx
  802434:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243a:	8b 50 08             	mov    0x8(%eax),%edx
  80243d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802440:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802446:	8b 50 08             	mov    0x8(%eax),%edx
  802449:	8b 45 08             	mov    0x8(%ebp),%eax
  80244c:	01 c2                	add    %eax,%edx
  80244e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802451:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 0c             	mov    0xc(%eax),%eax
  80245a:	2b 45 08             	sub    0x8(%ebp),%eax
  80245d:	89 c2                	mov    %eax,%edx
  80245f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802462:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  802465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802468:	eb 3b                	jmp    8024a5 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80246a:	a1 40 41 80 00       	mov    0x804140,%eax
  80246f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802472:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802476:	74 07                	je     80247f <alloc_block_FF+0x196>
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	eb 05                	jmp    802484 <alloc_block_FF+0x19b>
  80247f:	b8 00 00 00 00       	mov    $0x0,%eax
  802484:	a3 40 41 80 00       	mov    %eax,0x804140
  802489:	a1 40 41 80 00       	mov    0x804140,%eax
  80248e:	85 c0                	test   %eax,%eax
  802490:	0f 85 66 fe ff ff    	jne    8022fc <alloc_block_FF+0x13>
  802496:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80249a:	0f 85 5c fe ff ff    	jne    8022fc <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8024a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024a5:	c9                   	leave  
  8024a6:	c3                   	ret    

008024a7 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024a7:	55                   	push   %ebp
  8024a8:	89 e5                	mov    %esp,%ebp
  8024aa:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8024ad:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8024b4:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8024bb:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8024c2:	a1 38 41 80 00       	mov    0x804138,%eax
  8024c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ca:	e9 cf 00 00 00       	jmp    80259e <alloc_block_BF+0xf7>
		{
			c++;
  8024cf:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8024d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024db:	0f 85 8a 00 00 00    	jne    80256b <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8024e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e5:	75 17                	jne    8024fe <alloc_block_BF+0x57>
  8024e7:	83 ec 04             	sub    $0x4,%esp
  8024ea:	68 af 3a 80 00       	push   $0x803aaf
  8024ef:	68 a8 00 00 00       	push   $0xa8
  8024f4:	68 73 3a 80 00       	push   $0x803a73
  8024f9:	e8 5d dd ff ff       	call   80025b <_panic>
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	85 c0                	test   %eax,%eax
  802505:	74 10                	je     802517 <alloc_block_BF+0x70>
  802507:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250a:	8b 00                	mov    (%eax),%eax
  80250c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250f:	8b 52 04             	mov    0x4(%edx),%edx
  802512:	89 50 04             	mov    %edx,0x4(%eax)
  802515:	eb 0b                	jmp    802522 <alloc_block_BF+0x7b>
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	8b 40 04             	mov    0x4(%eax),%eax
  80251d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 40 04             	mov    0x4(%eax),%eax
  802528:	85 c0                	test   %eax,%eax
  80252a:	74 0f                	je     80253b <alloc_block_BF+0x94>
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	8b 40 04             	mov    0x4(%eax),%eax
  802532:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802535:	8b 12                	mov    (%edx),%edx
  802537:	89 10                	mov    %edx,(%eax)
  802539:	eb 0a                	jmp    802545 <alloc_block_BF+0x9e>
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	8b 00                	mov    (%eax),%eax
  802540:	a3 38 41 80 00       	mov    %eax,0x804138
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802558:	a1 44 41 80 00       	mov    0x804144,%eax
  80255d:	48                   	dec    %eax
  80255e:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	e9 85 01 00 00       	jmp    8026f0 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 0c             	mov    0xc(%eax),%eax
  802571:	3b 45 08             	cmp    0x8(%ebp),%eax
  802574:	76 20                	jbe    802596 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802579:	8b 40 0c             	mov    0xc(%eax),%eax
  80257c:	2b 45 08             	sub    0x8(%ebp),%eax
  80257f:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802582:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802585:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802588:	73 0c                	jae    802596 <alloc_block_BF+0xef>
				{
					ma=tempi;
  80258a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80258d:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  802590:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802593:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802596:	a1 40 41 80 00       	mov    0x804140,%eax
  80259b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025a2:	74 07                	je     8025ab <alloc_block_BF+0x104>
  8025a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a7:	8b 00                	mov    (%eax),%eax
  8025a9:	eb 05                	jmp    8025b0 <alloc_block_BF+0x109>
  8025ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b0:	a3 40 41 80 00       	mov    %eax,0x804140
  8025b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ba:	85 c0                	test   %eax,%eax
  8025bc:	0f 85 0d ff ff ff    	jne    8024cf <alloc_block_BF+0x28>
  8025c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c6:	0f 85 03 ff ff ff    	jne    8024cf <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8025cc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025d3:	a1 38 41 80 00       	mov    0x804138,%eax
  8025d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025db:	e9 dd 00 00 00       	jmp    8026bd <alloc_block_BF+0x216>
		{
			if(x==sol)
  8025e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025e3:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025e6:	0f 85 c6 00 00 00    	jne    8026b2 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8025ec:	a1 48 41 80 00       	mov    0x804148,%eax
  8025f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8025f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8025f8:	75 17                	jne    802611 <alloc_block_BF+0x16a>
  8025fa:	83 ec 04             	sub    $0x4,%esp
  8025fd:	68 af 3a 80 00       	push   $0x803aaf
  802602:	68 bb 00 00 00       	push   $0xbb
  802607:	68 73 3a 80 00       	push   $0x803a73
  80260c:	e8 4a dc ff ff       	call   80025b <_panic>
  802611:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802614:	8b 00                	mov    (%eax),%eax
  802616:	85 c0                	test   %eax,%eax
  802618:	74 10                	je     80262a <alloc_block_BF+0x183>
  80261a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80261d:	8b 00                	mov    (%eax),%eax
  80261f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802622:	8b 52 04             	mov    0x4(%edx),%edx
  802625:	89 50 04             	mov    %edx,0x4(%eax)
  802628:	eb 0b                	jmp    802635 <alloc_block_BF+0x18e>
  80262a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262d:	8b 40 04             	mov    0x4(%eax),%eax
  802630:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802635:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802638:	8b 40 04             	mov    0x4(%eax),%eax
  80263b:	85 c0                	test   %eax,%eax
  80263d:	74 0f                	je     80264e <alloc_block_BF+0x1a7>
  80263f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802642:	8b 40 04             	mov    0x4(%eax),%eax
  802645:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802648:	8b 12                	mov    (%edx),%edx
  80264a:	89 10                	mov    %edx,(%eax)
  80264c:	eb 0a                	jmp    802658 <alloc_block_BF+0x1b1>
  80264e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	a3 48 41 80 00       	mov    %eax,0x804148
  802658:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80265b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802661:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802664:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266b:	a1 54 41 80 00       	mov    0x804154,%eax
  802670:	48                   	dec    %eax
  802671:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802676:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802679:	8b 55 08             	mov    0x8(%ebp),%edx
  80267c:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	8b 50 08             	mov    0x8(%eax),%edx
  802685:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802688:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  80268b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268e:	8b 50 08             	mov    0x8(%eax),%edx
  802691:	8b 45 08             	mov    0x8(%ebp),%eax
  802694:	01 c2                	add    %eax,%edx
  802696:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802699:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a2:	2b 45 08             	sub    0x8(%ebp),%eax
  8026a5:	89 c2                	mov    %eax,%edx
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8026ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b0:	eb 3e                	jmp    8026f0 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8026b2:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026c1:	74 07                	je     8026ca <alloc_block_BF+0x223>
  8026c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c6:	8b 00                	mov    (%eax),%eax
  8026c8:	eb 05                	jmp    8026cf <alloc_block_BF+0x228>
  8026ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8026cf:	a3 40 41 80 00       	mov    %eax,0x804140
  8026d4:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d9:	85 c0                	test   %eax,%eax
  8026db:	0f 85 ff fe ff ff    	jne    8025e0 <alloc_block_BF+0x139>
  8026e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e5:	0f 85 f5 fe ff ff    	jne    8025e0 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8026eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f0:	c9                   	leave  
  8026f1:	c3                   	ret    

008026f2 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  8026f8:	a1 28 40 80 00       	mov    0x804028,%eax
  8026fd:	85 c0                	test   %eax,%eax
  8026ff:	75 14                	jne    802715 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802701:	a1 38 41 80 00       	mov    0x804138,%eax
  802706:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  80270b:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802712:	00 00 00 
	}
	uint32 c=1;
  802715:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80271c:	a1 60 41 80 00       	mov    0x804160,%eax
  802721:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802724:	e9 b3 01 00 00       	jmp    8028dc <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802729:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272c:	8b 40 0c             	mov    0xc(%eax),%eax
  80272f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802732:	0f 85 a9 00 00 00    	jne    8027e1 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	8b 00                	mov    (%eax),%eax
  80273d:	85 c0                	test   %eax,%eax
  80273f:	75 0c                	jne    80274d <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802741:	a1 38 41 80 00       	mov    0x804138,%eax
  802746:	a3 60 41 80 00       	mov    %eax,0x804160
  80274b:	eb 0a                	jmp    802757 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802750:	8b 00                	mov    (%eax),%eax
  802752:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802757:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80275b:	75 17                	jne    802774 <alloc_block_NF+0x82>
  80275d:	83 ec 04             	sub    $0x4,%esp
  802760:	68 af 3a 80 00       	push   $0x803aaf
  802765:	68 e3 00 00 00       	push   $0xe3
  80276a:	68 73 3a 80 00       	push   $0x803a73
  80276f:	e8 e7 da ff ff       	call   80025b <_panic>
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	8b 00                	mov    (%eax),%eax
  802779:	85 c0                	test   %eax,%eax
  80277b:	74 10                	je     80278d <alloc_block_NF+0x9b>
  80277d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802785:	8b 52 04             	mov    0x4(%edx),%edx
  802788:	89 50 04             	mov    %edx,0x4(%eax)
  80278b:	eb 0b                	jmp    802798 <alloc_block_NF+0xa6>
  80278d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802790:	8b 40 04             	mov    0x4(%eax),%eax
  802793:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802798:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80279b:	8b 40 04             	mov    0x4(%eax),%eax
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	74 0f                	je     8027b1 <alloc_block_NF+0xbf>
  8027a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a5:	8b 40 04             	mov    0x4(%eax),%eax
  8027a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ab:	8b 12                	mov    (%edx),%edx
  8027ad:	89 10                	mov    %edx,(%eax)
  8027af:	eb 0a                	jmp    8027bb <alloc_block_NF+0xc9>
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	8b 00                	mov    (%eax),%eax
  8027b6:	a3 38 41 80 00       	mov    %eax,0x804138
  8027bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027be:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ce:	a1 44 41 80 00       	mov    0x804144,%eax
  8027d3:	48                   	dec    %eax
  8027d4:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  8027d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dc:	e9 0e 01 00 00       	jmp    8028ef <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8027e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ea:	0f 86 ce 00 00 00    	jbe    8028be <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8027f0:	a1 48 41 80 00       	mov    0x804148,%eax
  8027f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8027f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027fc:	75 17                	jne    802815 <alloc_block_NF+0x123>
  8027fe:	83 ec 04             	sub    $0x4,%esp
  802801:	68 af 3a 80 00       	push   $0x803aaf
  802806:	68 e9 00 00 00       	push   $0xe9
  80280b:	68 73 3a 80 00       	push   $0x803a73
  802810:	e8 46 da ff ff       	call   80025b <_panic>
  802815:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802818:	8b 00                	mov    (%eax),%eax
  80281a:	85 c0                	test   %eax,%eax
  80281c:	74 10                	je     80282e <alloc_block_NF+0x13c>
  80281e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802821:	8b 00                	mov    (%eax),%eax
  802823:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802826:	8b 52 04             	mov    0x4(%edx),%edx
  802829:	89 50 04             	mov    %edx,0x4(%eax)
  80282c:	eb 0b                	jmp    802839 <alloc_block_NF+0x147>
  80282e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802831:	8b 40 04             	mov    0x4(%eax),%eax
  802834:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802839:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283c:	8b 40 04             	mov    0x4(%eax),%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	74 0f                	je     802852 <alloc_block_NF+0x160>
  802843:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802846:	8b 40 04             	mov    0x4(%eax),%eax
  802849:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80284c:	8b 12                	mov    (%edx),%edx
  80284e:	89 10                	mov    %edx,(%eax)
  802850:	eb 0a                	jmp    80285c <alloc_block_NF+0x16a>
  802852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802855:	8b 00                	mov    (%eax),%eax
  802857:	a3 48 41 80 00       	mov    %eax,0x804148
  80285c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802865:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802868:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286f:	a1 54 41 80 00       	mov    0x804154,%eax
  802874:	48                   	dec    %eax
  802875:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  80287a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287d:	8b 55 08             	mov    0x8(%ebp),%edx
  802880:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802883:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802886:	8b 50 08             	mov    0x8(%eax),%edx
  802889:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288c:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	8b 50 08             	mov    0x8(%eax),%edx
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	01 c2                	add    %eax,%edx
  80289a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289d:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8028a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8028a9:	89 c2                	mov    %eax,%edx
  8028ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ae:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8028b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b4:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8028b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bc:	eb 31                	jmp    8028ef <alloc_block_NF+0x1fd>
			 }
		 c++;
  8028be:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	75 0a                	jne    8028d4 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8028ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8028cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028d2:	eb 08                	jmp    8028dc <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8028d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d7:	8b 00                	mov    (%eax),%eax
  8028d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8028dc:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8028e4:	0f 85 3f fe ff ff    	jne    802729 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8028ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ef:	c9                   	leave  
  8028f0:	c3                   	ret    

008028f1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028f1:	55                   	push   %ebp
  8028f2:	89 e5                	mov    %esp,%ebp
  8028f4:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  8028f7:	a1 44 41 80 00       	mov    0x804144,%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	75 68                	jne    802968 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802900:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802904:	75 17                	jne    80291d <insert_sorted_with_merge_freeList+0x2c>
  802906:	83 ec 04             	sub    $0x4,%esp
  802909:	68 50 3a 80 00       	push   $0x803a50
  80290e:	68 0e 01 00 00       	push   $0x10e
  802913:	68 73 3a 80 00       	push   $0x803a73
  802918:	e8 3e d9 ff ff       	call   80025b <_panic>
  80291d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	89 10                	mov    %edx,(%eax)
  802928:	8b 45 08             	mov    0x8(%ebp),%eax
  80292b:	8b 00                	mov    (%eax),%eax
  80292d:	85 c0                	test   %eax,%eax
  80292f:	74 0d                	je     80293e <insert_sorted_with_merge_freeList+0x4d>
  802931:	a1 38 41 80 00       	mov    0x804138,%eax
  802936:	8b 55 08             	mov    0x8(%ebp),%edx
  802939:	89 50 04             	mov    %edx,0x4(%eax)
  80293c:	eb 08                	jmp    802946 <insert_sorted_with_merge_freeList+0x55>
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	a3 38 41 80 00       	mov    %eax,0x804138
  80294e:	8b 45 08             	mov    0x8(%ebp),%eax
  802951:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802958:	a1 44 41 80 00       	mov    0x804144,%eax
  80295d:	40                   	inc    %eax
  80295e:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802963:	e9 8c 06 00 00       	jmp    802ff4 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802968:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80296d:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802970:	a1 38 41 80 00       	mov    0x804138,%eax
  802975:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	8b 50 08             	mov    0x8(%eax),%edx
  80297e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802981:	8b 40 08             	mov    0x8(%eax),%eax
  802984:	39 c2                	cmp    %eax,%edx
  802986:	0f 86 14 01 00 00    	jbe    802aa0 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  80298c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298f:	8b 50 0c             	mov    0xc(%eax),%edx
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	8b 40 08             	mov    0x8(%eax),%eax
  802998:	01 c2                	add    %eax,%edx
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	8b 40 08             	mov    0x8(%eax),%eax
  8029a0:	39 c2                	cmp    %eax,%edx
  8029a2:	0f 85 90 00 00 00    	jne    802a38 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8029a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8029ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8029b4:	01 c2                	add    %eax,%edx
  8029b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b9:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029d4:	75 17                	jne    8029ed <insert_sorted_with_merge_freeList+0xfc>
  8029d6:	83 ec 04             	sub    $0x4,%esp
  8029d9:	68 50 3a 80 00       	push   $0x803a50
  8029de:	68 1b 01 00 00       	push   $0x11b
  8029e3:	68 73 3a 80 00       	push   $0x803a73
  8029e8:	e8 6e d8 ff ff       	call   80025b <_panic>
  8029ed:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	89 10                	mov    %edx,(%eax)
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	8b 00                	mov    (%eax),%eax
  8029fd:	85 c0                	test   %eax,%eax
  8029ff:	74 0d                	je     802a0e <insert_sorted_with_merge_freeList+0x11d>
  802a01:	a1 48 41 80 00       	mov    0x804148,%eax
  802a06:	8b 55 08             	mov    0x8(%ebp),%edx
  802a09:	89 50 04             	mov    %edx,0x4(%eax)
  802a0c:	eb 08                	jmp    802a16 <insert_sorted_with_merge_freeList+0x125>
  802a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a11:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	a3 48 41 80 00       	mov    %eax,0x804148
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a28:	a1 54 41 80 00       	mov    0x804154,%eax
  802a2d:	40                   	inc    %eax
  802a2e:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802a33:	e9 bc 05 00 00       	jmp    802ff4 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3c:	75 17                	jne    802a55 <insert_sorted_with_merge_freeList+0x164>
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	68 8c 3a 80 00       	push   $0x803a8c
  802a46:	68 1f 01 00 00       	push   $0x11f
  802a4b:	68 73 3a 80 00       	push   $0x803a73
  802a50:	e8 06 d8 ff ff       	call   80025b <_panic>
  802a55:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	89 50 04             	mov    %edx,0x4(%eax)
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	8b 40 04             	mov    0x4(%eax),%eax
  802a67:	85 c0                	test   %eax,%eax
  802a69:	74 0c                	je     802a77 <insert_sorted_with_merge_freeList+0x186>
  802a6b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a70:	8b 55 08             	mov    0x8(%ebp),%edx
  802a73:	89 10                	mov    %edx,(%eax)
  802a75:	eb 08                	jmp    802a7f <insert_sorted_with_merge_freeList+0x18e>
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	a3 38 41 80 00       	mov    %eax,0x804138
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a90:	a1 44 41 80 00       	mov    0x804144,%eax
  802a95:	40                   	inc    %eax
  802a96:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a9b:	e9 54 05 00 00       	jmp    802ff4 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	8b 50 08             	mov    0x8(%eax),%edx
  802aa6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa9:	8b 40 08             	mov    0x8(%eax),%eax
  802aac:	39 c2                	cmp    %eax,%edx
  802aae:	0f 83 20 01 00 00    	jae    802bd4 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	8b 50 0c             	mov    0xc(%eax),%edx
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	8b 40 08             	mov    0x8(%eax),%eax
  802ac0:	01 c2                	add    %eax,%edx
  802ac2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ac5:	8b 40 08             	mov    0x8(%eax),%eax
  802ac8:	39 c2                	cmp    %eax,%edx
  802aca:	0f 85 9c 00 00 00    	jne    802b6c <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	8b 50 08             	mov    0x8(%eax),%edx
  802ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ad9:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802adc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adf:	8b 50 0c             	mov    0xc(%eax),%edx
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae8:	01 c2                	add    %eax,%edx
  802aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aed:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802afa:	8b 45 08             	mov    0x8(%ebp),%eax
  802afd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b08:	75 17                	jne    802b21 <insert_sorted_with_merge_freeList+0x230>
  802b0a:	83 ec 04             	sub    $0x4,%esp
  802b0d:	68 50 3a 80 00       	push   $0x803a50
  802b12:	68 2a 01 00 00       	push   $0x12a
  802b17:	68 73 3a 80 00       	push   $0x803a73
  802b1c:	e8 3a d7 ff ff       	call   80025b <_panic>
  802b21:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	89 10                	mov    %edx,(%eax)
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	8b 00                	mov    (%eax),%eax
  802b31:	85 c0                	test   %eax,%eax
  802b33:	74 0d                	je     802b42 <insert_sorted_with_merge_freeList+0x251>
  802b35:	a1 48 41 80 00       	mov    0x804148,%eax
  802b3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3d:	89 50 04             	mov    %edx,0x4(%eax)
  802b40:	eb 08                	jmp    802b4a <insert_sorted_with_merge_freeList+0x259>
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	a3 48 41 80 00       	mov    %eax,0x804148
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5c:	a1 54 41 80 00       	mov    0x804154,%eax
  802b61:	40                   	inc    %eax
  802b62:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b67:	e9 88 04 00 00       	jmp    802ff4 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b70:	75 17                	jne    802b89 <insert_sorted_with_merge_freeList+0x298>
  802b72:	83 ec 04             	sub    $0x4,%esp
  802b75:	68 50 3a 80 00       	push   $0x803a50
  802b7a:	68 2e 01 00 00       	push   $0x12e
  802b7f:	68 73 3a 80 00       	push   $0x803a73
  802b84:	e8 d2 d6 ff ff       	call   80025b <_panic>
  802b89:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	89 10                	mov    %edx,(%eax)
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 00                	mov    (%eax),%eax
  802b99:	85 c0                	test   %eax,%eax
  802b9b:	74 0d                	je     802baa <insert_sorted_with_merge_freeList+0x2b9>
  802b9d:	a1 38 41 80 00       	mov    0x804138,%eax
  802ba2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba5:	89 50 04             	mov    %edx,0x4(%eax)
  802ba8:	eb 08                	jmp    802bb2 <insert_sorted_with_merge_freeList+0x2c1>
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	a3 38 41 80 00       	mov    %eax,0x804138
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc4:	a1 44 41 80 00       	mov    0x804144,%eax
  802bc9:	40                   	inc    %eax
  802bca:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bcf:	e9 20 04 00 00       	jmp    802ff4 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802bd4:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bdc:	e9 e2 03 00 00       	jmp    802fc3 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 50 08             	mov    0x8(%eax),%edx
  802be7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bea:	8b 40 08             	mov    0x8(%eax),%eax
  802bed:	39 c2                	cmp    %eax,%edx
  802bef:	0f 83 c6 03 00 00    	jae    802fbb <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf8:	8b 40 04             	mov    0x4(%eax),%eax
  802bfb:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802bfe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c01:	8b 50 08             	mov    0x8(%eax),%edx
  802c04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c07:	8b 40 0c             	mov    0xc(%eax),%eax
  802c0a:	01 d0                	add    %edx,%eax
  802c0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	8b 50 0c             	mov    0xc(%eax),%edx
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	8b 40 08             	mov    0x8(%eax),%eax
  802c1b:	01 d0                	add    %edx,%eax
  802c1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	8b 40 08             	mov    0x8(%eax),%eax
  802c26:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c29:	74 7a                	je     802ca5 <insert_sorted_with_merge_freeList+0x3b4>
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	8b 40 08             	mov    0x8(%eax),%eax
  802c31:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c34:	74 6f                	je     802ca5 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802c36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c3a:	74 06                	je     802c42 <insert_sorted_with_merge_freeList+0x351>
  802c3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c40:	75 17                	jne    802c59 <insert_sorted_with_merge_freeList+0x368>
  802c42:	83 ec 04             	sub    $0x4,%esp
  802c45:	68 d0 3a 80 00       	push   $0x803ad0
  802c4a:	68 43 01 00 00       	push   $0x143
  802c4f:	68 73 3a 80 00       	push   $0x803a73
  802c54:	e8 02 d6 ff ff       	call   80025b <_panic>
  802c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5c:	8b 50 04             	mov    0x4(%eax),%edx
  802c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c62:	89 50 04             	mov    %edx,0x4(%eax)
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c6b:	89 10                	mov    %edx,(%eax)
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0d                	je     802c84 <insert_sorted_with_merge_freeList+0x393>
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 04             	mov    0x4(%eax),%eax
  802c7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c80:	89 10                	mov    %edx,(%eax)
  802c82:	eb 08                	jmp    802c8c <insert_sorted_with_merge_freeList+0x39b>
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	a3 38 41 80 00       	mov    %eax,0x804138
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c92:	89 50 04             	mov    %edx,0x4(%eax)
  802c95:	a1 44 41 80 00       	mov    0x804144,%eax
  802c9a:	40                   	inc    %eax
  802c9b:	a3 44 41 80 00       	mov    %eax,0x804144
  802ca0:	e9 14 03 00 00       	jmp    802fb9 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	8b 40 08             	mov    0x8(%eax),%eax
  802cab:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cae:	0f 85 a0 01 00 00    	jne    802e54 <insert_sorted_with_merge_freeList+0x563>
  802cb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb7:	8b 40 08             	mov    0x8(%eax),%eax
  802cba:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cbd:	0f 85 91 01 00 00    	jne    802e54 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802cc3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc6:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd5:	01 c8                	add    %ecx,%eax
  802cd7:	01 c2                	add    %eax,%edx
  802cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdc:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cf6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802cfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d00:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d07:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d0b:	75 17                	jne    802d24 <insert_sorted_with_merge_freeList+0x433>
  802d0d:	83 ec 04             	sub    $0x4,%esp
  802d10:	68 50 3a 80 00       	push   $0x803a50
  802d15:	68 4d 01 00 00       	push   $0x14d
  802d1a:	68 73 3a 80 00       	push   $0x803a73
  802d1f:	e8 37 d5 ff ff       	call   80025b <_panic>
  802d24:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2d:	89 10                	mov    %edx,(%eax)
  802d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d32:	8b 00                	mov    (%eax),%eax
  802d34:	85 c0                	test   %eax,%eax
  802d36:	74 0d                	je     802d45 <insert_sorted_with_merge_freeList+0x454>
  802d38:	a1 48 41 80 00       	mov    0x804148,%eax
  802d3d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d40:	89 50 04             	mov    %edx,0x4(%eax)
  802d43:	eb 08                	jmp    802d4d <insert_sorted_with_merge_freeList+0x45c>
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d50:	a3 48 41 80 00       	mov    %eax,0x804148
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d5f:	a1 54 41 80 00       	mov    0x804154,%eax
  802d64:	40                   	inc    %eax
  802d65:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6e:	75 17                	jne    802d87 <insert_sorted_with_merge_freeList+0x496>
  802d70:	83 ec 04             	sub    $0x4,%esp
  802d73:	68 af 3a 80 00       	push   $0x803aaf
  802d78:	68 4e 01 00 00       	push   $0x14e
  802d7d:	68 73 3a 80 00       	push   $0x803a73
  802d82:	e8 d4 d4 ff ff       	call   80025b <_panic>
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 00                	mov    (%eax),%eax
  802d8c:	85 c0                	test   %eax,%eax
  802d8e:	74 10                	je     802da0 <insert_sorted_with_merge_freeList+0x4af>
  802d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d93:	8b 00                	mov    (%eax),%eax
  802d95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d98:	8b 52 04             	mov    0x4(%edx),%edx
  802d9b:	89 50 04             	mov    %edx,0x4(%eax)
  802d9e:	eb 0b                	jmp    802dab <insert_sorted_with_merge_freeList+0x4ba>
  802da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da3:	8b 40 04             	mov    0x4(%eax),%eax
  802da6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	8b 40 04             	mov    0x4(%eax),%eax
  802db1:	85 c0                	test   %eax,%eax
  802db3:	74 0f                	je     802dc4 <insert_sorted_with_merge_freeList+0x4d3>
  802db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db8:	8b 40 04             	mov    0x4(%eax),%eax
  802dbb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dbe:	8b 12                	mov    (%edx),%edx
  802dc0:	89 10                	mov    %edx,(%eax)
  802dc2:	eb 0a                	jmp    802dce <insert_sorted_with_merge_freeList+0x4dd>
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	8b 00                	mov    (%eax),%eax
  802dc9:	a3 38 41 80 00       	mov    %eax,0x804138
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de1:	a1 44 41 80 00       	mov    0x804144,%eax
  802de6:	48                   	dec    %eax
  802de7:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802dec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802df0:	75 17                	jne    802e09 <insert_sorted_with_merge_freeList+0x518>
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	68 50 3a 80 00       	push   $0x803a50
  802dfa:	68 4f 01 00 00       	push   $0x14f
  802dff:	68 73 3a 80 00       	push   $0x803a73
  802e04:	e8 52 d4 ff ff       	call   80025b <_panic>
  802e09:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e12:	89 10                	mov    %edx,(%eax)
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 00                	mov    (%eax),%eax
  802e19:	85 c0                	test   %eax,%eax
  802e1b:	74 0d                	je     802e2a <insert_sorted_with_merge_freeList+0x539>
  802e1d:	a1 48 41 80 00       	mov    0x804148,%eax
  802e22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e25:	89 50 04             	mov    %edx,0x4(%eax)
  802e28:	eb 08                	jmp    802e32 <insert_sorted_with_merge_freeList+0x541>
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	a3 48 41 80 00       	mov    %eax,0x804148
  802e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e44:	a1 54 41 80 00       	mov    0x804154,%eax
  802e49:	40                   	inc    %eax
  802e4a:	a3 54 41 80 00       	mov    %eax,0x804154
  802e4f:	e9 65 01 00 00       	jmp    802fb9 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	8b 40 08             	mov    0x8(%eax),%eax
  802e5a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e5d:	0f 85 9f 00 00 00    	jne    802f02 <insert_sorted_with_merge_freeList+0x611>
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 40 08             	mov    0x8(%eax),%eax
  802e69:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e6c:	0f 84 90 00 00 00    	je     802f02 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802e72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e75:	8b 50 0c             	mov    0xc(%eax),%edx
  802e78:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7e:	01 c2                	add    %eax,%edx
  802e80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e83:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802e86:	8b 45 08             	mov    0x8(%ebp),%eax
  802e89:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e9e:	75 17                	jne    802eb7 <insert_sorted_with_merge_freeList+0x5c6>
  802ea0:	83 ec 04             	sub    $0x4,%esp
  802ea3:	68 50 3a 80 00       	push   $0x803a50
  802ea8:	68 58 01 00 00       	push   $0x158
  802ead:	68 73 3a 80 00       	push   $0x803a73
  802eb2:	e8 a4 d3 ff ff       	call   80025b <_panic>
  802eb7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	89 10                	mov    %edx,(%eax)
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	8b 00                	mov    (%eax),%eax
  802ec7:	85 c0                	test   %eax,%eax
  802ec9:	74 0d                	je     802ed8 <insert_sorted_with_merge_freeList+0x5e7>
  802ecb:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed3:	89 50 04             	mov    %edx,0x4(%eax)
  802ed6:	eb 08                	jmp    802ee0 <insert_sorted_with_merge_freeList+0x5ef>
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ef7:	40                   	inc    %eax
  802ef8:	a3 54 41 80 00       	mov    %eax,0x804154
  802efd:	e9 b7 00 00 00       	jmp    802fb9 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f02:	8b 45 08             	mov    0x8(%ebp),%eax
  802f05:	8b 40 08             	mov    0x8(%eax),%eax
  802f08:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f0b:	0f 84 e2 00 00 00    	je     802ff3 <insert_sorted_with_merge_freeList+0x702>
  802f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f14:	8b 40 08             	mov    0x8(%eax),%eax
  802f17:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f1a:	0f 85 d3 00 00 00    	jne    802ff3 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	8b 50 08             	mov    0x8(%eax),%edx
  802f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f29:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	8b 40 0c             	mov    0xc(%eax),%eax
  802f38:	01 c2                	add    %eax,%edx
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f58:	75 17                	jne    802f71 <insert_sorted_with_merge_freeList+0x680>
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	68 50 3a 80 00       	push   $0x803a50
  802f62:	68 61 01 00 00       	push   $0x161
  802f67:	68 73 3a 80 00       	push   $0x803a73
  802f6c:	e8 ea d2 ff ff       	call   80025b <_panic>
  802f71:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	89 10                	mov    %edx,(%eax)
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	74 0d                	je     802f92 <insert_sorted_with_merge_freeList+0x6a1>
  802f85:	a1 48 41 80 00       	mov    0x804148,%eax
  802f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8d:	89 50 04             	mov    %edx,0x4(%eax)
  802f90:	eb 08                	jmp    802f9a <insert_sorted_with_merge_freeList+0x6a9>
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	a3 48 41 80 00       	mov    %eax,0x804148
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fac:	a1 54 41 80 00       	mov    0x804154,%eax
  802fb1:	40                   	inc    %eax
  802fb2:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802fb7:	eb 3a                	jmp    802ff3 <insert_sorted_with_merge_freeList+0x702>
  802fb9:	eb 38                	jmp    802ff3 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802fbb:	a1 40 41 80 00       	mov    0x804140,%eax
  802fc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fc7:	74 07                	je     802fd0 <insert_sorted_with_merge_freeList+0x6df>
  802fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fcc:	8b 00                	mov    (%eax),%eax
  802fce:	eb 05                	jmp    802fd5 <insert_sorted_with_merge_freeList+0x6e4>
  802fd0:	b8 00 00 00 00       	mov    $0x0,%eax
  802fd5:	a3 40 41 80 00       	mov    %eax,0x804140
  802fda:	a1 40 41 80 00       	mov    0x804140,%eax
  802fdf:	85 c0                	test   %eax,%eax
  802fe1:	0f 85 fa fb ff ff    	jne    802be1 <insert_sorted_with_merge_freeList+0x2f0>
  802fe7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802feb:	0f 85 f0 fb ff ff    	jne    802be1 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  802ff1:	eb 01                	jmp    802ff4 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  802ff3:	90                   	nop
							}

						}
		          }
		}
}
  802ff4:	90                   	nop
  802ff5:	c9                   	leave  
  802ff6:	c3                   	ret    
  802ff7:	90                   	nop

00802ff8 <__udivdi3>:
  802ff8:	55                   	push   %ebp
  802ff9:	57                   	push   %edi
  802ffa:	56                   	push   %esi
  802ffb:	53                   	push   %ebx
  802ffc:	83 ec 1c             	sub    $0x1c,%esp
  802fff:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803003:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803007:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80300b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80300f:	89 ca                	mov    %ecx,%edx
  803011:	89 f8                	mov    %edi,%eax
  803013:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803017:	85 f6                	test   %esi,%esi
  803019:	75 2d                	jne    803048 <__udivdi3+0x50>
  80301b:	39 cf                	cmp    %ecx,%edi
  80301d:	77 65                	ja     803084 <__udivdi3+0x8c>
  80301f:	89 fd                	mov    %edi,%ebp
  803021:	85 ff                	test   %edi,%edi
  803023:	75 0b                	jne    803030 <__udivdi3+0x38>
  803025:	b8 01 00 00 00       	mov    $0x1,%eax
  80302a:	31 d2                	xor    %edx,%edx
  80302c:	f7 f7                	div    %edi
  80302e:	89 c5                	mov    %eax,%ebp
  803030:	31 d2                	xor    %edx,%edx
  803032:	89 c8                	mov    %ecx,%eax
  803034:	f7 f5                	div    %ebp
  803036:	89 c1                	mov    %eax,%ecx
  803038:	89 d8                	mov    %ebx,%eax
  80303a:	f7 f5                	div    %ebp
  80303c:	89 cf                	mov    %ecx,%edi
  80303e:	89 fa                	mov    %edi,%edx
  803040:	83 c4 1c             	add    $0x1c,%esp
  803043:	5b                   	pop    %ebx
  803044:	5e                   	pop    %esi
  803045:	5f                   	pop    %edi
  803046:	5d                   	pop    %ebp
  803047:	c3                   	ret    
  803048:	39 ce                	cmp    %ecx,%esi
  80304a:	77 28                	ja     803074 <__udivdi3+0x7c>
  80304c:	0f bd fe             	bsr    %esi,%edi
  80304f:	83 f7 1f             	xor    $0x1f,%edi
  803052:	75 40                	jne    803094 <__udivdi3+0x9c>
  803054:	39 ce                	cmp    %ecx,%esi
  803056:	72 0a                	jb     803062 <__udivdi3+0x6a>
  803058:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80305c:	0f 87 9e 00 00 00    	ja     803100 <__udivdi3+0x108>
  803062:	b8 01 00 00 00       	mov    $0x1,%eax
  803067:	89 fa                	mov    %edi,%edx
  803069:	83 c4 1c             	add    $0x1c,%esp
  80306c:	5b                   	pop    %ebx
  80306d:	5e                   	pop    %esi
  80306e:	5f                   	pop    %edi
  80306f:	5d                   	pop    %ebp
  803070:	c3                   	ret    
  803071:	8d 76 00             	lea    0x0(%esi),%esi
  803074:	31 ff                	xor    %edi,%edi
  803076:	31 c0                	xor    %eax,%eax
  803078:	89 fa                	mov    %edi,%edx
  80307a:	83 c4 1c             	add    $0x1c,%esp
  80307d:	5b                   	pop    %ebx
  80307e:	5e                   	pop    %esi
  80307f:	5f                   	pop    %edi
  803080:	5d                   	pop    %ebp
  803081:	c3                   	ret    
  803082:	66 90                	xchg   %ax,%ax
  803084:	89 d8                	mov    %ebx,%eax
  803086:	f7 f7                	div    %edi
  803088:	31 ff                	xor    %edi,%edi
  80308a:	89 fa                	mov    %edi,%edx
  80308c:	83 c4 1c             	add    $0x1c,%esp
  80308f:	5b                   	pop    %ebx
  803090:	5e                   	pop    %esi
  803091:	5f                   	pop    %edi
  803092:	5d                   	pop    %ebp
  803093:	c3                   	ret    
  803094:	bd 20 00 00 00       	mov    $0x20,%ebp
  803099:	89 eb                	mov    %ebp,%ebx
  80309b:	29 fb                	sub    %edi,%ebx
  80309d:	89 f9                	mov    %edi,%ecx
  80309f:	d3 e6                	shl    %cl,%esi
  8030a1:	89 c5                	mov    %eax,%ebp
  8030a3:	88 d9                	mov    %bl,%cl
  8030a5:	d3 ed                	shr    %cl,%ebp
  8030a7:	89 e9                	mov    %ebp,%ecx
  8030a9:	09 f1                	or     %esi,%ecx
  8030ab:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030af:	89 f9                	mov    %edi,%ecx
  8030b1:	d3 e0                	shl    %cl,%eax
  8030b3:	89 c5                	mov    %eax,%ebp
  8030b5:	89 d6                	mov    %edx,%esi
  8030b7:	88 d9                	mov    %bl,%cl
  8030b9:	d3 ee                	shr    %cl,%esi
  8030bb:	89 f9                	mov    %edi,%ecx
  8030bd:	d3 e2                	shl    %cl,%edx
  8030bf:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030c3:	88 d9                	mov    %bl,%cl
  8030c5:	d3 e8                	shr    %cl,%eax
  8030c7:	09 c2                	or     %eax,%edx
  8030c9:	89 d0                	mov    %edx,%eax
  8030cb:	89 f2                	mov    %esi,%edx
  8030cd:	f7 74 24 0c          	divl   0xc(%esp)
  8030d1:	89 d6                	mov    %edx,%esi
  8030d3:	89 c3                	mov    %eax,%ebx
  8030d5:	f7 e5                	mul    %ebp
  8030d7:	39 d6                	cmp    %edx,%esi
  8030d9:	72 19                	jb     8030f4 <__udivdi3+0xfc>
  8030db:	74 0b                	je     8030e8 <__udivdi3+0xf0>
  8030dd:	89 d8                	mov    %ebx,%eax
  8030df:	31 ff                	xor    %edi,%edi
  8030e1:	e9 58 ff ff ff       	jmp    80303e <__udivdi3+0x46>
  8030e6:	66 90                	xchg   %ax,%ax
  8030e8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8030ec:	89 f9                	mov    %edi,%ecx
  8030ee:	d3 e2                	shl    %cl,%edx
  8030f0:	39 c2                	cmp    %eax,%edx
  8030f2:	73 e9                	jae    8030dd <__udivdi3+0xe5>
  8030f4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8030f7:	31 ff                	xor    %edi,%edi
  8030f9:	e9 40 ff ff ff       	jmp    80303e <__udivdi3+0x46>
  8030fe:	66 90                	xchg   %ax,%ax
  803100:	31 c0                	xor    %eax,%eax
  803102:	e9 37 ff ff ff       	jmp    80303e <__udivdi3+0x46>
  803107:	90                   	nop

00803108 <__umoddi3>:
  803108:	55                   	push   %ebp
  803109:	57                   	push   %edi
  80310a:	56                   	push   %esi
  80310b:	53                   	push   %ebx
  80310c:	83 ec 1c             	sub    $0x1c,%esp
  80310f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803113:	8b 74 24 34          	mov    0x34(%esp),%esi
  803117:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80311b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80311f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803123:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803127:	89 f3                	mov    %esi,%ebx
  803129:	89 fa                	mov    %edi,%edx
  80312b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80312f:	89 34 24             	mov    %esi,(%esp)
  803132:	85 c0                	test   %eax,%eax
  803134:	75 1a                	jne    803150 <__umoddi3+0x48>
  803136:	39 f7                	cmp    %esi,%edi
  803138:	0f 86 a2 00 00 00    	jbe    8031e0 <__umoddi3+0xd8>
  80313e:	89 c8                	mov    %ecx,%eax
  803140:	89 f2                	mov    %esi,%edx
  803142:	f7 f7                	div    %edi
  803144:	89 d0                	mov    %edx,%eax
  803146:	31 d2                	xor    %edx,%edx
  803148:	83 c4 1c             	add    $0x1c,%esp
  80314b:	5b                   	pop    %ebx
  80314c:	5e                   	pop    %esi
  80314d:	5f                   	pop    %edi
  80314e:	5d                   	pop    %ebp
  80314f:	c3                   	ret    
  803150:	39 f0                	cmp    %esi,%eax
  803152:	0f 87 ac 00 00 00    	ja     803204 <__umoddi3+0xfc>
  803158:	0f bd e8             	bsr    %eax,%ebp
  80315b:	83 f5 1f             	xor    $0x1f,%ebp
  80315e:	0f 84 ac 00 00 00    	je     803210 <__umoddi3+0x108>
  803164:	bf 20 00 00 00       	mov    $0x20,%edi
  803169:	29 ef                	sub    %ebp,%edi
  80316b:	89 fe                	mov    %edi,%esi
  80316d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803171:	89 e9                	mov    %ebp,%ecx
  803173:	d3 e0                	shl    %cl,%eax
  803175:	89 d7                	mov    %edx,%edi
  803177:	89 f1                	mov    %esi,%ecx
  803179:	d3 ef                	shr    %cl,%edi
  80317b:	09 c7                	or     %eax,%edi
  80317d:	89 e9                	mov    %ebp,%ecx
  80317f:	d3 e2                	shl    %cl,%edx
  803181:	89 14 24             	mov    %edx,(%esp)
  803184:	89 d8                	mov    %ebx,%eax
  803186:	d3 e0                	shl    %cl,%eax
  803188:	89 c2                	mov    %eax,%edx
  80318a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80318e:	d3 e0                	shl    %cl,%eax
  803190:	89 44 24 04          	mov    %eax,0x4(%esp)
  803194:	8b 44 24 08          	mov    0x8(%esp),%eax
  803198:	89 f1                	mov    %esi,%ecx
  80319a:	d3 e8                	shr    %cl,%eax
  80319c:	09 d0                	or     %edx,%eax
  80319e:	d3 eb                	shr    %cl,%ebx
  8031a0:	89 da                	mov    %ebx,%edx
  8031a2:	f7 f7                	div    %edi
  8031a4:	89 d3                	mov    %edx,%ebx
  8031a6:	f7 24 24             	mull   (%esp)
  8031a9:	89 c6                	mov    %eax,%esi
  8031ab:	89 d1                	mov    %edx,%ecx
  8031ad:	39 d3                	cmp    %edx,%ebx
  8031af:	0f 82 87 00 00 00    	jb     80323c <__umoddi3+0x134>
  8031b5:	0f 84 91 00 00 00    	je     80324c <__umoddi3+0x144>
  8031bb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031bf:	29 f2                	sub    %esi,%edx
  8031c1:	19 cb                	sbb    %ecx,%ebx
  8031c3:	89 d8                	mov    %ebx,%eax
  8031c5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031c9:	d3 e0                	shl    %cl,%eax
  8031cb:	89 e9                	mov    %ebp,%ecx
  8031cd:	d3 ea                	shr    %cl,%edx
  8031cf:	09 d0                	or     %edx,%eax
  8031d1:	89 e9                	mov    %ebp,%ecx
  8031d3:	d3 eb                	shr    %cl,%ebx
  8031d5:	89 da                	mov    %ebx,%edx
  8031d7:	83 c4 1c             	add    $0x1c,%esp
  8031da:	5b                   	pop    %ebx
  8031db:	5e                   	pop    %esi
  8031dc:	5f                   	pop    %edi
  8031dd:	5d                   	pop    %ebp
  8031de:	c3                   	ret    
  8031df:	90                   	nop
  8031e0:	89 fd                	mov    %edi,%ebp
  8031e2:	85 ff                	test   %edi,%edi
  8031e4:	75 0b                	jne    8031f1 <__umoddi3+0xe9>
  8031e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031eb:	31 d2                	xor    %edx,%edx
  8031ed:	f7 f7                	div    %edi
  8031ef:	89 c5                	mov    %eax,%ebp
  8031f1:	89 f0                	mov    %esi,%eax
  8031f3:	31 d2                	xor    %edx,%edx
  8031f5:	f7 f5                	div    %ebp
  8031f7:	89 c8                	mov    %ecx,%eax
  8031f9:	f7 f5                	div    %ebp
  8031fb:	89 d0                	mov    %edx,%eax
  8031fd:	e9 44 ff ff ff       	jmp    803146 <__umoddi3+0x3e>
  803202:	66 90                	xchg   %ax,%ax
  803204:	89 c8                	mov    %ecx,%eax
  803206:	89 f2                	mov    %esi,%edx
  803208:	83 c4 1c             	add    $0x1c,%esp
  80320b:	5b                   	pop    %ebx
  80320c:	5e                   	pop    %esi
  80320d:	5f                   	pop    %edi
  80320e:	5d                   	pop    %ebp
  80320f:	c3                   	ret    
  803210:	3b 04 24             	cmp    (%esp),%eax
  803213:	72 06                	jb     80321b <__umoddi3+0x113>
  803215:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803219:	77 0f                	ja     80322a <__umoddi3+0x122>
  80321b:	89 f2                	mov    %esi,%edx
  80321d:	29 f9                	sub    %edi,%ecx
  80321f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803223:	89 14 24             	mov    %edx,(%esp)
  803226:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80322a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80322e:	8b 14 24             	mov    (%esp),%edx
  803231:	83 c4 1c             	add    $0x1c,%esp
  803234:	5b                   	pop    %ebx
  803235:	5e                   	pop    %esi
  803236:	5f                   	pop    %edi
  803237:	5d                   	pop    %ebp
  803238:	c3                   	ret    
  803239:	8d 76 00             	lea    0x0(%esi),%esi
  80323c:	2b 04 24             	sub    (%esp),%eax
  80323f:	19 fa                	sbb    %edi,%edx
  803241:	89 d1                	mov    %edx,%ecx
  803243:	89 c6                	mov    %eax,%esi
  803245:	e9 71 ff ff ff       	jmp    8031bb <__umoddi3+0xb3>
  80324a:	66 90                	xchg   %ax,%ax
  80324c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803250:	72 ea                	jb     80323c <__umoddi3+0x134>
  803252:	89 d9                	mov    %ebx,%ecx
  803254:	e9 62 ff ff ff       	jmp    8031bb <__umoddi3+0xb3>

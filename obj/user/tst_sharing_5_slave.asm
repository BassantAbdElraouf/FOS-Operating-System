
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 ff 00 00 00       	call   800135 <libmain>
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
  80008c:	68 80 32 80 00       	push   $0x803280
  800091:	6a 12                	push   $0x12
  800093:	68 9c 32 80 00       	push   $0x80329c
  800098:	e8 d4 01 00 00       	call   800271 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 ad 13 00 00       	call   801454 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int expected;
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 0b 1b 00 00       	call   801bba <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 b7 32 80 00       	push   $0x8032b7
  8000b7:	50                   	push   %eax
  8000b8:	e8 bd 15 00 00       	call   80167a <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 f9 17 00 00       	call   8018c1 <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 bc 32 80 00       	push   $0x8032bc
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 7b 16 00 00       	call   801761 <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 e0 32 80 00       	push   $0x8032e0
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 c3 17 00 00       	call   8018c1 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	expected = 1;
  80010a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  800111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800114:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 f8 32 80 00       	push   $0x8032f8
  800121:	6a 24                	push   $0x24
  800123:	68 9c 32 80 00       	push   $0x80329c
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 ad 1b 00 00       	call   801cdf <inctst>

	return;
  800132:	90                   	nop
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013b:	e8 61 1a 00 00       	call   801ba1 <sys_getenvindex>
  800140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800146:	89 d0                	mov    %edx,%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	01 c0                	add    %eax,%eax
  80014f:	01 d0                	add    %edx,%eax
  800151:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800158:	01 d0                	add    %edx,%eax
  80015a:	c1 e0 04             	shl    $0x4,%eax
  80015d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800162:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800167:	a1 20 40 80 00       	mov    0x804020,%eax
  80016c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0f                	je     800185 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800176:	a1 20 40 80 00       	mov    0x804020,%eax
  80017b:	05 5c 05 00 00       	add    $0x55c,%eax
  800180:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800189:	7e 0a                	jle    800195 <libmain+0x60>
		binaryname = argv[0];
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	8b 00                	mov    (%eax),%eax
  800190:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 0c             	pushl  0xc(%ebp)
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 fe ff ff       	call   800038 <_main>
  8001a3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a6:	e8 03 18 00 00       	call   8019ae <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 9c 33 80 00       	push   $0x80339c
  8001b3:	e8 6d 03 00 00       	call   800525 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	52                   	push   %edx
  8001d5:	50                   	push   %eax
  8001d6:	68 c4 33 80 00       	push   $0x8033c4
  8001db:	e8 45 03 00 00       	call   800525 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fe:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800204:	51                   	push   %ecx
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	68 ec 33 80 00       	push   $0x8033ec
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 44 34 80 00       	push   $0x803444
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 9c 33 80 00       	push   $0x80339c
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 83 17 00 00       	call   8019c8 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800245:	e8 19 00 00 00       	call   800263 <exit>
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	6a 00                	push   $0x0
  800258:	e8 10 19 00 00       	call   801b6d <sys_destroy_env>
  80025d:	83 c4 10             	add    $0x10,%esp
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <exit>:

void
exit(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800269:	e8 65 19 00 00       	call   801bd3 <sys_exit_env>
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800277:	8d 45 10             	lea    0x10(%ebp),%eax
  80027a:	83 c0 04             	add    $0x4,%eax
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800280:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800285:	85 c0                	test   %eax,%eax
  800287:	74 16                	je     80029f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800289:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	50                   	push   %eax
  800292:	68 58 34 80 00       	push   $0x803458
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 5d 34 80 00       	push   $0x80345d
  8002b0:	e8 70 02 00 00       	call   800525 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	e8 f3 01 00 00       	call   8004ba <vcprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	68 79 34 80 00       	push   $0x803479
  8002d4:	e8 e1 01 00 00       	call   8004ba <vcprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002dc:	e8 82 ff ff ff       	call   800263 <exit>

	// should not return here
	while (1) ;
  8002e1:	eb fe                	jmp    8002e1 <_panic+0x70>

008002e3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ee:	8b 50 74             	mov    0x74(%eax),%edx
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	74 14                	je     80030c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	68 7c 34 80 00       	push   $0x80347c
  800300:	6a 26                	push   $0x26
  800302:	68 c8 34 80 00       	push   $0x8034c8
  800307:	e8 65 ff ff ff       	call   800271 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80031a:	e9 c2 00 00 00       	jmp    8003e1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	85 c0                	test   %eax,%eax
  800332:	75 08                	jne    80033c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800334:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800337:	e9 a2 00 00 00       	jmp    8003de <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80033c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800343:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80034a:	eb 69                	jmp    8003b5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80034c:	a1 20 40 80 00       	mov    0x804020,%eax
  800351:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035a:	89 d0                	mov    %edx,%eax
  80035c:	01 c0                	add    %eax,%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	c1 e0 03             	shl    $0x3,%eax
  800363:	01 c8                	add    %ecx,%eax
  800365:	8a 40 04             	mov    0x4(%eax),%al
  800368:	84 c0                	test   %al,%al
  80036a:	75 46                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036c:	a1 20 40 80 00       	mov    0x804020,%eax
  800371:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037a:	89 d0                	mov    %edx,%eax
  80037c:	01 c0                	add    %eax,%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c1 e0 03             	shl    $0x3,%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800392:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 c8                	add    %ecx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	75 09                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003a9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b0:	eb 12                	jmp    8003c4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 50 74             	mov    0x74(%eax),%edx
  8003bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c0:	39 c2                	cmp    %eax,%edx
  8003c2:	77 88                	ja     80034c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c8:	75 14                	jne    8003de <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	68 d4 34 80 00       	push   $0x8034d4
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 c8 34 80 00       	push   $0x8034c8
  8003d9:	e8 93 fe ff ff       	call   800271 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003de:	ff 45 f0             	incl   -0x10(%ebp)
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e7:	0f 8c 32 ff ff ff    	jl     80031f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fb:	eb 26                	jmp    800423 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800402:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800408:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040b:	89 d0                	mov    %edx,%eax
  80040d:	01 c0                	add    %eax,%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	c1 e0 03             	shl    $0x3,%eax
  800414:	01 c8                	add    %ecx,%eax
  800416:	8a 40 04             	mov    0x4(%eax),%al
  800419:	3c 01                	cmp    $0x1,%al
  80041b:	75 03                	jne    800420 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80041d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800420:	ff 45 e0             	incl   -0x20(%ebp)
  800423:	a1 20 40 80 00       	mov    0x804020,%eax
  800428:	8b 50 74             	mov    0x74(%eax),%edx
  80042b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042e:	39 c2                	cmp    %eax,%edx
  800430:	77 cb                	ja     8003fd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800435:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800438:	74 14                	je     80044e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	68 28 35 80 00       	push   $0x803528
  800442:	6a 44                	push   $0x44
  800444:	68 c8 34 80 00       	push   $0x8034c8
  800449:	e8 23 fe ff ff       	call   800271 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044e:	90                   	nop
  80044f:	c9                   	leave  
  800450:	c3                   	ret    

00800451 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 48 01             	lea    0x1(%eax),%ecx
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	89 0a                	mov    %ecx,(%edx)
  800464:	8b 55 08             	mov    0x8(%ebp),%edx
  800467:	88 d1                	mov    %dl,%cl
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047a:	75 2c                	jne    8004a8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047c:	a0 24 40 80 00       	mov    0x804024,%al
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	8b 55 0c             	mov    0xc(%ebp),%edx
  800487:	8b 12                	mov    (%edx),%edx
  800489:	89 d1                	mov    %edx,%ecx
  80048b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048e:	83 c2 08             	add    $0x8,%edx
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	50                   	push   %eax
  800495:	51                   	push   %ecx
  800496:	52                   	push   %edx
  800497:	e8 64 13 00 00       	call   801800 <sys_cputs>
  80049c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 40 04             	mov    0x4(%eax),%eax
  8004ae:	8d 50 01             	lea    0x1(%eax),%edx
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ca:	00 00 00 
	b.cnt = 0;
  8004cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	ff 75 08             	pushl  0x8(%ebp)
  8004dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	68 51 04 80 00       	push   $0x800451
  8004e9:	e8 11 02 00 00       	call   8006ff <vprintfmt>
  8004ee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f1:	a0 24 40 80 00       	mov    0x804024,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	50                   	push   %eax
  800503:	52                   	push   %edx
  800504:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050a:	83 c0 08             	add    $0x8,%eax
  80050d:	50                   	push   %eax
  80050e:	e8 ed 12 00 00       	call   801800 <sys_cputs>
  800513:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800516:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80051d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <cprintf>:

int cprintf(const char *fmt, ...) {
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800532:	8d 45 0c             	lea    0xc(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 73 ff ff ff       	call   8004ba <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800558:	e8 51 14 00 00       	call   8019ae <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800560:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 f4             	pushl  -0xc(%ebp)
  80056c:	50                   	push   %eax
  80056d:	e8 48 ff ff ff       	call   8004ba <vcprintf>
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800578:	e8 4b 14 00 00       	call   8019c8 <sys_enable_interrupt>
	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	53                   	push   %ebx
  800586:	83 ec 14             	sub    $0x14,%esp
  800589:	8b 45 10             	mov    0x10(%ebp),%eax
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800595:	8b 45 18             	mov    0x18(%ebp),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a0:	77 55                	ja     8005f7 <printnum+0x75>
  8005a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a5:	72 05                	jb     8005ac <printnum+0x2a>
  8005a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005aa:	77 4b                	ja     8005f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	52                   	push   %edx
  8005bb:	50                   	push   %eax
  8005bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c2:	e8 49 2a 00 00       	call   803010 <__udivdi3>
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	ff 75 20             	pushl  0x20(%ebp)
  8005d0:	53                   	push   %ebx
  8005d1:	ff 75 18             	pushl  0x18(%ebp)
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	ff 75 0c             	pushl  0xc(%ebp)
  8005d9:	ff 75 08             	pushl  0x8(%ebp)
  8005dc:	e8 a1 ff ff ff       	call   800582 <printnum>
  8005e1:	83 c4 20             	add    $0x20,%esp
  8005e4:	eb 1a                	jmp    800600 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	ff d0                	call   *%eax
  8005f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8005fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fe:	7f e6                	jg     8005e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800600:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800603:	bb 00 00 00 00       	mov    $0x0,%ebx
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060e:	53                   	push   %ebx
  80060f:	51                   	push   %ecx
  800610:	52                   	push   %edx
  800611:	50                   	push   %eax
  800612:	e8 09 2b 00 00       	call   803120 <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 94 37 80 00       	add    $0x803794,%eax
  80061f:	8a 00                	mov    (%eax),%al
  800621:	0f be c0             	movsbl %al,%eax
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	50                   	push   %eax
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	ff d0                	call   *%eax
  800630:	83 c4 10             	add    $0x10,%esp
}
  800633:	90                   	nop
  800634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800640:	7e 1c                	jle    80065e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	8d 50 08             	lea    0x8(%eax),%edx
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 10                	mov    %edx,(%eax)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	83 e8 08             	sub    $0x8,%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	eb 40                	jmp    80069e <getuint+0x65>
	else if (lflag)
  80065e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800662:	74 1e                	je     800682 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	8d 50 04             	lea    0x4(%eax),%edx
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	89 10                	mov    %edx,(%eax)
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	ba 00 00 00 00       	mov    $0x0,%edx
  800680:	eb 1c                	jmp    80069e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a7:	7e 1c                	jle    8006c5 <getint+0x25>
		return va_arg(*ap, long long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 08             	lea    0x8(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 08             	sub    $0x8,%eax
  8006be:	8b 50 04             	mov    0x4(%eax),%edx
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	eb 38                	jmp    8006fd <getint+0x5d>
	else if (lflag)
  8006c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c9:	74 1a                	je     8006e5 <getint+0x45>
		return va_arg(*ap, long);
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	89 10                	mov    %edx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	83 e8 04             	sub    $0x4,%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	99                   	cltd   
  8006e3:	eb 18                	jmp    8006fd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	99                   	cltd   
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	56                   	push   %esi
  800703:	53                   	push   %ebx
  800704:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	eb 17                	jmp    800720 <vprintfmt+0x21>
			if (ch == '\0')
  800709:	85 db                	test   %ebx,%ebx
  80070b:	0f 84 af 03 00 00    	je     800ac0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	53                   	push   %ebx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	ff d0                	call   *%eax
  80071d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	8d 50 01             	lea    0x1(%eax),%edx
  800726:	89 55 10             	mov    %edx,0x10(%ebp)
  800729:	8a 00                	mov    (%eax),%al
  80072b:	0f b6 d8             	movzbl %al,%ebx
  80072e:	83 fb 25             	cmp    $0x25,%ebx
  800731:	75 d6                	jne    800709 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800733:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800737:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800745:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800753:	8b 45 10             	mov    0x10(%ebp),%eax
  800756:	8d 50 01             	lea    0x1(%eax),%edx
  800759:	89 55 10             	mov    %edx,0x10(%ebp)
  80075c:	8a 00                	mov    (%eax),%al
  80075e:	0f b6 d8             	movzbl %al,%ebx
  800761:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800764:	83 f8 55             	cmp    $0x55,%eax
  800767:	0f 87 2b 03 00 00    	ja     800a98 <vprintfmt+0x399>
  80076d:	8b 04 85 b8 37 80 00 	mov    0x8037b8(,%eax,4),%eax
  800774:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800776:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80077a:	eb d7                	jmp    800753 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800780:	eb d1                	jmp    800753 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800782:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800789:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078c:	89 d0                	mov    %edx,%eax
  80078e:	c1 e0 02             	shl    $0x2,%eax
  800791:	01 d0                	add    %edx,%eax
  800793:	01 c0                	add    %eax,%eax
  800795:	01 d8                	add    %ebx,%eax
  800797:	83 e8 30             	sub    $0x30,%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079d:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 3e                	jle    8007e8 <vprintfmt+0xe9>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 39                	jg     8007e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b2:	eb d5                	jmp    800789 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c8:	eb 1f                	jmp    8007e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ce:	79 83                	jns    800753 <vprintfmt+0x54>
				width = 0;
  8007d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d7:	e9 77 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e3:	e9 6b ff ff ff       	jmp    800753 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	0f 89 60 ff ff ff    	jns    800753 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800800:	e9 4e ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800805:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800808:	e9 46 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	50                   	push   %eax
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			break;
  80082d:	e9 89 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800843:	85 db                	test   %ebx,%ebx
  800845:	79 02                	jns    800849 <vprintfmt+0x14a>
				err = -err;
  800847:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800849:	83 fb 64             	cmp    $0x64,%ebx
  80084c:	7f 0b                	jg     800859 <vprintfmt+0x15a>
  80084e:	8b 34 9d 00 36 80 00 	mov    0x803600(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 a5 37 80 00       	push   $0x8037a5
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 5e 02 00 00       	call   800ac8 <printfmt>
  80086a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086d:	e9 49 02 00 00       	jmp    800abb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800872:	56                   	push   %esi
  800873:	68 ae 37 80 00       	push   $0x8037ae
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 45 02 00 00       	call   800ac8 <printfmt>
  800883:	83 c4 10             	add    $0x10,%esp
			break;
  800886:	e9 30 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 30                	mov    (%eax),%esi
  80089c:	85 f6                	test   %esi,%esi
  80089e:	75 05                	jne    8008a5 <vprintfmt+0x1a6>
				p = "(null)";
  8008a0:	be b1 37 80 00       	mov    $0x8037b1,%esi
			if (width > 0 && padc != '-')
  8008a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a9:	7e 6d                	jle    800918 <vprintfmt+0x219>
  8008ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008af:	74 67                	je     800918 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	50                   	push   %eax
  8008b8:	56                   	push   %esi
  8008b9:	e8 0c 03 00 00       	call   800bca <strnlen>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c4:	eb 16                	jmp    8008dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e0:	7f e4                	jg     8008c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e2:	eb 34                	jmp    800918 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e8:	74 1c                	je     800906 <vprintfmt+0x207>
  8008ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ed:	7e 05                	jle    8008f4 <vprintfmt+0x1f5>
  8008ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f2:	7e 12                	jle    800906 <vprintfmt+0x207>
					putch('?', putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	6a 3f                	push   $0x3f
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	eb 0f                	jmp    800915 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	ff 4d e4             	decl   -0x1c(%ebp)
  800918:	89 f0                	mov    %esi,%eax
  80091a:	8d 70 01             	lea    0x1(%eax),%esi
  80091d:	8a 00                	mov    (%eax),%al
  80091f:	0f be d8             	movsbl %al,%ebx
  800922:	85 db                	test   %ebx,%ebx
  800924:	74 24                	je     80094a <vprintfmt+0x24b>
  800926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092a:	78 b8                	js     8008e4 <vprintfmt+0x1e5>
  80092c:	ff 4d e0             	decl   -0x20(%ebp)
  80092f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800933:	79 af                	jns    8008e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800935:	eb 13                	jmp    80094a <vprintfmt+0x24b>
				putch(' ', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 20                	push   $0x20
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800947:	ff 4d e4             	decl   -0x1c(%ebp)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7f e7                	jg     800937 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800950:	e9 66 01 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 e8             	pushl  -0x18(%ebp)
  80095b:	8d 45 14             	lea    0x14(%ebp),%eax
  80095e:	50                   	push   %eax
  80095f:	e8 3c fd ff ff       	call   8006a0 <getint>
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800973:	85 d2                	test   %edx,%edx
  800975:	79 23                	jns    80099a <vprintfmt+0x29b>
				putch('-', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	6a 2d                	push   $0x2d
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098d:	f7 d8                	neg    %eax
  80098f:	83 d2 00             	adc    $0x0,%edx
  800992:	f7 da                	neg    %edx
  800994:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800997:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80099a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a1:	e9 bc 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8009af:	50                   	push   %eax
  8009b0:	e8 84 fc ff ff       	call   800639 <getuint>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c5:	e9 98 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 58                	push   $0x58
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 58                	push   $0x58
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 58                	push   $0x58
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			break;
  8009fa:	e9 bc 00 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 30                	push   $0x30
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 78                	push   $0x78
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 c0 04             	add    $0x4,%eax
  800a25:	89 45 14             	mov    %eax,0x14(%ebp)
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 e8 04             	sub    $0x4,%eax
  800a2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a41:	eb 1f                	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 e8             	pushl  -0x18(%ebp)
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 e7 fb ff ff       	call   800639 <getuint>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a69:	83 ec 04             	sub    $0x4,%esp
  800a6c:	52                   	push   %edx
  800a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 00 fb ff ff       	call   800582 <printnum>
  800a82:	83 c4 20             	add    $0x20,%esp
			break;
  800a85:	eb 34                	jmp    800abb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			break;
  800a96:	eb 23                	jmp    800abb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 25                	push   $0x25
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa8:	ff 4d 10             	decl   0x10(%ebp)
  800aab:	eb 03                	jmp    800ab0 <vprintfmt+0x3b1>
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab3:	48                   	dec    %eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	3c 25                	cmp    $0x25,%al
  800ab8:	75 f3                	jne    800aad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aba:	90                   	nop
		}
	}
  800abb:	e9 47 fc ff ff       	jmp    800707 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ace:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 16 fc ff ff       	call   8006ff <vprintfmt>
  800ae9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aec:	90                   	nop
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 40 08             	mov    0x8(%eax),%eax
  800af8:	8d 50 01             	lea    0x1(%eax),%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	8b 10                	mov    (%eax),%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 40 04             	mov    0x4(%eax),%eax
  800b0c:	39 c2                	cmp    %eax,%edx
  800b0e:	73 12                	jae    800b22 <sprintputch+0x33>
		*b->buf++ = ch;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	8d 48 01             	lea    0x1(%eax),%ecx
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 0a                	mov    %ecx,(%edx)
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	88 10                	mov    %dl,(%eax)
}
  800b22:	90                   	nop
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	01 d0                	add    %edx,%eax
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4a:	74 06                	je     800b52 <vsnprintf+0x2d>
  800b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b50:	7f 07                	jg     800b59 <vsnprintf+0x34>
		return -E_INVAL;
  800b52:	b8 03 00 00 00       	mov    $0x3,%eax
  800b57:	eb 20                	jmp    800b79 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b59:	ff 75 14             	pushl  0x14(%ebp)
  800b5c:	ff 75 10             	pushl  0x10(%ebp)
  800b5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b62:	50                   	push   %eax
  800b63:	68 ef 0a 80 00       	push   $0x800aef
  800b68:	e8 92 fb ff ff       	call   8006ff <vprintfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b81:	8d 45 10             	lea    0x10(%ebp),%eax
  800b84:	83 c0 04             	add    $0x4,%eax
  800b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	50                   	push   %eax
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 89 ff ff ff       	call   800b25 <vsnprintf>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb4:	eb 06                	jmp    800bbc <strlen+0x15>
		n++;
  800bb6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	ff 45 08             	incl   0x8(%ebp)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	75 f1                	jne    800bb6 <strlen+0xf>
		n++;
	return n;
  800bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd7:	eb 09                	jmp    800be2 <strnlen+0x18>
		n++;
  800bd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdc:	ff 45 08             	incl   0x8(%ebp)
  800bdf:	ff 4d 0c             	decl   0xc(%ebp)
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	74 09                	je     800bf1 <strnlen+0x27>
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 e8                	jne    800bd9 <strnlen+0xf>
		n++;
	return n;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c02:	90                   	nop
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c15:	8a 12                	mov    (%edx),%dl
  800c17:	88 10                	mov    %dl,(%eax)
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	75 e4                	jne    800c03 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 1f                	jmp    800c58 <strncpy+0x34>
		*dst++ = *src;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8d 50 01             	lea    0x1(%eax),%edx
  800c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	74 03                	je     800c55 <strncpy+0x31>
			src++;
  800c52:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c55:	ff 45 fc             	incl   -0x4(%ebp)
  800c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5e:	72 d9                	jb     800c39 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	74 30                	je     800ca7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c77:	eb 16                	jmp    800c8f <strlcpy+0x2a>
			*dst++ = *src++;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8b:	8a 12                	mov    (%edx),%dl
  800c8d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8f:	ff 4d 10             	decl   0x10(%ebp)
  800c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c96:	74 09                	je     800ca1 <strlcpy+0x3c>
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	84 c0                	test   %al,%al
  800c9f:	75 d8                	jne    800c79 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	29 c2                	sub    %eax,%edx
  800caf:	89 d0                	mov    %edx,%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb6:	eb 06                	jmp    800cbe <strcmp+0xb>
		p++, q++;
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	74 0e                	je     800cd5 <strcmp+0x22>
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 10                	mov    (%eax),%dl
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	38 c2                	cmp    %al,%dl
  800cd3:	74 e3                	je     800cb8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	0f b6 d0             	movzbl %al,%edx
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 c0             	movzbl %al,%eax
  800ce5:	29 c2                	sub    %eax,%edx
  800ce7:	89 d0                	mov    %edx,%eax
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cee:	eb 09                	jmp    800cf9 <strncmp+0xe>
		n--, p++, q++;
  800cf0:	ff 4d 10             	decl   0x10(%ebp)
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	74 17                	je     800d16 <strncmp+0x2b>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strncmp+0x2b>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 da                	je     800cf0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	75 07                	jne    800d23 <strncmp+0x38>
		return 0;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	eb 14                	jmp    800d37 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	29 c2                	sub    %eax,%edx
  800d35:	89 d0                	mov    %edx,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 04             	sub    $0x4,%esp
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d45:	eb 12                	jmp    800d59 <strchr+0x20>
		if (*s == c)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4f:	75 05                	jne    800d56 <strchr+0x1d>
			return (char *) s;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	eb 11                	jmp    800d67 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d56:	ff 45 08             	incl   0x8(%ebp)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	75 e5                	jne    800d47 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 0d                	jmp    800d84 <strfind+0x1b>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	74 0e                	je     800d8f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d81:	ff 45 08             	incl   0x8(%ebp)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	75 ea                	jne    800d77 <strfind+0xe>
  800d8d:	eb 01                	jmp    800d90 <strfind+0x27>
		if (*s == c)
			break;
  800d8f:	90                   	nop
	return (char *) s;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da7:	eb 0e                	jmp    800db7 <memset+0x22>
		*p++ = c;
  800da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db7:	ff 4d f8             	decl   -0x8(%ebp)
  800dba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbe:	79 e9                	jns    800da9 <memset+0x14>
		*p++ = c;

	return v;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd7:	eb 16                	jmp    800def <memcpy+0x2a>
		*d++ = *s++;
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800deb:	8a 12                	mov    (%edx),%dl
  800ded:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 dd                	jne    800dd9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e16:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e19:	73 50                	jae    800e6b <memmove+0x6a>
  800e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e26:	76 43                	jbe    800e6b <memmove+0x6a>
		s += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e34:	eb 10                	jmp    800e46 <memmove+0x45>
			*--d = *--s;
  800e36:	ff 4d f8             	decl   -0x8(%ebp)
  800e39:	ff 4d fc             	decl   -0x4(%ebp)
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	8a 10                	mov    (%eax),%dl
  800e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e44:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 e3                	jne    800e36 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e53:	eb 23                	jmp    800e78 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e64:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e67:	8a 12                	mov    (%edx),%dl
  800e69:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e71:	89 55 10             	mov    %edx,0x10(%ebp)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	75 dd                	jne    800e55 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8f:	eb 2a                	jmp    800ebb <memcmp+0x3e>
		if (*s1 != *s2)
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e94:	8a 10                	mov    (%eax),%dl
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	38 c2                	cmp    %al,%dl
  800e9d:	74 16                	je     800eb5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f b6 d0             	movzbl %al,%edx
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 c0             	movzbl %al,%eax
  800eaf:	29 c2                	sub    %eax,%edx
  800eb1:	89 d0                	mov    %edx,%eax
  800eb3:	eb 18                	jmp    800ecd <memcmp+0x50>
		s1++, s2++;
  800eb5:	ff 45 fc             	incl   -0x4(%ebp)
  800eb8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	75 c9                	jne    800e91 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee0:	eb 15                	jmp    800ef7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 d0             	movzbl %al,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	39 c2                	cmp    %eax,%edx
  800ef2:	74 0d                	je     800f01 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efd:	72 e3                	jb     800ee2 <memfind+0x13>
  800eff:	eb 01                	jmp    800f02 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f01:	90                   	nop
	return (void *) s;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1b:	eb 03                	jmp    800f20 <strtol+0x19>
		s++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 20                	cmp    $0x20,%al
  800f27:	74 f4                	je     800f1d <strtol+0x16>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 09                	cmp    $0x9,%al
  800f30:	74 eb                	je     800f1d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 2b                	cmp    $0x2b,%al
  800f39:	75 05                	jne    800f40 <strtol+0x39>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
  800f3e:	eb 13                	jmp    800f53 <strtol+0x4c>
	else if (*s == '-')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2d                	cmp    $0x2d,%al
  800f47:	75 0a                	jne    800f53 <strtol+0x4c>
		s++, neg = 1;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 06                	je     800f5f <strtol+0x58>
  800f59:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5d:	75 20                	jne    800f7f <strtol+0x78>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 30                	cmp    $0x30,%al
  800f66:	75 17                	jne    800f7f <strtol+0x78>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	40                   	inc    %eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	3c 78                	cmp    $0x78,%al
  800f70:	75 0d                	jne    800f7f <strtol+0x78>
		s += 2, base = 16;
  800f72:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f76:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7d:	eb 28                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 15                	jne    800f9a <strtol+0x93>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 30                	cmp    $0x30,%al
  800f8c:	75 0c                	jne    800f9a <strtol+0x93>
		s++, base = 8;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f98:	eb 0d                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0)
  800f9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9e:	75 07                	jne    800fa7 <strtol+0xa0>
		base = 10;
  800fa0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 2f                	cmp    $0x2f,%al
  800fae:	7e 19                	jle    800fc9 <strtol+0xc2>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 39                	cmp    $0x39,%al
  800fb7:	7f 10                	jg     800fc9 <strtol+0xc2>
			dig = *s - '0';
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	83 e8 30             	sub    $0x30,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc7:	eb 42                	jmp    80100b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 60                	cmp    $0x60,%al
  800fd0:	7e 19                	jle    800feb <strtol+0xe4>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 7a                	cmp    $0x7a,%al
  800fd9:	7f 10                	jg     800feb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f be c0             	movsbl %al,%eax
  800fe3:	83 e8 57             	sub    $0x57,%eax
  800fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe9:	eb 20                	jmp    80100b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 40                	cmp    $0x40,%al
  800ff2:	7e 39                	jle    80102d <strtol+0x126>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 5a                	cmp    $0x5a,%al
  800ffb:	7f 30                	jg     80102d <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f be c0             	movsbl %al,%eax
  801005:	83 e8 37             	sub    $0x37,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801011:	7d 19                	jge    80102c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801027:	e9 7b ff ff ff       	jmp    800fa7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801031:	74 08                	je     80103b <strtol+0x134>
		*endptr = (char *) s;
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103f:	74 07                	je     801048 <strtol+0x141>
  801041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801044:	f7 d8                	neg    %eax
  801046:	eb 03                	jmp    80104b <strtol+0x144>
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <ltostr>:

void
ltostr(long value, char *str)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801061:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801065:	79 13                	jns    80107a <ltostr+0x2d>
	{
		neg = 1;
  801067:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801074:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801077:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801082:	99                   	cltd   
  801083:	f7 f9                	idiv   %ecx
  801085:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801091:	89 c2                	mov    %eax,%edx
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	01 d0                	add    %edx,%eax
  801098:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109b:	83 c2 30             	add    $0x30,%edx
  80109e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a8:	f7 e9                	imul   %ecx
  8010aa:	c1 fa 02             	sar    $0x2,%edx
  8010ad:	89 c8                	mov    %ecx,%eax
  8010af:	c1 f8 1f             	sar    $0x1f,%eax
  8010b2:	29 c2                	sub    %eax,%edx
  8010b4:	89 d0                	mov    %edx,%eax
  8010b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c1:	f7 e9                	imul   %ecx
  8010c3:	c1 fa 02             	sar    $0x2,%edx
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	c1 f8 1f             	sar    $0x1f,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	c1 e0 02             	shl    $0x2,%eax
  8010d2:	01 d0                	add    %edx,%eax
  8010d4:	01 c0                	add    %eax,%eax
  8010d6:	29 c1                	sub    %eax,%ecx
  8010d8:	89 ca                	mov    %ecx,%edx
  8010da:	85 d2                	test   %edx,%edx
  8010dc:	75 9c                	jne    80107a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	48                   	dec    %eax
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 3d                	je     80112f <ltostr+0xe2>
		start = 1 ;
  8010f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f9:	eb 34                	jmp    80112f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 c2                	add    %eax,%edx
  801110:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 c2                	add    %eax,%edx
  801124:	8a 45 eb             	mov    -0x15(%ebp),%al
  801127:	88 02                	mov    %al,(%edx)
		start++ ;
  801129:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801135:	7c c4                	jl     8010fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801137:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801142:	90                   	nop
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 54 fa ff ff       	call   800ba7 <strlen>
  801153:	83 c4 04             	add    $0x4,%esp
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801159:	ff 75 0c             	pushl  0xc(%ebp)
  80115c:	e8 46 fa ff ff       	call   800ba7 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801175:	eb 17                	jmp    80118e <strcconcat+0x49>
		final[s] = str1[s] ;
  801177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 c2                	add    %eax,%edx
  80117f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	01 c8                	add    %ecx,%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118b:	ff 45 fc             	incl   -0x4(%ebp)
  80118e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801191:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801194:	7c e1                	jl     801177 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a4:	eb 1f                	jmp    8011c5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	01 c8                	add    %ecx,%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c2:	ff 45 f8             	incl   -0x8(%ebp)
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cb:	7c d9                	jl     8011a6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d8:	90                   	nop
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ea:	8b 00                	mov    (%eax),%eax
  8011ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fe:	eb 0c                	jmp    80120c <strsplit+0x31>
			*string++ = 0;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8d 50 01             	lea    0x1(%eax),%edx
  801206:	89 55 08             	mov    %edx,0x8(%ebp)
  801209:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	84 c0                	test   %al,%al
  801213:	74 18                	je     80122d <strsplit+0x52>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	50                   	push   %eax
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	e8 13 fb ff ff       	call   800d39 <strchr>
  801226:	83 c4 08             	add    $0x8,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 d3                	jne    801200 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	84 c0                	test   %al,%al
  801234:	74 5a                	je     801290 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	8b 00                	mov    (%eax),%eax
  80123b:	83 f8 0f             	cmp    $0xf,%eax
  80123e:	75 07                	jne    801247 <strsplit+0x6c>
		{
			return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb 66                	jmp    8012ad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 48 01             	lea    0x1(%eax),%ecx
  80124f:	8b 55 14             	mov    0x14(%ebp),%edx
  801252:	89 0a                	mov    %ecx,(%edx)
  801254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 c2                	add    %eax,%edx
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801265:	eb 03                	jmp    80126a <strsplit+0x8f>
			string++;
  801267:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	74 8b                	je     8011fe <strsplit+0x23>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 b5 fa ff ff       	call   800d39 <strchr>
  801284:	83 c4 08             	add    $0x8,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	74 dc                	je     801267 <strsplit+0x8c>
			string++;
	}
  80128b:	e9 6e ff ff ff       	jmp    8011fe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801290:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801291:	8b 45 14             	mov    0x14(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 1f                	je     8012dd <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012be:	e8 1d 00 00 00       	call   8012e0 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	68 10 39 80 00       	push   $0x803910
  8012cb:	e8 55 f2 ff ff       	call   800525 <cprintf>
  8012d0:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d3:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012da:	00 00 00 
	}
}
  8012dd:	90                   	nop
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8012e6:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012ed:	00 00 00 
  8012f0:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012f7:	00 00 00 
  8012fa:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801301:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801304:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80130b:	00 00 00 
  80130e:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801315:	00 00 00 
  801318:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80131f:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801322:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801329:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80132c:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801336:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80133b:	2d 00 10 00 00       	sub    $0x1000,%eax
  801340:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801345:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80134c:	a1 20 41 80 00       	mov    0x804120,%eax
  801351:	c1 e0 04             	shl    $0x4,%eax
  801354:	89 c2                	mov    %eax,%edx
  801356:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801359:	01 d0                	add    %edx,%eax
  80135b:	48                   	dec    %eax
  80135c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80135f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801362:	ba 00 00 00 00       	mov    $0x0,%edx
  801367:	f7 75 f0             	divl   -0x10(%ebp)
  80136a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80136d:	29 d0                	sub    %edx,%eax
  80136f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801372:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801381:	2d 00 10 00 00       	sub    $0x1000,%eax
  801386:	83 ec 04             	sub    $0x4,%esp
  801389:	6a 06                	push   $0x6
  80138b:	ff 75 e8             	pushl  -0x18(%ebp)
  80138e:	50                   	push   %eax
  80138f:	e8 b0 05 00 00       	call   801944 <sys_allocate_chunk>
  801394:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801397:	a1 20 41 80 00       	mov    0x804120,%eax
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	50                   	push   %eax
  8013a0:	e8 25 0c 00 00       	call   801fca <initialize_MemBlocksList>
  8013a5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8013a8:	a1 48 41 80 00       	mov    0x804148,%eax
  8013ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8013b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013b4:	75 14                	jne    8013ca <initialize_dyn_block_system+0xea>
  8013b6:	83 ec 04             	sub    $0x4,%esp
  8013b9:	68 35 39 80 00       	push   $0x803935
  8013be:	6a 29                	push   $0x29
  8013c0:	68 53 39 80 00       	push   $0x803953
  8013c5:	e8 a7 ee ff ff       	call   800271 <_panic>
  8013ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cd:	8b 00                	mov    (%eax),%eax
  8013cf:	85 c0                	test   %eax,%eax
  8013d1:	74 10                	je     8013e3 <initialize_dyn_block_system+0x103>
  8013d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d6:	8b 00                	mov    (%eax),%eax
  8013d8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8013db:	8b 52 04             	mov    0x4(%edx),%edx
  8013de:	89 50 04             	mov    %edx,0x4(%eax)
  8013e1:	eb 0b                	jmp    8013ee <initialize_dyn_block_system+0x10e>
  8013e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e6:	8b 40 04             	mov    0x4(%eax),%eax
  8013e9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f1:	8b 40 04             	mov    0x4(%eax),%eax
  8013f4:	85 c0                	test   %eax,%eax
  8013f6:	74 0f                	je     801407 <initialize_dyn_block_system+0x127>
  8013f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013fb:	8b 40 04             	mov    0x4(%eax),%eax
  8013fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801401:	8b 12                	mov    (%edx),%edx
  801403:	89 10                	mov    %edx,(%eax)
  801405:	eb 0a                	jmp    801411 <initialize_dyn_block_system+0x131>
  801407:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	a3 48 41 80 00       	mov    %eax,0x804148
  801411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801414:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80141a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801424:	a1 54 41 80 00       	mov    0x804154,%eax
  801429:	48                   	dec    %eax
  80142a:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80142f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801432:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801443:	83 ec 0c             	sub    $0xc,%esp
  801446:	ff 75 e0             	pushl  -0x20(%ebp)
  801449:	e8 b9 14 00 00       	call   802907 <insert_sorted_with_merge_freeList>
  80144e:	83 c4 10             	add    $0x10,%esp

}
  801451:	90                   	nop
  801452:	c9                   	leave  
  801453:	c3                   	ret    

00801454 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801454:	55                   	push   %ebp
  801455:	89 e5                	mov    %esp,%ebp
  801457:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80145a:	e8 50 fe ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  80145f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801463:	75 07                	jne    80146c <malloc+0x18>
  801465:	b8 00 00 00 00       	mov    $0x0,%eax
  80146a:	eb 68                	jmp    8014d4 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  80146c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801473:	8b 55 08             	mov    0x8(%ebp),%edx
  801476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801479:	01 d0                	add    %edx,%eax
  80147b:	48                   	dec    %eax
  80147c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80147f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801482:	ba 00 00 00 00       	mov    $0x0,%edx
  801487:	f7 75 f4             	divl   -0xc(%ebp)
  80148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148d:	29 d0                	sub    %edx,%eax
  80148f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801492:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  801499:	e8 74 08 00 00       	call   801d12 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	74 2d                	je     8014cf <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8014a2:	83 ec 0c             	sub    $0xc,%esp
  8014a5:	ff 75 ec             	pushl  -0x14(%ebp)
  8014a8:	e8 52 0e 00 00       	call   8022ff <alloc_block_FF>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8014b3:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8014b7:	74 16                	je     8014cf <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8014b9:	83 ec 0c             	sub    $0xc,%esp
  8014bc:	ff 75 e8             	pushl  -0x18(%ebp)
  8014bf:	e8 3b 0c 00 00       	call   8020ff <insert_sorted_allocList>
  8014c4:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8014c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8014ca:	8b 40 08             	mov    0x8(%eax),%eax
  8014cd:	eb 05                	jmp    8014d4 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8014cf:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8014d4:	c9                   	leave  
  8014d5:	c3                   	ret    

008014d6 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8014d6:	55                   	push   %ebp
  8014d7:	89 e5                	mov    %esp,%ebp
  8014d9:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8014dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014df:	83 ec 08             	sub    $0x8,%esp
  8014e2:	50                   	push   %eax
  8014e3:	68 40 40 80 00       	push   $0x804040
  8014e8:	e8 ba 0b 00 00       	call   8020a7 <find_block>
  8014ed:	83 c4 10             	add    $0x10,%esp
  8014f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8014f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8014fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801500:	0f 84 9f 00 00 00    	je     8015a5 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801506:	8b 45 08             	mov    0x8(%ebp),%eax
  801509:	83 ec 08             	sub    $0x8,%esp
  80150c:	ff 75 f0             	pushl  -0x10(%ebp)
  80150f:	50                   	push   %eax
  801510:	e8 f7 03 00 00       	call   80190c <sys_free_user_mem>
  801515:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80151c:	75 14                	jne    801532 <free+0x5c>
  80151e:	83 ec 04             	sub    $0x4,%esp
  801521:	68 35 39 80 00       	push   $0x803935
  801526:	6a 6a                	push   $0x6a
  801528:	68 53 39 80 00       	push   $0x803953
  80152d:	e8 3f ed ff ff       	call   800271 <_panic>
  801532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801535:	8b 00                	mov    (%eax),%eax
  801537:	85 c0                	test   %eax,%eax
  801539:	74 10                	je     80154b <free+0x75>
  80153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153e:	8b 00                	mov    (%eax),%eax
  801540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801543:	8b 52 04             	mov    0x4(%edx),%edx
  801546:	89 50 04             	mov    %edx,0x4(%eax)
  801549:	eb 0b                	jmp    801556 <free+0x80>
  80154b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154e:	8b 40 04             	mov    0x4(%eax),%eax
  801551:	a3 44 40 80 00       	mov    %eax,0x804044
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	8b 40 04             	mov    0x4(%eax),%eax
  80155c:	85 c0                	test   %eax,%eax
  80155e:	74 0f                	je     80156f <free+0x99>
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	8b 40 04             	mov    0x4(%eax),%eax
  801566:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801569:	8b 12                	mov    (%edx),%edx
  80156b:	89 10                	mov    %edx,(%eax)
  80156d:	eb 0a                	jmp    801579 <free+0xa3>
  80156f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801572:	8b 00                	mov    (%eax),%eax
  801574:	a3 40 40 80 00       	mov    %eax,0x804040
  801579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80157c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801585:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80158c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801591:	48                   	dec    %eax
  801592:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  801597:	83 ec 0c             	sub    $0xc,%esp
  80159a:	ff 75 f4             	pushl  -0xc(%ebp)
  80159d:	e8 65 13 00 00       	call   802907 <insert_sorted_with_merge_freeList>
  8015a2:	83 c4 10             	add    $0x10,%esp
	}
}
  8015a5:	90                   	nop
  8015a6:	c9                   	leave  
  8015a7:	c3                   	ret    

008015a8 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	83 ec 28             	sub    $0x28,%esp
  8015ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8015b1:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8015b4:	e8 f6 fc ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  8015b9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8015bd:	75 0a                	jne    8015c9 <smalloc+0x21>
  8015bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c4:	e9 af 00 00 00       	jmp    801678 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8015c9:	e8 44 07 00 00       	call   801d12 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ce:	83 f8 01             	cmp    $0x1,%eax
  8015d1:	0f 85 9c 00 00 00    	jne    801673 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8015d7:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e4:	01 d0                	add    %edx,%eax
  8015e6:	48                   	dec    %eax
  8015e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f2:	f7 75 f4             	divl   -0xc(%ebp)
  8015f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f8:	29 d0                	sub    %edx,%eax
  8015fa:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8015fd:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801604:	76 07                	jbe    80160d <smalloc+0x65>
			return NULL;
  801606:	b8 00 00 00 00       	mov    $0x0,%eax
  80160b:	eb 6b                	jmp    801678 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80160d:	83 ec 0c             	sub    $0xc,%esp
  801610:	ff 75 0c             	pushl  0xc(%ebp)
  801613:	e8 e7 0c 00 00       	call   8022ff <alloc_block_FF>
  801618:	83 c4 10             	add    $0x10,%esp
  80161b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80161e:	83 ec 0c             	sub    $0xc,%esp
  801621:	ff 75 ec             	pushl  -0x14(%ebp)
  801624:	e8 d6 0a 00 00       	call   8020ff <insert_sorted_allocList>
  801629:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80162c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801630:	75 07                	jne    801639 <smalloc+0x91>
		{
			return NULL;
  801632:	b8 00 00 00 00       	mov    $0x0,%eax
  801637:	eb 3f                	jmp    801678 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801639:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80163c:	8b 40 08             	mov    0x8(%eax),%eax
  80163f:	89 c2                	mov    %eax,%edx
  801641:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801645:	52                   	push   %edx
  801646:	50                   	push   %eax
  801647:	ff 75 0c             	pushl  0xc(%ebp)
  80164a:	ff 75 08             	pushl  0x8(%ebp)
  80164d:	e8 45 04 00 00       	call   801a97 <sys_createSharedObject>
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801658:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80165c:	74 06                	je     801664 <smalloc+0xbc>
  80165e:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801662:	75 07                	jne    80166b <smalloc+0xc3>
		{
			return NULL;
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
  801669:	eb 0d                	jmp    801678 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  80166b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80166e:	8b 40 08             	mov    0x8(%eax),%eax
  801671:	eb 05                	jmp    801678 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801673:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801680:	e8 2a fc ff ff       	call   8012af <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801685:	83 ec 08             	sub    $0x8,%esp
  801688:	ff 75 0c             	pushl  0xc(%ebp)
  80168b:	ff 75 08             	pushl  0x8(%ebp)
  80168e:	e8 2e 04 00 00       	call   801ac1 <sys_getSizeOfSharedObject>
  801693:	83 c4 10             	add    $0x10,%esp
  801696:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  801699:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  80169d:	75 0a                	jne    8016a9 <sget+0x2f>
	{
		return NULL;
  80169f:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a4:	e9 94 00 00 00       	jmp    80173d <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8016a9:	e8 64 06 00 00       	call   801d12 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	0f 84 82 00 00 00    	je     801738 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8016b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8016bd:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8016c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ca:	01 d0                	add    %edx,%eax
  8016cc:	48                   	dec    %eax
  8016cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8016d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d8:	f7 75 ec             	divl   -0x14(%ebp)
  8016db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016de:	29 d0                	sub    %edx,%eax
  8016e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8016e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e6:	83 ec 0c             	sub    $0xc,%esp
  8016e9:	50                   	push   %eax
  8016ea:	e8 10 0c 00 00       	call   8022ff <alloc_block_FF>
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8016f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016f9:	75 07                	jne    801702 <sget+0x88>
		{
			return NULL;
  8016fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801700:	eb 3b                	jmp    80173d <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801705:	8b 40 08             	mov    0x8(%eax),%eax
  801708:	83 ec 04             	sub    $0x4,%esp
  80170b:	50                   	push   %eax
  80170c:	ff 75 0c             	pushl  0xc(%ebp)
  80170f:	ff 75 08             	pushl  0x8(%ebp)
  801712:	e8 c7 03 00 00       	call   801ade <sys_getSharedObject>
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80171d:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801721:	74 06                	je     801729 <sget+0xaf>
  801723:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801727:	75 07                	jne    801730 <sget+0xb6>
		{
			return NULL;
  801729:	b8 00 00 00 00       	mov    $0x0,%eax
  80172e:	eb 0d                	jmp    80173d <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  801730:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801733:	8b 40 08             	mov    0x8(%eax),%eax
  801736:	eb 05                	jmp    80173d <sget+0xc3>
		}
	}
	else
			return NULL;
  801738:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801745:	e8 65 fb ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80174a:	83 ec 04             	sub    $0x4,%esp
  80174d:	68 60 39 80 00       	push   $0x803960
  801752:	68 e1 00 00 00       	push   $0xe1
  801757:	68 53 39 80 00       	push   $0x803953
  80175c:	e8 10 eb ff ff       	call   800271 <_panic>

00801761 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801761:	55                   	push   %ebp
  801762:	89 e5                	mov    %esp,%ebp
  801764:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801767:	83 ec 04             	sub    $0x4,%esp
  80176a:	68 88 39 80 00       	push   $0x803988
  80176f:	68 f5 00 00 00       	push   $0xf5
  801774:	68 53 39 80 00       	push   $0x803953
  801779:	e8 f3 ea ff ff       	call   800271 <_panic>

0080177e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801784:	83 ec 04             	sub    $0x4,%esp
  801787:	68 ac 39 80 00       	push   $0x8039ac
  80178c:	68 00 01 00 00       	push   $0x100
  801791:	68 53 39 80 00       	push   $0x803953
  801796:	e8 d6 ea ff ff       	call   800271 <_panic>

0080179b <shrink>:

}
void shrink(uint32 newSize)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017a1:	83 ec 04             	sub    $0x4,%esp
  8017a4:	68 ac 39 80 00       	push   $0x8039ac
  8017a9:	68 05 01 00 00       	push   $0x105
  8017ae:	68 53 39 80 00       	push   $0x803953
  8017b3:	e8 b9 ea ff ff       	call   800271 <_panic>

008017b8 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8017be:	83 ec 04             	sub    $0x4,%esp
  8017c1:	68 ac 39 80 00       	push   $0x8039ac
  8017c6:	68 0a 01 00 00       	push   $0x10a
  8017cb:	68 53 39 80 00       	push   $0x803953
  8017d0:	e8 9c ea ff ff       	call   800271 <_panic>

008017d5 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	57                   	push   %edi
  8017d9:	56                   	push   %esi
  8017da:	53                   	push   %ebx
  8017db:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017de:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017ea:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017ed:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017f0:	cd 30                	int    $0x30
  8017f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	5b                   	pop    %ebx
  8017fc:	5e                   	pop    %esi
  8017fd:	5f                   	pop    %edi
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 04             	sub    $0x4,%esp
  801806:	8b 45 10             	mov    0x10(%ebp),%eax
  801809:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80180c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801810:	8b 45 08             	mov    0x8(%ebp),%eax
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	52                   	push   %edx
  801818:	ff 75 0c             	pushl  0xc(%ebp)
  80181b:	50                   	push   %eax
  80181c:	6a 00                	push   $0x0
  80181e:	e8 b2 ff ff ff       	call   8017d5 <syscall>
  801823:	83 c4 18             	add    $0x18,%esp
}
  801826:	90                   	nop
  801827:	c9                   	leave  
  801828:	c3                   	ret    

00801829 <sys_cgetc>:

int
sys_cgetc(void)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 01                	push   $0x1
  801838:	e8 98 ff ff ff       	call   8017d5 <syscall>
  80183d:	83 c4 18             	add    $0x18,%esp
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801845:	8b 55 0c             	mov    0xc(%ebp),%edx
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	52                   	push   %edx
  801852:	50                   	push   %eax
  801853:	6a 05                	push   $0x5
  801855:	e8 7b ff ff ff       	call   8017d5 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	56                   	push   %esi
  801863:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801864:	8b 75 18             	mov    0x18(%ebp),%esi
  801867:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80186a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	56                   	push   %esi
  801874:	53                   	push   %ebx
  801875:	51                   	push   %ecx
  801876:	52                   	push   %edx
  801877:	50                   	push   %eax
  801878:	6a 06                	push   $0x6
  80187a:	e8 56 ff ff ff       	call   8017d5 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801885:	5b                   	pop    %ebx
  801886:	5e                   	pop    %esi
  801887:	5d                   	pop    %ebp
  801888:	c3                   	ret    

00801889 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80188c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188f:	8b 45 08             	mov    0x8(%ebp),%eax
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	52                   	push   %edx
  801899:	50                   	push   %eax
  80189a:	6a 07                	push   $0x7
  80189c:	e8 34 ff ff ff       	call   8017d5 <syscall>
  8018a1:	83 c4 18             	add    $0x18,%esp
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	ff 75 0c             	pushl  0xc(%ebp)
  8018b2:	ff 75 08             	pushl  0x8(%ebp)
  8018b5:	6a 08                	push   $0x8
  8018b7:	e8 19 ff ff ff       	call   8017d5 <syscall>
  8018bc:	83 c4 18             	add    $0x18,%esp
}
  8018bf:	c9                   	leave  
  8018c0:	c3                   	ret    

008018c1 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 09                	push   $0x9
  8018d0:	e8 00 ff ff ff       	call   8017d5 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 0a                	push   $0xa
  8018e9:	e8 e7 fe ff ff       	call   8017d5 <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	c9                   	leave  
  8018f2:	c3                   	ret    

008018f3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018f3:	55                   	push   %ebp
  8018f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 0b                	push   $0xb
  801902:	e8 ce fe ff ff       	call   8017d5 <syscall>
  801907:	83 c4 18             	add    $0x18,%esp
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	ff 75 0c             	pushl  0xc(%ebp)
  801918:	ff 75 08             	pushl  0x8(%ebp)
  80191b:	6a 0f                	push   $0xf
  80191d:	e8 b3 fe ff ff       	call   8017d5 <syscall>
  801922:	83 c4 18             	add    $0x18,%esp
	return;
  801925:	90                   	nop
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	ff 75 08             	pushl  0x8(%ebp)
  801937:	6a 10                	push   $0x10
  801939:	e8 97 fe ff ff       	call   8017d5 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
	return ;
  801941:	90                   	nop
}
  801942:	c9                   	leave  
  801943:	c3                   	ret    

00801944 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 10             	pushl  0x10(%ebp)
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	ff 75 08             	pushl  0x8(%ebp)
  801954:	6a 11                	push   $0x11
  801956:	e8 7a fe ff ff       	call   8017d5 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
	return ;
  80195e:	90                   	nop
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 0c                	push   $0xc
  801970:	e8 60 fe ff ff       	call   8017d5 <syscall>
  801975:	83 c4 18             	add    $0x18,%esp
}
  801978:	c9                   	leave  
  801979:	c3                   	ret    

0080197a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80197a:	55                   	push   %ebp
  80197b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	ff 75 08             	pushl  0x8(%ebp)
  801988:	6a 0d                	push   $0xd
  80198a:	e8 46 fe ff ff       	call   8017d5 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 0e                	push   $0xe
  8019a3:	e8 2d fe ff ff       	call   8017d5 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	90                   	nop
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 13                	push   $0x13
  8019bd:	e8 13 fe ff ff       	call   8017d5 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	90                   	nop
  8019c6:	c9                   	leave  
  8019c7:	c3                   	ret    

008019c8 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8019c8:	55                   	push   %ebp
  8019c9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 14                	push   $0x14
  8019d7:	e8 f9 fd ff ff       	call   8017d5 <syscall>
  8019dc:	83 c4 18             	add    $0x18,%esp
}
  8019df:	90                   	nop
  8019e0:	c9                   	leave  
  8019e1:	c3                   	ret    

008019e2 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	83 ec 04             	sub    $0x4,%esp
  8019e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019eb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019ee:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	50                   	push   %eax
  8019fb:	6a 15                	push   $0x15
  8019fd:	e8 d3 fd ff ff       	call   8017d5 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
}
  801a05:	90                   	nop
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 16                	push   $0x16
  801a17:	e8 b9 fd ff ff       	call   8017d5 <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	90                   	nop
  801a20:	c9                   	leave  
  801a21:	c3                   	ret    

00801a22 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801a25:	8b 45 08             	mov    0x8(%ebp),%eax
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	50                   	push   %eax
  801a32:	6a 17                	push   $0x17
  801a34:	e8 9c fd ff ff       	call   8017d5 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a41:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a44:	8b 45 08             	mov    0x8(%ebp),%eax
  801a47:	6a 00                	push   $0x0
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	52                   	push   %edx
  801a4e:	50                   	push   %eax
  801a4f:	6a 1a                	push   $0x1a
  801a51:	e8 7f fd ff ff       	call   8017d5 <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a61:	8b 45 08             	mov    0x8(%ebp),%eax
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	52                   	push   %edx
  801a6b:	50                   	push   %eax
  801a6c:	6a 18                	push   $0x18
  801a6e:	e8 62 fd ff ff       	call   8017d5 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	90                   	nop
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a7c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	52                   	push   %edx
  801a89:	50                   	push   %eax
  801a8a:	6a 19                	push   $0x19
  801a8c:	e8 44 fd ff ff       	call   8017d5 <syscall>
  801a91:	83 c4 18             	add    $0x18,%esp
}
  801a94:	90                   	nop
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	83 ec 04             	sub    $0x4,%esp
  801a9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801aa0:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801aa3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801aa6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  801aad:	6a 00                	push   $0x0
  801aaf:	51                   	push   %ecx
  801ab0:	52                   	push   %edx
  801ab1:	ff 75 0c             	pushl  0xc(%ebp)
  801ab4:	50                   	push   %eax
  801ab5:	6a 1b                	push   $0x1b
  801ab7:	e8 19 fd ff ff       	call   8017d5 <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	52                   	push   %edx
  801ad1:	50                   	push   %eax
  801ad2:	6a 1c                	push   $0x1c
  801ad4:	e8 fc fc ff ff       	call   8017d5 <syscall>
  801ad9:	83 c4 18             	add    $0x18,%esp
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ae1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	51                   	push   %ecx
  801aef:	52                   	push   %edx
  801af0:	50                   	push   %eax
  801af1:	6a 1d                	push   $0x1d
  801af3:	e8 dd fc ff ff       	call   8017d5 <syscall>
  801af8:	83 c4 18             	add    $0x18,%esp
}
  801afb:	c9                   	leave  
  801afc:	c3                   	ret    

00801afd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b03:	8b 45 08             	mov    0x8(%ebp),%eax
  801b06:	6a 00                	push   $0x0
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	52                   	push   %edx
  801b0d:	50                   	push   %eax
  801b0e:	6a 1e                	push   $0x1e
  801b10:	e8 c0 fc ff ff       	call   8017d5 <syscall>
  801b15:	83 c4 18             	add    $0x18,%esp
}
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 1f                	push   $0x1f
  801b29:	e8 a7 fc ff ff       	call   8017d5 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	c9                   	leave  
  801b32:	c3                   	ret    

00801b33 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b33:	55                   	push   %ebp
  801b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	6a 00                	push   $0x0
  801b3b:	ff 75 14             	pushl  0x14(%ebp)
  801b3e:	ff 75 10             	pushl  0x10(%ebp)
  801b41:	ff 75 0c             	pushl  0xc(%ebp)
  801b44:	50                   	push   %eax
  801b45:	6a 20                	push   $0x20
  801b47:	e8 89 fc ff ff       	call   8017d5 <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	50                   	push   %eax
  801b60:	6a 21                	push   $0x21
  801b62:	e8 6e fc ff ff       	call   8017d5 <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	90                   	nop
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	50                   	push   %eax
  801b7c:	6a 22                	push   $0x22
  801b7e:	e8 52 fc ff ff       	call   8017d5 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 02                	push   $0x2
  801b97:	e8 39 fc ff ff       	call   8017d5 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ba4:	6a 00                	push   $0x0
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 03                	push   $0x3
  801bb0:	e8 20 fc ff ff       	call   8017d5 <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    

00801bba <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801bbd:	6a 00                	push   $0x0
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 04                	push   $0x4
  801bc9:	e8 07 fc ff ff       	call   8017d5 <syscall>
  801bce:	83 c4 18             	add    $0x18,%esp
}
  801bd1:	c9                   	leave  
  801bd2:	c3                   	ret    

00801bd3 <sys_exit_env>:


void sys_exit_env(void)
{
  801bd3:	55                   	push   %ebp
  801bd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bd6:	6a 00                	push   $0x0
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 23                	push   $0x23
  801be2:	e8 ee fb ff ff       	call   8017d5 <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	90                   	nop
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bf3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bf6:	8d 50 04             	lea    0x4(%eax),%edx
  801bf9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	52                   	push   %edx
  801c03:	50                   	push   %eax
  801c04:	6a 24                	push   $0x24
  801c06:	e8 ca fb ff ff       	call   8017d5 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
	return result;
  801c0e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c11:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801c17:	89 01                	mov    %eax,(%ecx)
  801c19:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	c9                   	leave  
  801c20:	c2 04 00             	ret    $0x4

00801c23 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	ff 75 10             	pushl  0x10(%ebp)
  801c2d:	ff 75 0c             	pushl  0xc(%ebp)
  801c30:	ff 75 08             	pushl  0x8(%ebp)
  801c33:	6a 12                	push   $0x12
  801c35:	e8 9b fb ff ff       	call   8017d5 <syscall>
  801c3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c3d:	90                   	nop
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 25                	push   $0x25
  801c4f:	e8 81 fb ff ff       	call   8017d5 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c65:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	50                   	push   %eax
  801c72:	6a 26                	push   $0x26
  801c74:	e8 5c fb ff ff       	call   8017d5 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
	return ;
  801c7c:	90                   	nop
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <rsttst>:
void rsttst()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 28                	push   $0x28
  801c8e:	e8 42 fb ff ff       	call   8017d5 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
	return ;
  801c96:	90                   	nop
}
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
  801c9c:	83 ec 04             	sub    $0x4,%esp
  801c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801ca5:	8b 55 18             	mov    0x18(%ebp),%edx
  801ca8:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cac:	52                   	push   %edx
  801cad:	50                   	push   %eax
  801cae:	ff 75 10             	pushl  0x10(%ebp)
  801cb1:	ff 75 0c             	pushl  0xc(%ebp)
  801cb4:	ff 75 08             	pushl  0x8(%ebp)
  801cb7:	6a 27                	push   $0x27
  801cb9:	e8 17 fb ff ff       	call   8017d5 <syscall>
  801cbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc1:	90                   	nop
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <chktst>:
void chktst(uint32 n)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	ff 75 08             	pushl  0x8(%ebp)
  801cd2:	6a 29                	push   $0x29
  801cd4:	e8 fc fa ff ff       	call   8017d5 <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cdc:	90                   	nop
}
  801cdd:	c9                   	leave  
  801cde:	c3                   	ret    

00801cdf <inctst>:

void inctst()
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 2a                	push   $0x2a
  801cee:	e8 e2 fa ff ff       	call   8017d5 <syscall>
  801cf3:	83 c4 18             	add    $0x18,%esp
	return ;
  801cf6:	90                   	nop
}
  801cf7:	c9                   	leave  
  801cf8:	c3                   	ret    

00801cf9 <gettst>:
uint32 gettst()
{
  801cf9:	55                   	push   %ebp
  801cfa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 2b                	push   $0x2b
  801d08:	e8 c8 fa ff ff       	call   8017d5 <syscall>
  801d0d:	83 c4 18             	add    $0x18,%esp
}
  801d10:	c9                   	leave  
  801d11:	c3                   	ret    

00801d12 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	6a 00                	push   $0x0
  801d22:	6a 2c                	push   $0x2c
  801d24:	e8 ac fa ff ff       	call   8017d5 <syscall>
  801d29:	83 c4 18             	add    $0x18,%esp
  801d2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d2f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d33:	75 07                	jne    801d3c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d35:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3a:	eb 05                	jmp    801d41 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 2c                	push   $0x2c
  801d55:	e8 7b fa ff ff       	call   8017d5 <syscall>
  801d5a:	83 c4 18             	add    $0x18,%esp
  801d5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d60:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d64:	75 07                	jne    801d6d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d66:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6b:	eb 05                	jmp    801d72 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d72:	c9                   	leave  
  801d73:	c3                   	ret    

00801d74 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 2c                	push   $0x2c
  801d86:	e8 4a fa ff ff       	call   8017d5 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
  801d8e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d91:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d95:	75 07                	jne    801d9e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d97:	b8 01 00 00 00       	mov    $0x1,%eax
  801d9c:	eb 05                	jmp    801da3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d9e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 2c                	push   $0x2c
  801db7:	e8 19 fa ff ff       	call   8017d5 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
  801dbf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801dc2:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801dc6:	75 07                	jne    801dcf <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801dc8:	b8 01 00 00 00       	mov    $0x1,%eax
  801dcd:	eb 05                	jmp    801dd4 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801dcf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	ff 75 08             	pushl  0x8(%ebp)
  801de4:	6a 2d                	push   $0x2d
  801de6:	e8 ea f9 ff ff       	call   8017d5 <syscall>
  801deb:	83 c4 18             	add    $0x18,%esp
	return ;
  801dee:	90                   	nop
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801df5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801df8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801e01:	6a 00                	push   $0x0
  801e03:	53                   	push   %ebx
  801e04:	51                   	push   %ecx
  801e05:	52                   	push   %edx
  801e06:	50                   	push   %eax
  801e07:	6a 2e                	push   $0x2e
  801e09:	e8 c7 f9 ff ff       	call   8017d5 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
}
  801e11:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e14:	c9                   	leave  
  801e15:	c3                   	ret    

00801e16 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801e16:	55                   	push   %ebp
  801e17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801e19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	52                   	push   %edx
  801e26:	50                   	push   %eax
  801e27:	6a 2f                	push   $0x2f
  801e29:	e8 a7 f9 ff ff       	call   8017d5 <syscall>
  801e2e:	83 c4 18             	add    $0x18,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e39:	83 ec 0c             	sub    $0xc,%esp
  801e3c:	68 bc 39 80 00       	push   $0x8039bc
  801e41:	e8 df e6 ff ff       	call   800525 <cprintf>
  801e46:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e49:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e50:	83 ec 0c             	sub    $0xc,%esp
  801e53:	68 e8 39 80 00       	push   $0x8039e8
  801e58:	e8 c8 e6 ff ff       	call   800525 <cprintf>
  801e5d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e60:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e64:	a1 38 41 80 00       	mov    0x804138,%eax
  801e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e6c:	eb 56                	jmp    801ec4 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e72:	74 1c                	je     801e90 <print_mem_block_lists+0x5d>
  801e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e77:	8b 50 08             	mov    0x8(%eax),%edx
  801e7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e7d:	8b 48 08             	mov    0x8(%eax),%ecx
  801e80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e83:	8b 40 0c             	mov    0xc(%eax),%eax
  801e86:	01 c8                	add    %ecx,%eax
  801e88:	39 c2                	cmp    %eax,%edx
  801e8a:	73 04                	jae    801e90 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e8c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e93:	8b 50 08             	mov    0x8(%eax),%edx
  801e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e99:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9c:	01 c2                	add    %eax,%edx
  801e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea1:	8b 40 08             	mov    0x8(%eax),%eax
  801ea4:	83 ec 04             	sub    $0x4,%esp
  801ea7:	52                   	push   %edx
  801ea8:	50                   	push   %eax
  801ea9:	68 fd 39 80 00       	push   $0x8039fd
  801eae:	e8 72 e6 ff ff       	call   800525 <cprintf>
  801eb3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ebc:	a1 40 41 80 00       	mov    0x804140,%eax
  801ec1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ec4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ec8:	74 07                	je     801ed1 <print_mem_block_lists+0x9e>
  801eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecd:	8b 00                	mov    (%eax),%eax
  801ecf:	eb 05                	jmp    801ed6 <print_mem_block_lists+0xa3>
  801ed1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed6:	a3 40 41 80 00       	mov    %eax,0x804140
  801edb:	a1 40 41 80 00       	mov    0x804140,%eax
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	75 8a                	jne    801e6e <print_mem_block_lists+0x3b>
  801ee4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ee8:	75 84                	jne    801e6e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801eea:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801eee:	75 10                	jne    801f00 <print_mem_block_lists+0xcd>
  801ef0:	83 ec 0c             	sub    $0xc,%esp
  801ef3:	68 0c 3a 80 00       	push   $0x803a0c
  801ef8:	e8 28 e6 ff ff       	call   800525 <cprintf>
  801efd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f00:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f07:	83 ec 0c             	sub    $0xc,%esp
  801f0a:	68 30 3a 80 00       	push   $0x803a30
  801f0f:	e8 11 e6 ff ff       	call   800525 <cprintf>
  801f14:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801f17:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f1b:	a1 40 40 80 00       	mov    0x804040,%eax
  801f20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f23:	eb 56                	jmp    801f7b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f29:	74 1c                	je     801f47 <print_mem_block_lists+0x114>
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	8b 50 08             	mov    0x8(%eax),%edx
  801f31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f34:	8b 48 08             	mov    0x8(%eax),%ecx
  801f37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3d:	01 c8                	add    %ecx,%eax
  801f3f:	39 c2                	cmp    %eax,%edx
  801f41:	73 04                	jae    801f47 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f43:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4a:	8b 50 08             	mov    0x8(%eax),%edx
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 40 0c             	mov    0xc(%eax),%eax
  801f53:	01 c2                	add    %eax,%edx
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 40 08             	mov    0x8(%eax),%eax
  801f5b:	83 ec 04             	sub    $0x4,%esp
  801f5e:	52                   	push   %edx
  801f5f:	50                   	push   %eax
  801f60:	68 fd 39 80 00       	push   $0x8039fd
  801f65:	e8 bb e5 ff ff       	call   800525 <cprintf>
  801f6a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f73:	a1 48 40 80 00       	mov    0x804048,%eax
  801f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7f:	74 07                	je     801f88 <print_mem_block_lists+0x155>
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	8b 00                	mov    (%eax),%eax
  801f86:	eb 05                	jmp    801f8d <print_mem_block_lists+0x15a>
  801f88:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8d:	a3 48 40 80 00       	mov    %eax,0x804048
  801f92:	a1 48 40 80 00       	mov    0x804048,%eax
  801f97:	85 c0                	test   %eax,%eax
  801f99:	75 8a                	jne    801f25 <print_mem_block_lists+0xf2>
  801f9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9f:	75 84                	jne    801f25 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801fa1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa5:	75 10                	jne    801fb7 <print_mem_block_lists+0x184>
  801fa7:	83 ec 0c             	sub    $0xc,%esp
  801faa:	68 48 3a 80 00       	push   $0x803a48
  801faf:	e8 71 e5 ff ff       	call   800525 <cprintf>
  801fb4:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801fb7:	83 ec 0c             	sub    $0xc,%esp
  801fba:	68 bc 39 80 00       	push   $0x8039bc
  801fbf:	e8 61 e5 ff ff       	call   800525 <cprintf>
  801fc4:	83 c4 10             	add    $0x10,%esp

}
  801fc7:	90                   	nop
  801fc8:	c9                   	leave  
  801fc9:	c3                   	ret    

00801fca <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fca:	55                   	push   %ebp
  801fcb:	89 e5                	mov    %esp,%ebp
  801fcd:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fd0:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fd7:	00 00 00 
  801fda:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fe1:	00 00 00 
  801fe4:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801feb:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  801fee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801ff5:	e9 9e 00 00 00       	jmp    802098 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  801ffa:	a1 50 40 80 00       	mov    0x804050,%eax
  801fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802002:	c1 e2 04             	shl    $0x4,%edx
  802005:	01 d0                	add    %edx,%eax
  802007:	85 c0                	test   %eax,%eax
  802009:	75 14                	jne    80201f <initialize_MemBlocksList+0x55>
  80200b:	83 ec 04             	sub    $0x4,%esp
  80200e:	68 70 3a 80 00       	push   $0x803a70
  802013:	6a 42                	push   $0x42
  802015:	68 93 3a 80 00       	push   $0x803a93
  80201a:	e8 52 e2 ff ff       	call   800271 <_panic>
  80201f:	a1 50 40 80 00       	mov    0x804050,%eax
  802024:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802027:	c1 e2 04             	shl    $0x4,%edx
  80202a:	01 d0                	add    %edx,%eax
  80202c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802032:	89 10                	mov    %edx,(%eax)
  802034:	8b 00                	mov    (%eax),%eax
  802036:	85 c0                	test   %eax,%eax
  802038:	74 18                	je     802052 <initialize_MemBlocksList+0x88>
  80203a:	a1 48 41 80 00       	mov    0x804148,%eax
  80203f:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802045:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802048:	c1 e1 04             	shl    $0x4,%ecx
  80204b:	01 ca                	add    %ecx,%edx
  80204d:	89 50 04             	mov    %edx,0x4(%eax)
  802050:	eb 12                	jmp    802064 <initialize_MemBlocksList+0x9a>
  802052:	a1 50 40 80 00       	mov    0x804050,%eax
  802057:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80205a:	c1 e2 04             	shl    $0x4,%edx
  80205d:	01 d0                	add    %edx,%eax
  80205f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802064:	a1 50 40 80 00       	mov    0x804050,%eax
  802069:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80206c:	c1 e2 04             	shl    $0x4,%edx
  80206f:	01 d0                	add    %edx,%eax
  802071:	a3 48 41 80 00       	mov    %eax,0x804148
  802076:	a1 50 40 80 00       	mov    0x804050,%eax
  80207b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80207e:	c1 e2 04             	shl    $0x4,%edx
  802081:	01 d0                	add    %edx,%eax
  802083:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80208a:	a1 54 41 80 00       	mov    0x804154,%eax
  80208f:	40                   	inc    %eax
  802090:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802095:	ff 45 f4             	incl   -0xc(%ebp)
  802098:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80209e:	0f 82 56 ff ff ff    	jb     801ffa <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8020a4:	90                   	nop
  8020a5:	c9                   	leave  
  8020a6:	c3                   	ret    

008020a7 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8020a7:	55                   	push   %ebp
  8020a8:	89 e5                	mov    %esp,%ebp
  8020aa:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b0:	8b 00                	mov    (%eax),%eax
  8020b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020b5:	eb 19                	jmp    8020d0 <find_block+0x29>
	{
		if(blk->sva==va)
  8020b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020ba:	8b 40 08             	mov    0x8(%eax),%eax
  8020bd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8020c0:	75 05                	jne    8020c7 <find_block+0x20>
			return (blk);
  8020c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020c5:	eb 36                	jmp    8020fd <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8020c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ca:	8b 40 08             	mov    0x8(%eax),%eax
  8020cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8020d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020d4:	74 07                	je     8020dd <find_block+0x36>
  8020d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020d9:	8b 00                	mov    (%eax),%eax
  8020db:	eb 05                	jmp    8020e2 <find_block+0x3b>
  8020dd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8020e5:	89 42 08             	mov    %eax,0x8(%edx)
  8020e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020eb:	8b 40 08             	mov    0x8(%eax),%eax
  8020ee:	85 c0                	test   %eax,%eax
  8020f0:	75 c5                	jne    8020b7 <find_block+0x10>
  8020f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020f6:	75 bf                	jne    8020b7 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8020f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020fd:	c9                   	leave  
  8020fe:	c3                   	ret    

008020ff <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802105:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80210a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80210d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802114:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802117:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80211a:	75 65                	jne    802181 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80211c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802120:	75 14                	jne    802136 <insert_sorted_allocList+0x37>
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	68 70 3a 80 00       	push   $0x803a70
  80212a:	6a 5c                	push   $0x5c
  80212c:	68 93 3a 80 00       	push   $0x803a93
  802131:	e8 3b e1 ff ff       	call   800271 <_panic>
  802136:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	89 10                	mov    %edx,(%eax)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	85 c0                	test   %eax,%eax
  802148:	74 0d                	je     802157 <insert_sorted_allocList+0x58>
  80214a:	a1 40 40 80 00       	mov    0x804040,%eax
  80214f:	8b 55 08             	mov    0x8(%ebp),%edx
  802152:	89 50 04             	mov    %edx,0x4(%eax)
  802155:	eb 08                	jmp    80215f <insert_sorted_allocList+0x60>
  802157:	8b 45 08             	mov    0x8(%ebp),%eax
  80215a:	a3 44 40 80 00       	mov    %eax,0x804044
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	a3 40 40 80 00       	mov    %eax,0x804040
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802171:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802176:	40                   	inc    %eax
  802177:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80217c:	e9 7b 01 00 00       	jmp    8022fc <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802181:	a1 44 40 80 00       	mov    0x804044,%eax
  802186:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  802189:	a1 40 40 80 00       	mov    0x804040,%eax
  80218e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	8b 50 08             	mov    0x8(%eax),%edx
  802197:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80219a:	8b 40 08             	mov    0x8(%eax),%eax
  80219d:	39 c2                	cmp    %eax,%edx
  80219f:	76 65                	jbe    802206 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8021a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a5:	75 14                	jne    8021bb <insert_sorted_allocList+0xbc>
  8021a7:	83 ec 04             	sub    $0x4,%esp
  8021aa:	68 ac 3a 80 00       	push   $0x803aac
  8021af:	6a 64                	push   $0x64
  8021b1:	68 93 3a 80 00       	push   $0x803a93
  8021b6:	e8 b6 e0 ff ff       	call   800271 <_panic>
  8021bb:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	89 50 04             	mov    %edx,0x4(%eax)
  8021c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ca:	8b 40 04             	mov    0x4(%eax),%eax
  8021cd:	85 c0                	test   %eax,%eax
  8021cf:	74 0c                	je     8021dd <insert_sorted_allocList+0xde>
  8021d1:	a1 44 40 80 00       	mov    0x804044,%eax
  8021d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d9:	89 10                	mov    %edx,(%eax)
  8021db:	eb 08                	jmp    8021e5 <insert_sorted_allocList+0xe6>
  8021dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e0:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	a3 44 40 80 00       	mov    %eax,0x804044
  8021ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8021f6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021fb:	40                   	inc    %eax
  8021fc:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802201:	e9 f6 00 00 00       	jmp    8022fc <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	8b 50 08             	mov    0x8(%eax),%edx
  80220c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80220f:	8b 40 08             	mov    0x8(%eax),%eax
  802212:	39 c2                	cmp    %eax,%edx
  802214:	73 65                	jae    80227b <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221a:	75 14                	jne    802230 <insert_sorted_allocList+0x131>
  80221c:	83 ec 04             	sub    $0x4,%esp
  80221f:	68 70 3a 80 00       	push   $0x803a70
  802224:	6a 68                	push   $0x68
  802226:	68 93 3a 80 00       	push   $0x803a93
  80222b:	e8 41 e0 ff ff       	call   800271 <_panic>
  802230:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802236:	8b 45 08             	mov    0x8(%ebp),%eax
  802239:	89 10                	mov    %edx,(%eax)
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	8b 00                	mov    (%eax),%eax
  802240:	85 c0                	test   %eax,%eax
  802242:	74 0d                	je     802251 <insert_sorted_allocList+0x152>
  802244:	a1 40 40 80 00       	mov    0x804040,%eax
  802249:	8b 55 08             	mov    0x8(%ebp),%edx
  80224c:	89 50 04             	mov    %edx,0x4(%eax)
  80224f:	eb 08                	jmp    802259 <insert_sorted_allocList+0x15a>
  802251:	8b 45 08             	mov    0x8(%ebp),%eax
  802254:	a3 44 40 80 00       	mov    %eax,0x804044
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	a3 40 40 80 00       	mov    %eax,0x804040
  802261:	8b 45 08             	mov    0x8(%ebp),%eax
  802264:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80226b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802270:	40                   	inc    %eax
  802271:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802276:	e9 81 00 00 00       	jmp    8022fc <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80227b:	a1 40 40 80 00       	mov    0x804040,%eax
  802280:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802283:	eb 51                	jmp    8022d6 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	8b 50 08             	mov    0x8(%eax),%edx
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	39 c2                	cmp    %eax,%edx
  802293:	73 39                	jae    8022ce <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802295:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802298:	8b 40 04             	mov    0x4(%eax),%eax
  80229b:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  80229e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a4:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022ac:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b5:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8022bd:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8022c0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022c5:	40                   	inc    %eax
  8022c6:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8022cb:	90                   	nop
				}
			}
		 }

	}
}
  8022cc:	eb 2e                	jmp    8022fc <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8022ce:	a1 48 40 80 00       	mov    0x804048,%eax
  8022d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8022d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022da:	74 07                	je     8022e3 <insert_sorted_allocList+0x1e4>
  8022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022df:	8b 00                	mov    (%eax),%eax
  8022e1:	eb 05                	jmp    8022e8 <insert_sorted_allocList+0x1e9>
  8022e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e8:	a3 48 40 80 00       	mov    %eax,0x804048
  8022ed:	a1 48 40 80 00       	mov    0x804048,%eax
  8022f2:	85 c0                	test   %eax,%eax
  8022f4:	75 8f                	jne    802285 <insert_sorted_allocList+0x186>
  8022f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fa:	75 89                	jne    802285 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8022fc:	90                   	nop
  8022fd:	c9                   	leave  
  8022fe:	c3                   	ret    

008022ff <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022ff:	55                   	push   %ebp
  802300:	89 e5                	mov    %esp,%ebp
  802302:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802305:	a1 38 41 80 00       	mov    0x804138,%eax
  80230a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80230d:	e9 76 01 00 00       	jmp    802488 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 40 0c             	mov    0xc(%eax),%eax
  802318:	3b 45 08             	cmp    0x8(%ebp),%eax
  80231b:	0f 85 8a 00 00 00    	jne    8023ab <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802321:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802325:	75 17                	jne    80233e <alloc_block_FF+0x3f>
  802327:	83 ec 04             	sub    $0x4,%esp
  80232a:	68 cf 3a 80 00       	push   $0x803acf
  80232f:	68 8a 00 00 00       	push   $0x8a
  802334:	68 93 3a 80 00       	push   $0x803a93
  802339:	e8 33 df ff ff       	call   800271 <_panic>
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	85 c0                	test   %eax,%eax
  802345:	74 10                	je     802357 <alloc_block_FF+0x58>
  802347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234a:	8b 00                	mov    (%eax),%eax
  80234c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80234f:	8b 52 04             	mov    0x4(%edx),%edx
  802352:	89 50 04             	mov    %edx,0x4(%eax)
  802355:	eb 0b                	jmp    802362 <alloc_block_FF+0x63>
  802357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235a:	8b 40 04             	mov    0x4(%eax),%eax
  80235d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802365:	8b 40 04             	mov    0x4(%eax),%eax
  802368:	85 c0                	test   %eax,%eax
  80236a:	74 0f                	je     80237b <alloc_block_FF+0x7c>
  80236c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236f:	8b 40 04             	mov    0x4(%eax),%eax
  802372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802375:	8b 12                	mov    (%edx),%edx
  802377:	89 10                	mov    %edx,(%eax)
  802379:	eb 0a                	jmp    802385 <alloc_block_FF+0x86>
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 00                	mov    (%eax),%eax
  802380:	a3 38 41 80 00       	mov    %eax,0x804138
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802391:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802398:	a1 44 41 80 00       	mov    0x804144,%eax
  80239d:	48                   	dec    %eax
  80239e:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8023a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a6:	e9 10 01 00 00       	jmp    8024bb <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8023b1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023b4:	0f 86 c6 00 00 00    	jbe    802480 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8023ba:	a1 48 41 80 00       	mov    0x804148,%eax
  8023bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8023c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c6:	75 17                	jne    8023df <alloc_block_FF+0xe0>
  8023c8:	83 ec 04             	sub    $0x4,%esp
  8023cb:	68 cf 3a 80 00       	push   $0x803acf
  8023d0:	68 90 00 00 00       	push   $0x90
  8023d5:	68 93 3a 80 00       	push   $0x803a93
  8023da:	e8 92 de ff ff       	call   800271 <_panic>
  8023df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e2:	8b 00                	mov    (%eax),%eax
  8023e4:	85 c0                	test   %eax,%eax
  8023e6:	74 10                	je     8023f8 <alloc_block_FF+0xf9>
  8023e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023eb:	8b 00                	mov    (%eax),%eax
  8023ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8023f0:	8b 52 04             	mov    0x4(%edx),%edx
  8023f3:	89 50 04             	mov    %edx,0x4(%eax)
  8023f6:	eb 0b                	jmp    802403 <alloc_block_FF+0x104>
  8023f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023fb:	8b 40 04             	mov    0x4(%eax),%eax
  8023fe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802403:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802406:	8b 40 04             	mov    0x4(%eax),%eax
  802409:	85 c0                	test   %eax,%eax
  80240b:	74 0f                	je     80241c <alloc_block_FF+0x11d>
  80240d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802416:	8b 12                	mov    (%edx),%edx
  802418:	89 10                	mov    %edx,(%eax)
  80241a:	eb 0a                	jmp    802426 <alloc_block_FF+0x127>
  80241c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80241f:	8b 00                	mov    (%eax),%eax
  802421:	a3 48 41 80 00       	mov    %eax,0x804148
  802426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802429:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802432:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802439:	a1 54 41 80 00       	mov    0x804154,%eax
  80243e:	48                   	dec    %eax
  80243f:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802444:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802447:	8b 55 08             	mov    0x8(%ebp),%edx
  80244a:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80244d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802450:	8b 50 08             	mov    0x8(%eax),%edx
  802453:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802456:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245c:	8b 50 08             	mov    0x8(%eax),%edx
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	01 c2                	add    %eax,%edx
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 40 0c             	mov    0xc(%eax),%eax
  802470:	2b 45 08             	sub    0x8(%ebp),%eax
  802473:	89 c2                	mov    %eax,%edx
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  80247b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80247e:	eb 3b                	jmp    8024bb <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802480:	a1 40 41 80 00       	mov    0x804140,%eax
  802485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802488:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248c:	74 07                	je     802495 <alloc_block_FF+0x196>
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 00                	mov    (%eax),%eax
  802493:	eb 05                	jmp    80249a <alloc_block_FF+0x19b>
  802495:	b8 00 00 00 00       	mov    $0x0,%eax
  80249a:	a3 40 41 80 00       	mov    %eax,0x804140
  80249f:	a1 40 41 80 00       	mov    0x804140,%eax
  8024a4:	85 c0                	test   %eax,%eax
  8024a6:	0f 85 66 fe ff ff    	jne    802312 <alloc_block_FF+0x13>
  8024ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b0:	0f 85 5c fe ff ff    	jne    802312 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8024b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bb:	c9                   	leave  
  8024bc:	c3                   	ret    

008024bd <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024bd:	55                   	push   %ebp
  8024be:	89 e5                	mov    %esp,%ebp
  8024c0:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8024c3:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8024ca:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8024d1:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8024d8:	a1 38 41 80 00       	mov    0x804138,%eax
  8024dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e0:	e9 cf 00 00 00       	jmp    8025b4 <alloc_block_BF+0xf7>
		{
			c++;
  8024e5:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8024e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024eb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ee:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f1:	0f 85 8a 00 00 00    	jne    802581 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8024f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024fb:	75 17                	jne    802514 <alloc_block_BF+0x57>
  8024fd:	83 ec 04             	sub    $0x4,%esp
  802500:	68 cf 3a 80 00       	push   $0x803acf
  802505:	68 a8 00 00 00       	push   $0xa8
  80250a:	68 93 3a 80 00       	push   $0x803a93
  80250f:	e8 5d dd ff ff       	call   800271 <_panic>
  802514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802517:	8b 00                	mov    (%eax),%eax
  802519:	85 c0                	test   %eax,%eax
  80251b:	74 10                	je     80252d <alloc_block_BF+0x70>
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 00                	mov    (%eax),%eax
  802522:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802525:	8b 52 04             	mov    0x4(%edx),%edx
  802528:	89 50 04             	mov    %edx,0x4(%eax)
  80252b:	eb 0b                	jmp    802538 <alloc_block_BF+0x7b>
  80252d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802530:	8b 40 04             	mov    0x4(%eax),%eax
  802533:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	8b 40 04             	mov    0x4(%eax),%eax
  80253e:	85 c0                	test   %eax,%eax
  802540:	74 0f                	je     802551 <alloc_block_BF+0x94>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 04             	mov    0x4(%eax),%eax
  802548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254b:	8b 12                	mov    (%edx),%edx
  80254d:	89 10                	mov    %edx,(%eax)
  80254f:	eb 0a                	jmp    80255b <alloc_block_BF+0x9e>
  802551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802554:	8b 00                	mov    (%eax),%eax
  802556:	a3 38 41 80 00       	mov    %eax,0x804138
  80255b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80256e:	a1 44 41 80 00       	mov    0x804144,%eax
  802573:	48                   	dec    %eax
  802574:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	e9 85 01 00 00       	jmp    802706 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 40 0c             	mov    0xc(%eax),%eax
  802587:	3b 45 08             	cmp    0x8(%ebp),%eax
  80258a:	76 20                	jbe    8025ac <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 40 0c             	mov    0xc(%eax),%eax
  802592:	2b 45 08             	sub    0x8(%ebp),%eax
  802595:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  802598:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80259b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80259e:	73 0c                	jae    8025ac <alloc_block_BF+0xef>
				{
					ma=tempi;
  8025a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8025a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8025a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025ac:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b8:	74 07                	je     8025c1 <alloc_block_BF+0x104>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	eb 05                	jmp    8025c6 <alloc_block_BF+0x109>
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c6:	a3 40 41 80 00       	mov    %eax,0x804140
  8025cb:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	0f 85 0d ff ff ff    	jne    8024e5 <alloc_block_BF+0x28>
  8025d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dc:	0f 85 03 ff ff ff    	jne    8024e5 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8025e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025e9:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	e9 dd 00 00 00       	jmp    8026d3 <alloc_block_BF+0x216>
		{
			if(x==sol)
  8025f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f9:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8025fc:	0f 85 c6 00 00 00    	jne    8026c8 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802602:	a1 48 41 80 00       	mov    0x804148,%eax
  802607:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80260a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80260e:	75 17                	jne    802627 <alloc_block_BF+0x16a>
  802610:	83 ec 04             	sub    $0x4,%esp
  802613:	68 cf 3a 80 00       	push   $0x803acf
  802618:	68 bb 00 00 00       	push   $0xbb
  80261d:	68 93 3a 80 00       	push   $0x803a93
  802622:	e8 4a dc ff ff       	call   800271 <_panic>
  802627:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80262a:	8b 00                	mov    (%eax),%eax
  80262c:	85 c0                	test   %eax,%eax
  80262e:	74 10                	je     802640 <alloc_block_BF+0x183>
  802630:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802633:	8b 00                	mov    (%eax),%eax
  802635:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802638:	8b 52 04             	mov    0x4(%edx),%edx
  80263b:	89 50 04             	mov    %edx,0x4(%eax)
  80263e:	eb 0b                	jmp    80264b <alloc_block_BF+0x18e>
  802640:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802643:	8b 40 04             	mov    0x4(%eax),%eax
  802646:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80264b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80264e:	8b 40 04             	mov    0x4(%eax),%eax
  802651:	85 c0                	test   %eax,%eax
  802653:	74 0f                	je     802664 <alloc_block_BF+0x1a7>
  802655:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802658:	8b 40 04             	mov    0x4(%eax),%eax
  80265b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80265e:	8b 12                	mov    (%edx),%edx
  802660:	89 10                	mov    %edx,(%eax)
  802662:	eb 0a                	jmp    80266e <alloc_block_BF+0x1b1>
  802664:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802667:	8b 00                	mov    (%eax),%eax
  802669:	a3 48 41 80 00       	mov    %eax,0x804148
  80266e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802671:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802677:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80267a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802681:	a1 54 41 80 00       	mov    0x804154,%eax
  802686:	48                   	dec    %eax
  802687:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  80268c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80268f:	8b 55 08             	mov    0x8(%ebp),%edx
  802692:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802695:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802698:	8b 50 08             	mov    0x8(%eax),%edx
  80269b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80269e:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8026a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a4:	8b 50 08             	mov    0x8(%eax),%edx
  8026a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026aa:	01 c2                	add    %eax,%edx
  8026ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026af:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b8:	2b 45 08             	sub    0x8(%ebp),%eax
  8026bb:	89 c2                	mov    %eax,%edx
  8026bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c0:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8026c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026c6:	eb 3e                	jmp    802706 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8026c8:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026cb:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d7:	74 07                	je     8026e0 <alloc_block_BF+0x223>
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	eb 05                	jmp    8026e5 <alloc_block_BF+0x228>
  8026e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e5:	a3 40 41 80 00       	mov    %eax,0x804140
  8026ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	0f 85 ff fe ff ff    	jne    8025f6 <alloc_block_BF+0x139>
  8026f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fb:	0f 85 f5 fe ff ff    	jne    8025f6 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802701:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80270e:	a1 28 40 80 00       	mov    0x804028,%eax
  802713:	85 c0                	test   %eax,%eax
  802715:	75 14                	jne    80272b <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802717:	a1 38 41 80 00       	mov    0x804138,%eax
  80271c:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802721:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802728:	00 00 00 
	}
	uint32 c=1;
  80272b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802732:	a1 60 41 80 00       	mov    0x804160,%eax
  802737:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  80273a:	e9 b3 01 00 00       	jmp    8028f2 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80273f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802742:	8b 40 0c             	mov    0xc(%eax),%eax
  802745:	3b 45 08             	cmp    0x8(%ebp),%eax
  802748:	0f 85 a9 00 00 00    	jne    8027f7 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80274e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802751:	8b 00                	mov    (%eax),%eax
  802753:	85 c0                	test   %eax,%eax
  802755:	75 0c                	jne    802763 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802757:	a1 38 41 80 00       	mov    0x804138,%eax
  80275c:	a3 60 41 80 00       	mov    %eax,0x804160
  802761:	eb 0a                	jmp    80276d <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802763:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802766:	8b 00                	mov    (%eax),%eax
  802768:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  80276d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802771:	75 17                	jne    80278a <alloc_block_NF+0x82>
  802773:	83 ec 04             	sub    $0x4,%esp
  802776:	68 cf 3a 80 00       	push   $0x803acf
  80277b:	68 e3 00 00 00       	push   $0xe3
  802780:	68 93 3a 80 00       	push   $0x803a93
  802785:	e8 e7 da ff ff       	call   800271 <_panic>
  80278a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	85 c0                	test   %eax,%eax
  802791:	74 10                	je     8027a3 <alloc_block_NF+0x9b>
  802793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802796:	8b 00                	mov    (%eax),%eax
  802798:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80279b:	8b 52 04             	mov    0x4(%edx),%edx
  80279e:	89 50 04             	mov    %edx,0x4(%eax)
  8027a1:	eb 0b                	jmp    8027ae <alloc_block_NF+0xa6>
  8027a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a6:	8b 40 04             	mov    0x4(%eax),%eax
  8027a9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	85 c0                	test   %eax,%eax
  8027b6:	74 0f                	je     8027c7 <alloc_block_NF+0xbf>
  8027b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027bb:	8b 40 04             	mov    0x4(%eax),%eax
  8027be:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027c1:	8b 12                	mov    (%edx),%edx
  8027c3:	89 10                	mov    %edx,(%eax)
  8027c5:	eb 0a                	jmp    8027d1 <alloc_block_NF+0xc9>
  8027c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ca:	8b 00                	mov    (%eax),%eax
  8027cc:	a3 38 41 80 00       	mov    %eax,0x804138
  8027d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027dd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e4:	a1 44 41 80 00       	mov    0x804144,%eax
  8027e9:	48                   	dec    %eax
  8027ea:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  8027ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f2:	e9 0e 01 00 00       	jmp    802905 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8027f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8027fd:	3b 45 08             	cmp    0x8(%ebp),%eax
  802800:	0f 86 ce 00 00 00    	jbe    8028d4 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802806:	a1 48 41 80 00       	mov    0x804148,%eax
  80280b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80280e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802812:	75 17                	jne    80282b <alloc_block_NF+0x123>
  802814:	83 ec 04             	sub    $0x4,%esp
  802817:	68 cf 3a 80 00       	push   $0x803acf
  80281c:	68 e9 00 00 00       	push   $0xe9
  802821:	68 93 3a 80 00       	push   $0x803a93
  802826:	e8 46 da ff ff       	call   800271 <_panic>
  80282b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282e:	8b 00                	mov    (%eax),%eax
  802830:	85 c0                	test   %eax,%eax
  802832:	74 10                	je     802844 <alloc_block_NF+0x13c>
  802834:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802837:	8b 00                	mov    (%eax),%eax
  802839:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80283c:	8b 52 04             	mov    0x4(%edx),%edx
  80283f:	89 50 04             	mov    %edx,0x4(%eax)
  802842:	eb 0b                	jmp    80284f <alloc_block_NF+0x147>
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	8b 40 04             	mov    0x4(%eax),%eax
  80284a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80284f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802852:	8b 40 04             	mov    0x4(%eax),%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	74 0f                	je     802868 <alloc_block_NF+0x160>
  802859:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285c:	8b 40 04             	mov    0x4(%eax),%eax
  80285f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802862:	8b 12                	mov    (%edx),%edx
  802864:	89 10                	mov    %edx,(%eax)
  802866:	eb 0a                	jmp    802872 <alloc_block_NF+0x16a>
  802868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286b:	8b 00                	mov    (%eax),%eax
  80286d:	a3 48 41 80 00       	mov    %eax,0x804148
  802872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802885:	a1 54 41 80 00       	mov    0x804154,%eax
  80288a:	48                   	dec    %eax
  80288b:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802890:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802893:	8b 55 08             	mov    0x8(%ebp),%edx
  802896:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  802899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289c:	8b 50 08             	mov    0x8(%eax),%edx
  80289f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a2:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8028a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a8:	8b 50 08             	mov    0x8(%eax),%edx
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	01 c2                	add    %eax,%edx
  8028b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b3:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8028bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8028bf:	89 c2                	mov    %eax,%edx
  8028c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c4:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	eb 31                	jmp    802905 <alloc_block_NF+0x1fd>
			 }
		 c++;
  8028d4:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8028d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028da:	8b 00                	mov    (%eax),%eax
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	75 0a                	jne    8028ea <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8028e0:	a1 38 41 80 00       	mov    0x804138,%eax
  8028e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8028e8:	eb 08                	jmp    8028f2 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8028ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ed:	8b 00                	mov    (%eax),%eax
  8028ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8028f2:	a1 44 41 80 00       	mov    0x804144,%eax
  8028f7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8028fa:	0f 85 3f fe ff ff    	jne    80273f <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802905:	c9                   	leave  
  802906:	c3                   	ret    

00802907 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802907:	55                   	push   %ebp
  802908:	89 e5                	mov    %esp,%ebp
  80290a:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  80290d:	a1 44 41 80 00       	mov    0x804144,%eax
  802912:	85 c0                	test   %eax,%eax
  802914:	75 68                	jne    80297e <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802916:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291a:	75 17                	jne    802933 <insert_sorted_with_merge_freeList+0x2c>
  80291c:	83 ec 04             	sub    $0x4,%esp
  80291f:	68 70 3a 80 00       	push   $0x803a70
  802924:	68 0e 01 00 00       	push   $0x10e
  802929:	68 93 3a 80 00       	push   $0x803a93
  80292e:	e8 3e d9 ff ff       	call   800271 <_panic>
  802933:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802939:	8b 45 08             	mov    0x8(%ebp),%eax
  80293c:	89 10                	mov    %edx,(%eax)
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	85 c0                	test   %eax,%eax
  802945:	74 0d                	je     802954 <insert_sorted_with_merge_freeList+0x4d>
  802947:	a1 38 41 80 00       	mov    0x804138,%eax
  80294c:	8b 55 08             	mov    0x8(%ebp),%edx
  80294f:	89 50 04             	mov    %edx,0x4(%eax)
  802952:	eb 08                	jmp    80295c <insert_sorted_with_merge_freeList+0x55>
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	a3 38 41 80 00       	mov    %eax,0x804138
  802964:	8b 45 08             	mov    0x8(%ebp),%eax
  802967:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80296e:	a1 44 41 80 00       	mov    0x804144,%eax
  802973:	40                   	inc    %eax
  802974:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802979:	e9 8c 06 00 00       	jmp    80300a <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  80297e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802983:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802986:	a1 38 41 80 00       	mov    0x804138,%eax
  80298b:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	8b 50 08             	mov    0x8(%eax),%edx
  802994:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802997:	8b 40 08             	mov    0x8(%eax),%eax
  80299a:	39 c2                	cmp    %eax,%edx
  80299c:	0f 86 14 01 00 00    	jbe    802ab6 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  8029a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a5:	8b 50 0c             	mov    0xc(%eax),%edx
  8029a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ab:	8b 40 08             	mov    0x8(%eax),%eax
  8029ae:	01 c2                	add    %eax,%edx
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	8b 40 08             	mov    0x8(%eax),%eax
  8029b6:	39 c2                	cmp    %eax,%edx
  8029b8:	0f 85 90 00 00 00    	jne    802a4e <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  8029be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c1:	8b 50 0c             	mov    0xc(%eax),%edx
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ca:	01 c2                	add    %eax,%edx
  8029cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029cf:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  8029e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ea:	75 17                	jne    802a03 <insert_sorted_with_merge_freeList+0xfc>
  8029ec:	83 ec 04             	sub    $0x4,%esp
  8029ef:	68 70 3a 80 00       	push   $0x803a70
  8029f4:	68 1b 01 00 00       	push   $0x11b
  8029f9:	68 93 3a 80 00       	push   $0x803a93
  8029fe:	e8 6e d8 ff ff       	call   800271 <_panic>
  802a03:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	89 10                	mov    %edx,(%eax)
  802a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a11:	8b 00                	mov    (%eax),%eax
  802a13:	85 c0                	test   %eax,%eax
  802a15:	74 0d                	je     802a24 <insert_sorted_with_merge_freeList+0x11d>
  802a17:	a1 48 41 80 00       	mov    0x804148,%eax
  802a1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1f:	89 50 04             	mov    %edx,0x4(%eax)
  802a22:	eb 08                	jmp    802a2c <insert_sorted_with_merge_freeList+0x125>
  802a24:	8b 45 08             	mov    0x8(%ebp),%eax
  802a27:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2f:	a3 48 41 80 00       	mov    %eax,0x804148
  802a34:	8b 45 08             	mov    0x8(%ebp),%eax
  802a37:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3e:	a1 54 41 80 00       	mov    0x804154,%eax
  802a43:	40                   	inc    %eax
  802a44:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802a49:	e9 bc 05 00 00       	jmp    80300a <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802a4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a52:	75 17                	jne    802a6b <insert_sorted_with_merge_freeList+0x164>
  802a54:	83 ec 04             	sub    $0x4,%esp
  802a57:	68 ac 3a 80 00       	push   $0x803aac
  802a5c:	68 1f 01 00 00       	push   $0x11f
  802a61:	68 93 3a 80 00       	push   $0x803a93
  802a66:	e8 06 d8 ff ff       	call   800271 <_panic>
  802a6b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	89 50 04             	mov    %edx,0x4(%eax)
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	8b 40 04             	mov    0x4(%eax),%eax
  802a7d:	85 c0                	test   %eax,%eax
  802a7f:	74 0c                	je     802a8d <insert_sorted_with_merge_freeList+0x186>
  802a81:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a86:	8b 55 08             	mov    0x8(%ebp),%edx
  802a89:	89 10                	mov    %edx,(%eax)
  802a8b:	eb 08                	jmp    802a95 <insert_sorted_with_merge_freeList+0x18e>
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	a3 38 41 80 00       	mov    %eax,0x804138
  802a95:	8b 45 08             	mov    0x8(%ebp),%eax
  802a98:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa6:	a1 44 41 80 00       	mov    0x804144,%eax
  802aab:	40                   	inc    %eax
  802aac:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802ab1:	e9 54 05 00 00       	jmp    80300a <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab9:	8b 50 08             	mov    0x8(%eax),%edx
  802abc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802abf:	8b 40 08             	mov    0x8(%eax),%eax
  802ac2:	39 c2                	cmp    %eax,%edx
  802ac4:	0f 83 20 01 00 00    	jae    802bea <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802aca:	8b 45 08             	mov    0x8(%ebp),%eax
  802acd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	8b 40 08             	mov    0x8(%eax),%eax
  802ad6:	01 c2                	add    %eax,%edx
  802ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802adb:	8b 40 08             	mov    0x8(%eax),%eax
  802ade:	39 c2                	cmp    %eax,%edx
  802ae0:	0f 85 9c 00 00 00    	jne    802b82 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 50 08             	mov    0x8(%eax),%edx
  802aec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aef:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802af2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802af5:	8b 50 0c             	mov    0xc(%eax),%edx
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	8b 40 0c             	mov    0xc(%eax),%eax
  802afe:	01 c2                	add    %eax,%edx
  802b00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b03:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1e:	75 17                	jne    802b37 <insert_sorted_with_merge_freeList+0x230>
  802b20:	83 ec 04             	sub    $0x4,%esp
  802b23:	68 70 3a 80 00       	push   $0x803a70
  802b28:	68 2a 01 00 00       	push   $0x12a
  802b2d:	68 93 3a 80 00       	push   $0x803a93
  802b32:	e8 3a d7 ff ff       	call   800271 <_panic>
  802b37:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	89 10                	mov    %edx,(%eax)
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	74 0d                	je     802b58 <insert_sorted_with_merge_freeList+0x251>
  802b4b:	a1 48 41 80 00       	mov    0x804148,%eax
  802b50:	8b 55 08             	mov    0x8(%ebp),%edx
  802b53:	89 50 04             	mov    %edx,0x4(%eax)
  802b56:	eb 08                	jmp    802b60 <insert_sorted_with_merge_freeList+0x259>
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	a3 48 41 80 00       	mov    %eax,0x804148
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b72:	a1 54 41 80 00       	mov    0x804154,%eax
  802b77:	40                   	inc    %eax
  802b78:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b7d:	e9 88 04 00 00       	jmp    80300a <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802b82:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b86:	75 17                	jne    802b9f <insert_sorted_with_merge_freeList+0x298>
  802b88:	83 ec 04             	sub    $0x4,%esp
  802b8b:	68 70 3a 80 00       	push   $0x803a70
  802b90:	68 2e 01 00 00       	push   $0x12e
  802b95:	68 93 3a 80 00       	push   $0x803a93
  802b9a:	e8 d2 d6 ff ff       	call   800271 <_panic>
  802b9f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba8:	89 10                	mov    %edx,(%eax)
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	8b 00                	mov    (%eax),%eax
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	74 0d                	je     802bc0 <insert_sorted_with_merge_freeList+0x2b9>
  802bb3:	a1 38 41 80 00       	mov    0x804138,%eax
  802bb8:	8b 55 08             	mov    0x8(%ebp),%edx
  802bbb:	89 50 04             	mov    %edx,0x4(%eax)
  802bbe:	eb 08                	jmp    802bc8 <insert_sorted_with_merge_freeList+0x2c1>
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	a3 38 41 80 00       	mov    %eax,0x804138
  802bd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bda:	a1 44 41 80 00       	mov    0x804144,%eax
  802bdf:	40                   	inc    %eax
  802be0:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802be5:	e9 20 04 00 00       	jmp    80300a <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802bea:	a1 38 41 80 00       	mov    0x804138,%eax
  802bef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802bf2:	e9 e2 03 00 00       	jmp    802fd9 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	8b 50 08             	mov    0x8(%eax),%edx
  802bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c00:	8b 40 08             	mov    0x8(%eax),%eax
  802c03:	39 c2                	cmp    %eax,%edx
  802c05:	0f 83 c6 03 00 00    	jae    802fd1 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 40 04             	mov    0x4(%eax),%eax
  802c11:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802c14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c17:	8b 50 08             	mov    0x8(%eax),%edx
  802c1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  802c20:	01 d0                	add    %edx,%eax
  802c22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	8b 50 0c             	mov    0xc(%eax),%edx
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	8b 40 08             	mov    0x8(%eax),%eax
  802c31:	01 d0                	add    %edx,%eax
  802c33:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	8b 40 08             	mov    0x8(%eax),%eax
  802c3c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802c3f:	74 7a                	je     802cbb <insert_sorted_with_merge_freeList+0x3b4>
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	8b 40 08             	mov    0x8(%eax),%eax
  802c47:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802c4a:	74 6f                	je     802cbb <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802c4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c50:	74 06                	je     802c58 <insert_sorted_with_merge_freeList+0x351>
  802c52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c56:	75 17                	jne    802c6f <insert_sorted_with_merge_freeList+0x368>
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	68 f0 3a 80 00       	push   $0x803af0
  802c60:	68 43 01 00 00       	push   $0x143
  802c65:	68 93 3a 80 00       	push   $0x803a93
  802c6a:	e8 02 d6 ff ff       	call   800271 <_panic>
  802c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c72:	8b 50 04             	mov    0x4(%eax),%edx
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	89 50 04             	mov    %edx,0x4(%eax)
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c81:	89 10                	mov    %edx,(%eax)
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 40 04             	mov    0x4(%eax),%eax
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	74 0d                	je     802c9a <insert_sorted_with_merge_freeList+0x393>
  802c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	8b 55 08             	mov    0x8(%ebp),%edx
  802c96:	89 10                	mov    %edx,(%eax)
  802c98:	eb 08                	jmp    802ca2 <insert_sorted_with_merge_freeList+0x39b>
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	a3 38 41 80 00       	mov    %eax,0x804138
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca8:	89 50 04             	mov    %edx,0x4(%eax)
  802cab:	a1 44 41 80 00       	mov    0x804144,%eax
  802cb0:	40                   	inc    %eax
  802cb1:	a3 44 41 80 00       	mov    %eax,0x804144
  802cb6:	e9 14 03 00 00       	jmp    802fcf <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 40 08             	mov    0x8(%eax),%eax
  802cc1:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802cc4:	0f 85 a0 01 00 00    	jne    802e6a <insert_sorted_with_merge_freeList+0x563>
  802cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccd:	8b 40 08             	mov    0x8(%eax),%eax
  802cd0:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cd3:	0f 85 91 01 00 00    	jne    802e6a <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdc:	8b 50 0c             	mov    0xc(%eax),%edx
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	8b 48 0c             	mov    0xc(%eax),%ecx
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ceb:	01 c8                	add    %ecx,%eax
  802ced:	01 c2                	add    %eax,%edx
  802cef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cf2:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802d1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d21:	75 17                	jne    802d3a <insert_sorted_with_merge_freeList+0x433>
  802d23:	83 ec 04             	sub    $0x4,%esp
  802d26:	68 70 3a 80 00       	push   $0x803a70
  802d2b:	68 4d 01 00 00       	push   $0x14d
  802d30:	68 93 3a 80 00       	push   $0x803a93
  802d35:	e8 37 d5 ff ff       	call   800271 <_panic>
  802d3a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	89 10                	mov    %edx,(%eax)
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	8b 00                	mov    (%eax),%eax
  802d4a:	85 c0                	test   %eax,%eax
  802d4c:	74 0d                	je     802d5b <insert_sorted_with_merge_freeList+0x454>
  802d4e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d53:	8b 55 08             	mov    0x8(%ebp),%edx
  802d56:	89 50 04             	mov    %edx,0x4(%eax)
  802d59:	eb 08                	jmp    802d63 <insert_sorted_with_merge_freeList+0x45c>
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d63:	8b 45 08             	mov    0x8(%ebp),%eax
  802d66:	a3 48 41 80 00       	mov    %eax,0x804148
  802d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d75:	a1 54 41 80 00       	mov    0x804154,%eax
  802d7a:	40                   	inc    %eax
  802d7b:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802d80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d84:	75 17                	jne    802d9d <insert_sorted_with_merge_freeList+0x496>
  802d86:	83 ec 04             	sub    $0x4,%esp
  802d89:	68 cf 3a 80 00       	push   $0x803acf
  802d8e:	68 4e 01 00 00       	push   $0x14e
  802d93:	68 93 3a 80 00       	push   $0x803a93
  802d98:	e8 d4 d4 ff ff       	call   800271 <_panic>
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 00                	mov    (%eax),%eax
  802da2:	85 c0                	test   %eax,%eax
  802da4:	74 10                	je     802db6 <insert_sorted_with_merge_freeList+0x4af>
  802da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da9:	8b 00                	mov    (%eax),%eax
  802dab:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dae:	8b 52 04             	mov    0x4(%edx),%edx
  802db1:	89 50 04             	mov    %edx,0x4(%eax)
  802db4:	eb 0b                	jmp    802dc1 <insert_sorted_with_merge_freeList+0x4ba>
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 40 04             	mov    0x4(%eax),%eax
  802dbc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	8b 40 04             	mov    0x4(%eax),%eax
  802dc7:	85 c0                	test   %eax,%eax
  802dc9:	74 0f                	je     802dda <insert_sorted_with_merge_freeList+0x4d3>
  802dcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dce:	8b 40 04             	mov    0x4(%eax),%eax
  802dd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dd4:	8b 12                	mov    (%edx),%edx
  802dd6:	89 10                	mov    %edx,(%eax)
  802dd8:	eb 0a                	jmp    802de4 <insert_sorted_with_merge_freeList+0x4dd>
  802dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddd:	8b 00                	mov    (%eax),%eax
  802ddf:	a3 38 41 80 00       	mov    %eax,0x804138
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df7:	a1 44 41 80 00       	mov    0x804144,%eax
  802dfc:	48                   	dec    %eax
  802dfd:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e06:	75 17                	jne    802e1f <insert_sorted_with_merge_freeList+0x518>
  802e08:	83 ec 04             	sub    $0x4,%esp
  802e0b:	68 70 3a 80 00       	push   $0x803a70
  802e10:	68 4f 01 00 00       	push   $0x14f
  802e15:	68 93 3a 80 00       	push   $0x803a93
  802e1a:	e8 52 d4 ff ff       	call   800271 <_panic>
  802e1f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	89 10                	mov    %edx,(%eax)
  802e2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2d:	8b 00                	mov    (%eax),%eax
  802e2f:	85 c0                	test   %eax,%eax
  802e31:	74 0d                	je     802e40 <insert_sorted_with_merge_freeList+0x539>
  802e33:	a1 48 41 80 00       	mov    0x804148,%eax
  802e38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e3b:	89 50 04             	mov    %edx,0x4(%eax)
  802e3e:	eb 08                	jmp    802e48 <insert_sorted_with_merge_freeList+0x541>
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4b:	a3 48 41 80 00       	mov    %eax,0x804148
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5a:	a1 54 41 80 00       	mov    0x804154,%eax
  802e5f:	40                   	inc    %eax
  802e60:	a3 54 41 80 00       	mov    %eax,0x804154
  802e65:	e9 65 01 00 00       	jmp    802fcf <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6d:	8b 40 08             	mov    0x8(%eax),%eax
  802e70:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802e73:	0f 85 9f 00 00 00    	jne    802f18 <insert_sorted_with_merge_freeList+0x611>
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 40 08             	mov    0x8(%eax),%eax
  802e7f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802e82:	0f 84 90 00 00 00    	je     802f18 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802e88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e91:	8b 40 0c             	mov    0xc(%eax),%eax
  802e94:	01 c2                	add    %eax,%edx
  802e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e99:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802eb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802eb4:	75 17                	jne    802ecd <insert_sorted_with_merge_freeList+0x5c6>
  802eb6:	83 ec 04             	sub    $0x4,%esp
  802eb9:	68 70 3a 80 00       	push   $0x803a70
  802ebe:	68 58 01 00 00       	push   $0x158
  802ec3:	68 93 3a 80 00       	push   $0x803a93
  802ec8:	e8 a4 d3 ff ff       	call   800271 <_panic>
  802ecd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	89 10                	mov    %edx,(%eax)
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	8b 00                	mov    (%eax),%eax
  802edd:	85 c0                	test   %eax,%eax
  802edf:	74 0d                	je     802eee <insert_sorted_with_merge_freeList+0x5e7>
  802ee1:	a1 48 41 80 00       	mov    0x804148,%eax
  802ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ee9:	89 50 04             	mov    %edx,0x4(%eax)
  802eec:	eb 08                	jmp    802ef6 <insert_sorted_with_merge_freeList+0x5ef>
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef9:	a3 48 41 80 00       	mov    %eax,0x804148
  802efe:	8b 45 08             	mov    0x8(%ebp),%eax
  802f01:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f08:	a1 54 41 80 00       	mov    0x804154,%eax
  802f0d:	40                   	inc    %eax
  802f0e:	a3 54 41 80 00       	mov    %eax,0x804154
  802f13:	e9 b7 00 00 00       	jmp    802fcf <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	8b 40 08             	mov    0x8(%eax),%eax
  802f1e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f21:	0f 84 e2 00 00 00    	je     803009 <insert_sorted_with_merge_freeList+0x702>
  802f27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2a:	8b 40 08             	mov    0x8(%eax),%eax
  802f2d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f30:	0f 85 d3 00 00 00    	jne    803009 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802f36:	8b 45 08             	mov    0x8(%ebp),%eax
  802f39:	8b 50 08             	mov    0x8(%eax),%edx
  802f3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3f:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f45:	8b 50 0c             	mov    0xc(%eax),%edx
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f4e:	01 c2                	add    %eax,%edx
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f6e:	75 17                	jne    802f87 <insert_sorted_with_merge_freeList+0x680>
  802f70:	83 ec 04             	sub    $0x4,%esp
  802f73:	68 70 3a 80 00       	push   $0x803a70
  802f78:	68 61 01 00 00       	push   $0x161
  802f7d:	68 93 3a 80 00       	push   $0x803a93
  802f82:	e8 ea d2 ff ff       	call   800271 <_panic>
  802f87:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f90:	89 10                	mov    %edx,(%eax)
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	8b 00                	mov    (%eax),%eax
  802f97:	85 c0                	test   %eax,%eax
  802f99:	74 0d                	je     802fa8 <insert_sorted_with_merge_freeList+0x6a1>
  802f9b:	a1 48 41 80 00       	mov    0x804148,%eax
  802fa0:	8b 55 08             	mov    0x8(%ebp),%edx
  802fa3:	89 50 04             	mov    %edx,0x4(%eax)
  802fa6:	eb 08                	jmp    802fb0 <insert_sorted_with_merge_freeList+0x6a9>
  802fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb3:	a3 48 41 80 00       	mov    %eax,0x804148
  802fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc2:	a1 54 41 80 00       	mov    0x804154,%eax
  802fc7:	40                   	inc    %eax
  802fc8:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  802fcd:	eb 3a                	jmp    803009 <insert_sorted_with_merge_freeList+0x702>
  802fcf:	eb 38                	jmp    803009 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802fd1:	a1 40 41 80 00       	mov    0x804140,%eax
  802fd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fdd:	74 07                	je     802fe6 <insert_sorted_with_merge_freeList+0x6df>
  802fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe2:	8b 00                	mov    (%eax),%eax
  802fe4:	eb 05                	jmp    802feb <insert_sorted_with_merge_freeList+0x6e4>
  802fe6:	b8 00 00 00 00       	mov    $0x0,%eax
  802feb:	a3 40 41 80 00       	mov    %eax,0x804140
  802ff0:	a1 40 41 80 00       	mov    0x804140,%eax
  802ff5:	85 c0                	test   %eax,%eax
  802ff7:	0f 85 fa fb ff ff    	jne    802bf7 <insert_sorted_with_merge_freeList+0x2f0>
  802ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803001:	0f 85 f0 fb ff ff    	jne    802bf7 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803007:	eb 01                	jmp    80300a <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803009:	90                   	nop
							}

						}
		          }
		}
}
  80300a:	90                   	nop
  80300b:	c9                   	leave  
  80300c:	c3                   	ret    
  80300d:	66 90                	xchg   %ax,%ax
  80300f:	90                   	nop

00803010 <__udivdi3>:
  803010:	55                   	push   %ebp
  803011:	57                   	push   %edi
  803012:	56                   	push   %esi
  803013:	53                   	push   %ebx
  803014:	83 ec 1c             	sub    $0x1c,%esp
  803017:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80301b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80301f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803023:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803027:	89 ca                	mov    %ecx,%edx
  803029:	89 f8                	mov    %edi,%eax
  80302b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80302f:	85 f6                	test   %esi,%esi
  803031:	75 2d                	jne    803060 <__udivdi3+0x50>
  803033:	39 cf                	cmp    %ecx,%edi
  803035:	77 65                	ja     80309c <__udivdi3+0x8c>
  803037:	89 fd                	mov    %edi,%ebp
  803039:	85 ff                	test   %edi,%edi
  80303b:	75 0b                	jne    803048 <__udivdi3+0x38>
  80303d:	b8 01 00 00 00       	mov    $0x1,%eax
  803042:	31 d2                	xor    %edx,%edx
  803044:	f7 f7                	div    %edi
  803046:	89 c5                	mov    %eax,%ebp
  803048:	31 d2                	xor    %edx,%edx
  80304a:	89 c8                	mov    %ecx,%eax
  80304c:	f7 f5                	div    %ebp
  80304e:	89 c1                	mov    %eax,%ecx
  803050:	89 d8                	mov    %ebx,%eax
  803052:	f7 f5                	div    %ebp
  803054:	89 cf                	mov    %ecx,%edi
  803056:	89 fa                	mov    %edi,%edx
  803058:	83 c4 1c             	add    $0x1c,%esp
  80305b:	5b                   	pop    %ebx
  80305c:	5e                   	pop    %esi
  80305d:	5f                   	pop    %edi
  80305e:	5d                   	pop    %ebp
  80305f:	c3                   	ret    
  803060:	39 ce                	cmp    %ecx,%esi
  803062:	77 28                	ja     80308c <__udivdi3+0x7c>
  803064:	0f bd fe             	bsr    %esi,%edi
  803067:	83 f7 1f             	xor    $0x1f,%edi
  80306a:	75 40                	jne    8030ac <__udivdi3+0x9c>
  80306c:	39 ce                	cmp    %ecx,%esi
  80306e:	72 0a                	jb     80307a <__udivdi3+0x6a>
  803070:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803074:	0f 87 9e 00 00 00    	ja     803118 <__udivdi3+0x108>
  80307a:	b8 01 00 00 00       	mov    $0x1,%eax
  80307f:	89 fa                	mov    %edi,%edx
  803081:	83 c4 1c             	add    $0x1c,%esp
  803084:	5b                   	pop    %ebx
  803085:	5e                   	pop    %esi
  803086:	5f                   	pop    %edi
  803087:	5d                   	pop    %ebp
  803088:	c3                   	ret    
  803089:	8d 76 00             	lea    0x0(%esi),%esi
  80308c:	31 ff                	xor    %edi,%edi
  80308e:	31 c0                	xor    %eax,%eax
  803090:	89 fa                	mov    %edi,%edx
  803092:	83 c4 1c             	add    $0x1c,%esp
  803095:	5b                   	pop    %ebx
  803096:	5e                   	pop    %esi
  803097:	5f                   	pop    %edi
  803098:	5d                   	pop    %ebp
  803099:	c3                   	ret    
  80309a:	66 90                	xchg   %ax,%ax
  80309c:	89 d8                	mov    %ebx,%eax
  80309e:	f7 f7                	div    %edi
  8030a0:	31 ff                	xor    %edi,%edi
  8030a2:	89 fa                	mov    %edi,%edx
  8030a4:	83 c4 1c             	add    $0x1c,%esp
  8030a7:	5b                   	pop    %ebx
  8030a8:	5e                   	pop    %esi
  8030a9:	5f                   	pop    %edi
  8030aa:	5d                   	pop    %ebp
  8030ab:	c3                   	ret    
  8030ac:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030b1:	89 eb                	mov    %ebp,%ebx
  8030b3:	29 fb                	sub    %edi,%ebx
  8030b5:	89 f9                	mov    %edi,%ecx
  8030b7:	d3 e6                	shl    %cl,%esi
  8030b9:	89 c5                	mov    %eax,%ebp
  8030bb:	88 d9                	mov    %bl,%cl
  8030bd:	d3 ed                	shr    %cl,%ebp
  8030bf:	89 e9                	mov    %ebp,%ecx
  8030c1:	09 f1                	or     %esi,%ecx
  8030c3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030c7:	89 f9                	mov    %edi,%ecx
  8030c9:	d3 e0                	shl    %cl,%eax
  8030cb:	89 c5                	mov    %eax,%ebp
  8030cd:	89 d6                	mov    %edx,%esi
  8030cf:	88 d9                	mov    %bl,%cl
  8030d1:	d3 ee                	shr    %cl,%esi
  8030d3:	89 f9                	mov    %edi,%ecx
  8030d5:	d3 e2                	shl    %cl,%edx
  8030d7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030db:	88 d9                	mov    %bl,%cl
  8030dd:	d3 e8                	shr    %cl,%eax
  8030df:	09 c2                	or     %eax,%edx
  8030e1:	89 d0                	mov    %edx,%eax
  8030e3:	89 f2                	mov    %esi,%edx
  8030e5:	f7 74 24 0c          	divl   0xc(%esp)
  8030e9:	89 d6                	mov    %edx,%esi
  8030eb:	89 c3                	mov    %eax,%ebx
  8030ed:	f7 e5                	mul    %ebp
  8030ef:	39 d6                	cmp    %edx,%esi
  8030f1:	72 19                	jb     80310c <__udivdi3+0xfc>
  8030f3:	74 0b                	je     803100 <__udivdi3+0xf0>
  8030f5:	89 d8                	mov    %ebx,%eax
  8030f7:	31 ff                	xor    %edi,%edi
  8030f9:	e9 58 ff ff ff       	jmp    803056 <__udivdi3+0x46>
  8030fe:	66 90                	xchg   %ax,%ax
  803100:	8b 54 24 08          	mov    0x8(%esp),%edx
  803104:	89 f9                	mov    %edi,%ecx
  803106:	d3 e2                	shl    %cl,%edx
  803108:	39 c2                	cmp    %eax,%edx
  80310a:	73 e9                	jae    8030f5 <__udivdi3+0xe5>
  80310c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80310f:	31 ff                	xor    %edi,%edi
  803111:	e9 40 ff ff ff       	jmp    803056 <__udivdi3+0x46>
  803116:	66 90                	xchg   %ax,%ax
  803118:	31 c0                	xor    %eax,%eax
  80311a:	e9 37 ff ff ff       	jmp    803056 <__udivdi3+0x46>
  80311f:	90                   	nop

00803120 <__umoddi3>:
  803120:	55                   	push   %ebp
  803121:	57                   	push   %edi
  803122:	56                   	push   %esi
  803123:	53                   	push   %ebx
  803124:	83 ec 1c             	sub    $0x1c,%esp
  803127:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80312b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80312f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803133:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80313b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80313f:	89 f3                	mov    %esi,%ebx
  803141:	89 fa                	mov    %edi,%edx
  803143:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803147:	89 34 24             	mov    %esi,(%esp)
  80314a:	85 c0                	test   %eax,%eax
  80314c:	75 1a                	jne    803168 <__umoddi3+0x48>
  80314e:	39 f7                	cmp    %esi,%edi
  803150:	0f 86 a2 00 00 00    	jbe    8031f8 <__umoddi3+0xd8>
  803156:	89 c8                	mov    %ecx,%eax
  803158:	89 f2                	mov    %esi,%edx
  80315a:	f7 f7                	div    %edi
  80315c:	89 d0                	mov    %edx,%eax
  80315e:	31 d2                	xor    %edx,%edx
  803160:	83 c4 1c             	add    $0x1c,%esp
  803163:	5b                   	pop    %ebx
  803164:	5e                   	pop    %esi
  803165:	5f                   	pop    %edi
  803166:	5d                   	pop    %ebp
  803167:	c3                   	ret    
  803168:	39 f0                	cmp    %esi,%eax
  80316a:	0f 87 ac 00 00 00    	ja     80321c <__umoddi3+0xfc>
  803170:	0f bd e8             	bsr    %eax,%ebp
  803173:	83 f5 1f             	xor    $0x1f,%ebp
  803176:	0f 84 ac 00 00 00    	je     803228 <__umoddi3+0x108>
  80317c:	bf 20 00 00 00       	mov    $0x20,%edi
  803181:	29 ef                	sub    %ebp,%edi
  803183:	89 fe                	mov    %edi,%esi
  803185:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803189:	89 e9                	mov    %ebp,%ecx
  80318b:	d3 e0                	shl    %cl,%eax
  80318d:	89 d7                	mov    %edx,%edi
  80318f:	89 f1                	mov    %esi,%ecx
  803191:	d3 ef                	shr    %cl,%edi
  803193:	09 c7                	or     %eax,%edi
  803195:	89 e9                	mov    %ebp,%ecx
  803197:	d3 e2                	shl    %cl,%edx
  803199:	89 14 24             	mov    %edx,(%esp)
  80319c:	89 d8                	mov    %ebx,%eax
  80319e:	d3 e0                	shl    %cl,%eax
  8031a0:	89 c2                	mov    %eax,%edx
  8031a2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031a6:	d3 e0                	shl    %cl,%eax
  8031a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031ac:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031b0:	89 f1                	mov    %esi,%ecx
  8031b2:	d3 e8                	shr    %cl,%eax
  8031b4:	09 d0                	or     %edx,%eax
  8031b6:	d3 eb                	shr    %cl,%ebx
  8031b8:	89 da                	mov    %ebx,%edx
  8031ba:	f7 f7                	div    %edi
  8031bc:	89 d3                	mov    %edx,%ebx
  8031be:	f7 24 24             	mull   (%esp)
  8031c1:	89 c6                	mov    %eax,%esi
  8031c3:	89 d1                	mov    %edx,%ecx
  8031c5:	39 d3                	cmp    %edx,%ebx
  8031c7:	0f 82 87 00 00 00    	jb     803254 <__umoddi3+0x134>
  8031cd:	0f 84 91 00 00 00    	je     803264 <__umoddi3+0x144>
  8031d3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031d7:	29 f2                	sub    %esi,%edx
  8031d9:	19 cb                	sbb    %ecx,%ebx
  8031db:	89 d8                	mov    %ebx,%eax
  8031dd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031e1:	d3 e0                	shl    %cl,%eax
  8031e3:	89 e9                	mov    %ebp,%ecx
  8031e5:	d3 ea                	shr    %cl,%edx
  8031e7:	09 d0                	or     %edx,%eax
  8031e9:	89 e9                	mov    %ebp,%ecx
  8031eb:	d3 eb                	shr    %cl,%ebx
  8031ed:	89 da                	mov    %ebx,%edx
  8031ef:	83 c4 1c             	add    $0x1c,%esp
  8031f2:	5b                   	pop    %ebx
  8031f3:	5e                   	pop    %esi
  8031f4:	5f                   	pop    %edi
  8031f5:	5d                   	pop    %ebp
  8031f6:	c3                   	ret    
  8031f7:	90                   	nop
  8031f8:	89 fd                	mov    %edi,%ebp
  8031fa:	85 ff                	test   %edi,%edi
  8031fc:	75 0b                	jne    803209 <__umoddi3+0xe9>
  8031fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803203:	31 d2                	xor    %edx,%edx
  803205:	f7 f7                	div    %edi
  803207:	89 c5                	mov    %eax,%ebp
  803209:	89 f0                	mov    %esi,%eax
  80320b:	31 d2                	xor    %edx,%edx
  80320d:	f7 f5                	div    %ebp
  80320f:	89 c8                	mov    %ecx,%eax
  803211:	f7 f5                	div    %ebp
  803213:	89 d0                	mov    %edx,%eax
  803215:	e9 44 ff ff ff       	jmp    80315e <__umoddi3+0x3e>
  80321a:	66 90                	xchg   %ax,%ax
  80321c:	89 c8                	mov    %ecx,%eax
  80321e:	89 f2                	mov    %esi,%edx
  803220:	83 c4 1c             	add    $0x1c,%esp
  803223:	5b                   	pop    %ebx
  803224:	5e                   	pop    %esi
  803225:	5f                   	pop    %edi
  803226:	5d                   	pop    %ebp
  803227:	c3                   	ret    
  803228:	3b 04 24             	cmp    (%esp),%eax
  80322b:	72 06                	jb     803233 <__umoddi3+0x113>
  80322d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803231:	77 0f                	ja     803242 <__umoddi3+0x122>
  803233:	89 f2                	mov    %esi,%edx
  803235:	29 f9                	sub    %edi,%ecx
  803237:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80323b:	89 14 24             	mov    %edx,(%esp)
  80323e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803242:	8b 44 24 04          	mov    0x4(%esp),%eax
  803246:	8b 14 24             	mov    (%esp),%edx
  803249:	83 c4 1c             	add    $0x1c,%esp
  80324c:	5b                   	pop    %ebx
  80324d:	5e                   	pop    %esi
  80324e:	5f                   	pop    %edi
  80324f:	5d                   	pop    %ebp
  803250:	c3                   	ret    
  803251:	8d 76 00             	lea    0x0(%esi),%esi
  803254:	2b 04 24             	sub    (%esp),%eax
  803257:	19 fa                	sbb    %edi,%edx
  803259:	89 d1                	mov    %edx,%ecx
  80325b:	89 c6                	mov    %eax,%esi
  80325d:	e9 71 ff ff ff       	jmp    8031d3 <__umoddi3+0xb3>
  803262:	66 90                	xchg   %ax,%ax
  803264:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803268:	72 ea                	jb     803254 <__umoddi3+0x134>
  80326a:	89 d9                	mov    %ebx,%ecx
  80326c:	e9 62 ff ff ff       	jmp    8031d3 <__umoddi3+0xb3>

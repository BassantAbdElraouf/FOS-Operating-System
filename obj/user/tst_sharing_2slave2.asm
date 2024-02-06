
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 c3 01 00 00       	call   8001f9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 40 33 80 00       	push   $0x803340
  800092:	6a 13                	push   $0x13
  800094:	68 5c 33 80 00       	push   $0x80335c
  800099:	e8 97 02 00 00       	call   800335 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 70 14 00 00       	call   801518 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 ce 1b 00 00       	call   801c7e <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 ba 19 00 00       	call   801a72 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 c8 18 00 00       	call   801985 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 77 33 80 00       	push   $0x803377
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 6e 16 00 00       	call   80173e <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 7c 33 80 00       	push   $0x80337c
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 5c 33 80 00       	push   $0x80335c
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 8a 18 00 00       	call   801985 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 dc 33 80 00       	push   $0x8033dc
  80010c:	6a 22                	push   $0x22
  80010e:	68 5c 33 80 00       	push   $0x80335c
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 6f 19 00 00       	call   801a8c <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 50 19 00 00       	call   801a72 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 5e 18 00 00       	call   801985 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 6d 34 80 00       	push   $0x80346d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 04 16 00 00       	call   80173e <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 7c 33 80 00       	push   $0x80337c
  800151:	6a 28                	push   $0x28
  800153:	68 5c 33 80 00       	push   $0x80335c
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 23 18 00 00       	call   801985 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 dc 33 80 00       	push   $0x8033dc
  800173:	6a 29                	push   $0x29
  800175:	68 5c 33 80 00       	push   $0x80335c
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 08 19 00 00       	call   801a8c <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 70 34 80 00       	push   $0x803470
  800196:	6a 2c                	push   $0x2c
  800198:	68 5c 33 80 00       	push   $0x80335c
  80019d:	e8 93 01 00 00       	call   800335 <_panic>

	//Edit the writable object
	*z = 30;
  8001a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a5:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  8001ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	83 f8 1e             	cmp    $0x1e,%eax
  8001b3:	74 14                	je     8001c9 <_main+0x191>
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 70 34 80 00       	push   $0x803470
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 5c 33 80 00       	push   $0x80335c
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 a8 34 80 00       	push   $0x8034a8
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 d8 34 80 00       	push   $0x8034d8
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 5c 33 80 00       	push   $0x80335c
  8001f4:	e8 3c 01 00 00       	call   800335 <_panic>

008001f9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ff:	e8 61 1a 00 00       	call   801c65 <sys_getenvindex>
  800204:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80020a:	89 d0                	mov    %edx,%eax
  80020c:	c1 e0 03             	shl    $0x3,%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	01 d0                	add    %edx,%eax
  800215:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021c:	01 d0                	add    %edx,%eax
  80021e:	c1 e0 04             	shl    $0x4,%eax
  800221:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800226:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800236:	84 c0                	test   %al,%al
  800238:	74 0f                	je     800249 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	05 5c 05 00 00       	add    $0x55c,%eax
  800244:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024d:	7e 0a                	jle    800259 <libmain+0x60>
		binaryname = argv[0];
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 d1 fd ff ff       	call   800038 <_main>
  800267:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026a:	e8 03 18 00 00       	call   801a72 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 34 35 80 00       	push   $0x803534
  800277:	e8 6d 03 00 00       	call   8005e9 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027f:	a1 20 40 80 00       	mov    0x804020,%eax
  800284:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80028a:	a1 20 40 80 00       	mov    0x804020,%eax
  80028f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 5c 35 80 00       	push   $0x80355c
  80029f:	e8 45 03 00 00       	call   8005e9 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ac:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b7:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002c8:	51                   	push   %ecx
  8002c9:	52                   	push   %edx
  8002ca:	50                   	push   %eax
  8002cb:	68 84 35 80 00       	push   $0x803584
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 dc 35 80 00       	push   $0x8035dc
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 34 35 80 00       	push   $0x803534
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 83 17 00 00       	call   801a8c <sys_enable_interrupt>

	// exit gracefully
	exit();
  800309:	e8 19 00 00 00       	call   800327 <exit>
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	6a 00                	push   $0x0
  80031c:	e8 10 19 00 00       	call   801c31 <sys_destroy_env>
  800321:	83 c4 10             	add    $0x10,%esp
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <exit>:

void
exit(void)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80032d:	e8 65 19 00 00       	call   801c97 <sys_exit_env>
}
  800332:	90                   	nop
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80033b:	8d 45 10             	lea    0x10(%ebp),%eax
  80033e:	83 c0 04             	add    $0x4,%eax
  800341:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800344:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	74 16                	je     800363 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80034d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	50                   	push   %eax
  800356:	68 f0 35 80 00       	push   $0x8035f0
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 40 80 00       	mov    0x804000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 f5 35 80 00       	push   $0x8035f5
  800374:	e8 70 02 00 00       	call   8005e9 <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	e8 f3 01 00 00       	call   80057e <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	6a 00                	push   $0x0
  800393:	68 11 36 80 00       	push   $0x803611
  800398:	e8 e1 01 00 00       	call   80057e <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003a0:	e8 82 ff ff ff       	call   800327 <exit>

	// should not return here
	while (1) ;
  8003a5:	eb fe                	jmp    8003a5 <_panic+0x70>

008003a7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b2:	8b 50 74             	mov    0x74(%eax),%edx
  8003b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b8:	39 c2                	cmp    %eax,%edx
  8003ba:	74 14                	je     8003d0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	68 14 36 80 00       	push   $0x803614
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 60 36 80 00       	push   $0x803660
  8003cb:	e8 65 ff ff ff       	call   800335 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003de:	e9 c2 00 00 00       	jmp    8004a5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	75 08                	jne    800400 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003f8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003fb:	e9 a2 00 00 00       	jmp    8004a2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800400:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800407:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80040e:	eb 69                	jmp    800479 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8a 40 04             	mov    0x4(%eax),%al
  80042c:	84 c0                	test   %al,%al
  80042e:	75 46                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	a1 20 40 80 00       	mov    0x804020,%eax
  800435:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80043b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	01 c0                	add    %eax,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	c1 e0 03             	shl    $0x3,%eax
  800447:	01 c8                	add    %ecx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800456:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c8                	add    %ecx,%eax
  800467:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800469:	39 c2                	cmp    %eax,%edx
  80046b:	75 09                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80046d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800474:	eb 12                	jmp    800488 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	ff 45 e8             	incl   -0x18(%ebp)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 50 74             	mov    0x74(%eax),%edx
  800481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800484:	39 c2                	cmp    %eax,%edx
  800486:	77 88                	ja     800410 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80048c:	75 14                	jne    8004a2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	68 6c 36 80 00       	push   $0x80366c
  800496:	6a 3a                	push   $0x3a
  800498:	68 60 36 80 00       	push   $0x803660
  80049d:	e8 93 fe ff ff       	call   800335 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004a2:	ff 45 f0             	incl   -0x10(%ebp)
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ab:	0f 8c 32 ff ff ff    	jl     8003e3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004bf:	eb 26                	jmp    8004e7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	89 d0                	mov    %edx,%eax
  8004d1:	01 c0                	add    %eax,%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 03             	shl    $0x3,%eax
  8004d8:	01 c8                	add    %ecx,%eax
  8004da:	8a 40 04             	mov    0x4(%eax),%al
  8004dd:	3c 01                	cmp    $0x1,%al
  8004df:	75 03                	jne    8004e4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e4:	ff 45 e0             	incl   -0x20(%ebp)
  8004e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ec:	8b 50 74             	mov    0x74(%eax),%edx
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	77 cb                	ja     8004c1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fc:	74 14                	je     800512 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 c0 36 80 00       	push   $0x8036c0
  800506:	6a 44                	push   $0x44
  800508:	68 60 36 80 00       	push   $0x803660
  80050d:	e8 23 fe ff ff       	call   800335 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800512:	90                   	nop
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 48 01             	lea    0x1(%eax),%ecx
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	89 0a                	mov    %ecx,(%edx)
  800528:	8b 55 08             	mov    0x8(%ebp),%edx
  80052b:	88 d1                	mov    %dl,%cl
  80052d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800530:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800534:	8b 45 0c             	mov    0xc(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053e:	75 2c                	jne    80056c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800540:	a0 24 40 80 00       	mov    0x804024,%al
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	8b 12                	mov    (%edx),%edx
  80054d:	89 d1                	mov    %edx,%ecx
  80054f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800552:	83 c2 08             	add    $0x8,%edx
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	50                   	push   %eax
  800559:	51                   	push   %ecx
  80055a:	52                   	push   %edx
  80055b:	e8 64 13 00 00       	call   8018c4 <sys_cputs>
  800560:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	8b 40 04             	mov    0x4(%eax),%eax
  800572:	8d 50 01             	lea    0x1(%eax),%edx
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	89 50 04             	mov    %edx,0x4(%eax)
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800587:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058e:	00 00 00 
	b.cnt = 0;
  800591:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800598:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	ff 75 08             	pushl  0x8(%ebp)
  8005a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a7:	50                   	push   %eax
  8005a8:	68 15 05 80 00       	push   $0x800515
  8005ad:	e8 11 02 00 00       	call   8007c3 <vprintfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005b5:	a0 24 40 80 00       	mov    0x804024,%al
  8005ba:	0f b6 c0             	movzbl %al,%eax
  8005bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	50                   	push   %eax
  8005c7:	52                   	push   %edx
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	50                   	push   %eax
  8005d2:	e8 ed 12 00 00       	call   8018c4 <sys_cputs>
  8005d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005da:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ef:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 f4             	pushl  -0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	e8 73 ff ff ff       	call   80057e <vcprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80061c:	e8 51 14 00 00       	call   801a72 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 48 ff ff ff       	call   80057e <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80063c:	e8 4b 14 00 00       	call   801a8c <sys_enable_interrupt>
	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	53                   	push   %ebx
  80064a:	83 ec 14             	sub    $0x14,%esp
  80064d:	8b 45 10             	mov    0x10(%ebp),%eax
  800650:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800659:	8b 45 18             	mov    0x18(%ebp),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800664:	77 55                	ja     8006bb <printnum+0x75>
  800666:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800669:	72 05                	jb     800670 <printnum+0x2a>
  80066b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066e:	77 4b                	ja     8006bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800670:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800673:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800676:	8b 45 18             	mov    0x18(%ebp),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	52                   	push   %edx
  80067f:	50                   	push   %eax
  800680:	ff 75 f4             	pushl  -0xc(%ebp)
  800683:	ff 75 f0             	pushl  -0x10(%ebp)
  800686:	e8 49 2a 00 00       	call   8030d4 <__udivdi3>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	ff 75 20             	pushl  0x20(%ebp)
  800694:	53                   	push   %ebx
  800695:	ff 75 18             	pushl  0x18(%ebp)
  800698:	52                   	push   %edx
  800699:	50                   	push   %eax
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 a1 ff ff ff       	call   800646 <printnum>
  8006a5:	83 c4 20             	add    $0x20,%esp
  8006a8:	eb 1a                	jmp    8006c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 20             	pushl  0x20(%ebp)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c2:	7f e6                	jg     8006aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	53                   	push   %ebx
  8006d3:	51                   	push   %ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	e8 09 2b 00 00       	call   8031e4 <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 34 39 80 00       	add    $0x803934,%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be c0             	movsbl %al,%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	90                   	nop
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  800720:	eb 40                	jmp    800762 <getuint+0x65>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1e                	je     800746 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	eb 1c                	jmp    800762 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076b:	7e 1c                	jle    800789 <getint+0x25>
		return va_arg(*ap, long long);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 08             	lea    0x8(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 08             	sub    $0x8,%eax
  800782:	8b 50 04             	mov    0x4(%eax),%edx
  800785:	8b 00                	mov    (%eax),%eax
  800787:	eb 38                	jmp    8007c1 <getint+0x5d>
	else if (lflag)
  800789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078d:	74 1a                	je     8007a9 <getint+0x45>
		return va_arg(*ap, long);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	99                   	cltd   
  8007a7:	eb 18                	jmp    8007c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 04             	lea    0x4(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	99                   	cltd   
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	eb 17                	jmp    8007e4 <vprintfmt+0x21>
			if (ch == '\0')
  8007cd:	85 db                	test   %ebx,%ebx
  8007cf:	0f 84 af 03 00 00    	je     800b84 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ed:	8a 00                	mov    (%eax),%al
  8007ef:	0f b6 d8             	movzbl %al,%ebx
  8007f2:	83 fb 25             	cmp    $0x25,%ebx
  8007f5:	75 d6                	jne    8007cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800802:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800809:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	8d 50 01             	lea    0x1(%eax),%edx
  80081d:	89 55 10             	mov    %edx,0x10(%ebp)
  800820:	8a 00                	mov    (%eax),%al
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800828:	83 f8 55             	cmp    $0x55,%eax
  80082b:	0f 87 2b 03 00 00    	ja     800b5c <vprintfmt+0x399>
  800831:	8b 04 85 58 39 80 00 	mov    0x803958(,%eax,4),%eax
  800838:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80083a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083e:	eb d7                	jmp    800817 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800840:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800844:	eb d1                	jmp    800817 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800850:	89 d0                	mov    %edx,%eax
  800852:	c1 e0 02             	shl    $0x2,%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d8                	add    %ebx,%eax
  80085b:	83 e8 30             	sub    $0x30,%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	8a 00                	mov    (%eax),%al
  800866:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800869:	83 fb 2f             	cmp    $0x2f,%ebx
  80086c:	7e 3e                	jle    8008ac <vprintfmt+0xe9>
  80086e:	83 fb 39             	cmp    $0x39,%ebx
  800871:	7f 39                	jg     8008ac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800876:	eb d5                	jmp    80084d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	83 c0 04             	add    $0x4,%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 e8 04             	sub    $0x4,%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088c:	eb 1f                	jmp    8008ad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	79 83                	jns    800817 <vprintfmt+0x54>
				width = 0;
  800894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80089b:	e9 77 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a7:	e9 6b ff ff ff       	jmp    800817 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	0f 89 60 ff ff ff    	jns    800817 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c4:	e9 4e ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008cc:	e9 46 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	50                   	push   %eax
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
			break;
  8008f1:	e9 89 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800907:	85 db                	test   %ebx,%ebx
  800909:	79 02                	jns    80090d <vprintfmt+0x14a>
				err = -err;
  80090b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090d:	83 fb 64             	cmp    $0x64,%ebx
  800910:	7f 0b                	jg     80091d <vprintfmt+0x15a>
  800912:	8b 34 9d a0 37 80 00 	mov    0x8037a0(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 45 39 80 00       	push   $0x803945
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 08             	pushl  0x8(%ebp)
  800929:	e8 5e 02 00 00       	call   800b8c <printfmt>
  80092e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800931:	e9 49 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800936:	56                   	push   %esi
  800937:	68 4e 39 80 00       	push   $0x80394e
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 45 02 00 00       	call   800b8c <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			break;
  80094a:	e9 30 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 c0 04             	add    $0x4,%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 30                	mov    (%eax),%esi
  800960:	85 f6                	test   %esi,%esi
  800962:	75 05                	jne    800969 <vprintfmt+0x1a6>
				p = "(null)";
  800964:	be 51 39 80 00       	mov    $0x803951,%esi
			if (width > 0 && padc != '-')
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7e 6d                	jle    8009dc <vprintfmt+0x219>
  80096f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800973:	74 67                	je     8009dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	50                   	push   %eax
  80097c:	56                   	push   %esi
  80097d:	e8 0c 03 00 00       	call   800c8e <strnlen>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800988:	eb 16                	jmp    8009a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80098a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	50                   	push   %eax
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099d:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a4:	7f e4                	jg     80098a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a6:	eb 34                	jmp    8009dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ac:	74 1c                	je     8009ca <vprintfmt+0x207>
  8009ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b1:	7e 05                	jle    8009b8 <vprintfmt+0x1f5>
  8009b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b6:	7e 12                	jle    8009ca <vprintfmt+0x207>
					putch('?', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 3f                	push   $0x3f
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	eb 0f                	jmp    8009d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	89 f0                	mov    %esi,%eax
  8009de:	8d 70 01             	lea    0x1(%eax),%esi
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 24                	je     800a0e <vprintfmt+0x24b>
  8009ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ee:	78 b8                	js     8009a8 <vprintfmt+0x1e5>
  8009f0:	ff 4d e0             	decl   -0x20(%ebp)
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	79 af                	jns    8009a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f9:	eb 13                	jmp    800a0e <vprintfmt+0x24b>
				putch(' ', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 20                	push   $0x20
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a12:	7f e7                	jg     8009fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a14:	e9 66 01 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a22:	50                   	push   %eax
  800a23:	e8 3c fd ff ff       	call   800764 <getint>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a37:	85 d2                	test   %edx,%edx
  800a39:	79 23                	jns    800a5e <vprintfmt+0x29b>
				putch('-', putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	6a 2d                	push   $0x2d
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a51:	f7 d8                	neg    %eax
  800a53:	83 d2 00             	adc    $0x0,%edx
  800a56:	f7 da                	neg    %edx
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a65:	e9 bc 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	50                   	push   %eax
  800a74:	e8 84 fc ff ff       	call   8006fd <getuint>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a89:	e9 98 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 58                	push   $0x58
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 58                	push   $0x58
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 bc 00 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 30                	push   $0x30
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 78                	push   $0x78
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b05:	eb 1f                	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 e7 fb ff ff       	call   8006fd <getuint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	52                   	push   %edx
  800b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 f4             	pushl  -0xc(%ebp)
  800b38:	ff 75 f0             	pushl  -0x10(%ebp)
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 00 fb ff ff       	call   800646 <printnum>
  800b46:	83 c4 20             	add    $0x20,%esp
			break;
  800b49:	eb 34                	jmp    800b7f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	53                   	push   %ebx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			break;
  800b5a:	eb 23                	jmp    800b7f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 25                	push   $0x25
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6c:	ff 4d 10             	decl   0x10(%ebp)
  800b6f:	eb 03                	jmp    800b74 <vprintfmt+0x3b1>
  800b71:	ff 4d 10             	decl   0x10(%ebp)
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	48                   	dec    %eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	3c 25                	cmp    $0x25,%al
  800b7c:	75 f3                	jne    800b71 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b7e:	90                   	nop
		}
	}
  800b7f:	e9 47 fc ff ff       	jmp    8007cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 16 fc ff ff       	call   8007c3 <vprintfmt>
  800bad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb0:	90                   	nop
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 40 08             	mov    0x8(%eax),%eax
  800bbc:	8d 50 01             	lea    0x1(%eax),%edx
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 10                	mov    (%eax),%edx
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8b 40 04             	mov    0x4(%eax),%eax
  800bd0:	39 c2                	cmp    %eax,%edx
  800bd2:	73 12                	jae    800be6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdf:	89 0a                	mov    %ecx,(%edx)
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	88 10                	mov    %dl,(%eax)
}
  800be6:	90                   	nop
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	01 d0                	add    %edx,%eax
  800c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0e:	74 06                	je     800c16 <vsnprintf+0x2d>
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	7f 07                	jg     800c1d <vsnprintf+0x34>
		return -E_INVAL;
  800c16:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1b:	eb 20                	jmp    800c3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1d:	ff 75 14             	pushl  0x14(%ebp)
  800c20:	ff 75 10             	pushl  0x10(%ebp)
  800c23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	68 b3 0b 80 00       	push   $0x800bb3
  800c2c:	e8 92 fb ff ff       	call   8007c3 <vprintfmt>
  800c31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c45:	8d 45 10             	lea    0x10(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	ff 75 f4             	pushl  -0xc(%ebp)
  800c54:	50                   	push   %eax
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	ff 75 08             	pushl  0x8(%ebp)
  800c5b:	e8 89 ff ff ff       	call   800be9 <vsnprintf>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 06                	jmp    800c80 <strlen+0x15>
		n++;
  800c7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7d:	ff 45 08             	incl   0x8(%ebp)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	75 f1                	jne    800c7a <strlen+0xf>
		n++;
	return n;
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9b:	eb 09                	jmp    800ca6 <strnlen+0x18>
		n++;
  800c9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	ff 4d 0c             	decl   0xc(%ebp)
  800ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caa:	74 09                	je     800cb5 <strnlen+0x27>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 e8                	jne    800c9d <strnlen+0xf>
		n++;
	return n;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc6:	90                   	nop
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8d 50 01             	lea    0x1(%eax),%edx
  800ccd:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd9:	8a 12                	mov    (%edx),%dl
  800cdb:	88 10                	mov    %dl,(%eax)
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e4                	jne    800cc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfb:	eb 1f                	jmp    800d1c <strncpy+0x34>
		*dst++ = *src;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 08             	mov    %edx,0x8(%ebp)
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	8a 12                	mov    (%edx),%dl
  800d0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 03                	je     800d19 <strncpy+0x31>
			src++;
  800d16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d19:	ff 45 fc             	incl   -0x4(%ebp)
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d22:	72 d9                	jb     800cfd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	74 30                	je     800d6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3b:	eb 16                	jmp    800d53 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8d 50 01             	lea    0x1(%eax),%edx
  800d43:	89 55 08             	mov    %edx,0x8(%ebp)
  800d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4f:	8a 12                	mov    (%edx),%dl
  800d51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d53:	ff 4d 10             	decl   0x10(%ebp)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 09                	je     800d65 <strlcpy+0x3c>
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 d8                	jne    800d3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d71:	29 c2                	sub    %eax,%edx
  800d73:	89 d0                	mov    %edx,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d7a:	eb 06                	jmp    800d82 <strcmp+0xb>
		p++, q++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	84 c0                	test   %al,%al
  800d89:	74 0e                	je     800d99 <strcmp+0x22>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 10                	mov    (%eax),%dl
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	38 c2                	cmp    %al,%dl
  800d97:	74 e3                	je     800d7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	0f b6 d0             	movzbl %al,%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	29 c2                	sub    %eax,%edx
  800dab:	89 d0                	mov    %edx,%eax
}
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db2:	eb 09                	jmp    800dbd <strncmp+0xe>
		n--, p++, q++;
  800db4:	ff 4d 10             	decl   0x10(%ebp)
  800db7:	ff 45 08             	incl   0x8(%ebp)
  800dba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	74 17                	je     800dda <strncmp+0x2b>
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	84 c0                	test   %al,%al
  800dca:	74 0e                	je     800dda <strncmp+0x2b>
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 10                	mov    (%eax),%dl
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	38 c2                	cmp    %al,%dl
  800dd8:	74 da                	je     800db4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dde:	75 07                	jne    800de7 <strncmp+0x38>
		return 0;
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	eb 14                	jmp    800dfb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 04             	sub    $0x4,%esp
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e09:	eb 12                	jmp    800e1d <strchr+0x20>
		if (*s == c)
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e13:	75 05                	jne    800e1a <strchr+0x1d>
			return (char *) s;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	eb 11                	jmp    800e2b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 e5                	jne    800e0b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e39:	eb 0d                	jmp    800e48 <strfind+0x1b>
		if (*s == c)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e43:	74 0e                	je     800e53 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e45:	ff 45 08             	incl   0x8(%ebp)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	84 c0                	test   %al,%al
  800e4f:	75 ea                	jne    800e3b <strfind+0xe>
  800e51:	eb 01                	jmp    800e54 <strfind+0x27>
		if (*s == c)
			break;
  800e53:	90                   	nop
	return (char *) s;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x22>
		*p++ = c;
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e82:	79 e9                	jns    800e6d <memset+0x14>
		*p++ = c;

	return v;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e9b:	eb 16                	jmp    800eb3 <memcpy+0x2a>
		*d++ = *s++;
  800e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea0:	8d 50 01             	lea    0x1(%eax),%edx
  800ea3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eaf:	8a 12                	mov    (%edx),%dl
  800eb1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	75 dd                	jne    800e9d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edd:	73 50                	jae    800f2f <memmove+0x6a>
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 d0                	add    %edx,%eax
  800ee7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eea:	76 43                	jbe    800f2f <memmove+0x6a>
		s += n;
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef8:	eb 10                	jmp    800f0a <memmove+0x45>
			*--d = *--s;
  800efa:	ff 4d f8             	decl   -0x8(%ebp)
  800efd:	ff 4d fc             	decl   -0x4(%ebp)
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f10:	89 55 10             	mov    %edx,0x10(%ebp)
  800f13:	85 c0                	test   %eax,%eax
  800f15:	75 e3                	jne    800efa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f17:	eb 23                	jmp    800f3c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f35:	89 55 10             	mov    %edx,0x10(%ebp)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	75 dd                	jne    800f19 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f53:	eb 2a                	jmp    800f7f <memcmp+0x3e>
		if (*s1 != *s2)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	38 c2                	cmp    %al,%dl
  800f61:	74 16                	je     800f79 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f b6 d0             	movzbl %al,%edx
  800f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	0f b6 c0             	movzbl %al,%eax
  800f73:	29 c2                	sub    %eax,%edx
  800f75:	89 d0                	mov    %edx,%eax
  800f77:	eb 18                	jmp    800f91 <memcmp+0x50>
		s1++, s2++;
  800f79:	ff 45 fc             	incl   -0x4(%ebp)
  800f7c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f85:	89 55 10             	mov    %edx,0x10(%ebp)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	75 c9                	jne    800f55 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa4:	eb 15                	jmp    800fbb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f b6 d0             	movzbl %al,%edx
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	39 c2                	cmp    %eax,%edx
  800fb6:	74 0d                	je     800fc5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb8:	ff 45 08             	incl   0x8(%ebp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc1:	72 e3                	jb     800fa6 <memfind+0x13>
  800fc3:	eb 01                	jmp    800fc6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc5:	90                   	nop
	return (void *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdf:	eb 03                	jmp    800fe4 <strtol+0x19>
		s++;
  800fe1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 20                	cmp    $0x20,%al
  800feb:	74 f4                	je     800fe1 <strtol+0x16>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 09                	cmp    $0x9,%al
  800ff4:	74 eb                	je     800fe1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 2b                	cmp    $0x2b,%al
  800ffd:	75 05                	jne    801004 <strtol+0x39>
		s++;
  800fff:	ff 45 08             	incl   0x8(%ebp)
  801002:	eb 13                	jmp    801017 <strtol+0x4c>
	else if (*s == '-')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2d                	cmp    $0x2d,%al
  80100b:	75 0a                	jne    801017 <strtol+0x4c>
		s++, neg = 1;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101b:	74 06                	je     801023 <strtol+0x58>
  80101d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801021:	75 20                	jne    801043 <strtol+0x78>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 30                	cmp    $0x30,%al
  80102a:	75 17                	jne    801043 <strtol+0x78>
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	40                   	inc    %eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 78                	cmp    $0x78,%al
  801034:	75 0d                	jne    801043 <strtol+0x78>
		s += 2, base = 16;
  801036:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80103a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801041:	eb 28                	jmp    80106b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	75 15                	jne    80105e <strtol+0x93>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 30                	cmp    $0x30,%al
  801050:	75 0c                	jne    80105e <strtol+0x93>
		s++, base = 8;
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80105c:	eb 0d                	jmp    80106b <strtol+0xa0>
	else if (base == 0)
  80105e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801062:	75 07                	jne    80106b <strtol+0xa0>
		base = 10;
  801064:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 2f                	cmp    $0x2f,%al
  801072:	7e 19                	jle    80108d <strtol+0xc2>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 39                	cmp    $0x39,%al
  80107b:	7f 10                	jg     80108d <strtol+0xc2>
			dig = *s - '0';
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f be c0             	movsbl %al,%eax
  801085:	83 e8 30             	sub    $0x30,%eax
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108b:	eb 42                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 60                	cmp    $0x60,%al
  801094:	7e 19                	jle    8010af <strtol+0xe4>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 7a                	cmp    $0x7a,%al
  80109d:	7f 10                	jg     8010af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	83 e8 57             	sub    $0x57,%eax
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ad:	eb 20                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 40                	cmp    $0x40,%al
  8010b6:	7e 39                	jle    8010f1 <strtol+0x126>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 5a                	cmp    $0x5a,%al
  8010bf:	7f 30                	jg     8010f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f be c0             	movsbl %al,%eax
  8010c9:	83 e8 37             	sub    $0x37,%eax
  8010cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d5:	7d 19                	jge    8010f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d7:	ff 45 08             	incl   0x8(%ebp)
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e6:	01 d0                	add    %edx,%eax
  8010e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010eb:	e9 7b ff ff ff       	jmp    80106b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f5:	74 08                	je     8010ff <strtol+0x134>
		*endptr = (char *) s;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801103:	74 07                	je     80110c <strtol+0x141>
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801108:	f7 d8                	neg    %eax
  80110a:	eb 03                	jmp    80110f <strtol+0x144>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <ltostr>:

void
ltostr(long value, char *str)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80111e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801129:	79 13                	jns    80113e <ltostr+0x2d>
	{
		neg = 1;
  80112b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801138:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80113b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801146:	99                   	cltd   
  801147:	f7 f9                	idiv   %ecx
  801149:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114f:	8d 50 01             	lea    0x1(%eax),%edx
  801152:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801155:	89 c2                	mov    %eax,%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 d0                	add    %edx,%eax
  80115c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115f:	83 c2 30             	add    $0x30,%edx
  801162:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801167:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116c:	f7 e9                	imul   %ecx
  80116e:	c1 fa 02             	sar    $0x2,%edx
  801171:	89 c8                	mov    %ecx,%eax
  801173:	c1 f8 1f             	sar    $0x1f,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
  80117a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80117d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801180:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801185:	f7 e9                	imul   %ecx
  801187:	c1 fa 02             	sar    $0x2,%edx
  80118a:	89 c8                	mov    %ecx,%eax
  80118c:	c1 f8 1f             	sar    $0x1f,%eax
  80118f:	29 c2                	sub    %eax,%edx
  801191:	89 d0                	mov    %edx,%eax
  801193:	c1 e0 02             	shl    $0x2,%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	01 c0                	add    %eax,%eax
  80119a:	29 c1                	sub    %eax,%ecx
  80119c:	89 ca                	mov    %ecx,%edx
  80119e:	85 d2                	test   %edx,%edx
  8011a0:	75 9c                	jne    80113e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	48                   	dec    %eax
  8011ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b4:	74 3d                	je     8011f3 <ltostr+0xe2>
		start = 1 ;
  8011b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011bd:	eb 34                	jmp    8011f3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 c2                	add    %eax,%edx
  8011d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	01 c8                	add    %ecx,%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011eb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011ed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f9:	7c c4                	jl     8011bf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801206:	90                   	nop
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	e8 54 fa ff ff       	call   800c6b <strlen>
  801217:	83 c4 04             	add    $0x4,%esp
  80121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 46 fa ff ff       	call   800c6b <strlen>
  801225:	83 c4 04             	add    $0x4,%esp
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80122b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801239:	eb 17                	jmp    801252 <strcconcat+0x49>
		final[s] = str1[s] ;
  80123b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	01 c8                	add    %ecx,%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80124f:	ff 45 fc             	incl   -0x4(%ebp)
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801258:	7c e1                	jl     80123b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80125a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801261:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801268:	eb 1f                	jmp    801289 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80126a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126d:	8d 50 01             	lea    0x1(%eax),%edx
  801270:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801273:	89 c2                	mov    %eax,%edx
  801275:	8b 45 10             	mov    0x10(%ebp),%eax
  801278:	01 c2                	add    %eax,%edx
  80127a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c8                	add    %ecx,%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801286:	ff 45 f8             	incl   -0x8(%ebp)
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80128f:	7c d9                	jl     80126a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	c6 00 00             	movb   $0x0,(%eax)
}
  80129c:	90                   	nop
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ae:	8b 00                	mov    (%eax),%eax
  8012b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c2:	eb 0c                	jmp    8012d0 <strsplit+0x31>
			*string++ = 0;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8012cd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	74 18                	je     8012f1 <strsplit+0x52>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 13 fb ff ff       	call   800dfd <strchr>
  8012ea:	83 c4 08             	add    $0x8,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	75 d3                	jne    8012c4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 5a                	je     801354 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	83 f8 0f             	cmp    $0xf,%eax
  801302:	75 07                	jne    80130b <strsplit+0x6c>
		{
			return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
  801309:	eb 66                	jmp    801371 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80130b:	8b 45 14             	mov    0x14(%ebp),%eax
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	8d 48 01             	lea    0x1(%eax),%ecx
  801313:	8b 55 14             	mov    0x14(%ebp),%edx
  801316:	89 0a                	mov    %ecx,(%edx)
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 c2                	add    %eax,%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801329:	eb 03                	jmp    80132e <strsplit+0x8f>
			string++;
  80132b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	84 c0                	test   %al,%al
  801335:	74 8b                	je     8012c2 <strsplit+0x23>
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f be c0             	movsbl %al,%eax
  80133f:	50                   	push   %eax
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	e8 b5 fa ff ff       	call   800dfd <strchr>
  801348:	83 c4 08             	add    $0x8,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	74 dc                	je     80132b <strsplit+0x8c>
			string++;
	}
  80134f:	e9 6e ff ff ff       	jmp    8012c2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801354:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80136c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801379:	a1 04 40 80 00       	mov    0x804004,%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	74 1f                	je     8013a1 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801382:	e8 1d 00 00 00       	call   8013a4 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	68 b0 3a 80 00       	push   $0x803ab0
  80138f:	e8 55 f2 ff ff       	call   8005e9 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801397:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80139e:	00 00 00 
	}
}
  8013a1:	90                   	nop
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  8013aa:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013b1:	00 00 00 
  8013b4:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013bb:	00 00 00 
  8013be:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013c5:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8013c8:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013cf:	00 00 00 
  8013d2:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013d9:	00 00 00 
  8013dc:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013e3:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8013e6:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013ed:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8013f0:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013ff:	2d 00 10 00 00       	sub    $0x1000,%eax
  801404:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801409:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801410:	a1 20 41 80 00       	mov    0x804120,%eax
  801415:	c1 e0 04             	shl    $0x4,%eax
  801418:	89 c2                	mov    %eax,%edx
  80141a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141d:	01 d0                	add    %edx,%eax
  80141f:	48                   	dec    %eax
  801420:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801426:	ba 00 00 00 00       	mov    $0x0,%edx
  80142b:	f7 75 f0             	divl   -0x10(%ebp)
  80142e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801431:	29 d0                	sub    %edx,%eax
  801433:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801436:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80143d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801440:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801445:	2d 00 10 00 00       	sub    $0x1000,%eax
  80144a:	83 ec 04             	sub    $0x4,%esp
  80144d:	6a 06                	push   $0x6
  80144f:	ff 75 e8             	pushl  -0x18(%ebp)
  801452:	50                   	push   %eax
  801453:	e8 b0 05 00 00       	call   801a08 <sys_allocate_chunk>
  801458:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80145b:	a1 20 41 80 00       	mov    0x804120,%eax
  801460:	83 ec 0c             	sub    $0xc,%esp
  801463:	50                   	push   %eax
  801464:	e8 25 0c 00 00       	call   80208e <initialize_MemBlocksList>
  801469:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  80146c:	a1 48 41 80 00       	mov    0x804148,%eax
  801471:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801474:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801478:	75 14                	jne    80148e <initialize_dyn_block_system+0xea>
  80147a:	83 ec 04             	sub    $0x4,%esp
  80147d:	68 d5 3a 80 00       	push   $0x803ad5
  801482:	6a 29                	push   $0x29
  801484:	68 f3 3a 80 00       	push   $0x803af3
  801489:	e8 a7 ee ff ff       	call   800335 <_panic>
  80148e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801491:	8b 00                	mov    (%eax),%eax
  801493:	85 c0                	test   %eax,%eax
  801495:	74 10                	je     8014a7 <initialize_dyn_block_system+0x103>
  801497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80149f:	8b 52 04             	mov    0x4(%edx),%edx
  8014a2:	89 50 04             	mov    %edx,0x4(%eax)
  8014a5:	eb 0b                	jmp    8014b2 <initialize_dyn_block_system+0x10e>
  8014a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014aa:	8b 40 04             	mov    0x4(%eax),%eax
  8014ad:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b5:	8b 40 04             	mov    0x4(%eax),%eax
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	74 0f                	je     8014cb <initialize_dyn_block_system+0x127>
  8014bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014bf:	8b 40 04             	mov    0x4(%eax),%eax
  8014c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014c5:	8b 12                	mov    (%edx),%edx
  8014c7:	89 10                	mov    %edx,(%eax)
  8014c9:	eb 0a                	jmp    8014d5 <initialize_dyn_block_system+0x131>
  8014cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ce:	8b 00                	mov    (%eax),%eax
  8014d0:	a3 48 41 80 00       	mov    %eax,0x804148
  8014d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014e8:	a1 54 41 80 00       	mov    0x804154,%eax
  8014ed:	48                   	dec    %eax
  8014ee:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  8014f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f6:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8014fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801500:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801507:	83 ec 0c             	sub    $0xc,%esp
  80150a:	ff 75 e0             	pushl  -0x20(%ebp)
  80150d:	e8 b9 14 00 00       	call   8029cb <insert_sorted_with_merge_freeList>
  801512:	83 c4 10             	add    $0x10,%esp

}
  801515:	90                   	nop
  801516:	c9                   	leave  
  801517:	c3                   	ret    

00801518 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801518:	55                   	push   %ebp
  801519:	89 e5                	mov    %esp,%ebp
  80151b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80151e:	e8 50 fe ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  801523:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801527:	75 07                	jne    801530 <malloc+0x18>
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
  80152e:	eb 68                	jmp    801598 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801530:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801537:	8b 55 08             	mov    0x8(%ebp),%edx
  80153a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153d:	01 d0                	add    %edx,%eax
  80153f:	48                   	dec    %eax
  801540:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801543:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801546:	ba 00 00 00 00       	mov    $0x0,%edx
  80154b:	f7 75 f4             	divl   -0xc(%ebp)
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	29 d0                	sub    %edx,%eax
  801553:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801556:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80155d:	e8 74 08 00 00       	call   801dd6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801562:	85 c0                	test   %eax,%eax
  801564:	74 2d                	je     801593 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801566:	83 ec 0c             	sub    $0xc,%esp
  801569:	ff 75 ec             	pushl  -0x14(%ebp)
  80156c:	e8 52 0e 00 00       	call   8023c3 <alloc_block_FF>
  801571:	83 c4 10             	add    $0x10,%esp
  801574:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801577:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80157b:	74 16                	je     801593 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  80157d:	83 ec 0c             	sub    $0xc,%esp
  801580:	ff 75 e8             	pushl  -0x18(%ebp)
  801583:	e8 3b 0c 00 00       	call   8021c3 <insert_sorted_allocList>
  801588:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80158b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80158e:	8b 40 08             	mov    0x8(%eax),%eax
  801591:	eb 05                	jmp    801598 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801593:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801598:	c9                   	leave  
  801599:	c3                   	ret    

0080159a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80159a:	55                   	push   %ebp
  80159b:	89 e5                	mov    %esp,%ebp
  80159d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8015a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a3:	83 ec 08             	sub    $0x8,%esp
  8015a6:	50                   	push   %eax
  8015a7:	68 40 40 80 00       	push   $0x804040
  8015ac:	e8 ba 0b 00 00       	call   80216b <find_block>
  8015b1:	83 c4 10             	add    $0x10,%esp
  8015b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  8015b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ba:	8b 40 0c             	mov    0xc(%eax),%eax
  8015bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8015c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015c4:	0f 84 9f 00 00 00    	je     801669 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  8015ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cd:	83 ec 08             	sub    $0x8,%esp
  8015d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8015d3:	50                   	push   %eax
  8015d4:	e8 f7 03 00 00       	call   8019d0 <sys_free_user_mem>
  8015d9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  8015dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015e0:	75 14                	jne    8015f6 <free+0x5c>
  8015e2:	83 ec 04             	sub    $0x4,%esp
  8015e5:	68 d5 3a 80 00       	push   $0x803ad5
  8015ea:	6a 6a                	push   $0x6a
  8015ec:	68 f3 3a 80 00       	push   $0x803af3
  8015f1:	e8 3f ed ff ff       	call   800335 <_panic>
  8015f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f9:	8b 00                	mov    (%eax),%eax
  8015fb:	85 c0                	test   %eax,%eax
  8015fd:	74 10                	je     80160f <free+0x75>
  8015ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801602:	8b 00                	mov    (%eax),%eax
  801604:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801607:	8b 52 04             	mov    0x4(%edx),%edx
  80160a:	89 50 04             	mov    %edx,0x4(%eax)
  80160d:	eb 0b                	jmp    80161a <free+0x80>
  80160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801612:	8b 40 04             	mov    0x4(%eax),%eax
  801615:	a3 44 40 80 00       	mov    %eax,0x804044
  80161a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161d:	8b 40 04             	mov    0x4(%eax),%eax
  801620:	85 c0                	test   %eax,%eax
  801622:	74 0f                	je     801633 <free+0x99>
  801624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801627:	8b 40 04             	mov    0x4(%eax),%eax
  80162a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162d:	8b 12                	mov    (%edx),%edx
  80162f:	89 10                	mov    %edx,(%eax)
  801631:	eb 0a                	jmp    80163d <free+0xa3>
  801633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801636:	8b 00                	mov    (%eax),%eax
  801638:	a3 40 40 80 00       	mov    %eax,0x804040
  80163d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801640:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801649:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801650:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801655:	48                   	dec    %eax
  801656:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  80165b:	83 ec 0c             	sub    $0xc,%esp
  80165e:	ff 75 f4             	pushl  -0xc(%ebp)
  801661:	e8 65 13 00 00       	call   8029cb <insert_sorted_with_merge_freeList>
  801666:	83 c4 10             	add    $0x10,%esp
	}
}
  801669:	90                   	nop
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 28             	sub    $0x28,%esp
  801672:	8b 45 10             	mov    0x10(%ebp),%eax
  801675:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801678:	e8 f6 fc ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  80167d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801681:	75 0a                	jne    80168d <smalloc+0x21>
  801683:	b8 00 00 00 00       	mov    $0x0,%eax
  801688:	e9 af 00 00 00       	jmp    80173c <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80168d:	e8 44 07 00 00       	call   801dd6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801692:	83 f8 01             	cmp    $0x1,%eax
  801695:	0f 85 9c 00 00 00    	jne    801737 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80169b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a8:	01 d0                	add    %edx,%eax
  8016aa:	48                   	dec    %eax
  8016ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b6:	f7 75 f4             	divl   -0xc(%ebp)
  8016b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bc:	29 d0                	sub    %edx,%eax
  8016be:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8016c1:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  8016c8:	76 07                	jbe    8016d1 <smalloc+0x65>
			return NULL;
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cf:	eb 6b                	jmp    80173c <smalloc+0xd0>
		blk =alloc_block_FF(size);
  8016d1:	83 ec 0c             	sub    $0xc,%esp
  8016d4:	ff 75 0c             	pushl  0xc(%ebp)
  8016d7:	e8 e7 0c 00 00       	call   8023c3 <alloc_block_FF>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  8016e2:	83 ec 0c             	sub    $0xc,%esp
  8016e5:	ff 75 ec             	pushl  -0x14(%ebp)
  8016e8:	e8 d6 0a 00 00       	call   8021c3 <insert_sorted_allocList>
  8016ed:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8016f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016f4:	75 07                	jne    8016fd <smalloc+0x91>
		{
			return NULL;
  8016f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fb:	eb 3f                	jmp    80173c <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8016fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801700:	8b 40 08             	mov    0x8(%eax),%eax
  801703:	89 c2                	mov    %eax,%edx
  801705:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801709:	52                   	push   %edx
  80170a:	50                   	push   %eax
  80170b:	ff 75 0c             	pushl  0xc(%ebp)
  80170e:	ff 75 08             	pushl  0x8(%ebp)
  801711:	e8 45 04 00 00       	call   801b5b <sys_createSharedObject>
  801716:	83 c4 10             	add    $0x10,%esp
  801719:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  80171c:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801720:	74 06                	je     801728 <smalloc+0xbc>
  801722:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801726:	75 07                	jne    80172f <smalloc+0xc3>
		{
			return NULL;
  801728:	b8 00 00 00 00       	mov    $0x0,%eax
  80172d:	eb 0d                	jmp    80173c <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  80172f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801732:	8b 40 08             	mov    0x8(%eax),%eax
  801735:	eb 05                	jmp    80173c <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
  801741:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801744:	e8 2a fc ff ff       	call   801373 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801749:	83 ec 08             	sub    $0x8,%esp
  80174c:	ff 75 0c             	pushl  0xc(%ebp)
  80174f:	ff 75 08             	pushl  0x8(%ebp)
  801752:	e8 2e 04 00 00       	call   801b85 <sys_getSizeOfSharedObject>
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  80175d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801761:	75 0a                	jne    80176d <sget+0x2f>
	{
		return NULL;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	e9 94 00 00 00       	jmp    801801 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80176d:	e8 64 06 00 00       	call   801dd6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801772:	85 c0                	test   %eax,%eax
  801774:	0f 84 82 00 00 00    	je     8017fc <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  80177a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801781:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801788:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178e:	01 d0                	add    %edx,%eax
  801790:	48                   	dec    %eax
  801791:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801794:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801797:	ba 00 00 00 00       	mov    $0x0,%edx
  80179c:	f7 75 ec             	divl   -0x14(%ebp)
  80179f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017a2:	29 d0                	sub    %edx,%eax
  8017a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  8017a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017aa:	83 ec 0c             	sub    $0xc,%esp
  8017ad:	50                   	push   %eax
  8017ae:	e8 10 0c 00 00       	call   8023c3 <alloc_block_FF>
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  8017b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017bd:	75 07                	jne    8017c6 <sget+0x88>
		{
			return NULL;
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	eb 3b                	jmp    801801 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8017c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c9:	8b 40 08             	mov    0x8(%eax),%eax
  8017cc:	83 ec 04             	sub    $0x4,%esp
  8017cf:	50                   	push   %eax
  8017d0:	ff 75 0c             	pushl  0xc(%ebp)
  8017d3:	ff 75 08             	pushl  0x8(%ebp)
  8017d6:	e8 c7 03 00 00       	call   801ba2 <sys_getSharedObject>
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  8017e1:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8017e5:	74 06                	je     8017ed <sget+0xaf>
  8017e7:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8017eb:	75 07                	jne    8017f4 <sget+0xb6>
		{
			return NULL;
  8017ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f2:	eb 0d                	jmp    801801 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8017f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f7:	8b 40 08             	mov    0x8(%eax),%eax
  8017fa:	eb 05                	jmp    801801 <sget+0xc3>
		}
	}
	else
			return NULL;
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801809:	e8 65 fb ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 00 3b 80 00       	push   $0x803b00
  801816:	68 e1 00 00 00       	push   $0xe1
  80181b:	68 f3 3a 80 00       	push   $0x803af3
  801820:	e8 10 eb ff ff       	call   800335 <_panic>

00801825 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 28 3b 80 00       	push   $0x803b28
  801833:	68 f5 00 00 00       	push   $0xf5
  801838:	68 f3 3a 80 00       	push   $0x803af3
  80183d:	e8 f3 ea ff ff       	call   800335 <_panic>

00801842 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	68 4c 3b 80 00       	push   $0x803b4c
  801850:	68 00 01 00 00       	push   $0x100
  801855:	68 f3 3a 80 00       	push   $0x803af3
  80185a:	e8 d6 ea ff ff       	call   800335 <_panic>

0080185f <shrink>:

}
void shrink(uint32 newSize)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	68 4c 3b 80 00       	push   $0x803b4c
  80186d:	68 05 01 00 00       	push   $0x105
  801872:	68 f3 3a 80 00       	push   $0x803af3
  801877:	e8 b9 ea ff ff       	call   800335 <_panic>

0080187c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	68 4c 3b 80 00       	push   $0x803b4c
  80188a:	68 0a 01 00 00       	push   $0x10a
  80188f:	68 f3 3a 80 00       	push   $0x803af3
  801894:	e8 9c ea ff ff       	call   800335 <_panic>

00801899 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	57                   	push   %edi
  80189d:	56                   	push   %esi
  80189e:	53                   	push   %ebx
  80189f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018ab:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018ae:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018b1:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018b4:	cd 30                	int    $0x30
  8018b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018bc:	83 c4 10             	add    $0x10,%esp
  8018bf:	5b                   	pop    %ebx
  8018c0:	5e                   	pop    %esi
  8018c1:	5f                   	pop    %edi
  8018c2:	5d                   	pop    %ebp
  8018c3:	c3                   	ret    

008018c4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 04             	sub    $0x4,%esp
  8018ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8018cd:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018d0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	52                   	push   %edx
  8018dc:	ff 75 0c             	pushl  0xc(%ebp)
  8018df:	50                   	push   %eax
  8018e0:	6a 00                	push   $0x0
  8018e2:	e8 b2 ff ff ff       	call   801899 <syscall>
  8018e7:	83 c4 18             	add    $0x18,%esp
}
  8018ea:	90                   	nop
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    

008018ed <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 01                	push   $0x1
  8018fc:	e8 98 ff ff ff       	call   801899 <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801909:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
  80190f:	6a 00                	push   $0x0
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	52                   	push   %edx
  801916:	50                   	push   %eax
  801917:	6a 05                	push   $0x5
  801919:	e8 7b ff ff ff       	call   801899 <syscall>
  80191e:	83 c4 18             	add    $0x18,%esp
}
  801921:	c9                   	leave  
  801922:	c3                   	ret    

00801923 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801923:	55                   	push   %ebp
  801924:	89 e5                	mov    %esp,%ebp
  801926:	56                   	push   %esi
  801927:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801928:	8b 75 18             	mov    0x18(%ebp),%esi
  80192b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801931:	8b 55 0c             	mov    0xc(%ebp),%edx
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	56                   	push   %esi
  801938:	53                   	push   %ebx
  801939:	51                   	push   %ecx
  80193a:	52                   	push   %edx
  80193b:	50                   	push   %eax
  80193c:	6a 06                	push   $0x6
  80193e:	e8 56 ff ff ff       	call   801899 <syscall>
  801943:	83 c4 18             	add    $0x18,%esp
}
  801946:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801949:	5b                   	pop    %ebx
  80194a:	5e                   	pop    %esi
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801950:	8b 55 0c             	mov    0xc(%ebp),%edx
  801953:	8b 45 08             	mov    0x8(%ebp),%eax
  801956:	6a 00                	push   $0x0
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	52                   	push   %edx
  80195d:	50                   	push   %eax
  80195e:	6a 07                	push   $0x7
  801960:	e8 34 ff ff ff       	call   801899 <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	ff 75 0c             	pushl  0xc(%ebp)
  801976:	ff 75 08             	pushl  0x8(%ebp)
  801979:	6a 08                	push   $0x8
  80197b:	e8 19 ff ff ff       	call   801899 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	c9                   	leave  
  801984:	c3                   	ret    

00801985 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 09                	push   $0x9
  801994:	e8 00 ff ff ff       	call   801899 <syscall>
  801999:	83 c4 18             	add    $0x18,%esp
}
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 0a                	push   $0xa
  8019ad:	e8 e7 fe ff ff       	call   801899 <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 0b                	push   $0xb
  8019c6:	e8 ce fe ff ff       	call   801899 <syscall>
  8019cb:	83 c4 18             	add    $0x18,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	ff 75 08             	pushl  0x8(%ebp)
  8019df:	6a 0f                	push   $0xf
  8019e1:	e8 b3 fe ff ff       	call   801899 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
	return;
  8019e9:	90                   	nop
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	6a 10                	push   $0x10
  8019fd:	e8 97 fe ff ff       	call   801899 <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return ;
  801a05:	90                   	nop
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	ff 75 10             	pushl  0x10(%ebp)
  801a12:	ff 75 0c             	pushl  0xc(%ebp)
  801a15:	ff 75 08             	pushl  0x8(%ebp)
  801a18:	6a 11                	push   $0x11
  801a1a:	e8 7a fe ff ff       	call   801899 <syscall>
  801a1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a22:	90                   	nop
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 0c                	push   $0xc
  801a34:	e8 60 fe ff ff       	call   801899 <syscall>
  801a39:	83 c4 18             	add    $0x18,%esp
}
  801a3c:	c9                   	leave  
  801a3d:	c3                   	ret    

00801a3e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	ff 75 08             	pushl  0x8(%ebp)
  801a4c:	6a 0d                	push   $0xd
  801a4e:	e8 46 fe ff ff       	call   801899 <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 0e                	push   $0xe
  801a67:	e8 2d fe ff ff       	call   801899 <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	90                   	nop
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 13                	push   $0x13
  801a81:	e8 13 fe ff ff       	call   801899 <syscall>
  801a86:	83 c4 18             	add    $0x18,%esp
}
  801a89:	90                   	nop
  801a8a:	c9                   	leave  
  801a8b:	c3                   	ret    

00801a8c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 14                	push   $0x14
  801a9b:	e8 f9 fd ff ff       	call   801899 <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
}
  801aa3:	90                   	nop
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_cputc>:


void
sys_cputc(const char c)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
  801aa9:	83 ec 04             	sub    $0x4,%esp
  801aac:	8b 45 08             	mov    0x8(%ebp),%eax
  801aaf:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ab2:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	50                   	push   %eax
  801abf:	6a 15                	push   $0x15
  801ac1:	e8 d3 fd ff ff       	call   801899 <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	90                   	nop
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 16                	push   $0x16
  801adb:	e8 b9 fd ff ff       	call   801899 <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	90                   	nop
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	50                   	push   %eax
  801af6:	6a 17                	push   $0x17
  801af8:	e8 9c fd ff ff       	call   801899 <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	52                   	push   %edx
  801b12:	50                   	push   %eax
  801b13:	6a 1a                	push   $0x1a
  801b15:	e8 7f fd ff ff       	call   801899 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	c9                   	leave  
  801b1e:	c3                   	ret    

00801b1f <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b25:	8b 45 08             	mov    0x8(%ebp),%eax
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	52                   	push   %edx
  801b2f:	50                   	push   %eax
  801b30:	6a 18                	push   $0x18
  801b32:	e8 62 fd ff ff       	call   801899 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	90                   	nop
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    

00801b3d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	52                   	push   %edx
  801b4d:	50                   	push   %eax
  801b4e:	6a 19                	push   $0x19
  801b50:	e8 44 fd ff ff       	call   801899 <syscall>
  801b55:	83 c4 18             	add    $0x18,%esp
}
  801b58:	90                   	nop
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 04             	sub    $0x4,%esp
  801b61:	8b 45 10             	mov    0x10(%ebp),%eax
  801b64:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b67:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b6a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	6a 00                	push   $0x0
  801b73:	51                   	push   %ecx
  801b74:	52                   	push   %edx
  801b75:	ff 75 0c             	pushl  0xc(%ebp)
  801b78:	50                   	push   %eax
  801b79:	6a 1b                	push   $0x1b
  801b7b:	e8 19 fd ff ff       	call   801899 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	52                   	push   %edx
  801b95:	50                   	push   %eax
  801b96:	6a 1c                	push   $0x1c
  801b98:	e8 fc fc ff ff       	call   801899 <syscall>
  801b9d:	83 c4 18             	add    $0x18,%esp
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ba5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	51                   	push   %ecx
  801bb3:	52                   	push   %edx
  801bb4:	50                   	push   %eax
  801bb5:	6a 1d                	push   $0x1d
  801bb7:	e8 dd fc ff ff       	call   801899 <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	52                   	push   %edx
  801bd1:	50                   	push   %eax
  801bd2:	6a 1e                	push   $0x1e
  801bd4:	e8 c0 fc ff ff       	call   801899 <syscall>
  801bd9:	83 c4 18             	add    $0x18,%esp
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 1f                	push   $0x1f
  801bed:	e8 a7 fc ff ff       	call   801899 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	6a 00                	push   $0x0
  801bff:	ff 75 14             	pushl  0x14(%ebp)
  801c02:	ff 75 10             	pushl  0x10(%ebp)
  801c05:	ff 75 0c             	pushl  0xc(%ebp)
  801c08:	50                   	push   %eax
  801c09:	6a 20                	push   $0x20
  801c0b:	e8 89 fc ff ff       	call   801899 <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c18:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	50                   	push   %eax
  801c24:	6a 21                	push   $0x21
  801c26:	e8 6e fc ff ff       	call   801899 <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	90                   	nop
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	6a 00                	push   $0x0
  801c3d:	6a 00                	push   $0x0
  801c3f:	50                   	push   %eax
  801c40:	6a 22                	push   $0x22
  801c42:	e8 52 fc ff ff       	call   801899 <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 02                	push   $0x2
  801c5b:	e8 39 fc ff ff       	call   801899 <syscall>
  801c60:	83 c4 18             	add    $0x18,%esp
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 03                	push   $0x3
  801c74:	e8 20 fc ff ff       	call   801899 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 04                	push   $0x4
  801c8d:	e8 07 fc ff ff       	call   801899 <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_exit_env>:


void sys_exit_env(void)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 23                	push   $0x23
  801ca6:	e8 ee fb ff ff       	call   801899 <syscall>
  801cab:	83 c4 18             	add    $0x18,%esp
}
  801cae:	90                   	nop
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cb7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cba:	8d 50 04             	lea    0x4(%eax),%edx
  801cbd:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	52                   	push   %edx
  801cc7:	50                   	push   %eax
  801cc8:	6a 24                	push   $0x24
  801cca:	e8 ca fb ff ff       	call   801899 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
	return result;
  801cd2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cdb:	89 01                	mov    %eax,(%ecx)
  801cdd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	c9                   	leave  
  801ce4:	c2 04 00             	ret    $0x4

00801ce7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	ff 75 10             	pushl  0x10(%ebp)
  801cf1:	ff 75 0c             	pushl  0xc(%ebp)
  801cf4:	ff 75 08             	pushl  0x8(%ebp)
  801cf7:	6a 12                	push   $0x12
  801cf9:	e8 9b fb ff ff       	call   801899 <syscall>
  801cfe:	83 c4 18             	add    $0x18,%esp
	return ;
  801d01:	90                   	nop
}
  801d02:	c9                   	leave  
  801d03:	c3                   	ret    

00801d04 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d04:	55                   	push   %ebp
  801d05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 25                	push   $0x25
  801d13:	e8 81 fb ff ff       	call   801899 <syscall>
  801d18:	83 c4 18             	add    $0x18,%esp
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 04             	sub    $0x4,%esp
  801d23:	8b 45 08             	mov    0x8(%ebp),%eax
  801d26:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d29:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	50                   	push   %eax
  801d36:	6a 26                	push   $0x26
  801d38:	e8 5c fb ff ff       	call   801899 <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d40:	90                   	nop
}
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <rsttst>:
void rsttst()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 00                	push   $0x0
  801d50:	6a 28                	push   $0x28
  801d52:	e8 42 fb ff ff       	call   801899 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5a:	90                   	nop
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	83 ec 04             	sub    $0x4,%esp
  801d63:	8b 45 14             	mov    0x14(%ebp),%eax
  801d66:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d69:	8b 55 18             	mov    0x18(%ebp),%edx
  801d6c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d70:	52                   	push   %edx
  801d71:	50                   	push   %eax
  801d72:	ff 75 10             	pushl  0x10(%ebp)
  801d75:	ff 75 0c             	pushl  0xc(%ebp)
  801d78:	ff 75 08             	pushl  0x8(%ebp)
  801d7b:	6a 27                	push   $0x27
  801d7d:	e8 17 fb ff ff       	call   801899 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
	return ;
  801d85:	90                   	nop
}
  801d86:	c9                   	leave  
  801d87:	c3                   	ret    

00801d88 <chktst>:
void chktst(uint32 n)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	ff 75 08             	pushl  0x8(%ebp)
  801d96:	6a 29                	push   $0x29
  801d98:	e8 fc fa ff ff       	call   801899 <syscall>
  801d9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801da0:	90                   	nop
}
  801da1:	c9                   	leave  
  801da2:	c3                   	ret    

00801da3 <inctst>:

void inctst()
{
  801da3:	55                   	push   %ebp
  801da4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 2a                	push   $0x2a
  801db2:	e8 e2 fa ff ff       	call   801899 <syscall>
  801db7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dba:	90                   	nop
}
  801dbb:	c9                   	leave  
  801dbc:	c3                   	ret    

00801dbd <gettst>:
uint32 gettst()
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 00                	push   $0x0
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 2b                	push   $0x2b
  801dcc:	e8 c8 fa ff ff       	call   801899 <syscall>
  801dd1:	83 c4 18             	add    $0x18,%esp
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 2c                	push   $0x2c
  801de8:	e8 ac fa ff ff       	call   801899 <syscall>
  801ded:	83 c4 18             	add    $0x18,%esp
  801df0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801df3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801df7:	75 07                	jne    801e00 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfe:	eb 05                	jmp    801e05 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e00:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e05:	c9                   	leave  
  801e06:	c3                   	ret    

00801e07 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e07:	55                   	push   %ebp
  801e08:	89 e5                	mov    %esp,%ebp
  801e0a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 00                	push   $0x0
  801e15:	6a 00                	push   $0x0
  801e17:	6a 2c                	push   $0x2c
  801e19:	e8 7b fa ff ff       	call   801899 <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
  801e21:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e24:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e28:	75 07                	jne    801e31 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2f:	eb 05                	jmp    801e36 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e36:	c9                   	leave  
  801e37:	c3                   	ret    

00801e38 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e38:	55                   	push   %ebp
  801e39:	89 e5                	mov    %esp,%ebp
  801e3b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 2c                	push   $0x2c
  801e4a:	e8 4a fa ff ff       	call   801899 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
  801e52:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e55:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e59:	75 07                	jne    801e62 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e5b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e60:	eb 05                	jmp    801e67 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e67:	c9                   	leave  
  801e68:	c3                   	ret    

00801e69 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e69:	55                   	push   %ebp
  801e6a:	89 e5                	mov    %esp,%ebp
  801e6c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 2c                	push   $0x2c
  801e7b:	e8 19 fa ff ff       	call   801899 <syscall>
  801e80:	83 c4 18             	add    $0x18,%esp
  801e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e86:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e8a:	75 07                	jne    801e93 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e8c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e91:	eb 05                	jmp    801e98 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e98:	c9                   	leave  
  801e99:	c3                   	ret    

00801e9a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	ff 75 08             	pushl  0x8(%ebp)
  801ea8:	6a 2d                	push   $0x2d
  801eaa:	e8 ea f9 ff ff       	call   801899 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb2:	90                   	nop
}
  801eb3:	c9                   	leave  
  801eb4:	c3                   	ret    

00801eb5 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eb5:	55                   	push   %ebp
  801eb6:	89 e5                	mov    %esp,%ebp
  801eb8:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ebc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	6a 00                	push   $0x0
  801ec7:	53                   	push   %ebx
  801ec8:	51                   	push   %ecx
  801ec9:	52                   	push   %edx
  801eca:	50                   	push   %eax
  801ecb:	6a 2e                	push   $0x2e
  801ecd:	e8 c7 f9 ff ff       	call   801899 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801edd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	52                   	push   %edx
  801eea:	50                   	push   %eax
  801eeb:	6a 2f                	push   $0x2f
  801eed:	e8 a7 f9 ff ff       	call   801899 <syscall>
  801ef2:	83 c4 18             	add    $0x18,%esp
}
  801ef5:	c9                   	leave  
  801ef6:	c3                   	ret    

00801ef7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	68 5c 3b 80 00       	push   $0x803b5c
  801f05:	e8 df e6 ff ff       	call   8005e9 <cprintf>
  801f0a:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f14:	83 ec 0c             	sub    $0xc,%esp
  801f17:	68 88 3b 80 00       	push   $0x803b88
  801f1c:	e8 c8 e6 ff ff       	call   8005e9 <cprintf>
  801f21:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f24:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f28:	a1 38 41 80 00       	mov    0x804138,%eax
  801f2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f30:	eb 56                	jmp    801f88 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f36:	74 1c                	je     801f54 <print_mem_block_lists+0x5d>
  801f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3b:	8b 50 08             	mov    0x8(%eax),%edx
  801f3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f41:	8b 48 08             	mov    0x8(%eax),%ecx
  801f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f47:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4a:	01 c8                	add    %ecx,%eax
  801f4c:	39 c2                	cmp    %eax,%edx
  801f4e:	73 04                	jae    801f54 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f50:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f57:	8b 50 08             	mov    0x8(%eax),%edx
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f60:	01 c2                	add    %eax,%edx
  801f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f65:	8b 40 08             	mov    0x8(%eax),%eax
  801f68:	83 ec 04             	sub    $0x4,%esp
  801f6b:	52                   	push   %edx
  801f6c:	50                   	push   %eax
  801f6d:	68 9d 3b 80 00       	push   $0x803b9d
  801f72:	e8 72 e6 ff ff       	call   8005e9 <cprintf>
  801f77:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f80:	a1 40 41 80 00       	mov    0x804140,%eax
  801f85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8c:	74 07                	je     801f95 <print_mem_block_lists+0x9e>
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	8b 00                	mov    (%eax),%eax
  801f93:	eb 05                	jmp    801f9a <print_mem_block_lists+0xa3>
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	a3 40 41 80 00       	mov    %eax,0x804140
  801f9f:	a1 40 41 80 00       	mov    0x804140,%eax
  801fa4:	85 c0                	test   %eax,%eax
  801fa6:	75 8a                	jne    801f32 <print_mem_block_lists+0x3b>
  801fa8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fac:	75 84                	jne    801f32 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fae:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fb2:	75 10                	jne    801fc4 <print_mem_block_lists+0xcd>
  801fb4:	83 ec 0c             	sub    $0xc,%esp
  801fb7:	68 ac 3b 80 00       	push   $0x803bac
  801fbc:	e8 28 e6 ff ff       	call   8005e9 <cprintf>
  801fc1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fc4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fcb:	83 ec 0c             	sub    $0xc,%esp
  801fce:	68 d0 3b 80 00       	push   $0x803bd0
  801fd3:	e8 11 e6 ff ff       	call   8005e9 <cprintf>
  801fd8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fdb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fdf:	a1 40 40 80 00       	mov    0x804040,%eax
  801fe4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe7:	eb 56                	jmp    80203f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fed:	74 1c                	je     80200b <print_mem_block_lists+0x114>
  801fef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff2:	8b 50 08             	mov    0x8(%eax),%edx
  801ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff8:	8b 48 08             	mov    0x8(%eax),%ecx
  801ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  802001:	01 c8                	add    %ecx,%eax
  802003:	39 c2                	cmp    %eax,%edx
  802005:	73 04                	jae    80200b <print_mem_block_lists+0x114>
			sorted = 0 ;
  802007:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	8b 50 08             	mov    0x8(%eax),%edx
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	8b 40 0c             	mov    0xc(%eax),%eax
  802017:	01 c2                	add    %eax,%edx
  802019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201c:	8b 40 08             	mov    0x8(%eax),%eax
  80201f:	83 ec 04             	sub    $0x4,%esp
  802022:	52                   	push   %edx
  802023:	50                   	push   %eax
  802024:	68 9d 3b 80 00       	push   $0x803b9d
  802029:	e8 bb e5 ff ff       	call   8005e9 <cprintf>
  80202e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802031:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802034:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802037:	a1 48 40 80 00       	mov    0x804048,%eax
  80203c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802043:	74 07                	je     80204c <print_mem_block_lists+0x155>
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	8b 00                	mov    (%eax),%eax
  80204a:	eb 05                	jmp    802051 <print_mem_block_lists+0x15a>
  80204c:	b8 00 00 00 00       	mov    $0x0,%eax
  802051:	a3 48 40 80 00       	mov    %eax,0x804048
  802056:	a1 48 40 80 00       	mov    0x804048,%eax
  80205b:	85 c0                	test   %eax,%eax
  80205d:	75 8a                	jne    801fe9 <print_mem_block_lists+0xf2>
  80205f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802063:	75 84                	jne    801fe9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802065:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802069:	75 10                	jne    80207b <print_mem_block_lists+0x184>
  80206b:	83 ec 0c             	sub    $0xc,%esp
  80206e:	68 e8 3b 80 00       	push   $0x803be8
  802073:	e8 71 e5 ff ff       	call   8005e9 <cprintf>
  802078:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80207b:	83 ec 0c             	sub    $0xc,%esp
  80207e:	68 5c 3b 80 00       	push   $0x803b5c
  802083:	e8 61 e5 ff ff       	call   8005e9 <cprintf>
  802088:	83 c4 10             	add    $0x10,%esp

}
  80208b:	90                   	nop
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    

0080208e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802094:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80209b:	00 00 00 
  80209e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020a5:	00 00 00 
  8020a8:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020af:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  8020b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020b9:	e9 9e 00 00 00       	jmp    80215c <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  8020be:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c6:	c1 e2 04             	shl    $0x4,%edx
  8020c9:	01 d0                	add    %edx,%eax
  8020cb:	85 c0                	test   %eax,%eax
  8020cd:	75 14                	jne    8020e3 <initialize_MemBlocksList+0x55>
  8020cf:	83 ec 04             	sub    $0x4,%esp
  8020d2:	68 10 3c 80 00       	push   $0x803c10
  8020d7:	6a 42                	push   $0x42
  8020d9:	68 33 3c 80 00       	push   $0x803c33
  8020de:	e8 52 e2 ff ff       	call   800335 <_panic>
  8020e3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020eb:	c1 e2 04             	shl    $0x4,%edx
  8020ee:	01 d0                	add    %edx,%eax
  8020f0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020f6:	89 10                	mov    %edx,(%eax)
  8020f8:	8b 00                	mov    (%eax),%eax
  8020fa:	85 c0                	test   %eax,%eax
  8020fc:	74 18                	je     802116 <initialize_MemBlocksList+0x88>
  8020fe:	a1 48 41 80 00       	mov    0x804148,%eax
  802103:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802109:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80210c:	c1 e1 04             	shl    $0x4,%ecx
  80210f:	01 ca                	add    %ecx,%edx
  802111:	89 50 04             	mov    %edx,0x4(%eax)
  802114:	eb 12                	jmp    802128 <initialize_MemBlocksList+0x9a>
  802116:	a1 50 40 80 00       	mov    0x804050,%eax
  80211b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211e:	c1 e2 04             	shl    $0x4,%edx
  802121:	01 d0                	add    %edx,%eax
  802123:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802128:	a1 50 40 80 00       	mov    0x804050,%eax
  80212d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802130:	c1 e2 04             	shl    $0x4,%edx
  802133:	01 d0                	add    %edx,%eax
  802135:	a3 48 41 80 00       	mov    %eax,0x804148
  80213a:	a1 50 40 80 00       	mov    0x804050,%eax
  80213f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802142:	c1 e2 04             	shl    $0x4,%edx
  802145:	01 d0                	add    %edx,%eax
  802147:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214e:	a1 54 41 80 00       	mov    0x804154,%eax
  802153:	40                   	inc    %eax
  802154:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802159:	ff 45 f4             	incl   -0xc(%ebp)
  80215c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802162:	0f 82 56 ff ff ff    	jb     8020be <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802168:	90                   	nop
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8b 00                	mov    (%eax),%eax
  802176:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802179:	eb 19                	jmp    802194 <find_block+0x29>
	{
		if(blk->sva==va)
  80217b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217e:	8b 40 08             	mov    0x8(%eax),%eax
  802181:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802184:	75 05                	jne    80218b <find_block+0x20>
			return (blk);
  802186:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802189:	eb 36                	jmp    8021c1 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80218b:	8b 45 08             	mov    0x8(%ebp),%eax
  80218e:	8b 40 08             	mov    0x8(%eax),%eax
  802191:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802194:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802198:	74 07                	je     8021a1 <find_block+0x36>
  80219a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80219d:	8b 00                	mov    (%eax),%eax
  80219f:	eb 05                	jmp    8021a6 <find_block+0x3b>
  8021a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a9:	89 42 08             	mov    %eax,0x8(%edx)
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8b 40 08             	mov    0x8(%eax),%eax
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	75 c5                	jne    80217b <find_block+0x10>
  8021b6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ba:	75 bf                	jne    80217b <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  8021bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8021c9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021d1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8021d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021db:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021de:	75 65                	jne    802245 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e4:	75 14                	jne    8021fa <insert_sorted_allocList+0x37>
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	68 10 3c 80 00       	push   $0x803c10
  8021ee:	6a 5c                	push   $0x5c
  8021f0:	68 33 3c 80 00       	push   $0x803c33
  8021f5:	e8 3b e1 ff ff       	call   800335 <_panic>
  8021fa:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802200:	8b 45 08             	mov    0x8(%ebp),%eax
  802203:	89 10                	mov    %edx,(%eax)
  802205:	8b 45 08             	mov    0x8(%ebp),%eax
  802208:	8b 00                	mov    (%eax),%eax
  80220a:	85 c0                	test   %eax,%eax
  80220c:	74 0d                	je     80221b <insert_sorted_allocList+0x58>
  80220e:	a1 40 40 80 00       	mov    0x804040,%eax
  802213:	8b 55 08             	mov    0x8(%ebp),%edx
  802216:	89 50 04             	mov    %edx,0x4(%eax)
  802219:	eb 08                	jmp    802223 <insert_sorted_allocList+0x60>
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	a3 44 40 80 00       	mov    %eax,0x804044
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	a3 40 40 80 00       	mov    %eax,0x804040
  80222b:	8b 45 08             	mov    0x8(%ebp),%eax
  80222e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802235:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80223a:	40                   	inc    %eax
  80223b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802240:	e9 7b 01 00 00       	jmp    8023c0 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802245:	a1 44 40 80 00       	mov    0x804044,%eax
  80224a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80224d:	a1 40 40 80 00       	mov    0x804040,%eax
  802252:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802255:	8b 45 08             	mov    0x8(%ebp),%eax
  802258:	8b 50 08             	mov    0x8(%eax),%edx
  80225b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80225e:	8b 40 08             	mov    0x8(%eax),%eax
  802261:	39 c2                	cmp    %eax,%edx
  802263:	76 65                	jbe    8022ca <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802265:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802269:	75 14                	jne    80227f <insert_sorted_allocList+0xbc>
  80226b:	83 ec 04             	sub    $0x4,%esp
  80226e:	68 4c 3c 80 00       	push   $0x803c4c
  802273:	6a 64                	push   $0x64
  802275:	68 33 3c 80 00       	push   $0x803c33
  80227a:	e8 b6 e0 ff ff       	call   800335 <_panic>
  80227f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	89 50 04             	mov    %edx,0x4(%eax)
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	8b 40 04             	mov    0x4(%eax),%eax
  802291:	85 c0                	test   %eax,%eax
  802293:	74 0c                	je     8022a1 <insert_sorted_allocList+0xde>
  802295:	a1 44 40 80 00       	mov    0x804044,%eax
  80229a:	8b 55 08             	mov    0x8(%ebp),%edx
  80229d:	89 10                	mov    %edx,(%eax)
  80229f:	eb 08                	jmp    8022a9 <insert_sorted_allocList+0xe6>
  8022a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a4:	a3 40 40 80 00       	mov    %eax,0x804040
  8022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ac:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022ba:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022bf:	40                   	inc    %eax
  8022c0:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022c5:	e9 f6 00 00 00       	jmp    8023c0 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	8b 50 08             	mov    0x8(%eax),%edx
  8022d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022d3:	8b 40 08             	mov    0x8(%eax),%eax
  8022d6:	39 c2                	cmp    %eax,%edx
  8022d8:	73 65                	jae    80233f <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8022da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022de:	75 14                	jne    8022f4 <insert_sorted_allocList+0x131>
  8022e0:	83 ec 04             	sub    $0x4,%esp
  8022e3:	68 10 3c 80 00       	push   $0x803c10
  8022e8:	6a 68                	push   $0x68
  8022ea:	68 33 3c 80 00       	push   $0x803c33
  8022ef:	e8 41 e0 ff ff       	call   800335 <_panic>
  8022f4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	89 10                	mov    %edx,(%eax)
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	8b 00                	mov    (%eax),%eax
  802304:	85 c0                	test   %eax,%eax
  802306:	74 0d                	je     802315 <insert_sorted_allocList+0x152>
  802308:	a1 40 40 80 00       	mov    0x804040,%eax
  80230d:	8b 55 08             	mov    0x8(%ebp),%edx
  802310:	89 50 04             	mov    %edx,0x4(%eax)
  802313:	eb 08                	jmp    80231d <insert_sorted_allocList+0x15a>
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	a3 44 40 80 00       	mov    %eax,0x804044
  80231d:	8b 45 08             	mov    0x8(%ebp),%eax
  802320:	a3 40 40 80 00       	mov    %eax,0x804040
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80232f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802334:	40                   	inc    %eax
  802335:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80233a:	e9 81 00 00 00       	jmp    8023c0 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80233f:	a1 40 40 80 00       	mov    0x804040,%eax
  802344:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802347:	eb 51                	jmp    80239a <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802349:	8b 45 08             	mov    0x8(%ebp),%eax
  80234c:	8b 50 08             	mov    0x8(%eax),%edx
  80234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802352:	8b 40 08             	mov    0x8(%eax),%eax
  802355:	39 c2                	cmp    %eax,%edx
  802357:	73 39                	jae    802392 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 40 04             	mov    0x4(%eax),%eax
  80235f:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802362:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802365:	8b 55 08             	mov    0x8(%ebp),%edx
  802368:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  80236a:	8b 45 08             	mov    0x8(%ebp),%eax
  80236d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802370:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802373:	8b 45 08             	mov    0x8(%ebp),%eax
  802376:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802379:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80237b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237e:	8b 55 08             	mov    0x8(%ebp),%edx
  802381:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802384:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802389:	40                   	inc    %eax
  80238a:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  80238f:	90                   	nop
				}
			}
		 }

	}
}
  802390:	eb 2e                	jmp    8023c0 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802392:	a1 48 40 80 00       	mov    0x804048,%eax
  802397:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80239a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239e:	74 07                	je     8023a7 <insert_sorted_allocList+0x1e4>
  8023a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	eb 05                	jmp    8023ac <insert_sorted_allocList+0x1e9>
  8023a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ac:	a3 48 40 80 00       	mov    %eax,0x804048
  8023b1:	a1 48 40 80 00       	mov    0x804048,%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	75 8f                	jne    802349 <insert_sorted_allocList+0x186>
  8023ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023be:	75 89                	jne    802349 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8023c0:	90                   	nop
  8023c1:	c9                   	leave  
  8023c2:	c3                   	ret    

008023c3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023c3:	55                   	push   %ebp
  8023c4:	89 e5                	mov    %esp,%ebp
  8023c6:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8023c9:	a1 38 41 80 00       	mov    0x804138,%eax
  8023ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d1:	e9 76 01 00 00       	jmp    80254c <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023dc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023df:	0f 85 8a 00 00 00    	jne    80246f <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8023e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023e9:	75 17                	jne    802402 <alloc_block_FF+0x3f>
  8023eb:	83 ec 04             	sub    $0x4,%esp
  8023ee:	68 6f 3c 80 00       	push   $0x803c6f
  8023f3:	68 8a 00 00 00       	push   $0x8a
  8023f8:	68 33 3c 80 00       	push   $0x803c33
  8023fd:	e8 33 df ff ff       	call   800335 <_panic>
  802402:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802405:	8b 00                	mov    (%eax),%eax
  802407:	85 c0                	test   %eax,%eax
  802409:	74 10                	je     80241b <alloc_block_FF+0x58>
  80240b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240e:	8b 00                	mov    (%eax),%eax
  802410:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802413:	8b 52 04             	mov    0x4(%edx),%edx
  802416:	89 50 04             	mov    %edx,0x4(%eax)
  802419:	eb 0b                	jmp    802426 <alloc_block_FF+0x63>
  80241b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802426:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802429:	8b 40 04             	mov    0x4(%eax),%eax
  80242c:	85 c0                	test   %eax,%eax
  80242e:	74 0f                	je     80243f <alloc_block_FF+0x7c>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 40 04             	mov    0x4(%eax),%eax
  802436:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802439:	8b 12                	mov    (%edx),%edx
  80243b:	89 10                	mov    %edx,(%eax)
  80243d:	eb 0a                	jmp    802449 <alloc_block_FF+0x86>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	a3 38 41 80 00       	mov    %eax,0x804138
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80245c:	a1 44 41 80 00       	mov    0x804144,%eax
  802461:	48                   	dec    %eax
  802462:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246a:	e9 10 01 00 00       	jmp    80257f <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 40 0c             	mov    0xc(%eax),%eax
  802475:	3b 45 08             	cmp    0x8(%ebp),%eax
  802478:	0f 86 c6 00 00 00    	jbe    802544 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80247e:	a1 48 41 80 00       	mov    0x804148,%eax
  802483:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802486:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80248a:	75 17                	jne    8024a3 <alloc_block_FF+0xe0>
  80248c:	83 ec 04             	sub    $0x4,%esp
  80248f:	68 6f 3c 80 00       	push   $0x803c6f
  802494:	68 90 00 00 00       	push   $0x90
  802499:	68 33 3c 80 00       	push   $0x803c33
  80249e:	e8 92 de ff ff       	call   800335 <_panic>
  8024a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024a6:	8b 00                	mov    (%eax),%eax
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	74 10                	je     8024bc <alloc_block_FF+0xf9>
  8024ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024af:	8b 00                	mov    (%eax),%eax
  8024b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024b4:	8b 52 04             	mov    0x4(%edx),%edx
  8024b7:	89 50 04             	mov    %edx,0x4(%eax)
  8024ba:	eb 0b                	jmp    8024c7 <alloc_block_FF+0x104>
  8024bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024bf:	8b 40 04             	mov    0x4(%eax),%eax
  8024c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ca:	8b 40 04             	mov    0x4(%eax),%eax
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	74 0f                	je     8024e0 <alloc_block_FF+0x11d>
  8024d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d4:	8b 40 04             	mov    0x4(%eax),%eax
  8024d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024da:	8b 12                	mov    (%edx),%edx
  8024dc:	89 10                	mov    %edx,(%eax)
  8024de:	eb 0a                	jmp    8024ea <alloc_block_FF+0x127>
  8024e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024e3:	8b 00                	mov    (%eax),%eax
  8024e5:	a3 48 41 80 00       	mov    %eax,0x804148
  8024ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024fd:	a1 54 41 80 00       	mov    0x804154,%eax
  802502:	48                   	dec    %eax
  802503:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250b:	8b 55 08             	mov    0x8(%ebp),%edx
  80250e:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 50 08             	mov    0x8(%eax),%edx
  802517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251a:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	8b 50 08             	mov    0x8(%eax),%edx
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	01 c2                	add    %eax,%edx
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  80252e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802531:	8b 40 0c             	mov    0xc(%eax),%eax
  802534:	2b 45 08             	sub    0x8(%ebp),%eax
  802537:	89 c2                	mov    %eax,%edx
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  80253f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802542:	eb 3b                	jmp    80257f <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802544:	a1 40 41 80 00       	mov    0x804140,%eax
  802549:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802550:	74 07                	je     802559 <alloc_block_FF+0x196>
  802552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802555:	8b 00                	mov    (%eax),%eax
  802557:	eb 05                	jmp    80255e <alloc_block_FF+0x19b>
  802559:	b8 00 00 00 00       	mov    $0x0,%eax
  80255e:	a3 40 41 80 00       	mov    %eax,0x804140
  802563:	a1 40 41 80 00       	mov    0x804140,%eax
  802568:	85 c0                	test   %eax,%eax
  80256a:	0f 85 66 fe ff ff    	jne    8023d6 <alloc_block_FF+0x13>
  802570:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802574:	0f 85 5c fe ff ff    	jne    8023d6 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  80257a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80257f:	c9                   	leave  
  802580:	c3                   	ret    

00802581 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802587:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80258e:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802595:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80259c:	a1 38 41 80 00       	mov    0x804138,%eax
  8025a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a4:	e9 cf 00 00 00       	jmp    802678 <alloc_block_BF+0xf7>
		{
			c++;
  8025a9:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025b5:	0f 85 8a 00 00 00    	jne    802645 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  8025bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025bf:	75 17                	jne    8025d8 <alloc_block_BF+0x57>
  8025c1:	83 ec 04             	sub    $0x4,%esp
  8025c4:	68 6f 3c 80 00       	push   $0x803c6f
  8025c9:	68 a8 00 00 00       	push   $0xa8
  8025ce:	68 33 3c 80 00       	push   $0x803c33
  8025d3:	e8 5d dd ff ff       	call   800335 <_panic>
  8025d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	85 c0                	test   %eax,%eax
  8025df:	74 10                	je     8025f1 <alloc_block_BF+0x70>
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	8b 00                	mov    (%eax),%eax
  8025e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e9:	8b 52 04             	mov    0x4(%edx),%edx
  8025ec:	89 50 04             	mov    %edx,0x4(%eax)
  8025ef:	eb 0b                	jmp    8025fc <alloc_block_BF+0x7b>
  8025f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f4:	8b 40 04             	mov    0x4(%eax),%eax
  8025f7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ff:	8b 40 04             	mov    0x4(%eax),%eax
  802602:	85 c0                	test   %eax,%eax
  802604:	74 0f                	je     802615 <alloc_block_BF+0x94>
  802606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802609:	8b 40 04             	mov    0x4(%eax),%eax
  80260c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260f:	8b 12                	mov    (%edx),%edx
  802611:	89 10                	mov    %edx,(%eax)
  802613:	eb 0a                	jmp    80261f <alloc_block_BF+0x9e>
  802615:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	a3 38 41 80 00       	mov    %eax,0x804138
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802632:	a1 44 41 80 00       	mov    0x804144,%eax
  802637:	48                   	dec    %eax
  802638:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	e9 85 01 00 00       	jmp    8027ca <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802645:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802648:	8b 40 0c             	mov    0xc(%eax),%eax
  80264b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80264e:	76 20                	jbe    802670 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	8b 40 0c             	mov    0xc(%eax),%eax
  802656:	2b 45 08             	sub    0x8(%ebp),%eax
  802659:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  80265c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80265f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802662:	73 0c                	jae    802670 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802664:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802667:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  80266a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266d:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802670:	a1 40 41 80 00       	mov    0x804140,%eax
  802675:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802678:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80267c:	74 07                	je     802685 <alloc_block_BF+0x104>
  80267e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802681:	8b 00                	mov    (%eax),%eax
  802683:	eb 05                	jmp    80268a <alloc_block_BF+0x109>
  802685:	b8 00 00 00 00       	mov    $0x0,%eax
  80268a:	a3 40 41 80 00       	mov    %eax,0x804140
  80268f:	a1 40 41 80 00       	mov    0x804140,%eax
  802694:	85 c0                	test   %eax,%eax
  802696:	0f 85 0d ff ff ff    	jne    8025a9 <alloc_block_BF+0x28>
  80269c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a0:	0f 85 03 ff ff ff    	jne    8025a9 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  8026a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026ad:	a1 38 41 80 00       	mov    0x804138,%eax
  8026b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026b5:	e9 dd 00 00 00       	jmp    802797 <alloc_block_BF+0x216>
		{
			if(x==sol)
  8026ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bd:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026c0:	0f 85 c6 00 00 00    	jne    80278c <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8026c6:	a1 48 41 80 00       	mov    0x804148,%eax
  8026cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8026ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026d2:	75 17                	jne    8026eb <alloc_block_BF+0x16a>
  8026d4:	83 ec 04             	sub    $0x4,%esp
  8026d7:	68 6f 3c 80 00       	push   $0x803c6f
  8026dc:	68 bb 00 00 00       	push   $0xbb
  8026e1:	68 33 3c 80 00       	push   $0x803c33
  8026e6:	e8 4a dc ff ff       	call   800335 <_panic>
  8026eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ee:	8b 00                	mov    (%eax),%eax
  8026f0:	85 c0                	test   %eax,%eax
  8026f2:	74 10                	je     802704 <alloc_block_BF+0x183>
  8026f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026fc:	8b 52 04             	mov    0x4(%edx),%edx
  8026ff:	89 50 04             	mov    %edx,0x4(%eax)
  802702:	eb 0b                	jmp    80270f <alloc_block_BF+0x18e>
  802704:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802707:	8b 40 04             	mov    0x4(%eax),%eax
  80270a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80270f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802712:	8b 40 04             	mov    0x4(%eax),%eax
  802715:	85 c0                	test   %eax,%eax
  802717:	74 0f                	je     802728 <alloc_block_BF+0x1a7>
  802719:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271c:	8b 40 04             	mov    0x4(%eax),%eax
  80271f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802722:	8b 12                	mov    (%edx),%edx
  802724:	89 10                	mov    %edx,(%eax)
  802726:	eb 0a                	jmp    802732 <alloc_block_BF+0x1b1>
  802728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272b:	8b 00                	mov    (%eax),%eax
  80272d:	a3 48 41 80 00       	mov    %eax,0x804148
  802732:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802735:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80273b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802745:	a1 54 41 80 00       	mov    0x804154,%eax
  80274a:	48                   	dec    %eax
  80274b:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802750:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802753:	8b 55 08             	mov    0x8(%ebp),%edx
  802756:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802759:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275c:	8b 50 08             	mov    0x8(%eax),%edx
  80275f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802762:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802768:	8b 50 08             	mov    0x8(%eax),%edx
  80276b:	8b 45 08             	mov    0x8(%ebp),%eax
  80276e:	01 c2                	add    %eax,%edx
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802779:	8b 40 0c             	mov    0xc(%eax),%eax
  80277c:	2b 45 08             	sub    0x8(%ebp),%eax
  80277f:	89 c2                	mov    %eax,%edx
  802781:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802784:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802787:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80278a:	eb 3e                	jmp    8027ca <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80278c:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80278f:	a1 40 41 80 00       	mov    0x804140,%eax
  802794:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802797:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279b:	74 07                	je     8027a4 <alloc_block_BF+0x223>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	eb 05                	jmp    8027a9 <alloc_block_BF+0x228>
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a9:	a3 40 41 80 00       	mov    %eax,0x804140
  8027ae:	a1 40 41 80 00       	mov    0x804140,%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	0f 85 ff fe ff ff    	jne    8026ba <alloc_block_BF+0x139>
  8027bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bf:	0f 85 f5 fe ff ff    	jne    8026ba <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8027c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ca:	c9                   	leave  
  8027cb:	c3                   	ret    

008027cc <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027cc:	55                   	push   %ebp
  8027cd:	89 e5                	mov    %esp,%ebp
  8027cf:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  8027d2:	a1 28 40 80 00       	mov    0x804028,%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	75 14                	jne    8027ef <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  8027db:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e0:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  8027e5:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8027ec:	00 00 00 
	}
	uint32 c=1;
  8027ef:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8027f6:	a1 60 41 80 00       	mov    0x804160,%eax
  8027fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8027fe:	e9 b3 01 00 00       	jmp    8029b6 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  802803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802806:	8b 40 0c             	mov    0xc(%eax),%eax
  802809:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280c:	0f 85 a9 00 00 00    	jne    8028bb <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  802812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	75 0c                	jne    802827 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  80281b:	a1 38 41 80 00       	mov    0x804138,%eax
  802820:	a3 60 41 80 00       	mov    %eax,0x804160
  802825:	eb 0a                	jmp    802831 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802831:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802835:	75 17                	jne    80284e <alloc_block_NF+0x82>
  802837:	83 ec 04             	sub    $0x4,%esp
  80283a:	68 6f 3c 80 00       	push   $0x803c6f
  80283f:	68 e3 00 00 00       	push   $0xe3
  802844:	68 33 3c 80 00       	push   $0x803c33
  802849:	e8 e7 da ff ff       	call   800335 <_panic>
  80284e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802851:	8b 00                	mov    (%eax),%eax
  802853:	85 c0                	test   %eax,%eax
  802855:	74 10                	je     802867 <alloc_block_NF+0x9b>
  802857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285f:	8b 52 04             	mov    0x4(%edx),%edx
  802862:	89 50 04             	mov    %edx,0x4(%eax)
  802865:	eb 0b                	jmp    802872 <alloc_block_NF+0xa6>
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	8b 40 04             	mov    0x4(%eax),%eax
  80286d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802872:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802875:	8b 40 04             	mov    0x4(%eax),%eax
  802878:	85 c0                	test   %eax,%eax
  80287a:	74 0f                	je     80288b <alloc_block_NF+0xbf>
  80287c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287f:	8b 40 04             	mov    0x4(%eax),%eax
  802882:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802885:	8b 12                	mov    (%edx),%edx
  802887:	89 10                	mov    %edx,(%eax)
  802889:	eb 0a                	jmp    802895 <alloc_block_NF+0xc9>
  80288b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80288e:	8b 00                	mov    (%eax),%eax
  802890:	a3 38 41 80 00       	mov    %eax,0x804138
  802895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802898:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80289e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8028ad:	48                   	dec    %eax
  8028ae:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  8028b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b6:	e9 0e 01 00 00       	jmp    8029c9 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  8028bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028be:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028c4:	0f 86 ce 00 00 00    	jbe    802998 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8028ca:	a1 48 41 80 00       	mov    0x804148,%eax
  8028cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8028d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028d6:	75 17                	jne    8028ef <alloc_block_NF+0x123>
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	68 6f 3c 80 00       	push   $0x803c6f
  8028e0:	68 e9 00 00 00       	push   $0xe9
  8028e5:	68 33 3c 80 00       	push   $0x803c33
  8028ea:	e8 46 da ff ff       	call   800335 <_panic>
  8028ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f2:	8b 00                	mov    (%eax),%eax
  8028f4:	85 c0                	test   %eax,%eax
  8028f6:	74 10                	je     802908 <alloc_block_NF+0x13c>
  8028f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802900:	8b 52 04             	mov    0x4(%edx),%edx
  802903:	89 50 04             	mov    %edx,0x4(%eax)
  802906:	eb 0b                	jmp    802913 <alloc_block_NF+0x147>
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	8b 40 04             	mov    0x4(%eax),%eax
  80290e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802913:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802916:	8b 40 04             	mov    0x4(%eax),%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	74 0f                	je     80292c <alloc_block_NF+0x160>
  80291d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802920:	8b 40 04             	mov    0x4(%eax),%eax
  802923:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802926:	8b 12                	mov    (%edx),%edx
  802928:	89 10                	mov    %edx,(%eax)
  80292a:	eb 0a                	jmp    802936 <alloc_block_NF+0x16a>
  80292c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80292f:	8b 00                	mov    (%eax),%eax
  802931:	a3 48 41 80 00       	mov    %eax,0x804148
  802936:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802939:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802942:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802949:	a1 54 41 80 00       	mov    0x804154,%eax
  80294e:	48                   	dec    %eax
  80294f:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802954:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802957:	8b 55 08             	mov    0x8(%ebp),%edx
  80295a:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  80295d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802960:	8b 50 08             	mov    0x8(%eax),%edx
  802963:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802966:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802969:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296c:	8b 50 08             	mov    0x8(%eax),%edx
  80296f:	8b 45 08             	mov    0x8(%ebp),%eax
  802972:	01 c2                	add    %eax,%edx
  802974:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802977:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  80297a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297d:	8b 40 0c             	mov    0xc(%eax),%eax
  802980:	2b 45 08             	sub    0x8(%ebp),%eax
  802983:	89 c2                	mov    %eax,%edx
  802985:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802988:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80298b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298e:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802996:	eb 31                	jmp    8029c9 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802998:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80299b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299e:	8b 00                	mov    (%eax),%eax
  8029a0:	85 c0                	test   %eax,%eax
  8029a2:	75 0a                	jne    8029ae <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8029a4:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8029ac:	eb 08                	jmp    8029b6 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  8029ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029b1:	8b 00                	mov    (%eax),%eax
  8029b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8029b6:	a1 44 41 80 00       	mov    0x804144,%eax
  8029bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8029be:	0f 85 3f fe ff ff    	jne    802803 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8029c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029c9:	c9                   	leave  
  8029ca:	c3                   	ret    

008029cb <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029cb:	55                   	push   %ebp
  8029cc:	89 e5                	mov    %esp,%ebp
  8029ce:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  8029d1:	a1 44 41 80 00       	mov    0x804144,%eax
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	75 68                	jne    802a42 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029de:	75 17                	jne    8029f7 <insert_sorted_with_merge_freeList+0x2c>
  8029e0:	83 ec 04             	sub    $0x4,%esp
  8029e3:	68 10 3c 80 00       	push   $0x803c10
  8029e8:	68 0e 01 00 00       	push   $0x10e
  8029ed:	68 33 3c 80 00       	push   $0x803c33
  8029f2:	e8 3e d9 ff ff       	call   800335 <_panic>
  8029f7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802a00:	89 10                	mov    %edx,(%eax)
  802a02:	8b 45 08             	mov    0x8(%ebp),%eax
  802a05:	8b 00                	mov    (%eax),%eax
  802a07:	85 c0                	test   %eax,%eax
  802a09:	74 0d                	je     802a18 <insert_sorted_with_merge_freeList+0x4d>
  802a0b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a10:	8b 55 08             	mov    0x8(%ebp),%edx
  802a13:	89 50 04             	mov    %edx,0x4(%eax)
  802a16:	eb 08                	jmp    802a20 <insert_sorted_with_merge_freeList+0x55>
  802a18:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	a3 38 41 80 00       	mov    %eax,0x804138
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a32:	a1 44 41 80 00       	mov    0x804144,%eax
  802a37:	40                   	inc    %eax
  802a38:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a3d:	e9 8c 06 00 00       	jmp    8030ce <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802a42:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802a4a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	8b 50 08             	mov    0x8(%eax),%edx
  802a58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a5b:	8b 40 08             	mov    0x8(%eax),%eax
  802a5e:	39 c2                	cmp    %eax,%edx
  802a60:	0f 86 14 01 00 00    	jbe    802b7a <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a69:	8b 50 0c             	mov    0xc(%eax),%edx
  802a6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a6f:	8b 40 08             	mov    0x8(%eax),%eax
  802a72:	01 c2                	add    %eax,%edx
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	8b 40 08             	mov    0x8(%eax),%eax
  802a7a:	39 c2                	cmp    %eax,%edx
  802a7c:	0f 85 90 00 00 00    	jne    802b12 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a85:	8b 50 0c             	mov    0xc(%eax),%edx
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a8e:	01 c2                	add    %eax,%edx
  802a90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a93:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802aaa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aae:	75 17                	jne    802ac7 <insert_sorted_with_merge_freeList+0xfc>
  802ab0:	83 ec 04             	sub    $0x4,%esp
  802ab3:	68 10 3c 80 00       	push   $0x803c10
  802ab8:	68 1b 01 00 00       	push   $0x11b
  802abd:	68 33 3c 80 00       	push   $0x803c33
  802ac2:	e8 6e d8 ff ff       	call   800335 <_panic>
  802ac7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	89 10                	mov    %edx,(%eax)
  802ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad5:	8b 00                	mov    (%eax),%eax
  802ad7:	85 c0                	test   %eax,%eax
  802ad9:	74 0d                	je     802ae8 <insert_sorted_with_merge_freeList+0x11d>
  802adb:	a1 48 41 80 00       	mov    0x804148,%eax
  802ae0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae3:	89 50 04             	mov    %edx,0x4(%eax)
  802ae6:	eb 08                	jmp    802af0 <insert_sorted_with_merge_freeList+0x125>
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	a3 48 41 80 00       	mov    %eax,0x804148
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b02:	a1 54 41 80 00       	mov    0x804154,%eax
  802b07:	40                   	inc    %eax
  802b08:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b0d:	e9 bc 05 00 00       	jmp    8030ce <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b16:	75 17                	jne    802b2f <insert_sorted_with_merge_freeList+0x164>
  802b18:	83 ec 04             	sub    $0x4,%esp
  802b1b:	68 4c 3c 80 00       	push   $0x803c4c
  802b20:	68 1f 01 00 00       	push   $0x11f
  802b25:	68 33 3c 80 00       	push   $0x803c33
  802b2a:	e8 06 d8 ff ff       	call   800335 <_panic>
  802b2f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	89 50 04             	mov    %edx,0x4(%eax)
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	8b 40 04             	mov    0x4(%eax),%eax
  802b41:	85 c0                	test   %eax,%eax
  802b43:	74 0c                	je     802b51 <insert_sorted_with_merge_freeList+0x186>
  802b45:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4d:	89 10                	mov    %edx,(%eax)
  802b4f:	eb 08                	jmp    802b59 <insert_sorted_with_merge_freeList+0x18e>
  802b51:	8b 45 08             	mov    0x8(%ebp),%eax
  802b54:	a3 38 41 80 00       	mov    %eax,0x804138
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b6a:	a1 44 41 80 00       	mov    0x804144,%eax
  802b6f:	40                   	inc    %eax
  802b70:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802b75:	e9 54 05 00 00       	jmp    8030ce <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	8b 50 08             	mov    0x8(%eax),%edx
  802b80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b83:	8b 40 08             	mov    0x8(%eax),%eax
  802b86:	39 c2                	cmp    %eax,%edx
  802b88:	0f 83 20 01 00 00    	jae    802cae <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b91:	8b 50 0c             	mov    0xc(%eax),%edx
  802b94:	8b 45 08             	mov    0x8(%ebp),%eax
  802b97:	8b 40 08             	mov    0x8(%eax),%eax
  802b9a:	01 c2                	add    %eax,%edx
  802b9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ba2:	39 c2                	cmp    %eax,%edx
  802ba4:	0f 85 9c 00 00 00    	jne    802c46 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	8b 50 08             	mov    0x8(%eax),%edx
  802bb0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb3:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb9:	8b 50 0c             	mov    0xc(%eax),%edx
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc2:	01 c2                	add    %eax,%edx
  802bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc7:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802bca:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802bde:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be2:	75 17                	jne    802bfb <insert_sorted_with_merge_freeList+0x230>
  802be4:	83 ec 04             	sub    $0x4,%esp
  802be7:	68 10 3c 80 00       	push   $0x803c10
  802bec:	68 2a 01 00 00       	push   $0x12a
  802bf1:	68 33 3c 80 00       	push   $0x803c33
  802bf6:	e8 3a d7 ff ff       	call   800335 <_panic>
  802bfb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	89 10                	mov    %edx,(%eax)
  802c06:	8b 45 08             	mov    0x8(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	85 c0                	test   %eax,%eax
  802c0d:	74 0d                	je     802c1c <insert_sorted_with_merge_freeList+0x251>
  802c0f:	a1 48 41 80 00       	mov    0x804148,%eax
  802c14:	8b 55 08             	mov    0x8(%ebp),%edx
  802c17:	89 50 04             	mov    %edx,0x4(%eax)
  802c1a:	eb 08                	jmp    802c24 <insert_sorted_with_merge_freeList+0x259>
  802c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	a3 48 41 80 00       	mov    %eax,0x804148
  802c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c36:	a1 54 41 80 00       	mov    0x804154,%eax
  802c3b:	40                   	inc    %eax
  802c3c:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c41:	e9 88 04 00 00       	jmp    8030ce <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4a:	75 17                	jne    802c63 <insert_sorted_with_merge_freeList+0x298>
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	68 10 3c 80 00       	push   $0x803c10
  802c54:	68 2e 01 00 00       	push   $0x12e
  802c59:	68 33 3c 80 00       	push   $0x803c33
  802c5e:	e8 d2 d6 ff ff       	call   800335 <_panic>
  802c63:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	89 10                	mov    %edx,(%eax)
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0d                	je     802c84 <insert_sorted_with_merge_freeList+0x2b9>
  802c77:	a1 38 41 80 00       	mov    0x804138,%eax
  802c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
  802c82:	eb 08                	jmp    802c8c <insert_sorted_with_merge_freeList+0x2c1>
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	a3 38 41 80 00       	mov    %eax,0x804138
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9e:	a1 44 41 80 00       	mov    0x804144,%eax
  802ca3:	40                   	inc    %eax
  802ca4:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802ca9:	e9 20 04 00 00       	jmp    8030ce <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802cae:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802cb6:	e9 e2 03 00 00       	jmp    80309d <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	8b 50 08             	mov    0x8(%eax),%edx
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	8b 40 08             	mov    0x8(%eax),%eax
  802cc7:	39 c2                	cmp    %eax,%edx
  802cc9:	0f 83 c6 03 00 00    	jae    803095 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cdb:	8b 50 08             	mov    0x8(%eax),%edx
  802cde:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ce1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ce4:	01 d0                	add    %edx,%eax
  802ce6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cec:	8b 50 0c             	mov    0xc(%eax),%edx
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	8b 40 08             	mov    0x8(%eax),%eax
  802cf5:	01 d0                	add    %edx,%eax
  802cf7:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	8b 40 08             	mov    0x8(%eax),%eax
  802d00:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d03:	74 7a                	je     802d7f <insert_sorted_with_merge_freeList+0x3b4>
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	8b 40 08             	mov    0x8(%eax),%eax
  802d0b:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d0e:	74 6f                	je     802d7f <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802d10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d14:	74 06                	je     802d1c <insert_sorted_with_merge_freeList+0x351>
  802d16:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d1a:	75 17                	jne    802d33 <insert_sorted_with_merge_freeList+0x368>
  802d1c:	83 ec 04             	sub    $0x4,%esp
  802d1f:	68 90 3c 80 00       	push   $0x803c90
  802d24:	68 43 01 00 00       	push   $0x143
  802d29:	68 33 3c 80 00       	push   $0x803c33
  802d2e:	e8 02 d6 ff ff       	call   800335 <_panic>
  802d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d36:	8b 50 04             	mov    0x4(%eax),%edx
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	89 50 04             	mov    %edx,0x4(%eax)
  802d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d45:	89 10                	mov    %edx,(%eax)
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	85 c0                	test   %eax,%eax
  802d4f:	74 0d                	je     802d5e <insert_sorted_with_merge_freeList+0x393>
  802d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d54:	8b 40 04             	mov    0x4(%eax),%eax
  802d57:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5a:	89 10                	mov    %edx,(%eax)
  802d5c:	eb 08                	jmp    802d66 <insert_sorted_with_merge_freeList+0x39b>
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	a3 38 41 80 00       	mov    %eax,0x804138
  802d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d69:	8b 55 08             	mov    0x8(%ebp),%edx
  802d6c:	89 50 04             	mov    %edx,0x4(%eax)
  802d6f:	a1 44 41 80 00       	mov    0x804144,%eax
  802d74:	40                   	inc    %eax
  802d75:	a3 44 41 80 00       	mov    %eax,0x804144
  802d7a:	e9 14 03 00 00       	jmp    803093 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	8b 40 08             	mov    0x8(%eax),%eax
  802d85:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d88:	0f 85 a0 01 00 00    	jne    802f2e <insert_sorted_with_merge_freeList+0x563>
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 40 08             	mov    0x8(%eax),%eax
  802d94:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d97:	0f 85 91 01 00 00    	jne    802f2e <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802d9d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802da0:	8b 50 0c             	mov    0xc(%eax),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	8b 48 0c             	mov    0xc(%eax),%ecx
  802da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dac:	8b 40 0c             	mov    0xc(%eax),%eax
  802daf:	01 c8                	add    %ecx,%eax
  802db1:	01 c2                	add    %eax,%edx
  802db3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802db6:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802de1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802de5:	75 17                	jne    802dfe <insert_sorted_with_merge_freeList+0x433>
  802de7:	83 ec 04             	sub    $0x4,%esp
  802dea:	68 10 3c 80 00       	push   $0x803c10
  802def:	68 4d 01 00 00       	push   $0x14d
  802df4:	68 33 3c 80 00       	push   $0x803c33
  802df9:	e8 37 d5 ff ff       	call   800335 <_panic>
  802dfe:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e04:	8b 45 08             	mov    0x8(%ebp),%eax
  802e07:	89 10                	mov    %edx,(%eax)
  802e09:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0c:	8b 00                	mov    (%eax),%eax
  802e0e:	85 c0                	test   %eax,%eax
  802e10:	74 0d                	je     802e1f <insert_sorted_with_merge_freeList+0x454>
  802e12:	a1 48 41 80 00       	mov    0x804148,%eax
  802e17:	8b 55 08             	mov    0x8(%ebp),%edx
  802e1a:	89 50 04             	mov    %edx,0x4(%eax)
  802e1d:	eb 08                	jmp    802e27 <insert_sorted_with_merge_freeList+0x45c>
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e39:	a1 54 41 80 00       	mov    0x804154,%eax
  802e3e:	40                   	inc    %eax
  802e3f:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e48:	75 17                	jne    802e61 <insert_sorted_with_merge_freeList+0x496>
  802e4a:	83 ec 04             	sub    $0x4,%esp
  802e4d:	68 6f 3c 80 00       	push   $0x803c6f
  802e52:	68 4e 01 00 00       	push   $0x14e
  802e57:	68 33 3c 80 00       	push   $0x803c33
  802e5c:	e8 d4 d4 ff ff       	call   800335 <_panic>
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 00                	mov    (%eax),%eax
  802e66:	85 c0                	test   %eax,%eax
  802e68:	74 10                	je     802e7a <insert_sorted_with_merge_freeList+0x4af>
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	8b 00                	mov    (%eax),%eax
  802e6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e72:	8b 52 04             	mov    0x4(%edx),%edx
  802e75:	89 50 04             	mov    %edx,0x4(%eax)
  802e78:	eb 0b                	jmp    802e85 <insert_sorted_with_merge_freeList+0x4ba>
  802e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7d:	8b 40 04             	mov    0x4(%eax),%eax
  802e80:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 40 04             	mov    0x4(%eax),%eax
  802e8b:	85 c0                	test   %eax,%eax
  802e8d:	74 0f                	je     802e9e <insert_sorted_with_merge_freeList+0x4d3>
  802e8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e92:	8b 40 04             	mov    0x4(%eax),%eax
  802e95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e98:	8b 12                	mov    (%edx),%edx
  802e9a:	89 10                	mov    %edx,(%eax)
  802e9c:	eb 0a                	jmp    802ea8 <insert_sorted_with_merge_freeList+0x4dd>
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 00                	mov    (%eax),%eax
  802ea3:	a3 38 41 80 00       	mov    %eax,0x804138
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ebb:	a1 44 41 80 00       	mov    0x804144,%eax
  802ec0:	48                   	dec    %eax
  802ec1:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802ec6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eca:	75 17                	jne    802ee3 <insert_sorted_with_merge_freeList+0x518>
  802ecc:	83 ec 04             	sub    $0x4,%esp
  802ecf:	68 10 3c 80 00       	push   $0x803c10
  802ed4:	68 4f 01 00 00       	push   $0x14f
  802ed9:	68 33 3c 80 00       	push   $0x803c33
  802ede:	e8 52 d4 ff ff       	call   800335 <_panic>
  802ee3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	89 10                	mov    %edx,(%eax)
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	8b 00                	mov    (%eax),%eax
  802ef3:	85 c0                	test   %eax,%eax
  802ef5:	74 0d                	je     802f04 <insert_sorted_with_merge_freeList+0x539>
  802ef7:	a1 48 41 80 00       	mov    0x804148,%eax
  802efc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eff:	89 50 04             	mov    %edx,0x4(%eax)
  802f02:	eb 08                	jmp    802f0c <insert_sorted_with_merge_freeList+0x541>
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	a3 48 41 80 00       	mov    %eax,0x804148
  802f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1e:	a1 54 41 80 00       	mov    0x804154,%eax
  802f23:	40                   	inc    %eax
  802f24:	a3 54 41 80 00       	mov    %eax,0x804154
  802f29:	e9 65 01 00 00       	jmp    803093 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f31:	8b 40 08             	mov    0x8(%eax),%eax
  802f34:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f37:	0f 85 9f 00 00 00    	jne    802fdc <insert_sorted_with_merge_freeList+0x611>
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 40 08             	mov    0x8(%eax),%eax
  802f43:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f46:	0f 84 90 00 00 00    	je     802fdc <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802f4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f4f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f52:	8b 45 08             	mov    0x8(%ebp),%eax
  802f55:	8b 40 0c             	mov    0xc(%eax),%eax
  802f58:	01 c2                	add    %eax,%edx
  802f5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f5d:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f60:	8b 45 08             	mov    0x8(%ebp),%eax
  802f63:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f78:	75 17                	jne    802f91 <insert_sorted_with_merge_freeList+0x5c6>
  802f7a:	83 ec 04             	sub    $0x4,%esp
  802f7d:	68 10 3c 80 00       	push   $0x803c10
  802f82:	68 58 01 00 00       	push   $0x158
  802f87:	68 33 3c 80 00       	push   $0x803c33
  802f8c:	e8 a4 d3 ff ff       	call   800335 <_panic>
  802f91:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f97:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9a:	89 10                	mov    %edx,(%eax)
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 0d                	je     802fb2 <insert_sorted_with_merge_freeList+0x5e7>
  802fa5:	a1 48 41 80 00       	mov    0x804148,%eax
  802faa:	8b 55 08             	mov    0x8(%ebp),%edx
  802fad:	89 50 04             	mov    %edx,0x4(%eax)
  802fb0:	eb 08                	jmp    802fba <insert_sorted_with_merge_freeList+0x5ef>
  802fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	a3 48 41 80 00       	mov    %eax,0x804148
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcc:	a1 54 41 80 00       	mov    0x804154,%eax
  802fd1:	40                   	inc    %eax
  802fd2:	a3 54 41 80 00       	mov    %eax,0x804154
  802fd7:	e9 b7 00 00 00       	jmp    803093 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdf:	8b 40 08             	mov    0x8(%eax),%eax
  802fe2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802fe5:	0f 84 e2 00 00 00    	je     8030cd <insert_sorted_with_merge_freeList+0x702>
  802feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fee:	8b 40 08             	mov    0x8(%eax),%eax
  802ff1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802ff4:	0f 85 d3 00 00 00    	jne    8030cd <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	8b 50 08             	mov    0x8(%eax),%edx
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 50 0c             	mov    0xc(%eax),%edx
  80300c:	8b 45 08             	mov    0x8(%ebp),%eax
  80300f:	8b 40 0c             	mov    0xc(%eax),%eax
  803012:	01 c2                	add    %eax,%edx
  803014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803017:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803024:	8b 45 08             	mov    0x8(%ebp),%eax
  803027:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80302e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803032:	75 17                	jne    80304b <insert_sorted_with_merge_freeList+0x680>
  803034:	83 ec 04             	sub    $0x4,%esp
  803037:	68 10 3c 80 00       	push   $0x803c10
  80303c:	68 61 01 00 00       	push   $0x161
  803041:	68 33 3c 80 00       	push   $0x803c33
  803046:	e8 ea d2 ff ff       	call   800335 <_panic>
  80304b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	89 10                	mov    %edx,(%eax)
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	8b 00                	mov    (%eax),%eax
  80305b:	85 c0                	test   %eax,%eax
  80305d:	74 0d                	je     80306c <insert_sorted_with_merge_freeList+0x6a1>
  80305f:	a1 48 41 80 00       	mov    0x804148,%eax
  803064:	8b 55 08             	mov    0x8(%ebp),%edx
  803067:	89 50 04             	mov    %edx,0x4(%eax)
  80306a:	eb 08                	jmp    803074 <insert_sorted_with_merge_freeList+0x6a9>
  80306c:	8b 45 08             	mov    0x8(%ebp),%eax
  80306f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	a3 48 41 80 00       	mov    %eax,0x804148
  80307c:	8b 45 08             	mov    0x8(%ebp),%eax
  80307f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803086:	a1 54 41 80 00       	mov    0x804154,%eax
  80308b:	40                   	inc    %eax
  80308c:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803091:	eb 3a                	jmp    8030cd <insert_sorted_with_merge_freeList+0x702>
  803093:	eb 38                	jmp    8030cd <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803095:	a1 40 41 80 00       	mov    0x804140,%eax
  80309a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a1:	74 07                	je     8030aa <insert_sorted_with_merge_freeList+0x6df>
  8030a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a6:	8b 00                	mov    (%eax),%eax
  8030a8:	eb 05                	jmp    8030af <insert_sorted_with_merge_freeList+0x6e4>
  8030aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8030af:	a3 40 41 80 00       	mov    %eax,0x804140
  8030b4:	a1 40 41 80 00       	mov    0x804140,%eax
  8030b9:	85 c0                	test   %eax,%eax
  8030bb:	0f 85 fa fb ff ff    	jne    802cbb <insert_sorted_with_merge_freeList+0x2f0>
  8030c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c5:	0f 85 f0 fb ff ff    	jne    802cbb <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8030cb:	eb 01                	jmp    8030ce <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8030cd:	90                   	nop
							}

						}
		          }
		}
}
  8030ce:	90                   	nop
  8030cf:	c9                   	leave  
  8030d0:	c3                   	ret    
  8030d1:	66 90                	xchg   %ax,%ax
  8030d3:	90                   	nop

008030d4 <__udivdi3>:
  8030d4:	55                   	push   %ebp
  8030d5:	57                   	push   %edi
  8030d6:	56                   	push   %esi
  8030d7:	53                   	push   %ebx
  8030d8:	83 ec 1c             	sub    $0x1c,%esp
  8030db:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030df:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030eb:	89 ca                	mov    %ecx,%edx
  8030ed:	89 f8                	mov    %edi,%eax
  8030ef:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030f3:	85 f6                	test   %esi,%esi
  8030f5:	75 2d                	jne    803124 <__udivdi3+0x50>
  8030f7:	39 cf                	cmp    %ecx,%edi
  8030f9:	77 65                	ja     803160 <__udivdi3+0x8c>
  8030fb:	89 fd                	mov    %edi,%ebp
  8030fd:	85 ff                	test   %edi,%edi
  8030ff:	75 0b                	jne    80310c <__udivdi3+0x38>
  803101:	b8 01 00 00 00       	mov    $0x1,%eax
  803106:	31 d2                	xor    %edx,%edx
  803108:	f7 f7                	div    %edi
  80310a:	89 c5                	mov    %eax,%ebp
  80310c:	31 d2                	xor    %edx,%edx
  80310e:	89 c8                	mov    %ecx,%eax
  803110:	f7 f5                	div    %ebp
  803112:	89 c1                	mov    %eax,%ecx
  803114:	89 d8                	mov    %ebx,%eax
  803116:	f7 f5                	div    %ebp
  803118:	89 cf                	mov    %ecx,%edi
  80311a:	89 fa                	mov    %edi,%edx
  80311c:	83 c4 1c             	add    $0x1c,%esp
  80311f:	5b                   	pop    %ebx
  803120:	5e                   	pop    %esi
  803121:	5f                   	pop    %edi
  803122:	5d                   	pop    %ebp
  803123:	c3                   	ret    
  803124:	39 ce                	cmp    %ecx,%esi
  803126:	77 28                	ja     803150 <__udivdi3+0x7c>
  803128:	0f bd fe             	bsr    %esi,%edi
  80312b:	83 f7 1f             	xor    $0x1f,%edi
  80312e:	75 40                	jne    803170 <__udivdi3+0x9c>
  803130:	39 ce                	cmp    %ecx,%esi
  803132:	72 0a                	jb     80313e <__udivdi3+0x6a>
  803134:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803138:	0f 87 9e 00 00 00    	ja     8031dc <__udivdi3+0x108>
  80313e:	b8 01 00 00 00       	mov    $0x1,%eax
  803143:	89 fa                	mov    %edi,%edx
  803145:	83 c4 1c             	add    $0x1c,%esp
  803148:	5b                   	pop    %ebx
  803149:	5e                   	pop    %esi
  80314a:	5f                   	pop    %edi
  80314b:	5d                   	pop    %ebp
  80314c:	c3                   	ret    
  80314d:	8d 76 00             	lea    0x0(%esi),%esi
  803150:	31 ff                	xor    %edi,%edi
  803152:	31 c0                	xor    %eax,%eax
  803154:	89 fa                	mov    %edi,%edx
  803156:	83 c4 1c             	add    $0x1c,%esp
  803159:	5b                   	pop    %ebx
  80315a:	5e                   	pop    %esi
  80315b:	5f                   	pop    %edi
  80315c:	5d                   	pop    %ebp
  80315d:	c3                   	ret    
  80315e:	66 90                	xchg   %ax,%ax
  803160:	89 d8                	mov    %ebx,%eax
  803162:	f7 f7                	div    %edi
  803164:	31 ff                	xor    %edi,%edi
  803166:	89 fa                	mov    %edi,%edx
  803168:	83 c4 1c             	add    $0x1c,%esp
  80316b:	5b                   	pop    %ebx
  80316c:	5e                   	pop    %esi
  80316d:	5f                   	pop    %edi
  80316e:	5d                   	pop    %ebp
  80316f:	c3                   	ret    
  803170:	bd 20 00 00 00       	mov    $0x20,%ebp
  803175:	89 eb                	mov    %ebp,%ebx
  803177:	29 fb                	sub    %edi,%ebx
  803179:	89 f9                	mov    %edi,%ecx
  80317b:	d3 e6                	shl    %cl,%esi
  80317d:	89 c5                	mov    %eax,%ebp
  80317f:	88 d9                	mov    %bl,%cl
  803181:	d3 ed                	shr    %cl,%ebp
  803183:	89 e9                	mov    %ebp,%ecx
  803185:	09 f1                	or     %esi,%ecx
  803187:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80318b:	89 f9                	mov    %edi,%ecx
  80318d:	d3 e0                	shl    %cl,%eax
  80318f:	89 c5                	mov    %eax,%ebp
  803191:	89 d6                	mov    %edx,%esi
  803193:	88 d9                	mov    %bl,%cl
  803195:	d3 ee                	shr    %cl,%esi
  803197:	89 f9                	mov    %edi,%ecx
  803199:	d3 e2                	shl    %cl,%edx
  80319b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80319f:	88 d9                	mov    %bl,%cl
  8031a1:	d3 e8                	shr    %cl,%eax
  8031a3:	09 c2                	or     %eax,%edx
  8031a5:	89 d0                	mov    %edx,%eax
  8031a7:	89 f2                	mov    %esi,%edx
  8031a9:	f7 74 24 0c          	divl   0xc(%esp)
  8031ad:	89 d6                	mov    %edx,%esi
  8031af:	89 c3                	mov    %eax,%ebx
  8031b1:	f7 e5                	mul    %ebp
  8031b3:	39 d6                	cmp    %edx,%esi
  8031b5:	72 19                	jb     8031d0 <__udivdi3+0xfc>
  8031b7:	74 0b                	je     8031c4 <__udivdi3+0xf0>
  8031b9:	89 d8                	mov    %ebx,%eax
  8031bb:	31 ff                	xor    %edi,%edi
  8031bd:	e9 58 ff ff ff       	jmp    80311a <__udivdi3+0x46>
  8031c2:	66 90                	xchg   %ax,%ax
  8031c4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031c8:	89 f9                	mov    %edi,%ecx
  8031ca:	d3 e2                	shl    %cl,%edx
  8031cc:	39 c2                	cmp    %eax,%edx
  8031ce:	73 e9                	jae    8031b9 <__udivdi3+0xe5>
  8031d0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031d3:	31 ff                	xor    %edi,%edi
  8031d5:	e9 40 ff ff ff       	jmp    80311a <__udivdi3+0x46>
  8031da:	66 90                	xchg   %ax,%ax
  8031dc:	31 c0                	xor    %eax,%eax
  8031de:	e9 37 ff ff ff       	jmp    80311a <__udivdi3+0x46>
  8031e3:	90                   	nop

008031e4 <__umoddi3>:
  8031e4:	55                   	push   %ebp
  8031e5:	57                   	push   %edi
  8031e6:	56                   	push   %esi
  8031e7:	53                   	push   %ebx
  8031e8:	83 ec 1c             	sub    $0x1c,%esp
  8031eb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031ef:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031f7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031ff:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803203:	89 f3                	mov    %esi,%ebx
  803205:	89 fa                	mov    %edi,%edx
  803207:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80320b:	89 34 24             	mov    %esi,(%esp)
  80320e:	85 c0                	test   %eax,%eax
  803210:	75 1a                	jne    80322c <__umoddi3+0x48>
  803212:	39 f7                	cmp    %esi,%edi
  803214:	0f 86 a2 00 00 00    	jbe    8032bc <__umoddi3+0xd8>
  80321a:	89 c8                	mov    %ecx,%eax
  80321c:	89 f2                	mov    %esi,%edx
  80321e:	f7 f7                	div    %edi
  803220:	89 d0                	mov    %edx,%eax
  803222:	31 d2                	xor    %edx,%edx
  803224:	83 c4 1c             	add    $0x1c,%esp
  803227:	5b                   	pop    %ebx
  803228:	5e                   	pop    %esi
  803229:	5f                   	pop    %edi
  80322a:	5d                   	pop    %ebp
  80322b:	c3                   	ret    
  80322c:	39 f0                	cmp    %esi,%eax
  80322e:	0f 87 ac 00 00 00    	ja     8032e0 <__umoddi3+0xfc>
  803234:	0f bd e8             	bsr    %eax,%ebp
  803237:	83 f5 1f             	xor    $0x1f,%ebp
  80323a:	0f 84 ac 00 00 00    	je     8032ec <__umoddi3+0x108>
  803240:	bf 20 00 00 00       	mov    $0x20,%edi
  803245:	29 ef                	sub    %ebp,%edi
  803247:	89 fe                	mov    %edi,%esi
  803249:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80324d:	89 e9                	mov    %ebp,%ecx
  80324f:	d3 e0                	shl    %cl,%eax
  803251:	89 d7                	mov    %edx,%edi
  803253:	89 f1                	mov    %esi,%ecx
  803255:	d3 ef                	shr    %cl,%edi
  803257:	09 c7                	or     %eax,%edi
  803259:	89 e9                	mov    %ebp,%ecx
  80325b:	d3 e2                	shl    %cl,%edx
  80325d:	89 14 24             	mov    %edx,(%esp)
  803260:	89 d8                	mov    %ebx,%eax
  803262:	d3 e0                	shl    %cl,%eax
  803264:	89 c2                	mov    %eax,%edx
  803266:	8b 44 24 08          	mov    0x8(%esp),%eax
  80326a:	d3 e0                	shl    %cl,%eax
  80326c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803270:	8b 44 24 08          	mov    0x8(%esp),%eax
  803274:	89 f1                	mov    %esi,%ecx
  803276:	d3 e8                	shr    %cl,%eax
  803278:	09 d0                	or     %edx,%eax
  80327a:	d3 eb                	shr    %cl,%ebx
  80327c:	89 da                	mov    %ebx,%edx
  80327e:	f7 f7                	div    %edi
  803280:	89 d3                	mov    %edx,%ebx
  803282:	f7 24 24             	mull   (%esp)
  803285:	89 c6                	mov    %eax,%esi
  803287:	89 d1                	mov    %edx,%ecx
  803289:	39 d3                	cmp    %edx,%ebx
  80328b:	0f 82 87 00 00 00    	jb     803318 <__umoddi3+0x134>
  803291:	0f 84 91 00 00 00    	je     803328 <__umoddi3+0x144>
  803297:	8b 54 24 04          	mov    0x4(%esp),%edx
  80329b:	29 f2                	sub    %esi,%edx
  80329d:	19 cb                	sbb    %ecx,%ebx
  80329f:	89 d8                	mov    %ebx,%eax
  8032a1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032a5:	d3 e0                	shl    %cl,%eax
  8032a7:	89 e9                	mov    %ebp,%ecx
  8032a9:	d3 ea                	shr    %cl,%edx
  8032ab:	09 d0                	or     %edx,%eax
  8032ad:	89 e9                	mov    %ebp,%ecx
  8032af:	d3 eb                	shr    %cl,%ebx
  8032b1:	89 da                	mov    %ebx,%edx
  8032b3:	83 c4 1c             	add    $0x1c,%esp
  8032b6:	5b                   	pop    %ebx
  8032b7:	5e                   	pop    %esi
  8032b8:	5f                   	pop    %edi
  8032b9:	5d                   	pop    %ebp
  8032ba:	c3                   	ret    
  8032bb:	90                   	nop
  8032bc:	89 fd                	mov    %edi,%ebp
  8032be:	85 ff                	test   %edi,%edi
  8032c0:	75 0b                	jne    8032cd <__umoddi3+0xe9>
  8032c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c7:	31 d2                	xor    %edx,%edx
  8032c9:	f7 f7                	div    %edi
  8032cb:	89 c5                	mov    %eax,%ebp
  8032cd:	89 f0                	mov    %esi,%eax
  8032cf:	31 d2                	xor    %edx,%edx
  8032d1:	f7 f5                	div    %ebp
  8032d3:	89 c8                	mov    %ecx,%eax
  8032d5:	f7 f5                	div    %ebp
  8032d7:	89 d0                	mov    %edx,%eax
  8032d9:	e9 44 ff ff ff       	jmp    803222 <__umoddi3+0x3e>
  8032de:	66 90                	xchg   %ax,%ax
  8032e0:	89 c8                	mov    %ecx,%eax
  8032e2:	89 f2                	mov    %esi,%edx
  8032e4:	83 c4 1c             	add    $0x1c,%esp
  8032e7:	5b                   	pop    %ebx
  8032e8:	5e                   	pop    %esi
  8032e9:	5f                   	pop    %edi
  8032ea:	5d                   	pop    %ebp
  8032eb:	c3                   	ret    
  8032ec:	3b 04 24             	cmp    (%esp),%eax
  8032ef:	72 06                	jb     8032f7 <__umoddi3+0x113>
  8032f1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032f5:	77 0f                	ja     803306 <__umoddi3+0x122>
  8032f7:	89 f2                	mov    %esi,%edx
  8032f9:	29 f9                	sub    %edi,%ecx
  8032fb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032ff:	89 14 24             	mov    %edx,(%esp)
  803302:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803306:	8b 44 24 04          	mov    0x4(%esp),%eax
  80330a:	8b 14 24             	mov    (%esp),%edx
  80330d:	83 c4 1c             	add    $0x1c,%esp
  803310:	5b                   	pop    %ebx
  803311:	5e                   	pop    %esi
  803312:	5f                   	pop    %edi
  803313:	5d                   	pop    %ebp
  803314:	c3                   	ret    
  803315:	8d 76 00             	lea    0x0(%esi),%esi
  803318:	2b 04 24             	sub    (%esp),%eax
  80331b:	19 fa                	sbb    %edi,%edx
  80331d:	89 d1                	mov    %edx,%ecx
  80331f:	89 c6                	mov    %eax,%esi
  803321:	e9 71 ff ff ff       	jmp    803297 <__umoddi3+0xb3>
  803326:	66 90                	xchg   %ax,%ax
  803328:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80332c:	72 ea                	jb     803318 <__umoddi3+0x134>
  80332e:	89 d9                	mov    %ebx,%ecx
  803330:	e9 62 ff ff ff       	jmp    803297 <__umoddi3+0xb3>

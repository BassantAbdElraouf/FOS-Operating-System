
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 1e 02 00 00       	call   800254 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
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
  80008d:	68 a0 33 80 00       	push   $0x8033a0
  800092:	6a 13                	push   $0x13
  800094:	68 bc 33 80 00       	push   $0x8033bc
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 36 1c 00 00       	call   801cd9 <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 22 1a 00 00       	call   801acd <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 30 19 00 00       	call   8019e0 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 da 33 80 00       	push   $0x8033da
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 d6 16 00 00       	call   801799 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 dc 33 80 00       	push   $0x8033dc
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 bc 33 80 00       	push   $0x8033bc
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 f2 18 00 00       	call   8019e0 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 3c 34 80 00       	push   $0x80343c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 bc 33 80 00       	push   $0x8033bc
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 d7 19 00 00       	call   801ae7 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 b8 19 00 00       	call   801acd <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 c6 18 00 00       	call   8019e0 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 cd 34 80 00       	push   $0x8034cd
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 6c 16 00 00       	call   801799 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 dc 33 80 00       	push   $0x8033dc
  800144:	6a 23                	push   $0x23
  800146:	68 bc 33 80 00       	push   $0x8033bc
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 8b 18 00 00       	call   8019e0 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 3c 34 80 00       	push   $0x80343c
  800166:	6a 24                	push   $0x24
  800168:	68 bc 33 80 00       	push   $0x8033bc
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 70 19 00 00       	call   801ae7 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 d0 34 80 00       	push   $0x8034d0
  800189:	6a 27                	push   $0x27
  80018b:	68 bc 33 80 00       	push   $0x8033bc
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 33 19 00 00       	call   801acd <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 41 18 00 00       	call   8019e0 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 07 35 80 00       	push   $0x803507
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 e7 15 00 00       	call   801799 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 dc 33 80 00       	push   $0x8033dc
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 bc 33 80 00       	push   $0x8033bc
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 06 18 00 00       	call   8019e0 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 3c 34 80 00       	push   $0x80343c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 bc 33 80 00       	push   $0x8033bc
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 eb 18 00 00       	call   801ae7 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 d0 34 80 00       	push   $0x8034d0
  80020e:	6a 30                	push   $0x30
  800210:	68 bc 33 80 00       	push   $0x8033bc
  800215:	e8 76 01 00 00       	call   800390 <_panic>

	*z = *x + *y ;
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	01 c2                	add    %eax,%edx
  800226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800229:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80022b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022e:	8b 00                	mov    (%eax),%eax
  800230:	83 f8 1e             	cmp    $0x1e,%eax
  800233:	74 14                	je     800249 <_main+0x211>
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 d0 34 80 00       	push   $0x8034d0
  80023d:	6a 33                	push   $0x33
  80023f:	68 bc 33 80 00       	push   $0x8033bc
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 b0 1b 00 00       	call   801dfe <inctst>

	return;
  80024e:	90                   	nop
}
  80024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025a:	e8 61 1a 00 00       	call   801cc0 <sys_getenvindex>
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800265:	89 d0                	mov    %edx,%eax
  800267:	c1 e0 03             	shl    $0x3,%eax
  80026a:	01 d0                	add    %edx,%eax
  80026c:	01 c0                	add    %eax,%eax
  80026e:	01 d0                	add    %edx,%eax
  800270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800277:	01 d0                	add    %edx,%eax
  800279:	c1 e0 04             	shl    $0x4,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800286:	a1 20 40 80 00       	mov    0x804020,%eax
  80028b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800291:	84 c0                	test   %al,%al
  800293:	74 0f                	je     8002a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800295:	a1 20 40 80 00       	mov    0x804020,%eax
  80029a:	05 5c 05 00 00       	add    $0x55c,%eax
  80029f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a8:	7e 0a                	jle    8002b4 <libmain+0x60>
		binaryname = argv[0];
  8002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 76 fd ff ff       	call   800038 <_main>
  8002c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c5:	e8 03 18 00 00       	call   801acd <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 24 35 80 00       	push   $0x803524
  8002d2:	e8 6d 03 00 00       	call   800644 <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002da:	a1 20 40 80 00       	mov    0x804020,%eax
  8002df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 4c 35 80 00       	push   $0x80354c
  8002fa:	e8 45 03 00 00       	call   800644 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800302:	a1 20 40 80 00       	mov    0x804020,%eax
  800307:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800318:	a1 20 40 80 00       	mov    0x804020,%eax
  80031d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800323:	51                   	push   %ecx
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	68 74 35 80 00       	push   $0x803574
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 40 80 00       	mov    0x804020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 cc 35 80 00       	push   $0x8035cc
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 24 35 80 00       	push   $0x803524
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 83 17 00 00       	call   801ae7 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800364:	e8 19 00 00 00       	call   800382 <exit>
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 10 19 00 00       	call   801c8c <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 65 19 00 00       	call   801cf2 <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 e0 35 80 00       	push   $0x8035e0
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 e5 35 80 00       	push   $0x8035e5
  8003cf:	e8 70 02 00 00       	call   800644 <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	e8 f3 01 00 00       	call   8005d9 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	68 01 36 80 00       	push   $0x803601
  8003f3:	e8 e1 01 00 00       	call   8005d9 <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fb:	e8 82 ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800400:	eb fe                	jmp    800400 <_panic+0x70>

00800402 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800408:	a1 20 40 80 00       	mov    0x804020,%eax
  80040d:	8b 50 74             	mov    0x74(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 04 36 80 00       	push   $0x803604
  80041f:	6a 26                	push   $0x26
  800421:	68 50 36 80 00       	push   $0x803650
  800426:	e8 65 ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 c2 00 00 00       	jmp    800500 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 a2 00 00 00       	jmp    8004fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 69                	jmp    8004d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 20 40 80 00       	mov    0x804020,%eax
  800470:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c1 e0 03             	shl    $0x3,%eax
  800482:	01 c8                	add    %ecx,%eax
  800484:	8a 40 04             	mov    0x4(%eax),%al
  800487:	84 c0                	test   %al,%al
  800489:	75 46                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048b:	a1 20 40 80 00       	mov    0x804020,%eax
  800490:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c4:	39 c2                	cmp    %eax,%edx
  8004c6:	75 09                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cf:	eb 12                	jmp    8004e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d1:	ff 45 e8             	incl   -0x18(%ebp)
  8004d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d9:	8b 50 74             	mov    0x74(%eax),%edx
  8004dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004df:	39 c2                	cmp    %eax,%edx
  8004e1:	77 88                	ja     80046b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e7:	75 14                	jne    8004fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 5c 36 80 00       	push   $0x80365c
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 50 36 80 00       	push   $0x803650
  8004f8:	e8 93 fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fd:	ff 45 f0             	incl   -0x10(%ebp)
  800500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800503:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800506:	0f 8c 32 ff ff ff    	jl     80043e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800513:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051a:	eb 26                	jmp    800542 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800527:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	01 c0                	add    %eax,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	c1 e0 03             	shl    $0x3,%eax
  800533:	01 c8                	add    %ecx,%eax
  800535:	8a 40 04             	mov    0x4(%eax),%al
  800538:	3c 01                	cmp    $0x1,%al
  80053a:	75 03                	jne    80053f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80053c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053f:	ff 45 e0             	incl   -0x20(%ebp)
  800542:	a1 20 40 80 00       	mov    0x804020,%eax
  800547:	8b 50 74             	mov    0x74(%eax),%edx
  80054a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054d:	39 c2                	cmp    %eax,%edx
  80054f:	77 cb                	ja     80051c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800557:	74 14                	je     80056d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800559:	83 ec 04             	sub    $0x4,%esp
  80055c:	68 b0 36 80 00       	push   $0x8036b0
  800561:	6a 44                	push   $0x44
  800563:	68 50 36 80 00       	push   $0x803650
  800568:	e8 23 fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	8d 48 01             	lea    0x1(%eax),%ecx
  80057e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800581:	89 0a                	mov    %ecx,(%edx)
  800583:	8b 55 08             	mov    0x8(%ebp),%edx
  800586:	88 d1                	mov    %dl,%cl
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	3d ff 00 00 00       	cmp    $0xff,%eax
  800599:	75 2c                	jne    8005c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80059b:	a0 24 40 80 00       	mov    0x804024,%al
  8005a0:	0f b6 c0             	movzbl %al,%eax
  8005a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a6:	8b 12                	mov    (%edx),%edx
  8005a8:	89 d1                	mov    %edx,%ecx
  8005aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ad:	83 c2 08             	add    $0x8,%edx
  8005b0:	83 ec 04             	sub    $0x4,%esp
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	52                   	push   %edx
  8005b6:	e8 64 13 00 00       	call   80191f <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	8b 40 04             	mov    0x4(%eax),%eax
  8005cd:	8d 50 01             	lea    0x1(%eax),%edx
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e9:	00 00 00 
	b.cnt = 0;
  8005ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	68 70 05 80 00       	push   $0x800570
  800608:	e8 11 02 00 00       	call   80081e <vprintfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800610:	a0 24 40 80 00       	mov    0x804024,%al
  800615:	0f b6 c0             	movzbl %al,%eax
  800618:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	50                   	push   %eax
  800622:	52                   	push   %edx
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	83 c0 08             	add    $0x8,%eax
  80062c:	50                   	push   %eax
  80062d:	e8 ed 12 00 00       	call   80191f <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800635:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <cprintf>:

int cprintf(const char *fmt, ...) {
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80064a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 73 ff ff ff       	call   8005d9 <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800677:	e8 51 14 00 00       	call   801acd <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 48 ff ff ff       	call   8005d9 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800697:	e8 4b 14 00 00       	call   801ae7 <sys_enable_interrupt>
	return cnt;
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 14             	sub    $0x14,%esp
  8006a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	77 55                	ja     800716 <printnum+0x75>
  8006c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c4:	72 05                	jb     8006cb <printnum+0x2a>
  8006c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c9:	77 4b                	ja     800716 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	52                   	push   %edx
  8006da:	50                   	push   %eax
  8006db:	ff 75 f4             	pushl  -0xc(%ebp)
  8006de:	ff 75 f0             	pushl  -0x10(%ebp)
  8006e1:	e8 46 2a 00 00       	call   80312c <__udivdi3>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	53                   	push   %ebx
  8006f0:	ff 75 18             	pushl  0x18(%ebp)
  8006f3:	52                   	push   %edx
  8006f4:	50                   	push   %eax
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 a1 ff ff ff       	call   8006a1 <printnum>
  800700:	83 c4 20             	add    $0x20,%esp
  800703:	eb 1a                	jmp    80071f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 20             	pushl  0x20(%ebp)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800716:	ff 4d 1c             	decl   0x1c(%ebp)
  800719:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80071d:	7f e6                	jg     800705 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800722:	bb 00 00 00 00       	mov    $0x0,%ebx
  800727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	53                   	push   %ebx
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	e8 06 2b 00 00       	call   80323c <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 14 39 80 00       	add    $0x803914,%eax
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f be c0             	movsbl %al,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	ff d0                	call   *%eax
  80074f:	83 c4 10             	add    $0x10,%esp
}
  800752:	90                   	nop
  800753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075f:	7e 1c                	jle    80077d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 08             	lea    0x8(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 08             	sub    $0x8,%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	eb 40                	jmp    8007bd <getuint+0x65>
	else if (lflag)
  80077d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800781:	74 1e                	je     8007a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	eb 1c                	jmp    8007bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c6:	7e 1c                	jle    8007e4 <getint+0x25>
		return va_arg(*ap, long long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 08             	lea    0x8(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 08             	sub    $0x8,%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	eb 38                	jmp    80081c <getint+0x5d>
	else if (lflag)
  8007e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e8:	74 1a                	je     800804 <getint+0x45>
		return va_arg(*ap, long);
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	8d 50 04             	lea    0x4(%eax),%edx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	89 10                	mov    %edx,(%eax)
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	99                   	cltd   
  800802:	eb 18                	jmp    80081c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	8d 50 04             	lea    0x4(%eax),%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	89 10                	mov    %edx,(%eax)
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	83 e8 04             	sub    $0x4,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	99                   	cltd   
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800826:	eb 17                	jmp    80083f <vprintfmt+0x21>
			if (ch == '\0')
  800828:	85 db                	test   %ebx,%ebx
  80082a:	0f 84 af 03 00 00    	je     800bdf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083f:	8b 45 10             	mov    0x10(%ebp),%eax
  800842:	8d 50 01             	lea    0x1(%eax),%edx
  800845:	89 55 10             	mov    %edx,0x10(%ebp)
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f b6 d8             	movzbl %al,%ebx
  80084d:	83 fb 25             	cmp    $0x25,%ebx
  800850:	75 d6                	jne    800828 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800852:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800856:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80085d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800864:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80086b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	8d 50 01             	lea    0x1(%eax),%edx
  800878:	89 55 10             	mov    %edx,0x10(%ebp)
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f b6 d8             	movzbl %al,%ebx
  800880:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800883:	83 f8 55             	cmp    $0x55,%eax
  800886:	0f 87 2b 03 00 00    	ja     800bb7 <vprintfmt+0x399>
  80088c:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  800893:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800895:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800899:	eb d7                	jmp    800872 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089f:	eb d1                	jmp    800872 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	c1 e0 02             	shl    $0x2,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	83 e8 30             	sub    $0x30,%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c7:	7e 3e                	jle    800907 <vprintfmt+0xe9>
  8008c9:	83 fb 39             	cmp    $0x39,%ebx
  8008cc:	7f 39                	jg     800907 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d1:	eb d5                	jmp    8008a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 c0 04             	add    $0x4,%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e7:	eb 1f                	jmp    800908 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	79 83                	jns    800872 <vprintfmt+0x54>
				width = 0;
  8008ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f6:	e9 77 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800902:	e9 6b ff ff ff       	jmp    800872 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800907:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 60 ff ff ff    	jns    800872 <vprintfmt+0x54>
				width = precision, precision = -1;
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091f:	e9 4e ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800924:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800927:	e9 46 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			break;
  80094c:	e9 89 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800962:	85 db                	test   %ebx,%ebx
  800964:	79 02                	jns    800968 <vprintfmt+0x14a>
				err = -err;
  800966:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800968:	83 fb 64             	cmp    $0x64,%ebx
  80096b:	7f 0b                	jg     800978 <vprintfmt+0x15a>
  80096d:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 25 39 80 00       	push   $0x803925
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 5e 02 00 00       	call   800be7 <printfmt>
  800989:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098c:	e9 49 02 00 00       	jmp    800bda <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	56                   	push   %esi
  800992:	68 2e 39 80 00       	push   $0x80392e
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 45 02 00 00       	call   800be7 <printfmt>
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 30 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 30                	mov    (%eax),%esi
  8009bb:	85 f6                	test   %esi,%esi
  8009bd:	75 05                	jne    8009c4 <vprintfmt+0x1a6>
				p = "(null)";
  8009bf:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  8009c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c8:	7e 6d                	jle    800a37 <vprintfmt+0x219>
  8009ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ce:	74 67                	je     800a37 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	50                   	push   %eax
  8009d7:	56                   	push   %esi
  8009d8:	e8 0c 03 00 00       	call   800ce9 <strnlen>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e3:	eb 16                	jmp    8009fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ff:	7f e4                	jg     8009e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a01:	eb 34                	jmp    800a37 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a07:	74 1c                	je     800a25 <vprintfmt+0x207>
  800a09:	83 fb 1f             	cmp    $0x1f,%ebx
  800a0c:	7e 05                	jle    800a13 <vprintfmt+0x1f5>
  800a0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a11:	7e 12                	jle    800a25 <vprintfmt+0x207>
					putch('?', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 3f                	push   $0x3f
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	eb 0f                	jmp    800a34 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a34:	ff 4d e4             	decl   -0x1c(%ebp)
  800a37:	89 f0                	mov    %esi,%eax
  800a39:	8d 70 01             	lea    0x1(%eax),%esi
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	74 24                	je     800a69 <vprintfmt+0x24b>
  800a45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a49:	78 b8                	js     800a03 <vprintfmt+0x1e5>
  800a4b:	ff 4d e0             	decl   -0x20(%ebp)
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	79 af                	jns    800a03 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	eb 13                	jmp    800a69 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 20                	push   $0x20
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a66:	ff 4d e4             	decl   -0x1c(%ebp)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	7f e7                	jg     800a56 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6f:	e9 66 01 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 3c fd ff ff       	call   8007bf <getint>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a92:	85 d2                	test   %edx,%edx
  800a94:	79 23                	jns    800ab9 <vprintfmt+0x29b>
				putch('-', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 2d                	push   $0x2d
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aac:	f7 d8                	neg    %eax
  800aae:	83 d2 00             	adc    $0x0,%edx
  800ab1:	f7 da                	neg    %edx
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac0:	e9 bc 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 e8             	pushl  -0x18(%ebp)
  800acb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	e8 84 fc ff ff       	call   800758 <getuint>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800add:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae4:	e9 98 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 58                	push   $0x58
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	6a 58                	push   $0x58
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 58                	push   $0x58
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			break;
  800b19:	e9 bc 00 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 30                	push   $0x30
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 78                	push   $0x78
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 c0 04             	add    $0x4,%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 e8 04             	sub    $0x4,%eax
  800b4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b60:	eb 1f                	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e8             	pushl  -0x18(%ebp)
  800b68:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	e8 e7 fb ff ff       	call   800758 <getuint>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	ff 75 f0             	pushl  -0x10(%ebp)
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 00 fb ff ff       	call   8006a1 <printnum>
  800ba1:	83 c4 20             	add    $0x20,%esp
			break;
  800ba4:	eb 34                	jmp    800bda <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	eb 23                	jmp    800bda <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 25                	push   $0x25
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	eb 03                	jmp    800bcf <vprintfmt+0x3b1>
  800bcc:	ff 4d 10             	decl   0x10(%ebp)
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	48                   	dec    %eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	3c 25                	cmp    $0x25,%al
  800bd7:	75 f3                	jne    800bcc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd9:	90                   	nop
		}
	}
  800bda:	e9 47 fc ff ff       	jmp    800826 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bdf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bed:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf0:	83 c0 04             	add    $0x4,%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 16 fc ff ff       	call   80081e <vprintfmt>
  800c08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0b:	90                   	nop
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 40 08             	mov    0x8(%eax),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8b 40 04             	mov    0x4(%eax),%eax
  800c2b:	39 c2                	cmp    %eax,%edx
  800c2d:	73 12                	jae    800c41 <sprintputch+0x33>
		*b->buf++ = ch;
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	8d 48 01             	lea    0x1(%eax),%ecx
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 0a                	mov    %ecx,(%edx)
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	88 10                	mov    %dl,(%eax)
}
  800c41:	90                   	nop
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c69:	74 06                	je     800c71 <vsnprintf+0x2d>
  800c6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6f:	7f 07                	jg     800c78 <vsnprintf+0x34>
		return -E_INVAL;
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	eb 20                	jmp    800c98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c78:	ff 75 14             	pushl  0x14(%ebp)
  800c7b:	ff 75 10             	pushl  0x10(%ebp)
  800c7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	68 0e 0c 80 00       	push   $0x800c0e
  800c87:	e8 92 fb ff ff       	call   80081e <vprintfmt>
  800c8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	50                   	push   %eax
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 89 ff ff ff       	call   800c44 <vsnprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd3:	eb 06                	jmp    800cdb <strlen+0x15>
		n++;
  800cd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	84 c0                	test   %al,%al
  800ce2:	75 f1                	jne    800cd5 <strlen+0xf>
		n++;
	return n;
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 09                	jmp    800d01 <strnlen+0x18>
		n++;
  800cf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 4d 0c             	decl   0xc(%ebp)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 09                	je     800d10 <strnlen+0x27>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e8                	jne    800cf8 <strnlen+0xf>
		n++;
	return n;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d21:	90                   	nop
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	75 e4                	jne    800d22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 1f                	jmp    800d77 <strncpy+0x34>
		*dst++ = *src;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	8a 12                	mov    (%edx),%dl
  800d66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 03                	je     800d74 <strncpy+0x31>
			src++;
  800d71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7d:	72 d9                	jb     800d58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d94:	74 30                	je     800dc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d96:	eb 16                	jmp    800dae <strlcpy+0x2a>
			*dst++ = *src++;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800daa:	8a 12                	mov    (%edx),%dl
  800dac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dae:	ff 4d 10             	decl   0x10(%ebp)
  800db1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db5:	74 09                	je     800dc0 <strlcpy+0x3c>
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 d8                	jne    800d98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	29 c2                	sub    %eax,%edx
  800dce:	89 d0                	mov    %edx,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0xb>
		p++, q++;
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	74 0e                	je     800df4 <strcmp+0x22>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 10                	mov    (%eax),%dl
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	38 c2                	cmp    %al,%dl
  800df2:	74 e3                	je     800dd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0d:	eb 09                	jmp    800e18 <strncmp+0xe>
		n--, p++, q++;
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 17                	je     800e35 <strncmp+0x2b>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	74 0e                	je     800e35 <strncmp+0x2b>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 10                	mov    (%eax),%dl
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	38 c2                	cmp    %al,%dl
  800e33:	74 da                	je     800e0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	75 07                	jne    800e42 <strncmp+0x38>
		return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	eb 14                	jmp    800e56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d0             	movzbl %al,%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	0f b6 c0             	movzbl %al,%eax
  800e52:	29 c2                	sub    %eax,%edx
  800e54:	89 d0                	mov    %edx,%eax
}
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e64:	eb 12                	jmp    800e78 <strchr+0x20>
		if (*s == c)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6e:	75 05                	jne    800e75 <strchr+0x1d>
			return (char *) s;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	eb 11                	jmp    800e86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e5                	jne    800e66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e94:	eb 0d                	jmp    800ea3 <strfind+0x1b>
		if (*s == c)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9e:	74 0e                	je     800eae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	75 ea                	jne    800e96 <strfind+0xe>
  800eac:	eb 01                	jmp    800eaf <strfind+0x27>
		if (*s == c)
			break;
  800eae:	90                   	nop
	return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec6:	eb 0e                	jmp    800ed6 <memset+0x22>
		*p++ = c;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed6:	ff 4d f8             	decl   -0x8(%ebp)
  800ed9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800edd:	79 e9                	jns    800ec8 <memset+0x14>
		*p++ = c;

	return v;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef6:	eb 16                	jmp    800f0e <memcpy+0x2a>
		*d++ = *s++;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0a:	8a 12                	mov    (%edx),%dl
  800f0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 dd                	jne    800ef8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f38:	73 50                	jae    800f8a <memmove+0x6a>
  800f3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	76 43                	jbe    800f8a <memmove+0x6a>
		s += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f53:	eb 10                	jmp    800f65 <memmove+0x45>
			*--d = *--s;
  800f55:	ff 4d f8             	decl   -0x8(%ebp)
  800f58:	ff 4d fc             	decl   -0x4(%ebp)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 e3                	jne    800f55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f72:	eb 23                	jmp    800f97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fae:	eb 2a                	jmp    800fda <memcmp+0x3e>
		if (*s1 != *s2)
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 16                	je     800fd4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d0             	movzbl %al,%edx
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	eb 18                	jmp    800fec <memcmp+0x50>
		s1++, s2++;
  800fd4:	ff 45 fc             	incl   -0x4(%ebp)
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	75 c9                	jne    800fb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fff:	eb 15                	jmp    801016 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 d0             	movzbl %al,%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	39 c2                	cmp    %eax,%edx
  801011:	74 0d                	je     801020 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80101c:	72 e3                	jb     801001 <memfind+0x13>
  80101e:	eb 01                	jmp    801021 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801020:	90                   	nop
	return (void *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80102c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801033:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	eb 03                	jmp    80103f <strtol+0x19>
		s++;
  80103c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f4                	je     80103c <strtol+0x16>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 09                	cmp    $0x9,%al
  80104f:	74 eb                	je     80103c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 2b                	cmp    $0x2b,%al
  801058:	75 05                	jne    80105f <strtol+0x39>
		s++;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	eb 13                	jmp    801072 <strtol+0x4c>
	else if (*s == '-')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 2d                	cmp    $0x2d,%al
  801066:	75 0a                	jne    801072 <strtol+0x4c>
		s++, neg = 1;
  801068:	ff 45 08             	incl   0x8(%ebp)
  80106b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801076:	74 06                	je     80107e <strtol+0x58>
  801078:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80107c:	75 20                	jne    80109e <strtol+0x78>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 17                	jne    80109e <strtol+0x78>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	40                   	inc    %eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 78                	cmp    $0x78,%al
  80108f:	75 0d                	jne    80109e <strtol+0x78>
		s += 2, base = 16;
  801091:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801095:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80109c:	eb 28                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 15                	jne    8010b9 <strtol+0x93>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 30                	cmp    $0x30,%al
  8010ab:	75 0c                	jne    8010b9 <strtol+0x93>
		s++, base = 8;
  8010ad:	ff 45 08             	incl   0x8(%ebp)
  8010b0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b7:	eb 0d                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0)
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	75 07                	jne    8010c6 <strtol+0xa0>
		base = 10;
  8010bf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 2f                	cmp    $0x2f,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xc2>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 39                	cmp    $0x39,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xc2>
			dig = *s - '0';
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 30             	sub    $0x30,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 42                	jmp    80112a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 60                	cmp    $0x60,%al
  8010ef:	7e 19                	jle    80110a <strtol+0xe4>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 7a                	cmp    $0x7a,%al
  8010f8:	7f 10                	jg     80110a <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 57             	sub    $0x57,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801108:	eb 20                	jmp    80112a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 40                	cmp    $0x40,%al
  801111:	7e 39                	jle    80114c <strtol+0x126>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 5a                	cmp    $0x5a,%al
  80111a:	7f 30                	jg     80114c <strtol+0x126>
			dig = *s - 'A' + 10;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f be c0             	movsbl %al,%eax
  801124:	83 e8 37             	sub    $0x37,%eax
  801127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801130:	7d 19                	jge    80114b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801138:	0f af 45 10          	imul   0x10(%ebp),%eax
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801146:	e9 7b ff ff ff       	jmp    8010c6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80114b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801150:	74 08                	je     80115a <strtol+0x134>
		*endptr = (char *) s;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80115a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80115e:	74 07                	je     801167 <strtol+0x141>
  801160:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801163:	f7 d8                	neg    %eax
  801165:	eb 03                	jmp    80116a <strtol+0x144>
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <ltostr>:

void
ltostr(long value, char *str)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801184:	79 13                	jns    801199 <ltostr+0x2d>
	{
		neg = 1;
  801186:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801193:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801196:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011a1:	99                   	cltd   
  8011a2:	f7 f9                	idiv   %ecx
  8011a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8d 50 01             	lea    0x1(%eax),%edx
  8011ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ba:	83 c2 30             	add    $0x30,%edx
  8011bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c7:	f7 e9                	imul   %ecx
  8011c9:	c1 fa 02             	sar    $0x2,%edx
  8011cc:	89 c8                	mov    %ecx,%eax
  8011ce:	c1 f8 1f             	sar    $0x1f,%eax
  8011d1:	29 c2                	sub    %eax,%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e0:	f7 e9                	imul   %ecx
  8011e2:	c1 fa 02             	sar    $0x2,%edx
  8011e5:	89 c8                	mov    %ecx,%eax
  8011e7:	c1 f8 1f             	sar    $0x1f,%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
  8011ee:	c1 e0 02             	shl    $0x2,%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	01 c0                	add    %eax,%eax
  8011f5:	29 c1                	sub    %eax,%ecx
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	75 9c                	jne    801199 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	48                   	dec    %eax
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120f:	74 3d                	je     80124e <ltostr+0xe2>
		start = 1 ;
  801211:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801218:	eb 34                	jmp    80124e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	01 c8                	add    %ecx,%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8a 45 eb             	mov    -0x15(%ebp),%al
  801246:	88 02                	mov    %al,(%edx)
		start++ ;
  801248:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801251:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801254:	7c c4                	jl     80121a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801256:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 54 fa ff ff       	call   800cc6 <strlen>
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	e8 46 fa ff ff       	call   800cc6 <strlen>
  801280:	83 c4 04             	add    $0x4,%esp
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801294:	eb 17                	jmp    8012ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 c2                	add    %eax,%edx
  80129e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 c8                	add    %ecx,%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012aa:	ff 45 fc             	incl   -0x4(%ebp)
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b3:	7c e1                	jl     801296 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c3:	eb 1f                	jmp    8012e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 c2                	add    %eax,%edx
  8012d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 c8                	add    %ecx,%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e1:	ff 45 f8             	incl   -0x8(%ebp)
  8012e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ea:	7c d9                	jl     8012c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801306:	8b 45 14             	mov    0x14(%ebp),%eax
  801309:	8b 00                	mov    (%eax),%eax
  80130b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131d:	eb 0c                	jmp    80132b <strsplit+0x31>
			*string++ = 0;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 08             	mov    %edx,0x8(%ebp)
  801328:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	74 18                	je     80134c <strsplit+0x52>
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	e8 13 fb ff ff       	call   800e58 <strchr>
  801345:	83 c4 08             	add    $0x8,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 d3                	jne    80131f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 5a                	je     8013af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	83 f8 0f             	cmp    $0xf,%eax
  80135d:	75 07                	jne    801366 <strsplit+0x6c>
		{
			return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	eb 66                	jmp    8013cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801366:	8b 45 14             	mov    0x14(%ebp),%eax
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	8d 48 01             	lea    0x1(%eax),%ecx
  80136e:	8b 55 14             	mov    0x14(%ebp),%edx
  801371:	89 0a                	mov    %ecx,(%edx)
  801373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	01 c2                	add    %eax,%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	eb 03                	jmp    801389 <strsplit+0x8f>
			string++;
  801386:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	84 c0                	test   %al,%al
  801390:	74 8b                	je     80131d <strsplit+0x23>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	0f be c0             	movsbl %al,%eax
  80139a:	50                   	push   %eax
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	e8 b5 fa ff ff       	call   800e58 <strchr>
  8013a3:	83 c4 08             	add    $0x8,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	74 dc                	je     801386 <strsplit+0x8c>
			string++;
	}
  8013aa:	e9 6e ff ff ff       	jmp    80131d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b3:	8b 00                	mov    (%eax),%eax
  8013b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bf:	01 d0                	add    %edx,%eax
  8013c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 1f                	je     8013fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013dd:	e8 1d 00 00 00       	call   8013ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013e2:	83 ec 0c             	sub    $0xc,%esp
  8013e5:	68 90 3a 80 00       	push   $0x803a90
  8013ea:	e8 55 f2 ff ff       	call   800644 <cprintf>
  8013ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013f9:	00 00 00 
	}
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801405:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80140c:	00 00 00 
  80140f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801416:	00 00 00 
  801419:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801420:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801423:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80142a:	00 00 00 
  80142d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801434:	00 00 00 
  801437:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80143e:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  801441:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801448:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  80144b:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  801452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801455:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80145a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80145f:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801464:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80146b:	a1 20 41 80 00       	mov    0x804120,%eax
  801470:	c1 e0 04             	shl    $0x4,%eax
  801473:	89 c2                	mov    %eax,%edx
  801475:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801478:	01 d0                	add    %edx,%eax
  80147a:	48                   	dec    %eax
  80147b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80147e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801481:	ba 00 00 00 00       	mov    $0x0,%edx
  801486:	f7 75 f0             	divl   -0x10(%ebp)
  801489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80148c:	29 d0                	sub    %edx,%eax
  80148e:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801491:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  801498:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80149b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014a5:	83 ec 04             	sub    $0x4,%esp
  8014a8:	6a 06                	push   $0x6
  8014aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ad:	50                   	push   %eax
  8014ae:	e8 b0 05 00 00       	call   801a63 <sys_allocate_chunk>
  8014b3:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014b6:	a1 20 41 80 00       	mov    0x804120,%eax
  8014bb:	83 ec 0c             	sub    $0xc,%esp
  8014be:	50                   	push   %eax
  8014bf:	e8 25 0c 00 00       	call   8020e9 <initialize_MemBlocksList>
  8014c4:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8014c7:	a1 48 41 80 00       	mov    0x804148,%eax
  8014cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8014cf:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014d3:	75 14                	jne    8014e9 <initialize_dyn_block_system+0xea>
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	68 b5 3a 80 00       	push   $0x803ab5
  8014dd:	6a 29                	push   $0x29
  8014df:	68 d3 3a 80 00       	push   $0x803ad3
  8014e4:	e8 a7 ee ff ff       	call   800390 <_panic>
  8014e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ec:	8b 00                	mov    (%eax),%eax
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	74 10                	je     801502 <initialize_dyn_block_system+0x103>
  8014f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f5:	8b 00                	mov    (%eax),%eax
  8014f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014fa:	8b 52 04             	mov    0x4(%edx),%edx
  8014fd:	89 50 04             	mov    %edx,0x4(%eax)
  801500:	eb 0b                	jmp    80150d <initialize_dyn_block_system+0x10e>
  801502:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801505:	8b 40 04             	mov    0x4(%eax),%eax
  801508:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80150d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801510:	8b 40 04             	mov    0x4(%eax),%eax
  801513:	85 c0                	test   %eax,%eax
  801515:	74 0f                	je     801526 <initialize_dyn_block_system+0x127>
  801517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151a:	8b 40 04             	mov    0x4(%eax),%eax
  80151d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801520:	8b 12                	mov    (%edx),%edx
  801522:	89 10                	mov    %edx,(%eax)
  801524:	eb 0a                	jmp    801530 <initialize_dyn_block_system+0x131>
  801526:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801529:	8b 00                	mov    (%eax),%eax
  80152b:	a3 48 41 80 00       	mov    %eax,0x804148
  801530:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801533:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801539:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80153c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801543:	a1 54 41 80 00       	mov    0x804154,%eax
  801548:	48                   	dec    %eax
  801549:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80154e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801551:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801558:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  801562:	83 ec 0c             	sub    $0xc,%esp
  801565:	ff 75 e0             	pushl  -0x20(%ebp)
  801568:	e8 b9 14 00 00       	call   802a26 <insert_sorted_with_merge_freeList>
  80156d:	83 c4 10             	add    $0x10,%esp

}
  801570:	90                   	nop
  801571:	c9                   	leave  
  801572:	c3                   	ret    

00801573 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801573:	55                   	push   %ebp
  801574:	89 e5                	mov    %esp,%ebp
  801576:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801579:	e8 50 fe ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80157e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801582:	75 07                	jne    80158b <malloc+0x18>
  801584:	b8 00 00 00 00       	mov    $0x0,%eax
  801589:	eb 68                	jmp    8015f3 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  80158b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801592:	8b 55 08             	mov    0x8(%ebp),%edx
  801595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801598:	01 d0                	add    %edx,%eax
  80159a:	48                   	dec    %eax
  80159b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80159e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a6:	f7 75 f4             	divl   -0xc(%ebp)
  8015a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ac:	29 d0                	sub    %edx,%eax
  8015ae:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8015b1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015b8:	e8 74 08 00 00       	call   801e31 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	74 2d                	je     8015ee <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8015c1:	83 ec 0c             	sub    $0xc,%esp
  8015c4:	ff 75 ec             	pushl  -0x14(%ebp)
  8015c7:	e8 52 0e 00 00       	call   80241e <alloc_block_FF>
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8015d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015d6:	74 16                	je     8015ee <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8015d8:	83 ec 0c             	sub    $0xc,%esp
  8015db:	ff 75 e8             	pushl  -0x18(%ebp)
  8015de:	e8 3b 0c 00 00       	call   80221e <insert_sorted_allocList>
  8015e3:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8015e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015e9:	8b 40 08             	mov    0x8(%eax),%eax
  8015ec:	eb 05                	jmp    8015f3 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8015ee:	b8 00 00 00 00       	mov    $0x0,%eax

}
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    

008015f5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	83 ec 08             	sub    $0x8,%esp
  801601:	50                   	push   %eax
  801602:	68 40 40 80 00       	push   $0x804040
  801607:	e8 ba 0b 00 00       	call   8021c6 <find_block>
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801615:	8b 40 0c             	mov    0xc(%eax),%eax
  801618:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  80161b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80161f:	0f 84 9f 00 00 00    	je     8016c4 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	83 ec 08             	sub    $0x8,%esp
  80162b:	ff 75 f0             	pushl  -0x10(%ebp)
  80162e:	50                   	push   %eax
  80162f:	e8 f7 03 00 00       	call   801a2b <sys_free_user_mem>
  801634:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801637:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80163b:	75 14                	jne    801651 <free+0x5c>
  80163d:	83 ec 04             	sub    $0x4,%esp
  801640:	68 b5 3a 80 00       	push   $0x803ab5
  801645:	6a 6a                	push   $0x6a
  801647:	68 d3 3a 80 00       	push   $0x803ad3
  80164c:	e8 3f ed ff ff       	call   800390 <_panic>
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	8b 00                	mov    (%eax),%eax
  801656:	85 c0                	test   %eax,%eax
  801658:	74 10                	je     80166a <free+0x75>
  80165a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165d:	8b 00                	mov    (%eax),%eax
  80165f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801662:	8b 52 04             	mov    0x4(%edx),%edx
  801665:	89 50 04             	mov    %edx,0x4(%eax)
  801668:	eb 0b                	jmp    801675 <free+0x80>
  80166a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166d:	8b 40 04             	mov    0x4(%eax),%eax
  801670:	a3 44 40 80 00       	mov    %eax,0x804044
  801675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801678:	8b 40 04             	mov    0x4(%eax),%eax
  80167b:	85 c0                	test   %eax,%eax
  80167d:	74 0f                	je     80168e <free+0x99>
  80167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801682:	8b 40 04             	mov    0x4(%eax),%eax
  801685:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801688:	8b 12                	mov    (%edx),%edx
  80168a:	89 10                	mov    %edx,(%eax)
  80168c:	eb 0a                	jmp    801698 <free+0xa3>
  80168e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801691:	8b 00                	mov    (%eax),%eax
  801693:	a3 40 40 80 00       	mov    %eax,0x804040
  801698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016ab:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016b0:	48                   	dec    %eax
  8016b1:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8016b6:	83 ec 0c             	sub    $0xc,%esp
  8016b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8016bc:	e8 65 13 00 00       	call   802a26 <insert_sorted_with_merge_freeList>
  8016c1:	83 c4 10             	add    $0x10,%esp
	}
}
  8016c4:	90                   	nop
  8016c5:	c9                   	leave  
  8016c6:	c3                   	ret    

008016c7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016c7:	55                   	push   %ebp
  8016c8:	89 e5                	mov    %esp,%ebp
  8016ca:	83 ec 28             	sub    $0x28,%esp
  8016cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016d0:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016d3:	e8 f6 fc ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  8016d8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016dc:	75 0a                	jne    8016e8 <smalloc+0x21>
  8016de:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e3:	e9 af 00 00 00       	jmp    801797 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8016e8:	e8 44 07 00 00       	call   801e31 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016ed:	83 f8 01             	cmp    $0x1,%eax
  8016f0:	0f 85 9c 00 00 00    	jne    801792 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  8016f6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8016fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801700:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801703:	01 d0                	add    %edx,%eax
  801705:	48                   	dec    %eax
  801706:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170c:	ba 00 00 00 00       	mov    $0x0,%edx
  801711:	f7 75 f4             	divl   -0xc(%ebp)
  801714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801717:	29 d0                	sub    %edx,%eax
  801719:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  80171c:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801723:	76 07                	jbe    80172c <smalloc+0x65>
			return NULL;
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
  80172a:	eb 6b                	jmp    801797 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  80172c:	83 ec 0c             	sub    $0xc,%esp
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	e8 e7 0c 00 00       	call   80241e <alloc_block_FF>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80173d:	83 ec 0c             	sub    $0xc,%esp
  801740:	ff 75 ec             	pushl  -0x14(%ebp)
  801743:	e8 d6 0a 00 00       	call   80221e <insert_sorted_allocList>
  801748:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  80174b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80174f:	75 07                	jne    801758 <smalloc+0x91>
		{
			return NULL;
  801751:	b8 00 00 00 00       	mov    $0x0,%eax
  801756:	eb 3f                	jmp    801797 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801758:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175b:	8b 40 08             	mov    0x8(%eax),%eax
  80175e:	89 c2                	mov    %eax,%edx
  801760:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801764:	52                   	push   %edx
  801765:	50                   	push   %eax
  801766:	ff 75 0c             	pushl  0xc(%ebp)
  801769:	ff 75 08             	pushl  0x8(%ebp)
  80176c:	e8 45 04 00 00       	call   801bb6 <sys_createSharedObject>
  801771:	83 c4 10             	add    $0x10,%esp
  801774:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801777:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  80177b:	74 06                	je     801783 <smalloc+0xbc>
  80177d:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801781:	75 07                	jne    80178a <smalloc+0xc3>
		{
			return NULL;
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	eb 0d                	jmp    801797 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  80178a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80178d:	8b 40 08             	mov    0x8(%eax),%eax
  801790:	eb 05                	jmp    801797 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801797:	c9                   	leave  
  801798:	c3                   	ret    

00801799 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80179f:	e8 2a fc ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	e8 2e 04 00 00       	call   801be0 <sys_getSizeOfSharedObject>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8017b8:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017bc:	75 0a                	jne    8017c8 <sget+0x2f>
	{
		return NULL;
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	e9 94 00 00 00       	jmp    80185c <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017c8:	e8 64 06 00 00       	call   801e31 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017cd:	85 c0                	test   %eax,%eax
  8017cf:	0f 84 82 00 00 00    	je     801857 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8017d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8017dc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017e9:	01 d0                	add    %edx,%eax
  8017eb:	48                   	dec    %eax
  8017ec:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f7:	f7 75 ec             	divl   -0x14(%ebp)
  8017fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017fd:	29 d0                	sub    %edx,%eax
  8017ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801805:	83 ec 0c             	sub    $0xc,%esp
  801808:	50                   	push   %eax
  801809:	e8 10 0c 00 00       	call   80241e <alloc_block_FF>
  80180e:	83 c4 10             	add    $0x10,%esp
  801811:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801814:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801818:	75 07                	jne    801821 <sget+0x88>
		{
			return NULL;
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
  80181f:	eb 3b                	jmp    80185c <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801824:	8b 40 08             	mov    0x8(%eax),%eax
  801827:	83 ec 04             	sub    $0x4,%esp
  80182a:	50                   	push   %eax
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	ff 75 08             	pushl  0x8(%ebp)
  801831:	e8 c7 03 00 00       	call   801bfd <sys_getSharedObject>
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  80183c:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  801840:	74 06                	je     801848 <sget+0xaf>
  801842:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801846:	75 07                	jne    80184f <sget+0xb6>
		{
			return NULL;
  801848:	b8 00 00 00 00       	mov    $0x0,%eax
  80184d:	eb 0d                	jmp    80185c <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80184f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801852:	8b 40 08             	mov    0x8(%eax),%eax
  801855:	eb 05                	jmp    80185c <sget+0xc3>
		}
	}
	else
			return NULL;
  801857:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801864:	e8 65 fb ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801869:	83 ec 04             	sub    $0x4,%esp
  80186c:	68 e0 3a 80 00       	push   $0x803ae0
  801871:	68 e1 00 00 00       	push   $0xe1
  801876:	68 d3 3a 80 00       	push   $0x803ad3
  80187b:	e8 10 eb ff ff       	call   800390 <_panic>

00801880 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801886:	83 ec 04             	sub    $0x4,%esp
  801889:	68 08 3b 80 00       	push   $0x803b08
  80188e:	68 f5 00 00 00       	push   $0xf5
  801893:	68 d3 3a 80 00       	push   $0x803ad3
  801898:	e8 f3 ea ff ff       	call   800390 <_panic>

0080189d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80189d:	55                   	push   %ebp
  80189e:	89 e5                	mov    %esp,%ebp
  8018a0:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a3:	83 ec 04             	sub    $0x4,%esp
  8018a6:	68 2c 3b 80 00       	push   $0x803b2c
  8018ab:	68 00 01 00 00       	push   $0x100
  8018b0:	68 d3 3a 80 00       	push   $0x803ad3
  8018b5:	e8 d6 ea ff ff       	call   800390 <_panic>

008018ba <shrink>:

}
void shrink(uint32 newSize)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	68 2c 3b 80 00       	push   $0x803b2c
  8018c8:	68 05 01 00 00       	push   $0x105
  8018cd:	68 d3 3a 80 00       	push   $0x803ad3
  8018d2:	e8 b9 ea ff ff       	call   800390 <_panic>

008018d7 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	68 2c 3b 80 00       	push   $0x803b2c
  8018e5:	68 0a 01 00 00       	push   $0x10a
  8018ea:	68 d3 3a 80 00       	push   $0x803ad3
  8018ef:	e8 9c ea ff ff       	call   800390 <_panic>

008018f4 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	57                   	push   %edi
  8018f8:	56                   	push   %esi
  8018f9:	53                   	push   %ebx
  8018fa:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	8b 55 0c             	mov    0xc(%ebp),%edx
  801903:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801906:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801909:	8b 7d 18             	mov    0x18(%ebp),%edi
  80190c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80190f:	cd 30                	int    $0x30
  801911:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801914:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801917:	83 c4 10             	add    $0x10,%esp
  80191a:	5b                   	pop    %ebx
  80191b:	5e                   	pop    %esi
  80191c:	5f                   	pop    %edi
  80191d:	5d                   	pop    %ebp
  80191e:	c3                   	ret    

0080191f <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	83 ec 04             	sub    $0x4,%esp
  801925:	8b 45 10             	mov    0x10(%ebp),%eax
  801928:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80192b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80192f:	8b 45 08             	mov    0x8(%ebp),%eax
  801932:	6a 00                	push   $0x0
  801934:	6a 00                	push   $0x0
  801936:	52                   	push   %edx
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	50                   	push   %eax
  80193b:	6a 00                	push   $0x0
  80193d:	e8 b2 ff ff ff       	call   8018f4 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	90                   	nop
  801946:	c9                   	leave  
  801947:	c3                   	ret    

00801948 <sys_cgetc>:

int
sys_cgetc(void)
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 01                	push   $0x1
  801957:	e8 98 ff ff ff       	call   8018f4 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801964:	8b 55 0c             	mov    0xc(%ebp),%edx
  801967:	8b 45 08             	mov    0x8(%ebp),%eax
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	52                   	push   %edx
  801971:	50                   	push   %eax
  801972:	6a 05                	push   $0x5
  801974:	e8 7b ff ff ff       	call   8018f4 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	56                   	push   %esi
  801982:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801983:	8b 75 18             	mov    0x18(%ebp),%esi
  801986:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801989:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80198c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	56                   	push   %esi
  801993:	53                   	push   %ebx
  801994:	51                   	push   %ecx
  801995:	52                   	push   %edx
  801996:	50                   	push   %eax
  801997:	6a 06                	push   $0x6
  801999:	e8 56 ff ff ff       	call   8018f4 <syscall>
  80199e:	83 c4 18             	add    $0x18,%esp
}
  8019a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a4:	5b                   	pop    %ebx
  8019a5:	5e                   	pop    %esi
  8019a6:	5d                   	pop    %ebp
  8019a7:	c3                   	ret    

008019a8 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019a8:	55                   	push   %ebp
  8019a9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	52                   	push   %edx
  8019b8:	50                   	push   %eax
  8019b9:	6a 07                	push   $0x7
  8019bb:	e8 34 ff ff ff       	call   8018f4 <syscall>
  8019c0:	83 c4 18             	add    $0x18,%esp
}
  8019c3:	c9                   	leave  
  8019c4:	c3                   	ret    

008019c5 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019c5:	55                   	push   %ebp
  8019c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	ff 75 0c             	pushl  0xc(%ebp)
  8019d1:	ff 75 08             	pushl  0x8(%ebp)
  8019d4:	6a 08                	push   $0x8
  8019d6:	e8 19 ff ff ff       	call   8018f4 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 09                	push   $0x9
  8019ef:	e8 00 ff ff ff       	call   8018f4 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 0a                	push   $0xa
  801a08:	e8 e7 fe ff ff       	call   8018f4 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 0b                	push   $0xb
  801a21:	e8 ce fe ff ff       	call   8018f4 <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 0f                	push   $0xf
  801a3c:	e8 b3 fe ff ff       	call   8018f4 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	return;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	ff 75 08             	pushl  0x8(%ebp)
  801a56:	6a 10                	push   $0x10
  801a58:	e8 97 fe ff ff       	call   8018f4 <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a60:	90                   	nop
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	ff 75 10             	pushl  0x10(%ebp)
  801a6d:	ff 75 0c             	pushl  0xc(%ebp)
  801a70:	ff 75 08             	pushl  0x8(%ebp)
  801a73:	6a 11                	push   $0x11
  801a75:	e8 7a fe ff ff       	call   8018f4 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7d:	90                   	nop
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 0c                	push   $0xc
  801a8f:	e8 60 fe ff ff       	call   8018f4 <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	ff 75 08             	pushl  0x8(%ebp)
  801aa7:	6a 0d                	push   $0xd
  801aa9:	e8 46 fe ff ff       	call   8018f4 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 0e                	push   $0xe
  801ac2:	e8 2d fe ff ff       	call   8018f4 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	90                   	nop
  801acb:	c9                   	leave  
  801acc:	c3                   	ret    

00801acd <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801acd:	55                   	push   %ebp
  801ace:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 13                	push   $0x13
  801adc:	e8 13 fe ff ff       	call   8018f4 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	90                   	nop
  801ae5:	c9                   	leave  
  801ae6:	c3                   	ret    

00801ae7 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 14                	push   $0x14
  801af6:	e8 f9 fd ff ff       	call   8018f4 <syscall>
  801afb:	83 c4 18             	add    $0x18,%esp
}
  801afe:	90                   	nop
  801aff:	c9                   	leave  
  801b00:	c3                   	ret    

00801b01 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 04             	sub    $0x4,%esp
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b0d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b11:	6a 00                	push   $0x0
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	50                   	push   %eax
  801b1a:	6a 15                	push   $0x15
  801b1c:	e8 d3 fd ff ff       	call   8018f4 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	90                   	nop
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 16                	push   $0x16
  801b36:	e8 b9 fd ff ff       	call   8018f4 <syscall>
  801b3b:	83 c4 18             	add    $0x18,%esp
}
  801b3e:	90                   	nop
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b44:	8b 45 08             	mov    0x8(%ebp),%eax
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	ff 75 0c             	pushl  0xc(%ebp)
  801b50:	50                   	push   %eax
  801b51:	6a 17                	push   $0x17
  801b53:	e8 9c fd ff ff       	call   8018f4 <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	52                   	push   %edx
  801b6d:	50                   	push   %eax
  801b6e:	6a 1a                	push   $0x1a
  801b70:	e8 7f fd ff ff       	call   8018f4 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	52                   	push   %edx
  801b8a:	50                   	push   %eax
  801b8b:	6a 18                	push   $0x18
  801b8d:	e8 62 fd ff ff       	call   8018f4 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	90                   	nop
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba1:	6a 00                	push   $0x0
  801ba3:	6a 00                	push   $0x0
  801ba5:	6a 00                	push   $0x0
  801ba7:	52                   	push   %edx
  801ba8:	50                   	push   %eax
  801ba9:	6a 19                	push   $0x19
  801bab:	e8 44 fd ff ff       	call   8018f4 <syscall>
  801bb0:	83 c4 18             	add    $0x18,%esp
}
  801bb3:	90                   	nop
  801bb4:	c9                   	leave  
  801bb5:	c3                   	ret    

00801bb6 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	83 ec 04             	sub    $0x4,%esp
  801bbc:	8b 45 10             	mov    0x10(%ebp),%eax
  801bbf:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bc2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bc5:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcc:	6a 00                	push   $0x0
  801bce:	51                   	push   %ecx
  801bcf:	52                   	push   %edx
  801bd0:	ff 75 0c             	pushl  0xc(%ebp)
  801bd3:	50                   	push   %eax
  801bd4:	6a 1b                	push   $0x1b
  801bd6:	e8 19 fd ff ff       	call   8018f4 <syscall>
  801bdb:	83 c4 18             	add    $0x18,%esp
}
  801bde:	c9                   	leave  
  801bdf:	c3                   	ret    

00801be0 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801be3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	52                   	push   %edx
  801bf0:	50                   	push   %eax
  801bf1:	6a 1c                	push   $0x1c
  801bf3:	e8 fc fc ff ff       	call   8018f4 <syscall>
  801bf8:	83 c4 18             	add    $0x18,%esp
}
  801bfb:	c9                   	leave  
  801bfc:	c3                   	ret    

00801bfd <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bfd:	55                   	push   %ebp
  801bfe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c00:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	51                   	push   %ecx
  801c0e:	52                   	push   %edx
  801c0f:	50                   	push   %eax
  801c10:	6a 1d                	push   $0x1d
  801c12:	e8 dd fc ff ff       	call   8018f4 <syscall>
  801c17:	83 c4 18             	add    $0x18,%esp
}
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	52                   	push   %edx
  801c2c:	50                   	push   %eax
  801c2d:	6a 1e                	push   $0x1e
  801c2f:	e8 c0 fc ff ff       	call   8018f4 <syscall>
  801c34:	83 c4 18             	add    $0x18,%esp
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 1f                	push   $0x1f
  801c48:	e8 a7 fc ff ff       	call   8018f4 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	ff 75 14             	pushl  0x14(%ebp)
  801c5d:	ff 75 10             	pushl  0x10(%ebp)
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	50                   	push   %eax
  801c64:	6a 20                	push   $0x20
  801c66:	e8 89 fc ff ff       	call   8018f4 <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	50                   	push   %eax
  801c7f:	6a 21                	push   $0x21
  801c81:	e8 6e fc ff ff       	call   8018f4 <syscall>
  801c86:	83 c4 18             	add    $0x18,%esp
}
  801c89:	90                   	nop
  801c8a:	c9                   	leave  
  801c8b:	c3                   	ret    

00801c8c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c8c:	55                   	push   %ebp
  801c8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	50                   	push   %eax
  801c9b:	6a 22                	push   $0x22
  801c9d:	e8 52 fc ff ff       	call   8018f4 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 02                	push   $0x2
  801cb6:	e8 39 fc ff ff       	call   8018f4 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 03                	push   $0x3
  801ccf:	e8 20 fc ff ff       	call   8018f4 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	c9                   	leave  
  801cd8:	c3                   	ret    

00801cd9 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 00                	push   $0x0
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 04                	push   $0x4
  801ce8:	e8 07 fc ff ff       	call   8018f4 <syscall>
  801ced:	83 c4 18             	add    $0x18,%esp
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_exit_env>:


void sys_exit_env(void)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 23                	push   $0x23
  801d01:	e8 ee fb ff ff       	call   8018f4 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	90                   	nop
  801d0a:	c9                   	leave  
  801d0b:	c3                   	ret    

00801d0c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d15:	8d 50 04             	lea    0x4(%eax),%edx
  801d18:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	52                   	push   %edx
  801d22:	50                   	push   %eax
  801d23:	6a 24                	push   $0x24
  801d25:	e8 ca fb ff ff       	call   8018f4 <syscall>
  801d2a:	83 c4 18             	add    $0x18,%esp
	return result;
  801d2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d33:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d36:	89 01                	mov    %eax,(%ecx)
  801d38:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	c9                   	leave  
  801d3f:	c2 04 00             	ret    $0x4

00801d42 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	ff 75 10             	pushl  0x10(%ebp)
  801d4c:	ff 75 0c             	pushl  0xc(%ebp)
  801d4f:	ff 75 08             	pushl  0x8(%ebp)
  801d52:	6a 12                	push   $0x12
  801d54:	e8 9b fb ff ff       	call   8018f4 <syscall>
  801d59:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5c:	90                   	nop
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <sys_rcr2>:
uint32 sys_rcr2()
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 25                	push   $0x25
  801d6e:	e8 81 fb ff ff       	call   8018f4 <syscall>
  801d73:	83 c4 18             	add    $0x18,%esp
}
  801d76:	c9                   	leave  
  801d77:	c3                   	ret    

00801d78 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d78:	55                   	push   %ebp
  801d79:	89 e5                	mov    %esp,%ebp
  801d7b:	83 ec 04             	sub    $0x4,%esp
  801d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d81:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d84:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	50                   	push   %eax
  801d91:	6a 26                	push   $0x26
  801d93:	e8 5c fb ff ff       	call   8018f4 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9b:	90                   	nop
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <rsttst>:
void rsttst()
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 28                	push   $0x28
  801dad:	e8 42 fb ff ff       	call   8018f4 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
	return ;
  801db5:	90                   	nop
}
  801db6:	c9                   	leave  
  801db7:	c3                   	ret    

00801db8 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801db8:	55                   	push   %ebp
  801db9:	89 e5                	mov    %esp,%ebp
  801dbb:	83 ec 04             	sub    $0x4,%esp
  801dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  801dc1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dc4:	8b 55 18             	mov    0x18(%ebp),%edx
  801dc7:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dcb:	52                   	push   %edx
  801dcc:	50                   	push   %eax
  801dcd:	ff 75 10             	pushl  0x10(%ebp)
  801dd0:	ff 75 0c             	pushl  0xc(%ebp)
  801dd3:	ff 75 08             	pushl  0x8(%ebp)
  801dd6:	6a 27                	push   $0x27
  801dd8:	e8 17 fb ff ff       	call   8018f4 <syscall>
  801ddd:	83 c4 18             	add    $0x18,%esp
	return ;
  801de0:	90                   	nop
}
  801de1:	c9                   	leave  
  801de2:	c3                   	ret    

00801de3 <chktst>:
void chktst(uint32 n)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	ff 75 08             	pushl  0x8(%ebp)
  801df1:	6a 29                	push   $0x29
  801df3:	e8 fc fa ff ff       	call   8018f4 <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfb:	90                   	nop
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <inctst>:

void inctst()
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 2a                	push   $0x2a
  801e0d:	e8 e2 fa ff ff       	call   8018f4 <syscall>
  801e12:	83 c4 18             	add    $0x18,%esp
	return ;
  801e15:	90                   	nop
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <gettst>:
uint32 gettst()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 2b                	push   $0x2b
  801e27:	e8 c8 fa ff ff       	call   8018f4 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
}
  801e2f:	c9                   	leave  
  801e30:	c3                   	ret    

00801e31 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e31:	55                   	push   %ebp
  801e32:	89 e5                	mov    %esp,%ebp
  801e34:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 00                	push   $0x0
  801e3d:	6a 00                	push   $0x0
  801e3f:	6a 00                	push   $0x0
  801e41:	6a 2c                	push   $0x2c
  801e43:	e8 ac fa ff ff       	call   8018f4 <syscall>
  801e48:	83 c4 18             	add    $0x18,%esp
  801e4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e4e:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e52:	75 07                	jne    801e5b <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e54:	b8 01 00 00 00       	mov    $0x1,%eax
  801e59:	eb 05                	jmp    801e60 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e60:	c9                   	leave  
  801e61:	c3                   	ret    

00801e62 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e62:	55                   	push   %ebp
  801e63:	89 e5                	mov    %esp,%ebp
  801e65:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 00                	push   $0x0
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 2c                	push   $0x2c
  801e74:	e8 7b fa ff ff       	call   8018f4 <syscall>
  801e79:	83 c4 18             	add    $0x18,%esp
  801e7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e7f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e83:	75 07                	jne    801e8c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e85:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8a:	eb 05                	jmp    801e91 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 2c                	push   $0x2c
  801ea5:	e8 4a fa ff ff       	call   8018f4 <syscall>
  801eaa:	83 c4 18             	add    $0x18,%esp
  801ead:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eb0:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eb4:	75 07                	jne    801ebd <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eb6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ebb:	eb 05                	jmp    801ec2 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ebd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec2:	c9                   	leave  
  801ec3:	c3                   	ret    

00801ec4 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 2c                	push   $0x2c
  801ed6:	e8 19 fa ff ff       	call   8018f4 <syscall>
  801edb:	83 c4 18             	add    $0x18,%esp
  801ede:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ee1:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ee5:	75 07                	jne    801eee <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ee7:	b8 01 00 00 00       	mov    $0x1,%eax
  801eec:	eb 05                	jmp    801ef3 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef3:	c9                   	leave  
  801ef4:	c3                   	ret    

00801ef5 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ef5:	55                   	push   %ebp
  801ef6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	6a 00                	push   $0x0
  801efe:	6a 00                	push   $0x0
  801f00:	ff 75 08             	pushl  0x8(%ebp)
  801f03:	6a 2d                	push   $0x2d
  801f05:	e8 ea f9 ff ff       	call   8018f4 <syscall>
  801f0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0d:	90                   	nop
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f14:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f17:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	6a 00                	push   $0x0
  801f22:	53                   	push   %ebx
  801f23:	51                   	push   %ecx
  801f24:	52                   	push   %edx
  801f25:	50                   	push   %eax
  801f26:	6a 2e                	push   $0x2e
  801f28:	e8 c7 f9 ff ff       	call   8018f4 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f33:	c9                   	leave  
  801f34:	c3                   	ret    

00801f35 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f35:	55                   	push   %ebp
  801f36:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	52                   	push   %edx
  801f45:	50                   	push   %eax
  801f46:	6a 2f                	push   $0x2f
  801f48:	e8 a7 f9 ff ff       	call   8018f4 <syscall>
  801f4d:	83 c4 18             	add    $0x18,%esp
}
  801f50:	c9                   	leave  
  801f51:	c3                   	ret    

00801f52 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f52:	55                   	push   %ebp
  801f53:	89 e5                	mov    %esp,%ebp
  801f55:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f58:	83 ec 0c             	sub    $0xc,%esp
  801f5b:	68 3c 3b 80 00       	push   $0x803b3c
  801f60:	e8 df e6 ff ff       	call   800644 <cprintf>
  801f65:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f6f:	83 ec 0c             	sub    $0xc,%esp
  801f72:	68 68 3b 80 00       	push   $0x803b68
  801f77:	e8 c8 e6 ff ff       	call   800644 <cprintf>
  801f7c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f7f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f83:	a1 38 41 80 00       	mov    0x804138,%eax
  801f88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f8b:	eb 56                	jmp    801fe3 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f8d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f91:	74 1c                	je     801faf <print_mem_block_lists+0x5d>
  801f93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f96:	8b 50 08             	mov    0x8(%eax),%edx
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fa5:	01 c8                	add    %ecx,%eax
  801fa7:	39 c2                	cmp    %eax,%edx
  801fa9:	73 04                	jae    801faf <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fab:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 50 08             	mov    0x8(%eax),%edx
  801fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fbb:	01 c2                	add    %eax,%edx
  801fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc0:	8b 40 08             	mov    0x8(%eax),%eax
  801fc3:	83 ec 04             	sub    $0x4,%esp
  801fc6:	52                   	push   %edx
  801fc7:	50                   	push   %eax
  801fc8:	68 7d 3b 80 00       	push   $0x803b7d
  801fcd:	e8 72 e6 ff ff       	call   800644 <cprintf>
  801fd2:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fdb:	a1 40 41 80 00       	mov    0x804140,%eax
  801fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe7:	74 07                	je     801ff0 <print_mem_block_lists+0x9e>
  801fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fec:	8b 00                	mov    (%eax),%eax
  801fee:	eb 05                	jmp    801ff5 <print_mem_block_lists+0xa3>
  801ff0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff5:	a3 40 41 80 00       	mov    %eax,0x804140
  801ffa:	a1 40 41 80 00       	mov    0x804140,%eax
  801fff:	85 c0                	test   %eax,%eax
  802001:	75 8a                	jne    801f8d <print_mem_block_lists+0x3b>
  802003:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802007:	75 84                	jne    801f8d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802009:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80200d:	75 10                	jne    80201f <print_mem_block_lists+0xcd>
  80200f:	83 ec 0c             	sub    $0xc,%esp
  802012:	68 8c 3b 80 00       	push   $0x803b8c
  802017:	e8 28 e6 ff ff       	call   800644 <cprintf>
  80201c:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80201f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802026:	83 ec 0c             	sub    $0xc,%esp
  802029:	68 b0 3b 80 00       	push   $0x803bb0
  80202e:	e8 11 e6 ff ff       	call   800644 <cprintf>
  802033:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802036:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80203a:	a1 40 40 80 00       	mov    0x804040,%eax
  80203f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802042:	eb 56                	jmp    80209a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802044:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802048:	74 1c                	je     802066 <print_mem_block_lists+0x114>
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	8b 50 08             	mov    0x8(%eax),%edx
  802050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802053:	8b 48 08             	mov    0x8(%eax),%ecx
  802056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802059:	8b 40 0c             	mov    0xc(%eax),%eax
  80205c:	01 c8                	add    %ecx,%eax
  80205e:	39 c2                	cmp    %eax,%edx
  802060:	73 04                	jae    802066 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802062:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 50 08             	mov    0x8(%eax),%edx
  80206c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206f:	8b 40 0c             	mov    0xc(%eax),%eax
  802072:	01 c2                	add    %eax,%edx
  802074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802077:	8b 40 08             	mov    0x8(%eax),%eax
  80207a:	83 ec 04             	sub    $0x4,%esp
  80207d:	52                   	push   %edx
  80207e:	50                   	push   %eax
  80207f:	68 7d 3b 80 00       	push   $0x803b7d
  802084:	e8 bb e5 ff ff       	call   800644 <cprintf>
  802089:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802092:	a1 48 40 80 00       	mov    0x804048,%eax
  802097:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80209a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209e:	74 07                	je     8020a7 <print_mem_block_lists+0x155>
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	8b 00                	mov    (%eax),%eax
  8020a5:	eb 05                	jmp    8020ac <print_mem_block_lists+0x15a>
  8020a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ac:	a3 48 40 80 00       	mov    %eax,0x804048
  8020b1:	a1 48 40 80 00       	mov    0x804048,%eax
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	75 8a                	jne    802044 <print_mem_block_lists+0xf2>
  8020ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020be:	75 84                	jne    802044 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020c0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020c4:	75 10                	jne    8020d6 <print_mem_block_lists+0x184>
  8020c6:	83 ec 0c             	sub    $0xc,%esp
  8020c9:	68 c8 3b 80 00       	push   $0x803bc8
  8020ce:	e8 71 e5 ff ff       	call   800644 <cprintf>
  8020d3:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020d6:	83 ec 0c             	sub    $0xc,%esp
  8020d9:	68 3c 3b 80 00       	push   $0x803b3c
  8020de:	e8 61 e5 ff ff       	call   800644 <cprintf>
  8020e3:	83 c4 10             	add    $0x10,%esp

}
  8020e6:	90                   	nop
  8020e7:	c9                   	leave  
  8020e8:	c3                   	ret    

008020e9 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020e9:	55                   	push   %ebp
  8020ea:	89 e5                	mov    %esp,%ebp
  8020ec:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020ef:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020f6:	00 00 00 
  8020f9:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802100:	00 00 00 
  802103:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80210a:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80210d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802114:	e9 9e 00 00 00       	jmp    8021b7 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802119:	a1 50 40 80 00       	mov    0x804050,%eax
  80211e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802121:	c1 e2 04             	shl    $0x4,%edx
  802124:	01 d0                	add    %edx,%eax
  802126:	85 c0                	test   %eax,%eax
  802128:	75 14                	jne    80213e <initialize_MemBlocksList+0x55>
  80212a:	83 ec 04             	sub    $0x4,%esp
  80212d:	68 f0 3b 80 00       	push   $0x803bf0
  802132:	6a 42                	push   $0x42
  802134:	68 13 3c 80 00       	push   $0x803c13
  802139:	e8 52 e2 ff ff       	call   800390 <_panic>
  80213e:	a1 50 40 80 00       	mov    0x804050,%eax
  802143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802146:	c1 e2 04             	shl    $0x4,%edx
  802149:	01 d0                	add    %edx,%eax
  80214b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802151:	89 10                	mov    %edx,(%eax)
  802153:	8b 00                	mov    (%eax),%eax
  802155:	85 c0                	test   %eax,%eax
  802157:	74 18                	je     802171 <initialize_MemBlocksList+0x88>
  802159:	a1 48 41 80 00       	mov    0x804148,%eax
  80215e:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802164:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802167:	c1 e1 04             	shl    $0x4,%ecx
  80216a:	01 ca                	add    %ecx,%edx
  80216c:	89 50 04             	mov    %edx,0x4(%eax)
  80216f:	eb 12                	jmp    802183 <initialize_MemBlocksList+0x9a>
  802171:	a1 50 40 80 00       	mov    0x804050,%eax
  802176:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802179:	c1 e2 04             	shl    $0x4,%edx
  80217c:	01 d0                	add    %edx,%eax
  80217e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802183:	a1 50 40 80 00       	mov    0x804050,%eax
  802188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218b:	c1 e2 04             	shl    $0x4,%edx
  80218e:	01 d0                	add    %edx,%eax
  802190:	a3 48 41 80 00       	mov    %eax,0x804148
  802195:	a1 50 40 80 00       	mov    0x804050,%eax
  80219a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219d:	c1 e2 04             	shl    $0x4,%edx
  8021a0:	01 d0                	add    %edx,%eax
  8021a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a9:	a1 54 41 80 00       	mov    0x804154,%eax
  8021ae:	40                   	inc    %eax
  8021af:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8021b4:	ff 45 f4             	incl   -0xc(%ebp)
  8021b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ba:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021bd:	0f 82 56 ff ff ff    	jb     802119 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8021c3:	90                   	nop
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	8b 00                	mov    (%eax),%eax
  8021d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021d4:	eb 19                	jmp    8021ef <find_block+0x29>
	{
		if(blk->sva==va)
  8021d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d9:	8b 40 08             	mov    0x8(%eax),%eax
  8021dc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021df:	75 05                	jne    8021e6 <find_block+0x20>
			return (blk);
  8021e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e4:	eb 36                	jmp    80221c <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	8b 40 08             	mov    0x8(%eax),%eax
  8021ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021ef:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f3:	74 07                	je     8021fc <find_block+0x36>
  8021f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f8:	8b 00                	mov    (%eax),%eax
  8021fa:	eb 05                	jmp    802201 <find_block+0x3b>
  8021fc:	b8 00 00 00 00       	mov    $0x0,%eax
  802201:	8b 55 08             	mov    0x8(%ebp),%edx
  802204:	89 42 08             	mov    %eax,0x8(%edx)
  802207:	8b 45 08             	mov    0x8(%ebp),%eax
  80220a:	8b 40 08             	mov    0x8(%eax),%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	75 c5                	jne    8021d6 <find_block+0x10>
  802211:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802215:	75 bf                	jne    8021d6 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802217:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802224:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802229:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80222c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802233:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802236:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802239:	75 65                	jne    8022a0 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  80223b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223f:	75 14                	jne    802255 <insert_sorted_allocList+0x37>
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	68 f0 3b 80 00       	push   $0x803bf0
  802249:	6a 5c                	push   $0x5c
  80224b:	68 13 3c 80 00       	push   $0x803c13
  802250:	e8 3b e1 ff ff       	call   800390 <_panic>
  802255:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	89 10                	mov    %edx,(%eax)
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	8b 00                	mov    (%eax),%eax
  802265:	85 c0                	test   %eax,%eax
  802267:	74 0d                	je     802276 <insert_sorted_allocList+0x58>
  802269:	a1 40 40 80 00       	mov    0x804040,%eax
  80226e:	8b 55 08             	mov    0x8(%ebp),%edx
  802271:	89 50 04             	mov    %edx,0x4(%eax)
  802274:	eb 08                	jmp    80227e <insert_sorted_allocList+0x60>
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	a3 44 40 80 00       	mov    %eax,0x804044
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	a3 40 40 80 00       	mov    %eax,0x804040
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802290:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802295:	40                   	inc    %eax
  802296:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80229b:	e9 7b 01 00 00       	jmp    80241b <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8022a0:	a1 44 40 80 00       	mov    0x804044,%eax
  8022a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8022a8:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	8b 50 08             	mov    0x8(%eax),%edx
  8022b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022b9:	8b 40 08             	mov    0x8(%eax),%eax
  8022bc:	39 c2                	cmp    %eax,%edx
  8022be:	76 65                	jbe    802325 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8022c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c4:	75 14                	jne    8022da <insert_sorted_allocList+0xbc>
  8022c6:	83 ec 04             	sub    $0x4,%esp
  8022c9:	68 2c 3c 80 00       	push   $0x803c2c
  8022ce:	6a 64                	push   $0x64
  8022d0:	68 13 3c 80 00       	push   $0x803c13
  8022d5:	e8 b6 e0 ff ff       	call   800390 <_panic>
  8022da:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	89 50 04             	mov    %edx,0x4(%eax)
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	8b 40 04             	mov    0x4(%eax),%eax
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	74 0c                	je     8022fc <insert_sorted_allocList+0xde>
  8022f0:	a1 44 40 80 00       	mov    0x804044,%eax
  8022f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f8:	89 10                	mov    %edx,(%eax)
  8022fa:	eb 08                	jmp    802304 <insert_sorted_allocList+0xe6>
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	a3 40 40 80 00       	mov    %eax,0x804040
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	a3 44 40 80 00       	mov    %eax,0x804044
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802315:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231a:	40                   	inc    %eax
  80231b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802320:	e9 f6 00 00 00       	jmp    80241b <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802325:	8b 45 08             	mov    0x8(%ebp),%eax
  802328:	8b 50 08             	mov    0x8(%eax),%edx
  80232b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80232e:	8b 40 08             	mov    0x8(%eax),%eax
  802331:	39 c2                	cmp    %eax,%edx
  802333:	73 65                	jae    80239a <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802335:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802339:	75 14                	jne    80234f <insert_sorted_allocList+0x131>
  80233b:	83 ec 04             	sub    $0x4,%esp
  80233e:	68 f0 3b 80 00       	push   $0x803bf0
  802343:	6a 68                	push   $0x68
  802345:	68 13 3c 80 00       	push   $0x803c13
  80234a:	e8 41 e0 ff ff       	call   800390 <_panic>
  80234f:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802355:	8b 45 08             	mov    0x8(%ebp),%eax
  802358:	89 10                	mov    %edx,(%eax)
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	8b 00                	mov    (%eax),%eax
  80235f:	85 c0                	test   %eax,%eax
  802361:	74 0d                	je     802370 <insert_sorted_allocList+0x152>
  802363:	a1 40 40 80 00       	mov    0x804040,%eax
  802368:	8b 55 08             	mov    0x8(%ebp),%edx
  80236b:	89 50 04             	mov    %edx,0x4(%eax)
  80236e:	eb 08                	jmp    802378 <insert_sorted_allocList+0x15a>
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	a3 44 40 80 00       	mov    %eax,0x804044
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	a3 40 40 80 00       	mov    %eax,0x804040
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80238a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80238f:	40                   	inc    %eax
  802390:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802395:	e9 81 00 00 00       	jmp    80241b <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80239a:	a1 40 40 80 00       	mov    0x804040,%eax
  80239f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023a2:	eb 51                	jmp    8023f5 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8023a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a7:	8b 50 08             	mov    0x8(%eax),%edx
  8023aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ad:	8b 40 08             	mov    0x8(%eax),%eax
  8023b0:	39 c2                	cmp    %eax,%edx
  8023b2:	73 39                	jae    8023ed <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8023b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8023bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c3:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8023c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023cb:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8023ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023d4:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8023d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023dc:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8023df:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023e4:	40                   	inc    %eax
  8023e5:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8023ea:	90                   	nop
				}
			}
		 }

	}
}
  8023eb:	eb 2e                	jmp    80241b <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8023ed:	a1 48 40 80 00       	mov    0x804048,%eax
  8023f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f9:	74 07                	je     802402 <insert_sorted_allocList+0x1e4>
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 00                	mov    (%eax),%eax
  802400:	eb 05                	jmp    802407 <insert_sorted_allocList+0x1e9>
  802402:	b8 00 00 00 00       	mov    $0x0,%eax
  802407:	a3 48 40 80 00       	mov    %eax,0x804048
  80240c:	a1 48 40 80 00       	mov    0x804048,%eax
  802411:	85 c0                	test   %eax,%eax
  802413:	75 8f                	jne    8023a4 <insert_sorted_allocList+0x186>
  802415:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802419:	75 89                	jne    8023a4 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  80241b:	90                   	nop
  80241c:	c9                   	leave  
  80241d:	c3                   	ret    

0080241e <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80241e:	55                   	push   %ebp
  80241f:	89 e5                	mov    %esp,%ebp
  802421:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802424:	a1 38 41 80 00       	mov    0x804138,%eax
  802429:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80242c:	e9 76 01 00 00       	jmp    8025a7 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  802431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802434:	8b 40 0c             	mov    0xc(%eax),%eax
  802437:	3b 45 08             	cmp    0x8(%ebp),%eax
  80243a:	0f 85 8a 00 00 00    	jne    8024ca <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  802440:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802444:	75 17                	jne    80245d <alloc_block_FF+0x3f>
  802446:	83 ec 04             	sub    $0x4,%esp
  802449:	68 4f 3c 80 00       	push   $0x803c4f
  80244e:	68 8a 00 00 00       	push   $0x8a
  802453:	68 13 3c 80 00       	push   $0x803c13
  802458:	e8 33 df ff ff       	call   800390 <_panic>
  80245d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802460:	8b 00                	mov    (%eax),%eax
  802462:	85 c0                	test   %eax,%eax
  802464:	74 10                	je     802476 <alloc_block_FF+0x58>
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 00                	mov    (%eax),%eax
  80246b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246e:	8b 52 04             	mov    0x4(%edx),%edx
  802471:	89 50 04             	mov    %edx,0x4(%eax)
  802474:	eb 0b                	jmp    802481 <alloc_block_FF+0x63>
  802476:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802479:	8b 40 04             	mov    0x4(%eax),%eax
  80247c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	8b 40 04             	mov    0x4(%eax),%eax
  802487:	85 c0                	test   %eax,%eax
  802489:	74 0f                	je     80249a <alloc_block_FF+0x7c>
  80248b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248e:	8b 40 04             	mov    0x4(%eax),%eax
  802491:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802494:	8b 12                	mov    (%edx),%edx
  802496:	89 10                	mov    %edx,(%eax)
  802498:	eb 0a                	jmp    8024a4 <alloc_block_FF+0x86>
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 00                	mov    (%eax),%eax
  80249f:	a3 38 41 80 00       	mov    %eax,0x804138
  8024a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b7:	a1 44 41 80 00       	mov    0x804144,%eax
  8024bc:	48                   	dec    %eax
  8024bd:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	e9 10 01 00 00       	jmp    8025da <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8024d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d3:	0f 86 c6 00 00 00    	jbe    80259f <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8024d9:	a1 48 41 80 00       	mov    0x804148,%eax
  8024de:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8024e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024e5:	75 17                	jne    8024fe <alloc_block_FF+0xe0>
  8024e7:	83 ec 04             	sub    $0x4,%esp
  8024ea:	68 4f 3c 80 00       	push   $0x803c4f
  8024ef:	68 90 00 00 00       	push   $0x90
  8024f4:	68 13 3c 80 00       	push   $0x803c13
  8024f9:	e8 92 de ff ff       	call   800390 <_panic>
  8024fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802501:	8b 00                	mov    (%eax),%eax
  802503:	85 c0                	test   %eax,%eax
  802505:	74 10                	je     802517 <alloc_block_FF+0xf9>
  802507:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250a:	8b 00                	mov    (%eax),%eax
  80250c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80250f:	8b 52 04             	mov    0x4(%edx),%edx
  802512:	89 50 04             	mov    %edx,0x4(%eax)
  802515:	eb 0b                	jmp    802522 <alloc_block_FF+0x104>
  802517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80251a:	8b 40 04             	mov    0x4(%eax),%eax
  80251d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802525:	8b 40 04             	mov    0x4(%eax),%eax
  802528:	85 c0                	test   %eax,%eax
  80252a:	74 0f                	je     80253b <alloc_block_FF+0x11d>
  80252c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252f:	8b 40 04             	mov    0x4(%eax),%eax
  802532:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802535:	8b 12                	mov    (%edx),%edx
  802537:	89 10                	mov    %edx,(%eax)
  802539:	eb 0a                	jmp    802545 <alloc_block_FF+0x127>
  80253b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253e:	8b 00                	mov    (%eax),%eax
  802540:	a3 48 41 80 00       	mov    %eax,0x804148
  802545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802548:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80254e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802551:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802558:	a1 54 41 80 00       	mov    0x804154,%eax
  80255d:	48                   	dec    %eax
  80255e:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802566:	8b 55 08             	mov    0x8(%ebp),%edx
  802569:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  80256c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256f:	8b 50 08             	mov    0x8(%eax),%edx
  802572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802575:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802578:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257b:	8b 50 08             	mov    0x8(%eax),%edx
  80257e:	8b 45 08             	mov    0x8(%ebp),%eax
  802581:	01 c2                	add    %eax,%edx
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802589:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258c:	8b 40 0c             	mov    0xc(%eax),%eax
  80258f:	2b 45 08             	sub    0x8(%ebp),%eax
  802592:	89 c2                	mov    %eax,%edx
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  80259a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80259d:	eb 3b                	jmp    8025da <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  80259f:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025ab:	74 07                	je     8025b4 <alloc_block_FF+0x196>
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	8b 00                	mov    (%eax),%eax
  8025b2:	eb 05                	jmp    8025b9 <alloc_block_FF+0x19b>
  8025b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b9:	a3 40 41 80 00       	mov    %eax,0x804140
  8025be:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c3:	85 c0                	test   %eax,%eax
  8025c5:	0f 85 66 fe ff ff    	jne    802431 <alloc_block_FF+0x13>
  8025cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cf:	0f 85 5c fe ff ff    	jne    802431 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8025d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025da:	c9                   	leave  
  8025db:	c3                   	ret    

008025dc <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025dc:	55                   	push   %ebp
  8025dd:	89 e5                	mov    %esp,%ebp
  8025df:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8025e2:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8025e9:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8025f0:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8025f7:	a1 38 41 80 00       	mov    0x804138,%eax
  8025fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ff:	e9 cf 00 00 00       	jmp    8026d3 <alloc_block_BF+0xf7>
		{
			c++;
  802604:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260a:	8b 40 0c             	mov    0xc(%eax),%eax
  80260d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802610:	0f 85 8a 00 00 00    	jne    8026a0 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802616:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80261a:	75 17                	jne    802633 <alloc_block_BF+0x57>
  80261c:	83 ec 04             	sub    $0x4,%esp
  80261f:	68 4f 3c 80 00       	push   $0x803c4f
  802624:	68 a8 00 00 00       	push   $0xa8
  802629:	68 13 3c 80 00       	push   $0x803c13
  80262e:	e8 5d dd ff ff       	call   800390 <_panic>
  802633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	85 c0                	test   %eax,%eax
  80263a:	74 10                	je     80264c <alloc_block_BF+0x70>
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 00                	mov    (%eax),%eax
  802641:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802644:	8b 52 04             	mov    0x4(%edx),%edx
  802647:	89 50 04             	mov    %edx,0x4(%eax)
  80264a:	eb 0b                	jmp    802657 <alloc_block_BF+0x7b>
  80264c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264f:	8b 40 04             	mov    0x4(%eax),%eax
  802652:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265a:	8b 40 04             	mov    0x4(%eax),%eax
  80265d:	85 c0                	test   %eax,%eax
  80265f:	74 0f                	je     802670 <alloc_block_BF+0x94>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 40 04             	mov    0x4(%eax),%eax
  802667:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80266a:	8b 12                	mov    (%edx),%edx
  80266c:	89 10                	mov    %edx,(%eax)
  80266e:	eb 0a                	jmp    80267a <alloc_block_BF+0x9e>
  802670:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802673:	8b 00                	mov    (%eax),%eax
  802675:	a3 38 41 80 00       	mov    %eax,0x804138
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80268d:	a1 44 41 80 00       	mov    0x804144,%eax
  802692:	48                   	dec    %eax
  802693:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  802698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269b:	e9 85 01 00 00       	jmp    802825 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8026a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026a9:	76 20                	jbe    8026cb <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8026b4:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8026b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026ba:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026bd:	73 0c                	jae    8026cb <alloc_block_BF+0xef>
				{
					ma=tempi;
  8026bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8026c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026cb:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026d7:	74 07                	je     8026e0 <alloc_block_BF+0x104>
  8026d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026dc:	8b 00                	mov    (%eax),%eax
  8026de:	eb 05                	jmp    8026e5 <alloc_block_BF+0x109>
  8026e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e5:	a3 40 41 80 00       	mov    %eax,0x804140
  8026ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8026ef:	85 c0                	test   %eax,%eax
  8026f1:	0f 85 0d ff ff ff    	jne    802604 <alloc_block_BF+0x28>
  8026f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fb:	0f 85 03 ff ff ff    	jne    802604 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802701:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802708:	a1 38 41 80 00       	mov    0x804138,%eax
  80270d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802710:	e9 dd 00 00 00       	jmp    8027f2 <alloc_block_BF+0x216>
		{
			if(x==sol)
  802715:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802718:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80271b:	0f 85 c6 00 00 00    	jne    8027e7 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802721:	a1 48 41 80 00       	mov    0x804148,%eax
  802726:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802729:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80272d:	75 17                	jne    802746 <alloc_block_BF+0x16a>
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 4f 3c 80 00       	push   $0x803c4f
  802737:	68 bb 00 00 00       	push   $0xbb
  80273c:	68 13 3c 80 00       	push   $0x803c13
  802741:	e8 4a dc ff ff       	call   800390 <_panic>
  802746:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 10                	je     80275f <alloc_block_BF+0x183>
  80274f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802757:	8b 52 04             	mov    0x4(%edx),%edx
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	eb 0b                	jmp    80276a <alloc_block_BF+0x18e>
  80275f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80276a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276d:	8b 40 04             	mov    0x4(%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 0f                	je     802783 <alloc_block_BF+0x1a7>
  802774:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802777:	8b 40 04             	mov    0x4(%eax),%eax
  80277a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80277d:	8b 12                	mov    (%edx),%edx
  80277f:	89 10                	mov    %edx,(%eax)
  802781:	eb 0a                	jmp    80278d <alloc_block_BF+0x1b1>
  802783:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	a3 48 41 80 00       	mov    %eax,0x804148
  80278d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802796:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802799:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8027a5:	48                   	dec    %eax
  8027a6:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8027ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b1:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8027b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b7:	8b 50 08             	mov    0x8(%eax),%edx
  8027ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bd:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8027c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c3:	8b 50 08             	mov    0x8(%eax),%edx
  8027c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c9:	01 c2                	add    %eax,%edx
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d7:	2b 45 08             	sub    0x8(%ebp),%eax
  8027da:	89 c2                	mov    %eax,%edx
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8027e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027e5:	eb 3e                	jmp    802825 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8027e7:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8027ea:	a1 40 41 80 00       	mov    0x804140,%eax
  8027ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027f6:	74 07                	je     8027ff <alloc_block_BF+0x223>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 00                	mov    (%eax),%eax
  8027fd:	eb 05                	jmp    802804 <alloc_block_BF+0x228>
  8027ff:	b8 00 00 00 00       	mov    $0x0,%eax
  802804:	a3 40 41 80 00       	mov    %eax,0x804140
  802809:	a1 40 41 80 00       	mov    0x804140,%eax
  80280e:	85 c0                	test   %eax,%eax
  802810:	0f 85 ff fe ff ff    	jne    802715 <alloc_block_BF+0x139>
  802816:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80281a:	0f 85 f5 fe ff ff    	jne    802715 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  802820:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802825:	c9                   	leave  
  802826:	c3                   	ret    

00802827 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802827:	55                   	push   %ebp
  802828:	89 e5                	mov    %esp,%ebp
  80282a:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80282d:	a1 28 40 80 00       	mov    0x804028,%eax
  802832:	85 c0                	test   %eax,%eax
  802834:	75 14                	jne    80284a <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802836:	a1 38 41 80 00       	mov    0x804138,%eax
  80283b:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  802840:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802847:	00 00 00 
	}
	uint32 c=1;
  80284a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  802851:	a1 60 41 80 00       	mov    0x804160,%eax
  802856:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802859:	e9 b3 01 00 00       	jmp    802a11 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80285e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802861:	8b 40 0c             	mov    0xc(%eax),%eax
  802864:	3b 45 08             	cmp    0x8(%ebp),%eax
  802867:	0f 85 a9 00 00 00    	jne    802916 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80286d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802870:	8b 00                	mov    (%eax),%eax
  802872:	85 c0                	test   %eax,%eax
  802874:	75 0c                	jne    802882 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802876:	a1 38 41 80 00       	mov    0x804138,%eax
  80287b:	a3 60 41 80 00       	mov    %eax,0x804160
  802880:	eb 0a                	jmp    80288c <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802882:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802885:	8b 00                	mov    (%eax),%eax
  802887:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  80288c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802890:	75 17                	jne    8028a9 <alloc_block_NF+0x82>
  802892:	83 ec 04             	sub    $0x4,%esp
  802895:	68 4f 3c 80 00       	push   $0x803c4f
  80289a:	68 e3 00 00 00       	push   $0xe3
  80289f:	68 13 3c 80 00       	push   $0x803c13
  8028a4:	e8 e7 da ff ff       	call   800390 <_panic>
  8028a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	74 10                	je     8028c2 <alloc_block_NF+0x9b>
  8028b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ba:	8b 52 04             	mov    0x4(%edx),%edx
  8028bd:	89 50 04             	mov    %edx,0x4(%eax)
  8028c0:	eb 0b                	jmp    8028cd <alloc_block_NF+0xa6>
  8028c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c5:	8b 40 04             	mov    0x4(%eax),%eax
  8028c8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	8b 40 04             	mov    0x4(%eax),%eax
  8028d3:	85 c0                	test   %eax,%eax
  8028d5:	74 0f                	je     8028e6 <alloc_block_NF+0xbf>
  8028d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028da:	8b 40 04             	mov    0x4(%eax),%eax
  8028dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028e0:	8b 12                	mov    (%edx),%edx
  8028e2:	89 10                	mov    %edx,(%eax)
  8028e4:	eb 0a                	jmp    8028f0 <alloc_block_NF+0xc9>
  8028e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	a3 38 41 80 00       	mov    %eax,0x804138
  8028f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802903:	a1 44 41 80 00       	mov    0x804144,%eax
  802908:	48                   	dec    %eax
  802909:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  80290e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802911:	e9 0e 01 00 00       	jmp    802a24 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802916:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802919:	8b 40 0c             	mov    0xc(%eax),%eax
  80291c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80291f:	0f 86 ce 00 00 00    	jbe    8029f3 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802925:	a1 48 41 80 00       	mov    0x804148,%eax
  80292a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80292d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802931:	75 17                	jne    80294a <alloc_block_NF+0x123>
  802933:	83 ec 04             	sub    $0x4,%esp
  802936:	68 4f 3c 80 00       	push   $0x803c4f
  80293b:	68 e9 00 00 00       	push   $0xe9
  802940:	68 13 3c 80 00       	push   $0x803c13
  802945:	e8 46 da ff ff       	call   800390 <_panic>
  80294a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80294d:	8b 00                	mov    (%eax),%eax
  80294f:	85 c0                	test   %eax,%eax
  802951:	74 10                	je     802963 <alloc_block_NF+0x13c>
  802953:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802956:	8b 00                	mov    (%eax),%eax
  802958:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80295b:	8b 52 04             	mov    0x4(%edx),%edx
  80295e:	89 50 04             	mov    %edx,0x4(%eax)
  802961:	eb 0b                	jmp    80296e <alloc_block_NF+0x147>
  802963:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802966:	8b 40 04             	mov    0x4(%eax),%eax
  802969:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80296e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802971:	8b 40 04             	mov    0x4(%eax),%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	74 0f                	je     802987 <alloc_block_NF+0x160>
  802978:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297b:	8b 40 04             	mov    0x4(%eax),%eax
  80297e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802981:	8b 12                	mov    (%edx),%edx
  802983:	89 10                	mov    %edx,(%eax)
  802985:	eb 0a                	jmp    802991 <alloc_block_NF+0x16a>
  802987:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80298a:	8b 00                	mov    (%eax),%eax
  80298c:	a3 48 41 80 00       	mov    %eax,0x804148
  802991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802994:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80299a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80299d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029a4:	a1 54 41 80 00       	mov    0x804154,%eax
  8029a9:	48                   	dec    %eax
  8029aa:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8029af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b5:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8029b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bb:	8b 50 08             	mov    0x8(%eax),%edx
  8029be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029c1:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8029c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c7:	8b 50 08             	mov    0x8(%eax),%edx
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	01 c2                	add    %eax,%edx
  8029cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d2:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8029d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8029db:	2b 45 08             	sub    0x8(%ebp),%eax
  8029de:	89 c2                	mov    %eax,%edx
  8029e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e3:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8029e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e9:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8029ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029f1:	eb 31                	jmp    802a24 <alloc_block_NF+0x1fd>
			 }
		 c++;
  8029f3:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  8029f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f9:	8b 00                	mov    (%eax),%eax
  8029fb:	85 c0                	test   %eax,%eax
  8029fd:	75 0a                	jne    802a09 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  8029ff:	a1 38 41 80 00       	mov    0x804138,%eax
  802a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a07:	eb 08                	jmp    802a11 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802a11:	a1 44 41 80 00       	mov    0x804144,%eax
  802a16:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a19:	0f 85 3f fe ff ff    	jne    80285e <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a24:	c9                   	leave  
  802a25:	c3                   	ret    

00802a26 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a26:	55                   	push   %ebp
  802a27:	89 e5                	mov    %esp,%ebp
  802a29:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802a2c:	a1 44 41 80 00       	mov    0x804144,%eax
  802a31:	85 c0                	test   %eax,%eax
  802a33:	75 68                	jne    802a9d <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a35:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a39:	75 17                	jne    802a52 <insert_sorted_with_merge_freeList+0x2c>
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	68 f0 3b 80 00       	push   $0x803bf0
  802a43:	68 0e 01 00 00       	push   $0x10e
  802a48:	68 13 3c 80 00       	push   $0x803c13
  802a4d:	e8 3e d9 ff ff       	call   800390 <_panic>
  802a52:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a58:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5b:	89 10                	mov    %edx,(%eax)
  802a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a60:	8b 00                	mov    (%eax),%eax
  802a62:	85 c0                	test   %eax,%eax
  802a64:	74 0d                	je     802a73 <insert_sorted_with_merge_freeList+0x4d>
  802a66:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6e:	89 50 04             	mov    %edx,0x4(%eax)
  802a71:	eb 08                	jmp    802a7b <insert_sorted_with_merge_freeList+0x55>
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	a3 38 41 80 00       	mov    %eax,0x804138
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a8d:	a1 44 41 80 00       	mov    0x804144,%eax
  802a92:	40                   	inc    %eax
  802a93:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a98:	e9 8c 06 00 00       	jmp    803129 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802a9d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802aa5:	a1 38 41 80 00       	mov    0x804138,%eax
  802aaa:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	8b 50 08             	mov    0x8(%eax),%edx
  802ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab6:	8b 40 08             	mov    0x8(%eax),%eax
  802ab9:	39 c2                	cmp    %eax,%edx
  802abb:	0f 86 14 01 00 00    	jbe    802bd5 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac4:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aca:	8b 40 08             	mov    0x8(%eax),%eax
  802acd:	01 c2                	add    %eax,%edx
  802acf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad2:	8b 40 08             	mov    0x8(%eax),%eax
  802ad5:	39 c2                	cmp    %eax,%edx
  802ad7:	0f 85 90 00 00 00    	jne    802b6d <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ae0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ae9:	01 c2                	add    %eax,%edx
  802aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aee:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b09:	75 17                	jne    802b22 <insert_sorted_with_merge_freeList+0xfc>
  802b0b:	83 ec 04             	sub    $0x4,%esp
  802b0e:	68 f0 3b 80 00       	push   $0x803bf0
  802b13:	68 1b 01 00 00       	push   $0x11b
  802b18:	68 13 3c 80 00       	push   $0x803c13
  802b1d:	e8 6e d8 ff ff       	call   800390 <_panic>
  802b22:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	89 10                	mov    %edx,(%eax)
  802b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b30:	8b 00                	mov    (%eax),%eax
  802b32:	85 c0                	test   %eax,%eax
  802b34:	74 0d                	je     802b43 <insert_sorted_with_merge_freeList+0x11d>
  802b36:	a1 48 41 80 00       	mov    0x804148,%eax
  802b3b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3e:	89 50 04             	mov    %edx,0x4(%eax)
  802b41:	eb 08                	jmp    802b4b <insert_sorted_with_merge_freeList+0x125>
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	a3 48 41 80 00       	mov    %eax,0x804148
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b5d:	a1 54 41 80 00       	mov    0x804154,%eax
  802b62:	40                   	inc    %eax
  802b63:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b68:	e9 bc 05 00 00       	jmp    803129 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b71:	75 17                	jne    802b8a <insert_sorted_with_merge_freeList+0x164>
  802b73:	83 ec 04             	sub    $0x4,%esp
  802b76:	68 2c 3c 80 00       	push   $0x803c2c
  802b7b:	68 1f 01 00 00       	push   $0x11f
  802b80:	68 13 3c 80 00       	push   $0x803c13
  802b85:	e8 06 d8 ff ff       	call   800390 <_panic>
  802b8a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	89 50 04             	mov    %edx,0x4(%eax)
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	8b 40 04             	mov    0x4(%eax),%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	74 0c                	je     802bac <insert_sorted_with_merge_freeList+0x186>
  802ba0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba8:	89 10                	mov    %edx,(%eax)
  802baa:	eb 08                	jmp    802bb4 <insert_sorted_with_merge_freeList+0x18e>
  802bac:	8b 45 08             	mov    0x8(%ebp),%eax
  802baf:	a3 38 41 80 00       	mov    %eax,0x804138
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bc5:	a1 44 41 80 00       	mov    0x804144,%eax
  802bca:	40                   	inc    %eax
  802bcb:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bd0:	e9 54 05 00 00       	jmp    803129 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	8b 50 08             	mov    0x8(%eax),%edx
  802bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bde:	8b 40 08             	mov    0x8(%eax),%eax
  802be1:	39 c2                	cmp    %eax,%edx
  802be3:	0f 83 20 01 00 00    	jae    802d09 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	8b 50 0c             	mov    0xc(%eax),%edx
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	8b 40 08             	mov    0x8(%eax),%eax
  802bf5:	01 c2                	add    %eax,%edx
  802bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfa:	8b 40 08             	mov    0x8(%eax),%eax
  802bfd:	39 c2                	cmp    %eax,%edx
  802bff:	0f 85 9c 00 00 00    	jne    802ca1 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802c05:	8b 45 08             	mov    0x8(%ebp),%eax
  802c08:	8b 50 08             	mov    0x8(%eax),%edx
  802c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0e:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c14:	8b 50 0c             	mov    0xc(%eax),%edx
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1d:	01 c2                	add    %eax,%edx
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3d:	75 17                	jne    802c56 <insert_sorted_with_merge_freeList+0x230>
  802c3f:	83 ec 04             	sub    $0x4,%esp
  802c42:	68 f0 3b 80 00       	push   $0x803bf0
  802c47:	68 2a 01 00 00       	push   $0x12a
  802c4c:	68 13 3c 80 00       	push   $0x803c13
  802c51:	e8 3a d7 ff ff       	call   800390 <_panic>
  802c56:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5f:	89 10                	mov    %edx,(%eax)
  802c61:	8b 45 08             	mov    0x8(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	85 c0                	test   %eax,%eax
  802c68:	74 0d                	je     802c77 <insert_sorted_with_merge_freeList+0x251>
  802c6a:	a1 48 41 80 00       	mov    0x804148,%eax
  802c6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802c72:	89 50 04             	mov    %edx,0x4(%eax)
  802c75:	eb 08                	jmp    802c7f <insert_sorted_with_merge_freeList+0x259>
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	a3 48 41 80 00       	mov    %eax,0x804148
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c91:	a1 54 41 80 00       	mov    0x804154,%eax
  802c96:	40                   	inc    %eax
  802c97:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c9c:	e9 88 04 00 00       	jmp    803129 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802ca1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ca5:	75 17                	jne    802cbe <insert_sorted_with_merge_freeList+0x298>
  802ca7:	83 ec 04             	sub    $0x4,%esp
  802caa:	68 f0 3b 80 00       	push   $0x803bf0
  802caf:	68 2e 01 00 00       	push   $0x12e
  802cb4:	68 13 3c 80 00       	push   $0x803c13
  802cb9:	e8 d2 d6 ff ff       	call   800390 <_panic>
  802cbe:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc7:	89 10                	mov    %edx,(%eax)
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	8b 00                	mov    (%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	74 0d                	je     802cdf <insert_sorted_with_merge_freeList+0x2b9>
  802cd2:	a1 38 41 80 00       	mov    0x804138,%eax
  802cd7:	8b 55 08             	mov    0x8(%ebp),%edx
  802cda:	89 50 04             	mov    %edx,0x4(%eax)
  802cdd:	eb 08                	jmp    802ce7 <insert_sorted_with_merge_freeList+0x2c1>
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	a3 38 41 80 00       	mov    %eax,0x804138
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf9:	a1 44 41 80 00       	mov    0x804144,%eax
  802cfe:	40                   	inc    %eax
  802cff:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802d04:	e9 20 04 00 00       	jmp    803129 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802d09:	a1 38 41 80 00       	mov    0x804138,%eax
  802d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d11:	e9 e2 03 00 00       	jmp    8030f8 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 50 08             	mov    0x8(%eax),%edx
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 40 08             	mov    0x8(%eax),%eax
  802d22:	39 c2                	cmp    %eax,%edx
  802d24:	0f 83 c6 03 00 00    	jae    8030f0 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2d:	8b 40 04             	mov    0x4(%eax),%eax
  802d30:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d36:	8b 50 08             	mov    0x8(%eax),%edx
  802d39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d3f:	01 d0                	add    %edx,%eax
  802d41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	8b 50 0c             	mov    0xc(%eax),%edx
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	8b 40 08             	mov    0x8(%eax),%eax
  802d50:	01 d0                	add    %edx,%eax
  802d52:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802d55:	8b 45 08             	mov    0x8(%ebp),%eax
  802d58:	8b 40 08             	mov    0x8(%eax),%eax
  802d5b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d5e:	74 7a                	je     802dda <insert_sorted_with_merge_freeList+0x3b4>
  802d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d63:	8b 40 08             	mov    0x8(%eax),%eax
  802d66:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d69:	74 6f                	je     802dda <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802d6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6f:	74 06                	je     802d77 <insert_sorted_with_merge_freeList+0x351>
  802d71:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d75:	75 17                	jne    802d8e <insert_sorted_with_merge_freeList+0x368>
  802d77:	83 ec 04             	sub    $0x4,%esp
  802d7a:	68 70 3c 80 00       	push   $0x803c70
  802d7f:	68 43 01 00 00       	push   $0x143
  802d84:	68 13 3c 80 00       	push   $0x803c13
  802d89:	e8 02 d6 ff ff       	call   800390 <_panic>
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 50 04             	mov    0x4(%eax),%edx
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	89 50 04             	mov    %edx,0x4(%eax)
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 40 04             	mov    0x4(%eax),%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	74 0d                	je     802db9 <insert_sorted_with_merge_freeList+0x393>
  802dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802daf:	8b 40 04             	mov    0x4(%eax),%eax
  802db2:	8b 55 08             	mov    0x8(%ebp),%edx
  802db5:	89 10                	mov    %edx,(%eax)
  802db7:	eb 08                	jmp    802dc1 <insert_sorted_with_merge_freeList+0x39b>
  802db9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbc:	a3 38 41 80 00       	mov    %eax,0x804138
  802dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc7:	89 50 04             	mov    %edx,0x4(%eax)
  802dca:	a1 44 41 80 00       	mov    0x804144,%eax
  802dcf:	40                   	inc    %eax
  802dd0:	a3 44 41 80 00       	mov    %eax,0x804144
  802dd5:	e9 14 03 00 00       	jmp    8030ee <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	8b 40 08             	mov    0x8(%eax),%eax
  802de0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802de3:	0f 85 a0 01 00 00    	jne    802f89 <insert_sorted_with_merge_freeList+0x563>
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	8b 40 08             	mov    0x8(%eax),%eax
  802def:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802df2:	0f 85 91 01 00 00    	jne    802f89 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802df8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802dfb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	8b 40 0c             	mov    0xc(%eax),%eax
  802e0a:	01 c8                	add    %ecx,%eax
  802e0c:	01 c2                	add    %eax,%edx
  802e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e11:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e40:	75 17                	jne    802e59 <insert_sorted_with_merge_freeList+0x433>
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	68 f0 3b 80 00       	push   $0x803bf0
  802e4a:	68 4d 01 00 00       	push   $0x14d
  802e4f:	68 13 3c 80 00       	push   $0x803c13
  802e54:	e8 37 d5 ff ff       	call   800390 <_panic>
  802e59:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e62:	89 10                	mov    %edx,(%eax)
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	8b 00                	mov    (%eax),%eax
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	74 0d                	je     802e7a <insert_sorted_with_merge_freeList+0x454>
  802e6d:	a1 48 41 80 00       	mov    0x804148,%eax
  802e72:	8b 55 08             	mov    0x8(%ebp),%edx
  802e75:	89 50 04             	mov    %edx,0x4(%eax)
  802e78:	eb 08                	jmp    802e82 <insert_sorted_with_merge_freeList+0x45c>
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e82:	8b 45 08             	mov    0x8(%ebp),%eax
  802e85:	a3 48 41 80 00       	mov    %eax,0x804148
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e94:	a1 54 41 80 00       	mov    0x804154,%eax
  802e99:	40                   	inc    %eax
  802e9a:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802e9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea3:	75 17                	jne    802ebc <insert_sorted_with_merge_freeList+0x496>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 4f 3c 80 00       	push   $0x803c4f
  802ead:	68 4e 01 00 00       	push   $0x14e
  802eb2:	68 13 3c 80 00       	push   $0x803c13
  802eb7:	e8 d4 d4 ff ff       	call   800390 <_panic>
  802ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebf:	8b 00                	mov    (%eax),%eax
  802ec1:	85 c0                	test   %eax,%eax
  802ec3:	74 10                	je     802ed5 <insert_sorted_with_merge_freeList+0x4af>
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	8b 00                	mov    (%eax),%eax
  802eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ecd:	8b 52 04             	mov    0x4(%edx),%edx
  802ed0:	89 50 04             	mov    %edx,0x4(%eax)
  802ed3:	eb 0b                	jmp    802ee0 <insert_sorted_with_merge_freeList+0x4ba>
  802ed5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed8:	8b 40 04             	mov    0x4(%eax),%eax
  802edb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ee0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee3:	8b 40 04             	mov    0x4(%eax),%eax
  802ee6:	85 c0                	test   %eax,%eax
  802ee8:	74 0f                	je     802ef9 <insert_sorted_with_merge_freeList+0x4d3>
  802eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eed:	8b 40 04             	mov    0x4(%eax),%eax
  802ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ef3:	8b 12                	mov    (%edx),%edx
  802ef5:	89 10                	mov    %edx,(%eax)
  802ef7:	eb 0a                	jmp    802f03 <insert_sorted_with_merge_freeList+0x4dd>
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	a3 38 41 80 00       	mov    %eax,0x804138
  802f03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f06:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 44 41 80 00       	mov    0x804144,%eax
  802f1b:	48                   	dec    %eax
  802f1c:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802f21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f25:	75 17                	jne    802f3e <insert_sorted_with_merge_freeList+0x518>
  802f27:	83 ec 04             	sub    $0x4,%esp
  802f2a:	68 f0 3b 80 00       	push   $0x803bf0
  802f2f:	68 4f 01 00 00       	push   $0x14f
  802f34:	68 13 3c 80 00       	push   $0x803c13
  802f39:	e8 52 d4 ff ff       	call   800390 <_panic>
  802f3e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	89 10                	mov    %edx,(%eax)
  802f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4c:	8b 00                	mov    (%eax),%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	74 0d                	je     802f5f <insert_sorted_with_merge_freeList+0x539>
  802f52:	a1 48 41 80 00       	mov    0x804148,%eax
  802f57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f5a:	89 50 04             	mov    %edx,0x4(%eax)
  802f5d:	eb 08                	jmp    802f67 <insert_sorted_with_merge_freeList+0x541>
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6a:	a3 48 41 80 00       	mov    %eax,0x804148
  802f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f79:	a1 54 41 80 00       	mov    0x804154,%eax
  802f7e:	40                   	inc    %eax
  802f7f:	a3 54 41 80 00       	mov    %eax,0x804154
  802f84:	e9 65 01 00 00       	jmp    8030ee <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802f89:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8c:	8b 40 08             	mov    0x8(%eax),%eax
  802f8f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f92:	0f 85 9f 00 00 00    	jne    803037 <insert_sorted_with_merge_freeList+0x611>
  802f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9b:	8b 40 08             	mov    0x8(%eax),%eax
  802f9e:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802fa1:	0f 84 90 00 00 00    	je     803037 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802faa:	8b 50 0c             	mov    0xc(%eax),%edx
  802fad:	8b 45 08             	mov    0x8(%ebp),%eax
  802fb0:	8b 40 0c             	mov    0xc(%eax),%eax
  802fb3:	01 c2                	add    %eax,%edx
  802fb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb8:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fd3:	75 17                	jne    802fec <insert_sorted_with_merge_freeList+0x5c6>
  802fd5:	83 ec 04             	sub    $0x4,%esp
  802fd8:	68 f0 3b 80 00       	push   $0x803bf0
  802fdd:	68 58 01 00 00       	push   $0x158
  802fe2:	68 13 3c 80 00       	push   $0x803c13
  802fe7:	e8 a4 d3 ff ff       	call   800390 <_panic>
  802fec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	89 10                	mov    %edx,(%eax)
  802ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffa:	8b 00                	mov    (%eax),%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	74 0d                	je     80300d <insert_sorted_with_merge_freeList+0x5e7>
  803000:	a1 48 41 80 00       	mov    0x804148,%eax
  803005:	8b 55 08             	mov    0x8(%ebp),%edx
  803008:	89 50 04             	mov    %edx,0x4(%eax)
  80300b:	eb 08                	jmp    803015 <insert_sorted_with_merge_freeList+0x5ef>
  80300d:	8b 45 08             	mov    0x8(%ebp),%eax
  803010:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803015:	8b 45 08             	mov    0x8(%ebp),%eax
  803018:	a3 48 41 80 00       	mov    %eax,0x804148
  80301d:	8b 45 08             	mov    0x8(%ebp),%eax
  803020:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803027:	a1 54 41 80 00       	mov    0x804154,%eax
  80302c:	40                   	inc    %eax
  80302d:	a3 54 41 80 00       	mov    %eax,0x804154
  803032:	e9 b7 00 00 00       	jmp    8030ee <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803037:	8b 45 08             	mov    0x8(%ebp),%eax
  80303a:	8b 40 08             	mov    0x8(%eax),%eax
  80303d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803040:	0f 84 e2 00 00 00    	je     803128 <insert_sorted_with_merge_freeList+0x702>
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 40 08             	mov    0x8(%eax),%eax
  80304c:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80304f:	0f 85 d3 00 00 00    	jne    803128 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803055:	8b 45 08             	mov    0x8(%ebp),%eax
  803058:	8b 50 08             	mov    0x8(%eax),%edx
  80305b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305e:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  803061:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803064:	8b 50 0c             	mov    0xc(%eax),%edx
  803067:	8b 45 08             	mov    0x8(%ebp),%eax
  80306a:	8b 40 0c             	mov    0xc(%eax),%eax
  80306d:	01 c2                	add    %eax,%edx
  80306f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803072:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80307f:	8b 45 08             	mov    0x8(%ebp),%eax
  803082:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803089:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80308d:	75 17                	jne    8030a6 <insert_sorted_with_merge_freeList+0x680>
  80308f:	83 ec 04             	sub    $0x4,%esp
  803092:	68 f0 3b 80 00       	push   $0x803bf0
  803097:	68 61 01 00 00       	push   $0x161
  80309c:	68 13 3c 80 00       	push   $0x803c13
  8030a1:	e8 ea d2 ff ff       	call   800390 <_panic>
  8030a6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8030af:	89 10                	mov    %edx,(%eax)
  8030b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	74 0d                	je     8030c7 <insert_sorted_with_merge_freeList+0x6a1>
  8030ba:	a1 48 41 80 00       	mov    0x804148,%eax
  8030bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8030c2:	89 50 04             	mov    %edx,0x4(%eax)
  8030c5:	eb 08                	jmp    8030cf <insert_sorted_with_merge_freeList+0x6a9>
  8030c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8030da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030e1:	a1 54 41 80 00       	mov    0x804154,%eax
  8030e6:	40                   	inc    %eax
  8030e7:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  8030ec:	eb 3a                	jmp    803128 <insert_sorted_with_merge_freeList+0x702>
  8030ee:	eb 38                	jmp    803128 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8030f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8030f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030fc:	74 07                	je     803105 <insert_sorted_with_merge_freeList+0x6df>
  8030fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803101:	8b 00                	mov    (%eax),%eax
  803103:	eb 05                	jmp    80310a <insert_sorted_with_merge_freeList+0x6e4>
  803105:	b8 00 00 00 00       	mov    $0x0,%eax
  80310a:	a3 40 41 80 00       	mov    %eax,0x804140
  80310f:	a1 40 41 80 00       	mov    0x804140,%eax
  803114:	85 c0                	test   %eax,%eax
  803116:	0f 85 fa fb ff ff    	jne    802d16 <insert_sorted_with_merge_freeList+0x2f0>
  80311c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803120:	0f 85 f0 fb ff ff    	jne    802d16 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803126:	eb 01                	jmp    803129 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803128:	90                   	nop
							}

						}
		          }
		}
}
  803129:	90                   	nop
  80312a:	c9                   	leave  
  80312b:	c3                   	ret    

0080312c <__udivdi3>:
  80312c:	55                   	push   %ebp
  80312d:	57                   	push   %edi
  80312e:	56                   	push   %esi
  80312f:	53                   	push   %ebx
  803130:	83 ec 1c             	sub    $0x1c,%esp
  803133:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803137:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80313b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80313f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803143:	89 ca                	mov    %ecx,%edx
  803145:	89 f8                	mov    %edi,%eax
  803147:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80314b:	85 f6                	test   %esi,%esi
  80314d:	75 2d                	jne    80317c <__udivdi3+0x50>
  80314f:	39 cf                	cmp    %ecx,%edi
  803151:	77 65                	ja     8031b8 <__udivdi3+0x8c>
  803153:	89 fd                	mov    %edi,%ebp
  803155:	85 ff                	test   %edi,%edi
  803157:	75 0b                	jne    803164 <__udivdi3+0x38>
  803159:	b8 01 00 00 00       	mov    $0x1,%eax
  80315e:	31 d2                	xor    %edx,%edx
  803160:	f7 f7                	div    %edi
  803162:	89 c5                	mov    %eax,%ebp
  803164:	31 d2                	xor    %edx,%edx
  803166:	89 c8                	mov    %ecx,%eax
  803168:	f7 f5                	div    %ebp
  80316a:	89 c1                	mov    %eax,%ecx
  80316c:	89 d8                	mov    %ebx,%eax
  80316e:	f7 f5                	div    %ebp
  803170:	89 cf                	mov    %ecx,%edi
  803172:	89 fa                	mov    %edi,%edx
  803174:	83 c4 1c             	add    $0x1c,%esp
  803177:	5b                   	pop    %ebx
  803178:	5e                   	pop    %esi
  803179:	5f                   	pop    %edi
  80317a:	5d                   	pop    %ebp
  80317b:	c3                   	ret    
  80317c:	39 ce                	cmp    %ecx,%esi
  80317e:	77 28                	ja     8031a8 <__udivdi3+0x7c>
  803180:	0f bd fe             	bsr    %esi,%edi
  803183:	83 f7 1f             	xor    $0x1f,%edi
  803186:	75 40                	jne    8031c8 <__udivdi3+0x9c>
  803188:	39 ce                	cmp    %ecx,%esi
  80318a:	72 0a                	jb     803196 <__udivdi3+0x6a>
  80318c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803190:	0f 87 9e 00 00 00    	ja     803234 <__udivdi3+0x108>
  803196:	b8 01 00 00 00       	mov    $0x1,%eax
  80319b:	89 fa                	mov    %edi,%edx
  80319d:	83 c4 1c             	add    $0x1c,%esp
  8031a0:	5b                   	pop    %ebx
  8031a1:	5e                   	pop    %esi
  8031a2:	5f                   	pop    %edi
  8031a3:	5d                   	pop    %ebp
  8031a4:	c3                   	ret    
  8031a5:	8d 76 00             	lea    0x0(%esi),%esi
  8031a8:	31 ff                	xor    %edi,%edi
  8031aa:	31 c0                	xor    %eax,%eax
  8031ac:	89 fa                	mov    %edi,%edx
  8031ae:	83 c4 1c             	add    $0x1c,%esp
  8031b1:	5b                   	pop    %ebx
  8031b2:	5e                   	pop    %esi
  8031b3:	5f                   	pop    %edi
  8031b4:	5d                   	pop    %ebp
  8031b5:	c3                   	ret    
  8031b6:	66 90                	xchg   %ax,%ax
  8031b8:	89 d8                	mov    %ebx,%eax
  8031ba:	f7 f7                	div    %edi
  8031bc:	31 ff                	xor    %edi,%edi
  8031be:	89 fa                	mov    %edi,%edx
  8031c0:	83 c4 1c             	add    $0x1c,%esp
  8031c3:	5b                   	pop    %ebx
  8031c4:	5e                   	pop    %esi
  8031c5:	5f                   	pop    %edi
  8031c6:	5d                   	pop    %ebp
  8031c7:	c3                   	ret    
  8031c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031cd:	89 eb                	mov    %ebp,%ebx
  8031cf:	29 fb                	sub    %edi,%ebx
  8031d1:	89 f9                	mov    %edi,%ecx
  8031d3:	d3 e6                	shl    %cl,%esi
  8031d5:	89 c5                	mov    %eax,%ebp
  8031d7:	88 d9                	mov    %bl,%cl
  8031d9:	d3 ed                	shr    %cl,%ebp
  8031db:	89 e9                	mov    %ebp,%ecx
  8031dd:	09 f1                	or     %esi,%ecx
  8031df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031e3:	89 f9                	mov    %edi,%ecx
  8031e5:	d3 e0                	shl    %cl,%eax
  8031e7:	89 c5                	mov    %eax,%ebp
  8031e9:	89 d6                	mov    %edx,%esi
  8031eb:	88 d9                	mov    %bl,%cl
  8031ed:	d3 ee                	shr    %cl,%esi
  8031ef:	89 f9                	mov    %edi,%ecx
  8031f1:	d3 e2                	shl    %cl,%edx
  8031f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f7:	88 d9                	mov    %bl,%cl
  8031f9:	d3 e8                	shr    %cl,%eax
  8031fb:	09 c2                	or     %eax,%edx
  8031fd:	89 d0                	mov    %edx,%eax
  8031ff:	89 f2                	mov    %esi,%edx
  803201:	f7 74 24 0c          	divl   0xc(%esp)
  803205:	89 d6                	mov    %edx,%esi
  803207:	89 c3                	mov    %eax,%ebx
  803209:	f7 e5                	mul    %ebp
  80320b:	39 d6                	cmp    %edx,%esi
  80320d:	72 19                	jb     803228 <__udivdi3+0xfc>
  80320f:	74 0b                	je     80321c <__udivdi3+0xf0>
  803211:	89 d8                	mov    %ebx,%eax
  803213:	31 ff                	xor    %edi,%edi
  803215:	e9 58 ff ff ff       	jmp    803172 <__udivdi3+0x46>
  80321a:	66 90                	xchg   %ax,%ax
  80321c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803220:	89 f9                	mov    %edi,%ecx
  803222:	d3 e2                	shl    %cl,%edx
  803224:	39 c2                	cmp    %eax,%edx
  803226:	73 e9                	jae    803211 <__udivdi3+0xe5>
  803228:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80322b:	31 ff                	xor    %edi,%edi
  80322d:	e9 40 ff ff ff       	jmp    803172 <__udivdi3+0x46>
  803232:	66 90                	xchg   %ax,%ax
  803234:	31 c0                	xor    %eax,%eax
  803236:	e9 37 ff ff ff       	jmp    803172 <__udivdi3+0x46>
  80323b:	90                   	nop

0080323c <__umoddi3>:
  80323c:	55                   	push   %ebp
  80323d:	57                   	push   %edi
  80323e:	56                   	push   %esi
  80323f:	53                   	push   %ebx
  803240:	83 ec 1c             	sub    $0x1c,%esp
  803243:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803247:	8b 74 24 34          	mov    0x34(%esp),%esi
  80324b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80324f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803253:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803257:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80325b:	89 f3                	mov    %esi,%ebx
  80325d:	89 fa                	mov    %edi,%edx
  80325f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803263:	89 34 24             	mov    %esi,(%esp)
  803266:	85 c0                	test   %eax,%eax
  803268:	75 1a                	jne    803284 <__umoddi3+0x48>
  80326a:	39 f7                	cmp    %esi,%edi
  80326c:	0f 86 a2 00 00 00    	jbe    803314 <__umoddi3+0xd8>
  803272:	89 c8                	mov    %ecx,%eax
  803274:	89 f2                	mov    %esi,%edx
  803276:	f7 f7                	div    %edi
  803278:	89 d0                	mov    %edx,%eax
  80327a:	31 d2                	xor    %edx,%edx
  80327c:	83 c4 1c             	add    $0x1c,%esp
  80327f:	5b                   	pop    %ebx
  803280:	5e                   	pop    %esi
  803281:	5f                   	pop    %edi
  803282:	5d                   	pop    %ebp
  803283:	c3                   	ret    
  803284:	39 f0                	cmp    %esi,%eax
  803286:	0f 87 ac 00 00 00    	ja     803338 <__umoddi3+0xfc>
  80328c:	0f bd e8             	bsr    %eax,%ebp
  80328f:	83 f5 1f             	xor    $0x1f,%ebp
  803292:	0f 84 ac 00 00 00    	je     803344 <__umoddi3+0x108>
  803298:	bf 20 00 00 00       	mov    $0x20,%edi
  80329d:	29 ef                	sub    %ebp,%edi
  80329f:	89 fe                	mov    %edi,%esi
  8032a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032a5:	89 e9                	mov    %ebp,%ecx
  8032a7:	d3 e0                	shl    %cl,%eax
  8032a9:	89 d7                	mov    %edx,%edi
  8032ab:	89 f1                	mov    %esi,%ecx
  8032ad:	d3 ef                	shr    %cl,%edi
  8032af:	09 c7                	or     %eax,%edi
  8032b1:	89 e9                	mov    %ebp,%ecx
  8032b3:	d3 e2                	shl    %cl,%edx
  8032b5:	89 14 24             	mov    %edx,(%esp)
  8032b8:	89 d8                	mov    %ebx,%eax
  8032ba:	d3 e0                	shl    %cl,%eax
  8032bc:	89 c2                	mov    %eax,%edx
  8032be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c2:	d3 e0                	shl    %cl,%eax
  8032c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032cc:	89 f1                	mov    %esi,%ecx
  8032ce:	d3 e8                	shr    %cl,%eax
  8032d0:	09 d0                	or     %edx,%eax
  8032d2:	d3 eb                	shr    %cl,%ebx
  8032d4:	89 da                	mov    %ebx,%edx
  8032d6:	f7 f7                	div    %edi
  8032d8:	89 d3                	mov    %edx,%ebx
  8032da:	f7 24 24             	mull   (%esp)
  8032dd:	89 c6                	mov    %eax,%esi
  8032df:	89 d1                	mov    %edx,%ecx
  8032e1:	39 d3                	cmp    %edx,%ebx
  8032e3:	0f 82 87 00 00 00    	jb     803370 <__umoddi3+0x134>
  8032e9:	0f 84 91 00 00 00    	je     803380 <__umoddi3+0x144>
  8032ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032f3:	29 f2                	sub    %esi,%edx
  8032f5:	19 cb                	sbb    %ecx,%ebx
  8032f7:	89 d8                	mov    %ebx,%eax
  8032f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032fd:	d3 e0                	shl    %cl,%eax
  8032ff:	89 e9                	mov    %ebp,%ecx
  803301:	d3 ea                	shr    %cl,%edx
  803303:	09 d0                	or     %edx,%eax
  803305:	89 e9                	mov    %ebp,%ecx
  803307:	d3 eb                	shr    %cl,%ebx
  803309:	89 da                	mov    %ebx,%edx
  80330b:	83 c4 1c             	add    $0x1c,%esp
  80330e:	5b                   	pop    %ebx
  80330f:	5e                   	pop    %esi
  803310:	5f                   	pop    %edi
  803311:	5d                   	pop    %ebp
  803312:	c3                   	ret    
  803313:	90                   	nop
  803314:	89 fd                	mov    %edi,%ebp
  803316:	85 ff                	test   %edi,%edi
  803318:	75 0b                	jne    803325 <__umoddi3+0xe9>
  80331a:	b8 01 00 00 00       	mov    $0x1,%eax
  80331f:	31 d2                	xor    %edx,%edx
  803321:	f7 f7                	div    %edi
  803323:	89 c5                	mov    %eax,%ebp
  803325:	89 f0                	mov    %esi,%eax
  803327:	31 d2                	xor    %edx,%edx
  803329:	f7 f5                	div    %ebp
  80332b:	89 c8                	mov    %ecx,%eax
  80332d:	f7 f5                	div    %ebp
  80332f:	89 d0                	mov    %edx,%eax
  803331:	e9 44 ff ff ff       	jmp    80327a <__umoddi3+0x3e>
  803336:	66 90                	xchg   %ax,%ax
  803338:	89 c8                	mov    %ecx,%eax
  80333a:	89 f2                	mov    %esi,%edx
  80333c:	83 c4 1c             	add    $0x1c,%esp
  80333f:	5b                   	pop    %ebx
  803340:	5e                   	pop    %esi
  803341:	5f                   	pop    %edi
  803342:	5d                   	pop    %ebp
  803343:	c3                   	ret    
  803344:	3b 04 24             	cmp    (%esp),%eax
  803347:	72 06                	jb     80334f <__umoddi3+0x113>
  803349:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80334d:	77 0f                	ja     80335e <__umoddi3+0x122>
  80334f:	89 f2                	mov    %esi,%edx
  803351:	29 f9                	sub    %edi,%ecx
  803353:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803357:	89 14 24             	mov    %edx,(%esp)
  80335a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80335e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803362:	8b 14 24             	mov    (%esp),%edx
  803365:	83 c4 1c             	add    $0x1c,%esp
  803368:	5b                   	pop    %ebx
  803369:	5e                   	pop    %esi
  80336a:	5f                   	pop    %edi
  80336b:	5d                   	pop    %ebp
  80336c:	c3                   	ret    
  80336d:	8d 76 00             	lea    0x0(%esi),%esi
  803370:	2b 04 24             	sub    (%esp),%eax
  803373:	19 fa                	sbb    %edi,%edx
  803375:	89 d1                	mov    %edx,%ecx
  803377:	89 c6                	mov    %eax,%esi
  803379:	e9 71 ff ff ff       	jmp    8032ef <__umoddi3+0xb3>
  80337e:	66 90                	xchg   %ax,%ax
  803380:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803384:	72 ea                	jb     803370 <__umoddi3+0x134>
  803386:	89 d9                	mov    %ebx,%ecx
  803388:	e9 62 ff ff ff       	jmp    8032ef <__umoddi3+0xb3>

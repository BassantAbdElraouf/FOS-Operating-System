
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 2b 02 00 00       	call   800261 <libmain>
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
  800099:	e8 ff 02 00 00       	call   80039d <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 d8 14 00 00       	call   801580 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 36 1c 00 00       	call   801ce6 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 22 1a 00 00       	call   801ada <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 30 19 00 00       	call   8019ed <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 d7 33 80 00       	push   $0x8033d7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 d6 16 00 00       	call   8017a6 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 dc 33 80 00       	push   $0x8033dc
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 bc 33 80 00       	push   $0x8033bc
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 f2 18 00 00       	call   8019ed <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 3c 34 80 00       	push   $0x80343c
  80010c:	6a 21                	push   $0x21
  80010e:	68 bc 33 80 00       	push   $0x8033bc
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 d7 19 00 00       	call   801af4 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 b8 19 00 00       	call   801ada <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 c6 18 00 00       	call   8019ed <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 cd 34 80 00       	push   $0x8034cd
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 6c 16 00 00       	call   8017a6 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 dc 33 80 00       	push   $0x8033dc
  800151:	6a 27                	push   $0x27
  800153:	68 bc 33 80 00       	push   $0x8033bc
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 8b 18 00 00       	call   8019ed <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 3c 34 80 00       	push   $0x80343c
  800173:	6a 28                	push   $0x28
  800175:	68 bc 33 80 00       	push   $0x8033bc
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 70 19 00 00       	call   801af4 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 d0 34 80 00       	push   $0x8034d0
  800196:	6a 2b                	push   $0x2b
  800198:	68 bc 33 80 00       	push   $0x8033bc
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 33 19 00 00       	call   801ada <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 41 18 00 00       	call   8019ed <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 07 35 80 00       	push   $0x803507
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 e7 15 00 00       	call   8017a6 <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 dc 33 80 00       	push   $0x8033dc
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 bc 33 80 00       	push   $0x8033bc
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 06 18 00 00       	call   8019ed <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 3c 34 80 00       	push   $0x80343c
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 bc 33 80 00       	push   $0x8033bc
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 eb 18 00 00       	call   801af4 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 d0 34 80 00       	push   $0x8034d0
  80021b:	6a 34                	push   $0x34
  80021d:	68 bc 33 80 00       	push   $0x8033bc
  800222:	e8 76 01 00 00       	call   80039d <_panic>

	*z = *x + *y ;
  800227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022a:	8b 10                	mov    (%eax),%edx
  80022c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	01 c2                	add    %eax,%edx
  800233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800236:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	83 f8 1e             	cmp    $0x1e,%eax
  800240:	74 14                	je     800256 <_main+0x21e>
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 d0 34 80 00       	push   $0x8034d0
  80024a:	6a 37                	push   $0x37
  80024c:	68 bc 33 80 00       	push   $0x8033bc
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 b0 1b 00 00       	call   801e0b <inctst>

	return;
  80025b:	90                   	nop
}
  80025c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800267:	e8 61 1a 00 00       	call   801ccd <sys_getenvindex>
  80026c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80026f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800272:	89 d0                	mov    %edx,%eax
  800274:	c1 e0 03             	shl    $0x3,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	01 c0                	add    %eax,%eax
  80027b:	01 d0                	add    %edx,%eax
  80027d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800284:	01 d0                	add    %edx,%eax
  800286:	c1 e0 04             	shl    $0x4,%eax
  800289:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028e:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800293:	a1 20 40 80 00       	mov    0x804020,%eax
  800298:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80029e:	84 c0                	test   %al,%al
  8002a0:	74 0f                	je     8002b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8002ac:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b5:	7e 0a                	jle    8002c1 <libmain+0x60>
		binaryname = argv[0];
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 0c             	pushl  0xc(%ebp)
  8002c7:	ff 75 08             	pushl  0x8(%ebp)
  8002ca:	e8 69 fd ff ff       	call   800038 <_main>
  8002cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002d2:	e8 03 18 00 00       	call   801ada <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 24 35 80 00       	push   $0x803524
  8002df:	e8 6d 03 00 00       	call   800651 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	52                   	push   %edx
  800301:	50                   	push   %eax
  800302:	68 4c 35 80 00       	push   $0x80354c
  800307:	e8 45 03 00 00       	call   800651 <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80030f:	a1 20 40 80 00       	mov    0x804020,%eax
  800314:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80031a:	a1 20 40 80 00       	mov    0x804020,%eax
  80031f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800325:	a1 20 40 80 00       	mov    0x804020,%eax
  80032a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800330:	51                   	push   %ecx
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	68 74 35 80 00       	push   $0x803574
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 40 80 00       	mov    0x804020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 cc 35 80 00       	push   $0x8035cc
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 24 35 80 00       	push   $0x803524
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 83 17 00 00       	call   801af4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800371:	e8 19 00 00 00       	call   80038f <exit>
}
  800376:	90                   	nop
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	6a 00                	push   $0x0
  800384:	e8 10 19 00 00       	call   801c99 <sys_destroy_env>
  800389:	83 c4 10             	add    $0x10,%esp
}
  80038c:	90                   	nop
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <exit>:

void
exit(void)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800395:	e8 65 19 00 00       	call   801cff <sys_exit_env>
}
  80039a:	90                   	nop
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003ac:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003b1:	85 c0                	test   %eax,%eax
  8003b3:	74 16                	je     8003cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	50                   	push   %eax
  8003be:	68 e0 35 80 00       	push   $0x8035e0
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 40 80 00       	mov    0x804000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 e5 35 80 00       	push   $0x8035e5
  8003dc:	e8 70 02 00 00       	call   800651 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ed:	50                   	push   %eax
  8003ee:	e8 f3 01 00 00       	call   8005e6 <vcprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	6a 00                	push   $0x0
  8003fb:	68 01 36 80 00       	push   $0x803601
  800400:	e8 e1 01 00 00       	call   8005e6 <vcprintf>
  800405:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800408:	e8 82 ff ff ff       	call   80038f <exit>

	// should not return here
	while (1) ;
  80040d:	eb fe                	jmp    80040d <_panic+0x70>

0080040f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 04 36 80 00       	push   $0x803604
  80042c:	6a 26                	push   $0x26
  80042e:	68 50 36 80 00       	push   $0x803650
  800433:	e8 65 ff ff ff       	call   80039d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80043f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800446:	e9 c2 00 00 00       	jmp    80050d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80044b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	01 d0                	add    %edx,%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	85 c0                	test   %eax,%eax
  80045e:	75 08                	jne    800468 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800460:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800463:	e9 a2 00 00 00       	jmp    80050a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800468:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800476:	eb 69                	jmp    8004e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800478:	a1 20 40 80 00       	mov    0x804020,%eax
  80047d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800483:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800486:	89 d0                	mov    %edx,%eax
  800488:	01 c0                	add    %eax,%eax
  80048a:	01 d0                	add    %edx,%eax
  80048c:	c1 e0 03             	shl    $0x3,%eax
  80048f:	01 c8                	add    %ecx,%eax
  800491:	8a 40 04             	mov    0x4(%eax),%al
  800494:	84 c0                	test   %al,%al
  800496:	75 46                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a6:	89 d0                	mov    %edx,%eax
  8004a8:	01 c0                	add    %eax,%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	c1 e0 03             	shl    $0x3,%eax
  8004af:	01 c8                	add    %ecx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	01 c8                	add    %ecx,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	75 09                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004dc:	eb 12                	jmp    8004f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004de:	ff 45 e8             	incl   -0x18(%ebp)
  8004e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004e6:	8b 50 74             	mov    0x74(%eax),%edx
  8004e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ec:	39 c2                	cmp    %eax,%edx
  8004ee:	77 88                	ja     800478 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004f4:	75 14                	jne    80050a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	68 5c 36 80 00       	push   $0x80365c
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 50 36 80 00       	push   $0x803650
  800505:	e8 93 fe ff ff       	call   80039d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80050a:	ff 45 f0             	incl   -0x10(%ebp)
  80050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800510:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800513:	0f 8c 32 ff ff ff    	jl     80044b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800519:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800520:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800527:	eb 26                	jmp    80054f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800529:	a1 20 40 80 00       	mov    0x804020,%eax
  80052e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	01 c0                	add    %eax,%eax
  80053b:	01 d0                	add    %edx,%eax
  80053d:	c1 e0 03             	shl    $0x3,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	8a 40 04             	mov    0x4(%eax),%al
  800545:	3c 01                	cmp    $0x1,%al
  800547:	75 03                	jne    80054c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800549:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054c:	ff 45 e0             	incl   -0x20(%ebp)
  80054f:	a1 20 40 80 00       	mov    0x804020,%eax
  800554:	8b 50 74             	mov    0x74(%eax),%edx
  800557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055a:	39 c2                	cmp    %eax,%edx
  80055c:	77 cb                	ja     800529 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80055e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800561:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800564:	74 14                	je     80057a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800566:	83 ec 04             	sub    $0x4,%esp
  800569:	68 b0 36 80 00       	push   $0x8036b0
  80056e:	6a 44                	push   $0x44
  800570:	68 50 36 80 00       	push   $0x803650
  800575:	e8 23 fe ff ff       	call   80039d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80057a:	90                   	nop
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	8d 48 01             	lea    0x1(%eax),%ecx
  80058b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058e:	89 0a                	mov    %ecx,(%edx)
  800590:	8b 55 08             	mov    0x8(%ebp),%edx
  800593:	88 d1                	mov    %dl,%cl
  800595:	8b 55 0c             	mov    0xc(%ebp),%edx
  800598:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a6:	75 2c                	jne    8005d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005a8:	a0 24 40 80 00       	mov    0x804024,%al
  8005ad:	0f b6 c0             	movzbl %al,%eax
  8005b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b3:	8b 12                	mov    (%edx),%edx
  8005b5:	89 d1                	mov    %edx,%ecx
  8005b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ba:	83 c2 08             	add    $0x8,%edx
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	50                   	push   %eax
  8005c1:	51                   	push   %ecx
  8005c2:	52                   	push   %edx
  8005c3:	e8 64 13 00 00       	call   80192c <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d7:	8b 40 04             	mov    0x4(%eax),%eax
  8005da:	8d 50 01             	lea    0x1(%eax),%edx
  8005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e3:	90                   	nop
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f6:	00 00 00 
	b.cnt = 0;
  8005f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800600:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 08             	pushl  0x8(%ebp)
  800609:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060f:	50                   	push   %eax
  800610:	68 7d 05 80 00       	push   $0x80057d
  800615:	e8 11 02 00 00       	call   80082b <vprintfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80061d:	a0 24 40 80 00       	mov    0x804024,%al
  800622:	0f b6 c0             	movzbl %al,%eax
  800625:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80062b:	83 ec 04             	sub    $0x4,%esp
  80062e:	50                   	push   %eax
  80062f:	52                   	push   %edx
  800630:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800636:	83 c0 08             	add    $0x8,%eax
  800639:	50                   	push   %eax
  80063a:	e8 ed 12 00 00       	call   80192c <sys_cputs>
  80063f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800642:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800649:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <cprintf>:

int cprintf(const char *fmt, ...) {
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800657:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80065e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800661:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 f4             	pushl  -0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	e8 73 ff ff ff       	call   8005e6 <vcprintf>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800684:	e8 51 14 00 00       	call   801ada <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800689:	8d 45 0c             	lea    0xc(%ebp),%eax
  80068c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 f4             	pushl  -0xc(%ebp)
  800698:	50                   	push   %eax
  800699:	e8 48 ff ff ff       	call   8005e6 <vcprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006a4:	e8 4b 14 00 00       	call   801af4 <sys_enable_interrupt>
	return cnt;
  8006a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 14             	sub    $0x14,%esp
  8006b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006cc:	77 55                	ja     800723 <printnum+0x75>
  8006ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d1:	72 05                	jb     8006d8 <printnum+0x2a>
  8006d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006d6:	77 4b                	ja     800723 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006de:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ee:	e8 49 2a 00 00       	call   80313c <__udivdi3>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	53                   	push   %ebx
  8006fd:	ff 75 18             	pushl  0x18(%ebp)
  800700:	52                   	push   %edx
  800701:	50                   	push   %eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	e8 a1 ff ff ff       	call   8006ae <printnum>
  80070d:	83 c4 20             	add    $0x20,%esp
  800710:	eb 1a                	jmp    80072c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	ff 75 20             	pushl  0x20(%ebp)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	ff d0                	call   *%eax
  800720:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800723:	ff 4d 1c             	decl   0x1c(%ebp)
  800726:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80072a:	7f e6                	jg     800712 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80072c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80072f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	53                   	push   %ebx
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	e8 09 2b 00 00       	call   80324c <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 14 39 80 00       	add    $0x803914,%eax
  80074b:	8a 00                	mov    (%eax),%al
  80074d:	0f be c0             	movsbl %al,%eax
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	50                   	push   %eax
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
}
  80075f:	90                   	nop
  800760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800768:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076c:	7e 1c                	jle    80078a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	8d 50 08             	lea    0x8(%eax),%edx
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	89 10                	mov    %edx,(%eax)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	83 e8 08             	sub    $0x8,%eax
  800783:	8b 50 04             	mov    0x4(%eax),%edx
  800786:	8b 00                	mov    (%eax),%eax
  800788:	eb 40                	jmp    8007ca <getuint+0x65>
	else if (lflag)
  80078a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078e:	74 1e                	je     8007ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	8d 50 04             	lea    0x4(%eax),%edx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	89 10                	mov    %edx,(%eax)
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	83 e8 04             	sub    $0x4,%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	eb 1c                	jmp    8007ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 10                	mov    %edx,(%eax)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d3:	7e 1c                	jle    8007f1 <getint+0x25>
		return va_arg(*ap, long long);
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	8d 50 08             	lea    0x8(%eax),%edx
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	89 10                	mov    %edx,(%eax)
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	83 e8 08             	sub    $0x8,%eax
  8007ea:	8b 50 04             	mov    0x4(%eax),%edx
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	eb 38                	jmp    800829 <getint+0x5d>
	else if (lflag)
  8007f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f5:	74 1a                	je     800811 <getint+0x45>
		return va_arg(*ap, long);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	8d 50 04             	lea    0x4(%eax),%edx
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	89 10                	mov    %edx,(%eax)
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	83 e8 04             	sub    $0x4,%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	99                   	cltd   
  80080f:	eb 18                	jmp    800829 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	8d 50 04             	lea    0x4(%eax),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	89 10                	mov    %edx,(%eax)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	99                   	cltd   
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	56                   	push   %esi
  80082f:	53                   	push   %ebx
  800830:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800833:	eb 17                	jmp    80084c <vprintfmt+0x21>
			if (ch == '\0')
  800835:	85 db                	test   %ebx,%ebx
  800837:	0f 84 af 03 00 00    	je     800bec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	83 fb 25             	cmp    $0x25,%ebx
  80085d:	75 d6                	jne    800835 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80085f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800863:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80086a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800871:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800878:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	89 55 10             	mov    %edx,0x10(%ebp)
  800888:	8a 00                	mov    (%eax),%al
  80088a:	0f b6 d8             	movzbl %al,%ebx
  80088d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800890:	83 f8 55             	cmp    $0x55,%eax
  800893:	0f 87 2b 03 00 00    	ja     800bc4 <vprintfmt+0x399>
  800899:	8b 04 85 38 39 80 00 	mov    0x803938(,%eax,4),%eax
  8008a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008a6:	eb d7                	jmp    80087f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ac:	eb d1                	jmp    80087f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	c1 e0 02             	shl    $0x2,%eax
  8008bd:	01 d0                	add    %edx,%eax
  8008bf:	01 c0                	add    %eax,%eax
  8008c1:	01 d8                	add    %ebx,%eax
  8008c3:	83 e8 30             	sub    $0x30,%eax
  8008c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	8a 00                	mov    (%eax),%al
  8008ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008d4:	7e 3e                	jle    800914 <vprintfmt+0xe9>
  8008d6:	83 fb 39             	cmp    $0x39,%ebx
  8008d9:	7f 39                	jg     800914 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008de:	eb d5                	jmp    8008b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 c0 04             	add    $0x4,%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008f4:	eb 1f                	jmp    800915 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	79 83                	jns    80087f <vprintfmt+0x54>
				width = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800903:	e9 77 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800908:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80090f:	e9 6b ff ff ff       	jmp    80087f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800914:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800919:	0f 89 60 ff ff ff    	jns    80087f <vprintfmt+0x54>
				width = precision, precision = -1;
  80091f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800925:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80092c:	e9 4e ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800931:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800934:	e9 46 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	83 c0 04             	add    $0x4,%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 e8 04             	sub    $0x4,%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	50                   	push   %eax
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			break;
  800959:	e9 89 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	83 c0 04             	add    $0x4,%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	83 e8 04             	sub    $0x4,%eax
  80096d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80096f:	85 db                	test   %ebx,%ebx
  800971:	79 02                	jns    800975 <vprintfmt+0x14a>
				err = -err;
  800973:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800975:	83 fb 64             	cmp    $0x64,%ebx
  800978:	7f 0b                	jg     800985 <vprintfmt+0x15a>
  80097a:	8b 34 9d 80 37 80 00 	mov    0x803780(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 25 39 80 00       	push   $0x803925
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	e8 5e 02 00 00       	call   800bf4 <printfmt>
  800996:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800999:	e9 49 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80099e:	56                   	push   %esi
  80099f:	68 2e 39 80 00       	push   $0x80392e
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 45 02 00 00       	call   800bf4 <printfmt>
  8009af:	83 c4 10             	add    $0x10,%esp
			break;
  8009b2:	e9 30 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	83 c0 04             	add    $0x4,%eax
  8009bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	83 e8 04             	sub    $0x4,%eax
  8009c6:	8b 30                	mov    (%eax),%esi
  8009c8:	85 f6                	test   %esi,%esi
  8009ca:	75 05                	jne    8009d1 <vprintfmt+0x1a6>
				p = "(null)";
  8009cc:	be 31 39 80 00       	mov    $0x803931,%esi
			if (width > 0 && padc != '-')
  8009d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d5:	7e 6d                	jle    800a44 <vprintfmt+0x219>
  8009d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009db:	74 67                	je     800a44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	50                   	push   %eax
  8009e4:	56                   	push   %esi
  8009e5:	e8 0c 03 00 00       	call   800cf6 <strnlen>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f0:	eb 16                	jmp    800a08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	50                   	push   %eax
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a05:	ff 4d e4             	decl   -0x1c(%ebp)
  800a08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0c:	7f e4                	jg     8009f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	eb 34                	jmp    800a44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a14:	74 1c                	je     800a32 <vprintfmt+0x207>
  800a16:	83 fb 1f             	cmp    $0x1f,%ebx
  800a19:	7e 05                	jle    800a20 <vprintfmt+0x1f5>
  800a1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a1e:	7e 12                	jle    800a32 <vprintfmt+0x207>
					putch('?', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 3f                	push   $0x3f
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	eb 0f                	jmp    800a41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	53                   	push   %ebx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a41:	ff 4d e4             	decl   -0x1c(%ebp)
  800a44:	89 f0                	mov    %esi,%eax
  800a46:	8d 70 01             	lea    0x1(%eax),%esi
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	0f be d8             	movsbl %al,%ebx
  800a4e:	85 db                	test   %ebx,%ebx
  800a50:	74 24                	je     800a76 <vprintfmt+0x24b>
  800a52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a56:	78 b8                	js     800a10 <vprintfmt+0x1e5>
  800a58:	ff 4d e0             	decl   -0x20(%ebp)
  800a5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5f:	79 af                	jns    800a10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a61:	eb 13                	jmp    800a76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	6a 20                	push   $0x20
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7a:	7f e7                	jg     800a63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a7c:	e9 66 01 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 e8             	pushl  -0x18(%ebp)
  800a87:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8a:	50                   	push   %eax
  800a8b:	e8 3c fd ff ff       	call   8007cc <getint>
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9f:	85 d2                	test   %edx,%edx
  800aa1:	79 23                	jns    800ac6 <vprintfmt+0x29b>
				putch('-', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 2d                	push   $0x2d
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab9:	f7 d8                	neg    %eax
  800abb:	83 d2 00             	adc    $0x0,%edx
  800abe:	f7 da                	neg    %edx
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ac6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800acd:	e9 bc 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad8:	8d 45 14             	lea    0x14(%ebp),%eax
  800adb:	50                   	push   %eax
  800adc:	e8 84 fc ff ff       	call   800765 <getuint>
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af1:	e9 98 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 58                	push   $0x58
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 58                	push   $0x58
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	6a 58                	push   $0x58
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			break;
  800b26:	e9 bc 00 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	6a 30                	push   $0x30
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 78                	push   $0x78
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b6d:	eb 1f                	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 e8             	pushl  -0x18(%ebp)
  800b75:	8d 45 14             	lea    0x14(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	e8 e7 fb ff ff       	call   800765 <getuint>
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	52                   	push   %edx
  800b99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b9c:	50                   	push   %eax
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	e8 00 fb ff ff       	call   8006ae <printnum>
  800bae:	83 c4 20             	add    $0x20,%esp
			break;
  800bb1:	eb 34                	jmp    800be7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			break;
  800bc2:	eb 23                	jmp    800be7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	6a 25                	push   $0x25
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd4:	ff 4d 10             	decl   0x10(%ebp)
  800bd7:	eb 03                	jmp    800bdc <vprintfmt+0x3b1>
  800bd9:	ff 4d 10             	decl   0x10(%ebp)
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	48                   	dec    %eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	3c 25                	cmp    $0x25,%al
  800be4:	75 f3                	jne    800bd9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800be6:	90                   	nop
		}
	}
  800be7:	e9 47 fc ff ff       	jmp    800833 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfd:	83 c0 04             	add    $0x4,%eax
  800c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	ff 75 f4             	pushl  -0xc(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 16 fc ff ff       	call   80082b <vprintfmt>
  800c15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c18:	90                   	nop
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8b 40 08             	mov    0x8(%eax),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8b 10                	mov    (%eax),%edx
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8b 40 04             	mov    0x4(%eax),%eax
  800c38:	39 c2                	cmp    %eax,%edx
  800c3a:	73 12                	jae    800c4e <sprintputch+0x33>
		*b->buf++ = ch;
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8b 00                	mov    (%eax),%eax
  800c41:	8d 48 01             	lea    0x1(%eax),%ecx
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	89 0a                	mov    %ecx,(%edx)
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	88 10                	mov    %dl,(%eax)
}
  800c4e:	90                   	nop
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	01 d0                	add    %edx,%eax
  800c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c76:	74 06                	je     800c7e <vsnprintf+0x2d>
  800c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7c:	7f 07                	jg     800c85 <vsnprintf+0x34>
		return -E_INVAL;
  800c7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c83:	eb 20                	jmp    800ca5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c85:	ff 75 14             	pushl  0x14(%ebp)
  800c88:	ff 75 10             	pushl  0x10(%ebp)
  800c8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	68 1b 0c 80 00       	push   $0x800c1b
  800c94:	e8 92 fb ff ff       	call   80082b <vprintfmt>
  800c99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cad:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb0:	83 c0 04             	add    $0x4,%eax
  800cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbc:	50                   	push   %eax
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 89 ff ff ff       	call   800c51 <vsnprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
  800ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce0:	eb 06                	jmp    800ce8 <strlen+0x15>
		n++;
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	75 f1                	jne    800ce2 <strlen+0xf>
		n++;
	return n;
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d03:	eb 09                	jmp    800d0e <strnlen+0x18>
		n++;
  800d05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d08:	ff 45 08             	incl   0x8(%ebp)
  800d0b:	ff 4d 0c             	decl   0xc(%ebp)
  800d0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d12:	74 09                	je     800d1d <strnlen+0x27>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	75 e8                	jne    800d05 <strnlen+0xf>
		n++;
	return n;
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d2e:	90                   	nop
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 08             	mov    %edx,0x8(%ebp)
  800d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d41:	8a 12                	mov    (%edx),%dl
  800d43:	88 10                	mov    %dl,(%eax)
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 e4                	jne    800d2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d63:	eb 1f                	jmp    800d84 <strncpy+0x34>
		*dst++ = *src;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8d 50 01             	lea    0x1(%eax),%edx
  800d6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	8a 12                	mov    (%edx),%dl
  800d73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 03                	je     800d81 <strncpy+0x31>
			src++;
  800d7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d81:	ff 45 fc             	incl   -0x4(%ebp)
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d8a:	72 d9                	jb     800d65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 30                	je     800dd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da3:	eb 16                	jmp    800dbb <strlcpy+0x2a>
			*dst++ = *src++;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 08             	mov    %edx,0x8(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dbb:	ff 4d 10             	decl   0x10(%ebp)
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	74 09                	je     800dcd <strlcpy+0x3c>
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	75 d8                	jne    800da5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800de2:	eb 06                	jmp    800dea <strcmp+0xb>
		p++, q++;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 0e                	je     800e01 <strcmp+0x22>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 10                	mov    (%eax),%dl
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	38 c2                	cmp    %al,%dl
  800dff:	74 e3                	je     800de4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	0f b6 d0             	movzbl %al,%edx
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	0f b6 c0             	movzbl %al,%eax
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 d0                	mov    %edx,%eax
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e1a:	eb 09                	jmp    800e25 <strncmp+0xe>
		n--, p++, q++;
  800e1c:	ff 4d 10             	decl   0x10(%ebp)
  800e1f:	ff 45 08             	incl   0x8(%ebp)
  800e22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 17                	je     800e42 <strncmp+0x2b>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	84 c0                	test   %al,%al
  800e32:	74 0e                	je     800e42 <strncmp+0x2b>
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 10                	mov    (%eax),%dl
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	38 c2                	cmp    %al,%dl
  800e40:	74 da                	je     800e1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	75 07                	jne    800e4f <strncmp+0x38>
		return 0;
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	eb 14                	jmp    800e63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	0f b6 d0             	movzbl %al,%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 c0             	movzbl %al,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 d0                	mov    %edx,%eax
}
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 04             	sub    $0x4,%esp
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e71:	eb 12                	jmp    800e85 <strchr+0x20>
		if (*s == c)
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7b:	75 05                	jne    800e82 <strchr+0x1d>
			return (char *) s;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	eb 11                	jmp    800e93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e5                	jne    800e73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 04             	sub    $0x4,%esp
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea1:	eb 0d                	jmp    800eb0 <strfind+0x1b>
		if (*s == c)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eab:	74 0e                	je     800ebb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ead:	ff 45 08             	incl   0x8(%ebp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 ea                	jne    800ea3 <strfind+0xe>
  800eb9:	eb 01                	jmp    800ebc <strfind+0x27>
		if (*s == c)
			break;
  800ebb:	90                   	nop
	return (char *) s;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ed3:	eb 0e                	jmp    800ee3 <memset+0x22>
		*p++ = c;
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	8d 50 01             	lea    0x1(%eax),%edx
  800edb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ee3:	ff 4d f8             	decl   -0x8(%ebp)
  800ee6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eea:	79 e9                	jns    800ed5 <memset+0x14>
		*p++ = c;

	return v;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f03:	eb 16                	jmp    800f1b <memcpy+0x2a>
		*d++ = *s++;
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	8d 50 01             	lea    0x1(%eax),%edx
  800f0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f17:	8a 12                	mov    (%edx),%dl
  800f19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 dd                	jne    800f05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	73 50                	jae    800f97 <memmove+0x6a>
  800f47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	01 d0                	add    %edx,%eax
  800f4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f52:	76 43                	jbe    800f97 <memmove+0x6a>
		s += n;
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f60:	eb 10                	jmp    800f72 <memmove+0x45>
			*--d = *--s;
  800f62:	ff 4d f8             	decl   -0x8(%ebp)
  800f65:	ff 4d fc             	decl   -0x4(%ebp)
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6b:	8a 10                	mov    (%eax),%dl
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 e3                	jne    800f62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f7f:	eb 23                	jmp    800fa4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f84:	8d 50 01             	lea    0x1(%eax),%edx
  800f87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f93:	8a 12                	mov    (%edx),%dl
  800f95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 dd                	jne    800f81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fbb:	eb 2a                	jmp    800fe7 <memcmp+0x3e>
		if (*s1 != *s2)
  800fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc0:	8a 10                	mov    (%eax),%dl
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	38 c2                	cmp    %al,%dl
  800fc9:	74 16                	je     800fe1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 d0             	movzbl %al,%edx
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
  800fdf:	eb 18                	jmp    800ff9 <memcmp+0x50>
		s1++, s2++;
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 c9                	jne    800fbd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80100c:	eb 15                	jmp    801023 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f b6 d0             	movzbl %al,%edx
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	0f b6 c0             	movzbl %al,%eax
  80101c:	39 c2                	cmp    %eax,%edx
  80101e:	74 0d                	je     80102d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801020:	ff 45 08             	incl   0x8(%ebp)
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801029:	72 e3                	jb     80100e <memfind+0x13>
  80102b:	eb 01                	jmp    80102e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80102d:	90                   	nop
	return (void *) s;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801040:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801047:	eb 03                	jmp    80104c <strtol+0x19>
		s++;
  801049:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	3c 20                	cmp    $0x20,%al
  801053:	74 f4                	je     801049 <strtol+0x16>
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	3c 09                	cmp    $0x9,%al
  80105c:	74 eb                	je     801049 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	3c 2b                	cmp    $0x2b,%al
  801065:	75 05                	jne    80106c <strtol+0x39>
		s++;
  801067:	ff 45 08             	incl   0x8(%ebp)
  80106a:	eb 13                	jmp    80107f <strtol+0x4c>
	else if (*s == '-')
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 2d                	cmp    $0x2d,%al
  801073:	75 0a                	jne    80107f <strtol+0x4c>
		s++, neg = 1;
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80107f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801083:	74 06                	je     80108b <strtol+0x58>
  801085:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801089:	75 20                	jne    8010ab <strtol+0x78>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 30                	cmp    $0x30,%al
  801092:	75 17                	jne    8010ab <strtol+0x78>
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	40                   	inc    %eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 78                	cmp    $0x78,%al
  80109c:	75 0d                	jne    8010ab <strtol+0x78>
		s += 2, base = 16;
  80109e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010a2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010a9:	eb 28                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010af:	75 15                	jne    8010c6 <strtol+0x93>
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 30                	cmp    $0x30,%al
  8010b8:	75 0c                	jne    8010c6 <strtol+0x93>
		s++, base = 8;
  8010ba:	ff 45 08             	incl   0x8(%ebp)
  8010bd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010c4:	eb 0d                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0)
  8010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ca:	75 07                	jne    8010d3 <strtol+0xa0>
		base = 10;
  8010cc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2f                	cmp    $0x2f,%al
  8010da:	7e 19                	jle    8010f5 <strtol+0xc2>
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 39                	cmp    $0x39,%al
  8010e3:	7f 10                	jg     8010f5 <strtol+0xc2>
			dig = *s - '0';
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	0f be c0             	movsbl %al,%eax
  8010ed:	83 e8 30             	sub    $0x30,%eax
  8010f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f3:	eb 42                	jmp    801137 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 60                	cmp    $0x60,%al
  8010fc:	7e 19                	jle    801117 <strtol+0xe4>
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 7a                	cmp    $0x7a,%al
  801105:	7f 10                	jg     801117 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f be c0             	movsbl %al,%eax
  80110f:	83 e8 57             	sub    $0x57,%eax
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801115:	eb 20                	jmp    801137 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 40                	cmp    $0x40,%al
  80111e:	7e 39                	jle    801159 <strtol+0x126>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 5a                	cmp    $0x5a,%al
  801127:	7f 30                	jg     801159 <strtol+0x126>
			dig = *s - 'A' + 10;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	0f be c0             	movsbl %al,%eax
  801131:	83 e8 37             	sub    $0x37,%eax
  801134:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80113d:	7d 19                	jge    801158 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80113f:	ff 45 08             	incl   0x8(%ebp)
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	0f af 45 10          	imul   0x10(%ebp),%eax
  801149:	89 c2                	mov    %eax,%edx
  80114b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801153:	e9 7b ff ff ff       	jmp    8010d3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801158:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801159:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115d:	74 08                	je     801167 <strtol+0x134>
		*endptr = (char *) s;
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	8b 55 08             	mov    0x8(%ebp),%edx
  801165:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801167:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80116b:	74 07                	je     801174 <strtol+0x141>
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	f7 d8                	neg    %eax
  801172:	eb 03                	jmp    801177 <strtol+0x144>
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <ltostr>:

void
ltostr(long value, char *str)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801186:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80118d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801191:	79 13                	jns    8011a6 <ltostr+0x2d>
	{
		neg = 1;
  801193:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011a0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011a3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ae:	99                   	cltd   
  8011af:	f7 f9                	idiv   %ecx
  8011b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011c7:	83 c2 30             	add    $0x30,%edx
  8011ca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011d4:	f7 e9                	imul   %ecx
  8011d6:	c1 fa 02             	sar    $0x2,%edx
  8011d9:	89 c8                	mov    %ecx,%eax
  8011db:	c1 f8 1f             	sar    $0x1f,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ed:	f7 e9                	imul   %ecx
  8011ef:	c1 fa 02             	sar    $0x2,%edx
  8011f2:	89 c8                	mov    %ecx,%eax
  8011f4:	c1 f8 1f             	sar    $0x1f,%eax
  8011f7:	29 c2                	sub    %eax,%edx
  8011f9:	89 d0                	mov    %edx,%eax
  8011fb:	c1 e0 02             	shl    $0x2,%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	01 c0                	add    %eax,%eax
  801202:	29 c1                	sub    %eax,%ecx
  801204:	89 ca                	mov    %ecx,%edx
  801206:	85 d2                	test   %edx,%edx
  801208:	75 9c                	jne    8011a6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80120a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	48                   	dec    %eax
  801215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801218:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121c:	74 3d                	je     80125b <ltostr+0xe2>
		start = 1 ;
  80121e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801225:	eb 34                	jmp    80125b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 c2                	add    %eax,%edx
  80123c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 c8                	add    %ecx,%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 c2                	add    %eax,%edx
  801250:	8a 45 eb             	mov    -0x15(%ebp),%al
  801253:	88 02                	mov    %al,(%edx)
		start++ ;
  801255:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801258:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801261:	7c c4                	jl     801227 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801263:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80126e:	90                   	nop
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801277:	ff 75 08             	pushl  0x8(%ebp)
  80127a:	e8 54 fa ff ff       	call   800cd3 <strlen>
  80127f:	83 c4 04             	add    $0x4,%esp
  801282:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	e8 46 fa ff ff       	call   800cd3 <strlen>
  80128d:	83 c4 04             	add    $0x4,%esp
  801290:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80129a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a1:	eb 17                	jmp    8012ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	01 c2                	add    %eax,%edx
  8012ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	01 c8                	add    %ecx,%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012b7:	ff 45 fc             	incl   -0x4(%ebp)
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c0:	7c e1                	jl     8012a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d0:	eb 1f                	jmp    8012f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 c2                	add    %eax,%edx
  8012e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e8:	01 c8                	add    %ecx,%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012ee:	ff 45 f8             	incl   -0x8(%ebp)
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f7:	7c d9                	jl     8012d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 d0                	add    %edx,%eax
  801301:	c6 00 00             	movb   $0x0,(%eax)
}
  801304:	90                   	nop
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801313:	8b 45 14             	mov    0x14(%ebp),%eax
  801316:	8b 00                	mov    (%eax),%eax
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132a:	eb 0c                	jmp    801338 <strsplit+0x31>
			*string++ = 0;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8d 50 01             	lea    0x1(%eax),%edx
  801332:	89 55 08             	mov    %edx,0x8(%ebp)
  801335:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 18                	je     801359 <strsplit+0x52>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	0f be c0             	movsbl %al,%eax
  801349:	50                   	push   %eax
  80134a:	ff 75 0c             	pushl  0xc(%ebp)
  80134d:	e8 13 fb ff ff       	call   800e65 <strchr>
  801352:	83 c4 08             	add    $0x8,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	75 d3                	jne    80132c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 5a                	je     8013bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	83 f8 0f             	cmp    $0xf,%eax
  80136a:	75 07                	jne    801373 <strsplit+0x6c>
		{
			return 0;
  80136c:	b8 00 00 00 00       	mov    $0x0,%eax
  801371:	eb 66                	jmp    8013d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	8d 48 01             	lea    0x1(%eax),%ecx
  80137b:	8b 55 14             	mov    0x14(%ebp),%edx
  80137e:	89 0a                	mov    %ecx,(%edx)
  801380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	01 c2                	add    %eax,%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801391:	eb 03                	jmp    801396 <strsplit+0x8f>
			string++;
  801393:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	84 c0                	test   %al,%al
  80139d:	74 8b                	je     80132a <strsplit+0x23>
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	0f be c0             	movsbl %al,%eax
  8013a7:	50                   	push   %eax
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	e8 b5 fa ff ff       	call   800e65 <strchr>
  8013b0:	83 c4 08             	add    $0x8,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 dc                	je     801393 <strsplit+0x8c>
			string++;
	}
  8013b7:	e9 6e ff ff ff       	jmp    80132a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	74 1f                	je     801409 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013ea:	e8 1d 00 00 00       	call   80140c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	68 90 3a 80 00       	push   $0x803a90
  8013f7:	e8 55 f2 ff ff       	call   800651 <cprintf>
  8013fc:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013ff:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801406:	00 00 00 
	}
}
  801409:	90                   	nop
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  801412:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801419:	00 00 00 
  80141c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801423:	00 00 00 
  801426:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80142d:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  801430:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801437:	00 00 00 
  80143a:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801441:	00 00 00 
  801444:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80144b:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  80144e:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  801455:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  801458:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  80145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801462:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801467:	2d 00 10 00 00       	sub    $0x1000,%eax
  80146c:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  801471:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801478:	a1 20 41 80 00       	mov    0x804120,%eax
  80147d:	c1 e0 04             	shl    $0x4,%eax
  801480:	89 c2                	mov    %eax,%edx
  801482:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801485:	01 d0                	add    %edx,%eax
  801487:	48                   	dec    %eax
  801488:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80148b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80148e:	ba 00 00 00 00       	mov    $0x0,%edx
  801493:	f7 75 f0             	divl   -0x10(%ebp)
  801496:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801499:	29 d0                	sub    %edx,%eax
  80149b:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  80149e:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  8014a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014ad:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014b2:	83 ec 04             	sub    $0x4,%esp
  8014b5:	6a 06                	push   $0x6
  8014b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ba:	50                   	push   %eax
  8014bb:	e8 b0 05 00 00       	call   801a70 <sys_allocate_chunk>
  8014c0:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014c3:	a1 20 41 80 00       	mov    0x804120,%eax
  8014c8:	83 ec 0c             	sub    $0xc,%esp
  8014cb:	50                   	push   %eax
  8014cc:	e8 25 0c 00 00       	call   8020f6 <initialize_MemBlocksList>
  8014d1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  8014d4:	a1 48 41 80 00       	mov    0x804148,%eax
  8014d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  8014dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014e0:	75 14                	jne    8014f6 <initialize_dyn_block_system+0xea>
  8014e2:	83 ec 04             	sub    $0x4,%esp
  8014e5:	68 b5 3a 80 00       	push   $0x803ab5
  8014ea:	6a 29                	push   $0x29
  8014ec:	68 d3 3a 80 00       	push   $0x803ad3
  8014f1:	e8 a7 ee ff ff       	call   80039d <_panic>
  8014f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	74 10                	je     80150f <initialize_dyn_block_system+0x103>
  8014ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801502:	8b 00                	mov    (%eax),%eax
  801504:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801507:	8b 52 04             	mov    0x4(%edx),%edx
  80150a:	89 50 04             	mov    %edx,0x4(%eax)
  80150d:	eb 0b                	jmp    80151a <initialize_dyn_block_system+0x10e>
  80150f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801512:	8b 40 04             	mov    0x4(%eax),%eax
  801515:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80151a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80151d:	8b 40 04             	mov    0x4(%eax),%eax
  801520:	85 c0                	test   %eax,%eax
  801522:	74 0f                	je     801533 <initialize_dyn_block_system+0x127>
  801524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801527:	8b 40 04             	mov    0x4(%eax),%eax
  80152a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80152d:	8b 12                	mov    (%edx),%edx
  80152f:	89 10                	mov    %edx,(%eax)
  801531:	eb 0a                	jmp    80153d <initialize_dyn_block_system+0x131>
  801533:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801536:	8b 00                	mov    (%eax),%eax
  801538:	a3 48 41 80 00       	mov    %eax,0x804148
  80153d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801540:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801546:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801550:	a1 54 41 80 00       	mov    0x804154,%eax
  801555:	48                   	dec    %eax
  801556:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  80155b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80155e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  801565:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801568:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  80156f:	83 ec 0c             	sub    $0xc,%esp
  801572:	ff 75 e0             	pushl  -0x20(%ebp)
  801575:	e8 b9 14 00 00       	call   802a33 <insert_sorted_with_merge_freeList>
  80157a:	83 c4 10             	add    $0x10,%esp

}
  80157d:	90                   	nop
  80157e:	c9                   	leave  
  80157f:	c3                   	ret    

00801580 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801580:	55                   	push   %ebp
  801581:	89 e5                	mov    %esp,%ebp
  801583:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801586:	e8 50 fe ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  80158b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158f:	75 07                	jne    801598 <malloc+0x18>
  801591:	b8 00 00 00 00       	mov    $0x0,%eax
  801596:	eb 68                	jmp    801600 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801598:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80159f:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a5:	01 d0                	add    %edx,%eax
  8015a7:	48                   	dec    %eax
  8015a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b3:	f7 75 f4             	divl   -0xc(%ebp)
  8015b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b9:	29 d0                	sub    %edx,%eax
  8015bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  8015be:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8015c5:	e8 74 08 00 00       	call   801e3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ca:	85 c0                	test   %eax,%eax
  8015cc:	74 2d                	je     8015fb <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  8015ce:	83 ec 0c             	sub    $0xc,%esp
  8015d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8015d4:	e8 52 0e 00 00       	call   80242b <alloc_block_FF>
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  8015df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8015e3:	74 16                	je     8015fb <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  8015e5:	83 ec 0c             	sub    $0xc,%esp
  8015e8:	ff 75 e8             	pushl  -0x18(%ebp)
  8015eb:	e8 3b 0c 00 00       	call   80222b <insert_sorted_allocList>
  8015f0:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  8015f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015f6:	8b 40 08             	mov    0x8(%eax),%eax
  8015f9:	eb 05                	jmp    801600 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  8015fb:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801608:	8b 45 08             	mov    0x8(%ebp),%eax
  80160b:	83 ec 08             	sub    $0x8,%esp
  80160e:	50                   	push   %eax
  80160f:	68 40 40 80 00       	push   $0x804040
  801614:	e8 ba 0b 00 00       	call   8021d3 <find_block>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  80161f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801622:	8b 40 0c             	mov    0xc(%eax),%eax
  801625:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  801628:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80162c:	0f 84 9f 00 00 00    	je     8016d1 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  801632:	8b 45 08             	mov    0x8(%ebp),%eax
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	ff 75 f0             	pushl  -0x10(%ebp)
  80163b:	50                   	push   %eax
  80163c:	e8 f7 03 00 00       	call   801a38 <sys_free_user_mem>
  801641:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  801644:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801648:	75 14                	jne    80165e <free+0x5c>
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	68 b5 3a 80 00       	push   $0x803ab5
  801652:	6a 6a                	push   $0x6a
  801654:	68 d3 3a 80 00       	push   $0x803ad3
  801659:	e8 3f ed ff ff       	call   80039d <_panic>
  80165e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801661:	8b 00                	mov    (%eax),%eax
  801663:	85 c0                	test   %eax,%eax
  801665:	74 10                	je     801677 <free+0x75>
  801667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80166a:	8b 00                	mov    (%eax),%eax
  80166c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80166f:	8b 52 04             	mov    0x4(%edx),%edx
  801672:	89 50 04             	mov    %edx,0x4(%eax)
  801675:	eb 0b                	jmp    801682 <free+0x80>
  801677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167a:	8b 40 04             	mov    0x4(%eax),%eax
  80167d:	a3 44 40 80 00       	mov    %eax,0x804044
  801682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801685:	8b 40 04             	mov    0x4(%eax),%eax
  801688:	85 c0                	test   %eax,%eax
  80168a:	74 0f                	je     80169b <free+0x99>
  80168c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168f:	8b 40 04             	mov    0x4(%eax),%eax
  801692:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801695:	8b 12                	mov    (%edx),%edx
  801697:	89 10                	mov    %edx,(%eax)
  801699:	eb 0a                	jmp    8016a5 <free+0xa3>
  80169b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169e:	8b 00                	mov    (%eax),%eax
  8016a0:	a3 40 40 80 00       	mov    %eax,0x804040
  8016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016b8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016bd:	48                   	dec    %eax
  8016be:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  8016c3:	83 ec 0c             	sub    $0xc,%esp
  8016c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c9:	e8 65 13 00 00       	call   802a33 <insert_sorted_with_merge_freeList>
  8016ce:	83 c4 10             	add    $0x10,%esp
	}
}
  8016d1:	90                   	nop
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    

008016d4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  8016d4:	55                   	push   %ebp
  8016d5:	89 e5                	mov    %esp,%ebp
  8016d7:	83 ec 28             	sub    $0x28,%esp
  8016da:	8b 45 10             	mov    0x10(%ebp),%eax
  8016dd:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016e0:	e8 f6 fc ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  8016e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016e9:	75 0a                	jne    8016f5 <smalloc+0x21>
  8016eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f0:	e9 af 00 00 00       	jmp    8017a4 <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  8016f5:	e8 44 07 00 00       	call   801e3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016fa:	83 f8 01             	cmp    $0x1,%eax
  8016fd:	0f 85 9c 00 00 00    	jne    80179f <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  801703:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80170a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80170d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	48                   	dec    %eax
  801713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801719:	ba 00 00 00 00       	mov    $0x0,%edx
  80171e:	f7 75 f4             	divl   -0xc(%ebp)
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	29 d0                	sub    %edx,%eax
  801726:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  801729:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  801730:	76 07                	jbe    801739 <smalloc+0x65>
			return NULL;
  801732:	b8 00 00 00 00       	mov    $0x0,%eax
  801737:	eb 6b                	jmp    8017a4 <smalloc+0xd0>
		blk =alloc_block_FF(size);
  801739:	83 ec 0c             	sub    $0xc,%esp
  80173c:	ff 75 0c             	pushl  0xc(%ebp)
  80173f:	e8 e7 0c 00 00       	call   80242b <alloc_block_FF>
  801744:	83 c4 10             	add    $0x10,%esp
  801747:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  80174a:	83 ec 0c             	sub    $0xc,%esp
  80174d:	ff 75 ec             	pushl  -0x14(%ebp)
  801750:	e8 d6 0a 00 00       	call   80222b <insert_sorted_allocList>
  801755:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  801758:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80175c:	75 07                	jne    801765 <smalloc+0x91>
		{
			return NULL;
  80175e:	b8 00 00 00 00       	mov    $0x0,%eax
  801763:	eb 3f                	jmp    8017a4 <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  801765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801768:	8b 40 08             	mov    0x8(%eax),%eax
  80176b:	89 c2                	mov    %eax,%edx
  80176d:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  801771:	52                   	push   %edx
  801772:	50                   	push   %eax
  801773:	ff 75 0c             	pushl  0xc(%ebp)
  801776:	ff 75 08             	pushl  0x8(%ebp)
  801779:	e8 45 04 00 00       	call   801bc3 <sys_createSharedObject>
  80177e:	83 c4 10             	add    $0x10,%esp
  801781:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  801784:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801788:	74 06                	je     801790 <smalloc+0xbc>
  80178a:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  80178e:	75 07                	jne    801797 <smalloc+0xc3>
		{
			return NULL;
  801790:	b8 00 00 00 00       	mov    $0x0,%eax
  801795:	eb 0d                	jmp    8017a4 <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  801797:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80179a:	8b 40 08             	mov    0x8(%eax),%eax
  80179d:	eb 05                	jmp    8017a4 <smalloc+0xd0>
		}
	}
	else
		return NULL;
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017a4:	c9                   	leave  
  8017a5:	c3                   	ret    

008017a6 <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017a6:	55                   	push   %ebp
  8017a7:	89 e5                	mov    %esp,%ebp
  8017a9:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ac:	e8 2a fc ff ff       	call   8013db <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017b1:	83 ec 08             	sub    $0x8,%esp
  8017b4:	ff 75 0c             	pushl  0xc(%ebp)
  8017b7:	ff 75 08             	pushl  0x8(%ebp)
  8017ba:	e8 2e 04 00 00       	call   801bed <sys_getSizeOfSharedObject>
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  8017c5:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  8017c9:	75 0a                	jne    8017d5 <sget+0x2f>
	{
		return NULL;
  8017cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d0:	e9 94 00 00 00       	jmp    801869 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  8017d5:	e8 64 06 00 00       	call   801e3e <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	0f 84 82 00 00 00    	je     801864 <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  8017e2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  8017e9:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f6:	01 d0                	add    %edx,%eax
  8017f8:	48                   	dec    %eax
  8017f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ff:	ba 00 00 00 00       	mov    $0x0,%edx
  801804:	f7 75 ec             	divl   -0x14(%ebp)
  801807:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80180a:	29 d0                	sub    %edx,%eax
  80180c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  80180f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801812:	83 ec 0c             	sub    $0xc,%esp
  801815:	50                   	push   %eax
  801816:	e8 10 0c 00 00       	call   80242b <alloc_block_FF>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801821:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801825:	75 07                	jne    80182e <sget+0x88>
		{
			return NULL;
  801827:	b8 00 00 00 00       	mov    $0x0,%eax
  80182c:	eb 3b                	jmp    801869 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  80182e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801831:	8b 40 08             	mov    0x8(%eax),%eax
  801834:	83 ec 04             	sub    $0x4,%esp
  801837:	50                   	push   %eax
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	ff 75 08             	pushl  0x8(%ebp)
  80183e:	e8 c7 03 00 00       	call   801c0a <sys_getSharedObject>
  801843:	83 c4 10             	add    $0x10,%esp
  801846:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  801849:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  80184d:	74 06                	je     801855 <sget+0xaf>
  80184f:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  801853:	75 07                	jne    80185c <sget+0xb6>
		{
			return NULL;
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
  80185a:	eb 0d                	jmp    801869 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  80185c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185f:	8b 40 08             	mov    0x8(%eax),%eax
  801862:	eb 05                	jmp    801869 <sget+0xc3>
		}
	}
	else
			return NULL;
  801864:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801871:	e8 65 fb ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801876:	83 ec 04             	sub    $0x4,%esp
  801879:	68 e0 3a 80 00       	push   $0x803ae0
  80187e:	68 e1 00 00 00       	push   $0xe1
  801883:	68 d3 3a 80 00       	push   $0x803ad3
  801888:	e8 10 eb ff ff       	call   80039d <_panic>

0080188d <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
  801890:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801893:	83 ec 04             	sub    $0x4,%esp
  801896:	68 08 3b 80 00       	push   $0x803b08
  80189b:	68 f5 00 00 00       	push   $0xf5
  8018a0:	68 d3 3a 80 00       	push   $0x803ad3
  8018a5:	e8 f3 ea ff ff       	call   80039d <_panic>

008018aa <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018b0:	83 ec 04             	sub    $0x4,%esp
  8018b3:	68 2c 3b 80 00       	push   $0x803b2c
  8018b8:	68 00 01 00 00       	push   $0x100
  8018bd:	68 d3 3a 80 00       	push   $0x803ad3
  8018c2:	e8 d6 ea ff ff       	call   80039d <_panic>

008018c7 <shrink>:

}
void shrink(uint32 newSize)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018cd:	83 ec 04             	sub    $0x4,%esp
  8018d0:	68 2c 3b 80 00       	push   $0x803b2c
  8018d5:	68 05 01 00 00       	push   $0x105
  8018da:	68 d3 3a 80 00       	push   $0x803ad3
  8018df:	e8 b9 ea ff ff       	call   80039d <_panic>

008018e4 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ea:	83 ec 04             	sub    $0x4,%esp
  8018ed:	68 2c 3b 80 00       	push   $0x803b2c
  8018f2:	68 0a 01 00 00       	push   $0x10a
  8018f7:	68 d3 3a 80 00       	push   $0x803ad3
  8018fc:	e8 9c ea ff ff       	call   80039d <_panic>

00801901 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	57                   	push   %edi
  801905:	56                   	push   %esi
  801906:	53                   	push   %ebx
  801907:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80190a:	8b 45 08             	mov    0x8(%ebp),%eax
  80190d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801910:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801913:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801916:	8b 7d 18             	mov    0x18(%ebp),%edi
  801919:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80191c:	cd 30                	int    $0x30
  80191e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801921:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	5b                   	pop    %ebx
  801928:	5e                   	pop    %esi
  801929:	5f                   	pop    %edi
  80192a:	5d                   	pop    %ebp
  80192b:	c3                   	ret    

0080192c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80192c:	55                   	push   %ebp
  80192d:	89 e5                	mov    %esp,%ebp
  80192f:	83 ec 04             	sub    $0x4,%esp
  801932:	8b 45 10             	mov    0x10(%ebp),%eax
  801935:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801938:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	52                   	push   %edx
  801944:	ff 75 0c             	pushl  0xc(%ebp)
  801947:	50                   	push   %eax
  801948:	6a 00                	push   $0x0
  80194a:	e8 b2 ff ff ff       	call   801901 <syscall>
  80194f:	83 c4 18             	add    $0x18,%esp
}
  801952:	90                   	nop
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_cgetc>:

int
sys_cgetc(void)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 01                	push   $0x1
  801964:	e8 98 ff ff ff       	call   801901 <syscall>
  801969:	83 c4 18             	add    $0x18,%esp
}
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801971:	8b 55 0c             	mov    0xc(%ebp),%edx
  801974:	8b 45 08             	mov    0x8(%ebp),%eax
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	52                   	push   %edx
  80197e:	50                   	push   %eax
  80197f:	6a 05                	push   $0x5
  801981:	e8 7b ff ff ff       	call   801901 <syscall>
  801986:	83 c4 18             	add    $0x18,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801990:	8b 75 18             	mov    0x18(%ebp),%esi
  801993:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801996:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801999:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199c:	8b 45 08             	mov    0x8(%ebp),%eax
  80199f:	56                   	push   %esi
  8019a0:	53                   	push   %ebx
  8019a1:	51                   	push   %ecx
  8019a2:	52                   	push   %edx
  8019a3:	50                   	push   %eax
  8019a4:	6a 06                	push   $0x6
  8019a6:	e8 56 ff ff ff       	call   801901 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b1:	5b                   	pop    %ebx
  8019b2:	5e                   	pop    %esi
  8019b3:	5d                   	pop    %ebp
  8019b4:	c3                   	ret    

008019b5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019b8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	52                   	push   %edx
  8019c5:	50                   	push   %eax
  8019c6:	6a 07                	push   $0x7
  8019c8:	e8 34 ff ff ff       	call   801901 <syscall>
  8019cd:	83 c4 18             	add    $0x18,%esp
}
  8019d0:	c9                   	leave  
  8019d1:	c3                   	ret    

008019d2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019d2:	55                   	push   %ebp
  8019d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	ff 75 0c             	pushl  0xc(%ebp)
  8019de:	ff 75 08             	pushl  0x8(%ebp)
  8019e1:	6a 08                	push   $0x8
  8019e3:	e8 19 ff ff ff       	call   801901 <syscall>
  8019e8:	83 c4 18             	add    $0x18,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 09                	push   $0x9
  8019fc:	e8 00 ff ff ff       	call   801901 <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 0a                	push   $0xa
  801a15:	e8 e7 fe ff ff       	call   801901 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 0b                	push   $0xb
  801a2e:	e8 ce fe ff ff       	call   801901 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	ff 75 08             	pushl  0x8(%ebp)
  801a47:	6a 0f                	push   $0xf
  801a49:	e8 b3 fe ff ff       	call   801901 <syscall>
  801a4e:	83 c4 18             	add    $0x18,%esp
	return;
  801a51:	90                   	nop
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	ff 75 0c             	pushl  0xc(%ebp)
  801a60:	ff 75 08             	pushl  0x8(%ebp)
  801a63:	6a 10                	push   $0x10
  801a65:	e8 97 fe ff ff       	call   801901 <syscall>
  801a6a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a6d:	90                   	nop
}
  801a6e:	c9                   	leave  
  801a6f:	c3                   	ret    

00801a70 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a70:	55                   	push   %ebp
  801a71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	ff 75 10             	pushl  0x10(%ebp)
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	6a 11                	push   $0x11
  801a82:	e8 7a fe ff ff       	call   801901 <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
	return ;
  801a8a:	90                   	nop
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 0c                	push   $0xc
  801a9c:	e8 60 fe ff ff       	call   801901 <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	ff 75 08             	pushl  0x8(%ebp)
  801ab4:	6a 0d                	push   $0xd
  801ab6:	e8 46 fe ff ff       	call   801901 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 0e                	push   $0xe
  801acf:	e8 2d fe ff ff       	call   801901 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	90                   	nop
  801ad8:	c9                   	leave  
  801ad9:	c3                   	ret    

00801ada <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ada:	55                   	push   %ebp
  801adb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801add:	6a 00                	push   $0x0
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	6a 13                	push   $0x13
  801ae9:	e8 13 fe ff ff       	call   801901 <syscall>
  801aee:	83 c4 18             	add    $0x18,%esp
}
  801af1:	90                   	nop
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 14                	push   $0x14
  801b03:	e8 f9 fd ff ff       	call   801901 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	90                   	nop
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <sys_cputc>:


void
sys_cputc(const char c)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 04             	sub    $0x4,%esp
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b1a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	6a 00                	push   $0x0
  801b24:	6a 00                	push   $0x0
  801b26:	50                   	push   %eax
  801b27:	6a 15                	push   $0x15
  801b29:	e8 d3 fd ff ff       	call   801901 <syscall>
  801b2e:	83 c4 18             	add    $0x18,%esp
}
  801b31:	90                   	nop
  801b32:	c9                   	leave  
  801b33:	c3                   	ret    

00801b34 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 16                	push   $0x16
  801b43:	e8 b9 fd ff ff       	call   801901 <syscall>
  801b48:	83 c4 18             	add    $0x18,%esp
}
  801b4b:	90                   	nop
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	ff 75 0c             	pushl  0xc(%ebp)
  801b5d:	50                   	push   %eax
  801b5e:	6a 17                	push   $0x17
  801b60:	e8 9c fd ff ff       	call   801901 <syscall>
  801b65:	83 c4 18             	add    $0x18,%esp
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	52                   	push   %edx
  801b7a:	50                   	push   %eax
  801b7b:	6a 1a                	push   $0x1a
  801b7d:	e8 7f fd ff ff       	call   801901 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 18                	push   $0x18
  801b9a:	e8 62 fd ff ff       	call   801901 <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	90                   	nop
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	52                   	push   %edx
  801bb5:	50                   	push   %eax
  801bb6:	6a 19                	push   $0x19
  801bb8:	e8 44 fd ff ff       	call   801901 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	90                   	nop
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 04             	sub    $0x4,%esp
  801bc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bcc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bcf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bd2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	6a 00                	push   $0x0
  801bdb:	51                   	push   %ecx
  801bdc:	52                   	push   %edx
  801bdd:	ff 75 0c             	pushl  0xc(%ebp)
  801be0:	50                   	push   %eax
  801be1:	6a 1b                	push   $0x1b
  801be3:	e8 19 fd ff ff       	call   801901 <syscall>
  801be8:	83 c4 18             	add    $0x18,%esp
}
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bf0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	52                   	push   %edx
  801bfd:	50                   	push   %eax
  801bfe:	6a 1c                	push   $0x1c
  801c00:	e8 fc fc ff ff       	call   801901 <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c0d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c13:	8b 45 08             	mov    0x8(%ebp),%eax
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	51                   	push   %ecx
  801c1b:	52                   	push   %edx
  801c1c:	50                   	push   %eax
  801c1d:	6a 1d                	push   $0x1d
  801c1f:	e8 dd fc ff ff       	call   801901 <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	52                   	push   %edx
  801c39:	50                   	push   %eax
  801c3a:	6a 1e                	push   $0x1e
  801c3c:	e8 c0 fc ff ff       	call   801901 <syscall>
  801c41:	83 c4 18             	add    $0x18,%esp
}
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 1f                	push   $0x1f
  801c55:	e8 a7 fc ff ff       	call   801901 <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	6a 00                	push   $0x0
  801c67:	ff 75 14             	pushl  0x14(%ebp)
  801c6a:	ff 75 10             	pushl  0x10(%ebp)
  801c6d:	ff 75 0c             	pushl  0xc(%ebp)
  801c70:	50                   	push   %eax
  801c71:	6a 20                	push   $0x20
  801c73:	e8 89 fc ff ff       	call   801901 <syscall>
  801c78:	83 c4 18             	add    $0x18,%esp
}
  801c7b:	c9                   	leave  
  801c7c:	c3                   	ret    

00801c7d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	50                   	push   %eax
  801c8c:	6a 21                	push   $0x21
  801c8e:	e8 6e fc ff ff       	call   801901 <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	90                   	nop
  801c97:	c9                   	leave  
  801c98:	c3                   	ret    

00801c99 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c99:	55                   	push   %ebp
  801c9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	50                   	push   %eax
  801ca8:	6a 22                	push   $0x22
  801caa:	e8 52 fc ff ff       	call   801901 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 02                	push   $0x2
  801cc3:	e8 39 fc ff ff       	call   801901 <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 03                	push   $0x3
  801cdc:	e8 20 fc ff ff       	call   801901 <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 04                	push   $0x4
  801cf5:	e8 07 fc ff ff       	call   801901 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_exit_env>:


void sys_exit_env(void)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 23                	push   $0x23
  801d0e:	e8 ee fb ff ff       	call   801901 <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	90                   	nop
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d1f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d22:	8d 50 04             	lea    0x4(%eax),%edx
  801d25:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	52                   	push   %edx
  801d2f:	50                   	push   %eax
  801d30:	6a 24                	push   $0x24
  801d32:	e8 ca fb ff ff       	call   801901 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return result;
  801d3a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d40:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d43:	89 01                	mov    %eax,(%ecx)
  801d45:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d48:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4b:	c9                   	leave  
  801d4c:	c2 04 00             	ret    $0x4

00801d4f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	ff 75 10             	pushl  0x10(%ebp)
  801d59:	ff 75 0c             	pushl  0xc(%ebp)
  801d5c:	ff 75 08             	pushl  0x8(%ebp)
  801d5f:	6a 12                	push   $0x12
  801d61:	e8 9b fb ff ff       	call   801901 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
	return ;
  801d69:	90                   	nop
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <sys_rcr2>:
uint32 sys_rcr2()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 25                	push   $0x25
  801d7b:	e8 81 fb ff ff       	call   801901 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
  801d88:	83 ec 04             	sub    $0x4,%esp
  801d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d91:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	50                   	push   %eax
  801d9e:	6a 26                	push   $0x26
  801da0:	e8 5c fb ff ff       	call   801901 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
	return ;
  801da8:	90                   	nop
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <rsttst>:
void rsttst()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 28                	push   $0x28
  801dba:	e8 42 fb ff ff       	call   801901 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc2:	90                   	nop
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 04             	sub    $0x4,%esp
  801dcb:	8b 45 14             	mov    0x14(%ebp),%eax
  801dce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dd1:	8b 55 18             	mov    0x18(%ebp),%edx
  801dd4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dd8:	52                   	push   %edx
  801dd9:	50                   	push   %eax
  801dda:	ff 75 10             	pushl  0x10(%ebp)
  801ddd:	ff 75 0c             	pushl  0xc(%ebp)
  801de0:	ff 75 08             	pushl  0x8(%ebp)
  801de3:	6a 27                	push   $0x27
  801de5:	e8 17 fb ff ff       	call   801901 <syscall>
  801dea:	83 c4 18             	add    $0x18,%esp
	return ;
  801ded:	90                   	nop
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <chktst>:
void chktst(uint32 n)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	ff 75 08             	pushl  0x8(%ebp)
  801dfe:	6a 29                	push   $0x29
  801e00:	e8 fc fa ff ff       	call   801901 <syscall>
  801e05:	83 c4 18             	add    $0x18,%esp
	return ;
  801e08:	90                   	nop
}
  801e09:	c9                   	leave  
  801e0a:	c3                   	ret    

00801e0b <inctst>:

void inctst()
{
  801e0b:	55                   	push   %ebp
  801e0c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 2a                	push   $0x2a
  801e1a:	e8 e2 fa ff ff       	call   801901 <syscall>
  801e1f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e22:	90                   	nop
}
  801e23:	c9                   	leave  
  801e24:	c3                   	ret    

00801e25 <gettst>:
uint32 gettst()
{
  801e25:	55                   	push   %ebp
  801e26:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e28:	6a 00                	push   $0x0
  801e2a:	6a 00                	push   $0x0
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 2b                	push   $0x2b
  801e34:	e8 c8 fa ff ff       	call   801901 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 2c                	push   $0x2c
  801e50:	e8 ac fa ff ff       	call   801901 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
  801e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e5b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e5f:	75 07                	jne    801e68 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e61:	b8 01 00 00 00       	mov    $0x1,%eax
  801e66:	eb 05                	jmp    801e6d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 2c                	push   $0x2c
  801e81:	e8 7b fa ff ff       	call   801901 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
  801e89:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e8c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e90:	75 07                	jne    801e99 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e92:	b8 01 00 00 00       	mov    $0x1,%eax
  801e97:	eb 05                	jmp    801e9e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 2c                	push   $0x2c
  801eb2:	e8 4a fa ff ff       	call   801901 <syscall>
  801eb7:	83 c4 18             	add    $0x18,%esp
  801eba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ebd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ec1:	75 07                	jne    801eca <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ec3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec8:	eb 05                	jmp    801ecf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ecf:	c9                   	leave  
  801ed0:	c3                   	ret    

00801ed1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 2c                	push   $0x2c
  801ee3:	e8 19 fa ff ff       	call   801901 <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
  801eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eee:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ef2:	75 07                	jne    801efb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ef4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef9:	eb 05                	jmp    801f00 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801efb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f00:	c9                   	leave  
  801f01:	c3                   	ret    

00801f02 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f02:	55                   	push   %ebp
  801f03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	ff 75 08             	pushl  0x8(%ebp)
  801f10:	6a 2d                	push   $0x2d
  801f12:	e8 ea f9 ff ff       	call   801901 <syscall>
  801f17:	83 c4 18             	add    $0x18,%esp
	return ;
  801f1a:	90                   	nop
}
  801f1b:	c9                   	leave  
  801f1c:	c3                   	ret    

00801f1d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f21:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f24:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f2d:	6a 00                	push   $0x0
  801f2f:	53                   	push   %ebx
  801f30:	51                   	push   %ecx
  801f31:	52                   	push   %edx
  801f32:	50                   	push   %eax
  801f33:	6a 2e                	push   $0x2e
  801f35:	e8 c7 f9 ff ff       	call   801901 <syscall>
  801f3a:	83 c4 18             	add    $0x18,%esp
}
  801f3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	52                   	push   %edx
  801f52:	50                   	push   %eax
  801f53:	6a 2f                	push   $0x2f
  801f55:	e8 a7 f9 ff ff       	call   801901 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	68 3c 3b 80 00       	push   $0x803b3c
  801f6d:	e8 df e6 ff ff       	call   800651 <cprintf>
  801f72:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f75:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f7c:	83 ec 0c             	sub    $0xc,%esp
  801f7f:	68 68 3b 80 00       	push   $0x803b68
  801f84:	e8 c8 e6 ff ff       	call   800651 <cprintf>
  801f89:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f8c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f90:	a1 38 41 80 00       	mov    0x804138,%eax
  801f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f98:	eb 56                	jmp    801ff0 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f9e:	74 1c                	je     801fbc <print_mem_block_lists+0x5d>
  801fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa3:	8b 50 08             	mov    0x8(%eax),%edx
  801fa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa9:	8b 48 08             	mov    0x8(%eax),%ecx
  801fac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801faf:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb2:	01 c8                	add    %ecx,%eax
  801fb4:	39 c2                	cmp    %eax,%edx
  801fb6:	73 04                	jae    801fbc <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fb8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbf:	8b 50 08             	mov    0x8(%eax),%edx
  801fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc8:	01 c2                	add    %eax,%edx
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	8b 40 08             	mov    0x8(%eax),%eax
  801fd0:	83 ec 04             	sub    $0x4,%esp
  801fd3:	52                   	push   %edx
  801fd4:	50                   	push   %eax
  801fd5:	68 7d 3b 80 00       	push   $0x803b7d
  801fda:	e8 72 e6 ff ff       	call   800651 <cprintf>
  801fdf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fe8:	a1 40 41 80 00       	mov    0x804140,%eax
  801fed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ff0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff4:	74 07                	je     801ffd <print_mem_block_lists+0x9e>
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 00                	mov    (%eax),%eax
  801ffb:	eb 05                	jmp    802002 <print_mem_block_lists+0xa3>
  801ffd:	b8 00 00 00 00       	mov    $0x0,%eax
  802002:	a3 40 41 80 00       	mov    %eax,0x804140
  802007:	a1 40 41 80 00       	mov    0x804140,%eax
  80200c:	85 c0                	test   %eax,%eax
  80200e:	75 8a                	jne    801f9a <print_mem_block_lists+0x3b>
  802010:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802014:	75 84                	jne    801f9a <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802016:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80201a:	75 10                	jne    80202c <print_mem_block_lists+0xcd>
  80201c:	83 ec 0c             	sub    $0xc,%esp
  80201f:	68 8c 3b 80 00       	push   $0x803b8c
  802024:	e8 28 e6 ff ff       	call   800651 <cprintf>
  802029:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80202c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802033:	83 ec 0c             	sub    $0xc,%esp
  802036:	68 b0 3b 80 00       	push   $0x803bb0
  80203b:	e8 11 e6 ff ff       	call   800651 <cprintf>
  802040:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802043:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802047:	a1 40 40 80 00       	mov    0x804040,%eax
  80204c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80204f:	eb 56                	jmp    8020a7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802051:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802055:	74 1c                	je     802073 <print_mem_block_lists+0x114>
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	8b 50 08             	mov    0x8(%eax),%edx
  80205d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802060:	8b 48 08             	mov    0x8(%eax),%ecx
  802063:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802066:	8b 40 0c             	mov    0xc(%eax),%eax
  802069:	01 c8                	add    %ecx,%eax
  80206b:	39 c2                	cmp    %eax,%edx
  80206d:	73 04                	jae    802073 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80206f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802073:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802076:	8b 50 08             	mov    0x8(%eax),%edx
  802079:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80207c:	8b 40 0c             	mov    0xc(%eax),%eax
  80207f:	01 c2                	add    %eax,%edx
  802081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802084:	8b 40 08             	mov    0x8(%eax),%eax
  802087:	83 ec 04             	sub    $0x4,%esp
  80208a:	52                   	push   %edx
  80208b:	50                   	push   %eax
  80208c:	68 7d 3b 80 00       	push   $0x803b7d
  802091:	e8 bb e5 ff ff       	call   800651 <cprintf>
  802096:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80209f:	a1 48 40 80 00       	mov    0x804048,%eax
  8020a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ab:	74 07                	je     8020b4 <print_mem_block_lists+0x155>
  8020ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b0:	8b 00                	mov    (%eax),%eax
  8020b2:	eb 05                	jmp    8020b9 <print_mem_block_lists+0x15a>
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b9:	a3 48 40 80 00       	mov    %eax,0x804048
  8020be:	a1 48 40 80 00       	mov    0x804048,%eax
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	75 8a                	jne    802051 <print_mem_block_lists+0xf2>
  8020c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020cb:	75 84                	jne    802051 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020cd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020d1:	75 10                	jne    8020e3 <print_mem_block_lists+0x184>
  8020d3:	83 ec 0c             	sub    $0xc,%esp
  8020d6:	68 c8 3b 80 00       	push   $0x803bc8
  8020db:	e8 71 e5 ff ff       	call   800651 <cprintf>
  8020e0:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020e3:	83 ec 0c             	sub    $0xc,%esp
  8020e6:	68 3c 3b 80 00       	push   $0x803b3c
  8020eb:	e8 61 e5 ff ff       	call   800651 <cprintf>
  8020f0:	83 c4 10             	add    $0x10,%esp

}
  8020f3:	90                   	nop
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020fc:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802103:	00 00 00 
  802106:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80210d:	00 00 00 
  802110:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802117:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  80211a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802121:	e9 9e 00 00 00       	jmp    8021c4 <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  802126:	a1 50 40 80 00       	mov    0x804050,%eax
  80212b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212e:	c1 e2 04             	shl    $0x4,%edx
  802131:	01 d0                	add    %edx,%eax
  802133:	85 c0                	test   %eax,%eax
  802135:	75 14                	jne    80214b <initialize_MemBlocksList+0x55>
  802137:	83 ec 04             	sub    $0x4,%esp
  80213a:	68 f0 3b 80 00       	push   $0x803bf0
  80213f:	6a 42                	push   $0x42
  802141:	68 13 3c 80 00       	push   $0x803c13
  802146:	e8 52 e2 ff ff       	call   80039d <_panic>
  80214b:	a1 50 40 80 00       	mov    0x804050,%eax
  802150:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802153:	c1 e2 04             	shl    $0x4,%edx
  802156:	01 d0                	add    %edx,%eax
  802158:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80215e:	89 10                	mov    %edx,(%eax)
  802160:	8b 00                	mov    (%eax),%eax
  802162:	85 c0                	test   %eax,%eax
  802164:	74 18                	je     80217e <initialize_MemBlocksList+0x88>
  802166:	a1 48 41 80 00       	mov    0x804148,%eax
  80216b:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802171:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802174:	c1 e1 04             	shl    $0x4,%ecx
  802177:	01 ca                	add    %ecx,%edx
  802179:	89 50 04             	mov    %edx,0x4(%eax)
  80217c:	eb 12                	jmp    802190 <initialize_MemBlocksList+0x9a>
  80217e:	a1 50 40 80 00       	mov    0x804050,%eax
  802183:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802186:	c1 e2 04             	shl    $0x4,%edx
  802189:	01 d0                	add    %edx,%eax
  80218b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802190:	a1 50 40 80 00       	mov    0x804050,%eax
  802195:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802198:	c1 e2 04             	shl    $0x4,%edx
  80219b:	01 d0                	add    %edx,%eax
  80219d:	a3 48 41 80 00       	mov    %eax,0x804148
  8021a2:	a1 50 40 80 00       	mov    0x804050,%eax
  8021a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021aa:	c1 e2 04             	shl    $0x4,%edx
  8021ad:	01 d0                	add    %edx,%eax
  8021af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021b6:	a1 54 41 80 00       	mov    0x804154,%eax
  8021bb:	40                   	inc    %eax
  8021bc:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  8021c1:	ff 45 f4             	incl   -0xc(%ebp)
  8021c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021ca:	0f 82 56 ff ff ff    	jb     802126 <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  8021d0:	90                   	nop
  8021d1:	c9                   	leave  
  8021d2:	c3                   	ret    

008021d3 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021d3:	55                   	push   %ebp
  8021d4:	89 e5                	mov    %esp,%ebp
  8021d6:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dc:	8b 00                	mov    (%eax),%eax
  8021de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021e1:	eb 19                	jmp    8021fc <find_block+0x29>
	{
		if(blk->sva==va)
  8021e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e6:	8b 40 08             	mov    0x8(%eax),%eax
  8021e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021ec:	75 05                	jne    8021f3 <find_block+0x20>
			return (blk);
  8021ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021f1:	eb 36                	jmp    802229 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	8b 40 08             	mov    0x8(%eax),%eax
  8021f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  8021fc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802200:	74 07                	je     802209 <find_block+0x36>
  802202:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802205:	8b 00                	mov    (%eax),%eax
  802207:	eb 05                	jmp    80220e <find_block+0x3b>
  802209:	b8 00 00 00 00       	mov    $0x0,%eax
  80220e:	8b 55 08             	mov    0x8(%ebp),%edx
  802211:	89 42 08             	mov    %eax,0x8(%edx)
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	8b 40 08             	mov    0x8(%eax),%eax
  80221a:	85 c0                	test   %eax,%eax
  80221c:	75 c5                	jne    8021e3 <find_block+0x10>
  80221e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802222:	75 bf                	jne    8021e3 <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  802224:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802229:	c9                   	leave  
  80222a:	c3                   	ret    

0080222b <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80222b:	55                   	push   %ebp
  80222c:	89 e5                	mov    %esp,%ebp
  80222e:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  802231:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802236:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802239:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  802240:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802243:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802246:	75 65                	jne    8022ad <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802248:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80224c:	75 14                	jne    802262 <insert_sorted_allocList+0x37>
  80224e:	83 ec 04             	sub    $0x4,%esp
  802251:	68 f0 3b 80 00       	push   $0x803bf0
  802256:	6a 5c                	push   $0x5c
  802258:	68 13 3c 80 00       	push   $0x803c13
  80225d:	e8 3b e1 ff ff       	call   80039d <_panic>
  802262:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	89 10                	mov    %edx,(%eax)
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	8b 00                	mov    (%eax),%eax
  802272:	85 c0                	test   %eax,%eax
  802274:	74 0d                	je     802283 <insert_sorted_allocList+0x58>
  802276:	a1 40 40 80 00       	mov    0x804040,%eax
  80227b:	8b 55 08             	mov    0x8(%ebp),%edx
  80227e:	89 50 04             	mov    %edx,0x4(%eax)
  802281:	eb 08                	jmp    80228b <insert_sorted_allocList+0x60>
  802283:	8b 45 08             	mov    0x8(%ebp),%eax
  802286:	a3 44 40 80 00       	mov    %eax,0x804044
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	a3 40 40 80 00       	mov    %eax,0x804040
  802293:	8b 45 08             	mov    0x8(%ebp),%eax
  802296:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80229d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a2:	40                   	inc    %eax
  8022a3:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022a8:	e9 7b 01 00 00       	jmp    802428 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  8022ad:	a1 44 40 80 00       	mov    0x804044,%eax
  8022b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  8022b5:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  8022bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c0:	8b 50 08             	mov    0x8(%eax),%edx
  8022c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8022c6:	8b 40 08             	mov    0x8(%eax),%eax
  8022c9:	39 c2                	cmp    %eax,%edx
  8022cb:	76 65                	jbe    802332 <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  8022cd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d1:	75 14                	jne    8022e7 <insert_sorted_allocList+0xbc>
  8022d3:	83 ec 04             	sub    $0x4,%esp
  8022d6:	68 2c 3c 80 00       	push   $0x803c2c
  8022db:	6a 64                	push   $0x64
  8022dd:	68 13 3c 80 00       	push   $0x803c13
  8022e2:	e8 b6 e0 ff ff       	call   80039d <_panic>
  8022e7:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f0:	89 50 04             	mov    %edx,0x4(%eax)
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	8b 40 04             	mov    0x4(%eax),%eax
  8022f9:	85 c0                	test   %eax,%eax
  8022fb:	74 0c                	je     802309 <insert_sorted_allocList+0xde>
  8022fd:	a1 44 40 80 00       	mov    0x804044,%eax
  802302:	8b 55 08             	mov    0x8(%ebp),%edx
  802305:	89 10                	mov    %edx,(%eax)
  802307:	eb 08                	jmp    802311 <insert_sorted_allocList+0xe6>
  802309:	8b 45 08             	mov    0x8(%ebp),%eax
  80230c:	a3 40 40 80 00       	mov    %eax,0x804040
  802311:	8b 45 08             	mov    0x8(%ebp),%eax
  802314:	a3 44 40 80 00       	mov    %eax,0x804044
  802319:	8b 45 08             	mov    0x8(%ebp),%eax
  80231c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802322:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802327:	40                   	inc    %eax
  802328:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80232d:	e9 f6 00 00 00       	jmp    802428 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  802332:	8b 45 08             	mov    0x8(%ebp),%eax
  802335:	8b 50 08             	mov    0x8(%eax),%edx
  802338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80233b:	8b 40 08             	mov    0x8(%eax),%eax
  80233e:	39 c2                	cmp    %eax,%edx
  802340:	73 65                	jae    8023a7 <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  802342:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802346:	75 14                	jne    80235c <insert_sorted_allocList+0x131>
  802348:	83 ec 04             	sub    $0x4,%esp
  80234b:	68 f0 3b 80 00       	push   $0x803bf0
  802350:	6a 68                	push   $0x68
  802352:	68 13 3c 80 00       	push   $0x803c13
  802357:	e8 41 e0 ff ff       	call   80039d <_panic>
  80235c:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	89 10                	mov    %edx,(%eax)
  802367:	8b 45 08             	mov    0x8(%ebp),%eax
  80236a:	8b 00                	mov    (%eax),%eax
  80236c:	85 c0                	test   %eax,%eax
  80236e:	74 0d                	je     80237d <insert_sorted_allocList+0x152>
  802370:	a1 40 40 80 00       	mov    0x804040,%eax
  802375:	8b 55 08             	mov    0x8(%ebp),%edx
  802378:	89 50 04             	mov    %edx,0x4(%eax)
  80237b:	eb 08                	jmp    802385 <insert_sorted_allocList+0x15a>
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	a3 44 40 80 00       	mov    %eax,0x804044
  802385:	8b 45 08             	mov    0x8(%ebp),%eax
  802388:	a3 40 40 80 00       	mov    %eax,0x804040
  80238d:	8b 45 08             	mov    0x8(%ebp),%eax
  802390:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802397:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80239c:	40                   	inc    %eax
  80239d:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8023a2:	e9 81 00 00 00       	jmp    802428 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8023a7:	a1 40 40 80 00       	mov    0x804040,%eax
  8023ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023af:	eb 51                	jmp    802402 <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  8023b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b4:	8b 50 08             	mov    0x8(%eax),%edx
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ba:	8b 40 08             	mov    0x8(%eax),%eax
  8023bd:	39 c2                	cmp    %eax,%edx
  8023bf:	73 39                	jae    8023fa <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  8023c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c4:	8b 40 04             	mov    0x4(%eax),%eax
  8023c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  8023ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8023d0:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  8023d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023d8:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  8023db:	8b 45 08             	mov    0x8(%ebp),%eax
  8023de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e1:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  8023e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e9:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  8023ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023f1:	40                   	inc    %eax
  8023f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  8023f7:	90                   	nop
				}
			}
		 }

	}
}
  8023f8:	eb 2e                	jmp    802428 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  8023fa:	a1 48 40 80 00       	mov    0x804048,%eax
  8023ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802406:	74 07                	je     80240f <insert_sorted_allocList+0x1e4>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	eb 05                	jmp    802414 <insert_sorted_allocList+0x1e9>
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
  802414:	a3 48 40 80 00       	mov    %eax,0x804048
  802419:	a1 48 40 80 00       	mov    0x804048,%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	75 8f                	jne    8023b1 <insert_sorted_allocList+0x186>
  802422:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802426:	75 89                	jne    8023b1 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  802428:	90                   	nop
  802429:	c9                   	leave  
  80242a:	c3                   	ret    

0080242b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802431:	a1 38 41 80 00       	mov    0x804138,%eax
  802436:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802439:	e9 76 01 00 00       	jmp    8025b4 <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 40 0c             	mov    0xc(%eax),%eax
  802444:	3b 45 08             	cmp    0x8(%ebp),%eax
  802447:	0f 85 8a 00 00 00    	jne    8024d7 <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  80244d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802451:	75 17                	jne    80246a <alloc_block_FF+0x3f>
  802453:	83 ec 04             	sub    $0x4,%esp
  802456:	68 4f 3c 80 00       	push   $0x803c4f
  80245b:	68 8a 00 00 00       	push   $0x8a
  802460:	68 13 3c 80 00       	push   $0x803c13
  802465:	e8 33 df ff ff       	call   80039d <_panic>
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	8b 00                	mov    (%eax),%eax
  80246f:	85 c0                	test   %eax,%eax
  802471:	74 10                	je     802483 <alloc_block_FF+0x58>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247b:	8b 52 04             	mov    0x4(%edx),%edx
  80247e:	89 50 04             	mov    %edx,0x4(%eax)
  802481:	eb 0b                	jmp    80248e <alloc_block_FF+0x63>
  802483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802486:	8b 40 04             	mov    0x4(%eax),%eax
  802489:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 40 04             	mov    0x4(%eax),%eax
  802494:	85 c0                	test   %eax,%eax
  802496:	74 0f                	je     8024a7 <alloc_block_FF+0x7c>
  802498:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249b:	8b 40 04             	mov    0x4(%eax),%eax
  80249e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a1:	8b 12                	mov    (%edx),%edx
  8024a3:	89 10                	mov    %edx,(%eax)
  8024a5:	eb 0a                	jmp    8024b1 <alloc_block_FF+0x86>
  8024a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024aa:	8b 00                	mov    (%eax),%eax
  8024ac:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c4:	a1 44 41 80 00       	mov    0x804144,%eax
  8024c9:	48                   	dec    %eax
  8024ca:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	e9 10 01 00 00       	jmp    8025e7 <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	8b 40 0c             	mov    0xc(%eax),%eax
  8024dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e0:	0f 86 c6 00 00 00    	jbe    8025ac <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8024e6:	a1 48 41 80 00       	mov    0x804148,%eax
  8024eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8024ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f2:	75 17                	jne    80250b <alloc_block_FF+0xe0>
  8024f4:	83 ec 04             	sub    $0x4,%esp
  8024f7:	68 4f 3c 80 00       	push   $0x803c4f
  8024fc:	68 90 00 00 00       	push   $0x90
  802501:	68 13 3c 80 00       	push   $0x803c13
  802506:	e8 92 de ff ff       	call   80039d <_panic>
  80250b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80250e:	8b 00                	mov    (%eax),%eax
  802510:	85 c0                	test   %eax,%eax
  802512:	74 10                	je     802524 <alloc_block_FF+0xf9>
  802514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802517:	8b 00                	mov    (%eax),%eax
  802519:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80251c:	8b 52 04             	mov    0x4(%edx),%edx
  80251f:	89 50 04             	mov    %edx,0x4(%eax)
  802522:	eb 0b                	jmp    80252f <alloc_block_FF+0x104>
  802524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802527:	8b 40 04             	mov    0x4(%eax),%eax
  80252a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80252f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802532:	8b 40 04             	mov    0x4(%eax),%eax
  802535:	85 c0                	test   %eax,%eax
  802537:	74 0f                	je     802548 <alloc_block_FF+0x11d>
  802539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80253c:	8b 40 04             	mov    0x4(%eax),%eax
  80253f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802542:	8b 12                	mov    (%edx),%edx
  802544:	89 10                	mov    %edx,(%eax)
  802546:	eb 0a                	jmp    802552 <alloc_block_FF+0x127>
  802548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254b:	8b 00                	mov    (%eax),%eax
  80254d:	a3 48 41 80 00       	mov    %eax,0x804148
  802552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802555:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80255b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80255e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802565:	a1 54 41 80 00       	mov    0x804154,%eax
  80256a:	48                   	dec    %eax
  80256b:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  802570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802573:	8b 55 08             	mov    0x8(%ebp),%edx
  802576:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 50 08             	mov    0x8(%eax),%edx
  80257f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802582:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	8b 50 08             	mov    0x8(%eax),%edx
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	01 c2                	add    %eax,%edx
  802590:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802593:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 40 0c             	mov    0xc(%eax),%eax
  80259c:	2b 45 08             	sub    0x8(%ebp),%eax
  80259f:	89 c2                	mov    %eax,%edx
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  8025a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025aa:	eb 3b                	jmp    8025e7 <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8025ac:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b8:	74 07                	je     8025c1 <alloc_block_FF+0x196>
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 00                	mov    (%eax),%eax
  8025bf:	eb 05                	jmp    8025c6 <alloc_block_FF+0x19b>
  8025c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c6:	a3 40 41 80 00       	mov    %eax,0x804140
  8025cb:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d0:	85 c0                	test   %eax,%eax
  8025d2:	0f 85 66 fe ff ff    	jne    80243e <alloc_block_FF+0x13>
  8025d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025dc:	0f 85 5c fe ff ff    	jne    80243e <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  8025e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  8025ef:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  8025f6:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  8025fd:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802604:	a1 38 41 80 00       	mov    0x804138,%eax
  802609:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260c:	e9 cf 00 00 00       	jmp    8026e0 <alloc_block_BF+0xf7>
		{
			c++;
  802611:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  802614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802617:	8b 40 0c             	mov    0xc(%eax),%eax
  80261a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80261d:	0f 85 8a 00 00 00    	jne    8026ad <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  802623:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802627:	75 17                	jne    802640 <alloc_block_BF+0x57>
  802629:	83 ec 04             	sub    $0x4,%esp
  80262c:	68 4f 3c 80 00       	push   $0x803c4f
  802631:	68 a8 00 00 00       	push   $0xa8
  802636:	68 13 3c 80 00       	push   $0x803c13
  80263b:	e8 5d dd ff ff       	call   80039d <_panic>
  802640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	85 c0                	test   %eax,%eax
  802647:	74 10                	je     802659 <alloc_block_BF+0x70>
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 00                	mov    (%eax),%eax
  80264e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802651:	8b 52 04             	mov    0x4(%edx),%edx
  802654:	89 50 04             	mov    %edx,0x4(%eax)
  802657:	eb 0b                	jmp    802664 <alloc_block_BF+0x7b>
  802659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265c:	8b 40 04             	mov    0x4(%eax),%eax
  80265f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802664:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802667:	8b 40 04             	mov    0x4(%eax),%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	74 0f                	je     80267d <alloc_block_BF+0x94>
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 40 04             	mov    0x4(%eax),%eax
  802674:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802677:	8b 12                	mov    (%edx),%edx
  802679:	89 10                	mov    %edx,(%eax)
  80267b:	eb 0a                	jmp    802687 <alloc_block_BF+0x9e>
  80267d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	a3 38 41 80 00       	mov    %eax,0x804138
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269a:	a1 44 41 80 00       	mov    0x804144,%eax
  80269f:	48                   	dec    %eax
  8026a0:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	e9 85 01 00 00       	jmp    802832 <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  8026ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b6:	76 20                	jbe    8026d8 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  8026b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8026be:	2b 45 08             	sub    0x8(%ebp),%eax
  8026c1:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  8026c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026c7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8026ca:	73 0c                	jae    8026d8 <alloc_block_BF+0xef>
				{
					ma=tempi;
  8026cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8026cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  8026d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8026d8:	a1 40 41 80 00       	mov    0x804140,%eax
  8026dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026e4:	74 07                	je     8026ed <alloc_block_BF+0x104>
  8026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e9:	8b 00                	mov    (%eax),%eax
  8026eb:	eb 05                	jmp    8026f2 <alloc_block_BF+0x109>
  8026ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8026f2:	a3 40 41 80 00       	mov    %eax,0x804140
  8026f7:	a1 40 41 80 00       	mov    0x804140,%eax
  8026fc:	85 c0                	test   %eax,%eax
  8026fe:	0f 85 0d ff ff ff    	jne    802611 <alloc_block_BF+0x28>
  802704:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802708:	0f 85 03 ff ff ff    	jne    802611 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  80270e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802715:	a1 38 41 80 00       	mov    0x804138,%eax
  80271a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80271d:	e9 dd 00 00 00       	jmp    8027ff <alloc_block_BF+0x216>
		{
			if(x==sol)
  802722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802725:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  802728:	0f 85 c6 00 00 00    	jne    8027f4 <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80272e:	a1 48 41 80 00       	mov    0x804148,%eax
  802733:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802736:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80273a:	75 17                	jne    802753 <alloc_block_BF+0x16a>
  80273c:	83 ec 04             	sub    $0x4,%esp
  80273f:	68 4f 3c 80 00       	push   $0x803c4f
  802744:	68 bb 00 00 00       	push   $0xbb
  802749:	68 13 3c 80 00       	push   $0x803c13
  80274e:	e8 4a dc ff ff       	call   80039d <_panic>
  802753:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802756:	8b 00                	mov    (%eax),%eax
  802758:	85 c0                	test   %eax,%eax
  80275a:	74 10                	je     80276c <alloc_block_BF+0x183>
  80275c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80275f:	8b 00                	mov    (%eax),%eax
  802761:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802764:	8b 52 04             	mov    0x4(%edx),%edx
  802767:	89 50 04             	mov    %edx,0x4(%eax)
  80276a:	eb 0b                	jmp    802777 <alloc_block_BF+0x18e>
  80276c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276f:	8b 40 04             	mov    0x4(%eax),%eax
  802772:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802777:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277a:	8b 40 04             	mov    0x4(%eax),%eax
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 0f                	je     802790 <alloc_block_BF+0x1a7>
  802781:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802784:	8b 40 04             	mov    0x4(%eax),%eax
  802787:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80278a:	8b 12                	mov    (%edx),%edx
  80278c:	89 10                	mov    %edx,(%eax)
  80278e:	eb 0a                	jmp    80279a <alloc_block_BF+0x1b1>
  802790:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802793:	8b 00                	mov    (%eax),%eax
  802795:	a3 48 41 80 00       	mov    %eax,0x804148
  80279a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ad:	a1 54 41 80 00       	mov    0x804154,%eax
  8027b2:	48                   	dec    %eax
  8027b3:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  8027b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027be:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 50 08             	mov    0x8(%eax),%edx
  8027c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ca:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  8027cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d0:	8b 50 08             	mov    0x8(%eax),%edx
  8027d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d6:	01 c2                	add    %eax,%edx
  8027d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027db:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  8027de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e4:	2b 45 08             	sub    0x8(%ebp),%eax
  8027e7:	89 c2                	mov    %eax,%edx
  8027e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ec:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  8027ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027f2:	eb 3e                	jmp    802832 <alloc_block_BF+0x249>
						 break;
			}
			x++;
  8027f4:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  8027f7:	a1 40 41 80 00       	mov    0x804140,%eax
  8027fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802803:	74 07                	je     80280c <alloc_block_BF+0x223>
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	eb 05                	jmp    802811 <alloc_block_BF+0x228>
  80280c:	b8 00 00 00 00       	mov    $0x0,%eax
  802811:	a3 40 41 80 00       	mov    %eax,0x804140
  802816:	a1 40 41 80 00       	mov    0x804140,%eax
  80281b:	85 c0                	test   %eax,%eax
  80281d:	0f 85 ff fe ff ff    	jne    802722 <alloc_block_BF+0x139>
  802823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802827:	0f 85 f5 fe ff ff    	jne    802722 <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  80282d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802832:	c9                   	leave  
  802833:	c3                   	ret    

00802834 <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  802834:	55                   	push   %ebp
  802835:	89 e5                	mov    %esp,%ebp
  802837:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  80283a:	a1 28 40 80 00       	mov    0x804028,%eax
  80283f:	85 c0                	test   %eax,%eax
  802841:	75 14                	jne    802857 <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  802843:	a1 38 41 80 00       	mov    0x804138,%eax
  802848:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  80284d:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  802854:	00 00 00 
	}
	uint32 c=1;
  802857:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  80285e:	a1 60 41 80 00       	mov    0x804160,%eax
  802863:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802866:	e9 b3 01 00 00       	jmp    802a1e <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  80286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286e:	8b 40 0c             	mov    0xc(%eax),%eax
  802871:	3b 45 08             	cmp    0x8(%ebp),%eax
  802874:	0f 85 a9 00 00 00    	jne    802923 <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  80287a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80287d:	8b 00                	mov    (%eax),%eax
  80287f:	85 c0                	test   %eax,%eax
  802881:	75 0c                	jne    80288f <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  802883:	a1 38 41 80 00       	mov    0x804138,%eax
  802888:	a3 60 41 80 00       	mov    %eax,0x804160
  80288d:	eb 0a                	jmp    802899 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  80288f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802892:	8b 00                	mov    (%eax),%eax
  802894:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802899:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80289d:	75 17                	jne    8028b6 <alloc_block_NF+0x82>
  80289f:	83 ec 04             	sub    $0x4,%esp
  8028a2:	68 4f 3c 80 00       	push   $0x803c4f
  8028a7:	68 e3 00 00 00       	push   $0xe3
  8028ac:	68 13 3c 80 00       	push   $0x803c13
  8028b1:	e8 e7 da ff ff       	call   80039d <_panic>
  8028b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028b9:	8b 00                	mov    (%eax),%eax
  8028bb:	85 c0                	test   %eax,%eax
  8028bd:	74 10                	je     8028cf <alloc_block_NF+0x9b>
  8028bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028c2:	8b 00                	mov    (%eax),%eax
  8028c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028c7:	8b 52 04             	mov    0x4(%edx),%edx
  8028ca:	89 50 04             	mov    %edx,0x4(%eax)
  8028cd:	eb 0b                	jmp    8028da <alloc_block_NF+0xa6>
  8028cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d2:	8b 40 04             	mov    0x4(%eax),%eax
  8028d5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	85 c0                	test   %eax,%eax
  8028e2:	74 0f                	je     8028f3 <alloc_block_NF+0xbf>
  8028e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028ed:	8b 12                	mov    (%edx),%edx
  8028ef:	89 10                	mov    %edx,(%eax)
  8028f1:	eb 0a                	jmp    8028fd <alloc_block_NF+0xc9>
  8028f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f6:	8b 00                	mov    (%eax),%eax
  8028f8:	a3 38 41 80 00       	mov    %eax,0x804138
  8028fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802900:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802910:	a1 44 41 80 00       	mov    0x804144,%eax
  802915:	48                   	dec    %eax
  802916:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  80291b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80291e:	e9 0e 01 00 00       	jmp    802a31 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  802923:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802926:	8b 40 0c             	mov    0xc(%eax),%eax
  802929:	3b 45 08             	cmp    0x8(%ebp),%eax
  80292c:	0f 86 ce 00 00 00    	jbe    802a00 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  802932:	a1 48 41 80 00       	mov    0x804148,%eax
  802937:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  80293a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80293e:	75 17                	jne    802957 <alloc_block_NF+0x123>
  802940:	83 ec 04             	sub    $0x4,%esp
  802943:	68 4f 3c 80 00       	push   $0x803c4f
  802948:	68 e9 00 00 00       	push   $0xe9
  80294d:	68 13 3c 80 00       	push   $0x803c13
  802952:	e8 46 da ff ff       	call   80039d <_panic>
  802957:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	85 c0                	test   %eax,%eax
  80295e:	74 10                	je     802970 <alloc_block_NF+0x13c>
  802960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802963:	8b 00                	mov    (%eax),%eax
  802965:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802968:	8b 52 04             	mov    0x4(%edx),%edx
  80296b:	89 50 04             	mov    %edx,0x4(%eax)
  80296e:	eb 0b                	jmp    80297b <alloc_block_NF+0x147>
  802970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802973:	8b 40 04             	mov    0x4(%eax),%eax
  802976:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80297b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80297e:	8b 40 04             	mov    0x4(%eax),%eax
  802981:	85 c0                	test   %eax,%eax
  802983:	74 0f                	je     802994 <alloc_block_NF+0x160>
  802985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802988:	8b 40 04             	mov    0x4(%eax),%eax
  80298b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80298e:	8b 12                	mov    (%edx),%edx
  802990:	89 10                	mov    %edx,(%eax)
  802992:	eb 0a                	jmp    80299e <alloc_block_NF+0x16a>
  802994:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802997:	8b 00                	mov    (%eax),%eax
  802999:	a3 48 41 80 00       	mov    %eax,0x804148
  80299e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029aa:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b1:	a1 54 41 80 00       	mov    0x804154,%eax
  8029b6:	48                   	dec    %eax
  8029b7:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  8029bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c2:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  8029c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c8:	8b 50 08             	mov    0x8(%eax),%edx
  8029cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029ce:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  8029d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d4:	8b 50 08             	mov    0x8(%eax),%edx
  8029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029da:	01 c2                	add    %eax,%edx
  8029dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029df:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  8029e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e8:	2b 45 08             	sub    0x8(%ebp),%eax
  8029eb:	89 c2                	mov    %eax,%edx
  8029ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f0:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  8029f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f6:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  8029fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029fe:	eb 31                	jmp    802a31 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802a00:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  802a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a06:	8b 00                	mov    (%eax),%eax
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	75 0a                	jne    802a16 <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802a0c:	a1 38 41 80 00       	mov    0x804138,%eax
  802a11:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802a14:	eb 08                	jmp    802a1e <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  802a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a19:	8b 00                	mov    (%eax),%eax
  802a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802a1e:	a1 44 41 80 00       	mov    0x804144,%eax
  802a23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  802a26:	0f 85 3f fe ff ff    	jne    80286b <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  802a2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a31:	c9                   	leave  
  802a32:	c3                   	ret    

00802a33 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802a33:	55                   	push   %ebp
  802a34:	89 e5                	mov    %esp,%ebp
  802a36:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  802a39:	a1 44 41 80 00       	mov    0x804144,%eax
  802a3e:	85 c0                	test   %eax,%eax
  802a40:	75 68                	jne    802aaa <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802a42:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a46:	75 17                	jne    802a5f <insert_sorted_with_merge_freeList+0x2c>
  802a48:	83 ec 04             	sub    $0x4,%esp
  802a4b:	68 f0 3b 80 00       	push   $0x803bf0
  802a50:	68 0e 01 00 00       	push   $0x10e
  802a55:	68 13 3c 80 00       	push   $0x803c13
  802a5a:	e8 3e d9 ff ff       	call   80039d <_panic>
  802a5f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	89 10                	mov    %edx,(%eax)
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	8b 00                	mov    (%eax),%eax
  802a6f:	85 c0                	test   %eax,%eax
  802a71:	74 0d                	je     802a80 <insert_sorted_with_merge_freeList+0x4d>
  802a73:	a1 38 41 80 00       	mov    0x804138,%eax
  802a78:	8b 55 08             	mov    0x8(%ebp),%edx
  802a7b:	89 50 04             	mov    %edx,0x4(%eax)
  802a7e:	eb 08                	jmp    802a88 <insert_sorted_with_merge_freeList+0x55>
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	a3 38 41 80 00       	mov    %eax,0x804138
  802a90:	8b 45 08             	mov    0x8(%ebp),%eax
  802a93:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a9a:	a1 44 41 80 00       	mov    0x804144,%eax
  802a9f:	40                   	inc    %eax
  802aa0:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802aa5:	e9 8c 06 00 00       	jmp    803136 <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802aaa:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802ab2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab7:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	8b 50 08             	mov    0x8(%eax),%edx
  802ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac3:	8b 40 08             	mov    0x8(%eax),%eax
  802ac6:	39 c2                	cmp    %eax,%edx
  802ac8:	0f 86 14 01 00 00    	jbe    802be2 <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ad7:	8b 40 08             	mov    0x8(%eax),%eax
  802ada:	01 c2                	add    %eax,%edx
  802adc:	8b 45 08             	mov    0x8(%ebp),%eax
  802adf:	8b 40 08             	mov    0x8(%eax),%eax
  802ae2:	39 c2                	cmp    %eax,%edx
  802ae4:	0f 85 90 00 00 00    	jne    802b7a <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aed:	8b 50 0c             	mov    0xc(%eax),%edx
  802af0:	8b 45 08             	mov    0x8(%ebp),%eax
  802af3:	8b 40 0c             	mov    0xc(%eax),%eax
  802af6:	01 c2                	add    %eax,%edx
  802af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802afb:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802b12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b16:	75 17                	jne    802b2f <insert_sorted_with_merge_freeList+0xfc>
  802b18:	83 ec 04             	sub    $0x4,%esp
  802b1b:	68 f0 3b 80 00       	push   $0x803bf0
  802b20:	68 1b 01 00 00       	push   $0x11b
  802b25:	68 13 3c 80 00       	push   $0x803c13
  802b2a:	e8 6e d8 ff ff       	call   80039d <_panic>
  802b2f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b35:	8b 45 08             	mov    0x8(%ebp),%eax
  802b38:	89 10                	mov    %edx,(%eax)
  802b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	85 c0                	test   %eax,%eax
  802b41:	74 0d                	je     802b50 <insert_sorted_with_merge_freeList+0x11d>
  802b43:	a1 48 41 80 00       	mov    0x804148,%eax
  802b48:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4b:	89 50 04             	mov    %edx,0x4(%eax)
  802b4e:	eb 08                	jmp    802b58 <insert_sorted_with_merge_freeList+0x125>
  802b50:	8b 45 08             	mov    0x8(%ebp),%eax
  802b53:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b58:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5b:	a3 48 41 80 00       	mov    %eax,0x804148
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6a:	a1 54 41 80 00       	mov    0x804154,%eax
  802b6f:	40                   	inc    %eax
  802b70:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802b75:	e9 bc 05 00 00       	jmp    803136 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802b7a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7e:	75 17                	jne    802b97 <insert_sorted_with_merge_freeList+0x164>
  802b80:	83 ec 04             	sub    $0x4,%esp
  802b83:	68 2c 3c 80 00       	push   $0x803c2c
  802b88:	68 1f 01 00 00       	push   $0x11f
  802b8d:	68 13 3c 80 00       	push   $0x803c13
  802b92:	e8 06 d8 ff ff       	call   80039d <_panic>
  802b97:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba0:	89 50 04             	mov    %edx,0x4(%eax)
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	8b 40 04             	mov    0x4(%eax),%eax
  802ba9:	85 c0                	test   %eax,%eax
  802bab:	74 0c                	je     802bb9 <insert_sorted_with_merge_freeList+0x186>
  802bad:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb5:	89 10                	mov    %edx,(%eax)
  802bb7:	eb 08                	jmp    802bc1 <insert_sorted_with_merge_freeList+0x18e>
  802bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbc:	a3 38 41 80 00       	mov    %eax,0x804138
  802bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bd2:	a1 44 41 80 00       	mov    0x804144,%eax
  802bd7:	40                   	inc    %eax
  802bd8:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802bdd:	e9 54 05 00 00       	jmp    803136 <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802be2:	8b 45 08             	mov    0x8(%ebp),%eax
  802be5:	8b 50 08             	mov    0x8(%eax),%edx
  802be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802beb:	8b 40 08             	mov    0x8(%eax),%eax
  802bee:	39 c2                	cmp    %eax,%edx
  802bf0:	0f 83 20 01 00 00    	jae    802d16 <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf9:	8b 50 0c             	mov    0xc(%eax),%edx
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	8b 40 08             	mov    0x8(%eax),%eax
  802c02:	01 c2                	add    %eax,%edx
  802c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c07:	8b 40 08             	mov    0x8(%eax),%eax
  802c0a:	39 c2                	cmp    %eax,%edx
  802c0c:	0f 85 9c 00 00 00    	jne    802cae <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	8b 50 08             	mov    0x8(%eax),%edx
  802c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1b:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c21:	8b 50 0c             	mov    0xc(%eax),%edx
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	8b 40 0c             	mov    0xc(%eax),%eax
  802c2a:	01 c2                	add    %eax,%edx
  802c2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2f:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802c32:	8b 45 08             	mov    0x8(%ebp),%eax
  802c35:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802c46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4a:	75 17                	jne    802c63 <insert_sorted_with_merge_freeList+0x230>
  802c4c:	83 ec 04             	sub    $0x4,%esp
  802c4f:	68 f0 3b 80 00       	push   $0x803bf0
  802c54:	68 2a 01 00 00       	push   $0x12a
  802c59:	68 13 3c 80 00       	push   $0x803c13
  802c5e:	e8 3a d7 ff ff       	call   80039d <_panic>
  802c63:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	89 10                	mov    %edx,(%eax)
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 00                	mov    (%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	74 0d                	je     802c84 <insert_sorted_with_merge_freeList+0x251>
  802c77:	a1 48 41 80 00       	mov    0x804148,%eax
  802c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7f:	89 50 04             	mov    %edx,0x4(%eax)
  802c82:	eb 08                	jmp    802c8c <insert_sorted_with_merge_freeList+0x259>
  802c84:	8b 45 08             	mov    0x8(%ebp),%eax
  802c87:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8f:	a3 48 41 80 00       	mov    %eax,0x804148
  802c94:	8b 45 08             	mov    0x8(%ebp),%eax
  802c97:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c9e:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca3:	40                   	inc    %eax
  802ca4:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802ca9:	e9 88 04 00 00       	jmp    803136 <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802cae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cb2:	75 17                	jne    802ccb <insert_sorted_with_merge_freeList+0x298>
  802cb4:	83 ec 04             	sub    $0x4,%esp
  802cb7:	68 f0 3b 80 00       	push   $0x803bf0
  802cbc:	68 2e 01 00 00       	push   $0x12e
  802cc1:	68 13 3c 80 00       	push   $0x803c13
  802cc6:	e8 d2 d6 ff ff       	call   80039d <_panic>
  802ccb:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	89 10                	mov    %edx,(%eax)
  802cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd9:	8b 00                	mov    (%eax),%eax
  802cdb:	85 c0                	test   %eax,%eax
  802cdd:	74 0d                	je     802cec <insert_sorted_with_merge_freeList+0x2b9>
  802cdf:	a1 38 41 80 00       	mov    0x804138,%eax
  802ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce7:	89 50 04             	mov    %edx,0x4(%eax)
  802cea:	eb 08                	jmp    802cf4 <insert_sorted_with_merge_freeList+0x2c1>
  802cec:	8b 45 08             	mov    0x8(%ebp),%eax
  802cef:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	a3 38 41 80 00       	mov    %eax,0x804138
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d06:	a1 44 41 80 00       	mov    0x804144,%eax
  802d0b:	40                   	inc    %eax
  802d0c:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802d11:	e9 20 04 00 00       	jmp    803136 <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802d16:	a1 38 41 80 00       	mov    0x804138,%eax
  802d1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d1e:	e9 e2 03 00 00       	jmp    803105 <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	8b 50 08             	mov    0x8(%eax),%edx
  802d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2c:	8b 40 08             	mov    0x8(%eax),%eax
  802d2f:	39 c2                	cmp    %eax,%edx
  802d31:	0f 83 c6 03 00 00    	jae    8030fd <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3a:	8b 40 04             	mov    0x4(%eax),%eax
  802d3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802d40:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d43:	8b 50 08             	mov    0x8(%eax),%edx
  802d46:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d49:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4c:	01 d0                	add    %edx,%eax
  802d4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	8b 50 0c             	mov    0xc(%eax),%edx
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	8b 40 08             	mov    0x8(%eax),%eax
  802d5d:	01 d0                	add    %edx,%eax
  802d5f:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	8b 40 08             	mov    0x8(%eax),%eax
  802d68:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d6b:	74 7a                	je     802de7 <insert_sorted_with_merge_freeList+0x3b4>
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 40 08             	mov    0x8(%eax),%eax
  802d73:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d76:	74 6f                	je     802de7 <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802d78:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d7c:	74 06                	je     802d84 <insert_sorted_with_merge_freeList+0x351>
  802d7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d82:	75 17                	jne    802d9b <insert_sorted_with_merge_freeList+0x368>
  802d84:	83 ec 04             	sub    $0x4,%esp
  802d87:	68 70 3c 80 00       	push   $0x803c70
  802d8c:	68 43 01 00 00       	push   $0x143
  802d91:	68 13 3c 80 00       	push   $0x803c13
  802d96:	e8 02 d6 ff ff       	call   80039d <_panic>
  802d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9e:	8b 50 04             	mov    0x4(%eax),%edx
  802da1:	8b 45 08             	mov    0x8(%ebp),%eax
  802da4:	89 50 04             	mov    %edx,0x4(%eax)
  802da7:	8b 45 08             	mov    0x8(%ebp),%eax
  802daa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802dad:	89 10                	mov    %edx,(%eax)
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	8b 40 04             	mov    0x4(%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	74 0d                	je     802dc6 <insert_sorted_with_merge_freeList+0x393>
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 40 04             	mov    0x4(%eax),%eax
  802dbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc2:	89 10                	mov    %edx,(%eax)
  802dc4:	eb 08                	jmp    802dce <insert_sorted_with_merge_freeList+0x39b>
  802dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc9:	a3 38 41 80 00       	mov    %eax,0x804138
  802dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd4:	89 50 04             	mov    %edx,0x4(%eax)
  802dd7:	a1 44 41 80 00       	mov    0x804144,%eax
  802ddc:	40                   	inc    %eax
  802ddd:	a3 44 41 80 00       	mov    %eax,0x804144
  802de2:	e9 14 03 00 00       	jmp    8030fb <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802de7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dea:	8b 40 08             	mov    0x8(%eax),%eax
  802ded:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802df0:	0f 85 a0 01 00 00    	jne    802f96 <insert_sorted_with_merge_freeList+0x563>
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 40 08             	mov    0x8(%eax),%eax
  802dfc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802dff:	0f 85 91 01 00 00    	jne    802f96 <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802e05:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e08:	8b 50 0c             	mov    0xc(%eax),%edx
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	8b 48 0c             	mov    0xc(%eax),%ecx
  802e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e14:	8b 40 0c             	mov    0xc(%eax),%eax
  802e17:	01 c8                	add    %ecx,%eax
  802e19:	01 c2                	add    %eax,%edx
  802e1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e1e:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802e21:	8b 45 08             	mov    0x8(%ebp),%eax
  802e24:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e38:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802e49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4d:	75 17                	jne    802e66 <insert_sorted_with_merge_freeList+0x433>
  802e4f:	83 ec 04             	sub    $0x4,%esp
  802e52:	68 f0 3b 80 00       	push   $0x803bf0
  802e57:	68 4d 01 00 00       	push   $0x14d
  802e5c:	68 13 3c 80 00       	push   $0x803c13
  802e61:	e8 37 d5 ff ff       	call   80039d <_panic>
  802e66:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	89 10                	mov    %edx,(%eax)
  802e71:	8b 45 08             	mov    0x8(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	85 c0                	test   %eax,%eax
  802e78:	74 0d                	je     802e87 <insert_sorted_with_merge_freeList+0x454>
  802e7a:	a1 48 41 80 00       	mov    0x804148,%eax
  802e7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802e82:	89 50 04             	mov    %edx,0x4(%eax)
  802e85:	eb 08                	jmp    802e8f <insert_sorted_with_merge_freeList+0x45c>
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	a3 48 41 80 00       	mov    %eax,0x804148
  802e97:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea1:	a1 54 41 80 00       	mov    0x804154,%eax
  802ea6:	40                   	inc    %eax
  802ea7:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802eac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eb0:	75 17                	jne    802ec9 <insert_sorted_with_merge_freeList+0x496>
  802eb2:	83 ec 04             	sub    $0x4,%esp
  802eb5:	68 4f 3c 80 00       	push   $0x803c4f
  802eba:	68 4e 01 00 00       	push   $0x14e
  802ebf:	68 13 3c 80 00       	push   $0x803c13
  802ec4:	e8 d4 d4 ff ff       	call   80039d <_panic>
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 00                	mov    (%eax),%eax
  802ece:	85 c0                	test   %eax,%eax
  802ed0:	74 10                	je     802ee2 <insert_sorted_with_merge_freeList+0x4af>
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 00                	mov    (%eax),%eax
  802ed7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802eda:	8b 52 04             	mov    0x4(%edx),%edx
  802edd:	89 50 04             	mov    %edx,0x4(%eax)
  802ee0:	eb 0b                	jmp    802eed <insert_sorted_with_merge_freeList+0x4ba>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 40 04             	mov    0x4(%eax),%eax
  802ee8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 40 04             	mov    0x4(%eax),%eax
  802ef3:	85 c0                	test   %eax,%eax
  802ef5:	74 0f                	je     802f06 <insert_sorted_with_merge_freeList+0x4d3>
  802ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efa:	8b 40 04             	mov    0x4(%eax),%eax
  802efd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f00:	8b 12                	mov    (%edx),%edx
  802f02:	89 10                	mov    %edx,(%eax)
  802f04:	eb 0a                	jmp    802f10 <insert_sorted_with_merge_freeList+0x4dd>
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	a3 38 41 80 00       	mov    %eax,0x804138
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f23:	a1 44 41 80 00       	mov    0x804144,%eax
  802f28:	48                   	dec    %eax
  802f29:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802f2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f32:	75 17                	jne    802f4b <insert_sorted_with_merge_freeList+0x518>
  802f34:	83 ec 04             	sub    $0x4,%esp
  802f37:	68 f0 3b 80 00       	push   $0x803bf0
  802f3c:	68 4f 01 00 00       	push   $0x14f
  802f41:	68 13 3c 80 00       	push   $0x803c13
  802f46:	e8 52 d4 ff ff       	call   80039d <_panic>
  802f4b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f54:	89 10                	mov    %edx,(%eax)
  802f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f59:	8b 00                	mov    (%eax),%eax
  802f5b:	85 c0                	test   %eax,%eax
  802f5d:	74 0d                	je     802f6c <insert_sorted_with_merge_freeList+0x539>
  802f5f:	a1 48 41 80 00       	mov    0x804148,%eax
  802f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f67:	89 50 04             	mov    %edx,0x4(%eax)
  802f6a:	eb 08                	jmp    802f74 <insert_sorted_with_merge_freeList+0x541>
  802f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f77:	a3 48 41 80 00       	mov    %eax,0x804148
  802f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f86:	a1 54 41 80 00       	mov    0x804154,%eax
  802f8b:	40                   	inc    %eax
  802f8c:	a3 54 41 80 00       	mov    %eax,0x804154
  802f91:	e9 65 01 00 00       	jmp    8030fb <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	8b 40 08             	mov    0x8(%eax),%eax
  802f9c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f9f:	0f 85 9f 00 00 00    	jne    803044 <insert_sorted_with_merge_freeList+0x611>
  802fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa8:	8b 40 08             	mov    0x8(%eax),%eax
  802fab:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802fae:	0f 84 90 00 00 00    	je     803044 <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb7:	8b 50 0c             	mov    0xc(%eax),%edx
  802fba:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbd:	8b 40 0c             	mov    0xc(%eax),%eax
  802fc0:	01 c2                	add    %eax,%edx
  802fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc5:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fcb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802fdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fe0:	75 17                	jne    802ff9 <insert_sorted_with_merge_freeList+0x5c6>
  802fe2:	83 ec 04             	sub    $0x4,%esp
  802fe5:	68 f0 3b 80 00       	push   $0x803bf0
  802fea:	68 58 01 00 00       	push   $0x158
  802fef:	68 13 3c 80 00       	push   $0x803c13
  802ff4:	e8 a4 d3 ff ff       	call   80039d <_panic>
  802ff9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fff:	8b 45 08             	mov    0x8(%ebp),%eax
  803002:	89 10                	mov    %edx,(%eax)
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	8b 00                	mov    (%eax),%eax
  803009:	85 c0                	test   %eax,%eax
  80300b:	74 0d                	je     80301a <insert_sorted_with_merge_freeList+0x5e7>
  80300d:	a1 48 41 80 00       	mov    0x804148,%eax
  803012:	8b 55 08             	mov    0x8(%ebp),%edx
  803015:	89 50 04             	mov    %edx,0x4(%eax)
  803018:	eb 08                	jmp    803022 <insert_sorted_with_merge_freeList+0x5ef>
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803022:	8b 45 08             	mov    0x8(%ebp),%eax
  803025:	a3 48 41 80 00       	mov    %eax,0x804148
  80302a:	8b 45 08             	mov    0x8(%ebp),%eax
  80302d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803034:	a1 54 41 80 00       	mov    0x804154,%eax
  803039:	40                   	inc    %eax
  80303a:	a3 54 41 80 00       	mov    %eax,0x804154
  80303f:	e9 b7 00 00 00       	jmp    8030fb <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	8b 40 08             	mov    0x8(%eax),%eax
  80304a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80304d:	0f 84 e2 00 00 00    	je     803135 <insert_sorted_with_merge_freeList+0x702>
  803053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803056:	8b 40 08             	mov    0x8(%eax),%eax
  803059:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80305c:	0f 85 d3 00 00 00    	jne    803135 <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	8b 50 08             	mov    0x8(%eax),%edx
  803068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306b:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  80306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803071:	8b 50 0c             	mov    0xc(%eax),%edx
  803074:	8b 45 08             	mov    0x8(%ebp),%eax
  803077:	8b 40 0c             	mov    0xc(%eax),%eax
  80307a:	01 c2                	add    %eax,%edx
  80307c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307f:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  80308c:	8b 45 08             	mov    0x8(%ebp),%eax
  80308f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  803096:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80309a:	75 17                	jne    8030b3 <insert_sorted_with_merge_freeList+0x680>
  80309c:	83 ec 04             	sub    $0x4,%esp
  80309f:	68 f0 3b 80 00       	push   $0x803bf0
  8030a4:	68 61 01 00 00       	push   $0x161
  8030a9:	68 13 3c 80 00       	push   $0x803c13
  8030ae:	e8 ea d2 ff ff       	call   80039d <_panic>
  8030b3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030bc:	89 10                	mov    %edx,(%eax)
  8030be:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c1:	8b 00                	mov    (%eax),%eax
  8030c3:	85 c0                	test   %eax,%eax
  8030c5:	74 0d                	je     8030d4 <insert_sorted_with_merge_freeList+0x6a1>
  8030c7:	a1 48 41 80 00       	mov    0x804148,%eax
  8030cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8030cf:	89 50 04             	mov    %edx,0x4(%eax)
  8030d2:	eb 08                	jmp    8030dc <insert_sorted_with_merge_freeList+0x6a9>
  8030d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8030df:	a3 48 41 80 00       	mov    %eax,0x804148
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ee:	a1 54 41 80 00       	mov    0x804154,%eax
  8030f3:	40                   	inc    %eax
  8030f4:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  8030f9:	eb 3a                	jmp    803135 <insert_sorted_with_merge_freeList+0x702>
  8030fb:	eb 38                	jmp    803135 <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  8030fd:	a1 40 41 80 00       	mov    0x804140,%eax
  803102:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803105:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803109:	74 07                	je     803112 <insert_sorted_with_merge_freeList+0x6df>
  80310b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310e:	8b 00                	mov    (%eax),%eax
  803110:	eb 05                	jmp    803117 <insert_sorted_with_merge_freeList+0x6e4>
  803112:	b8 00 00 00 00       	mov    $0x0,%eax
  803117:	a3 40 41 80 00       	mov    %eax,0x804140
  80311c:	a1 40 41 80 00       	mov    0x804140,%eax
  803121:	85 c0                	test   %eax,%eax
  803123:	0f 85 fa fb ff ff    	jne    802d23 <insert_sorted_with_merge_freeList+0x2f0>
  803129:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312d:	0f 85 f0 fb ff ff    	jne    802d23 <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  803133:	eb 01                	jmp    803136 <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  803135:	90                   	nop
							}

						}
		          }
		}
}
  803136:	90                   	nop
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

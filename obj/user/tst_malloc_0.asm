
obj/user/tst_malloc_0:     file format elf32-i386


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
  800031:	e8 a3 01 00 00       	call   8001d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
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
void _main(void)
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
  80008c:	68 20 33 80 00       	push   $0x803320
  800091:	6a 14                	push   $0x14
  800093:	68 3c 33 80 00       	push   $0x80333c
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 c3 18 00 00       	call   801965 <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 5b 19 00 00       	call   801a05 <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 41 14 00 00       	call   8014f8 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 a6 18 00 00       	call   801965 <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 3e 19 00 00       	call   801a05 <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 41 80 00       	mov    0x804120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 50 33 80 00       	push   $0x803350
  8000de:	6a 23                	push   $0x23
  8000e0:	68 3c 33 80 00       	push   $0x80333c
  8000e5:	e8 2b 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AvailableMemBlocksList
	if (LIST_SIZE(&(AvailableMemBlocksList)) != MAX_MEM_BLOCK_CNT-1)
  8000ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8000ef:	8b 15 20 41 80 00    	mov    0x804120,%edx
  8000f5:	4a                   	dec    %edx
  8000f6:	39 d0                	cmp    %edx,%eax
  8000f8:	74 14                	je     80010e <_main+0xd6>
	{
		panic("Wrong initialize: Wrong size for the AvailableMemBlocksList");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 a4 33 80 00       	push   $0x8033a4
  800102:	6a 29                	push   $0x29
  800104:	68 3c 33 80 00       	push   $0x80333c
  800109:	e8 07 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AllocMemBlocksList
	if (LIST_SIZE(&(AllocMemBlocksList)) != 0)
  80010e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  800113:	85 c0                	test   %eax,%eax
  800115:	74 14                	je     80012b <_main+0xf3>
	{
		panic("Wrong initialize: Wrong size for the AllocMemBlocksList");
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 e0 33 80 00       	push   $0x8033e0
  80011f:	6a 2f                	push   $0x2f
  800121:	68 3c 33 80 00       	push   $0x80333c
  800126:	e8 ea 01 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in FreeMemBlocksList
	if (LIST_SIZE(&(FreeMemBlocksList)) != 1)
  80012b:	a1 44 41 80 00       	mov    0x804144,%eax
  800130:	83 f8 01             	cmp    $0x1,%eax
  800133:	74 14                	je     800149 <_main+0x111>
	{
		panic("Wrong initialize: Wrong size for the FreeMemBlocksList");
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 18 34 80 00       	push   $0x803418
  80013d:	6a 35                	push   $0x35
  80013f:	68 3c 33 80 00       	push   $0x80333c
  800144:	e8 cc 01 00 00       	call   800315 <_panic>
	}

	//Check content of FreeMemBlocksList
	struct MemBlock* block = LIST_FIRST(&FreeMemBlocksList);
  800149:	a1 38 41 80 00       	mov    0x804138,%eax
  80014e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(block == NULL || block->size != (0xA0000000-0x80000000) || block->sva != 0x80000000)
  800151:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800155:	74 1a                	je     800171 <_main+0x139>
  800157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015a:	8b 40 0c             	mov    0xc(%eax),%eax
  80015d:	3d 00 00 00 20       	cmp    $0x20000000,%eax
  800162:	75 0d                	jne    800171 <_main+0x139>
  800164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800167:	8b 40 08             	mov    0x8(%eax),%eax
  80016a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
	{
		panic("Wrong initialize: Wrong content for the FreeMemBlocksList.");
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 50 34 80 00       	push   $0x803450
  800179:	6a 3c                	push   $0x3c
  80017b:	68 3c 33 80 00       	push   $0x80333c
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 8c 34 80 00       	push   $0x80348c
  800195:	6a 40                	push   $0x40
  800197:	68 3c 33 80 00       	push   $0x80333c
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 f4 34 80 00       	push   $0x8034f4
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 3c 33 80 00       	push   $0x80333c
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 38 35 80 00       	push   $0x803538
  8001ce:	e8 f6 03 00 00       	call   8005c9 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp

	return;
  8001d6:	90                   	nop
}
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001df:	e8 61 1a 00 00       	call   801c45 <sys_getenvindex>
  8001e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001ea:	89 d0                	mov    %edx,%eax
  8001ec:	c1 e0 03             	shl    $0x3,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	01 c0                	add    %eax,%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fc:	01 d0                	add    %edx,%eax
  8001fe:	c1 e0 04             	shl    $0x4,%eax
  800201:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800206:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800216:	84 c0                	test   %al,%al
  800218:	74 0f                	je     800229 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	05 5c 05 00 00       	add    $0x55c,%eax
  800224:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022d:	7e 0a                	jle    800239 <libmain+0x60>
		binaryname = argv[0];
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 f1 fd ff ff       	call   800038 <_main>
  800247:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80024a:	e8 03 18 00 00       	call   801a52 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 a8 35 80 00       	push   $0x8035a8
  800257:	e8 6d 03 00 00       	call   8005c9 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80025f:	a1 20 40 80 00       	mov    0x804020,%eax
  800264:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80026a:	a1 20 40 80 00       	mov    0x804020,%eax
  80026f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 d0 35 80 00       	push   $0x8035d0
  80027f:	e8 45 03 00 00       	call   8005c9 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800287:	a1 20 40 80 00       	mov    0x804020,%eax
  80028c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800292:	a1 20 40 80 00       	mov    0x804020,%eax
  800297:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80029d:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002a8:	51                   	push   %ecx
  8002a9:	52                   	push   %edx
  8002aa:	50                   	push   %eax
  8002ab:	68 f8 35 80 00       	push   $0x8035f8
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 50 36 80 00       	push   $0x803650
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 a8 35 80 00       	push   $0x8035a8
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 83 17 00 00       	call   801a6c <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002e9:	e8 19 00 00 00       	call   800307 <exit>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	6a 00                	push   $0x0
  8002fc:	e8 10 19 00 00       	call   801c11 <sys_destroy_env>
  800301:	83 c4 10             	add    $0x10,%esp
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <exit>:

void
exit(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030d:	e8 65 19 00 00       	call   801c77 <sys_exit_env>
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031b:	8d 45 10             	lea    0x10(%ebp),%eax
  80031e:	83 c0 04             	add    $0x4,%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800324:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	74 16                	je     800343 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	50                   	push   %eax
  800336:	68 64 36 80 00       	push   $0x803664
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 40 80 00       	mov    0x804000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 69 36 80 00       	push   $0x803669
  800354:	e8 70 02 00 00       	call   8005c9 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	50                   	push   %eax
  800366:	e8 f3 01 00 00       	call   80055e <vcprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	6a 00                	push   $0x0
  800373:	68 85 36 80 00       	push   $0x803685
  800378:	e8 e1 01 00 00       	call   80055e <vcprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800380:	e8 82 ff ff ff       	call   800307 <exit>

	// should not return here
	while (1) ;
  800385:	eb fe                	jmp    800385 <_panic+0x70>

00800387 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038d:	a1 20 40 80 00       	mov    0x804020,%eax
  800392:	8b 50 74             	mov    0x74(%eax),%edx
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	39 c2                	cmp    %eax,%edx
  80039a:	74 14                	je     8003b0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	68 88 36 80 00       	push   $0x803688
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 d4 36 80 00       	push   $0x8036d4
  8003ab:	e8 65 ff ff ff       	call   800315 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003be:	e9 c2 00 00 00       	jmp    800485 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	75 08                	jne    8003e0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003d8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003db:	e9 a2 00 00 00       	jmp    800482 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ee:	eb 69                	jmp    800459 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	c1 e0 03             	shl    $0x3,%eax
  800407:	01 c8                	add    %ecx,%eax
  800409:	8a 40 04             	mov    0x4(%eax),%al
  80040c:	84 c0                	test   %al,%al
  80040e:	75 46                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800436:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	01 c8                	add    %ecx,%eax
  800447:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800449:	39 c2                	cmp    %eax,%edx
  80044b:	75 09                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80044d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800454:	eb 12                	jmp    800468 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800456:	ff 45 e8             	incl   -0x18(%ebp)
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 50 74             	mov    0x74(%eax),%edx
  800461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	77 88                	ja     8003f0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046c:	75 14                	jne    800482 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	68 e0 36 80 00       	push   $0x8036e0
  800476:	6a 3a                	push   $0x3a
  800478:	68 d4 36 80 00       	push   $0x8036d4
  80047d:	e8 93 fe ff ff       	call   800315 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800482:	ff 45 f0             	incl   -0x10(%ebp)
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800488:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80048b:	0f 8c 32 ff ff ff    	jl     8003c3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800491:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049f:	eb 26                	jmp    8004c7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004af:	89 d0                	mov    %edx,%eax
  8004b1:	01 c0                	add    %eax,%eax
  8004b3:	01 d0                	add    %edx,%eax
  8004b5:	c1 e0 03             	shl    $0x3,%eax
  8004b8:	01 c8                	add    %ecx,%eax
  8004ba:	8a 40 04             	mov    0x4(%eax),%al
  8004bd:	3c 01                	cmp    $0x1,%al
  8004bf:	75 03                	jne    8004c4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004c1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c4:	ff 45 e0             	incl   -0x20(%ebp)
  8004c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004cc:	8b 50 74             	mov    0x74(%eax),%edx
  8004cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	77 cb                	ja     8004a1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 34 37 80 00       	push   $0x803734
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 d4 36 80 00       	push   $0x8036d4
  8004ed:	e8 23 fe ff ff       	call   800315 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f2:	90                   	nop
  8004f3:	c9                   	leave  
  8004f4:	c3                   	ret    

008004f5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 48 01             	lea    0x1(%eax),%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	89 0a                	mov    %ecx,(%edx)
  800508:	8b 55 08             	mov    0x8(%ebp),%edx
  80050b:	88 d1                	mov    %dl,%cl
  80050d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800510:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800514:	8b 45 0c             	mov    0xc(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051e:	75 2c                	jne    80054c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800520:	a0 24 40 80 00       	mov    0x804024,%al
  800525:	0f b6 c0             	movzbl %al,%eax
  800528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052b:	8b 12                	mov    (%edx),%edx
  80052d:	89 d1                	mov    %edx,%ecx
  80052f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800532:	83 c2 08             	add    $0x8,%edx
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	50                   	push   %eax
  800539:	51                   	push   %ecx
  80053a:	52                   	push   %edx
  80053b:	e8 64 13 00 00       	call   8018a4 <sys_cputs>
  800540:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800543:	8b 45 0c             	mov    0xc(%ebp),%eax
  800546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054f:	8b 40 04             	mov    0x4(%eax),%eax
  800552:	8d 50 01             	lea    0x1(%eax),%edx
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800567:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056e:	00 00 00 
	b.cnt = 0;
  800571:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800578:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	68 f5 04 80 00       	push   $0x8004f5
  80058d:	e8 11 02 00 00       	call   8007a3 <vprintfmt>
  800592:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800595:	a0 24 40 80 00       	mov    0x804024,%al
  80059a:	0f b6 c0             	movzbl %al,%eax
  80059d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	50                   	push   %eax
  8005a7:	52                   	push   %edx
  8005a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ae:	83 c0 08             	add    $0x8,%eax
  8005b1:	50                   	push   %eax
  8005b2:	e8 ed 12 00 00       	call   8018a4 <sys_cputs>
  8005b7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ba:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005cf:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	e8 73 ff ff ff       	call   80055e <vcprintf>
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005fc:	e8 51 14 00 00       	call   801a52 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800601:	8d 45 0c             	lea    0xc(%ebp),%eax
  800604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 48 ff ff ff       	call   80055e <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80061c:	e8 4b 14 00 00       	call   801a6c <sys_enable_interrupt>
	return cnt;
  800621:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	53                   	push   %ebx
  80062a:	83 ec 14             	sub    $0x14,%esp
  80062d:	8b 45 10             	mov    0x10(%ebp),%eax
  800630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800639:	8b 45 18             	mov    0x18(%ebp),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
  800641:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800644:	77 55                	ja     80069b <printnum+0x75>
  800646:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800649:	72 05                	jb     800650 <printnum+0x2a>
  80064b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80064e:	77 4b                	ja     80069b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800650:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800653:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800656:	8b 45 18             	mov    0x18(%ebp),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	ff 75 f4             	pushl  -0xc(%ebp)
  800663:	ff 75 f0             	pushl  -0x10(%ebp)
  800666:	e8 49 2a 00 00       	call   8030b4 <__udivdi3>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	ff 75 20             	pushl  0x20(%ebp)
  800674:	53                   	push   %ebx
  800675:	ff 75 18             	pushl  0x18(%ebp)
  800678:	52                   	push   %edx
  800679:	50                   	push   %eax
  80067a:	ff 75 0c             	pushl  0xc(%ebp)
  80067d:	ff 75 08             	pushl  0x8(%ebp)
  800680:	e8 a1 ff ff ff       	call   800626 <printnum>
  800685:	83 c4 20             	add    $0x20,%esp
  800688:	eb 1a                	jmp    8006a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	ff 75 20             	pushl  0x20(%ebp)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069b:	ff 4d 1c             	decl   0x1c(%ebp)
  80069e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a2:	7f e6                	jg     80068a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b2:	53                   	push   %ebx
  8006b3:	51                   	push   %ecx
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	e8 09 2b 00 00       	call   8031c4 <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 94 39 80 00       	add    $0x803994,%eax
  8006c3:	8a 00                	mov    (%eax),%al
  8006c5:	0f be c0             	movsbl %al,%eax
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
}
  8006d7:	90                   	nop
  8006d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e4:	7e 1c                	jle    800702 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	8d 50 08             	lea    0x8(%eax),%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	89 10                	mov    %edx,(%eax)
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	83 e8 08             	sub    $0x8,%eax
  8006fb:	8b 50 04             	mov    0x4(%eax),%edx
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	eb 40                	jmp    800742 <getuint+0x65>
	else if (lflag)
  800702:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800706:	74 1e                	je     800726 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	89 10                	mov    %edx,(%eax)
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	83 e8 04             	sub    $0x4,%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	ba 00 00 00 00       	mov    $0x0,%edx
  800724:	eb 1c                	jmp    800742 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800747:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074b:	7e 1c                	jle    800769 <getint+0x25>
		return va_arg(*ap, long long);
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	8d 50 08             	lea    0x8(%eax),%edx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	89 10                	mov    %edx,(%eax)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	83 e8 08             	sub    $0x8,%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	eb 38                	jmp    8007a1 <getint+0x5d>
	else if (lflag)
  800769:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076d:	74 1a                	je     800789 <getint+0x45>
		return va_arg(*ap, long);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	99                   	cltd   
  800787:	eb 18                	jmp    8007a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 04             	lea    0x4(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	99                   	cltd   
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	56                   	push   %esi
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	eb 17                	jmp    8007c4 <vprintfmt+0x21>
			if (ch == '\0')
  8007ad:	85 db                	test   %ebx,%ebx
  8007af:	0f 84 af 03 00 00    	je     800b64 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	53                   	push   %ebx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8007cd:	8a 00                	mov    (%eax),%al
  8007cf:	0f b6 d8             	movzbl %al,%ebx
  8007d2:	83 fb 25             	cmp    $0x25,%ebx
  8007d5:	75 d6                	jne    8007ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	8d 50 01             	lea    0x1(%eax),%edx
  8007fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f b6 d8             	movzbl %al,%ebx
  800805:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800808:	83 f8 55             	cmp    $0x55,%eax
  80080b:	0f 87 2b 03 00 00    	ja     800b3c <vprintfmt+0x399>
  800811:	8b 04 85 b8 39 80 00 	mov    0x8039b8(,%eax,4),%eax
  800818:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80081e:	eb d7                	jmp    8007f7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800820:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800824:	eb d1                	jmp    8007f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80082d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800830:	89 d0                	mov    %edx,%eax
  800832:	c1 e0 02             	shl    $0x2,%eax
  800835:	01 d0                	add    %edx,%eax
  800837:	01 c0                	add    %eax,%eax
  800839:	01 d8                	add    %ebx,%eax
  80083b:	83 e8 30             	sub    $0x30,%eax
  80083e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800849:	83 fb 2f             	cmp    $0x2f,%ebx
  80084c:	7e 3e                	jle    80088c <vprintfmt+0xe9>
  80084e:	83 fb 39             	cmp    $0x39,%ebx
  800851:	7f 39                	jg     80088c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800856:	eb d5                	jmp    80082d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80086c:	eb 1f                	jmp    80088d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80086e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800872:	79 83                	jns    8007f7 <vprintfmt+0x54>
				width = 0;
  800874:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087b:	e9 77 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800880:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800887:	e9 6b ff ff ff       	jmp    8007f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80088c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	0f 89 60 ff ff ff    	jns    8007f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a4:	e9 4e ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ac:	e9 46 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			break;
  8008d1:	e9 89 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 c0 04             	add    $0x4,%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	83 e8 04             	sub    $0x4,%eax
  8008e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e7:	85 db                	test   %ebx,%ebx
  8008e9:	79 02                	jns    8008ed <vprintfmt+0x14a>
				err = -err;
  8008eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ed:	83 fb 64             	cmp    $0x64,%ebx
  8008f0:	7f 0b                	jg     8008fd <vprintfmt+0x15a>
  8008f2:	8b 34 9d 00 38 80 00 	mov    0x803800(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 a5 39 80 00       	push   $0x8039a5
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 5e 02 00 00       	call   800b6c <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800911:	e9 49 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800916:	56                   	push   %esi
  800917:	68 ae 39 80 00       	push   $0x8039ae
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 45 02 00 00       	call   800b6c <printfmt>
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 30 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 30                	mov    (%eax),%esi
  800940:	85 f6                	test   %esi,%esi
  800942:	75 05                	jne    800949 <vprintfmt+0x1a6>
				p = "(null)";
  800944:	be b1 39 80 00       	mov    $0x8039b1,%esi
			if (width > 0 && padc != '-')
  800949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094d:	7e 6d                	jle    8009bc <vprintfmt+0x219>
  80094f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800953:	74 67                	je     8009bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	50                   	push   %eax
  80095c:	56                   	push   %esi
  80095d:	e8 0c 03 00 00       	call   800c6e <strnlen>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800968:	eb 16                	jmp    800980 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	50                   	push   %eax
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097d:	ff 4d e4             	decl   -0x1c(%ebp)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	7f e4                	jg     80096a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800986:	eb 34                	jmp    8009bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800988:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098c:	74 1c                	je     8009aa <vprintfmt+0x207>
  80098e:	83 fb 1f             	cmp    $0x1f,%ebx
  800991:	7e 05                	jle    800998 <vprintfmt+0x1f5>
  800993:	83 fb 7e             	cmp    $0x7e,%ebx
  800996:	7e 12                	jle    8009aa <vprintfmt+0x207>
					putch('?', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	6a 3f                	push   $0x3f
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	eb 0f                	jmp    8009b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	53                   	push   %ebx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bc:	89 f0                	mov    %esi,%eax
  8009be:	8d 70 01             	lea    0x1(%eax),%esi
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	74 24                	je     8009ee <vprintfmt+0x24b>
  8009ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ce:	78 b8                	js     800988 <vprintfmt+0x1e5>
  8009d0:	ff 4d e0             	decl   -0x20(%ebp)
  8009d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d7:	79 af                	jns    800988 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d9:	eb 13                	jmp    8009ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 20                	push   $0x20
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f2:	7f e7                	jg     8009db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f4:	e9 66 01 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800a02:	50                   	push   %eax
  800a03:	e8 3c fd ff ff       	call   800744 <getint>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a17:	85 d2                	test   %edx,%edx
  800a19:	79 23                	jns    800a3e <vprintfmt+0x29b>
				putch('-', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 2d                	push   $0x2d
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a31:	f7 d8                	neg    %eax
  800a33:	83 d2 00             	adc    $0x0,%edx
  800a36:	f7 da                	neg    %edx
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a45:	e9 bc 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
  800a53:	50                   	push   %eax
  800a54:	e8 84 fc ff ff       	call   8006dd <getuint>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a69:	e9 98 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 58                	push   $0x58
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 58                	push   $0x58
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 30                	push   $0x30
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	6a 78                	push   $0x78
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 14             	mov    %eax,0x14(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 e8 04             	sub    $0x4,%eax
  800ad2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ade:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae5:	eb 1f                	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 e8             	pushl  -0x18(%ebp)
  800aed:	8d 45 14             	lea    0x14(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	e8 e7 fb ff ff       	call   8006dd <getuint>
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b06:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	52                   	push   %edx
  800b11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b14:	50                   	push   %eax
  800b15:	ff 75 f4             	pushl  -0xc(%ebp)
  800b18:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	ff 75 08             	pushl  0x8(%ebp)
  800b21:	e8 00 fb ff ff       	call   800626 <printnum>
  800b26:	83 c4 20             	add    $0x20,%esp
			break;
  800b29:	eb 34                	jmp    800b5f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
			break;
  800b3a:	eb 23                	jmp    800b5f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 25                	push   $0x25
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4c:	ff 4d 10             	decl   0x10(%ebp)
  800b4f:	eb 03                	jmp    800b54 <vprintfmt+0x3b1>
  800b51:	ff 4d 10             	decl   0x10(%ebp)
  800b54:	8b 45 10             	mov    0x10(%ebp),%eax
  800b57:	48                   	dec    %eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	3c 25                	cmp    $0x25,%al
  800b5c:	75 f3                	jne    800b51 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b5e:	90                   	nop
		}
	}
  800b5f:	e9 47 fc ff ff       	jmp    8007ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b72:	8d 45 10             	lea    0x10(%ebp),%eax
  800b75:	83 c0 04             	add    $0x4,%eax
  800b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	50                   	push   %eax
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 16 fc ff ff       	call   8007a3 <vprintfmt>
  800b8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b90:	90                   	nop
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8b 40 08             	mov    0x8(%eax),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	8b 10                	mov    (%eax),%edx
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 40 04             	mov    0x4(%eax),%eax
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	73 12                	jae    800bc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	89 0a                	mov    %ecx,(%edx)
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	88 10                	mov    %dl,(%eax)
}
  800bc6:	90                   	nop
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	01 d0                	add    %edx,%eax
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 06                	je     800bf6 <vsnprintf+0x2d>
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	7f 07                	jg     800bfd <vsnprintf+0x34>
		return -E_INVAL;
  800bf6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfb:	eb 20                	jmp    800c1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfd:	ff 75 14             	pushl  0x14(%ebp)
  800c00:	ff 75 10             	pushl  0x10(%ebp)
  800c03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	68 93 0b 80 00       	push   $0x800b93
  800c0c:	e8 92 fb ff ff       	call   8007a3 <vprintfmt>
  800c11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c25:	8d 45 10             	lea    0x10(%ebp),%eax
  800c28:	83 c0 04             	add    $0x4,%eax
  800c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	50                   	push   %eax
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	ff 75 08             	pushl  0x8(%ebp)
  800c3b:	e8 89 ff ff ff       	call   800bc9 <vsnprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c58:	eb 06                	jmp    800c60 <strlen+0x15>
		n++;
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5d:	ff 45 08             	incl   0x8(%ebp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 f1                	jne    800c5a <strlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7b:	eb 09                	jmp    800c86 <strnlen+0x18>
		n++;
  800c7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	ff 4d 0c             	decl   0xc(%ebp)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 09                	je     800c95 <strnlen+0x27>
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 e8                	jne    800c7d <strnlen+0xf>
		n++;
	return n;
  800c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca6:	90                   	nop
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb9:	8a 12                	mov    (%edx),%dl
  800cbb:	88 10                	mov    %dl,(%eax)
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 e4                	jne    800ca7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdb:	eb 1f                	jmp    800cfc <strncpy+0x34>
		*dst++ = *src;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8d 50 01             	lea    0x1(%eax),%edx
  800ce3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 03                	je     800cf9 <strncpy+0x31>
			src++;
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf9:	ff 45 fc             	incl   -0x4(%ebp)
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d02:	72 d9                	jb     800cdd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	74 30                	je     800d4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1b:	eb 16                	jmp    800d33 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	89 55 08             	mov    %edx,0x8(%ebp)
  800d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2f:	8a 12                	mov    (%edx),%dl
  800d31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3a:	74 09                	je     800d45 <strlcpy+0x3c>
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	84 c0                	test   %al,%al
  800d43:	75 d8                	jne    800d1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5a:	eb 06                	jmp    800d62 <strcmp+0xb>
		p++, q++;
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	74 0e                	je     800d79 <strcmp+0x22>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 10                	mov    (%eax),%dl
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	38 c2                	cmp    %al,%dl
  800d77:	74 e3                	je     800d5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d92:	eb 09                	jmp    800d9d <strncmp+0xe>
		n--, p++, q++;
  800d94:	ff 4d 10             	decl   0x10(%ebp)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 17                	je     800dba <strncmp+0x2b>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	74 0e                	je     800dba <strncmp+0x2b>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 10                	mov    (%eax),%dl
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	38 c2                	cmp    %al,%dl
  800db8:	74 da                	je     800d94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbe:	75 07                	jne    800dc7 <strncmp+0x38>
		return 0;
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc5:	eb 14                	jmp    800ddb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de9:	eb 12                	jmp    800dfd <strchr+0x20>
		if (*s == c)
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df3:	75 05                	jne    800dfa <strchr+0x1d>
			return (char *) s;
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	eb 11                	jmp    800e0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	84 c0                	test   %al,%al
  800e04:	75 e5                	jne    800deb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 0d                	jmp    800e28 <strfind+0x1b>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	74 0e                	je     800e33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e25:	ff 45 08             	incl   0x8(%ebp)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 ea                	jne    800e1b <strfind+0xe>
  800e31:	eb 01                	jmp    800e34 <strfind+0x27>
		if (*s == c)
			break;
  800e33:	90                   	nop
	return (char *) s;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e4b:	eb 0e                	jmp    800e5b <memset+0x22>
		*p++ = c;
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e5b:	ff 4d f8             	decl   -0x8(%ebp)
  800e5e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e62:	79 e9                	jns    800e4d <memset+0x14>
		*p++ = c;

	return v;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e7b:	eb 16                	jmp    800e93 <memcpy+0x2a>
		*d++ = *s++;
  800e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 dd                	jne    800e7d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ebd:	73 50                	jae    800f0f <memmove+0x6a>
  800ebf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	76 43                	jbe    800f0f <memmove+0x6a>
		s += n;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 10                	jmp    800eea <memmove+0x45>
			*--d = *--s;
  800eda:	ff 4d f8             	decl   -0x8(%ebp)
  800edd:	ff 4d fc             	decl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 10                	mov    (%eax),%dl
  800ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	75 e3                	jne    800eda <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef7:	eb 23                	jmp    800f1c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f08:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 dd                	jne    800ef9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f33:	eb 2a                	jmp    800f5f <memcmp+0x3e>
		if (*s1 != *s2)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 16                	je     800f59 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	eb 18                	jmp    800f71 <memcmp+0x50>
		s1++, s2++;
  800f59:	ff 45 fc             	incl   -0x4(%ebp)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 c9                	jne    800f35 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f84:	eb 15                	jmp    800f9b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	39 c2                	cmp    %eax,%edx
  800f96:	74 0d                	je     800fa5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa1:	72 e3                	jb     800f86 <memfind+0x13>
  800fa3:	eb 01                	jmp    800fa6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa5:	90                   	nop
	return (void *) s;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fbf:	eb 03                	jmp    800fc4 <strtol+0x19>
		s++;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 20                	cmp    $0x20,%al
  800fcb:	74 f4                	je     800fc1 <strtol+0x16>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 09                	cmp    $0x9,%al
  800fd4:	74 eb                	je     800fc1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 2b                	cmp    $0x2b,%al
  800fdd:	75 05                	jne    800fe4 <strtol+0x39>
		s++;
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	eb 13                	jmp    800ff7 <strtol+0x4c>
	else if (*s == '-')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 2d                	cmp    $0x2d,%al
  800feb:	75 0a                	jne    800ff7 <strtol+0x4c>
		s++, neg = 1;
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	74 06                	je     801003 <strtol+0x58>
  800ffd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801001:	75 20                	jne    801023 <strtol+0x78>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 30                	cmp    $0x30,%al
  80100a:	75 17                	jne    801023 <strtol+0x78>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	40                   	inc    %eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 78                	cmp    $0x78,%al
  801014:	75 0d                	jne    801023 <strtol+0x78>
		s += 2, base = 16;
  801016:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801021:	eb 28                	jmp    80104b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	75 15                	jne    80103e <strtol+0x93>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 30                	cmp    $0x30,%al
  801030:	75 0c                	jne    80103e <strtol+0x93>
		s++, base = 8;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80103c:	eb 0d                	jmp    80104b <strtol+0xa0>
	else if (base == 0)
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 07                	jne    80104b <strtol+0xa0>
		base = 10;
  801044:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2f                	cmp    $0x2f,%al
  801052:	7e 19                	jle    80106d <strtol+0xc2>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 39                	cmp    $0x39,%al
  80105b:	7f 10                	jg     80106d <strtol+0xc2>
			dig = *s - '0';
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 30             	sub    $0x30,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106b:	eb 42                	jmp    8010af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 60                	cmp    $0x60,%al
  801074:	7e 19                	jle    80108f <strtol+0xe4>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 7a                	cmp    $0x7a,%al
  80107d:	7f 10                	jg     80108f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f be c0             	movsbl %al,%eax
  801087:	83 e8 57             	sub    $0x57,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108d:	eb 20                	jmp    8010af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 40                	cmp    $0x40,%al
  801096:	7e 39                	jle    8010d1 <strtol+0x126>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 5a                	cmp    $0x5a,%al
  80109f:	7f 30                	jg     8010d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 37             	sub    $0x37,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b5:	7d 19                	jge    8010d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010b7:	ff 45 08             	incl   0x8(%ebp)
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cb:	e9 7b ff ff ff       	jmp    80104b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d5:	74 08                	je     8010df <strtol+0x134>
		*endptr = (char *) s;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e3:	74 07                	je     8010ec <strtol+0x141>
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	f7 d8                	neg    %eax
  8010ea:	eb 03                	jmp    8010ef <strtol+0x144>
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	79 13                	jns    80111e <ltostr+0x2d>
	{
		neg = 1;
  80110b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801118:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801126:	99                   	cltd   
  801127:	f7 f9                	idiv   %ecx
  801129:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80112c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80113f:	83 c2 30             	add    $0x30,%edx
  801142:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114c:	f7 e9                	imul   %ecx
  80114e:	c1 fa 02             	sar    $0x2,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	c1 f8 1f             	sar    $0x1f,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80115d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801160:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801165:	f7 e9                	imul   %ecx
  801167:	c1 fa 02             	sar    $0x2,%edx
  80116a:	89 c8                	mov    %ecx,%eax
  80116c:	c1 f8 1f             	sar    $0x1f,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	c1 e0 02             	shl    $0x2,%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	01 c0                	add    %eax,%eax
  80117a:	29 c1                	sub    %eax,%ecx
  80117c:	89 ca                	mov    %ecx,%edx
  80117e:	85 d2                	test   %edx,%edx
  801180:	75 9c                	jne    80111e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	48                   	dec    %eax
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801194:	74 3d                	je     8011d3 <ltostr+0xe2>
		start = 1 ;
  801196:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80119d:	eb 34                	jmp    8011d3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c8                	add    %ecx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c c4                	jl     80119f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 54 fa ff ff       	call   800c4b <strlen>
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 46 fa ff ff       	call   800c4b <strlen>
  801205:	83 c4 04             	add    $0x4,%esp
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801219:	eb 17                	jmp    801232 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 c2                	add    %eax,%edx
  801223:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	01 c8                	add    %ecx,%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122f:	ff 45 fc             	incl   -0x4(%ebp)
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801238:	7c e1                	jl     80121b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801241:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801248:	eb 1f                	jmp    801269 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801266:	ff 45 f8             	incl   -0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126f:	7c d9                	jl     80124a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801271:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a2:	eb 0c                	jmp    8012b0 <strsplit+0x31>
			*string++ = 0;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	84 c0                	test   %al,%al
  8012b7:	74 18                	je     8012d1 <strsplit+0x52>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	e8 13 fb ff ff       	call   800ddd <strchr>
  8012ca:	83 c4 08             	add    $0x8,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 d3                	jne    8012a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	74 5a                	je     801334 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012da:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	83 f8 0f             	cmp    $0xf,%eax
  8012e2:	75 07                	jne    8012eb <strsplit+0x6c>
		{
			return 0;
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	eb 66                	jmp    801351 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f6:	89 0a                	mov    %ecx,(%edx)
  8012f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801309:	eb 03                	jmp    80130e <strsplit+0x8f>
			string++;
  80130b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	74 8b                	je     8012a2 <strsplit+0x23>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	50                   	push   %eax
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	e8 b5 fa ff ff       	call   800ddd <strchr>
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	74 dc                	je     80130b <strsplit+0x8c>
			string++;
	}
  80132f:	e9 6e ff ff ff       	jmp    8012a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801334:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80134c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801359:	a1 04 40 80 00       	mov    0x804004,%eax
  80135e:	85 c0                	test   %eax,%eax
  801360:	74 1f                	je     801381 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801362:	e8 1d 00 00 00       	call   801384 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	68 10 3b 80 00       	push   $0x803b10
  80136f:	e8 55 f2 ff ff       	call   8005c9 <cprintf>
  801374:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801377:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80137e:	00 00 00 
	}
}
  801381:	90                   	nop
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 28             	sub    $0x28,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] initialize_dyn_block_system
	// your code is here, remove the panic and write your code
	LIST_INIT(&FreeMemBlocksList);
  80138a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801391:	00 00 00 
  801394:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80139b:	00 00 00 
  80139e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013a5:	00 00 00 
	LIST_INIT(&AllocMemBlocksList);
  8013a8:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013af:	00 00 00 
  8013b2:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013b9:	00 00 00 
  8013bc:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013c3:	00 00 00 
	MAX_MEM_BLOCK_CNT=NUM_OF_UHEAP_PAGES;
  8013c6:	c7 05 20 41 80 00 00 	movl   $0x20000,0x804120
  8013cd:	00 02 00 
	MemBlockNodes= (struct MemBlock*)USER_DYN_BLKS_ARRAY;
  8013d0:	c7 45 f4 00 00 e0 7f 	movl   $0x7fe00000,-0xc(%ebp)
  8013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013da:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013df:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e4:	a3 50 40 80 00       	mov    %eax,0x804050
	uint32 NodeSize= ROUNDUP(sizeof(*MemBlockNodes)*MAX_MEM_BLOCK_CNT,PAGE_SIZE);
  8013e9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8013f0:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f5:	c1 e0 04             	shl    $0x4,%eax
  8013f8:	89 c2                	mov    %eax,%edx
  8013fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fd:	01 d0                	add    %edx,%eax
  8013ff:	48                   	dec    %eax
  801400:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801403:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801406:	ba 00 00 00 00       	mov    $0x0,%edx
  80140b:	f7 75 f0             	divl   -0x10(%ebp)
  80140e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801411:	29 d0                	sub    %edx,%eax
  801413:	89 45 e8             	mov    %eax,-0x18(%ebp)
	sys_allocate_chunk(USER_DYN_BLKS_ARRAY,NodeSize,PERM_WRITEABLE|PERM_USER);
  801416:	c7 45 e4 00 00 e0 7f 	movl   $0x7fe00000,-0x1c(%ebp)
  80141d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801420:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801425:	2d 00 10 00 00       	sub    $0x1000,%eax
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	6a 06                	push   $0x6
  80142f:	ff 75 e8             	pushl  -0x18(%ebp)
  801432:	50                   	push   %eax
  801433:	e8 b0 05 00 00       	call   8019e8 <sys_allocate_chunk>
  801438:	83 c4 10             	add    $0x10,%esp
	initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80143b:	a1 20 41 80 00       	mov    0x804120,%eax
  801440:	83 ec 0c             	sub    $0xc,%esp
  801443:	50                   	push   %eax
  801444:	e8 25 0c 00 00       	call   80206e <initialize_MemBlocksList>
  801449:	83 c4 10             	add    $0x10,%esp
	struct MemBlock*element=LIST_FIRST(&AvailableMemBlocksList);
  80144c:	a1 48 41 80 00       	mov    0x804148,%eax
  801451:	89 45 e0             	mov    %eax,-0x20(%ebp)
	LIST_REMOVE(&AvailableMemBlocksList,element);
  801454:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801458:	75 14                	jne    80146e <initialize_dyn_block_system+0xea>
  80145a:	83 ec 04             	sub    $0x4,%esp
  80145d:	68 35 3b 80 00       	push   $0x803b35
  801462:	6a 29                	push   $0x29
  801464:	68 53 3b 80 00       	push   $0x803b53
  801469:	e8 a7 ee ff ff       	call   800315 <_panic>
  80146e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801471:	8b 00                	mov    (%eax),%eax
  801473:	85 c0                	test   %eax,%eax
  801475:	74 10                	je     801487 <initialize_dyn_block_system+0x103>
  801477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80147f:	8b 52 04             	mov    0x4(%edx),%edx
  801482:	89 50 04             	mov    %edx,0x4(%eax)
  801485:	eb 0b                	jmp    801492 <initialize_dyn_block_system+0x10e>
  801487:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80148a:	8b 40 04             	mov    0x4(%eax),%eax
  80148d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801495:	8b 40 04             	mov    0x4(%eax),%eax
  801498:	85 c0                	test   %eax,%eax
  80149a:	74 0f                	je     8014ab <initialize_dyn_block_system+0x127>
  80149c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80149f:	8b 40 04             	mov    0x4(%eax),%eax
  8014a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8014a5:	8b 12                	mov    (%edx),%edx
  8014a7:	89 10                	mov    %edx,(%eax)
  8014a9:	eb 0a                	jmp    8014b5 <initialize_dyn_block_system+0x131>
  8014ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ae:	8b 00                	mov    (%eax),%eax
  8014b0:	a3 48 41 80 00       	mov    %eax,0x804148
  8014b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014b8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014c1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014c8:	a1 54 41 80 00       	mov    0x804154,%eax
  8014cd:	48                   	dec    %eax
  8014ce:	a3 54 41 80 00       	mov    %eax,0x804154
	//uint32 end_adr = NUM_OF_UHEAP_PAGES - USER_DYN_BLKS_ARRAY;
	element->size=(USER_HEAP_MAX - USER_HEAP_START);
  8014d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014d6:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
	element->sva=USER_HEAP_START;
  8014dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014e0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
	insert_sorted_with_merge_freeList(element);
  8014e7:	83 ec 0c             	sub    $0xc,%esp
  8014ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8014ed:	e8 b9 14 00 00       	call   8029ab <insert_sorted_with_merge_freeList>
  8014f2:	83 c4 10             	add    $0x10,%esp

}
  8014f5:	90                   	nop
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
  8014fb:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014fe:	e8 50 fe ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  801503:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801507:	75 07                	jne    801510 <malloc+0x18>
  801509:	b8 00 00 00 00       	mov    $0x0,%eax
  80150e:	eb 68                	jmp    801578 <malloc+0x80>
	//==============================================================
	//==============================================================

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
	// your code is here, remove the panic and write your code
	uint32 Target_size= ROUNDUP(size,PAGE_SIZE);
  801510:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801517:	8b 55 08             	mov    0x8(%ebp),%edx
  80151a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80151d:	01 d0                	add    %edx,%eax
  80151f:	48                   	dec    %eax
  801520:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801523:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801526:	ba 00 00 00 00       	mov    $0x0,%edx
  80152b:	f7 75 f4             	divl   -0xc(%ebp)
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	29 d0                	sub    %edx,%eax
  801533:	89 45 ec             	mov    %eax,-0x14(%ebp)
	struct MemBlock* blk=NULL ;
  801536:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80153d:	e8 74 08 00 00       	call   801db6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801542:	85 c0                	test   %eax,%eax
  801544:	74 2d                	je     801573 <malloc+0x7b>
	{
		blk=alloc_block_FF(Target_size);
  801546:	83 ec 0c             	sub    $0xc,%esp
  801549:	ff 75 ec             	pushl  -0x14(%ebp)
  80154c:	e8 52 0e 00 00       	call   8023a3 <alloc_block_FF>
  801551:	83 c4 10             	add    $0x10,%esp
  801554:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(blk!=NULL)
  801557:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80155b:	74 16                	je     801573 <malloc+0x7b>
		{

			 insert_sorted_allocList(blk);
  80155d:	83 ec 0c             	sub    $0xc,%esp
  801560:	ff 75 e8             	pushl  -0x18(%ebp)
  801563:	e8 3b 0c 00 00       	call   8021a3 <insert_sorted_allocList>
  801568:	83 c4 10             	add    $0x10,%esp
			 return (void *)blk->sva;
  80156b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80156e:	8b 40 08             	mov    0x8(%eax),%eax
  801571:	eb 05                	jmp    801578 <malloc+0x80>
			 //return pointer containing the virtual address of allocated space
	    }
	}
		// no suitable space found
		return NULL;
  801573:	b8 00 00 00 00       	mov    $0x0,%eax

}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
  80157d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code
	struct MemBlock* blk ;
	blk=find_block(&AllocMemBlocksList,(uint32 )virtual_address);
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	83 ec 08             	sub    $0x8,%esp
  801586:	50                   	push   %eax
  801587:	68 40 40 80 00       	push   $0x804040
  80158c:	e8 ba 0b 00 00       	call   80214b <find_block>
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32 size=blk->size;
  801597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80159a:	8b 40 0c             	mov    0xc(%eax),%eax
  80159d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if(blk!=NULL){
  8015a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015a4:	0f 84 9f 00 00 00    	je     801649 <free+0xcf>
		//to free the allocation from the memory & page file
		sys_free_user_mem((uint32 )virtual_address,size);
  8015aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ad:	83 ec 08             	sub    $0x8,%esp
  8015b0:	ff 75 f0             	pushl  -0x10(%ebp)
  8015b3:	50                   	push   %eax
  8015b4:	e8 f7 03 00 00       	call   8019b0 <sys_free_user_mem>
  8015b9:	83 c4 10             	add    $0x10,%esp
		LIST_REMOVE(&AllocMemBlocksList,blk);
  8015bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015c0:	75 14                	jne    8015d6 <free+0x5c>
  8015c2:	83 ec 04             	sub    $0x4,%esp
  8015c5:	68 35 3b 80 00       	push   $0x803b35
  8015ca:	6a 6a                	push   $0x6a
  8015cc:	68 53 3b 80 00       	push   $0x803b53
  8015d1:	e8 3f ed ff ff       	call   800315 <_panic>
  8015d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d9:	8b 00                	mov    (%eax),%eax
  8015db:	85 c0                	test   %eax,%eax
  8015dd:	74 10                	je     8015ef <free+0x75>
  8015df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e2:	8b 00                	mov    (%eax),%eax
  8015e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015e7:	8b 52 04             	mov    0x4(%edx),%edx
  8015ea:	89 50 04             	mov    %edx,0x4(%eax)
  8015ed:	eb 0b                	jmp    8015fa <free+0x80>
  8015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015f2:	8b 40 04             	mov    0x4(%eax),%eax
  8015f5:	a3 44 40 80 00       	mov    %eax,0x804044
  8015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015fd:	8b 40 04             	mov    0x4(%eax),%eax
  801600:	85 c0                	test   %eax,%eax
  801602:	74 0f                	je     801613 <free+0x99>
  801604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801607:	8b 40 04             	mov    0x4(%eax),%eax
  80160a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160d:	8b 12                	mov    (%edx),%edx
  80160f:	89 10                	mov    %edx,(%eax)
  801611:	eb 0a                	jmp    80161d <free+0xa3>
  801613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801616:	8b 00                	mov    (%eax),%eax
  801618:	a3 40 40 80 00       	mov    %eax,0x804040
  80161d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801620:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801629:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801630:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801635:	48                   	dec    %eax
  801636:	a3 4c 40 80 00       	mov    %eax,0x80404c
		insert_sorted_with_merge_freeList(blk);
  80163b:	83 ec 0c             	sub    $0xc,%esp
  80163e:	ff 75 f4             	pushl  -0xc(%ebp)
  801641:	e8 65 13 00 00       	call   8029ab <insert_sorted_with_merge_freeList>
  801646:	83 c4 10             	add    $0x10,%esp
	}
}
  801649:	90                   	nop
  80164a:	c9                   	leave  
  80164b:	c3                   	ret    

0080164c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	83 ec 28             	sub    $0x28,%esp
  801652:	8b 45 10             	mov    0x10(%ebp),%eax
  801655:	88 45 e4             	mov    %al,-0x1c(%ebp)
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801658:	e8 f6 fc ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  80165d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801661:	75 0a                	jne    80166d <smalloc+0x21>
  801663:	b8 00 00 00 00       	mov    $0x0,%eax
  801668:	e9 af 00 00 00       	jmp    80171c <smalloc+0xd0>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	if(sys_isUHeapPlacementStrategyFIRSTFIT()==1)
  80166d:	e8 44 07 00 00       	call   801db6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801672:	83 f8 01             	cmp    $0x1,%eax
  801675:	0f 85 9c 00 00 00    	jne    801717 <smalloc+0xcb>
	{
		struct MemBlock * blk;
		size = ROUNDUP(size,PAGE_SIZE);
  80167b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801682:	8b 55 0c             	mov    0xc(%ebp),%edx
  801685:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	48                   	dec    %eax
  80168b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80168e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801691:	ba 00 00 00 00       	mov    $0x0,%edx
  801696:	f7 75 f4             	divl   -0xc(%ebp)
  801699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169c:	29 d0                	sub    %edx,%eax
  80169e:	89 45 0c             	mov    %eax,0xc(%ebp)
		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
  8016a1:	81 7d 0c ff ff ff 1f 	cmpl   $0x1fffffff,0xc(%ebp)
  8016a8:	76 07                	jbe    8016b1 <smalloc+0x65>
			return NULL;
  8016aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016af:	eb 6b                	jmp    80171c <smalloc+0xd0>
		blk =alloc_block_FF(size);
  8016b1:	83 ec 0c             	sub    $0xc,%esp
  8016b4:	ff 75 0c             	pushl  0xc(%ebp)
  8016b7:	e8 e7 0c 00 00       	call   8023a3 <alloc_block_FF>
  8016bc:	83 c4 10             	add    $0x10,%esp
  8016bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		insert_sorted_allocList(blk);
  8016c2:	83 ec 0c             	sub    $0xc,%esp
  8016c5:	ff 75 ec             	pushl  -0x14(%ebp)
  8016c8:	e8 d6 0a 00 00       	call   8021a3 <insert_sorted_allocList>
  8016cd:	83 c4 10             	add    $0x10,%esp
		if(blk == NULL)
  8016d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8016d4:	75 07                	jne    8016dd <smalloc+0x91>
		{
			return NULL;
  8016d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016db:	eb 3f                	jmp    80171c <smalloc+0xd0>
		}
		int ret = sys_createSharedObject(sharedVarName,size,isWritable,(void* )blk->sva);
  8016dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e0:	8b 40 08             	mov    0x8(%eax),%eax
  8016e3:	89 c2                	mov    %eax,%edx
  8016e5:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
  8016e9:	52                   	push   %edx
  8016ea:	50                   	push   %eax
  8016eb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ee:	ff 75 08             	pushl  0x8(%ebp)
  8016f1:	e8 45 04 00 00       	call   801b3b <sys_createSharedObject>
  8016f6:	83 c4 10             	add    $0x10,%esp
  8016f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(ret == E_NO_SHARE || ret == E_SHARED_MEM_EXISTS)
  8016fc:	83 7d e8 f2          	cmpl   $0xfffffff2,-0x18(%ebp)
  801700:	74 06                	je     801708 <smalloc+0xbc>
  801702:	83 7d e8 f1          	cmpl   $0xfffffff1,-0x18(%ebp)
  801706:	75 07                	jne    80170f <smalloc+0xc3>
		{
			return NULL;
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
  80170d:	eb 0d                	jmp    80171c <smalloc+0xd0>
		}
		else
		{

			return (void*)blk->sva;
  80170f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801712:	8b 40 08             	mov    0x8(%eax),%eax
  801715:	eb 05                	jmp    80171c <smalloc+0xd0>
		}
	}
	else
		return NULL;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80171c:	c9                   	leave  
  80171d:	c3                   	ret    

0080171e <sget>:

//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801724:	e8 2a fc ff ff       	call   801353 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	int size = sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801729:	83 ec 08             	sub    $0x8,%esp
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	e8 2e 04 00 00       	call   801b65 <sys_getSizeOfSharedObject>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if(size == E_SHARED_MEM_NOT_EXISTS)
  80173d:	83 7d f4 f0          	cmpl   $0xfffffff0,-0xc(%ebp)
  801741:	75 0a                	jne    80174d <sget+0x2f>
	{
		return NULL;
  801743:	b8 00 00 00 00       	mov    $0x0,%eax
  801748:	e9 94 00 00 00       	jmp    8017e1 <sget+0xc3>
	}
	if(sys_isUHeapPlacementStrategyFIRSTFIT())
  80174d:	e8 64 06 00 00       	call   801db6 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801752:	85 c0                	test   %eax,%eax
  801754:	0f 84 82 00 00 00    	je     8017dc <sget+0xbe>
	{

		struct MemBlock * blk=NULL;
  80175a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		size = ROUNDUP(size,PAGE_SIZE);
  801761:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801768:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176e:	01 d0                	add    %edx,%eax
  801770:	48                   	dec    %eax
  801771:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801774:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801777:	ba 00 00 00 00       	mov    $0x0,%edx
  80177c:	f7 75 ec             	divl   -0x14(%ebp)
  80177f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801782:	29 d0                	sub    %edx,%eax
  801784:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//		if(size >= (USER_HEAP_MAX-USER_HEAP_START))
	//			return NULL;
		blk =alloc_block_FF(size);
  801787:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80178a:	83 ec 0c             	sub    $0xc,%esp
  80178d:	50                   	push   %eax
  80178e:	e8 10 0c 00 00       	call   8023a3 <alloc_block_FF>
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if(blk == NULL)
  801799:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80179d:	75 07                	jne    8017a6 <sget+0x88>
		{
			return NULL;
  80179f:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a4:	eb 3b                	jmp    8017e1 <sget+0xc3>
		}
	//		insert_sorted_allocList(blk);
		int ret = sys_getSharedObject(ownerEnvID,sharedVarName,(void*)blk->sva);
  8017a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017a9:	8b 40 08             	mov    0x8(%eax),%eax
  8017ac:	83 ec 04             	sub    $0x4,%esp
  8017af:	50                   	push   %eax
  8017b0:	ff 75 0c             	pushl  0xc(%ebp)
  8017b3:	ff 75 08             	pushl  0x8(%ebp)
  8017b6:	e8 c7 03 00 00       	call   801b82 <sys_getSharedObject>
  8017bb:	83 c4 10             	add    $0x10,%esp
  8017be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(ret == E_SHARED_MEM_NOT_EXISTS || ret == E_NO_SHARE)
  8017c1:	83 7d e4 f0          	cmpl   $0xfffffff0,-0x1c(%ebp)
  8017c5:	74 06                	je     8017cd <sget+0xaf>
  8017c7:	83 7d e4 f2          	cmpl   $0xfffffff2,-0x1c(%ebp)
  8017cb:	75 07                	jne    8017d4 <sget+0xb6>
		{
			return NULL;
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d2:	eb 0d                	jmp    8017e1 <sget+0xc3>
		}
		else
		{
			return (void*)blk->sva;
  8017d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d7:	8b 40 08             	mov    0x8(%eax),%eax
  8017da:	eb 05                	jmp    8017e1 <sget+0xc3>
		}
	}
	else
			return NULL;
  8017dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e1:	c9                   	leave  
  8017e2:	c3                   	ret    

008017e3 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017e3:	55                   	push   %ebp
  8017e4:	89 e5                	mov    %esp,%ebp
  8017e6:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017e9:	e8 65 fb ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017ee:	83 ec 04             	sub    $0x4,%esp
  8017f1:	68 60 3b 80 00       	push   $0x803b60
  8017f6:	68 e1 00 00 00       	push   $0xe1
  8017fb:	68 53 3b 80 00       	push   $0x803b53
  801800:	e8 10 eb ff ff       	call   800315 <_panic>

00801805 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80180b:	83 ec 04             	sub    $0x4,%esp
  80180e:	68 88 3b 80 00       	push   $0x803b88
  801813:	68 f5 00 00 00       	push   $0xf5
  801818:	68 53 3b 80 00       	push   $0x803b53
  80181d:	e8 f3 ea ff ff       	call   800315 <_panic>

00801822 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801822:	55                   	push   %ebp
  801823:	89 e5                	mov    %esp,%ebp
  801825:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801828:	83 ec 04             	sub    $0x4,%esp
  80182b:	68 ac 3b 80 00       	push   $0x803bac
  801830:	68 00 01 00 00       	push   $0x100
  801835:	68 53 3b 80 00       	push   $0x803b53
  80183a:	e8 d6 ea ff ff       	call   800315 <_panic>

0080183f <shrink>:

}
void shrink(uint32 newSize)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801845:	83 ec 04             	sub    $0x4,%esp
  801848:	68 ac 3b 80 00       	push   $0x803bac
  80184d:	68 05 01 00 00       	push   $0x105
  801852:	68 53 3b 80 00       	push   $0x803b53
  801857:	e8 b9 ea ff ff       	call   800315 <_panic>

0080185c <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	68 ac 3b 80 00       	push   $0x803bac
  80186a:	68 0a 01 00 00       	push   $0x10a
  80186f:	68 53 3b 80 00       	push   $0x803b53
  801874:	e8 9c ea ff ff       	call   800315 <_panic>

00801879 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801879:	55                   	push   %ebp
  80187a:	89 e5                	mov    %esp,%ebp
  80187c:	57                   	push   %edi
  80187d:	56                   	push   %esi
  80187e:	53                   	push   %ebx
  80187f:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801882:	8b 45 08             	mov    0x8(%ebp),%eax
  801885:	8b 55 0c             	mov    0xc(%ebp),%edx
  801888:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188e:	8b 7d 18             	mov    0x18(%ebp),%edi
  801891:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801894:	cd 30                	int    $0x30
  801896:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801899:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189c:	83 c4 10             	add    $0x10,%esp
  80189f:	5b                   	pop    %ebx
  8018a0:	5e                   	pop    %esi
  8018a1:	5f                   	pop    %edi
  8018a2:	5d                   	pop    %ebp
  8018a3:	c3                   	ret    

008018a4 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 04             	sub    $0x4,%esp
  8018aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ad:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018b0:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	52                   	push   %edx
  8018bc:	ff 75 0c             	pushl  0xc(%ebp)
  8018bf:	50                   	push   %eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	e8 b2 ff ff ff       	call   801879 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
}
  8018ca:	90                   	nop
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_cgetc>:

int
sys_cgetc(void)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 01                	push   $0x1
  8018dc:	e8 98 ff ff ff       	call   801879 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	6a 00                	push   $0x0
  8018f1:	6a 00                	push   $0x0
  8018f3:	6a 00                	push   $0x0
  8018f5:	52                   	push   %edx
  8018f6:	50                   	push   %eax
  8018f7:	6a 05                	push   $0x5
  8018f9:	e8 7b ff ff ff       	call   801879 <syscall>
  8018fe:	83 c4 18             	add    $0x18,%esp
}
  801901:	c9                   	leave  
  801902:	c3                   	ret    

00801903 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	56                   	push   %esi
  801907:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801908:	8b 75 18             	mov    0x18(%ebp),%esi
  80190b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801911:	8b 55 0c             	mov    0xc(%ebp),%edx
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	56                   	push   %esi
  801918:	53                   	push   %ebx
  801919:	51                   	push   %ecx
  80191a:	52                   	push   %edx
  80191b:	50                   	push   %eax
  80191c:	6a 06                	push   $0x6
  80191e:	e8 56 ff ff ff       	call   801879 <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801929:	5b                   	pop    %ebx
  80192a:	5e                   	pop    %esi
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    

0080192d <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801930:	8b 55 0c             	mov    0xc(%ebp),%edx
  801933:	8b 45 08             	mov    0x8(%ebp),%eax
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	52                   	push   %edx
  80193d:	50                   	push   %eax
  80193e:	6a 07                	push   $0x7
  801940:	e8 34 ff ff ff       	call   801879 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	ff 75 08             	pushl  0x8(%ebp)
  801959:	6a 08                	push   $0x8
  80195b:	e8 19 ff ff ff       	call   801879 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 09                	push   $0x9
  801974:	e8 00 ff ff ff       	call   801879 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 0a                	push   $0xa
  80198d:	e8 e7 fe ff ff       	call   801879 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 0b                	push   $0xb
  8019a6:	e8 ce fe ff ff       	call   801879 <syscall>
  8019ab:	83 c4 18             	add    $0x18,%esp
}
  8019ae:	c9                   	leave  
  8019af:	c3                   	ret    

008019b0 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	ff 75 0c             	pushl  0xc(%ebp)
  8019bc:	ff 75 08             	pushl  0x8(%ebp)
  8019bf:	6a 0f                	push   $0xf
  8019c1:	e8 b3 fe ff ff       	call   801879 <syscall>
  8019c6:	83 c4 18             	add    $0x18,%esp
	return;
  8019c9:	90                   	nop
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	6a 10                	push   $0x10
  8019dd:	e8 97 fe ff ff       	call   801879 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e5:	90                   	nop
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	ff 75 10             	pushl  0x10(%ebp)
  8019f2:	ff 75 0c             	pushl  0xc(%ebp)
  8019f5:	ff 75 08             	pushl  0x8(%ebp)
  8019f8:	6a 11                	push   $0x11
  8019fa:	e8 7a fe ff ff       	call   801879 <syscall>
  8019ff:	83 c4 18             	add    $0x18,%esp
	return ;
  801a02:	90                   	nop
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 0c                	push   $0xc
  801a14:	e8 60 fe ff ff       	call   801879 <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    

00801a1e <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a1e:	55                   	push   %ebp
  801a1f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	6a 00                	push   $0x0
  801a27:	6a 00                	push   $0x0
  801a29:	ff 75 08             	pushl  0x8(%ebp)
  801a2c:	6a 0d                	push   $0xd
  801a2e:	e8 46 fe ff ff       	call   801879 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 0e                	push   $0xe
  801a47:	e8 2d fe ff ff       	call   801879 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	90                   	nop
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 13                	push   $0x13
  801a61:	e8 13 fe ff ff       	call   801879 <syscall>
  801a66:	83 c4 18             	add    $0x18,%esp
}
  801a69:	90                   	nop
  801a6a:	c9                   	leave  
  801a6b:	c3                   	ret    

00801a6c <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 14                	push   $0x14
  801a7b:	e8 f9 fd ff ff       	call   801879 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	90                   	nop
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 04             	sub    $0x4,%esp
  801a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a92:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	50                   	push   %eax
  801a9f:	6a 15                	push   $0x15
  801aa1:	e8 d3 fd ff ff       	call   801879 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	90                   	nop
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 16                	push   $0x16
  801abb:	e8 b9 fd ff ff       	call   801879 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	90                   	nop
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	ff 75 0c             	pushl  0xc(%ebp)
  801ad5:	50                   	push   %eax
  801ad6:	6a 17                	push   $0x17
  801ad8:	e8 9c fd ff ff       	call   801879 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	52                   	push   %edx
  801af2:	50                   	push   %eax
  801af3:	6a 1a                	push   $0x1a
  801af5:	e8 7f fd ff ff       	call   801879 <syscall>
  801afa:	83 c4 18             	add    $0x18,%esp
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	6a 00                	push   $0x0
  801b0a:	6a 00                	push   $0x0
  801b0c:	6a 00                	push   $0x0
  801b0e:	52                   	push   %edx
  801b0f:	50                   	push   %eax
  801b10:	6a 18                	push   $0x18
  801b12:	e8 62 fd ff ff       	call   801879 <syscall>
  801b17:	83 c4 18             	add    $0x18,%esp
}
  801b1a:	90                   	nop
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    

00801b1d <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b1d:	55                   	push   %ebp
  801b1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	52                   	push   %edx
  801b2d:	50                   	push   %eax
  801b2e:	6a 19                	push   $0x19
  801b30:	e8 44 fd ff ff       	call   801879 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	90                   	nop
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 04             	sub    $0x4,%esp
  801b41:	8b 45 10             	mov    0x10(%ebp),%eax
  801b44:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b47:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b4a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	51                   	push   %ecx
  801b54:	52                   	push   %edx
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	50                   	push   %eax
  801b59:	6a 1b                	push   $0x1b
  801b5b:	e8 19 fd ff ff       	call   801879 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b68:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6e:	6a 00                	push   $0x0
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	52                   	push   %edx
  801b75:	50                   	push   %eax
  801b76:	6a 1c                	push   $0x1c
  801b78:	e8 fc fc ff ff       	call   801879 <syscall>
  801b7d:	83 c4 18             	add    $0x18,%esp
}
  801b80:	c9                   	leave  
  801b81:	c3                   	ret    

00801b82 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b82:	55                   	push   %ebp
  801b83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b85:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b88:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	51                   	push   %ecx
  801b93:	52                   	push   %edx
  801b94:	50                   	push   %eax
  801b95:	6a 1d                	push   $0x1d
  801b97:	e8 dd fc ff ff       	call   801879 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	52                   	push   %edx
  801bb1:	50                   	push   %eax
  801bb2:	6a 1e                	push   $0x1e
  801bb4:	e8 c0 fc ff ff       	call   801879 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 1f                	push   $0x1f
  801bcd:	e8 a7 fc ff ff       	call   801879 <syscall>
  801bd2:	83 c4 18             	add    $0x18,%esp
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bda:	8b 45 08             	mov    0x8(%ebp),%eax
  801bdd:	6a 00                	push   $0x0
  801bdf:	ff 75 14             	pushl  0x14(%ebp)
  801be2:	ff 75 10             	pushl  0x10(%ebp)
  801be5:	ff 75 0c             	pushl  0xc(%ebp)
  801be8:	50                   	push   %eax
  801be9:	6a 20                	push   $0x20
  801beb:	e8 89 fc ff ff       	call   801879 <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 00                	push   $0x0
  801c03:	50                   	push   %eax
  801c04:	6a 21                	push   $0x21
  801c06:	e8 6e fc ff ff       	call   801879 <syscall>
  801c0b:	83 c4 18             	add    $0x18,%esp
}
  801c0e:	90                   	nop
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	50                   	push   %eax
  801c20:	6a 22                	push   $0x22
  801c22:	e8 52 fc ff ff       	call   801879 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 02                	push   $0x2
  801c3b:	e8 39 fc ff ff       	call   801879 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 03                	push   $0x3
  801c54:	e8 20 fc ff ff       	call   801879 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 04                	push   $0x4
  801c6d:	e8 07 fc ff ff       	call   801879 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	c9                   	leave  
  801c76:	c3                   	ret    

00801c77 <sys_exit_env>:


void sys_exit_env(void)
{
  801c77:	55                   	push   %ebp
  801c78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 23                	push   $0x23
  801c86:	e8 ee fb ff ff       	call   801879 <syscall>
  801c8b:	83 c4 18             	add    $0x18,%esp
}
  801c8e:	90                   	nop
  801c8f:	c9                   	leave  
  801c90:	c3                   	ret    

00801c91 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c91:	55                   	push   %ebp
  801c92:	89 e5                	mov    %esp,%ebp
  801c94:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c97:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c9a:	8d 50 04             	lea    0x4(%eax),%edx
  801c9d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	52                   	push   %edx
  801ca7:	50                   	push   %eax
  801ca8:	6a 24                	push   $0x24
  801caa:	e8 ca fb ff ff       	call   801879 <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
	return result;
  801cb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cbb:	89 01                	mov    %eax,(%ecx)
  801cbd:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	c9                   	leave  
  801cc4:	c2 04 00             	ret    $0x4

00801cc7 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cca:	6a 00                	push   $0x0
  801ccc:	6a 00                	push   $0x0
  801cce:	ff 75 10             	pushl  0x10(%ebp)
  801cd1:	ff 75 0c             	pushl  0xc(%ebp)
  801cd4:	ff 75 08             	pushl  0x8(%ebp)
  801cd7:	6a 12                	push   $0x12
  801cd9:	e8 9b fb ff ff       	call   801879 <syscall>
  801cde:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce1:	90                   	nop
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 25                	push   $0x25
  801cf3:	e8 81 fb ff ff       	call   801879 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
}
  801cfb:	c9                   	leave  
  801cfc:	c3                   	ret    

00801cfd <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cfd:	55                   	push   %ebp
  801cfe:	89 e5                	mov    %esp,%ebp
  801d00:	83 ec 04             	sub    $0x4,%esp
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d09:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	50                   	push   %eax
  801d16:	6a 26                	push   $0x26
  801d18:	e8 5c fb ff ff       	call   801879 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d20:	90                   	nop
}
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <rsttst>:
void rsttst()
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 28                	push   $0x28
  801d32:	e8 42 fb ff ff       	call   801879 <syscall>
  801d37:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3a:	90                   	nop
}
  801d3b:	c9                   	leave  
  801d3c:	c3                   	ret    

00801d3d <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d3d:	55                   	push   %ebp
  801d3e:	89 e5                	mov    %esp,%ebp
  801d40:	83 ec 04             	sub    $0x4,%esp
  801d43:	8b 45 14             	mov    0x14(%ebp),%eax
  801d46:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d49:	8b 55 18             	mov    0x18(%ebp),%edx
  801d4c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d50:	52                   	push   %edx
  801d51:	50                   	push   %eax
  801d52:	ff 75 10             	pushl  0x10(%ebp)
  801d55:	ff 75 0c             	pushl  0xc(%ebp)
  801d58:	ff 75 08             	pushl  0x8(%ebp)
  801d5b:	6a 27                	push   $0x27
  801d5d:	e8 17 fb ff ff       	call   801879 <syscall>
  801d62:	83 c4 18             	add    $0x18,%esp
	return ;
  801d65:	90                   	nop
}
  801d66:	c9                   	leave  
  801d67:	c3                   	ret    

00801d68 <chktst>:
void chktst(uint32 n)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	ff 75 08             	pushl  0x8(%ebp)
  801d76:	6a 29                	push   $0x29
  801d78:	e8 fc fa ff ff       	call   801879 <syscall>
  801d7d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d80:	90                   	nop
}
  801d81:	c9                   	leave  
  801d82:	c3                   	ret    

00801d83 <inctst>:

void inctst()
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 2a                	push   $0x2a
  801d92:	e8 e2 fa ff ff       	call   801879 <syscall>
  801d97:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9a:	90                   	nop
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <gettst>:
uint32 gettst()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801da0:	6a 00                	push   $0x0
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 2b                	push   $0x2b
  801dac:	e8 c8 fa ff ff       	call   801879 <syscall>
  801db1:	83 c4 18             	add    $0x18,%esp
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 2c                	push   $0x2c
  801dc8:	e8 ac fa ff ff       	call   801879 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
  801dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dd3:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dd7:	75 07                	jne    801de0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801dde:	eb 05                	jmp    801de5 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	6a 2c                	push   $0x2c
  801df9:	e8 7b fa ff ff       	call   801879 <syscall>
  801dfe:	83 c4 18             	add    $0x18,%esp
  801e01:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e04:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e08:	75 07                	jne    801e11 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0f:	eb 05                	jmp    801e16 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e16:	c9                   	leave  
  801e17:	c3                   	ret    

00801e18 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 2c                	push   $0x2c
  801e2a:	e8 4a fa ff ff       	call   801879 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
  801e32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e35:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e39:	75 07                	jne    801e42 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e3b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e40:	eb 05                	jmp    801e47 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    

00801e49 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e49:	55                   	push   %ebp
  801e4a:	89 e5                	mov    %esp,%ebp
  801e4c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 2c                	push   $0x2c
  801e5b:	e8 19 fa ff ff       	call   801879 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
  801e63:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e66:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e6a:	75 07                	jne    801e73 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e6c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e71:	eb 05                	jmp    801e78 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	ff 75 08             	pushl  0x8(%ebp)
  801e88:	6a 2d                	push   $0x2d
  801e8a:	e8 ea f9 ff ff       	call   801879 <syscall>
  801e8f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e92:	90                   	nop
}
  801e93:	c9                   	leave  
  801e94:	c3                   	ret    

00801e95 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e95:	55                   	push   %ebp
  801e96:	89 e5                	mov    %esp,%ebp
  801e98:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e99:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e9c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	53                   	push   %ebx
  801ea8:	51                   	push   %ecx
  801ea9:	52                   	push   %edx
  801eaa:	50                   	push   %eax
  801eab:	6a 2e                	push   $0x2e
  801ead:	e8 c7 f9 ff ff       	call   801879 <syscall>
  801eb2:	83 c4 18             	add    $0x18,%esp
}
  801eb5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb8:	c9                   	leave  
  801eb9:	c3                   	ret    

00801eba <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eba:	55                   	push   %ebp
  801ebb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ebd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	52                   	push   %edx
  801eca:	50                   	push   %eax
  801ecb:	6a 2f                	push   $0x2f
  801ecd:	e8 a7 f9 ff ff       	call   801879 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	68 bc 3b 80 00       	push   $0x803bbc
  801ee5:	e8 df e6 ff ff       	call   8005c9 <cprintf>
  801eea:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ef4:	83 ec 0c             	sub    $0xc,%esp
  801ef7:	68 e8 3b 80 00       	push   $0x803be8
  801efc:	e8 c8 e6 ff ff       	call   8005c9 <cprintf>
  801f01:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f04:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f08:	a1 38 41 80 00       	mov    0x804138,%eax
  801f0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f10:	eb 56                	jmp    801f68 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f12:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f16:	74 1c                	je     801f34 <print_mem_block_lists+0x5d>
  801f18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1b:	8b 50 08             	mov    0x8(%eax),%edx
  801f1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f21:	8b 48 08             	mov    0x8(%eax),%ecx
  801f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f27:	8b 40 0c             	mov    0xc(%eax),%eax
  801f2a:	01 c8                	add    %ecx,%eax
  801f2c:	39 c2                	cmp    %eax,%edx
  801f2e:	73 04                	jae    801f34 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f30:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f37:	8b 50 08             	mov    0x8(%eax),%edx
  801f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f40:	01 c2                	add    %eax,%edx
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 40 08             	mov    0x8(%eax),%eax
  801f48:	83 ec 04             	sub    $0x4,%esp
  801f4b:	52                   	push   %edx
  801f4c:	50                   	push   %eax
  801f4d:	68 fd 3b 80 00       	push   $0x803bfd
  801f52:	e8 72 e6 ff ff       	call   8005c9 <cprintf>
  801f57:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f60:	a1 40 41 80 00       	mov    0x804140,%eax
  801f65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6c:	74 07                	je     801f75 <print_mem_block_lists+0x9e>
  801f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f71:	8b 00                	mov    (%eax),%eax
  801f73:	eb 05                	jmp    801f7a <print_mem_block_lists+0xa3>
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7a:	a3 40 41 80 00       	mov    %eax,0x804140
  801f7f:	a1 40 41 80 00       	mov    0x804140,%eax
  801f84:	85 c0                	test   %eax,%eax
  801f86:	75 8a                	jne    801f12 <print_mem_block_lists+0x3b>
  801f88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8c:	75 84                	jne    801f12 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f8e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f92:	75 10                	jne    801fa4 <print_mem_block_lists+0xcd>
  801f94:	83 ec 0c             	sub    $0xc,%esp
  801f97:	68 0c 3c 80 00       	push   $0x803c0c
  801f9c:	e8 28 e6 ff ff       	call   8005c9 <cprintf>
  801fa1:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fa4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fab:	83 ec 0c             	sub    $0xc,%esp
  801fae:	68 30 3c 80 00       	push   $0x803c30
  801fb3:	e8 11 e6 ff ff       	call   8005c9 <cprintf>
  801fb8:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fbb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fbf:	a1 40 40 80 00       	mov    0x804040,%eax
  801fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc7:	eb 56                	jmp    80201f <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fcd:	74 1c                	je     801feb <print_mem_block_lists+0x114>
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	8b 50 08             	mov    0x8(%eax),%edx
  801fd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd8:	8b 48 08             	mov    0x8(%eax),%ecx
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe1:	01 c8                	add    %ecx,%eax
  801fe3:	39 c2                	cmp    %eax,%edx
  801fe5:	73 04                	jae    801feb <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fe7:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 50 08             	mov    0x8(%eax),%edx
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff7:	01 c2                	add    %eax,%edx
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 40 08             	mov    0x8(%eax),%eax
  801fff:	83 ec 04             	sub    $0x4,%esp
  802002:	52                   	push   %edx
  802003:	50                   	push   %eax
  802004:	68 fd 3b 80 00       	push   $0x803bfd
  802009:	e8 bb e5 ff ff       	call   8005c9 <cprintf>
  80200e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802017:	a1 48 40 80 00       	mov    0x804048,%eax
  80201c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802023:	74 07                	je     80202c <print_mem_block_lists+0x155>
  802025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802028:	8b 00                	mov    (%eax),%eax
  80202a:	eb 05                	jmp    802031 <print_mem_block_lists+0x15a>
  80202c:	b8 00 00 00 00       	mov    $0x0,%eax
  802031:	a3 48 40 80 00       	mov    %eax,0x804048
  802036:	a1 48 40 80 00       	mov    0x804048,%eax
  80203b:	85 c0                	test   %eax,%eax
  80203d:	75 8a                	jne    801fc9 <print_mem_block_lists+0xf2>
  80203f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802043:	75 84                	jne    801fc9 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802045:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802049:	75 10                	jne    80205b <print_mem_block_lists+0x184>
  80204b:	83 ec 0c             	sub    $0xc,%esp
  80204e:	68 48 3c 80 00       	push   $0x803c48
  802053:	e8 71 e5 ff ff       	call   8005c9 <cprintf>
  802058:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80205b:	83 ec 0c             	sub    $0xc,%esp
  80205e:	68 bc 3b 80 00       	push   $0x803bbc
  802063:	e8 61 e5 ff ff       	call   8005c9 <cprintf>
  802068:	83 c4 10             	add    $0x10,%esp

}
  80206b:	90                   	nop
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802074:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80207b:	00 00 00 
  80207e:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802085:	00 00 00 
  802088:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80208f:	00 00 00 
			for(int i=0;i<numOfBlocks;i++)
  802092:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802099:	e9 9e 00 00 00       	jmp    80213c <initialize_MemBlocksList+0xce>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
  80209e:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a6:	c1 e2 04             	shl    $0x4,%edx
  8020a9:	01 d0                	add    %edx,%eax
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	75 14                	jne    8020c3 <initialize_MemBlocksList+0x55>
  8020af:	83 ec 04             	sub    $0x4,%esp
  8020b2:	68 70 3c 80 00       	push   $0x803c70
  8020b7:	6a 42                	push   $0x42
  8020b9:	68 93 3c 80 00       	push   $0x803c93
  8020be:	e8 52 e2 ff ff       	call   800315 <_panic>
  8020c3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020cb:	c1 e2 04             	shl    $0x4,%edx
  8020ce:	01 d0                	add    %edx,%eax
  8020d0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020d6:	89 10                	mov    %edx,(%eax)
  8020d8:	8b 00                	mov    (%eax),%eax
  8020da:	85 c0                	test   %eax,%eax
  8020dc:	74 18                	je     8020f6 <initialize_MemBlocksList+0x88>
  8020de:	a1 48 41 80 00       	mov    0x804148,%eax
  8020e3:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020e9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020ec:	c1 e1 04             	shl    $0x4,%ecx
  8020ef:	01 ca                	add    %ecx,%edx
  8020f1:	89 50 04             	mov    %edx,0x4(%eax)
  8020f4:	eb 12                	jmp    802108 <initialize_MemBlocksList+0x9a>
  8020f6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fe:	c1 e2 04             	shl    $0x4,%edx
  802101:	01 d0                	add    %edx,%eax
  802103:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802108:	a1 50 40 80 00       	mov    0x804050,%eax
  80210d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802110:	c1 e2 04             	shl    $0x4,%edx
  802113:	01 d0                	add    %edx,%eax
  802115:	a3 48 41 80 00       	mov    %eax,0x804148
  80211a:	a1 50 40 80 00       	mov    0x804050,%eax
  80211f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802122:	c1 e2 04             	shl    $0x4,%edx
  802125:	01 d0                	add    %edx,%eax
  802127:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80212e:	a1 54 41 80 00       	mov    0x804154,%eax
  802133:	40                   	inc    %eax
  802134:	a3 54 41 80 00       	mov    %eax,0x804154
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);
			for(int i=0;i<numOfBlocks;i++)
  802139:	ff 45 f4             	incl   -0xc(%ebp)
  80213c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802142:	0f 82 56 ff ff ff    	jb     80209e <initialize_MemBlocksList+0x30>
			{
				LIST_INSERT_HEAD(&AvailableMemBlocksList,&MemBlockNodes[i]);
			}
}
  802148:	90                   	nop
  802149:	c9                   	leave  
  80214a:	c3                   	ret    

0080214b <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80214b:	55                   	push   %ebp
  80214c:	89 e5                	mov    %esp,%ebp
  80214e:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  802151:	8b 45 08             	mov    0x8(%ebp),%eax
  802154:	8b 00                	mov    (%eax),%eax
  802156:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802159:	eb 19                	jmp    802174 <find_block+0x29>
	{
		if(blk->sva==va)
  80215b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215e:	8b 40 08             	mov    0x8(%eax),%eax
  802161:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802164:	75 05                	jne    80216b <find_block+0x20>
			return (blk);
  802166:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802169:	eb 36                	jmp    8021a1 <find_block+0x56>
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock* blk ;
	LIST_FOREACH(blk,blockList)
  80216b:	8b 45 08             	mov    0x8(%ebp),%eax
  80216e:	8b 40 08             	mov    0x8(%eax),%eax
  802171:	89 45 fc             	mov    %eax,-0x4(%ebp)
  802174:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802178:	74 07                	je     802181 <find_block+0x36>
  80217a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217d:	8b 00                	mov    (%eax),%eax
  80217f:	eb 05                	jmp    802186 <find_block+0x3b>
  802181:	b8 00 00 00 00       	mov    $0x0,%eax
  802186:	8b 55 08             	mov    0x8(%ebp),%edx
  802189:	89 42 08             	mov    %eax,0x8(%edx)
  80218c:	8b 45 08             	mov    0x8(%ebp),%eax
  80218f:	8b 40 08             	mov    0x8(%eax),%eax
  802192:	85 c0                	test   %eax,%eax
  802194:	75 c5                	jne    80215b <find_block+0x10>
  802196:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80219a:	75 bf                	jne    80215b <find_block+0x10>
	{
		if(blk->sva==va)
			return (blk);
	}
			return (NULL);
  80219c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021a1:	c9                   	leave  
  8021a2:	c3                   	ret    

008021a3 <insert_sorted_allocList>:

//=========================================
// [3] INSERT BLOCK IN ALLOC LIST [SORTED]:
//=========================================
void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021a3:	55                   	push   %ebp
  8021a4:	89 e5                	mov    %esp,%ebp
  8021a6:	83 ec 28             	sub    $0x28,%esp
	 uint32 size = LIST_SIZE(&AllocMemBlocksList),ze=0;
  8021a9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8021b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	 if(size ==ze)
  8021b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021bb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8021be:	75 65                	jne    802225 <insert_sorted_allocList+0x82>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8021c0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021c4:	75 14                	jne    8021da <insert_sorted_allocList+0x37>
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	68 70 3c 80 00       	push   $0x803c70
  8021ce:	6a 5c                	push   $0x5c
  8021d0:	68 93 3c 80 00       	push   $0x803c93
  8021d5:	e8 3b e1 ff ff       	call   800315 <_panic>
  8021da:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	89 10                	mov    %edx,(%eax)
  8021e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e8:	8b 00                	mov    (%eax),%eax
  8021ea:	85 c0                	test   %eax,%eax
  8021ec:	74 0d                	je     8021fb <insert_sorted_allocList+0x58>
  8021ee:	a1 40 40 80 00       	mov    0x804040,%eax
  8021f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f6:	89 50 04             	mov    %edx,0x4(%eax)
  8021f9:	eb 08                	jmp    802203 <insert_sorted_allocList+0x60>
  8021fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fe:	a3 44 40 80 00       	mov    %eax,0x804044
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	a3 40 40 80 00       	mov    %eax,0x804040
  80220b:	8b 45 08             	mov    0x8(%ebp),%eax
  80220e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802215:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80221a:	40                   	inc    %eax
  80221b:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  802220:	e9 7b 01 00 00       	jmp    8023a0 <insert_sorted_allocList+0x1fd>
	{
		 LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
	}
	else
	{
		struct MemBlock * lastElement = LIST_LAST(&AllocMemBlocksList);
  802225:	a1 44 40 80 00       	mov    0x804044,%eax
  80222a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
  80222d:	a1 40 40 80 00       	mov    0x804040,%eax
  802232:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(blockToInsert->sva > lastElement->sva)
  802235:	8b 45 08             	mov    0x8(%ebp),%eax
  802238:	8b 50 08             	mov    0x8(%eax),%edx
  80223b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80223e:	8b 40 08             	mov    0x8(%eax),%eax
  802241:	39 c2                	cmp    %eax,%edx
  802243:	76 65                	jbe    8022aa <insert_sorted_allocList+0x107>
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
  802245:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802249:	75 14                	jne    80225f <insert_sorted_allocList+0xbc>
  80224b:	83 ec 04             	sub    $0x4,%esp
  80224e:	68 ac 3c 80 00       	push   $0x803cac
  802253:	6a 64                	push   $0x64
  802255:	68 93 3c 80 00       	push   $0x803c93
  80225a:	e8 b6 e0 ff ff       	call   800315 <_panic>
  80225f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	89 50 04             	mov    %edx,0x4(%eax)
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	8b 40 04             	mov    0x4(%eax),%eax
  802271:	85 c0                	test   %eax,%eax
  802273:	74 0c                	je     802281 <insert_sorted_allocList+0xde>
  802275:	a1 44 40 80 00       	mov    0x804044,%eax
  80227a:	8b 55 08             	mov    0x8(%ebp),%edx
  80227d:	89 10                	mov    %edx,(%eax)
  80227f:	eb 08                	jmp    802289 <insert_sorted_allocList+0xe6>
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	a3 40 40 80 00       	mov    %eax,0x804040
  802289:	8b 45 08             	mov    0x8(%ebp),%eax
  80228c:	a3 44 40 80 00       	mov    %eax,0x804044
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80229a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80229f:	40                   	inc    %eax
  8022a0:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  8022a5:	e9 f6 00 00 00       	jmp    8023a0 <insert_sorted_allocList+0x1fd>
		struct MemBlock * Firstelement =LIST_FIRST(&AllocMemBlocksList);
		if(blockToInsert->sva > lastElement->sva)
		{
			LIST_INSERT_TAIL(&AllocMemBlocksList , blockToInsert);
		}
		else if(blockToInsert->sva <Firstelement->sva)
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	8b 50 08             	mov    0x8(%eax),%edx
  8022b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022b3:	8b 40 08             	mov    0x8(%eax),%eax
  8022b6:	39 c2                	cmp    %eax,%edx
  8022b8:	73 65                	jae    80231f <insert_sorted_allocList+0x17c>
		{
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
  8022ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022be:	75 14                	jne    8022d4 <insert_sorted_allocList+0x131>
  8022c0:	83 ec 04             	sub    $0x4,%esp
  8022c3:	68 70 3c 80 00       	push   $0x803c70
  8022c8:	6a 68                	push   $0x68
  8022ca:	68 93 3c 80 00       	push   $0x803c93
  8022cf:	e8 41 e0 ff ff       	call   800315 <_panic>
  8022d4:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	89 10                	mov    %edx,(%eax)
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8b 00                	mov    (%eax),%eax
  8022e4:	85 c0                	test   %eax,%eax
  8022e6:	74 0d                	je     8022f5 <insert_sorted_allocList+0x152>
  8022e8:	a1 40 40 80 00       	mov    0x804040,%eax
  8022ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f0:	89 50 04             	mov    %edx,0x4(%eax)
  8022f3:	eb 08                	jmp    8022fd <insert_sorted_allocList+0x15a>
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	a3 44 40 80 00       	mov    %eax,0x804044
  8022fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802300:	a3 40 40 80 00       	mov    %eax,0x804040
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802314:	40                   	inc    %eax
  802315:	a3 4c 40 80 00       	mov    %eax,0x80404c
				}
			}
		 }

	}
}
  80231a:	e9 81 00 00 00       	jmp    8023a0 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  80231f:	a1 40 40 80 00       	mov    0x804040,%eax
  802324:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802327:	eb 51                	jmp    80237a <insert_sorted_allocList+0x1d7>
			{
				if(blockToInsert->sva<blk->sva)
  802329:	8b 45 08             	mov    0x8(%ebp),%eax
  80232c:	8b 50 08             	mov    0x8(%eax),%edx
  80232f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802332:	8b 40 08             	mov    0x8(%eax),%eax
  802335:	39 c2                	cmp    %eax,%edx
  802337:	73 39                	jae    802372 <insert_sorted_allocList+0x1cf>
				{
					struct MemBlock *before= blk->prev_next_info.le_prev;
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	8b 40 04             	mov    0x4(%eax),%eax
  80233f:	89 45 e0             	mov    %eax,-0x20(%ebp)
					before->prev_next_info.le_next=blockToInsert;
  802342:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802345:	8b 55 08             	mov    0x8(%ebp),%edx
  802348:	89 10                	mov    %edx,(%eax)
					blockToInsert->prev_next_info.le_prev=before;
  80234a:	8b 45 08             	mov    0x8(%ebp),%eax
  80234d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802350:	89 50 04             	mov    %edx,0x4(%eax)
					blockToInsert->prev_next_info.le_next=blk;
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802359:	89 10                	mov    %edx,(%eax)
					blk->prev_next_info.le_prev=blockToInsert;
  80235b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235e:	8b 55 08             	mov    0x8(%ebp),%edx
  802361:	89 50 04             	mov    %edx,0x4(%eax)
					LIST_SIZE(&AllocMemBlocksList)++;
  802364:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802369:	40                   	inc    %eax
  80236a:	a3 4c 40 80 00       	mov    %eax,0x80404c
					//LIST_INSERT_BEFORE(&AllocMemBlocksList,blk,blockToInsert);
					break;
  80236f:	90                   	nop
				}
			}
		 }

	}
}
  802370:	eb 2e                	jmp    8023a0 <insert_sorted_allocList+0x1fd>
			LIST_INSERT_HEAD(&AllocMemBlocksList,blockToInsert);
		}
		else
		{
			struct MemBlock * blk;
			LIST_FOREACH(blk,&AllocMemBlocksList)
  802372:	a1 48 40 80 00       	mov    0x804048,%eax
  802377:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80237e:	74 07                	je     802387 <insert_sorted_allocList+0x1e4>
  802380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802383:	8b 00                	mov    (%eax),%eax
  802385:	eb 05                	jmp    80238c <insert_sorted_allocList+0x1e9>
  802387:	b8 00 00 00 00       	mov    $0x0,%eax
  80238c:	a3 48 40 80 00       	mov    %eax,0x804048
  802391:	a1 48 40 80 00       	mov    0x804048,%eax
  802396:	85 c0                	test   %eax,%eax
  802398:	75 8f                	jne    802329 <insert_sorted_allocList+0x186>
  80239a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80239e:	75 89                	jne    802329 <insert_sorted_allocList+0x186>
				}
			}
		 }

	}
}
  8023a0:	90                   	nop
  8023a1:	c9                   	leave  
  8023a2:	c3                   	ret    

008023a3 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023a3:	55                   	push   %ebp
  8023a4:	89 e5                	mov    %esp,%ebp
  8023a6:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  8023a9:	a1 38 41 80 00       	mov    0x804138,%eax
  8023ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023b1:	e9 76 01 00 00       	jmp    80252c <alloc_block_FF+0x189>
	{
		 if(element->size==size)
  8023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023bf:	0f 85 8a 00 00 00    	jne    80244f <alloc_block_FF+0xac>
		 {
			LIST_REMOVE(&FreeMemBlocksList,element);
  8023c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023c9:	75 17                	jne    8023e2 <alloc_block_FF+0x3f>
  8023cb:	83 ec 04             	sub    $0x4,%esp
  8023ce:	68 cf 3c 80 00       	push   $0x803ccf
  8023d3:	68 8a 00 00 00       	push   $0x8a
  8023d8:	68 93 3c 80 00       	push   $0x803c93
  8023dd:	e8 33 df ff ff       	call   800315 <_panic>
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	85 c0                	test   %eax,%eax
  8023e9:	74 10                	je     8023fb <alloc_block_FF+0x58>
  8023eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ee:	8b 00                	mov    (%eax),%eax
  8023f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023f3:	8b 52 04             	mov    0x4(%edx),%edx
  8023f6:	89 50 04             	mov    %edx,0x4(%eax)
  8023f9:	eb 0b                	jmp    802406 <alloc_block_FF+0x63>
  8023fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fe:	8b 40 04             	mov    0x4(%eax),%eax
  802401:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802406:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802409:	8b 40 04             	mov    0x4(%eax),%eax
  80240c:	85 c0                	test   %eax,%eax
  80240e:	74 0f                	je     80241f <alloc_block_FF+0x7c>
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 40 04             	mov    0x4(%eax),%eax
  802416:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802419:	8b 12                	mov    (%edx),%edx
  80241b:	89 10                	mov    %edx,(%eax)
  80241d:	eb 0a                	jmp    802429 <alloc_block_FF+0x86>
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 00                	mov    (%eax),%eax
  802424:	a3 38 41 80 00       	mov    %eax,0x804138
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802435:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243c:	a1 44 41 80 00       	mov    0x804144,%eax
  802441:	48                   	dec    %eax
  802442:	a3 44 41 80 00       	mov    %eax,0x804144
			return element;
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	e9 10 01 00 00       	jmp    80255f <alloc_block_FF+0x1bc>
		 }
		 else if(element->size>size)
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 40 0c             	mov    0xc(%eax),%eax
  802455:	3b 45 08             	cmp    0x8(%ebp),%eax
  802458:	0f 86 c6 00 00 00    	jbe    802524 <alloc_block_FF+0x181>
		 {
			 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  80245e:	a1 48 41 80 00       	mov    0x804148,%eax
  802463:	89 45 f0             	mov    %eax,-0x10(%ebp)
			 LIST_REMOVE(&AvailableMemBlocksList,element1);
  802466:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80246a:	75 17                	jne    802483 <alloc_block_FF+0xe0>
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	68 cf 3c 80 00       	push   $0x803ccf
  802474:	68 90 00 00 00       	push   $0x90
  802479:	68 93 3c 80 00       	push   $0x803c93
  80247e:	e8 92 de ff ff       	call   800315 <_panic>
  802483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802486:	8b 00                	mov    (%eax),%eax
  802488:	85 c0                	test   %eax,%eax
  80248a:	74 10                	je     80249c <alloc_block_FF+0xf9>
  80248c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802494:	8b 52 04             	mov    0x4(%edx),%edx
  802497:	89 50 04             	mov    %edx,0x4(%eax)
  80249a:	eb 0b                	jmp    8024a7 <alloc_block_FF+0x104>
  80249c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80249f:	8b 40 04             	mov    0x4(%eax),%eax
  8024a2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024aa:	8b 40 04             	mov    0x4(%eax),%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 0f                	je     8024c0 <alloc_block_FF+0x11d>
  8024b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8024ba:	8b 12                	mov    (%edx),%edx
  8024bc:	89 10                	mov    %edx,(%eax)
  8024be:	eb 0a                	jmp    8024ca <alloc_block_FF+0x127>
  8024c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024c3:	8b 00                	mov    (%eax),%eax
  8024c5:	a3 48 41 80 00       	mov    %eax,0x804148
  8024ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024dd:	a1 54 41 80 00       	mov    0x804154,%eax
  8024e2:	48                   	dec    %eax
  8024e3:	a3 54 41 80 00       	mov    %eax,0x804154
			 element1->size =size;
  8024e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8024ee:	89 50 0c             	mov    %edx,0xc(%eax)
			 element1->sva=element->sva;
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 50 08             	mov    0x8(%eax),%edx
  8024f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024fa:	89 50 08             	mov    %edx,0x8(%eax)
			 element->sva=size+element->sva;
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 50 08             	mov    0x8(%eax),%edx
  802503:	8b 45 08             	mov    0x8(%ebp),%eax
  802506:	01 c2                	add    %eax,%edx
  802508:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250b:	89 50 08             	mov    %edx,0x8(%eax)
			 element->size=element->size-size;
  80250e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802511:	8b 40 0c             	mov    0xc(%eax),%eax
  802514:	2b 45 08             	sub    0x8(%ebp),%eax
  802517:	89 c2                	mov    %eax,%edx
  802519:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251c:	89 50 0c             	mov    %edx,0xc(%eax)
			 return element1;
  80251f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802522:	eb 3b                	jmp    80255f <alloc_block_FF+0x1bc>
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
	struct MemBlock *element;
	LIST_FOREACH(element, (&FreeMemBlocksList))
  802524:	a1 40 41 80 00       	mov    0x804140,%eax
  802529:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80252c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802530:	74 07                	je     802539 <alloc_block_FF+0x196>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	eb 05                	jmp    80253e <alloc_block_FF+0x19b>
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	a3 40 41 80 00       	mov    %eax,0x804140
  802543:	a1 40 41 80 00       	mov    0x804140,%eax
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 85 66 fe ff ff    	jne    8023b6 <alloc_block_FF+0x13>
  802550:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802554:	0f 85 5c fe ff ff    	jne    8023b6 <alloc_block_FF+0x13>
			 element->size=element->size-size;
			 return element1;
		 }
	}

	return NULL;
  80255a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
  802567:	c7 45 f0 00 ca 9a 3b 	movl   $0x3b9aca00,-0x10(%ebp)
  80256e:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
  802575:	c7 45 e8 ff ff ff ff 	movl   $0xffffffff,-0x18(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80257c:	a1 38 41 80 00       	mov    0x804138,%eax
  802581:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802584:	e9 cf 00 00 00       	jmp    802658 <alloc_block_BF+0xf7>
		{
			c++;
  802589:	ff 45 ec             	incl   -0x14(%ebp)
			 if(block->size==size)
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 40 0c             	mov    0xc(%eax),%eax
  802592:	3b 45 08             	cmp    0x8(%ebp),%eax
  802595:	0f 85 8a 00 00 00    	jne    802625 <alloc_block_BF+0xc4>
			{
				LIST_REMOVE((&FreeMemBlocksList),block);
  80259b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259f:	75 17                	jne    8025b8 <alloc_block_BF+0x57>
  8025a1:	83 ec 04             	sub    $0x4,%esp
  8025a4:	68 cf 3c 80 00       	push   $0x803ccf
  8025a9:	68 a8 00 00 00       	push   $0xa8
  8025ae:	68 93 3c 80 00       	push   $0x803c93
  8025b3:	e8 5d dd ff ff       	call   800315 <_panic>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 10                	je     8025d1 <alloc_block_BF+0x70>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 00                	mov    (%eax),%eax
  8025c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025c9:	8b 52 04             	mov    0x4(%edx),%edx
  8025cc:	89 50 04             	mov    %edx,0x4(%eax)
  8025cf:	eb 0b                	jmp    8025dc <alloc_block_BF+0x7b>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 40 04             	mov    0x4(%eax),%eax
  8025d7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 40 04             	mov    0x4(%eax),%eax
  8025e2:	85 c0                	test   %eax,%eax
  8025e4:	74 0f                	je     8025f5 <alloc_block_BF+0x94>
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ef:	8b 12                	mov    (%edx),%edx
  8025f1:	89 10                	mov    %edx,(%eax)
  8025f3:	eb 0a                	jmp    8025ff <alloc_block_BF+0x9e>
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	8b 00                	mov    (%eax),%eax
  8025fa:	a3 38 41 80 00       	mov    %eax,0x804138
  8025ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802612:	a1 44 41 80 00       	mov    0x804144,%eax
  802617:	48                   	dec    %eax
  802618:	a3 44 41 80 00       	mov    %eax,0x804144
				return block;
  80261d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802620:	e9 85 01 00 00       	jmp    8027aa <alloc_block_BF+0x249>
			}
			else if(block->size>size)
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 40 0c             	mov    0xc(%eax),%eax
  80262b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80262e:	76 20                	jbe    802650 <alloc_block_BF+0xef>
			{
				tempi=(block->size)-size;
  802630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802633:	8b 40 0c             	mov    0xc(%eax),%eax
  802636:	2b 45 08             	sub    0x8(%ebp),%eax
  802639:	89 45 dc             	mov    %eax,-0x24(%ebp)
				if(tempi<ma)
  80263c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80263f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802642:	73 0c                	jae    802650 <alloc_block_BF+0xef>
				{
					ma=tempi;
  802644:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802647:	89 45 f0             	mov    %eax,-0x10(%ebp)
					sol=c;
  80264a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80264d:	89 45 e8             	mov    %eax,-0x18(%ebp)
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
	struct MemBlock*block;
		uint32 ma=1e9,c=-1,sol=-1,tempi;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  802650:	a1 40 41 80 00       	mov    0x804140,%eax
  802655:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802658:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80265c:	74 07                	je     802665 <alloc_block_BF+0x104>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 00                	mov    (%eax),%eax
  802663:	eb 05                	jmp    80266a <alloc_block_BF+0x109>
  802665:	b8 00 00 00 00       	mov    $0x0,%eax
  80266a:	a3 40 41 80 00       	mov    %eax,0x804140
  80266f:	a1 40 41 80 00       	mov    0x804140,%eax
  802674:	85 c0                	test   %eax,%eax
  802676:	0f 85 0d ff ff ff    	jne    802589 <alloc_block_BF+0x28>
  80267c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802680:	0f 85 03 ff ff ff    	jne    802589 <alloc_block_BF+0x28>
					ma=tempi;
					sol=c;
				}
			}
		}
		uint32 x=0;
  802686:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80268d:	a1 38 41 80 00       	mov    0x804138,%eax
  802692:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802695:	e9 dd 00 00 00       	jmp    802777 <alloc_block_BF+0x216>
		{
			if(x==sol)
  80269a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80269d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  8026a0:	0f 85 c6 00 00 00    	jne    80276c <alloc_block_BF+0x20b>
			{
				struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8026a6:	a1 48 41 80 00       	mov    0x804148,%eax
  8026ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
						 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8026ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8026b2:	75 17                	jne    8026cb <alloc_block_BF+0x16a>
  8026b4:	83 ec 04             	sub    $0x4,%esp
  8026b7:	68 cf 3c 80 00       	push   $0x803ccf
  8026bc:	68 bb 00 00 00       	push   $0xbb
  8026c1:	68 93 3c 80 00       	push   $0x803c93
  8026c6:	e8 4a dc ff ff       	call   800315 <_panic>
  8026cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ce:	8b 00                	mov    (%eax),%eax
  8026d0:	85 c0                	test   %eax,%eax
  8026d2:	74 10                	je     8026e4 <alloc_block_BF+0x183>
  8026d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d7:	8b 00                	mov    (%eax),%eax
  8026d9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026dc:	8b 52 04             	mov    0x4(%edx),%edx
  8026df:	89 50 04             	mov    %edx,0x4(%eax)
  8026e2:	eb 0b                	jmp    8026ef <alloc_block_BF+0x18e>
  8026e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ea:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f2:	8b 40 04             	mov    0x4(%eax),%eax
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	74 0f                	je     802708 <alloc_block_BF+0x1a7>
  8026f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fc:	8b 40 04             	mov    0x4(%eax),%eax
  8026ff:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802702:	8b 12                	mov    (%edx),%edx
  802704:	89 10                	mov    %edx,(%eax)
  802706:	eb 0a                	jmp    802712 <alloc_block_BF+0x1b1>
  802708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270b:	8b 00                	mov    (%eax),%eax
  80270d:	a3 48 41 80 00       	mov    %eax,0x804148
  802712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802715:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80271b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802725:	a1 54 41 80 00       	mov    0x804154,%eax
  80272a:	48                   	dec    %eax
  80272b:	a3 54 41 80 00       	mov    %eax,0x804154
						 element1->size =size;
  802730:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802733:	8b 55 08             	mov    0x8(%ebp),%edx
  802736:	89 50 0c             	mov    %edx,0xc(%eax)
						 element1->sva=block->sva;
  802739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273c:	8b 50 08             	mov    0x8(%eax),%edx
  80273f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802742:	89 50 08             	mov    %edx,0x8(%eax)
						 block->sva=size+block->sva;
  802745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802748:	8b 50 08             	mov    0x8(%eax),%edx
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	01 c2                	add    %eax,%edx
  802750:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802753:	89 50 08             	mov    %edx,0x8(%eax)
						 block->size=block->size-size;
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 40 0c             	mov    0xc(%eax),%eax
  80275c:	2b 45 08             	sub    0x8(%ebp),%eax
  80275f:	89 c2                	mov    %eax,%edx
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	89 50 0c             	mov    %edx,0xc(%eax)
						 return element1;
  802767:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80276a:	eb 3e                	jmp    8027aa <alloc_block_BF+0x249>
						 break;
			}
			x++;
  80276c:	ff 45 e4             	incl   -0x1c(%ebp)
					sol=c;
				}
			}
		}
		uint32 x=0;
		LIST_FOREACH (block, (&FreeMemBlocksList))
  80276f:	a1 40 41 80 00       	mov    0x804140,%eax
  802774:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802777:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80277b:	74 07                	je     802784 <alloc_block_BF+0x223>
  80277d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802780:	8b 00                	mov    (%eax),%eax
  802782:	eb 05                	jmp    802789 <alloc_block_BF+0x228>
  802784:	b8 00 00 00 00       	mov    $0x0,%eax
  802789:	a3 40 41 80 00       	mov    %eax,0x804140
  80278e:	a1 40 41 80 00       	mov    0x804140,%eax
  802793:	85 c0                	test   %eax,%eax
  802795:	0f 85 ff fe ff ff    	jne    80269a <alloc_block_BF+0x139>
  80279b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279f:	0f 85 f5 fe ff ff    	jne    80269a <alloc_block_BF+0x139>
						 return element1;
						 break;
			}
			x++;
		}
			return NULL;
  8027a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027aa:	c9                   	leave  
  8027ab:	c3                   	ret    

008027ac <alloc_block_NF>:
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *temp;
bool hh=0;
struct MemBlock *alloc_block_NF(uint32 size)
{
  8027ac:	55                   	push   %ebp
  8027ad:	89 e5                	mov    %esp,%ebp
  8027af:	83 ec 18             	sub    $0x18,%esp
	if(hh==0)
  8027b2:	a1 28 40 80 00       	mov    0x804028,%eax
  8027b7:	85 c0                	test   %eax,%eax
  8027b9:	75 14                	jne    8027cf <alloc_block_NF+0x23>
	{
		temp= LIST_FIRST(&FreeMemBlocksList);
  8027bb:	a1 38 41 80 00       	mov    0x804138,%eax
  8027c0:	a3 60 41 80 00       	mov    %eax,0x804160
		hh=1;
  8027c5:	c7 05 28 40 80 00 01 	movl   $0x1,0x804028
  8027cc:	00 00 00 
	}
	uint32 c=1;
  8027cf:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	struct MemBlock *element=temp;
  8027d6:	a1 60 41 80 00       	mov    0x804160,%eax
  8027db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  8027de:	e9 b3 01 00 00       	jmp    802996 <alloc_block_NF+0x1ea>
	{
		 if(element->size==size)
  8027e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ec:	0f 85 a9 00 00 00    	jne    80289b <alloc_block_NF+0xef>
			 {
			 	if(element->prev_next_info.le_next==NULL)
  8027f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027f5:	8b 00                	mov    (%eax),%eax
  8027f7:	85 c0                	test   %eax,%eax
  8027f9:	75 0c                	jne    802807 <alloc_block_NF+0x5b>
			 	{
			 		temp= LIST_FIRST(&FreeMemBlocksList);
  8027fb:	a1 38 41 80 00       	mov    0x804138,%eax
  802800:	a3 60 41 80 00       	mov    %eax,0x804160
  802805:	eb 0a                	jmp    802811 <alloc_block_NF+0x65>
			 	}
			 	else
			 		{
			 		temp= element->prev_next_info.le_next;
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	a3 60 41 80 00       	mov    %eax,0x804160
			 		}
				 LIST_REMOVE(&FreeMemBlocksList,element);
  802811:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802815:	75 17                	jne    80282e <alloc_block_NF+0x82>
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	68 cf 3c 80 00       	push   $0x803ccf
  80281f:	68 e3 00 00 00       	push   $0xe3
  802824:	68 93 3c 80 00       	push   $0x803c93
  802829:	e8 e7 da ff ff       	call   800315 <_panic>
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 10                	je     802847 <alloc_block_NF+0x9b>
  802837:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283f:	8b 52 04             	mov    0x4(%edx),%edx
  802842:	89 50 04             	mov    %edx,0x4(%eax)
  802845:	eb 0b                	jmp    802852 <alloc_block_NF+0xa6>
  802847:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284a:	8b 40 04             	mov    0x4(%eax),%eax
  80284d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	74 0f                	je     80286b <alloc_block_NF+0xbf>
  80285c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802865:	8b 12                	mov    (%edx),%edx
  802867:	89 10                	mov    %edx,(%eax)
  802869:	eb 0a                	jmp    802875 <alloc_block_NF+0xc9>
  80286b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	a3 38 41 80 00       	mov    %eax,0x804138
  802875:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802878:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802888:	a1 44 41 80 00       	mov    0x804144,%eax
  80288d:	48                   	dec    %eax
  80288e:	a3 44 41 80 00       	mov    %eax,0x804144
				return element;
  802893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802896:	e9 0e 01 00 00       	jmp    8029a9 <alloc_block_NF+0x1fd>
			 }
			 else if(element->size>size)
  80289b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80289e:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a4:	0f 86 ce 00 00 00    	jbe    802978 <alloc_block_NF+0x1cc>
			 {
				 struct MemBlock *element1= LIST_FIRST(&AvailableMemBlocksList);
  8028aa:	a1 48 41 80 00       	mov    0x804148,%eax
  8028af:	89 45 ec             	mov    %eax,-0x14(%ebp)
				 LIST_REMOVE(&AvailableMemBlocksList,element1);
  8028b2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028b6:	75 17                	jne    8028cf <alloc_block_NF+0x123>
  8028b8:	83 ec 04             	sub    $0x4,%esp
  8028bb:	68 cf 3c 80 00       	push   $0x803ccf
  8028c0:	68 e9 00 00 00       	push   $0xe9
  8028c5:	68 93 3c 80 00       	push   $0x803c93
  8028ca:	e8 46 da ff ff       	call   800315 <_panic>
  8028cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	74 10                	je     8028e8 <alloc_block_NF+0x13c>
  8028d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028db:	8b 00                	mov    (%eax),%eax
  8028dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028e0:	8b 52 04             	mov    0x4(%edx),%edx
  8028e3:	89 50 04             	mov    %edx,0x4(%eax)
  8028e6:	eb 0b                	jmp    8028f3 <alloc_block_NF+0x147>
  8028e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028eb:	8b 40 04             	mov    0x4(%eax),%eax
  8028ee:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8028f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f6:	8b 40 04             	mov    0x4(%eax),%eax
  8028f9:	85 c0                	test   %eax,%eax
  8028fb:	74 0f                	je     80290c <alloc_block_NF+0x160>
  8028fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802900:	8b 40 04             	mov    0x4(%eax),%eax
  802903:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802906:	8b 12                	mov    (%edx),%edx
  802908:	89 10                	mov    %edx,(%eax)
  80290a:	eb 0a                	jmp    802916 <alloc_block_NF+0x16a>
  80290c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290f:	8b 00                	mov    (%eax),%eax
  802911:	a3 48 41 80 00       	mov    %eax,0x804148
  802916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802919:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802922:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802929:	a1 54 41 80 00       	mov    0x804154,%eax
  80292e:	48                   	dec    %eax
  80292f:	a3 54 41 80 00       	mov    %eax,0x804154
				 element1->size =size;
  802934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802937:	8b 55 08             	mov    0x8(%ebp),%edx
  80293a:	89 50 0c             	mov    %edx,0xc(%eax)
				 element1->sva=element->sva;
  80293d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802940:	8b 50 08             	mov    0x8(%eax),%edx
  802943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802946:	89 50 08             	mov    %edx,0x8(%eax)
				 element->sva=size+element->sva;
  802949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80294c:	8b 50 08             	mov    0x8(%eax),%edx
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	01 c2                	add    %eax,%edx
  802954:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802957:	89 50 08             	mov    %edx,0x8(%eax)
				 element->size=element->size-size;
  80295a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295d:	8b 40 0c             	mov    0xc(%eax),%eax
  802960:	2b 45 08             	sub    0x8(%ebp),%eax
  802963:	89 c2                	mov    %eax,%edx
  802965:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802968:	89 50 0c             	mov    %edx,0xc(%eax)
				 temp=element;
  80296b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80296e:	a3 60 41 80 00       	mov    %eax,0x804160
				 return element1;
  802973:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802976:	eb 31                	jmp    8029a9 <alloc_block_NF+0x1fd>
			 }
		 c++;
  802978:	ff 45 f4             	incl   -0xc(%ebp)
		 if(element->prev_next_info.le_next==NULL)
  80297b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80297e:	8b 00                	mov    (%eax),%eax
  802980:	85 c0                	test   %eax,%eax
  802982:	75 0a                	jne    80298e <alloc_block_NF+0x1e2>
		 {
		  element= LIST_FIRST(&FreeMemBlocksList);
  802984:	a1 38 41 80 00       	mov    0x804138,%eax
  802989:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80298c:	eb 08                	jmp    802996 <alloc_block_NF+0x1ea>
		 }
		 else
		 {
			 element= element->prev_next_info.le_next;
  80298e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802991:	8b 00                	mov    (%eax),%eax
  802993:	89 45 f0             	mov    %eax,-0x10(%ebp)
		temp= LIST_FIRST(&FreeMemBlocksList);
		hh=1;
	}
	uint32 c=1;
	struct MemBlock *element=temp;
	while(c!=LIST_SIZE(&FreeMemBlocksList))
  802996:	a1 44 41 80 00       	mov    0x804144,%eax
  80299b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80299e:	0f 85 3f fe ff ff    	jne    8027e3 <alloc_block_NF+0x37>
		 else
		 {
			 element= element->prev_next_info.le_next;
		 }
	}
	return NULL;
  8029a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029a9:	c9                   	leave  
  8029aa:	c3                   	ret    

008029ab <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8029ab:	55                   	push   %ebp
  8029ac:	89 e5                	mov    %esp,%ebp
  8029ae:	83 ec 28             	sub    $0x28,%esp
	// Write your code here, remove the panic and write your code
	//panic("insert_sorted_with_merge_freeList() is not implemented yet...!!");
	//int size=;
	//int size_v=LIST_SIZE(&(AvailableMemBlocksList));

	if(LIST_SIZE(&FreeMemBlocksList)==0)
  8029b1:	a1 44 41 80 00       	mov    0x804144,%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	75 68                	jne    802a22 <insert_sorted_with_merge_freeList+0x77>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  8029ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029be:	75 17                	jne    8029d7 <insert_sorted_with_merge_freeList+0x2c>
  8029c0:	83 ec 04             	sub    $0x4,%esp
  8029c3:	68 70 3c 80 00       	push   $0x803c70
  8029c8:	68 0e 01 00 00       	push   $0x10e
  8029cd:	68 93 3c 80 00       	push   $0x803c93
  8029d2:	e8 3e d9 ff ff       	call   800315 <_panic>
  8029d7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e0:	89 10                	mov    %edx,(%eax)
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	8b 00                	mov    (%eax),%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	74 0d                	je     8029f8 <insert_sorted_with_merge_freeList+0x4d>
  8029eb:	a1 38 41 80 00       	mov    0x804138,%eax
  8029f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f3:	89 50 04             	mov    %edx,0x4(%eax)
  8029f6:	eb 08                	jmp    802a00 <insert_sorted_with_merge_freeList+0x55>
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	a3 38 41 80 00       	mov    %eax,0x804138
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a12:	a1 44 41 80 00       	mov    0x804144,%eax
  802a17:	40                   	inc    %eax
  802a18:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802a1d:	e9 8c 06 00 00       	jmp    8030ae <insert_sorted_with_merge_freeList+0x703>
			{
			LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
			}
		else
		{
			struct MemBlock * lastElement = LIST_LAST(&FreeMemBlocksList);
  802a22:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a27:	89 45 f0             	mov    %eax,-0x10(%ebp)
						struct MemBlock * Firstelement =LIST_FIRST(&FreeMemBlocksList);
  802a2a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
						if(blockToInsert->sva > lastElement->sva)
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	8b 50 08             	mov    0x8(%eax),%edx
  802a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a3b:	8b 40 08             	mov    0x8(%eax),%eax
  802a3e:	39 c2                	cmp    %eax,%edx
  802a40:	0f 86 14 01 00 00    	jbe    802b5a <insert_sorted_with_merge_freeList+0x1af>
						{
							if(lastElement->size+lastElement->sva==blockToInsert->sva)
  802a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a49:	8b 50 0c             	mov    0xc(%eax),%edx
  802a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a4f:	8b 40 08             	mov    0x8(%eax),%eax
  802a52:	01 c2                	add    %eax,%edx
  802a54:	8b 45 08             	mov    0x8(%ebp),%eax
  802a57:	8b 40 08             	mov    0x8(%eax),%eax
  802a5a:	39 c2                	cmp    %eax,%edx
  802a5c:	0f 85 90 00 00 00    	jne    802af2 <insert_sorted_with_merge_freeList+0x147>
							{
								lastElement->size+= blockToInsert->size;
  802a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a65:	8b 50 0c             	mov    0xc(%eax),%edx
  802a68:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802a6e:	01 c2                	add    %eax,%edx
  802a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a73:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802a8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a8e:	75 17                	jne    802aa7 <insert_sorted_with_merge_freeList+0xfc>
  802a90:	83 ec 04             	sub    $0x4,%esp
  802a93:	68 70 3c 80 00       	push   $0x803c70
  802a98:	68 1b 01 00 00       	push   $0x11b
  802a9d:	68 93 3c 80 00       	push   $0x803c93
  802aa2:	e8 6e d8 ff ff       	call   800315 <_panic>
  802aa7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802aad:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab0:	89 10                	mov    %edx,(%eax)
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	74 0d                	je     802ac8 <insert_sorted_with_merge_freeList+0x11d>
  802abb:	a1 48 41 80 00       	mov    0x804148,%eax
  802ac0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac3:	89 50 04             	mov    %edx,0x4(%eax)
  802ac6:	eb 08                	jmp    802ad0 <insert_sorted_with_merge_freeList+0x125>
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad3:	a3 48 41 80 00       	mov    %eax,0x804148
  802ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  802adb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ae7:	40                   	inc    %eax
  802ae8:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802aed:	e9 bc 05 00 00       	jmp    8030ae <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
  802af2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802af6:	75 17                	jne    802b0f <insert_sorted_with_merge_freeList+0x164>
  802af8:	83 ec 04             	sub    $0x4,%esp
  802afb:	68 ac 3c 80 00       	push   $0x803cac
  802b00:	68 1f 01 00 00       	push   $0x11f
  802b05:	68 93 3c 80 00       	push   $0x803c93
  802b0a:	e8 06 d8 ff ff       	call   800315 <_panic>
  802b0f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b15:	8b 45 08             	mov    0x8(%ebp),%eax
  802b18:	89 50 04             	mov    %edx,0x4(%eax)
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	8b 40 04             	mov    0x4(%eax),%eax
  802b21:	85 c0                	test   %eax,%eax
  802b23:	74 0c                	je     802b31 <insert_sorted_with_merge_freeList+0x186>
  802b25:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2d:	89 10                	mov    %edx,(%eax)
  802b2f:	eb 08                	jmp    802b39 <insert_sorted_with_merge_freeList+0x18e>
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	a3 38 41 80 00       	mov    %eax,0x804138
  802b39:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b41:	8b 45 08             	mov    0x8(%ebp),%eax
  802b44:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b4a:	a1 44 41 80 00       	mov    0x804144,%eax
  802b4f:	40                   	inc    %eax
  802b50:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802b55:	e9 54 05 00 00       	jmp    8030ae <insert_sorted_with_merge_freeList+0x703>
							else
							{
								LIST_INSERT_TAIL(&FreeMemBlocksList, blockToInsert);
							}
						}
						else if(blockToInsert->sva <Firstelement->sva)
  802b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5d:	8b 50 08             	mov    0x8(%eax),%edx
  802b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b63:	8b 40 08             	mov    0x8(%eax),%eax
  802b66:	39 c2                	cmp    %eax,%edx
  802b68:	0f 83 20 01 00 00    	jae    802c8e <insert_sorted_with_merge_freeList+0x2e3>
						{
							if(blockToInsert->size+blockToInsert->sva==Firstelement->sva)
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	8b 50 0c             	mov    0xc(%eax),%edx
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	8b 40 08             	mov    0x8(%eax),%eax
  802b7a:	01 c2                	add    %eax,%edx
  802b7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b7f:	8b 40 08             	mov    0x8(%eax),%eax
  802b82:	39 c2                	cmp    %eax,%edx
  802b84:	0f 85 9c 00 00 00    	jne    802c26 <insert_sorted_with_merge_freeList+0x27b>
							{
								Firstelement->sva=blockToInsert->sva;
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	8b 50 08             	mov    0x8(%eax),%edx
  802b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b93:	89 50 08             	mov    %edx,0x8(%eax)
								Firstelement->size+=blockToInsert->size;
  802b96:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b99:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba2:	01 c2                	add    %eax,%edx
  802ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba7:	89 50 0c             	mov    %edx,0xc(%eax)
								blockToInsert->size=0;
  802baa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
								blockToInsert->sva=0;
  802bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bc2:	75 17                	jne    802bdb <insert_sorted_with_merge_freeList+0x230>
  802bc4:	83 ec 04             	sub    $0x4,%esp
  802bc7:	68 70 3c 80 00       	push   $0x803c70
  802bcc:	68 2a 01 00 00       	push   $0x12a
  802bd1:	68 93 3c 80 00       	push   $0x803c93
  802bd6:	e8 3a d7 ff ff       	call   800315 <_panic>
  802bdb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	89 10                	mov    %edx,(%eax)
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	8b 00                	mov    (%eax),%eax
  802beb:	85 c0                	test   %eax,%eax
  802bed:	74 0d                	je     802bfc <insert_sorted_with_merge_freeList+0x251>
  802bef:	a1 48 41 80 00       	mov    0x804148,%eax
  802bf4:	8b 55 08             	mov    0x8(%ebp),%edx
  802bf7:	89 50 04             	mov    %edx,0x4(%eax)
  802bfa:	eb 08                	jmp    802c04 <insert_sorted_with_merge_freeList+0x259>
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c04:	8b 45 08             	mov    0x8(%ebp),%eax
  802c07:	a3 48 41 80 00       	mov    %eax,0x804148
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c16:	a1 54 41 80 00       	mov    0x804154,%eax
  802c1b:	40                   	inc    %eax
  802c1c:	a3 54 41 80 00       	mov    %eax,0x804154
							}

						}
		          }
		}
}
  802c21:	e9 88 04 00 00       	jmp    8030ae <insert_sorted_with_merge_freeList+0x703>
								blockToInsert->sva=0;
								LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
							}
							else
							{
								LIST_INSERT_HEAD(&FreeMemBlocksList,blockToInsert);
  802c26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c2a:	75 17                	jne    802c43 <insert_sorted_with_merge_freeList+0x298>
  802c2c:	83 ec 04             	sub    $0x4,%esp
  802c2f:	68 70 3c 80 00       	push   $0x803c70
  802c34:	68 2e 01 00 00       	push   $0x12e
  802c39:	68 93 3c 80 00       	push   $0x803c93
  802c3e:	e8 d2 d6 ff ff       	call   800315 <_panic>
  802c43:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	89 10                	mov    %edx,(%eax)
  802c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c51:	8b 00                	mov    (%eax),%eax
  802c53:	85 c0                	test   %eax,%eax
  802c55:	74 0d                	je     802c64 <insert_sorted_with_merge_freeList+0x2b9>
  802c57:	a1 38 41 80 00       	mov    0x804138,%eax
  802c5c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5f:	89 50 04             	mov    %edx,0x4(%eax)
  802c62:	eb 08                	jmp    802c6c <insert_sorted_with_merge_freeList+0x2c1>
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6f:	a3 38 41 80 00       	mov    %eax,0x804138
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7e:	a1 44 41 80 00       	mov    0x804144,%eax
  802c83:	40                   	inc    %eax
  802c84:	a3 44 41 80 00       	mov    %eax,0x804144
							}

						}
		          }
		}
}
  802c89:	e9 20 04 00 00       	jmp    8030ae <insert_sorted_with_merge_freeList+0x703>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  802c8e:	a1 38 41 80 00       	mov    0x804138,%eax
  802c93:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c96:	e9 e2 03 00 00       	jmp    80307d <insert_sorted_with_merge_freeList+0x6d2>
							{
								if(blockToInsert->sva<blk->sva)
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca4:	8b 40 08             	mov    0x8(%eax),%eax
  802ca7:	39 c2                	cmp    %eax,%edx
  802ca9:	0f 83 c6 03 00 00    	jae    803075 <insert_sorted_with_merge_freeList+0x6ca>
								{
								prev=blk->prev_next_info.le_prev;
  802caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb2:	8b 40 04             	mov    0x4(%eax),%eax
  802cb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
								/*
								 prev sva+ size = blk_ins_sva >> merge prev
								 blk_ins_sva+size= blk_sva>> merge
								 */
								uint32 wiprev= prev->sva+prev->size
  802cb8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cbb:	8b 50 08             	mov    0x8(%eax),%edx
  802cbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cc1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc4:	01 d0                	add    %edx,%eax
  802cc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
								, winew= blockToInsert->size+blockToInsert->sva;
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	8b 50 0c             	mov    0xc(%eax),%edx
  802ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd2:	8b 40 08             	mov    0x8(%eax),%eax
  802cd5:	01 d0                	add    %edx,%eax
  802cd7:	89 45 e0             	mov    %eax,-0x20(%ebp)
								if(wiprev!=blockToInsert->sva&&winew!=blk->sva)
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	8b 40 08             	mov    0x8(%eax),%eax
  802ce0:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802ce3:	74 7a                	je     802d5f <insert_sorted_with_merge_freeList+0x3b4>
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 40 08             	mov    0x8(%eax),%eax
  802ceb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802cee:	74 6f                	je     802d5f <insert_sorted_with_merge_freeList+0x3b4>
								{
									// no merge
									LIST_INSERT_BEFORE(&FreeMemBlocksList,blk,blockToInsert);
  802cf0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf4:	74 06                	je     802cfc <insert_sorted_with_merge_freeList+0x351>
  802cf6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cfa:	75 17                	jne    802d13 <insert_sorted_with_merge_freeList+0x368>
  802cfc:	83 ec 04             	sub    $0x4,%esp
  802cff:	68 f0 3c 80 00       	push   $0x803cf0
  802d04:	68 43 01 00 00       	push   $0x143
  802d09:	68 93 3c 80 00       	push   $0x803c93
  802d0e:	e8 02 d6 ff ff       	call   800315 <_panic>
  802d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d16:	8b 50 04             	mov    0x4(%eax),%edx
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	89 50 04             	mov    %edx,0x4(%eax)
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d25:	89 10                	mov    %edx,(%eax)
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	8b 40 04             	mov    0x4(%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	74 0d                	je     802d3e <insert_sorted_with_merge_freeList+0x393>
  802d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d34:	8b 40 04             	mov    0x4(%eax),%eax
  802d37:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3a:	89 10                	mov    %edx,(%eax)
  802d3c:	eb 08                	jmp    802d46 <insert_sorted_with_merge_freeList+0x39b>
  802d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d41:	a3 38 41 80 00       	mov    %eax,0x804138
  802d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d49:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4c:	89 50 04             	mov    %edx,0x4(%eax)
  802d4f:	a1 44 41 80 00       	mov    0x804144,%eax
  802d54:	40                   	inc    %eax
  802d55:	a3 44 41 80 00       	mov    %eax,0x804144
  802d5a:	e9 14 03 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev==blockToInsert->sva&&winew==blk->sva)
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	8b 40 08             	mov    0x8(%eax),%eax
  802d65:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802d68:	0f 85 a0 01 00 00    	jne    802f0e <insert_sorted_with_merge_freeList+0x563>
  802d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d71:	8b 40 08             	mov    0x8(%eax),%eax
  802d74:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802d77:	0f 85 91 01 00 00    	jne    802f0e <insert_sorted_with_merge_freeList+0x563>
								{
									// both merge
									prev->size+= (blockToInsert->size)+(blk->size);
  802d7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d80:	8b 50 0c             	mov    0xc(%eax),%edx
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 48 0c             	mov    0xc(%eax),%ecx
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8f:	01 c8                	add    %ecx,%eax
  802d91:	01 c2                	add    %eax,%edx
  802d93:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d96:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802d99:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									blk->size=0;
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blk->sva=0;
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802dc1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc5:	75 17                	jne    802dde <insert_sorted_with_merge_freeList+0x433>
  802dc7:	83 ec 04             	sub    $0x4,%esp
  802dca:	68 70 3c 80 00       	push   $0x803c70
  802dcf:	68 4d 01 00 00       	push   $0x14d
  802dd4:	68 93 3c 80 00       	push   $0x803c93
  802dd9:	e8 37 d5 ff ff       	call   800315 <_panic>
  802dde:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	89 10                	mov    %edx,(%eax)
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 00                	mov    (%eax),%eax
  802dee:	85 c0                	test   %eax,%eax
  802df0:	74 0d                	je     802dff <insert_sorted_with_merge_freeList+0x454>
  802df2:	a1 48 41 80 00       	mov    0x804148,%eax
  802df7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfa:	89 50 04             	mov    %edx,0x4(%eax)
  802dfd:	eb 08                	jmp    802e07 <insert_sorted_with_merge_freeList+0x45c>
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	a3 48 41 80 00       	mov    %eax,0x804148
  802e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e12:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e19:	a1 54 41 80 00       	mov    0x804154,%eax
  802e1e:	40                   	inc    %eax
  802e1f:	a3 54 41 80 00       	mov    %eax,0x804154
									LIST_REMOVE(&FreeMemBlocksList,blk);
  802e24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e28:	75 17                	jne    802e41 <insert_sorted_with_merge_freeList+0x496>
  802e2a:	83 ec 04             	sub    $0x4,%esp
  802e2d:	68 cf 3c 80 00       	push   $0x803ccf
  802e32:	68 4e 01 00 00       	push   $0x14e
  802e37:	68 93 3c 80 00       	push   $0x803c93
  802e3c:	e8 d4 d4 ff ff       	call   800315 <_panic>
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	8b 00                	mov    (%eax),%eax
  802e46:	85 c0                	test   %eax,%eax
  802e48:	74 10                	je     802e5a <insert_sorted_with_merge_freeList+0x4af>
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e52:	8b 52 04             	mov    0x4(%edx),%edx
  802e55:	89 50 04             	mov    %edx,0x4(%eax)
  802e58:	eb 0b                	jmp    802e65 <insert_sorted_with_merge_freeList+0x4ba>
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 40 04             	mov    0x4(%eax),%eax
  802e60:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	8b 40 04             	mov    0x4(%eax),%eax
  802e6b:	85 c0                	test   %eax,%eax
  802e6d:	74 0f                	je     802e7e <insert_sorted_with_merge_freeList+0x4d3>
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e78:	8b 12                	mov    (%edx),%edx
  802e7a:	89 10                	mov    %edx,(%eax)
  802e7c:	eb 0a                	jmp    802e88 <insert_sorted_with_merge_freeList+0x4dd>
  802e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e81:	8b 00                	mov    (%eax),%eax
  802e83:	a3 38 41 80 00       	mov    %eax,0x804138
  802e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e9b:	a1 44 41 80 00       	mov    0x804144,%eax
  802ea0:	48                   	dec    %eax
  802ea1:	a3 44 41 80 00       	mov    %eax,0x804144
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blk);
  802ea6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eaa:	75 17                	jne    802ec3 <insert_sorted_with_merge_freeList+0x518>
  802eac:	83 ec 04             	sub    $0x4,%esp
  802eaf:	68 70 3c 80 00       	push   $0x803c70
  802eb4:	68 4f 01 00 00       	push   $0x14f
  802eb9:	68 93 3c 80 00       	push   $0x803c93
  802ebe:	e8 52 d4 ff ff       	call   800315 <_panic>
  802ec3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	89 10                	mov    %edx,(%eax)
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 00                	mov    (%eax),%eax
  802ed3:	85 c0                	test   %eax,%eax
  802ed5:	74 0d                	je     802ee4 <insert_sorted_with_merge_freeList+0x539>
  802ed7:	a1 48 41 80 00       	mov    0x804148,%eax
  802edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802edf:	89 50 04             	mov    %edx,0x4(%eax)
  802ee2:	eb 08                	jmp    802eec <insert_sorted_with_merge_freeList+0x541>
  802ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eef:	a3 48 41 80 00       	mov    %eax,0x804148
  802ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efe:	a1 54 41 80 00       	mov    0x804154,%eax
  802f03:	40                   	inc    %eax
  802f04:	a3 54 41 80 00       	mov    %eax,0x804154
  802f09:	e9 65 01 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x6c8>

								}
								else if(wiprev==blockToInsert->sva&&winew!=blk->sva)
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	8b 40 08             	mov    0x8(%eax),%eax
  802f14:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802f17:	0f 85 9f 00 00 00    	jne    802fbc <insert_sorted_with_merge_freeList+0x611>
  802f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f20:	8b 40 08             	mov    0x8(%eax),%eax
  802f23:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802f26:	0f 84 90 00 00 00    	je     802fbc <insert_sorted_with_merge_freeList+0x611>
								{
									// prev only
									prev->size+=blockToInsert->size;
  802f2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f2f:	8b 50 0c             	mov    0xc(%eax),%edx
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	8b 40 0c             	mov    0xc(%eax),%eax
  802f38:	01 c2                	add    %eax,%edx
  802f3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f3d:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802f40:	8b 45 08             	mov    0x8(%ebp),%eax
  802f43:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  802f54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f58:	75 17                	jne    802f71 <insert_sorted_with_merge_freeList+0x5c6>
  802f5a:	83 ec 04             	sub    $0x4,%esp
  802f5d:	68 70 3c 80 00       	push   $0x803c70
  802f62:	68 58 01 00 00       	push   $0x158
  802f67:	68 93 3c 80 00       	push   $0x803c93
  802f6c:	e8 a4 d3 ff ff       	call   800315 <_panic>
  802f71:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	89 10                	mov    %edx,(%eax)
  802f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7f:	8b 00                	mov    (%eax),%eax
  802f81:	85 c0                	test   %eax,%eax
  802f83:	74 0d                	je     802f92 <insert_sorted_with_merge_freeList+0x5e7>
  802f85:	a1 48 41 80 00       	mov    0x804148,%eax
  802f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8d:	89 50 04             	mov    %edx,0x4(%eax)
  802f90:	eb 08                	jmp    802f9a <insert_sorted_with_merge_freeList+0x5ef>
  802f92:	8b 45 08             	mov    0x8(%ebp),%eax
  802f95:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9d:	a3 48 41 80 00       	mov    %eax,0x804148
  802fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fac:	a1 54 41 80 00       	mov    0x804154,%eax
  802fb1:	40                   	inc    %eax
  802fb2:	a3 54 41 80 00       	mov    %eax,0x804154
  802fb7:	e9 b7 00 00 00       	jmp    803073 <insert_sorted_with_merge_freeList+0x6c8>
								}
								else if(wiprev!=blockToInsert->sva&&winew==blk->sva)
  802fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbf:	8b 40 08             	mov    0x8(%eax),%eax
  802fc2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  802fc5:	0f 84 e2 00 00 00    	je     8030ad <insert_sorted_with_merge_freeList+0x702>
  802fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fce:	8b 40 08             	mov    0x8(%eax),%eax
  802fd1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  802fd4:	0f 85 d3 00 00 00    	jne    8030ad <insert_sorted_with_merge_freeList+0x702>
								{
									// merge with next
									blk->sva= blockToInsert->sva;
  802fda:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdd:	8b 50 08             	mov    0x8(%eax),%edx
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	89 50 08             	mov    %edx,0x8(%eax)
									blk->size+= blockToInsert->size;
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 50 0c             	mov    0xc(%eax),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	8b 40 0c             	mov    0xc(%eax),%eax
  802ff2:	01 c2                	add    %eax,%edx
  802ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ff7:	89 50 0c             	mov    %edx,0xc(%eax)
									blockToInsert->size=0;
  802ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
									blockToInsert->sva=0;
  803004:	8b 45 08             	mov    0x8(%ebp),%eax
  803007:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
  80300e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803012:	75 17                	jne    80302b <insert_sorted_with_merge_freeList+0x680>
  803014:	83 ec 04             	sub    $0x4,%esp
  803017:	68 70 3c 80 00       	push   $0x803c70
  80301c:	68 61 01 00 00       	push   $0x161
  803021:	68 93 3c 80 00       	push   $0x803c93
  803026:	e8 ea d2 ff ff       	call   800315 <_panic>
  80302b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803031:	8b 45 08             	mov    0x8(%ebp),%eax
  803034:	89 10                	mov    %edx,(%eax)
  803036:	8b 45 08             	mov    0x8(%ebp),%eax
  803039:	8b 00                	mov    (%eax),%eax
  80303b:	85 c0                	test   %eax,%eax
  80303d:	74 0d                	je     80304c <insert_sorted_with_merge_freeList+0x6a1>
  80303f:	a1 48 41 80 00       	mov    0x804148,%eax
  803044:	8b 55 08             	mov    0x8(%ebp),%edx
  803047:	89 50 04             	mov    %edx,0x4(%eax)
  80304a:	eb 08                	jmp    803054 <insert_sorted_with_merge_freeList+0x6a9>
  80304c:	8b 45 08             	mov    0x8(%ebp),%eax
  80304f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803054:	8b 45 08             	mov    0x8(%ebp),%eax
  803057:	a3 48 41 80 00       	mov    %eax,0x804148
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803066:	a1 54 41 80 00       	mov    0x804154,%eax
  80306b:	40                   	inc    %eax
  80306c:	a3 54 41 80 00       	mov    %eax,0x804154
								}
								break;
  803071:	eb 3a                	jmp    8030ad <insert_sorted_with_merge_freeList+0x702>
  803073:	eb 38                	jmp    8030ad <insert_sorted_with_merge_freeList+0x702>
						}
						else
						{
							struct MemBlock * blk;
							struct MemBlock *prev;
							LIST_FOREACH(blk,&FreeMemBlocksList)
  803075:	a1 40 41 80 00       	mov    0x804140,%eax
  80307a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80307d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803081:	74 07                	je     80308a <insert_sorted_with_merge_freeList+0x6df>
  803083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803086:	8b 00                	mov    (%eax),%eax
  803088:	eb 05                	jmp    80308f <insert_sorted_with_merge_freeList+0x6e4>
  80308a:	b8 00 00 00 00       	mov    $0x0,%eax
  80308f:	a3 40 41 80 00       	mov    %eax,0x804140
  803094:	a1 40 41 80 00       	mov    0x804140,%eax
  803099:	85 c0                	test   %eax,%eax
  80309b:	0f 85 fa fb ff ff    	jne    802c9b <insert_sorted_with_merge_freeList+0x2f0>
  8030a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030a5:	0f 85 f0 fb ff ff    	jne    802c9b <insert_sorted_with_merge_freeList+0x2f0>
							}

						}
		          }
		}
}
  8030ab:	eb 01                	jmp    8030ae <insert_sorted_with_merge_freeList+0x703>
									blk->size+= blockToInsert->size;
									blockToInsert->size=0;
									blockToInsert->sva=0;
									LIST_INSERT_HEAD(&AvailableMemBlocksList,blockToInsert);
								}
								break;
  8030ad:	90                   	nop
							}

						}
		          }
		}
}
  8030ae:	90                   	nop
  8030af:	c9                   	leave  
  8030b0:	c3                   	ret    
  8030b1:	66 90                	xchg   %ax,%ax
  8030b3:	90                   	nop

008030b4 <__udivdi3>:
  8030b4:	55                   	push   %ebp
  8030b5:	57                   	push   %edi
  8030b6:	56                   	push   %esi
  8030b7:	53                   	push   %ebx
  8030b8:	83 ec 1c             	sub    $0x1c,%esp
  8030bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030c7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030cb:	89 ca                	mov    %ecx,%edx
  8030cd:	89 f8                	mov    %edi,%eax
  8030cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030d3:	85 f6                	test   %esi,%esi
  8030d5:	75 2d                	jne    803104 <__udivdi3+0x50>
  8030d7:	39 cf                	cmp    %ecx,%edi
  8030d9:	77 65                	ja     803140 <__udivdi3+0x8c>
  8030db:	89 fd                	mov    %edi,%ebp
  8030dd:	85 ff                	test   %edi,%edi
  8030df:	75 0b                	jne    8030ec <__udivdi3+0x38>
  8030e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8030e6:	31 d2                	xor    %edx,%edx
  8030e8:	f7 f7                	div    %edi
  8030ea:	89 c5                	mov    %eax,%ebp
  8030ec:	31 d2                	xor    %edx,%edx
  8030ee:	89 c8                	mov    %ecx,%eax
  8030f0:	f7 f5                	div    %ebp
  8030f2:	89 c1                	mov    %eax,%ecx
  8030f4:	89 d8                	mov    %ebx,%eax
  8030f6:	f7 f5                	div    %ebp
  8030f8:	89 cf                	mov    %ecx,%edi
  8030fa:	89 fa                	mov    %edi,%edx
  8030fc:	83 c4 1c             	add    $0x1c,%esp
  8030ff:	5b                   	pop    %ebx
  803100:	5e                   	pop    %esi
  803101:	5f                   	pop    %edi
  803102:	5d                   	pop    %ebp
  803103:	c3                   	ret    
  803104:	39 ce                	cmp    %ecx,%esi
  803106:	77 28                	ja     803130 <__udivdi3+0x7c>
  803108:	0f bd fe             	bsr    %esi,%edi
  80310b:	83 f7 1f             	xor    $0x1f,%edi
  80310e:	75 40                	jne    803150 <__udivdi3+0x9c>
  803110:	39 ce                	cmp    %ecx,%esi
  803112:	72 0a                	jb     80311e <__udivdi3+0x6a>
  803114:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803118:	0f 87 9e 00 00 00    	ja     8031bc <__udivdi3+0x108>
  80311e:	b8 01 00 00 00       	mov    $0x1,%eax
  803123:	89 fa                	mov    %edi,%edx
  803125:	83 c4 1c             	add    $0x1c,%esp
  803128:	5b                   	pop    %ebx
  803129:	5e                   	pop    %esi
  80312a:	5f                   	pop    %edi
  80312b:	5d                   	pop    %ebp
  80312c:	c3                   	ret    
  80312d:	8d 76 00             	lea    0x0(%esi),%esi
  803130:	31 ff                	xor    %edi,%edi
  803132:	31 c0                	xor    %eax,%eax
  803134:	89 fa                	mov    %edi,%edx
  803136:	83 c4 1c             	add    $0x1c,%esp
  803139:	5b                   	pop    %ebx
  80313a:	5e                   	pop    %esi
  80313b:	5f                   	pop    %edi
  80313c:	5d                   	pop    %ebp
  80313d:	c3                   	ret    
  80313e:	66 90                	xchg   %ax,%ax
  803140:	89 d8                	mov    %ebx,%eax
  803142:	f7 f7                	div    %edi
  803144:	31 ff                	xor    %edi,%edi
  803146:	89 fa                	mov    %edi,%edx
  803148:	83 c4 1c             	add    $0x1c,%esp
  80314b:	5b                   	pop    %ebx
  80314c:	5e                   	pop    %esi
  80314d:	5f                   	pop    %edi
  80314e:	5d                   	pop    %ebp
  80314f:	c3                   	ret    
  803150:	bd 20 00 00 00       	mov    $0x20,%ebp
  803155:	89 eb                	mov    %ebp,%ebx
  803157:	29 fb                	sub    %edi,%ebx
  803159:	89 f9                	mov    %edi,%ecx
  80315b:	d3 e6                	shl    %cl,%esi
  80315d:	89 c5                	mov    %eax,%ebp
  80315f:	88 d9                	mov    %bl,%cl
  803161:	d3 ed                	shr    %cl,%ebp
  803163:	89 e9                	mov    %ebp,%ecx
  803165:	09 f1                	or     %esi,%ecx
  803167:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80316b:	89 f9                	mov    %edi,%ecx
  80316d:	d3 e0                	shl    %cl,%eax
  80316f:	89 c5                	mov    %eax,%ebp
  803171:	89 d6                	mov    %edx,%esi
  803173:	88 d9                	mov    %bl,%cl
  803175:	d3 ee                	shr    %cl,%esi
  803177:	89 f9                	mov    %edi,%ecx
  803179:	d3 e2                	shl    %cl,%edx
  80317b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80317f:	88 d9                	mov    %bl,%cl
  803181:	d3 e8                	shr    %cl,%eax
  803183:	09 c2                	or     %eax,%edx
  803185:	89 d0                	mov    %edx,%eax
  803187:	89 f2                	mov    %esi,%edx
  803189:	f7 74 24 0c          	divl   0xc(%esp)
  80318d:	89 d6                	mov    %edx,%esi
  80318f:	89 c3                	mov    %eax,%ebx
  803191:	f7 e5                	mul    %ebp
  803193:	39 d6                	cmp    %edx,%esi
  803195:	72 19                	jb     8031b0 <__udivdi3+0xfc>
  803197:	74 0b                	je     8031a4 <__udivdi3+0xf0>
  803199:	89 d8                	mov    %ebx,%eax
  80319b:	31 ff                	xor    %edi,%edi
  80319d:	e9 58 ff ff ff       	jmp    8030fa <__udivdi3+0x46>
  8031a2:	66 90                	xchg   %ax,%ax
  8031a4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031a8:	89 f9                	mov    %edi,%ecx
  8031aa:	d3 e2                	shl    %cl,%edx
  8031ac:	39 c2                	cmp    %eax,%edx
  8031ae:	73 e9                	jae    803199 <__udivdi3+0xe5>
  8031b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031b3:	31 ff                	xor    %edi,%edi
  8031b5:	e9 40 ff ff ff       	jmp    8030fa <__udivdi3+0x46>
  8031ba:	66 90                	xchg   %ax,%ax
  8031bc:	31 c0                	xor    %eax,%eax
  8031be:	e9 37 ff ff ff       	jmp    8030fa <__udivdi3+0x46>
  8031c3:	90                   	nop

008031c4 <__umoddi3>:
  8031c4:	55                   	push   %ebp
  8031c5:	57                   	push   %edi
  8031c6:	56                   	push   %esi
  8031c7:	53                   	push   %ebx
  8031c8:	83 ec 1c             	sub    $0x1c,%esp
  8031cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031e3:	89 f3                	mov    %esi,%ebx
  8031e5:	89 fa                	mov    %edi,%edx
  8031e7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8031eb:	89 34 24             	mov    %esi,(%esp)
  8031ee:	85 c0                	test   %eax,%eax
  8031f0:	75 1a                	jne    80320c <__umoddi3+0x48>
  8031f2:	39 f7                	cmp    %esi,%edi
  8031f4:	0f 86 a2 00 00 00    	jbe    80329c <__umoddi3+0xd8>
  8031fa:	89 c8                	mov    %ecx,%eax
  8031fc:	89 f2                	mov    %esi,%edx
  8031fe:	f7 f7                	div    %edi
  803200:	89 d0                	mov    %edx,%eax
  803202:	31 d2                	xor    %edx,%edx
  803204:	83 c4 1c             	add    $0x1c,%esp
  803207:	5b                   	pop    %ebx
  803208:	5e                   	pop    %esi
  803209:	5f                   	pop    %edi
  80320a:	5d                   	pop    %ebp
  80320b:	c3                   	ret    
  80320c:	39 f0                	cmp    %esi,%eax
  80320e:	0f 87 ac 00 00 00    	ja     8032c0 <__umoddi3+0xfc>
  803214:	0f bd e8             	bsr    %eax,%ebp
  803217:	83 f5 1f             	xor    $0x1f,%ebp
  80321a:	0f 84 ac 00 00 00    	je     8032cc <__umoddi3+0x108>
  803220:	bf 20 00 00 00       	mov    $0x20,%edi
  803225:	29 ef                	sub    %ebp,%edi
  803227:	89 fe                	mov    %edi,%esi
  803229:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80322d:	89 e9                	mov    %ebp,%ecx
  80322f:	d3 e0                	shl    %cl,%eax
  803231:	89 d7                	mov    %edx,%edi
  803233:	89 f1                	mov    %esi,%ecx
  803235:	d3 ef                	shr    %cl,%edi
  803237:	09 c7                	or     %eax,%edi
  803239:	89 e9                	mov    %ebp,%ecx
  80323b:	d3 e2                	shl    %cl,%edx
  80323d:	89 14 24             	mov    %edx,(%esp)
  803240:	89 d8                	mov    %ebx,%eax
  803242:	d3 e0                	shl    %cl,%eax
  803244:	89 c2                	mov    %eax,%edx
  803246:	8b 44 24 08          	mov    0x8(%esp),%eax
  80324a:	d3 e0                	shl    %cl,%eax
  80324c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803250:	8b 44 24 08          	mov    0x8(%esp),%eax
  803254:	89 f1                	mov    %esi,%ecx
  803256:	d3 e8                	shr    %cl,%eax
  803258:	09 d0                	or     %edx,%eax
  80325a:	d3 eb                	shr    %cl,%ebx
  80325c:	89 da                	mov    %ebx,%edx
  80325e:	f7 f7                	div    %edi
  803260:	89 d3                	mov    %edx,%ebx
  803262:	f7 24 24             	mull   (%esp)
  803265:	89 c6                	mov    %eax,%esi
  803267:	89 d1                	mov    %edx,%ecx
  803269:	39 d3                	cmp    %edx,%ebx
  80326b:	0f 82 87 00 00 00    	jb     8032f8 <__umoddi3+0x134>
  803271:	0f 84 91 00 00 00    	je     803308 <__umoddi3+0x144>
  803277:	8b 54 24 04          	mov    0x4(%esp),%edx
  80327b:	29 f2                	sub    %esi,%edx
  80327d:	19 cb                	sbb    %ecx,%ebx
  80327f:	89 d8                	mov    %ebx,%eax
  803281:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803285:	d3 e0                	shl    %cl,%eax
  803287:	89 e9                	mov    %ebp,%ecx
  803289:	d3 ea                	shr    %cl,%edx
  80328b:	09 d0                	or     %edx,%eax
  80328d:	89 e9                	mov    %ebp,%ecx
  80328f:	d3 eb                	shr    %cl,%ebx
  803291:	89 da                	mov    %ebx,%edx
  803293:	83 c4 1c             	add    $0x1c,%esp
  803296:	5b                   	pop    %ebx
  803297:	5e                   	pop    %esi
  803298:	5f                   	pop    %edi
  803299:	5d                   	pop    %ebp
  80329a:	c3                   	ret    
  80329b:	90                   	nop
  80329c:	89 fd                	mov    %edi,%ebp
  80329e:	85 ff                	test   %edi,%edi
  8032a0:	75 0b                	jne    8032ad <__umoddi3+0xe9>
  8032a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032a7:	31 d2                	xor    %edx,%edx
  8032a9:	f7 f7                	div    %edi
  8032ab:	89 c5                	mov    %eax,%ebp
  8032ad:	89 f0                	mov    %esi,%eax
  8032af:	31 d2                	xor    %edx,%edx
  8032b1:	f7 f5                	div    %ebp
  8032b3:	89 c8                	mov    %ecx,%eax
  8032b5:	f7 f5                	div    %ebp
  8032b7:	89 d0                	mov    %edx,%eax
  8032b9:	e9 44 ff ff ff       	jmp    803202 <__umoddi3+0x3e>
  8032be:	66 90                	xchg   %ax,%ax
  8032c0:	89 c8                	mov    %ecx,%eax
  8032c2:	89 f2                	mov    %esi,%edx
  8032c4:	83 c4 1c             	add    $0x1c,%esp
  8032c7:	5b                   	pop    %ebx
  8032c8:	5e                   	pop    %esi
  8032c9:	5f                   	pop    %edi
  8032ca:	5d                   	pop    %ebp
  8032cb:	c3                   	ret    
  8032cc:	3b 04 24             	cmp    (%esp),%eax
  8032cf:	72 06                	jb     8032d7 <__umoddi3+0x113>
  8032d1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032d5:	77 0f                	ja     8032e6 <__umoddi3+0x122>
  8032d7:	89 f2                	mov    %esi,%edx
  8032d9:	29 f9                	sub    %edi,%ecx
  8032db:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032df:	89 14 24             	mov    %edx,(%esp)
  8032e2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032e6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8032ea:	8b 14 24             	mov    (%esp),%edx
  8032ed:	83 c4 1c             	add    $0x1c,%esp
  8032f0:	5b                   	pop    %ebx
  8032f1:	5e                   	pop    %esi
  8032f2:	5f                   	pop    %edi
  8032f3:	5d                   	pop    %ebp
  8032f4:	c3                   	ret    
  8032f5:	8d 76 00             	lea    0x0(%esi),%esi
  8032f8:	2b 04 24             	sub    (%esp),%eax
  8032fb:	19 fa                	sbb    %edi,%edx
  8032fd:	89 d1                	mov    %edx,%ecx
  8032ff:	89 c6                	mov    %eax,%esi
  803301:	e9 71 ff ff ff       	jmp    803277 <__umoddi3+0xb3>
  803306:	66 90                	xchg   %ax,%ax
  803308:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80330c:	72 ea                	jb     8032f8 <__umoddi3+0x134>
  80330e:	89 d9                	mov    %ebx,%ecx
  803310:	e9 62 ff ff ff       	jmp    803277 <__umoddi3+0xb3>